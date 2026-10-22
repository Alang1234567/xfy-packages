# 销售开票 · 最终版三件套（2026-10-22）

## 附件

- 文件：`销售开票_最终版_三件套.zip`（86,256 字节）
- SHA-256：`2deba3a6eb57ca2fed507bd0366478034a152bb6d3b9b4b8367da06473c93081`
- 内容：三份可粘贴 Studio 的 txt + 《部署说明》。**这是 txt 粘贴部署包，不是 iform 导入包**；zip 本体按既定分工由 Alan 网页上传本文件夹。
- 部署**不需要建表、不动数据库**。

## 三件套构成（均为已定版文件的原样组装，无新写代码、无任何计时/测试代码）

| txt | 粘贴页签 | 来源 | SHA-256 |
|---|---|---|---|
| `销售开票_main_最终版.txt` | Javascript | v17 定版 main.js | `842027e7…eea63` |
| `销售开票_portect_最终版.txt` | Protected Javascript | 改后v21（portect 仅 L87 关限销） | `29d2d31d…e305` |
| `销售开票_server_最终版.txt` | Server Javascript | v22 正式版（v14 五处重植 + N1/N2） | `4f5479b4…ee8` |

效果（现场实测口径，新建 1 行单）：保存总耗时约 13.5s（最初）→ 9.0s（v17 去重）→ **约 4.4s（最终版）**；检查约 0.36s、服务端钩子约 0.1s，其余约 90% 为平台存盘层（定版边界内不改）。

## 核验（组装时全量执行，详见 -xfyproject 变更文档）

- 三份 `node --check` 全过；与来源文件逐字节一致（cmp + sha256）。
- 污染断言零命中：main 无 `_t18/_t20/XFY_SAVE_TIMING/sql_xfy_timing/XFY_LIMITSALE_OFF/t15_`；server 无 `t15_/XFY_SAVE_TIMING`；portect 与 Alan 原版 diff 仅第 87 行一处。
- 兼容断言：portect sys_save 调用的 `uf_saveCheck` 在 main 中有定义且签名一致；`isLimitSale` 在 main 中只读无赋值，portect 强制 false 后保存与编辑两处限销一并关闭（与 10-22 现场实测限销段 0ms 互证）。
- zip 反向解包逐字节复验一致。

## 部署与回归（摘要，全文见 zip 内《部署说明》）

1. 三份整份粘贴对应页签（顺序随意、三份都换），保存发布。
2. 回归：正常单约 4.4 秒且**无弹框**（有弹框 = 有页签没换干净）；库存/信贷/价格拦截仍生效；WMS 单正常；限销客户单不再触发限销（不拦截、不清零）。
3. 回滚：只恢复限销按 portect 文件内注释改回原行；整版回滚换回各自原文件。
4. 遗留：XFY_SAVE_TIMING 表与本版无关，可保留或择机 DROP；可选 DBA 索引经核查一条都不用建。

## 源码与文档（在 -xfyproject 仓库）

- 源码：`forms/3b158nm6d7jro17p/final/`（三份 txt 原样）
- 文档：`docs/changes/2026-10-22-销售开票最终版.md`（构成、SHA 对照、核验结果、版本谱系）
- 本地制作区：`work/2026-10-22-final/`

## 取代关系

本版为保存优化线的**现行正式版**，取代 v17（功能基线包）+ 改后v21 portect + v22 server 的分散交付形态；测试版 v18/v20/v23 使命完成、不再部署。
