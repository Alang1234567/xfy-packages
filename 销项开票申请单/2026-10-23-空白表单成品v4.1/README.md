# 销项开票申请单 空白表单成品 v4.1（2026-10-23，热修复版）

**已被 v5 取代**（2026-10-23 页面架构重做：单头+明细双网格主从结构，见 `../2026-10-23-空白表单成品v5/`；功能口径与本版一致）。本版曾为现行交付版（取代同日 v4，**v4 导入后打开即报错、请勿再导入**；取代原因：热修复其「grid_list 未定义 + 页面空白」缺陷）。

- 交付物：`销项开票申请单_实例化表单_v4.1.zip`（12,886 B，SHA-256 `4bb38c1eeb8eb7b7e1335c898cbef585901494377f837b120f57dac05b42a6d8`；内层 iform SHA-256 `8fc44ee206f08f2bc3a5b1e712c64e0c3dac2cce94f5c963ff38b599e12183d4`）。**zip 本体待 Alan 网页上传至本文件夹**；本地原件在 `~/workspace/projects/xfy-project/work/2026-10-23-invoapply-package/`。
- 缺陷与根因：Alan 实测 v4 导入打开后页面空白、弹「"grid_list"未定义」且不止一个报错。取证定案：v4 把三个网格（grid_apply/grid_red/grid_list）直接挂在 tabpanel 下、未套 `<stack>` 容器；本平台控件构建只在 stack 内实例化控件，三个网格从未被建成运行时对象，平台生成脚本引用时报「未定义」、页面构建中断。证据：本地 58 份 XUL 真值/历史包全量调查——gridobject 父元素 100% 为 stack，唯一例外即 v4 本身；参照原本 15dka 的 5 个 tabpanel 直接子元素全部是 stack。
- 修复：仅 main.xul 三处——每个 tabpanel 内给 gridobject 加一层无属性 `<stack>` 包裹（逐式照 15dka）。其余 5 个成员（main.js/server.js/props.json/desc.html/form.properties）与 v4 **逐字节一致**（unwrap 自检 + 脚本断言）；功能、口径、宏、服务端函数零变化，main.js 无任何初始化时序修改（病因不在 JS：本包与 15dka 的 JS 均从不按名引用网格；数据集为窗口级元素、与页签显隐无关，惰性实例化方向已排查排除）。
- 新增固定检查：**控件引用完整性对账**（audit_refs.py）——静态提取全部控件/数据集引用与定义集核对，共 57 项：修复前一致 54、不一致恰为上述 3 处结构缺陷；修复后 **57/57**。已固化进 verify_package_v41.py（64 项全 PASS，含 v4 全部实质断言复跑：别名对齐 30/33/27、greatest 红线、标定/坐标终检）；fixture 对 v4.1 包内真实代码复跑 **99/99**。
- 部署前置（同 v4）：目标库先执行 `新增列DDL.sql`（蓝字 4 列、红字 0 新增）并登记数据字典，再导入、挂菜单、授权。已导入 v4 的环境直接导 v4.1 覆盖同 formid `1te8rhm10anw30hi`。导入步骤与 12 项实测清单见《导入说明.md》（含 v4.1 先决确认项：打开无报错、三页签可切换）。
- 源码/过程存档：-xfyproject `docs/changes/2026-10-23-销项开票申请单热修复v4.1.md`；构建与验证脚本在 xfy-project `work/2026-10-23-invoapply-package/`（build_v41.py / verify_package_v41.py / audit_refs.py / test_fixture_v41.js / stage-v41/）。
- 注意：服务器直建版 `1qnyaq9q8shnwbas`（v1.1.82.2）仍为单页蓝字版、未同步三页签；与本包是同一业务两份载体，正式使用二选一。
