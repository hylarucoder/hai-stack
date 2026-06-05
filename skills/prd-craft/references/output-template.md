# PRD Craft Output Template

Use this template when reporting how an existing PRD was audited, refined, or rewritten from a whole-document perspective.

```markdown
# PRD Craft Review: <document name>

## Document-Level Diagnosis
- **Current target outcome**: <as written>
- **Corrected target outcome**: <if changed>
- **Main drift**: goal drift / scope drift / conflict drift / acceptance drift / solution drift / local-edit drift

## Internal Conflicts
| Conflict | Sections | Why it matters | Resolution |
|----------|----------|----------------|------------|
| <incompatible claims> | <section refs> | <impact> | keep / rewrite / remove / split |

## Remove / Keep / Rewrite Decisions
| Content | Decision | Reason | Follow-up |
|---------|----------|--------|-----------|
| <requirement/section/claim> | remove / keep / rewrite / move | <why> | <none or action> |

## Changes Made or Recommended
| Section | Problem | Change | Why it improves the whole PRD |
|---------|---------|--------|-------------------------------|
| <section> | <issue> | <edit/rewrite> | <document-level effect> |

## Coherence Repairs
- <contradiction, duplicate, stale claim, or misplaced content repaired>

## Acceptance Improvements
- <criterion that became more observable or measurable>

## Remaining Open Questions
- <question that could change scope, behavior, or acceptance>
```
