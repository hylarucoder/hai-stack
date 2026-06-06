# Hai PRD: Scope Dimensions, Tiers, and New-Feature Flow

Read this when the six-test in SKILL.md points toward split / merge and you need to
choose a concrete cut, classify a PRD, or decide where a new feature lands. The six-test
table in SKILL.md is the decision core; this file holds the supporting apparatus.

## Preferred split dimensions

Split a PRD along a dimension where each fragment still carries independently
acceptable user value:

- **User journey stage** — distinct stages of one journey can be accepted separately.
- **Core path vs enhancement** — the must-have flow can ship and be accepted before the nice-to-have.
- **User role** — different actors have different acceptance and value.
- **Risk or complexity** — isolating a high-risk slice lets it be validated on its own.
- **Platform or channel** — a distinct platform experience is independently usable.

## Do not split by

These cuts fragment one user-acceptable journey across documents that nobody can accept
independently:

- **Technical layer** (API PRD + frontend PRD + DB PRD) — because no single layer delivers
  user-visible value or can be accepted on its own; the value only exists when the stack works end to end.
- **CRUD action** (separate create / read / delete PRDs) — because the operations are one
  lifecycle and splitting them leaves each fragment without a complete, acceptable behavior.
- **Team ownership** — because org structure is not user value; splitting by team scatters one
  journey across docs that mirror the org chart, not the product boundary.

## Three-tier classification

| Tier | Definition | Rule |
|------|------------|------|
| Tier 1: Entity lifecycle | Full lifecycle of a core entity | One core entity usually gets one PRD |
| Tier 2: Aggregate view | Cross-entity view that owns no core entity | One aggregate surface gets one PRD |
| Tier 3: Platform extension | Distinct platform or channel experience | One platform/channel gets one PRD |

## New-feature decision flow

1. Is it a new core entity with an independent lifecycle? If yes, likely a new PRD.
2. Is it a cross-entity aggregate view? If yes, likely a new PRD.
3. Is it a new platform or channel? If yes, likely a new PRD.
4. If none apply, it usually belongs inside an existing PRD.
