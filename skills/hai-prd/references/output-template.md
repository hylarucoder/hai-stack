# Hai PRD Output Template

根据任务选择对应模板。不要机械输出全部 section；只输出和当前问题相关的模式。

```markdown
# Hai PRD: <topic or document name>

## Mode
Need PRD / Design PRD / Craft PRD / Scope PRD

## PRD Necessity
Use when deciding whether a PRD is needed.

- **Recommendation**: PRD / hai-goal / design doc / task / no separate artifact
- **Reason**: <why this artifact type fits>
- **User-visible behavior change**: yes / no / unknown
- **Scope alignment needed**: yes / no
- **Acceptance needed**: yes / no
- **If not PRD, where it belongs**: <goal/design doc/task/existing PRD/etc.>

## PRD Draft
Use when designing a new PRD.

### Target Outcome
<What should be true for users or the business when this ships.>

### Problem
<Current pain, gap, or opportunity.>

### Users and Scenarios
- **User / actor**: <who>
- **Scenario**: <when they need this>
- **Current workaround**: <if known>

### Scope
#### In Scope
- <behavior or product surface>

#### Out of Scope
- <explicit non-goal that prevents scope creep>

### Requirements
| Requirement | User value | Verification |
|-------------|------------|--------------|
| <requirement> | <why it matters> | <how to prove it works> |

### Acceptance Criteria
- [ ] <observable pass/fail criterion>

### Risks and Open Questions
- <question that could change scope or acceptance>

### Rollout / Migration
<Only include when product behavior, data, or existing users are affected.>

## Existing PRD Diagnosis
Use when auditing, rewriting, or refining an existing PRD.

- **Current target outcome**: <as written>
- **Corrected target outcome**: <if changed>
- **Main drift**: goal drift / scope drift / conflict drift / acceptance drift / solution drift / local-edit drift

### Internal Conflicts
| Conflict | Sections | Why it matters | Resolution |
|----------|----------|----------------|------------|
| <incompatible claims> | <section refs> | <impact> | keep / rewrite / remove / split |

### Remove / Keep / Rewrite Decisions
| Content | Decision | Reason | Follow-up |
|---------|----------|--------|-----------|
| <requirement/section/claim> | remove / keep / rewrite / move | <why> | <none or action> |

### Coherence Repairs
- <contradiction, duplicate, stale claim, or misplaced content repaired>

### Acceptance Improvements
- <criterion that became more observable or measurable>

## PRD Scope Assessment
Use when deciding split / merge / keep as-is.

### Recommendation
<Split / Merge / Keep as-is> — <one paragraph reasoning>

### Six-Dimension Test
| Test | Signal | Evidence |
|------|--------|----------|
| Press Release | split / merge / neutral | <reason> |
| Independent Value | split / merge / neutral | <reason> |
| Independent Acceptance | split / merge / neutral | <reason> |
| Domain Language | split / merge / neutral | <reason> |
| User Journey | split / merge / neutral | <reason> |
| Time Appetite | split / merge / neutral | <reason> |

### Suggested Boundary
#### PRD A: <name>
- **Scope**: <included behavior>
- **Acceptance anchor**: <how it can be accepted independently>

#### PRD B: <name>
- **Scope**: <included behavior>
- **Dependency**: <none or what must ship first>

### What Not To Split
- <work that belongs in an existing PRD, design doc, or acceptance criteria>

## Remaining Open Questions
- <question that could change need, scope, behavior, or acceptance>

## Next Step
<The smallest edit to the PRD set or the next artifact to create.>
```
