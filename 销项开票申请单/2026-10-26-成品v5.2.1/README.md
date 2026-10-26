# 销项开票申请单 空白表单成品 v5.2.1（2026-10-26，增量版）

**现行交付版**（在 v5.2 之上只补打印模板的两项硬依赖：查询单头「整单数量」绑真数据、查询主宏 ORDER BY 客户打头供模板按客户分组小计；全量包含 v5.2，取代 v5.2）。

- 交付物：`销项开票申请单_实例化表单_v5.2.1.zip`（22,708 B，SHA-256 `985478b6a31feb8d9e30b0fe0557ff7a6a8f86ad1a246c842b5e659c1e400d6b`；内层 iform SHA-256 `0be832f760756dfbdb2b6df86d7edfc5dcce7cbc346312d65f8fb5cd6038a795`）。**zip 本体待 Alan 网页上传至本文件夹**；本地原件在 `~/workspace/projects/xfy-project/work/2026-10-23-invoapply-package/`。
- 改动仅三处：①sql_qmt_list 的 SELECT 在已申请金额聚合后增加 `Sum(b.Num) as ApplyQty`（整单全部明细行数量之和，红字负数原样）；②sql_qmt_list 的 ORDER BY 改为 `order by c.BusinessName, a.Dates, a.BillNo`（客户打头——打印模板按客户名称做 FastReport 分组小计的硬依赖，不保序会把同名客户拆成多段各出小计；连带查询页单头网格显示顺序变为按客户分组排列，属预期变化）；③ds_qmt format 在已申请金额字段后新增字段 ApplyQty（标题逐字「数量」，decimal 14/4，与明细数量同惯例）——打印模板数量列以 `[ds_qmt."数量"]` 按标题绑定即出真数（模板里原占位文字替换掉即可）。查询页单头网格同步多出一列「数量」（只读、带合计），为预期可见副作用。
- 与 v5.2 的差异总账：props.json 仅 qmt 两处（合计 +48 B）与 lastmodified 刷新；main.xul 仅 ds_qmt 一个 format blob 新增一个字段；main.js / server.js / desc.html / form.properties 与 v5.2 **逐字节一致**（哈希自证，见《v5.2.1增量说明.md》）。
- 验证：verify_package_v521 **131 项全过**（含与 v5.2 的变换重构保真、别名↔format 字段集仍精确相等、KF_KFPSQ 残留 = 0、v5.2 全部红线复跑、新增 6 项断言含 ORDER BY 客户打头）；控件引用完整性对账 **93/93**；fixture **177/177**（v5.2 的 173 项 + L13/L16 数量与排序断言 4 项：种子蓝单 30=10+20、红单 −30=−10+−20）。未做活体 SQL 验证，现场验收看查询页「数量」列与顺序、打印预览数量列与按客户小计。
- 导入：**未导 v5.2 的跳过 v5.2 直接导本包**（前置同 v5.2：先 `ALTER TABLE SaleOutMt MODIFY (K_ApplyTime CHAR(19));` 并同步字典长度 19，见随附《导入说明.md》）；**已导 v5.2 的覆盖导本包**，无新增前置；两种情况导后都**关掉该表单全部已打开页签再重开**，只导最新版。
- 源码/过程存档：-xfyproject `docs/changes/2026-10-26-销项开票申请单v5.2.1.md`；构建与验证脚本在 xfy-project `work/2026-10-23-invoapply-package/`（build_v521.py / verify_package_v521.py / test_fixture_v521.js）。
