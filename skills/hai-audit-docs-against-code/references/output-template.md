# 文档对照代码审计输出模板

用于最终报告。更详细的问题项字段和示例见 `references/output-format.md`。

```markdown
# 文档对照代码审计报告

## 审核结论
- **结论**: 通过 / 有条件通过 / 不通过
- **范围**: <README/docs/API/config files reviewed>
- **汇总**: P0:<n> P1:<n> P2:<n> P3:<n> 待补充:<n>

## 高优先级问题

### P1: <问题标题>
- **位置**: `<文档路径>:<行号>`
- **文档声称**: <quote or paraphrase>
- **代码事实**: `<代码路径>:<行号>` <verified behavior>
- **影响**: <misleading consequence>
- **建议**: <minimal correction>

## 其他问题
- <P2/P3 issue summary with location and fix direction>

## 建议修复顺序
1. <highest-risk doc fix>
2. <next fix>

## 已核对但无需修改
- <claim or doc area confirmed accurate>
```
