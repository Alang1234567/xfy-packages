# 销售开票 · 最终版可导入包 v6（行校验零量弹框摘除）

**现行正式交付版**，取代 `2026-10-22-三问题修复v5/`。

- 包：`销售开票_最终版_可导入_v6.zip`（150,684 B，SHA-256 `3920c97d322cbc833f189377e54faa5e6b5a87c8d8ae7a9a56b212272ad73147`）——zip 本体待 Alan 网页上传至本文件夹（本地镜像已含）。
- 构成：以 v5 包为底换 **main.js（最终版 v6）+ main.xul** 两成员；server.js（v22）、props.json、protected.js、desc.html、locale 与 v5 包逐字节一致，protected.js 原版未动（md5 `a9aa8eb4…`）。main.xul 仅一处变化：ds_ddmx 事件里 Num.onsettext 绑定由 `uf_compute()` 改为 `uf_onNumSetText()`。关限销仍不在包内（同 v5 说明）。

## v6 改动（v5 全部功能保留）

**摘除编辑期「当前商品数量为零,注意!」弹框**（Alan 口径：行校验保留、不合规静默清 0、只要保存校验）：

- 出处取证：该文案在 main.js 全版本/portect/server/包内语言文件/CHM 手册全仓零命中，出自平台共享保护库库存校验 pf_chkBal（编辑链 Num.onsettext→uf_compute→sys_compute("num")→pf_chkBal，遇数量 0 弹框），库体改不动 → 调用侧绕开。
- main.js 新增 `uf_onNumSetText()` 作为数量格入口：手工录入先用共用整除判定（uf_qtyDivisible）判当前行，除不尽 → 静默清零数量族，随后整段行计算在 verifyDisabled 抑制下执行（数量 0 时库存校验无对象、跳过只去弹框；金额公式 pf_fieldCompute 不受开关影响照常归零）；合规数量不设抑制、库存/限销校验照常；程序化填行期间（抑制已开）纯透传，导入流程不变。
- `uf_qtyClearAndRecompute`（导入清零重算）与 `uf_reselectResetQty`（改选清零）的重算调用同样加抑制包装——这两条我方清零路径在 v4/v5 会撞同一个零量弹框，一并静默。
- 保存侧逐字未动：数量 ≤0/除不尽仍由 uf_saveCheck 拦截报错（mock 用真实函数体实证拦截文案与现行一致）；导入完成回执点名保留。

## 验证

- 新 mock（mock-zeroalert）30/30：首要场景（录入 2/每袋 0.9）在平台库两种建模变体下均成立（新版静默清 0、金额归零、弹框 0 次；旧版复现清 0+弹框）；录入 1.8 保留且库存校验以原值执行；保存三场景（0 行拦、除不尽拦、合规过数量段）全过。
- v5 回归全量不破：三问题 39/39、整除 34/34、提速+批号 23/23、重选 13/13 场景·15/15 断言（S13 断言调整登记 1 处：uf_reselectResetQty 逐字性前提被 v6 授权改动取代，规范化包装行后比对）。
- 静态改动面核查 3/3：v5→v6 diff 仅 4 区块、+45/−1 行，全落在 uf_onNumSetText（新增）、uf_qtyClearAndRecompute、uf_reselectResetQty 三处。包反向解包校验全 PASS。
- 报告：`行校验摘除报告.md`（含最终行为矩阵与残余触发面说明）；技术存档 -xfyproject `forms/3b158nm6d7jro17p/zeroalert-v6/` 与 `docs/changes/2026-10-22-销售开票行校验零量弹框摘除v6.md`。

## 现场验证点

1. 明细录数量 2（每袋 0.9 商品）→ 当场变 0、无弹框、金额 0。
2. 录 1.8 → 保留、金额正常。
3. 留一行数量 0 保存 → 被「数量必须大于0」拦下。
4. 导入艾叶那批数据 → 完成回执照常点名，过程无「数量为零」弹框。
5. 改选商品 → 清零、无弹框。
