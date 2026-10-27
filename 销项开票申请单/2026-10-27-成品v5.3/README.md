# 销项开票申请单 成品 v5.3（2026-10-27）

**已被 v5.3.1 取代**（2026-10-27 热修复：查询提取报 ORA-12704 字符集不匹配，见 `../2026-10-27-成品v5.3.1/`；本版为在 v5.2.1 之上只改「已申请数据查询」页：补财务 15dka 已申请发票查询的发票字段，并展示之前已经开出来的发票数据；全量包含 v5.2.1，取代 v5.2.1）。

- 交付物：`销项开票申请单_实例化表单_v5.3.zip`（23,581 B，SHA-256 `3dec00600e6b97340397d6bfd5f77073afbcef93ac83ddb595d75946b7fb7219`；内层 iform SHA-256 `280dfddfcc1fa6da5ee4dd0f677b4c992d8175fceba5dba2bd09b4b611b4304a`）。**zip 本体待 Alan 网页上传至本文件夹**；本地原件在 `~/workspace/projects/xfy-project/work/2026-10-23-invoapply-package/`。
- 查询主表（ds_qmt）新增 12 列：已开发票金额、审核、发票号码、发票登记单号、登记日期、红字发票、冲红完成、发票日期、附件、发票下载地址（紧随已登记金额）+ 业务来源、业务类型（紧邻摘要前，查询页原缺）。查询明细（ds_qdt）新增 5 列：已开发票数量、已开发票金额、发票号码、发票登记单号、发票日期（紧随登记发票金额，逐行对位）。
- 关联口径：`InvoiceDt.RfBillNo/RfBillSn → SaleOutMt.BillNo / SaleOutDt.BillSn`（15dka 宏与函数库回写三处取证一致）；有效发票 `RuleId='3efz6zl30gj7qi9e' and BillState=0`；多票先「出库单×发票」去重再 listagg 拼接；附件/下载地址照财务 S_InvoQueryMt（PicLink 聚合，附件优先、否则 InvoiceMt.K_InvoiceUrl）；已开量/额取 SaleOutDt 回写列。
- 与 v5.2.1 的差异总账：props.json 仅 sql_qmt_list 四处 + sql_qdt_list 两处与 lastmodified；main.xul 仅 ds_qmt（+12 字段）/ ds_qdt（+5 字段）两个 format blob；main.js / server.js / desc.html / form.properties **逐字节一致**（变换重构 + 哈希自证，见《v5.3增量说明.md》）。
- 验证：verify_package_v53 **166 项全过**（含别名↔format 精确相等 qmt 32 列/qdt 35 列、to_char 白名单仅 to_char(m.BillNo) 一处、KF_KFPSQ 残留 = 0、表头单行终检）；控件引用完整性对账 **93/93**；fixture **200/200**（v5.2.1 的 177 项 + 发票口径/透传 23 项，种子仿财务截图蓝/红票对）。未做活体 SQL 验证，现场验收点见增量说明 A–E。
- 导入：无新增前置——未导 v5.2.1 的直接导本包（前置 ALTER K_ApplyTime CHAR(19) + 字典 19 照旧，见随附《导入说明.md》）；已导 v5.2.1 的覆盖导本包；导后关掉该表单全部已打开页签再重开。
- 源码/过程存档：-xfyproject `docs/changes/2026-10-27-销项开票申请单v5.3.md`；构建与验证脚本在 xfy-project `work/2026-10-23-invoapply-package/`（build_v53.py / verify_package_v53.py / test_fixture_v53.js）。
