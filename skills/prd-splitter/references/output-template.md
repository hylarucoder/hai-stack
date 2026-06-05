# PRD Scope Output Template

Use this template when advising whether to split, merge, or keep a PRD scope as-is.

```markdown
# PRD Scope Assessment: <feature or initiative>

## Recommendation
<Split / Merge / Keep as-is> — <one paragraph reasoning>

## Six-Dimension Test
| Test | Signal | Evidence |
|------|--------|----------|
| Press Release | split / merge / neutral | <reason> |
| Independent Value | split / merge / neutral | <reason> |
| Independent Acceptance | split / merge / neutral | <reason> |
| Domain Language | split / merge / neutral | <reason> |
| User Journey | split / merge / neutral | <reason> |
| Time Appetite | split / merge / neutral | <reason> |

## Suggested Boundary
### PRD A: <name>
- **Scope**: <included behavior>
- **Acceptance anchor**: <how it can be accepted independently>

### PRD B: <name>
- **Scope**: <included behavior>
- **Dependency**: <none or what must ship first>

## What Not To Split
- <work that belongs in an existing PRD, design doc, or acceptance criteria>

## Next Step
<The smallest edit to the PRD set.>
```
