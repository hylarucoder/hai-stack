# Hai Visual Report 中文版

本文件是中文阅读版；执行规则以 `SKILL.md` 为准。

## 描述

从想法、需求、PRD、目标、评审、架构议题、计划或方案，生成一份完整、自包含的多 section HTML 报告——标题 + 一句话结论、Mermaid 结构图、决策矩阵、风险/证明表、下一步行动块——并返回生成的文件路径。当用户想把内容变成可视化报告、可视化页面、HTML report、网页版、dashboard 或类似 PPT/幻灯片的网页时使用；即使只是随口说也要触发：可视化一下、做个可视化、做成网页、做个网页版、把这个评审做成网页、做成一页 HTML、输出 HTML、做个汇报页/展示页、做成 PPT 样子的网页、弄个好看点的报告、整理成一份报告页面、带 mermaid 图的报告，以及 render this as a page/webpage、make it visual/interactive、turn my analysis into slides-like html、dashboard of this（含 html repot / viz report 这类拼写错误）。当内容是多 section、需要结构、权衡、路线、风险和证据，而不是一张可传播的卡片时，优先用本 skill 而不是 create-visual-card。

## 概览

把想法、需求、方案、评审结果或目标文档做成可阅读、可展示的多 section HTML 报告——一个真实的 `.html` 文件，带标题、结论、图表、矩阵、各 section 和下一步。

先排除两个最常见的误判：

- 它不是 `create-visual-card`。视觉卡片是单屏摘要，适合传播；`hai-visual-report` 是多 section 报告，适合看清结构、判断、权衡、路线、风险和证据。
- 它也不是只写 Markdown 的回答。用户要的是生成出来的 HTML 文件，不是一段散文。

## 核心原则

先把结构可视化，再把文案写漂亮。

拿到想法或请求，不要直接堆段落。先找出核心判断、对象、结构关系、路径、风险和验证方式，再把它们变成可扫读的 HTML 页面。

## 报告结构

这是唯一的标准结构。默认报告包含这八个块（只能在说明理由后删减某一块）：

1. **标题**：标题、范围、生成日期。
2. **结论**：一句话结论和最重要的判断。
3. **结构图**：Mermaid 或布局图，表达对象、关系、流程或决策路径——放在靠前位置，作为读者的坐标系。
4. **核心 section**：问题、目标、方案、用户、流程、架构、权衡、风险或其它相关主题。每个 section 至少带一个可视化对象（图、表、矩阵、stepper、callout 或 checklist）。
5. **决策矩阵**：选项、风险、成本、价值或优先级。
6. **时间线 / 阶段**：涉及执行时给出阶段、退出证明和下一步。
7. **风险与证明**：关键风险、验证方式、通过/不通过信号。
8. **下一步**：明确的下一步行动。

每个块的可视化形式从内容本身选：复杂关系画 Mermaid 图，清晰流程做 timeline 或 stepper，选项对比用矩阵，风险用 grid，范围用 included/excluded 面板。

## 工作流

1. **判断报告类型**，它决定八个块的侧重：
   - Idea 报告：想法价值、机会成本、验证路径。
   - Requirement 报告：需求结构、范围、验收、风险。
   - Goal 报告：目标、阶段、todos、验证。
   - Review 报告：问题、证据、建议、优先级。
   - Architecture-style 报告：当前链路、边界、选项、why-not、红蓝评审。

2. **提炼核心判断**（应用核心原则）。写下这份报告最想让读者记住的那一点，以及最重要的对象、关系、冲突、风险或决策。信息缺失时声明假设而不是编造事实，并让事实、假设、判断三者在视觉上区分清楚。

3. **下笔前先读输出形态。** 打开 `references/output-template.md` 看交付格式，打开 `references/html-skeleton.md` 看八个块的 Tailwind + Mermaid 最小骨架，对着目标产出，而不是每次现编页面布局。

4. **写 HTML。**
   - 输出一个完整的 `.html` 文件。
   - 优先放系统临时目录，如 `$TMPDIR/hai-visual-report-<topic>/`；用户指定路径时按用户的来。
   - CSS、JS 内联或走 CDN（Tailwind CDN、Mermaid CDN 都行）；除非用户要求，不要依赖项目本地资源，这样 `.html` 才是一个可直接打开或发送、无需构建的单一可移植文件。
   - 中文请求用中文 UI 文案，英文请求用英文 UI 文案。代码标识符保持不变。

5. **QA 后返回路径**（见下方 QA）。交付生成的 `.html` 的绝对路径。

### 样式约束

- 安静、专业的报告风格，不是营销落地页。
- 卡片只用于重复出现的发现、选项、风险、指标或 callout。
- 如果报告来自架构评审，保留 architecture-map-first、选项矩阵、why-not 备选、红蓝对抗评审（判断本身仍归 `hai-architecture`——见下）。

## 输出

在回复中交付这个骨架，并实际写出文件：

```
## Report Type
<idea / requirement / goal / review / architecture-style / custom> — <一句话>

## Core Judgment
<这份报告最想让读者记住的判断>

## Generated HTML
`<.html 的绝对路径>`

## QA
- HTML 已生成：yes/no
- 结论 + 结构图 + 下一步首屏可见：pass/issue
- Mermaid 可读（太密就拆）：pass/issue/omitted because <原因>
- 是多 section 页面而非一张长卡片：pass/issue
- 文本不溢出卡片或按钮：pass/issue
- 事实与假设已区分：pass/issue
```

定稿前先读 `references/output-template.md`；上面的内联骨架是它的摘要。

## 两个要避免的坑

- 页面很花，却把结论和下一步藏起来了。可读性和判断优先于装饰。
- 把事实、假设、判断混在一起，读者分不清哪个是哪个。

## 何时改用别的 skill

- 用户要的是单张视觉卡片、信息卡、社交卡或单屏摘要——用 `create-visual-card`。
- 用户要的是架构级判断（APoSD/Ousterhout 评审、模块边界批评）——用 `hai-architecture`。即使他同时想要 HTML，架构判断也归 `hai-architecture`；本 skill 负责渲染报告，不产出架构结论。
