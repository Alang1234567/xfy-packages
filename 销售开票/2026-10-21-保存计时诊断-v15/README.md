# 销售开票 · 保存计时诊断 v15（2026-10-21）

## 附件

- 文件：`销售开票_保存计时诊断_改后v15.zip`（144,192 字节）
- SHA-256：`776b45021076d4a6a4dc87a60c34a8a68481a7ac4bc4a4d8d96adfa882dc384e`
- 基线：v14（完整包含 v11–v14 全部内容）。**功能与 v14 逐一等价，只加计时**；拿到读数后即被下一版取代，不要长期停留在此版。zip 本体按既定分工由 Alan 网页上传本文件夹。
- 附带：`建表SQL-XFY_SAVE_TIMING.sql`——**部署本包前先在 Oracle 执行**（独立新表，诊断结束可整表 DROP）。未建表也能保存，只是弹窗没有服务端分段。

## 为什么做这一版

v14 把一次保存的 DBUtil 往返从 14+2N 降到约 15 次（18 行单 50→15），Alan 现场实测同一张 18 品种单仅 **12s→10s**——剩余耗时不在往返次数，而在少数语句的库内执行与平台存盘内部。本版把一次保存按段计时拆开，为 v16 定点优化取证。两个前提（Alan 确认）：本表单**全部单据走 WMS**；**只有销售开票慢**，其他单据不慢——瓶颈在本表单保存链内部。

## 计时段（弹窗一次汇总，带 (v15诊断) 标记）

- 客户端 3 段：cli_check（保存前检查）、cli_save（sys_save 总耗时：平台一单六表存盘含 WmsOutMt/Dt + 服务端钩子）、cli_total。
- 服务端 16 段：bs_total / **bs_wmschk**（WMS 同步校验分支）/ **bs_b6**（SaleOrderDt 回滚重语句，单独段）/ bs_updord / bs_updsrc；am_total / am_settle / am_updsrc（pf_updSrcBill）/ am_chknum / **am_wmsoccu**（srv_regGoodsOccu，WMS 库存占用登记）/ am_prom；as_total / **as_wmsmeas**（wmsmeas 件装查）/ as_ecproc / as_ecchk / as_ls（lastsaledt 回写块）。条件段缺席 = 该分支未执行，本身即路径证据；每行另带 flags 运行时属性原值。
- 回传通道（取证后选型）：sys_save 返回值、数据集回填均无已证通道 → 服务端在 after_save 末尾写一行到 XFY_SAVE_TIMING（仅此 1 次额外往返、在 as_total 收口之后），客户端保存后按单号经 props 只读宏 sql_xfy_timing 读回。全部计时代码 try/catch 吞异常，计时坏掉不影响保存（mock 实证）。

## WMS 路径基线重算（修正 v14 口径，18 行）

- v14 代码、WMS 路径：我方 DBUtil 调用 ≈15 次（与线下模型相同）、SQL 语句 = 50 条；v13 同口径为调用 50 次、语句 68 条（v14：调用 −70%、语句 −26%）。
- v14 公式里的 W 指 lastsaledt 写入行数、不是 WMS 增项；WMS 路径没有随行数增长的额外往返，差异只有常数级/平台级三处：among 多 srv_regGoodsOccu 平台调用、平台存盘多写 WmsOutMt/Dt 两表、v13 时代 WMS 分支多 1 次重复查询（v14 已消除）。
- B6 语句分析与"聚合只算一次"的 MERGE 等价改写候选已备在变更文档第四节，等 bs_b6 读数点名后在 v16 启用。

## 源码与文档（在 -xfyproject 仓库）

- 源码：`forms/3b158nm6d7jro17p/save-timing-v15/`（main.js、server.js、props.json、建表SQL-XFY_SAVE_TIMING.sql）
- 段定义、通道取证、WMS 重算、B6 分析、v16 候选与读数解读：`docs/changes/2026-10-21-销售开票保存计时诊断v15.md`

## 现场验证点（只做一件事）

1. 先执行随包建表 SQL，再部署本包；
2. 用平时那张 **18 品种单保存一次**，把保存成功后弹出的分段窗口**整段拍照发回**（或抄下各段数字）。其余不用做。
3. 顺带确认：保存结果、校验拦截、提示与 v14 完全一致（本版行为等价红线）；若弹窗显示"服务端分段未取到"，先确认建表 SQL 已执行、再存一次。
