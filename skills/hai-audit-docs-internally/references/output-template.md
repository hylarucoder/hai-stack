# Internal Documentation Audit Output Template

Use this template when reporting conflicts, stale content, and update/remove decisions inside one document or a documentation set.

```markdown
# Internal Documentation Audit: <document or doc set>

## Verdict
- **Status**: healthy (no P0/P1) / needs cleanup (P2-P3 only) / inconsistent (has P0/P1) / blocked by decisions (has Needs-decision forks)
- **Main issue**: <one sentence>
- **Scope reviewed**: <files or sections>

## Document Map
| Section / Doc | Apparent purpose | Notes |
|---------------|------------------|-------|
| <section> | <purpose> | <key observation> |

## Findings

Order by severity (P0 first). Severity levels are defined in SKILL.md; types and repairs are defined in Workflow steps 3-4.

### P0: <conflict that could cause a wrong decision, unsafe action, or failed launch>
- **Type**: direct conflict / scope conflict / terminology drift / lifecycle conflict / acceptance conflict / stale signal / redundant content / misplaced content / unsupported claim
- **Location**: `<doc>:<section or line>`
- **Evidence**:
  - <claim A>
  - <claim B or stale signal>
- **Impact**: <the wrong decision, unsafe action, or failed launch this could cause>
- **Repair**: update / move / merge / remove / split / ask
- **Recommendation**: <specific edit direction>

### P1: <conflict or stale-content title>
- **Type**: <one of the types above>
- **Location**: `<doc>:<section or line>`
- **Evidence**:
  - <claim A>
  - <claim B or stale signal>
- **Impact**: <why this changes understanding, decisions, or execution>
- **Repair**: update / move / merge / remove / split / ask
- **Recommendation**: <specific edit direction>

### Needs decision: <real fork the document cannot resolve on its own>
- **Type**: <one of the types above>
- **Location**: `<doc>:<section or line>`
- **Evidence**:
  - <option A and what assumes it>
  - <option B and what assumes it>
- **Impact**: <what stays inconsistent until the owner picks>
- **Repair**: ask
- **Recommendation**: <the question to put to the owner; mirror it in Open Decisions below>

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
