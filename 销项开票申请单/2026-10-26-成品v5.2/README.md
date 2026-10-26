# 销项开票申请单 空白表单成品 v5.2（2026-10-26，终版）

**已被 v5.2.1 取代**（增量仅一数：查询单头整单数量，供打印模板数量列绑真数据；见 `2026-10-26-成品v5.2.1/`）。以下为 v5.2 本版记录。

**本版交付说明**（取代 v5.1；取代原因：v5.1 在现场暴露三故障——保存 ORA-12899、存量 NULL 行误报「已被他人修改」、查询页 ORA-01722，本版逐项闭环并落标记列切换与打印按钮，见下）。

- 交付物：`销项开票申请单_实例化表单_v5.2.zip`（22,673 B，SHA-256 `f1e3981cbb04f612750fa6de7ca3f8025423642e0ff35dc45c7a497914c6115c`；内层 iform SHA-256 `3ad0dc40b55a7f31e8028c3da3aa7b706f1f326eb732a5b84eb37b9a804a0a007`）。**zip 本体待 Alan 网页上传至本文件夹**；本地原件在 `~/workspace/projects/xfy-project/work/2026-10-23-invoapply-package/`。
- 三故障根因与修法：①ORA-12899=代码写裸 sysdate 进 CHAR(10) 的 K_ApplyTime、隐式转出 11 位串溢出——乙路线：导入前先 `ALTER TABLE SaleOutMt MODIFY (K_ApplyTime CHAR(19));` 并同步字典长度 19，包里写 19 位全量时间串。②守卫误报=目标行 K_ApplyInvoiceNum 为 NULL、金额为 0（提取只卡金额故行可见、界面显示 0、JS 归一 0、SQL 等值比 NULL≠0 命中 0 行）——server.js 读/守卫全 NVL 归一、守卫面扩为申请+已登记+标记 5 项并捕获更新行数，回执区分「守卫未命中/回读不一致」；六宏同步 NVL 归一（41 处）。③ORA-01722=查询主宏对 CHAR 型 K_ApplyTime 套 to_char 转换（全包唯一处）——改直读，verify 新增静态类型红线防再犯。
- 标记列切换：KF_KFPSQ → 本站自加的 `K_ApplyFlag`（format 2 处、宏 4 处、server.js 3 处；NULL≡'N' 全程 NVL）；成品全部成员（含解码 format）KF_KFPSQ 残留 = 0（verify 断言）。
- 打印预览按钮：主工具栏「全消」后新增 btn_print（label=打印预览、oncommand="Printer.preview()"，照 15dka）；模板由 Alan 在打印设计里替换 .rpt 后生效。
- 不动：dentid 修复完整保留（main.js 与 v5.1 逐字节一致）、greatest 余额口径、写回其余逻辑、数据集其余字段、红字 K_Dir 分支。
- 验证：verify_package_v52 **130 项全过**（含与 v5.1 的变换重构保真、别名↔format 相等、KF_KFPSQ 残留 0、NVL 在位剥除断言、静态类型红线、harness 替身差集 = 空）；控件引用完整性对账 **93/93**；fixture **173/173**（装载包内真实函数体；新增存量 NULL 套件 N1–N5、红字撤销真分发 L15、查询页提取路径 L16）。未做活体 SQL 验证，现场验收按《导入说明.md》清单。
- 部署前置（v5.2 新口径）：现场列已建好（K_ApplyFlag 等，实况见《导入说明.md》），导入前只需①执行上面的 ALTER 并同步字典长度 19；②导包后**关掉该表单全部已打开页签再重开**（旧窗口装旧代码——红字 dentid 乌龙即 v5 被重复导入覆盖 v5.1 + 旧代码所致）；③只导最新版，不再导任何旧版 zip。改动逐处与三故障闭环见《v5.2修复说明.md》。
- 源码/过程存档：-xfyproject `docs/changes/2026-10-26-销项开票申请单v5.2.md`；构建与验证脚本在 xfy-project `work/2026-10-23-invoapply-package/`（build_v52.py / verify_package_v52.py / test_fixture_v52.js / src-v52/server.js / audit_refs.py）。
- 注意：服务器直建版 `1qnyaq9q8shnwbas` 仍为单页老版且源码带 dentid 同病——同步须另行授权；正式使用仍二选一。
