# 销项开票申请单 成品 v5.3.1（2026-10-27，热修复版）

**已被 v5.3.2 取代**（2026-10-27 正票口径+已冲红状态，见 `../2026-10-27-成品v5.3.2/`；本版为修 v5.3 查询提取报 ORA-12704 字符集不匹配；全量包含 v5.3，取代 v5.3）。

- 交付物：`销项开票申请单_实例化表单_v5.3.1.zip`（23,584 B，SHA-256 `f1bf1fc426b37f2bf2e90205c359b689c31bdd597a10e280c48a28bb01ab0954`；内层 iform SHA-256 `b508614c0d0e2f13913cc0f02933515be21ca42196efebd54eed30166f7121ff`）。**zip 本体待 Alan 网页上传至本文件夹**；本地原件在 `~/workspace/projects/xfy-project/work/2026-10-23-invoapply-package/`。
- 根因：sql_qmt_list 的 PicLink 附件地址拼接漏了 15dka 原式的 `to_char` 包裹——AttachId（NVARCHAR2）拼接结果属国家字符集，与 CASE 另一分支 InvoiceMt.K_InvoiceUrl（VARCHAR2）撞集，Oracle 报 ORA-12704、整宏失败。
- 修复仅一处：`Max(to_char('http://139.159.244.54:2223/attachment/' || AttachId))`，与财务 S_InvoQueryMt 逐字一致；其余宏/数据集/main.js/server.js/main.xul 与 v5.3 **逐字节一致**（verify 变换重构自证）。
- 验证：verify_package_v531 **164 项全过**（含 v5.3 发票展示断言全量复跑、to_char 白名单更新为 15dka 同式两处）；对账 **93/93**；fixture **201/201**。
- 导入：已导 v5.3 的覆盖导本包即可，无新增前置；导后关全部页签重开，进已申请数据查询页提取复测（不再报错 + 按 v5.3 说明 A–E 验发票列）。
- 源码/过程存档：-xfyproject `docs/changes/2026-10-27-销项开票申请单v5.3.1.md`；脚本在 xfy-project `work/2026-10-23-invoapply-package/`（build_v531.py / verify_package_v531.py / test_fixture_v531.js）。
