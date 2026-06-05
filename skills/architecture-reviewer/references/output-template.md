# Architecture Review Output Template

Use this template when returning an architecture or design review. Keep findings evidence-led and focused on complexity reduction.

```markdown
# Architecture Review: <scope>

## Verdict
<One sentence: healthy / mixed / risky, and why.>

## Complexity Map
- **Main abstraction**: <module/component/system concept>
- **Complexity owner**: <where complexity should live>
- **Leaky boundary**: <where callers know too much, if any>

## Findings

### P1: <finding title>
- **What I found**: <specific observation with file:line references>
- **APoSD principle**: <deep module / information hiding / define errors away / design it twice / ...>
- **Why it adds complexity**: <how this makes future change harder>
- **Recommendation**: <specific design move>
- **Tradeoff**: <cost or migration concern>

### P2: <finding title>
- **What I found**: <specific observation>
- **APoSD principle**: <principle>
- **Why it adds complexity**: <impact>
- **Recommendation**: <specific design move>
- **Tradeoff**: <cost>

## What Is Already Good
- <specific design choice worth preserving>

## Next Step
<The smallest design change that would reduce the most complexity.>
```
