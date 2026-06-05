# hai-stack

> 一套面向 AI 编程助手的工作方法论：先判断，再定义；先写清楚，再执行；先验证，再交付。

`hai-stack` 不是一堆零散的 prompt，也不只是一个 skills 目录。它是一套让 AI 助手更像可靠合作者的工作系统：帮助你判断想法、定义 PRD、写清目标、审视架构、用测试驱动实现、同步文档，并把关键结论变成可读的报告。

## 这是什么

这是一个很轻的 `skills` 仓库，不是完整应用，也不是脚手架工程。

它的核心价值不是“多几个命令”，而是把一套工作方法固定下来：

- **先判断价值**：一个想法是不是值得做，不能只靠兴奋感。
- **先定义边界**：PRD、Goal、架构、文档，各自承担不同层面的真相。
- **先写清楚再执行**：不要一边跑一边看，先把目标、阶段、规则和验证写下来。
- **用反复验证抵抗幻觉**：测试、审计、证据、验收标准都要明确。
- **让输出可交付**：报告、卡片、文档和结论要能被别人读懂和复用。

这些 skill 服务的是同一个目标：**降低和 AI 协作时的随意性，让想法、需求、实现和文档都能被检查、被验证、被继续推进。**

## 方法论

`hai-stack` 的工作流可以理解成一条从想法到交付的链路：

```text
Idea → PRD → Goal → Architecture → TDD → Audit → Report
```

每一步都有一个明确问题：

| 阶段 | 核心问题 | 对应能力 |
| --- | --- | --- |
| Idea | 这个想法是不是好主意，值得投入吗？ | hai-idea |
| PRD | 是否需要 PRD？边界和粒度怎么定？ | hai-prd |
| Goal | 开始做之前，目标、阶段、todo 和验证是什么？ | hai-goal |
| Architecture | 设计是否把复杂度藏在正确边界里？ | hai-architecture |
| TDD | 行为是否先被测试定义，再被实现？ | hai-tdd |
| Audit | 文档内部是否一致？文档和代码是否一致？ | hai-audit-docs-internally / hai-audit-docs-against-code |
| Report | 关键判断能不能被清楚展示和复用？ | hai-visual-report |

这条链路不是强制流程。它的作用是让你在任何阶段都能问对问题：该判断时不急着写 PRD，该写目标时不急着动手，该验证时不靠感觉过关。

## 能带来什么

对使用者来说，这套方法论带来的不是“AI 回答更长”，而是：

- **减少无效投入**：先用 `hai-idea` 判断想法值不值得，而不是每个点子都进入执行。
- **减少需求返工**：用 `hai-prd` 判断是否需要 PRD、PRD 粒度是否合理、验收是否可验证。
- **减少一边做一边改方向**：用 `hai-goal` 把目标、阶段和 proof 写清楚。
- **减少架构局部最优**：用 `hai-architecture` 从复杂度、边界和信息隐藏审视系统。
- **减少“补测试式自我安慰”**：用 `hai-tdd` 先看测试失败，再写最小实现。
- **减少文档失真**：用文档审计 skill 保持文档内部一致，并让文档跟代码同步。
- **减少结论不可传播**：用 `hai-visual-report` 和 `create-visual-card` 把复杂内容变成能展示的产物。

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

## 语言约定

- `SKILL.md` 是执行源文件，主体内容使用英文。
- `SKILL.zh_CN.md` 是中文阅读版本，用于团队理解和文案打磨。
- 两者冲突时，以 `SKILL.md` 为准。
- frontmatter `description` 可以包含少量中文触发词，帮助中文请求匹配。
- 用户可见输出模板可以根据技能场景使用中文。
- 新增或重命名 `hai-*` skill 时，必须同时提供 `SKILL.md` 和 `SKILL.zh_CN.md`。

## 怎么用

最自然的用法不是记命令，而是直接对助手说清楚你的目标。例如：

```text
帮我从架构层面 review 一下这个模块的设计
帮我把格局打开，不要被兼容性和重构成本吓住
帮我把这个想法设计成一份 PRD
这份 PRD 有点局部修补的感觉，帮我从整篇文档角度打磨一下
这份 PRD 里面有没有冲突、不合理或应该删掉的内容？
这个想法是不是个好主意？值得做吗？
帮我把这个模糊目标改成可验证的 goal
帮我把这个 goal 拆成多个 phase，每个 phase 有 todo
这份计划太散了，按目标重写成 goal document
先别一边跑一边看，帮我写一份 goal document 再开始
帮我诊断一下这个 React 组件的架构质量
这个变量叫什么名字好？帮我起个名
这个功能用 TDD 来做，先写失败测试
帮我检查一下代码质量，看看有没有 code smell
这个 PRD 是不是太大了，需要拆吗？
对照这份 PRD，检查一下数据模型字段是否对齐
帮我检查 README 和代码有没有不一致的地方
帮我审一下这组文档内部有没有冲突、过期或该删的内容
帮我美化一下这个 README
给这个想法做一份可视化 HTML report
请你阅读这篇文章，最后生成一张视觉卡片
```

这些技能会在 AI 助手识别到意图后自动激活，不需要记特定命令。

## 技能一览

下面的表格不是简单分类，而是把方法论拆成可触发的能力。

`hai-*` 是核心方法论技能，负责判断、定义、约束和验证；其他技能是支撑工具，负责具体审查、代码质量、展示和工程化产出。

### 设计与架构

