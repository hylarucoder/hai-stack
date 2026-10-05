# 参与维护 hai-stack

## 维护原则

- 独立入口要有独立的任务、方法和完成证据。规模或视角不同时，优先做成模式或参考资料。
- `hai-*` 是个人方法系列的命名，不代表所有核心能力都要加这个前缀。
- 已授权实施的任务，不能只交付计划；诊断或审查请求，不自动变成修改。
- 复用目标和当前证据。没有理由时，不重复写报告，也不重复执行已通过的检查。
- 新增技能先用真实任务验证收益，不以数量增长为目标。

## 技能目录结构

```text
skills/<skill-name>/
  SKILL.md           # 英文执行源
  SKILL.zh_CN.md     # hai-* 技能必备的中文阅读版
  references/        # 按需读取的专业方法和模板
  scripts/           # 确定性的辅助工具
  assets/            # 产物模板
```

## 已退役的技能

原目录不保留重复的触发入口；旧内容可以从 Git 历史恢复。
`make link` 和 `make unlink` 会清理指向这些旧路径的链接，包括历史上的 `~/.codex/skills/` 链接。

| 旧入口 | 新归属 | 保留的方法 |
| --- | --- | --- |
| `hai-visual-report` | `hai-visual-explainer` | card 和 report 两种模式、模板与统一截图 |
| `hai-ssot` | `hai-architecture` 的 SSOT 视角 | 十类症状、误报裁决、治理配方与处置报告 |
| `create-visual-card` | `hai-visual-explainer` 的 card 模式 | 卡片设计与模板、元素截图和可读性检查 |
| `react-component-diagnosis` | `hai-architecture` 的 bounded 模式 | React 七维诊断、证据与评分报告变体 |
| `hai-complexity` | `hai-architecture` 的全局模式 | 入口族、调用链、状态和配置、测试保护 |
| `hai-audit-docs-internally` | `hai-audit-docs` 的内部模式 | 主张图、矛盾、术语和生命周期漂移 |
| `hai-audit-docs-against-code` | `hai-audit-docs` 的实现和综合模式 | 双向核对、权威优先级、缺陷归属 |
| `clean-code-reviewer` | `code-review-and-quality` 的可维护性模式 | 代码整洁度方法和语言参考 |

技能的来源与收录说明，见 [来源说明](docs/skill-sources.md)。

## 评估

触发边界在 [trigger-cases.json](evals/trigger-cases.json)，工作样例在 [workflow-cases.json](evals/workflow-cases.json)。
静态校验不等于模型的触发准确率。对照执行检查四件事：方法是否保留、是否误改、是否漏了证据、是否多加了流程。
运行方法见 [评估说明](evals/README.md)。

## 可选的渲染工具

只阅读技能，不需要 Node 依赖。生成 HTML 截图时，先安装：

```bash
npm install
npx playwright install chromium
```

## README 头图

`docs/assets/flow.svg` 是 README 的头图，由 `docs/assets/make_flow.py` 生成。技能增减或换了阶段后，先改脚本里的 `STAGES` 或 `LENSES`，再运行：

```bash
python3 docs/assets/make_flow.py
```

README 的“能力一览”表和头图按同样的阶段分组，两处要一起改。
