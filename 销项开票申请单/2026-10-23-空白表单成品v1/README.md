# 销项开票申请单 空白表单成品 v1（2026-10-23）

**现行交付版**（本表单首版）。

- 交付物：`销项开票申请单_实例化表单_v1.zip`（9155 B，SHA-256 `de7babe15e72ef23d623b4649d2f57c790ac85d9ac153b88717ebec1fdfc83d6`）。**zip 本体待 Alan 网页上传至本文件夹**；本地原件在 `~/workspace/projects/xfy-project/work/2026-10-23-invoapply-package/`。
- 内容：以 Alan 上传的空白表单（upload-17.zip，formid `1te8rhm10anw30hi`、formname `cskq.sza.xxfpsqs`）为身份底子，整体移植服务器直建版「销项开票申请单」（formid `1qnyaq9q8shnwbas`，公式纠正后 v1.1.82.2 回读真值）的全部功能：查询头 + 提取/保存申请/撤销申请/全选/全消 + 可编辑申请明细网格、数据集 ds_qry/ds_apply、宏 sql_apply_list、服务端写回 Srv_SaveInvoApply/Srv_CancelInvoApply（旧值守卫、点名回执）。源空白件是设计注册文件（.reg.form、无 orgid），成品按实例化口径校正为 `1te8rhm10anw30hi_00000000000.iform`。
- 口径红线：可申请余额/上限 = `TaxAmount − greatest(K_RegInvoiceAmt, K_ApplyInvoiceAmt)`（数量同理），与设计 §3.2 定案及直建版 v1.1.82.2 一致，旧保守校验式 0 残留。
- 验证：结构校验（外层单成员 .iform）+ 四件套（node --check / XUL 解析 / props JSON / 反向解包复验）全过；main.js、server.js、desc.html 与直建版真值逐字节一致，xul 仅 formid 两处不同，props 仅五项身份字段不同（label 按平台算法以新 formid 重生成且复算自证）；fixture 46 条对成品包内代码复跑 46/46。
- 源码/过程存档：-xfyproject `docs/changes/2026-10-23-销项开票申请单空白表单成品v1.md`；构建与验证脚本在 xfy-project `work/2026-10-23-invoapply-package/`（build_package.py / verify_package.py / 验底记录.md）。
- 部署前置：目标库先执行 `新增列DDL.sql`（SaleOutDt/SaleOutMt 加 4 列）并在平台数据字典登记，再导入表单、挂菜单、授权。导入与实测步骤见同文件夹《导入说明.md》。
- 注意：与服务器直建版 `1qnyaq9q8shnwbas` 是同一功能两份载体，导入同一服务器将并存，正式使用二选一。
