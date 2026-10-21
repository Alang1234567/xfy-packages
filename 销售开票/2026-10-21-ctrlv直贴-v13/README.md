# 销售开票 · Ctrl+V 直贴 + 数量封顶 v13（2026-10-21）

## 附件

- 文件：`销售开票_表格导入_改后v13.zip`（140,543 字节）
- SHA-256：`beeaeeb217e5dd467de48da559e55b0c3a151f58d213a0c9fc62455fa7737d8b`
- 基线：v12（完整包含 v11/v12 全部内容），v13 为现行交付版。zip 本体按既定分工由 Alan 网页上传本文件夹。

## 内容

两处改动，都只落 main.js 的粘贴/键盘函数：

1. **导入表格内 Ctrl+V 直贴**：不再必须点按钮。挂钩复用本表单原厂统一键盘入口 `uf_onload()` 里的 `document.onkeydown = hotkey`（直退直销表单同款），在 `hotkey()` 里加 Ctrl+V 分支；作用域判定新函数 `uf_impgrid_isEvtFocus()`：取按键事件源（`window.event.srcElement`，与原厂 hotkey 读 window.event 同款；取不到退 `document.activeElement`），沿父元素上溯命中导入表格元素 `grid_imp` 才执行粘贴并取消默认动作，其余位置（尤其明细网格 grid1 的单元格）一律放行不拦截——grid1 里 Ctrl+V 仍是原厂单格粘贴。判定不通过绝不劫持；CHM 手册查证 Grid 控件没有键盘/焦点事件成员、props 无 grid 级 onkeydown 先例，故未用其他挂钩。"从Excel粘贴"按钮保留，与直贴共用同一 `uf_impgrid_paste()`。
2. **数量列粘贴封顶**：单列贴数量时只填到已有商品编码的最后一行为止，不再自动补行；超出的值直接丢弃，完成提示注明"另有 N 个值超过商品编码行数已忽略"。编码列仍可自动补行、两列整表粘贴不变；按钮与 Ctrl+V 两条路径行为一致。

XUL、props、下游管线（匹配/分摊/税率/快照/回读校验）未动。Node mock 31 项全过（含作用域拦截/放行、封顶/丢弃计数、Ctrl+V 端到端）。

## 源码与文档（在 -xfyproject 仓库）

- 源码：`forms/3b158nm6d7jro17p/ctrlv-paste-v13/`（仅 main.js；main.xul 与 v11 相同）
- 说明与测试记录：`docs/changes/2026-10-21-销售开票CtrlV直贴v13.md`

## 现场验证点

在 Excel 复制一列或两列 → 点进导入表格任意单元格 → 直接 Ctrl+V 应立即落行（弹窗标记 (v13)）；在明细网格 grid1 单元格里 Ctrl+V 必须是单格粘贴、不触发整列填充；先贴 N 行编码、再贴多于 N 个的数量，应只填 N 行、不新增行并提示丢弃数。若 Ctrl+V 在导入表格里毫无反应，说明网格先行消费了按键（已知边界），请反馈现象，按钮路径照常可用。
