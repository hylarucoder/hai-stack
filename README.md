# hai-stack

> 一个专门放 `skills` 的小仓库。先把事情做小、做清楚，再把结果做得好看。

`hai-stack` 是一组面向 AI 编程助手的技能集合，覆盖视觉卡片生成、代码质量审查、组件架构诊断、文档一致性检查等场景。

## 这是什么

这是一个很轻的 `skills` 集合，不是完整应用，也不是脚手架工程。

这里的重点不是”搭一套复杂系统”，而是把单个能力做成清晰、可复用、可直接拿来用的技能文件。每个技能独立成目录，按需安装。

## 快速安装

克隆仓库后，运行 `make link` 即可将所有技能以符号链接的方式安装到 `~/.claude/skills/` 和 `~/.codex/skills/`：

```bash
git clone https://github.com/hylarucoder/hai-stack.git
cd hai-stack
make link
```

其他管理命令：

```bash
make status   # 查看各技能的安装状态
make unlink   # 移除所有符号链接
```

新增技能后再跑一次 `make link`，已安装的会自动跳过。

## 怎么用

最自然的用法不是记命令，而是直接对助手说清楚你的目标。例如：

```text
帮我用 APoSD 的视角 review 一下这个模块的设计
帮我诊断一下这个 React 组件的架构质量
这个变量叫什么名字好？帮我起个名
帮我检查一下代码质量，看看有没有 code smell
这个 PRD 是不是太大了，需要拆吗？
对照这份 PRD，检查一下数据模型字段是否对齐
帮我检查 README 和代码有没有不一致的地方
帮我美化一下这个 README
请你阅读这篇文章，最后生成一张视觉卡片
```

这些技能会在 AI 助手识别到意图后自动激活，不需要记特定命令。

## 技能一览

### 设计与架构

| 名称 | 用途 | 收益 |
| --- | --- | --- |
| `aposd-reviewer` | 基于《软件设计哲学》(APoSD) 的深度设计审查，检测浅模块、信息泄漏、透传层等反模式 | 在架构决策阶段就消灭复杂性，而不是等它扩散后再补救 |
| `react-component-diagnosis` | 从使用者 API、数据流、可测试性、可扩展性、性能、心智模型、边界契约 7 个维度诊断组件架构 | 一次诊断定位组件的结构性问题，避免反复重构 |
| `naming-consultant` | 命名顾问——给变量/函数/模块/类型起名，或审计现有命名的模糊、不一致和误导问题 | 好的命名就是好的设计，减少"读代码猜意图"的时间 |

### 代码质量

| 名称 | 用途 | 收益 |
| --- | --- | --- |
| `clean-code-reviewer` | 基于《代码整洁之道》原则，从命名、函数大小、DRY、YAGNI、魔法数字等 7 个维度审查代码 | 系统化的代码体检，而不是凭经验零散挑问题 |
| `ast-grep-rule-crafter` | 用 ast-grep YAML 编写 AST 级别的代码搜索与自动重写规则 | 把一次性的手工查找替换变成可复用的 lint 规则，杜绝同类问题再犯 |

### 产品与建模

| 名称 | 用途 | 收益 |
| --- | --- | --- |
| `prd-splitter` | PRD 粒度顾问——判断一个需求该拆成多个 PRD 还是合并，提供 6 维决策框架 | 避免 PRD 过大导致交付失控，或过小导致上下文碎片化 |
| `entity-model-auditor` | 对照 PRD 审计实体数据模型，逐字段对比目标设计与当前实现，输出迁移变更清单 | 在开发前就对齐 PRD 和数据库，减少联调阶段的返工 |

### 文档与展示

| 名称 | 用途 | 收益 |
| --- | --- | --- |
| `doc-consistency-reviewer` | 系统性检查代码实现与文档说明的一致性，找出过时或错误的描述 | 文档与代码永远同步，新人不再被过时的 README 误导 |
| `readme-beautifier` | 修复 README 的结构混乱和格式不统一问题，输出专业规范的版本 | 一键美化，不用再纠结排版细节 |
| `visual-card` | 把内容做成视觉卡片，输出独立 HTML，并支持导出 PNG | 快速把文字变成可分享的精美卡片，适合社交传播和笔记归档 |

## 目录结构

```text
skills/
  aposd-reviewer/          # 软件设计哲学审查
    SKILL.md
    references/
  ast-grep-rule-crafter/   # AST 搜索重写规则
    SKILL.md
    references/
  clean-code-reviewer/     # 代码整洁度审查
    SKILL.md
    references/
  doc-consistency-reviewer/ # 文档一致性审查
    SKILL.md
    references/
  entity-model-auditor/    # 实体模型审计
    SKILL.md
  naming-consultant/       # 命名顾问
    SKILL.md
  prd-splitter/            # PRD 粒度顾问
    SKILL.md
  react-component-diagnosis/ # React 组件诊断
    SKILL.md
  readme-beautifier/       # README 美化
    SKILL.md
  visual-card/             # 视觉卡片生成
    SKILL.md
    scripts/
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
