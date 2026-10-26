# 客户资料导入（销售版）v1（2026-10-26）

客户资料的「销售模板导出 + Excel 导入」新表单，路线 B1：以原厂客户资料导入 3mqc4alvb0m9rvhh 实例真值克隆扩改，原厂本尊不动。设计定案见 -xfyproject `docs/设计-客户资料导入销售版-2026-10-26.md`。

- 交付物：`客户资料导入（销售版）_v1.zip`（24,656 B，SHA-256 `4d89d50972a53536a68a78d7e3504388a86a7c81251358fdf3e9d629fc97ca6e`；内层 iform `hoi5z8fazwvvmr5v_00000000000.iform` SHA-256 `23d3381aea3419b9d83bb4b0d4069f319eb50161d1ac861678c8690eeee62123`）。**zip 本体待 Alan 网页上传至本文件夹**；本地原件在 `~/workspace/projects/xfy-project/work/2026-10-26-clientdoc-excel/build/`。
- 新 formid：`hoi5z8fazwvvmr5v`；表单名 `skzy.business.khdrxs`；暂存表 `t_hoi5z8fazwvvmr5v_ds_Client`。
- 内容：57 列模板（导出自带 EXAMPLE 示例行）→ 导入按列位置入暂存 → 回显标注新增/更新 → 全量逐行校验（R1–R12 + R-P2、9 列字典按名转码、存量户覆盖总纲：空不覆盖/白名单覆盖/名称与信用代码黑名单只出问题单）→ 合格户先落库、问题户整户拦截留网格 + 问题单网格/导出。落库五段：主表双数据集 saveDatasets + getIdentity 一号同赋、证照 BusiCert 14 组横排展开 upsert、联系人 ContactDoc 采购员/代理人补建、业务员归属 SalespersonDoc（不自动改挂、多账号 AUTO 按同业务来源频次定）、默认地址行 BusinessAdd 补建回填 DftAddId；新户 IsPass='N' 走首营、TaxNo 由 OrgCert 回填、经营范围 DictList/BusinessCont 双写。
- 配套包二（客户资料加一个入口项）在 `../../客户资料/2026-10-26-导入入口v1/`，导入顺序：先包二后包一，导入后关掉全部已打开页签再测。
- 自验：verify 47 项 / audit 221 项 / fixture 70 项断言全过（详见同文件夹《自验报告.md》）；平台运行时未证项见《现场验证清单.md》。
- 说明文档：同文件夹《成品说明.md》《现场验证清单.md》《自验报告.md》。
