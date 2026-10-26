# 销项开票申请单 空白表单成品 v5.1（2026-10-26，热修复版）

**现行交付版**（取代 2026-10-23 的 v5；取代原因：v5 保存报错——点「保存申请」弹 `"dentid"未定义`，见下）。

- 交付物：`销项开票申请单_实例化表单_v5.1.zip`（21,901 B，SHA-256 `1ea07e63eae3de207479ea2a3159131bd4602f3a0aa1c663fadc32dc5e5621a5`；内层 iform SHA-256 `82e80d95bd75703da9ae8d176428da2f5ba0c9a2e24bc419ca459ea1cff723e3`）。**zip 本体待 Alan 网页上传至本文件夹**；本地原件在 `~/workspace/projects/xfy-project/work/2026-10-23-invoapply-package/`。
- 缺陷与根因：v5 现场实测提取/主从联动/勾选金额全正常，唯保存/撤销中断。客户端 main.js 四处入口 `params.K_EntId = dentid;` 裸读从未声明赋值的变量——dentid 不是平台注入的全局，只是部分原厂表单自备的局部变量惯例（业务员表单：var 声明 + onLoad 取登录信息企业 ID；参照 15dka：取主数据集当前行 EntId 字段）；本包自 v1 起照客户资料的裸用写法继承了该缺陷（此前各版实测均先卡在提取阶段，未触发）。
- 修复（仅 main.js，6 处）：新增 `uf_entid()` 作企业 ID 唯一来源（当前页签主数据集当前行 EntId 字段优先、退登录信息、再无回空串），蓝/红保存与蓝/红撤销四处调用点改走它，离线导出表加一项。与 v5 的保真关系经断言证明：server.js/main.xul/desc.html/form.properties 逐字节一致、props 除时间戳外全等、main.js 差异恰为上述修复（变换重构全等）——功能口径、六宏、greatest 红线、写回守卫零改动。
- 漏检整改（第二次同类「未定义」教训）：v5 的 fixture harness 预置了 `global.dentid` 恰好盖住缺失，audit_refs 又误把 dentid 列入平台白名单且只查对象头引用（裸值读不在集内）。已升级固定防线：audit 新增裸标识符读扫描 + 客户端→服务端参数契约对账，verify 新增「harness 替身差集 = 空」；阴性对照——新 audit 对 v5 恰报 dentid 一项、新 harness 跑 v5 在保存步同症中断。
- 验证：verify_package_v51 **84 项全过**；控件引用完整性对账 **92/92**；fixture **135/135**（harness 不预置 dentid，含保存/撤销 K_EntId 实参断言与 uf_entid 解析链）。
- 部署前置（同前版）：目标库先执行 `新增列DDL.sql`（4 列）并登记数据字典，再导入、挂菜单、授权。已导入 v5 的环境直接导 v5.1 覆盖同 formid `1te8rhm10anw30hi`。导入步骤见《导入说明.md》（已同步 v5.1，实测清单前加了「保存/撤销四入口不再报错」的验收第一项）；根因与改动全表见《v5.1热修复说明.md》。
- 源码/过程存档：-xfyproject `docs/changes/2026-10-26-销项开票申请单热修复v5.1.md`；构建与验证脚本在 xfy-project `work/2026-10-23-invoapply-package/`（build_v51.py / verify_package_v51.py / test_fixture_v51.js / src-v51/ / stage-v51/ / audit_refs.py 升级版）。
- 注意：服务器直建版 `1qnyaq9q8shnwbas`（v1.1.82.2）源码里有同一裸读缺陷且仍为单页版——若启用它保存会犯同样的错；其修复须另行授权走服务器开→存流程，本版未动。正式使用仍二选一。
