# Hai Visual Explainer 中文版

本文件是中文阅读版；执行规则以 `SKILL.md` 为准。

## 用途

把想法、PRD、计划、评审、架构议题或其他有实质内容的来源做成自包含的 HTML 与 PNG。根据内容选择结构图、矩阵、证据、风险和下一步，同时保留原始含义。

支持 **card**（单张卡片）和 **report**（多节长报告）两种模式；本 skill 负责展示，不替代 `hai-architecture`、`hai-prd` 等判断 skill 生成专业结论。

## 核心原则

在用户要求的范围内保留来源含义，同时改善导航、重点和阅读顺序。可以为清晰度改写、重排或删除真实重复，但不能擅自把完整文档压成一页 bullet 摘要；用户明确要求摘要卡片时可以提炼，但仍需保留限定条件。视觉元素服务内容，不是删内容的借口。输入只是原始想法时，要把用户事实、假设和新增判断分开。

## 选择模式

- **card**：信息卡、知识卡、金句、社交分享图、摘要或封面。读取 `references/card-design.md`，从 `assets/card-template.html` 开始，按低/中/高密度选择大字、均衡分区或报纸网格。保留请求范围内的要点与限定条件，不能为塞进一张图擅自删减原意。
- **report**：完整文档或多节汇报。使用下方内容模型及报告模板。
- 根据用户要的产物判断，不要求用户选择内部模式。完整文档不能擅自压成卡片；一张卡片也不扩写成长报告。

## 报告可选内容块

按内容选择，不输出空洞或仪式化 section：

1. Header：标题、范围、生成日期。
2. Verdict：只有来源本身有结论时才提前展示。
3. Structure Map：参与者、关系、流程或决策路径。
4. Core Sections：承载原始实质；关系、比较、顺序、层级或证据复杂时才加可视化。
5. Decision Matrix：选项、成本、价值和风险。
6. Timeline/Phases：执行阶段与退出证明。
7. Risks and Proof：风险、验证方式与通过/失败信号。
8. Next Move：明确下一动作。

## 工作流

1. 先选择 card 或 report；卡片说明密度与布局，报告判断类型：idea、requirement、goal、review、architecture-style 或 custom。
2. 阅读完整来源，映射 section 和关键点，再决定哪里真正需要图、矩阵、stepper 或强调。信息缺失时写明假设，不造事实。
3. 报告写之前读取 `references/output-template.md` 和 `references/html-skeleton.md`；卡片读取上述设计参考和 `references/card-output-template.md`。
4. 生成一个完整 `.html`。用户给路径就遵循；否则用 `mktemp -d` 创建唯一临时目录。CSS/JS 内联或使用 CDN，保持无需构建即可打开。
5. QA：
   - 有 Mermaid 时运行 `node scripts/lint_mermaid.js <file.html>`，修完所有 `ERR`，对密度 warning 做简化判断。
   - 统一脚本：报告运行 `node scripts/render_report.mjs <file.html> --mode report` 截全页；卡片运行 `node scripts/render_report.mjs <file.html> --mode card`，自动测量 `.card` 宽度并以 2 倍像素截图。检查 PNG 中的图表失败、溢出、裁切、字号与层级。
   - 浏览器不可用时明确说明视觉 QA 未完成，不冒充通过。

## Mermaid 安全

包含 `/`、括号、方括号、花括号、`<>`、`&`、`:` 或 `#` 的 label 用双引号包住，例如 `A["Timeline / Phases"]`。仍有问题时使用 HTML entity。静态 linter 只是预检，真实浏览器渲染才是最终视觉证据。

## 报告样式

- 安静、专业的报告样式，不做营销 landing page。
- 卡片只用于重复 findings、选项、风险、指标或 callout。
- 架构报告保留 map-first、选项、why-not 和红蓝对抗，但判断仍由 `hai-architecture` 负责。

## 输出

报告使用 `references/output-template.md`，卡片使用 `references/card-output-template.md`（检查正文 ≥ 18px、手机可读性和视觉层级，可用时内联展示 PNG），返回真实 HTML 和预览 PNG 路径、内容保真状态与实际完成的 QA。没有运行的检查不能声称 pass。

## 避免

- 用更短的摘要替代原文实质。
- 把事实、假设与判断混在一起。
- 为每个 section 强塞一个无意义视觉元素。
- 用户只要一张卡片时生成长报告。
