# React 组件诊断输出模板

用于输出组件架构体检报告。评分必须由具体代码证据支撑。

```markdown
# 组件诊断报告：<组件名>

> <一句话概括组件职责>

## 评分卡
| 维度 | 得分 | 一句话评价 |
|------|------|------------|
| 使用者 API | <1-5> | <summary> |
| 数据流 | <1-5> | <summary> |
| 可测试性 | <1-5> | <summary> |
| 可扩展性 | <1-5> | <summary> |
| 性能 | <1-5> | <summary> |
| 心智模型 | <1-5> | <summary> |
| 边界契约 | <1-5> | <summary> |
| **综合** | **<score>** | <overall> |

## 关键发现
### P1: <问题标题>
- **维度**: <dimension>
- **位置**: `<file>:<line>`
- **证据**: <specific code behavior>
- **影响**: <why this hurts component architecture>
- **建议**: <concrete change direction>
- **工作量**: 小 / 中 / 大

## 亮点
- `<file>:<line>` <design pattern worth preserving>

## 改进路线
1. <highest leverage change>
2. <next change>

## 风险和测试建议
- <behavior to protect while refactoring>
```
