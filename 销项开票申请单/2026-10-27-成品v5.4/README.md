# 销项开票申请单 成品 v5.4（2026-10-27，已登记换源版）

**现行交付版**（设计修正：已登记量额换源；全量包含 v5.3.2 的发票展示/正票口径/已冲红状态/ORA-12704 修复，取代 v5.3.2）。

- 交付物：`销项开票申请单_实例化表单_v5.4.zip`（24,128 B，SHA-256 `94506cc448868793177b5993aa4e4eb9e4c91d13dd24f518fb649a7b6e82a2d4`；内层 iform SHA-256 `452d320e04cde2248048c6540700745f6fc4ab3724e32e63ae622aa0dc2ce15d`）。**zip 本体待 Alan 网页上传至本文件夹**；本地原件在 `~/workspace/projects/xfy-project/work/2026-10-23-invoapply-package/`。
- 换源口径：已登记数量/金额 = 有效登记单（InvoiceMt 登记类、未作废）挂到该出库行的 InvoiceDt 明细汇总，正负票净额抵扣。不再读 SaleOutDt 的 `K_RegInvoiceAmt / K_RegInvoiceNum` 回写列（财务表单只读不写、手动登记链不维护，该列恒无数据）。
- 改动面：六个宏各加 reg 预聚合联接、已登记引用全换现算（共 23 处）；server.js 读现值与守卫的已登记两项换同一现算表达式。字段 id、界面、客户端校验、写回纪律（只写 K_Apply 三列）全部不变；main.js / main.xul 逐字节不动。
- 一并堵住的洞：撤销下限此前押在恒 0 的回写列上，可把已登记部分的申请撤掉再重复申请；换源后撤销只能释放未登记部分。
- 验证：verify_package_v54 **188 项全过**（变换重构自证、audit 93/93、六宏回写列残留 = 0）；test_fixture_v54 **213/213**。
- 导入：已导 v5.3.x 的覆盖导本包，无新增前置；导后关全部页签重开复测（手动登记单的已登记金额/状态、撤销下限）。
- 源码/过程存档：-xfyproject `docs/changes/2026-10-27-销项开票申请单v5.4.md`；脚本在 xfy-project `work/2026-10-23-invoapply-package/`（build_v54.py / verify_package_v54.py / test_fixture_v54.js）。
