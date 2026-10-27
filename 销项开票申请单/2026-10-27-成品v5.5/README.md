# 销项开票申请单 成品 v5.5（2026-10-27，查询页调整版）

**已被 v5.5.1 取代**（v5.5 按申请日期查询漏数：存量早期格式与空时间的行被滤掉；勿再导 v5.5）。原说明：查询页删已登记展示列 + 按申请日期查询；全量包含 v5.4，取代 v5.4。

- 交付物：`销项开票申请单_实例化表单_v5.5.zip`（24,110 B，SHA-256 `df807aaf7dc8ddebd381fafab6ab4d83df4c3c967150eaf4f7b342515dc1fd64`；内层 iform SHA-256 `9377bbfd2989cfae62e7f4a6ea94ba1ebb5f52c7f1f1d2a43e25bd124b19b09e`）。**zip 本体待 Alan 网页上传至本文件夹**；本地原件在 `~/workspace/projects/xfy-project/work/2026-10-23-invoapply-package/`。
- 改动（仅查询页）：主表删「已登记金额」列（31 列）、明细删「登记发票数量/金额」两列（33 列），数据集与宏 SELECT 同步删，状态推导内部不变；查询日期范围改按申请日期（`substr(K_ApplyTime,1,10)` 起止比较），查询头标签改「申请日期」。
- 未动：蓝/红申请页的已登记列（客户端校验要读，非纯展示）；其余功能与 v5.4 一致。
- 注意：申请日期取单头最近一次申请时间；申请时间为空的存量行不在日期范围内显示（该缺陷已在 v5.5.1 修复：空值按出库日期兜底、早期 NLS 格式归一）。
- 验证：verify_package_v55 **168 项全过**（变换重构自证、audit 93/93）；test_fixture_v55 **216/216**。
- 导入：已导 v5.4 的覆盖导本包，无新增前置；导后关全部页签重开复测。
- 源码/过程存档：-xfyproject `docs/changes/2026-10-27-销项开票申请单v5.5.md`；脚本在 xfy-project `work/2026-10-23-invoapply-package/`（build_v55.py / verify_package_v55.py / test_fixture_v55.js）。
