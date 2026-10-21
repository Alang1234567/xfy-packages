# 销售开票 · 粘贴导入包装税率修复 v6（2026-10-21）

## 附件

- 文件：`销售开票_粘贴导入包装税率修复_改后v6.zip`（135,255 字节）
- SHA-256：`c72af790b1fc3e977122cdb7b279eea42ce411822c73192dbb50ca603c1b1a3b`
- 基线：v5（完整包含 v5/v4 全部内容），v6 为现行交付版，部署用这一份即可。

## 内容

修粘贴导入明细带出不全：解析 SQL 补取 GoodsDoc 的包装规格 K_PackSpec、每袋装量 K_PackBaseNum、外包装规格 K_OuterPackSpec 与 GoodsAttr 的定制税率列 K_RATE；写行与价格重算回填环节同步补齐上述字段和税率（OutTaxRate 优先、K_RATE 兜底），并按原厂公式补算包装袋个数；弹窗每行显示识别到的税率。

## 源码与文档（在 -xfyproject 仓库）

- 源码：`forms/3b158nm6d7jro17p/pack-rate-fix-v6/`（main.js、props.json）
- 说明：`docs/changes/2026-10-21-销售开票粘贴导入包装税率修复v6.md`

## 现场验证点

弹窗标记 (v6)、每行带"税率："数值；网格包装规格/每袋装量与手工选行一致；不含税单价应按税率拆分低于含税单价。
