# Internal Documentation Audit Output Template

Use this template when reporting conflicts, stale content, and update/remove decisions inside one document or a documentation set.

```markdown
# Internal Documentation Audit: <document or doc set>

## Verdict
- **Status**: healthy / needs cleanup / inconsistent / blocked by decisions
- **Main issue**: <one sentence>
- **Scope reviewed**: <files or sections>

## Document Map
| Section / Doc | Apparent purpose | Notes |
|---------------|------------------|-------|
| <section> | <purpose> | <key observation> |

## Findings

### P1: <conflict or stale-content title>
- **Type**: direct conflict / scope conflict / terminology drift / lifecycle conflict / acceptance conflict / stale signal / redundant content / misplaced content / unsupported claim
- **Location**: `<doc>:<section or line>`
- **Evidence**:
  - <claim A>
  - <claim B or stale signal>
- **Impact**: <why this changes understanding, decisions, or execution>
- **Repair**: update / move / merge / remove / split / ask
- **Recommendation**: <specific edit direction>

## Remove / Update / Move Decisions
| Content | Decision | Reason | Suggested destination or replacement |
|---------|----------|--------|--------------------------------------|
| <claim/section> | remove / update / move / merge | <why> | <target or replacement> |

## Open Decisions
- <question that must be answered by the document owner>

## Suggested Repair Order
1. <highest leverage repair>
2. <next repair>
```
