# hai-stack

> 一个专门放 `skills` 的小仓库。先把事情做小、做清楚，再把结果做得好看。

`hai-stack` 是一组面向 AI 编程助手的技能集合，覆盖视觉卡片生成、代码质量审查、组件架构诊断、文档一致性检查等场景。

## 这是什么

这是一个很轻的 `skills` 集合，不是完整应用，也不是脚手架工程。

这里的重点不是”搭一套复杂系统”，而是把单个能力做成清晰、可复用、可直接拿来用的技能文件。每个技能独立成目录，按需安装。

## 快速安装

如果你是放进 OpenClaw 里用，最直接的方式是把这个仓库里的技能目录放到 OpenClaw 的 `skills` 目录中。

常见位置通常是：

- `<workspace>/skills/`
- `~/.openclaw/skills/`

你要安装的技能名是：

- `visual-card`
- `react-component-diagnosis`
- `clean-code-reviewer`
- `ast-grep-rule-crafter`
- `doc-consistency-reviewer`
- `readme-beautifier`

安装完成后，OpenClaw 就能在后续对话里识别并使用这个技能。

## 怎么用

最自然的用法不是记命令，而是直接对助手说清楚你的目标。

例如：

```text
请你帮我阅读这篇文章，最后生成一张视觉卡片。
```

或者：

```text
请你帮我阅读这份内容，提炼重点，最后生成视觉卡片。
```

如果你已经知道材料来源，也可以直接这样说：

```text
请你帮我阅读 xxx，最后生成视觉卡片。
```

这个技能更适合“先理解内容，再整理成卡片”的工作流，而不是只做一张空壳模板。

## 当前包含

| 名称 | 用途 |
| --- | --- |
| `visual-card` | 把内容做成视觉卡片，输出独立 HTML，并支持导出 PNG |
| `react-component-diagnosis` | 从 7 个维度深度诊断 React 组件架构质量，输出结构化评分报告 |
| `clean-code-reviewer` | 基于《代码整洁之道》原则，从命名、函数、DRY、YAGNI 等 7 个维度审查代码质量 |
| `ast-grep-rule-crafter` | 用 ast-grep YAML 编写 AST 级别的代码搜索与重写规则 |
| `doc-consistency-reviewer` | 系统性检查文档与代码实现的一致性，找出过时或错误的描述 |
| `readme-beautifier` | 修复 README 的结构混乱和格式不统一问题，输出专业规范的版本 |

## 目录结构

```text
skills/
  visual-card/
    SKILL.md
    scripts/
      screenshot.mjs
  react-component-diagnosis/
    SKILL.md
  clean-code-reviewer/
    SKILL.md
    references/
      detailed-examples.md
      language-patterns.md
  ast-grep-rule-crafter/
    SKILL.md
    references/
      rule-syntax.md
      common-patterns.md
  doc-consistency-reviewer/
    SKILL.md
    references/
      checklist.md
      output-format.md
  readme-beautifier/
    SKILL.md
```

## 运行要求

这个仓库当前没有额外的工程封装，核心依赖很少。

- 需要 Node.js 来运行截图脚本
- 需要 Playwright 才能把 HTML 截成 PNG

如果只是查看技能说明文件，不需要额外安装别的东西。

## 结构约定

- 每个技能放在自己的目录里
- 每个技能有独立的 `SKILL.md`
- 需要配套工具时，放进自己的 `scripts/`
- 需要参考资料时，放进自己的 `references/`
