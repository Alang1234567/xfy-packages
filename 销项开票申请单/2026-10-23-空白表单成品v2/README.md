# 销项开票申请单 空白表单成品 v2（2026-10-23，布局修复）

**现行交付版**（取代同日 v1，v1 请勿再导入）。

- 交付物：`销项开票申请单_实例化表单_v2.zip`（9,172 B，SHA-256 `b349743fb71c3e61d8fc8aedf397f4846e260f87460c84487505f05e3c435d81`；内层 iform SHA-256 `327c4cf2b1d10927e3283cc509ec90cee1a763a2dbbc383bce569794b02a8cc1`）。**zip 本体待 Alan 网页上传至本文件夹**；本地原件在 `~/workspace/projects/xfy-project/work/2026-10-23-invoapply-package/`。
- 与 v1 的差异：**仅 `content/main.xul`**——①查询头下移避开工具栏带（v1 坐标审计重叠 6 对：第一行 top:8 落在平台工具栏带 0..27 内、被压 19px；v2 行 1 top 35 / 行 2 top 63）；②ds_apply 8 个字段列宽按运行时显示标题（数据字典注释：单据序号/登记发票数量/登记发票金额/是否开具发票等，原 w 照 format 短标题定得过窄、表头折行叠字）加宽，26 个可见列复验均可单行；③网格撑满（top 91、height 653、下边距 16=右边距 16），横向滚动条随网格落到窗口底部。改动面经脚本证明：xul 掩 format 值并抹坐标后与 v1 逐字节一致、format 30 字段仅 8 个 w 不同；main.js/server.js/desc/props 与 v1 逐字节一致，功能与口径（greatest 定案）零变化，fixture 46 条对 v2 包内代码复跑 46/46。
- 标题提醒：运行时页签标题取**菜单节点名**；该 formid 在 Alan 环境的既存登记名是「未命名表单」（其新建空白表单时的名字），包内全部标题字段（caption/cl/xul label/desc/form.properties）均已核为「销项开票申请单」——挂菜单时把节点命名为「销项开票申请单」即可。
- 详细审计与逐项对账：同文件夹《v2布局修复说明.md》；导入步骤、前置 DDL 与实测清单见《导入说明.md》。
- 源码/过程存档：-xfyproject `docs/changes/2026-10-23-销项开票申请单布局修复v2.md`；构建与验证脚本在 xfy-project `work/2026-10-23-invoapply-package/`（audit_layout.py / build_v2.py / verify_package_v2.py）。
- 部署前置（同 v1）：目标库先执行 `新增列DDL.sql` 并登记数据字典，再导入、挂菜单、授权。已导入 v1 的环境直接导 v2 覆盖同 formid。
- 注意：与服务器直建版 `1qnyaq9q8shnwbas` 是同一功能两份载体，正式使用二选一。
