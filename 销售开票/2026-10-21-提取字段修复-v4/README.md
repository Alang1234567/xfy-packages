# 销售开票 · 提取字段修复 v4（2026-10-21）

## 附件

- 文件：`销售开票_提取字段修复_改后v4.zip`（136,893 字节）
- SHA-256：`3e8bd9471dea797e190141218d2ae13b79bfec194e776fa0137f5977cff17b4f`
- 基线：v3（粘贴导入支持商品编码），v4 在其上增补提取字段修复，v1–v3 不再单独归档。

## 内容

- 粘贴导入（v3）：编码/名称双通道、数量客户端解析、按现场真实结构分摊（单参数 Proc_ShareBatchStor、经 AngleId 关联批号）、复用空白行。
- 提取字段修复（v4）：复制后客户框锁定（uf_afterCopyBill 守卫改 sel_CopyBill.result）、平台订单提取补数量 Num 与单头 ClientId/SaleClientId/AccptId、自助订单别名 slaeclientcode 改 saleclientcode。

## 源码与文档（在 -xfyproject 仓库）

- 源码：`forms/3b158nm6d7jro17p/extract-field-fixes/`（main.js、props.json）
- 说明：`docs/changes/2026-10-21-销售开票提取字段修复v4.md`、`docs/changes/2026-10-21-销售开票粘贴导入v3修正.md`

## 现场验证点

复制后客户框变灰锁定；平台订单提取后明细数量有值、未预选客户时单头客户完整；自助订单提取后销售客户编码有值；粘贴导入弹窗标记 (v3) 属正常（该部分未动）。
