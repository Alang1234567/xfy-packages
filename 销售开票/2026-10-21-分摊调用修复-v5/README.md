# 销售开票 · 粘贴导入分摊调用修复 v5（2026-10-21）

## 附件

- 文件：`销售开票_粘贴导入分摊调用修复_改后v5.zip`（134,846 字节）
- SHA-256：`9735a0ed0595907f2812fa7331e36645c2b944258efb1ee1d9bb88b45a96a671`
- 基线：v4（完整包含 v4 的提取字段修复与粘贴导入 v3），v5 为现行交付版，部署用这一份即可。

## 内容

修粘贴导入的批号分摊调用：v3/v4 现场实测报 ORA-00900——分摊宏用了 SQL Server 方言 `exec Proc_ShareBatchStor :K_OnlyId`，Oracle 不认；改为 Oracle 写法 `call Proc_ShareBatchStor(:K_OnlyId)`（同表单内原厂 Oracle 宏的既有写法）。顺带修正分摊计数：库存不足的短缺行（AngleId 为空）不再计入"已分摊数量"；弹窗版本标记改为 (v5)。

## 源码与文档（在 -xfyproject 仓库）

- 源码：`forms/3b158nm6d7jro17p/share-call-fix-v5/`（main.js、props.json）
- 说明：`docs/changes/2026-10-21-销售开票粘贴导入分摊调用修复v5.md`

## 现场验证点

粘贴 `MCAAA001000301,50`（艾叶）：弹窗标记 (v5)；预期已分摊 50、未分摊 0，网格批号列自动带出。
