# hai-stack

> 一个专门放 `skills` 的小仓库。先把事情做小、做清楚，再把结果做得好看。

`hai-stack` 是一组面向 AI 编程助手的技能集合，覆盖架构审查、PRD 设计与打磨、目标定义与拆解、计划修正、视觉卡片生成、代码质量审查、组件架构诊断、文档对照代码审计等场景。

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
帮我从架构层面 review 一下这个模块的设计
帮我把格局打开，不要被兼容性和重构成本吓住
帮我把这个想法设计成一份 PRD
这份 PRD 有点局部修补的感觉，帮我从整篇文档角度打磨一下
这份 PRD 里面有没有冲突、不合理或应该删掉的内容？
帮我把这个模糊目标改成可验证的 goal
帮我把这个 goal 拆成多个 phase，每个 phase 有 todo
这份计划太散了，帮我重写成可执行计划
帮我诊断一下这个 React 组件的架构质量
这个变量叫什么名字好？帮我起个名
帮我检查一下代码质量，看看有没有 code smell
这个 PRD 是不是太大了，需要拆吗？
对照这份 PRD，检查一下数据模型字段是否对齐
帮我检查 README 和代码有没有不一致的地方
帮我审一下这组文档内部有没有冲突、过期或该删的内容
帮我美化一下这个 README
请你阅读这篇文章，最后生成一张视觉卡片
```

这些技能会在 AI 助手识别到意图后自动激活，不需要记特定命令。

## 技能一览

### 设计与架构

| 名称 | 用途 | 收益 |
| --- | --- | --- |
| `architecture-reviewer` | 基于 APoSD/Ousterhout 思路做架构层审查，关注复杂度、信息隐藏、深模块、接口和依赖方向 | 在架构决策阶段发现系统性复杂度，而不是停留在局部代码风格 |
| `geju` | 在方案讨论时打开格局，挑战过度兼容、局部细节陷阱和重构恐惧，输出更高位、更有锋芒的判断 | 先看清系统应该成为什么，再讨论迁移、阶段和落地 |
| `react-component-diagnosis` | 从使用者 API、数据流、可测试性、可扩展性、性能、心智模型、边界契约 7 个维度诊断组件架构 | 一次诊断定位组件的结构性问题，避免反复重构 |
| `naming-consultant` | 命名顾问——给变量/函数/模块/类型起名，或审计现有命名的模糊、不一致和误导问题 | 好的命名就是好的设计，减少"读代码猜意图"的时间 |

### 产品、PRD 与目标

| 名称 | 用途 | 收益 |
| --- | --- | --- |
| `prd-design` | 把功能想法或产品问题设计成 PRD 级需求，明确目标、范围、行为、验收标准和验证规则 | 避免一上来写实现，把产品目标和边界先想清楚 |
| `prd-craft` | 打磨已有 PRD，从整篇文档角度修复目标漂移、范围漂移、内部冲突、不合理内容、验收不可验证和局部修补问题 | 让 PRD 成为一份连贯的产品论证，而不是多个局部段落的拼接 |
| `goal-make` | 把模糊意图转成可验证、可判断、必要时可量化的目标 | 让目标是否达成有清晰证据，而不是靠感觉判断 |
| `goal-craft` | 把目标细化成多个 phase，并为每个 phase 设计 todo 和验证规则 | 把目标从“想做到”推进到“可阶段性执行和检查” |
| `prd-splitter` | PRD 粒度顾问——判断一个需求该拆成多个 PRD 还是合并，提供 6 维决策框架 | 避免 PRD 过大导致交付失控，或过小导致上下文碎片化 |
| `entity-model-auditor` | 对照 PRD 审计实体数据模型，逐字段对比目标设计与当前实现，输出迁移变更清单 | 在开发前就对齐 PRD 和数据库，减少联调阶段的返工 |

### 代码质量

| 名称 | 用途 | 收益 |
| --- | --- | --- |
| `clean-code-reviewer` | 基于《代码整洁之道》原则，从命名、函数大小、DRY、YAGNI、魔法数字等 7 个维度审查代码 | 系统化的代码体检，而不是凭经验零散挑问题 |
| `ast-grep-rule-crafter` | 用 ast-grep YAML 编写 AST 级别的代码搜索与自动重写规则 | 把一次性的手工查找替换变成可复用的 lint 规则，杜绝同类问题再犯 |

### 计划

| 名称 | 用途 | 收益 |
| --- | --- | --- |
| `plan-craft` | 打磨已有计划，从整篇计划角度修复目标不清、阶段松散、todo 不可验证等问题 | 把计划拉回目标、阶段、依赖和验证，变成能执行的路径 |

### 文档与展示

| 名称 | 用途 | 收益 |
| --- | --- | --- |
| `audit-docs-internally` | 审计单个文档或文档集内部的冲突、过期线索、重复内容、术语漂移和该更新/移动/删除的部分 | 先把文档自身整理成一致的论证，避免读者被互相打架的段落误导 |
| `audit-docs-against-code` | 对照代码实现、配置和 API 合同审计 README/docs，找出过时、错误或与实现不一致的描述 | 文档与实现保持同步，新人不再被过时说明误导 |
| `readme-beautifier` | 修复 README 的结构混乱和格式不统一问题，输出专业规范的版本 | 一键美化，不用再纠结排版细节 |
| `create-visual-card` | 把内容做成视觉卡片，输出独立 HTML，并支持导出 PNG | 快速把文字变成可分享的精美卡片，适合社交传播和笔记归档 |

## 目录结构

```text
skills/
  architecture-reviewer/   # 架构层审查
    SKILL.md
    references/
  ast-grep-rule-crafter/   # AST 搜索重写规则
    SKILL.md
    references/
  audit-docs-against-code/ # 文档对照代码审计
    SKILL.md
    references/
  audit-docs-internally/   # 文档内部审计
    SKILL.md
    references/
  clean-code-reviewer/     # 代码整洁度审查
    SKILL.md
    references/
  create-visual-card/      # 视觉卡片生成
    SKILL.md
    references/
    scripts/
  entity-model-auditor/    # 实体模型审计
    SKILL.md
    references/
  goal-craft/              # 目标阶段拆解
    SKILL.md
    references/
  goal-make/               # 可验证目标定义
    SKILL.md
    references/
  geju/                    # 打开格局的方案判断
    SKILL.md
    SKILL.zh_CN.md
    references/
  naming-consultant/       # 命名顾问
    SKILL.md
    references/
  plan-craft/              # 计划打磨
    SKILL.md
    references/
  prd-craft/               # PRD 打磨
    SKILL.md
    references/
  prd-design/              # PRD 设计
    SKILL.md
    references/
  prd-splitter/            # PRD 粒度顾问
    SKILL.md
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
