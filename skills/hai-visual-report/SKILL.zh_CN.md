# Hai Visual Report 中文版

本文件是中文阅读版；执行规则以 `SKILL.md` 为准。

## 概览

用这个 skill 把想法、需求、方案、评审结果或目标文档做成可阅读、可展示的 HTML 可视化报告。

它不是 `create-visual-card`。视觉卡片是单屏摘要，适合传播；`hai-visual-report` 是多 section 报告，适合看清结构、判断、权衡、路线和证据。

## 核心原则

先把结构可视化，再把文案写漂亮。

不要直接堆段落。先找出核心判断、对象、结构关系、路径、风险和验证方式，然后变成可扫读的 HTML 页面。

## 何时使用

- 需要 visual report / 可视化报告 / HTML report。
- 给想法或需求做一份可展示的网页报告。
- 像 architecture review 那种 HTML artifact。
- 把 PRD、goal、方案、评审结果视觉化。
- 需要 report，不是单张卡片。

## 报告结构

默认包含标题、范围、结论、结构图、核心 section、决策矩阵、阶段/时间线、风险与证明、下一步。

## 工作流

1. 判断报告类型：idea、requirement、goal、review、architecture-style。
2. 提炼核心判断。
3. 选择可视化结构：Mermaid、timeline、options matrix、risk grid、scope panels、phase table。
4. 写完整 HTML 文件，优先放系统临时目录。
5. 做视觉 QA：首屏能看到结论和结构，图可读，文本不溢出，不做成单张长卡片。

## 常见错误

- 只写 Markdown，不产出 HTML。
- 把 report 做成单张 visual card。
- 视觉很花，但读者看不出结论和下一步。
- Mermaid 图太密。
- 没有区分事实、判断和假设。
