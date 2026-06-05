# Clean Code Review Output Template

Use this template for implementation-quality findings. Keep each issue tied to behavior-preserving maintainability improvements.

```markdown
# Clean Code Review: <scope>

## Summary
<One paragraph on the highest-leverage maintainability risks.>

## Findings

### P1: <issue title>
- **Principle**: <naming / single responsibility / DRY / YAGNI / magic numbers / comments / error handling>
- **Location**: `<file>:<line>`
- **Severity**: High / Medium / Low
- **Problem**: <what makes the code harder to read, change, or test>
- **Recommendation**: <behavior-preserving refactor direction>
- **Why now**: <risk if left as-is>

### P2: <issue title>
- **Principle**: <principle>
- **Location**: `<file>:<line>`
- **Severity**: High / Medium / Low
- **Problem**: <description>
- **Recommendation**: <direction>
- **Why now**: <risk>

## Good Patterns To Keep
- <specific implementation choice worth preserving>

## Test Gaps
- <only tests needed to protect behavior during refactor>
```
