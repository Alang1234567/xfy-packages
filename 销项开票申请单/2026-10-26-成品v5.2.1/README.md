# 销项开票申请单 空白表单成品 v5.2.1（2026-10-26，增量版）

**现行交付版**（在 v5.2 之上只补一个数：查询单头「整单数量」，供打印模板数量列绑真数据；全量包含 v5.2，取代 v5.2）。

- 交付物：`销项开票申请单_实例化表单_v5.2.1.zip`（22,701 B，SHA-256 `09f563d05b5e045fa546482cd37aec17600f07034eeab344474a75d74cf41e9b`；内层 iform SHA-256 `8f18df87291d28fb85a9de48b702208a9f12e500ba8d20c9682d88e726bcbb13`）。**zip 本体待 Alan 网页上传至本文件夹**；本地原件在 `~/workspace/projects/xfy-project/work/2026-10-23-invoapply-package/`。
- 改动仅两处：①props.json 的 sql_qmt_list 在已申请金额聚合后增加 `Sum(b.Num) as ApplyQty`（整单全部明细行数量之和，红字负数原样）；②ds_qmt format 在已申请金额字段后新增字段 ApplyQty（标题逐字「数量」，decimal 14/4，与明细数量同惯例）——打印模板数量列以 `[ds_qmt."数量"]` 按标题绑定即出真数（模板里原占位文字替换掉即可）。查询页单头网格同步多出一列「数量」（只读、带合计），为预期可见副作用。
- 与 v5.2 的差异总账：props.json 仅 qmt 一行（+23 B）与 lastmodified 刷新；main.xul 仅 ds_qmt 一个 format blob 新增一个字段；main.js / server.js / desc.html / form.properties 与 v5.2 **逐字节一致**（哈希自证，见《v5.2.1增量说明.md》）。
- 验证：verify_package_v521 **130 项全过**（含与 v5.2 的变换重构保真、别名↔format 字段集仍精确相等、KF_KFPSQ 残留 = 0、v5.2 全部红线复跑、新增 5 项 ApplyQty 断言）；控件引用完整性对账 **93/93**；fixture **176/176**（v5.2 的 173 项 + L13/L16 数量断言 3 项：种子蓝单 30=10+20、红单 −30=−10+−20）。未做活体 SQL 验证，现场验收看查询页「数量」列与打印预览数量列。
- 导入：**未导 v5.2 的跳过 v5.2 直接导本包**（前置同 v5.2：先 `ALTER TABLE SaleOutMt MODIFY (K_ApplyTime CHAR(19));` 并同步字典长度 19，见随附《导入说明.md》）；**已导 v5.2 的覆盖导本包**，无新增前置；两种情况导后都**关掉该表单全部已打开页签再重开**，只导最新版。
- 源码/过程存档：-xfyproject `docs/changes/2026-10-26-销项开票申请单v5.2.1.md`；构建与验证脚本在 xfy-project `work/2026-10-23-invoapply-package/`（build_v521.py / verify_package_v521.py / test_fixture_v521.js）。