| 名称 | 用途 | 收益 |
| --- | --- | --- |
| `hai-architecture` | 基于 APoSD/Ousterhout 思路做架构层审查，关注复杂度、信息隐藏、深模块、接口和依赖方向 | 在架构决策阶段发现系统性复杂度，而不是停留在局部代码风格 |
| `geju` | 在方案讨论时打开格局，挑战过度兼容、局部细节陷阱和重构恐惧，输出更高位、更有锋芒的判断 | 先看清系统应该成为什么，再讨论迁移、阶段和落地 |
| `react-component-diagnosis` | 从使用者 API、数据流、可测试性、可扩展性、性能、心智模型、边界契约 7 个维度诊断组件架构 | 一次诊断定位组件的结构性问题，避免反复重构 |
| `hai-naming` | 命名顾问——给变量/函数/模块/类型起名，或审计现有命名的模糊、不一致和误导问题 | 好的命名就是好的设计，减少"读代码猜意图"的时间 |

### 产品、PRD 与 Goal

| 名称 | 用途 | 收益 |
| --- | --- | --- |
| `hai-prd` | 判断是否需要 PRD，设计新 PRD，打磨已有 PRD，并处理 PRD 拆分、合并和粒度问题 | 把所有 PRD 相关判断收敛到一个入口，先定边界和粒度，再写清目标、范围、行为和验收 |
| `hai-idea` | 判断一个想法是不是好主意，明确它值得做、先验证、重塑、延后还是砍掉 | 先判断想法质量和机会成本，避免把精力浪费在听起来有趣但不值得做的事情上 |
| `hai-goal` | 把模糊意图、已有目标或松散计划写成 goal document；定义可验证目标、边界、阶段、todo、优先级和验证规则 | 以后没有独立 plan，plan 是一种专门的 goal；先把路线和证明规则写清楚再动手 |
| `entity-model-auditor` | 对照 PRD 审计实体数据模型，逐字段对比目标设计与当前实现，输出迁移变更清单 | 在开发前就对齐 PRD 和数据库，减少联调阶段的返工 |

### 代码质量

| 名称 | 用途 | 收益 |
| --- | --- | --- |
| `hai-tdd` | 用测试驱动开发，先写失败测试，再写最小实现，最后在测试保护下重构 | 把“我觉得能跑”变成可重复验证的行为证据，减少补测试和返工 |
| `clean-code-reviewer` | 基于《代码整洁之道》原则，从命名、函数大小、DRY、YAGNI、魔法数字等 7 个维度审查代码 | 系统化的代码体检，而不是凭经验零散挑问题 |
| `ast-grep-rule-crafter` | 用 ast-grep YAML 编写 AST 级别的代码搜索与自动重写规则 | 把一次性的手工查找替换变成可复用的 lint 规则，杜绝同类问题再犯 |

### 文档与展示

| 名称 | 用途 | 收益 |
| --- | --- | --- |
| `hai-audit-docs-internally` | 审计单个文档或文档集内部的冲突、过期线索、重复内容、术语漂移和该更新/移动/删除的部分 | 先把文档自身整理成一致的论证，避免读者被互相打架的段落误导 |
| `hai-audit-docs-against-code` | 对照代码实现、配置和 API 合同审计 README/docs，找出过时、错误或与实现不一致的描述 | 文档与实现保持同步，新人不再被过时说明误导 |
| `readme-beautifier` | 修复 README 的结构混乱和格式不统一问题，输出专业规范的版本 | 一键美化，不用再纠结排版细节 |
| `hai-visual-report` | 把想法、需求、PRD、goal、评审或方案做成结构化可视化 HTML report | 不只是写总结，而是用 map、矩阵、阶段、风险和下一步把复杂内容讲清楚 |
| `create-visual-card` | 把内容做成视觉卡片，输出独立 HTML，并支持导出 PNG | 快速把文字变成可分享的精美卡片，适合社交传播和笔记归档 |

## 目录结构

```text
skills/
  hai-architecture/        # 架构层审查
    SKILL.md
    SKILL.zh_CN.md
    references/
  ast-grep-rule-crafter/   # AST 搜索重写规则
    SKILL.md
    references/
  hai-audit-docs-against-code/ # 文档对照代码审计
    SKILL.md
    SKILL.zh_CN.md
    references/
  hai-audit-docs-internally/ # 文档内部审计
    SKILL.md
    SKILL.zh_CN.md
    references/
  clean-code-reviewer/     # 代码整洁度审查
    SKILL.md
    references/
  create-visual-card/      # 视觉卡片生成
    SKILL.md
    references/
    scripts/
  hai-goal/                # Goal 文档与执行前重写
    SKILL.md
    SKILL.zh_CN.md
    references/
  entity-model-auditor/    # 实体模型审计
    SKILL.md
    references/
  hai-idea/                # 想法价值判断
    SKILL.md
    SKILL.zh_CN.md
    references/
  hai-visual-report/       # 可视化 HTML 报告
    SKILL.md
    SKILL.zh_CN.md
    references/
  geju/                    # 打开格局的方案判断
    SKILL.md
    SKILL.zh_CN.md
    references/
  hai-naming/              # 命名顾问
    SKILL.md
    SKILL.zh_CN.md
    references/
  hai-tdd/                 # 测试驱动开发
    SKILL.md
    SKILL.zh_CN.md
    references/
  hai-prd/                 # PRD 判断、设计、打磨与拆合
    SKILL.md
    SKILL.zh_CN.md
    references/
  react-component-diagnosis/ # React 组件诊断
    SKILL.md
    references/
  readme-beautifier/       # README 美化
    SKILL.md
    references/
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
