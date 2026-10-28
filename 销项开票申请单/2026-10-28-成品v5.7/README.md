# 销项开票申请单 v5.7（开票金额/结算金额）

- 基线：v5.6。按商务部需求清单 12/13 条 + Alan 口径：开票金额 = 高价口径（高价 × 数量），结算金额 = 含税金额。申请页（蓝/红）与查询页都加。
- 明细（ds_dt/ds_rdt/ds_qdt）新增三列（紧随结算金额之后）：高价 K_TaxPrice（SaleOutDt.K_TaxPrice，字典名「实际含税价」，本站业务用作高价，与销售开票 GJ 折扣同列）、开票金额 K_InvoAmt = Round(数量 × 高价, 2)、已申请开票金额 K_ApplyInvoAmt = Round(已申请量 × 高价, 2)。
- 主表（ds_mt/ds_rmt/ds_qmt）新增两列（紧随已申请金额之后）：开票金额、已申请开票金额（逐行 Round 后汇总）。
- 六个数据集 TaxAmount 标题由「含税总价」改名为「结算金额」（字段 id 与值不变，口径就是含税金额）。两个打印模板均未绑该标题，不受影响；退货协议绑的「含税单价」未动。
- 纯展示改动：已申请额的校验、登记对账、状态推导仍走含税（结算）口径；main.js/server.js/参照宏逐字节不动；六宏与六 format 同位序插入，别名↔字段集有序相等经 verify 硬校验。
- 产物：`销项开票申请单_实例化表单_v5.7.zip` 24,516 B，SHA-256 `75547ee2b6e6ef8b43e424ad8293ef83f1f6e6476e46d88d4c27f56492e9453a`（iform `0a08de4b…`）。zip 本体待 Alan 网页上传本目录。
- 校验：verify_package_v57.py 全部通过；fixture 245/245（新增 L21 二十八项）。
- 现场复测：导包关页签重开 → 蓝/红申请页与查询页核对新列（开票金额应 = 数量 × 高价；红字为负数）；若个别行高价显示 0，是该出库行 K_TaxPrice 本身为空，属源数据问题，报单号再查。
- 源码：-xfyproject `docs/changes/2026-10-28-销项开票申请单v5.7开票金额结算金额.md`；构建/校验脚本在 work/2026-10-23-invoapply-package（build_v57.py / verify_package_v57.py / test_fixture_v57.js）。
