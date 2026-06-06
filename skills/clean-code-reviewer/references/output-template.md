# Clean Code Review Output Template

The canonical report shape. Findings are P-numbered and sorted by severity (highest first). Severity labels are 高 / 中 / 低, matching the rubric in SKILL.md. The behavior-preserving constraint is inherited from SKILL.md — every recommendation stays within it.

```markdown
# Clean Code Review: <scope>

## Summary
<最高杠杆的可维护性风险，一段话>

## Findings

### P1: <issue title>
- **原则**: <命名 / 单一职责 / DRY / YAGNI / 魔法数字 / 结构清晰度 / 项目规范>
- **位置**: `<file>:<line>`
- **级别**: 高 / 中 / 低
- **问题**: <what makes the code harder to read, change, or test>
- **建议**: <refactor direction>
- **Why now**: <risk if left as-is>

### P2: <issue title>
- **原则**: <principle>
- **位置**: `<file>:<line>`
- **级别**: 高 / 中 / 低
- **问题**: <description>
- **建议**: <direction>
- **Why now**: <risk>

## Good Patterns To Keep
- <specific implementation choice worth preserving>

## Test Gaps
- <only tests needed to protect behavior during refactor>
```
