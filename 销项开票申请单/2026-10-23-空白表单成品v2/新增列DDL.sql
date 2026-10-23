-- ============================================================
-- 销项开票申请单 前置 DDL（随表单 1qnyaq9q8shnwbas 交付，不由 Muse 执行）
-- 目标库：欣福源智友 V11（Oracle）。执行时机：低峰窗口、表单启用前。
-- 执行后须在平台数据字典中登记这四列（否则数据集/字典校验可能不认）。
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
