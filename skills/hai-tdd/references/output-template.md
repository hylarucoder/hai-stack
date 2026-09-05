# Hai TDD 输出模板

用于记录 TDD 执行过程。不要只写“已测试”，必须给出 RED/GREEN/REFACTOR 的证据。

如果本切片没有合法 RED，不要为了填模板硬造测试。使用下面的 `No Legitimate RED` 模板，并把工作标记为结构重构、tests-after 或普通验证，而不是 TDD。

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

```markdown
# Hai TDD: <structural refactor or verification slice>

## Target Change
<本轮要完成的结构变化，例如删除字段、收窄接口、移动类型、移除别名。>

## No Legitimate RED
- **Reason**: <为什么这里没有行为级 RED，例如“这是纯结构边界收口，测试只能重复编译器/AST 检查”。>
- **Rejected fake RED**: <明确拒绝的假测试，例如“不会添加 ConversationScope must not contain TurnID 的 AST 守卫”。>
- **Validation instead**: <将使用的验证方式，例如编译错误、现有测试、静态检查、聚焦集成测试。>

## Implementation
- **Change**: <实际结构改动摘要>

## Verification
- **Command**: `<command>`
- **Observed result**: <通过结果摘要，或失败及后续处理>

## Next Behavior
<如果后续存在真实行为变化，下一步再进入 RED；否则 done。>
```
