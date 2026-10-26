# 销项发票申请（财务）闸口包 v1（2026-10-26）

**现行交付版**——把《财务表单15dka自改清单》落成的可导入成品包：Alan 不在 Studio 里手工改了，直接导包。

- 交付物：`销项发票申请_财务闸口版_v1.zip`（28,275 B，SHA-256 `b3eee3ec01267fb1e21deb568a4f48abde0298051abcc2d94d9df43747e7eaf9`；内层 iform `15dka0cl3kvd44y9_00000000000.iform`，28,401 B，SHA-256 `481d604ba339653f831d5bdd372059325a30372c09cbab441622c033211887f5`）。**zip 本体待 Alan 网页上传至本文件夹**；本地原件在 `~/workspace/projects/xfy-project/work/2026-10-23-invoapply-package/`。
- 对象：财务的销项发票申请 `15dka0cl3kvd44y9` **实例版**（orgid=`00000000000`，基线 version 1.1.82.292 服务器真值），覆盖导入同一表单、身份不变。效果：财务只看得到、只开得了开票员已申请的量/额，可登记 = 已申请 − 已登记；未申请的行/单不出现；手动登记发票页签保留应急旁路、不设闸。
- 改动（与基线的全部差异，零夹带——出包时以「换回旧值后逐字节全等」断言自证）：props.json 仅四条宏 sql 共 21 处（S_BlueInvoMt 4 / S_BlueInvoDt 7 / S_RedInvoMt 3 / S_RedInvoDt 7）：可登记基数换 `nvl(已申请,0) − nvl(已登记,0)`、exists 换申请口径（K_ApplyFlag 或申请额非 0 且 abs(申请)>abs(登记)）、蓝 Mt having 同步、明细新增已申请量/额别名、蓝 Dt 行条件换「申请>已登记」；**其中红 Dt 4-6 是唯一行为新增项**（原宏无行级出现条件，新增 `abs(nvl(申请,0)) > abs(nvl(登记,0))` 一行）。main.xul 仅 6 个数据集 format blob：标题归位 9 处（K_RegInvoiceAmt/Num 误挂的「已申请」改回「已登记」）+ 蓝/红四数据集新增真·已申请字段 6 个。
- 不动：main.js（清单逐处判定六处勾选校验全不改）、server.js、desc.html、S_InvoReg 两宏及其余 10 条宏、未改 5 个数据集 format blob（原字节保留）。
- 验证：独立复验脚本 94 项全过（反向解包、未点名宏逐字断言、四宏 diff 与清单改文逐字对账、标题/新字段逐核、引用完整性、括号配平、XML/JSON 可解析）；如实标注两点——改动的 6 个 format blob 按既往惯例 Python gzip(mtime=0) 重编码（原 .NET 产物字节不同，平台解压读取、内容逐字对账）；本机无 Oracle，未做活体 SQL 执行，导入后按说明 §五验收。
- 导入注意（详见《财务闸口包说明.md》）：先跑红字预检 SQL（已登记退货行量/额须全为负数，有正数存量先停下反馈）→ 导出原包备份 → 覆盖导入**实例**版 → 验收。⚠️ 导入即生效：无申请记录的存量未开票单会立刻从蓝/红列表消失（补申请后重现），避开财务集中开票时段切换。验收含 60/100 部分申请场景（已申请列=60、可登记=60、登记后递减、未申请单不出现）。
- 源码/过程存档：-xfyproject `docs/changes/2026-10-26-财务表单闸口包v1.md`；构建/复验脚本与 diff 在 xfy-project `work/2026-10-23-invoapply-package/gate15/`（build_gate15.py / verify_gate15.py / macro_diffs.txt）；改动清单原文《财务表单15dka自改清单.md》同目录。
