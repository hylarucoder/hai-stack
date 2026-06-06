# Architecture Review Output Template

Use this template when returning a markdown architecture or design review. It is the canonical
shape referenced from `SKILL.md` (Output section); the inline skeleton there is a summary of this.
Keep findings evidence-led and focused on complexity reduction. Adapt section depth to the review
scope, but keep the section set and order.

```markdown
# Architecture Review: <scope>

## Verdict
<One sentence — healthy / mixed / risky and why — plus the single most important thing to fix.>

## Architecture Map
<A simple map of the whole chain before any findings: main actors/modules, dependency and
data/state direction, the current boundary where complexity is meant to be hidden, and where
competing options would change the map. Use a Mermaid diagram or a clear text outline.>

## Boundary
<The large module, ownership boundary, or call chain being reviewed. State assumptions and any
clarification needed. If the boundary is ambiguous and different assumptions change the
recommendation, ask before continuing.>

## Review Lenses
<The 3-6 lenses selected for this scope and why each matters here. Do not score all 14.>

## Painful Center
<The highest-leverage complexity source found in the reviewed scope. Explain why easier findings
are secondary, and tie it back to the architecture map.>

## Options
<At least two viable options, compared by boundary clarity, module depth, current-needs fit,
migration cost, and risk. For nontrivial changes include a conservative and a stronger option.
Recommend one.>

## Findings

### P1: <finding title> — Severity: High/Medium/Low
- **What I found**: <specific observation with file:line references>
- **APoSD principle**: <deep module / information hiding / define errors away / design it twice / ...>
- **Why it adds complexity**: <which symptom — change amplification, cognitive load, or unknown unknowns>
- **Recommendation**: <specific design move, not "make it better">
- **Why-not / tradeoff**: <which alternatives are rejected and why; for key findings, the red team attack / blue team defense / residual risk>

### P2: <finding title> — Severity: High/Medium/Low
- **What I found**: <specific observation>
- **APoSD principle**: <principle>
- **Why it adds complexity**: <impact>
- **Recommendation**: <specific design move>
- **Why-not / tradeoff**: <cost / rejected alternatives>

(repeat, ordered by severity; group low-severity findings into a "Minor" section at the end)

## What Is Already Good
- <specific design choice worth preserving>

## Evidence Reviewed
- <files, packages, docs, schemas, and call chains actually read, plus the searches actually run —
  the output of the evidence gate in `SKILL.md`. Keep it factual; do not hide unsupported assumptions.>

## Next Step
<The smallest design change that would reduce the most complexity.>
```
