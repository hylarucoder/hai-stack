# hai-stack

<p>
  <img src="https://img.shields.io/badge/skills-21-2563eb" alt="skills" />
  <img src="https://img.shields.io/badge/for-Claude%20Code%20%2F%20Codex-8A2BE2" alt="for Claude Code / Codex" />
  <a href="LICENSE">License</a>
</p>

> 帮助软件持续迭代：从真实问题出发，完成改动，用证据确认结果。

每个技能拥有明确的进入条件、独特的处理方法和可以检查的完成结果。
选择入口时看当前卡点，不要求每次走完一套流程。

## 从当前问题进入

| 当前卡点 | 入口 | 完成结果 |
| --- | --- | --- |
| 值不值得投入？ | `hai-idea` | 决策、关键假设、最低成本验证 |
| 用户需要什么行为？ | `hai-prd` | 范围、场景、可验收要求；小事可以不写 PRD |
| 系统为什么难改，边界怎么调整？ | `hai-architecture` | 全局运行链调查或局部设计决策、证据、选项 |
| 出现故障，原因不清楚 | `hai-debug`（试用） | 复现、假设排除、因果链；要求修复时继续完成 |
| 方向明确，执行依赖复杂 | `hai-goal` | 阶段、依赖、验证和完成条件 |
| 开始修改 | 常规执行；适合时用 `hai-tdd` | 完整变更和相称的验证；真实 RED/GREEN |
| 检查这次改动 | `code-review-and-quality` | 缺陷、证据、修复方向和限定范围的评审结论 |
| 确认目标已经完成 | `write-technical-acceptance-report` | 要求与实际验证对应的结果；按风险选择简版/完整版 |
| 结论需要沉淀 | `hai-audit-docs` / `hai-rewrite-doc` | 准确文档、已修复项与未决问题 |

原因已知的小 bug 可以直接用 TDD 修复；单纯移动类型可以直接改并编译验证；
不明原因的故障先诊断；跨存储/API/前端的迁移才需要明确阶段与完整验收。
评审通过不自动授权合并，验收通过不自动授权部署。

## 随时可用的纠偏视角

这些是按需调用的视角，不是每次迭代必须完成的阶段，也不绑定某一个模型。

| 技能 | 什么时候有帮助 | 产出 |
| --- | --- | --- |
| `geju` | 方案被历史形状、兼容焦虑和局部补丁限制 | 干净目标、不同选项、可证伪的第一证明点 |
| `goudi` | 方向很大，第一步和失败信号不清 | 最小证明、现实约束、明确止损规则 |
| `hai-razor` | 需求、字段、状态、层或流程需要证明独立存在的价值 | 保留/合并/延后/删除/替换/先证明及隐藏责任归属 |

## 专项判断与工具

| 技能 | 独立责任 |
| --- | --- |
| `hai-ssot` | 追踪多源定义、默认值、形状和规则漂移，裁决误报，给治理方法 |
| `entity-model-auditor` | 逐字段判断存储/推导、列/配置、归属与迁移差异 |
| `hai-naming` | 为具体概念命名，或审查跨模块词汇及迁移影响 |
| `react-component-diagnosis` | 深入诊断单个 React 组件的 API、状态/effect 和渲染链 |
| `hai-ast-grep` | 结构化搜索、lint/codemod 规则及正反样例验证 |
| `readme-beautifier` | 只整理 Markdown 排版结构，保留事实和原意 |

## 文档与展示

`hai-audit-docs` 一个入口覆盖内部一致性、实现/契约对照和综合审计。
文档自洽不等于事实正确，当前代码也不能自动推翻批准的目标行为。

只要求审查就交付问题；已经要求“检查并修复”就完成有证据的局部修复；
全文重建由 `hai-rewrite-doc` 负责。PRD 与计划调整分别归 `hai-prd` 和 `hai-goal`。

| 技能 | 产出 |
| --- | --- |
| `hai-visual-report` | 保留源材料含义的多 section HTML 报告与 PNG 预览 |
| `create-visual-card` | 单张可分享视觉卡片，HTML 与 PNG |

展示是可选形式，任务完成不要求再做一份视觉报告。

## 常用说法

```text
系统太绕了，从 server 和 worker 入口看看为什么改重试规则这么费劲。
这两个包该合并吗？看看真正的所有权和调用关系。
关闭重试后还是重复请求，先定位根因，不要改代码。
帮我修这个问题，复现之后继续完成修复和回归验证。
对照实现检查并修复 README，批准的未来需求不要改成现有行为。
review 当前 diff，优先找真实 bug 和缺少的验证。
确认这次迁移满足要求，区分实际通过、跳过和没跑的用例。
把格局打开。 / 用苟帝压实第一步。 / 用剃刀看看哪些概念该合并。
```

## 安装与升级

```bash
git clone https://github.com/hylarucoder/hai-stack.git
cd hai-stack
make link
```

技能链接到 `~/.agents/skills/` 和 `~/.claude/skills/`。
安装器只清理指向本仓库已退役技能路径的旧链接，包括历史 `~/.codex/skills/` 链接；
真实目录或其他仓库的链接不会被覆盖。同名独立安装会提示冲突。

```bash
make status    # 查看安装状态
make unlink    # 只移除指向本仓库的技能链接
make validate  # 技能结构、资源、入口样例和脚本语法校验
```

| 旧入口 | 新归属 | 保留的方法 |
| --- | --- | --- |
| `hai-complexity` | `hai-architecture` 全局模式 | 入口族、调用链、状态/配置、测试保护 |
| `hai-audit-docs-internally` | `hai-audit-docs` 内部模式 | 主张图、矛盾、术语和生命周期漂移 |
| `hai-audit-docs-against-code` | `hai-audit-docs` 实现/综合模式 | 双向核对、权威优先级、缺陷归属 |
| `clean-code-reviewer` | `code-review-and-quality` 可维护性模式 | 代码整洁度方法和语言参考 |

原目录不保留重复触发入口；旧内容可从 Git 历史恢复。
评审和验收沿用已有技能名称，见 [来源说明](docs/skill-sources.md)。

## 维护原则

- 独立入口要有独立任务、方法和完成证据；规模或视角变化优先考虑模式/参考资料。
- `hai-*` 是个人方法系列的命名，不代表所有核心能力都必须加此前缀。
- 已授权实施的任务不能只交付计划；诊断/审查请求不自动变成修改。
- 复用目标和当前证据，不重复写报告或无理由重复执行已通过的检查。
- 新增技能先用真实任务验证收益，不以数量增长为目标。

```text
skills/<skill-name>/
  SKILL.md           # 英文执行源
  SKILL.zh_CN.md     # hai-* 必备中文阅读版
  references/        # 按需读取的专业方法和模板
  scripts/           # 确定性辅助工具
  assets/            # 产物模板
```

触发边界在 [trigger-cases.json](evals/trigger-cases.json)，工作样例在
[workflow-cases.json](evals/workflow-cases.json)。静态校验不等于模型触发准确率；
对照执行检查方法是否保留、是否误改、是否漏证据或增加流程，见 [评估说明](evals/README.md)。

## 可选渲染工具

只阅读技能不需要 Node 依赖。生成 HTML 截图时安装：

```bash
npm install
npx playwright install chromium
```
