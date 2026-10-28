# 销项开票申请单 v5.8（高价口径切换版）

- 基线：v5.7。高价开票方案 C 的申请单侧口径切换（设计：-xfyproject `docs/设计-财务高价开票改造-2026-10-28.md` 第三节第 4 条）。**本包必须与财务侧改包（15dka/登记子表单 4au48 高价取价）+ 存量迁移 SQL 同批上线，中间态不可单独运行。**
- 切换后口径：SaleOutDt.K_ApplyInvoiceAmt 存储 = 高价口径已申请额；已登记现算（InvoiceDt）= 高价口径；行高价额 = Round(Num × nvl(K_TaxPrice,0), 2)。
- 改动（其余成员与 v5.7 逐字节一致，main.xul 不新增字段）：
  - 六宏：dt/rdt 的 BalAmt 与行级余额过滤、mt/rmt 的 BalAmt 与 having 改开票口径（行高价额 − greatest(已登记现算, 已申请)，红字 sign/abs 同构）；qmt/qdt 状态 CASE 的「已开完」比较改已申请开票金额（已申请量 × 高价，行级/聚合级）；数量口径与 reg 现算子查询不动。
  - main.js：ThisAmt 单价来源 TaxPrice → K_TaxPrice（改量联动 + 蓝/红收集补值 3 处）；蓝/红收集的金额天花板基数 TaxAmount → K_InvoAmt（行高价额）。结算口径字段只展示、不再参与计算（"TaxPrice"/"TaxAmount" 读取残留 = 0，verify 已断言）。
  - server.js：uf_readRow 增读 K_TaxPrice（第 8 列）；保存金额天花板改行高价额 Round(Num × K_TaxPrice, 2)（红字取绝对值）；守卫表达式文本不动（其比较值在切换后天然同为高价口径）。
- 产物：`销项开票申请单_实例化表单_v5.8.zip` 24,698 B，SHA-256 `68232c34cbb3fb6b503aba3c114263d1ad683ecc73e38e603b5e33acdd431ae3`（iform `ab04ffdb…`）。zip 本体待 Alan 网页上传本目录。
- 离线校验（2026-10-28）：verify_package_v58.py 228 项断言全部通过（diff 分区 + 三路变换重构 + 别名↔字段有序相等 + 表头终检）；test_fixture_v58.js 269/269（新增 L22 清单用例组 24 项：条 13 余额高价口径、条 14 改量高价联动、条 16 正负混合汇总净额、条 17 负数行不可单独提交、条 19 状态四档高价推导）。未做活体验证，现场复测点见下。
- 存量迁移：-xfyproject `docs/迁移SQL-高价切换.sql`（执行前偏差抽查 + 高价缺失行抽查 + 申请侧公式重算 UPDATE + 登记侧存量计数；只备稿不自动执行）。
- 现场复测（与财务侧同批上线后）：导包关页签重开 → 蓝字申请一单：勾选带额 = 高价余额、改量后本次额按高价联动 → 保存后查询页状态/已申请开票金额对齐 → 红字同链 → 与财务登记（高价）后核对已开完状态。若个别行高价为 0，该行将无法申请（天花板为 0），属源数据缺高价，报单号再查。
- 源码：-xfyproject `docs/changes/2026-10-28-销项开票申请单v5.8口径切换.md`；构建/校验脚本在 work/2026-10-23-invoapply-package（build_v58.py / verify_package_v58.py / test_fixture_v58.js）。
