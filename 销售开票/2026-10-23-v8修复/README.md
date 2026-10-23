# 销售开票 · 最终版可导入包 v8（v7 两处现场失败修复 + A 方案提示行）

**现行正式交付版**，取代 `2026-10-23-服务器真值基线v7/`（v7 已导入上线，但现场实测两处失败，见下）。

- 包：`销售开票_最终版_可导入_v8.zip`（153,762 B，SHA-256 `eec98b381fd6ab2a8f00ba9897f197ba85aa495a18552e8ddfa6782c0f31ad0e`）——zip 本体待 Alan 网页上传至本文件夹。
- 基线：以 v7 包为底，**只换 `content/main.js` 与 `content/main.xul`**，其余成员与 v7 包逐字节一致；protected.js 仍为服务器现行件（md5 `2b721009…`，关限销保持关闭），未动。

## v8 改动

1. **修保存「"pf_showWaitBox"未定义」**：取证——该函数在 designer 函数清单（openFuncList）中在册，元数据与运行时可用的 pf_chkBal/pf_fieldCompute 逐列相同、登记注释亦带官方示例，调用方式无误；是本表单运行时未装载该函数（**设计器清单在册 ≠ 运行时可用**）。修法：将其真实函数体逐行移植进表单本地改名 `uf_showWaitBox`（体内仅用 document/navigator/setTimeout/alert，无其它库依赖；verify 已证与库原体逐标记一致），保存 uf_djsave/挂账 uf_djgz 两入口改调本地版。
2. **修零量弹框仍触发**：取证——弹框本体在 `pf_fieldCompute` 的 `case "num"`（仅 num==0 且 cancelNum==0 时无条件 alert，无 verifyDisabled 等任何其它门控），而 protected 的 `sys_compute` 尾部对它**无条件调用**，verifyDisabled 只门控其内部库存校验段。v6/v7 的「抑制」模型自始无效（两轮 mock 用按错误模型写的行为桩自证，是本轮立规要戒的）。修法：新增守卫 `uf_numCompute`——数量为 0 时改以 taxPrice 触发同一套金额写回（真体对照证整行写回逐项一致，差异仅弹框/pass_hjjy/抢焦点三项副作用；含税价同为 0 时直写金额族归零），main 内全部 7 处裸调用点 + 清零助手统一收口；守卫另在相同门控下补写 pf_chkBal 的 tmpNum 暂存，使校验暂存残留与旧链一致。保存校验逐字未动。
3. **A 方案提示行（Alan 拍板）**：编辑期静默清零加非模态反馈——main.xul 明细网格上方空带新增红色只读标签 `lbl_qtytip`（落点经 xul 全量坐标扫描证实无遮挡、不动布局）；编辑期两类清零（录入除不尽/改选商品）统一经集中处置 `uf_editQtyClear` 清零+重算+写提示（「第X行 数量Y 不能被每袋装量Z整除，已清零」/「第X行 更换商品，数量已清零」）；生命周期：新清零覆盖、保存成功清（uf_saveBill）、打开表单为空、清空单据确认后清（工具栏改绑 uf_billEmpty 包装）、录入合规数量不主动清。导入维持完成弹窗点名，不走提示行。

## 验证

- verify_v8 32/32：与 v7 包逐件对照（仅 main.js/main.xul 变更）、protected md5 与解码复验、移植逐标记一致、静态断言（裸 sys_compute("num") 仅剩守卫内 1 处、无 pf_showWaitBox 代码调用）、node --check、xul/props 可解析。
- mock-v8（新）63/63：harness 装入 protected 真体 sys_compute + 函数库真体 pf_fieldCompute/pf_chkBal + 随包移植体，含旧链/新链整行写回等价对照（4 组配置）、等待框出-拆配平、提示行全生命周期断言；全程零量弹框 0 次。
- 历史回归全量复跑：整除 34/34、提速+批号 23/23、重选 13/13 场景·15/15、三问题 39/39、等待框 30/30、zeroalert（已换真体）31/31。
- 残留（如实）：protected 内 sys_kslr（快速录入）finally 逐行 sys_compute("num") 与 sys_after_compute（调用方不明、疑休眠）仍可达零量弹框，本轮未动 protected，根治需 Alan 单独批准（详见报告第五节）。
- 报告：`v8修复报告.md`（本文件夹）；技术存档 -xfyproject `forms/3b158nm6d7jro17p/serverbase-v8/` 与 `docs/changes/2026-10-23-销售开票v8双修复与提示行.md`。

## 现场验证点

1. 录数量 0 → 不弹「当前商品数量为零」；录数量 2（每袋 0.9）→ 静默清 0 + 网格上方红字提示原因；录 1.8 → 保留、提示不清。
2. 改选商品 → 清零 + 提示「第X行 更换商品，数量已清零」。
3. 点保存/挂账 → 等待框+遮罩出现、毕即消失、无未定义报错；保存成功后提示清空。
4. 留一行数量 0 保存 → 被「数量必须大于0」拦下、提示保留；清空当前单据确认后提示一并清空。
5. 限销仍关闭；导入艾叶点名口径不变。
