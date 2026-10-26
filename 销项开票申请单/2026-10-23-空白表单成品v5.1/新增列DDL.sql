-- ============================================================
-- 销项开票申请单 前置 DDL（v4 版，随三页签重建版交付，不由 Muse 执行）
-- 目标库：欣福源智友 V11（Oracle）。执行时机：低峰窗口、表单启用前。
-- 执行后须在平台数据字典中登记这四列（否则数据集/字典校验可能不认）；
-- 登记注释建议：K_ApplyInvoiceAmt=「已申请金额」、K_ApplyInvoiceNum=「已申请数量」、
-- K_ApplyUser=「申请人」、K_ApplyTime=「申请时间」。
--
--
-- 取证（2026-10-23）：参照表单 15dka 的红字页宏 S_RedInvoMt/S_RedInvoDt 数据源
-- 与蓝字同为 SaleOutMt/SaleOutDt（退货类单据，RuleId in
-- ('1w8bnrjr7c7no0bj','3cc08h3z7cnkrv2q')），不是发票登记表 InvoiceMt/Dt；
-- InvoiceMt（88 字段）/InvoiceDt（50 字段）逐项核查亦无可复用的闲置申请字段。
-- 红字申请与蓝字共用下面这套申请列（KF_KFPSQ + K_ApplyInvoiceAmt/Num，
-- 留痕共用 K_ApplyUser/K_ApplyTime），方向由单据 RuleId 区分——同一行物理上
-- 不可能同时是蓝字源与红字源，不会串账。红字落库为负数（与已登记额同符号空间）。
-- ============================================================

-- 明细：已申请额 / 已申请量（与既有 K_RegInvoiceAmt / K_RegInvoiceNum 对位）
ALTER TABLE SaleOutDt ADD (K_ApplyInvoiceAmt DECIMAL(14,2) DEFAULT 0 NOT NULL);
ALTER TABLE SaleOutDt ADD (K_ApplyInvoiceNum DECIMAL(14,4) DEFAULT 0 NOT NULL);

-- 单头：最近一次申请留痕（申请人 / 申请时间）
ALTER TABLE SaleOutMt ADD (K_ApplyUser CHAR(11));
-- 平台字典类型 datetime 在 Oracle 中对应 DATE
ALTER TABLE SaleOutMt ADD (K_ApplyTime DATE);

-- 执行后自查（两条都应返回 0 行 NULL）：
-- SELECT COUNT(*) FROM SaleOutDt WHERE K_ApplyInvoiceAmt IS NULL OR K_ApplyInvoiceNum IS NULL;
-- SELECT COUNT(*) FROM SaleOutMt WHERE K_ApplyUser IS NULL AND K_ApplyTime IS NOT NULL;

-- 回滚（如需）：
-- ALTER TABLE SaleOutDt DROP COLUMN K_ApplyInvoiceAmt;
-- ALTER TABLE SaleOutDt DROP COLUMN K_ApplyInvoiceNum;
-- ALTER TABLE SaleOutMt DROP COLUMN K_ApplyUser;
-- ALTER TABLE SaleOutMt DROP COLUMN K_ApplyTime;
