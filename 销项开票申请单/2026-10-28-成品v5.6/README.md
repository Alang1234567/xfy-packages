# 销项开票申请单 成品 v5.6 + 销售退货协议书打印模板（2026-10-28）

**现行交付版**（查询明细补原发票号/日期两列，为退货协议书打印备数；全量包含 v5.5.1，取代 v5.5.1）。

- 表单包：`销项开票申请单_实例化表单_v5.6.zip`（24,252 B，SHA-256 `5e2cfdf59e7331e154096ade8b5ce22c4eefa0900edbf1e17b5181add1534742`；内层 iform SHA-256 `52bda0409f19bb83e44770d82f63fa2ad24cdc0556588eaa1a342aac9025a20e`）。**zip 本体待 Alan 网页上传至本文件夹**；本地原件在 `~/workspace/projects/xfy-project/work/2026-10-23-invoapply-package/`。
- 打印模板：`销售退货协议书打印模板.rpt`（14,718 B），随本说明同目录的副本在 xfy-project work 目录；**rpt 本体同样待 Alan 网页上传至本文件夹**（或直接用对话附件）。挂载方式见《退货协议打印模板接法说明》。
- 改动（仅两处）：sql_qdt_list 加 f 子查询输出原发票号/原发票日期（照红字明细 rdt 口径，只取有效蓝票）；ds_qdt format 在「发票日期」后加这两字段（33→35 列）。main.js/server.js 与 v5.5.1 逐字节一致，业务逻辑零改动。
- 打印口径（Alan 选 B）：查询页打开一张红字单后点打印预览，协议货物行按已申请量/额（ABS 正数），甲方取客户名称，开票日期/号码取原蓝票，合计取主表已申请金额。
- 注意：本表单打印模板位只有一个，挂协议书会顶掉 A5 开票申请单模板，二选一挂载。
- 验证：verify_package_v56 全过；test_fixture_v56 **217/217**；模板 12 处字段绑定逐个与数据集 format 对账全中、列宽连续对账 718.11。未做 Oracle 活体验证，以现场复测为准。
- 导入：覆盖导 v5.6，无新增前置；导后关全部页签重开，查询明细应多出原发票号/原发票日期两列。
- 源码/过程存档：-xfyproject `docs/changes/2026-10-28-销项开票申请单v5.6与退货协议模板.md`；脚本在 xfy-project `work/2026-10-23-invoapply-package/`（build_v56.py / verify_package_v56.py / test_fixture_v56.js / build_rpt_agreement.py）。
