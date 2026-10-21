-- =====================================================================
-- 销售开票保存优化 · 可选 DBA 索引建议（2026-10-21，配合 v14 表单包）
-- 性质：可选、独立于表单包，不装包也生效，装包不依赖它。
-- 执行前务必先跑文末的现状查询，确认索引不存在再建；建索引时机与
-- 必要性请 DBA 结合现场执行计划评估，本文件仅是候选清单。
-- 适用库：Oracle（现场口径）。均为普通 B-tree 索引，不含唯一约束。
-- =====================================================================

-- 1) k_lastsaledt(EntId, ClientId, GoodsId)
--    after_save 每次保存都要按 (企业, 客户, 商品) 查存在性并回写最后售价；
--    v14 已把逐行 count 合并为一次 IN 查询，但该表若无此索引仍是全表扫描。
CREATE INDEX IDX_KLASTSALEDT_ECG ON K_LASTSALEDT (ENTID, CLIENTID, GOODSID);

-- 2) SaleNotesDt(BillNo, EntId, RfBillNo, RfBillSn)
--    before_save 修改保存时按本单 BillNo 聚合 SaleNotesDt 回滚订单执行量，
--    delete_bill 同口径反冲；按来源单 (RfBillNo, RfBillSn) 的汇总也走此表。
CREATE INDEX IDX_SALENOTESDT_BILL_RF ON SALENOTESDT (BILLNO, ENTID, RFBillNO, RFBILLSN);

-- 3) KT_LYOUTDT(BillNo, BillSn)
--    before_save 的 Upd_SrcBill/Upd_Order 按 (BillNo, BillSn) 逐行回写领用单。
CREATE INDEX IDX_KTLYOUTDT_BS ON KT_LYOUTDT (BILLNO, BILLSN);

-- 4) K_ClientSaleZone(EntId, GoodsId, AngleId, OwnerId)
--    after_save 删除一次性限销记录时按 (EntId, GoodsId, AngleId, OwnerId, ClientId)
--    与 SaleNotesDt/SaleNotesMt 做 exists 关联。
CREATE INDEX IDX_KCSZ_EGAO ON K_CLIENTSALEZONE (ENTID, GOODSID, ANGLEID, OWNERID);

-- =====================================================================
-- 现状核查（先跑这个，已有等价索引就不要重复建）：
-- SELECT index_name, table_name FROM user_indexes
--  WHERE table_name IN ('K_LASTSALEDT','SALENOTESDT','KT_LYOUTDT','K_CLIENTSALEZONE');
-- SELECT index_name, column_name, column_position FROM user_ind_columns
--  WHERE table_name IN ('K_LASTSALEDT','SALENOTESDT','KT_LYOUTDT','K_CLIENTSALEZONE')
--  ORDER BY index_name, column_position;
-- =====================================================================
