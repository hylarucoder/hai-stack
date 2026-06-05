# Hai TDD 输出模板

用于记录 TDD 执行过程。不要只写“已测试”，必须给出 RED/GREEN/REFACTOR 的证据。

```markdown
# Hai TDD: <feature or bug>

## Target Behavior
<本轮要驱动的最小行为切片。>

## RED
- **Test added**: `<test file or test name>`
- **Behavior asserted**: <测试约束的行为>
- **Command**: `<command>`
- **Observed failure**: <失败信息摘要>
- **Failure is correct because**: <为什么这是目标行为缺失，而不是测试/环境错误>

## GREEN
- **Minimal implementation**: <做了哪些最小代码改动>
- **Command**: `<command>`
- **Observed pass**: <通过结果摘要>

## REFACTOR
- **Refactor done**: yes / no
- **Change**: <命名、去重、结构调整，或 no refactor needed>
- **Command after refactor**: `<command or not needed>`
- **Observed result**: <通过结果摘要>

## Next Behavior
<下一个需要进入 RED 的行为，或 done。>
```
