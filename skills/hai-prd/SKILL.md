---
name: hai-prd
description: |
  Produces a PRD recommendation, draft, or document-level diagnosis: decides whether a PRD is even
  needed (vs a goal, design doc, or task), drafts one from a product problem, audits/repairs an
  existing PRD for drift and unverifiable acceptance, or judges whether to split / merge it. Use
  whenever the user mentions a PRD, product requirements, requirements doc, or spec — writing,
  rewriting, refining, auditing, scoping, or splitting/merging one — even if they never say "PRD".
  Be pushy: trigger on casual asks like "turn this into a spec", "draft requirements for X", "is
  this PRD too big", "this PRD is a mess", "do we even need a PRD for this", "one PRD or two". Also
  on 写 PRD, 帮我写需求文档, 需求文档, 产品需求文档, PRD 拆分, PRD 合并, 这个 PRD 要不要拆,
  PRD 粒度, 帮我改需求文档.
---

# Hai PRD

For Chinese readers, see `SKILL.zh_CN.md`. The English `SKILL.md` is the execution source of truth.

## Overview

Handle all PRD-related work: deciding whether a PRD is even needed, choosing PRD granularity,
splitting or merging PRDs, drafting a PRD from a product problem, and refining an existing one.

The non-obvious framing: a PRD is not the default artifact. Not every idea, field, API,
configuration change, or technical decision earns one. Pick the mode that fits the request and
do not wrap work in a PRD when there is no product boundary or acceptance to prove.

## Core Principle

A PRD is a product argument with verifiable acceptance — not a feature list. Three rules carry
the rest:

- **Acceptance must be provable.** One PRD should resolve one clear outcome, one main user journey
  or product boundary, and acceptance criteria that prove it shipped.
- **Boundary follows the user's mental model, not the tech.** Granularity tracks user journeys and
  independent acceptance — not technical layers, teams, or files.
- **Fix the boundary before the wording.** If the PRD boundary is wrong, split, merge, or reframe
  it before polishing local sentences; edit an existing PRD as a system where goal, scope, behavior,
  acceptance, risks, and rollout must agree.

## Modes

### 1. Need PRD

First decide the artifact type — a PRD is one option among several:

| Situation | Better artifact |
|-----------|-----------------|
| User or business behavior changes and goal, scope, and acceptance need alignment | PRD |
| Execution goal, phases, and verification are the main need | `hai-goal` |
| Architecture, module boundaries, or technical tradeoffs are the main need | `hai-architecture` |
| The main question is whether the idea is worth doing at all | `hai-idea` |
| The work is a code task, bugfix, or test-first implementation | `hai-tdd` or task note |
| The work is documentation consistency auditing | doc-audit skill (vs code or internal) |

Ask:

- Is there a user-, buyer-, operator-, maintainer-, or business-visible behavior change?
- Does the work need explicit in-scope and out-of-scope boundaries?
- Does it need acceptance criteria to prove it was done correctly?
- Are there product-level options, risks, constraints, or rollout concerns to record?
- Would the team disagree on goal, scope, or acceptance without a PRD?

If most answers are no, do not force a PRD. When auditing a *set* of PRDs, also check for duplicate
boundaries, circular dependencies, or broken user journeys across them.

### 2. Design PRD

Turn a feature idea or product problem into PRD-level requirements:

1. **Gather context.** Target user, product surface, current behavior, desired outcome, constraints,
   assumptions; plus existing PRDs, docs, screenshots, user flows, issues, data, or adjacent specs.
2. **Frame the requirement.** Write the problem in product language; define the target outcome and
   non-goals; identify the user journey or workflow boundary; separate facts, assumptions, and open
   questions.
3. **Shape scope.** Decide what belongs in this PRD versus another PRD, design doc, goal, or task.
   Do not bundle unrelated cleanup, platform work, or refactors unless they directly affect product
   behavior or acceptance.
4. **Define behavior and acceptance.** Describe expected behavior by scenario; add observable
   acceptance criteria; include edge cases, failure states, permissions, empty states, data
   dependencies, and rollout only when relevant.

### 3. Craft PRD

Refine an existing PRD as a whole product argument:

1. **Read the full document first.** Identify title, target user, goal, journey, scope, non-goals,
   acceptance, risks, and open questions; mark contradictions, duplication, stale sections, local
   patches, and unreasonable content.
2. **Diagnose document drift** using this taxonomy:
   - **Goal drift**: sections optimize for different outcomes.
   - **Scope drift**: requirements pull in unrelated work.
   - **Conflict drift**: behavior, state, permissions, data, or rollout disagree across sections.
   - **Acceptance drift**: acceptance criteria cannot prove the target outcome.
   - **Solution drift**: implementation choices replace product requirements.
   - **Local-edit drift**: one section improves while the whole PRD becomes worse.
3. **Reframe before rewriting.** State the corrected target outcome and the PRD boundary; decide
   whether to preserve, reorganize, split, merge, or rewrite.
4. **Craft the document.** Edit directly when the user provides a file; preserve useful content but
   move it to the right section; remove unsupported, duplicated, obsolete, or out-of-scope content;
   explain why removal beats rewriting or moving when content is deleted.

### 4. Scope PRD

Judge PRD granularity by user mental model and independent acceptance, not technical modules or
teams. Run the six tests — this is the decision core:

| Test | Question | Signal |
|------|----------|--------|
| Press Release | Can one sentence express one clear user value? | Multiple unrelated values lean split |
| Independent Value | Does this PRD deliver value on its own? | Independent value can split; no value leans merge |
| Independent Acceptance | Can it be accepted independently? | Independent acceptance can split |
| Domain Language | Does it share the same core entity, terminology, and lifecycle? | Same entity leans merge; different contexts lean split |
| User Journey | Does splitting break the user journey? | Broken journey means do not split |
| Time Appetite | Is the scope controlled? | Too large should split or cut; too small should merge |

When the tests point toward split or merge, read `references/scope-tiers.md` to pick a concrete
cut: the preferred split dimensions, the splits to avoid (technical layer / CRUD / team ownership,
because no such fragment is independently acceptable), the three-tier classification (entity
lifecycle / aggregate view / platform extension), and the new-feature decision flow.

## Workflow

1. **Pick the mode** from the request: necessity check → Need PRD; draft from a problem → Design
   PRD; refine an existing doc → Craft PRD; split/merge/granularity → Scope PRD. A request may span
   modes (e.g. necessity then scope).
2. **Run that mode's procedure above.** Apply the Core Principle throughout — fix the boundary
   before the wording.
3. **For split/merge questions**, run the six tests, then consult `references/scope-tiers.md` for
   the concrete cut and classification.
4. **Produce the output** for the active mode (see below). When a worked run helps, read
   `references/worked-example.md` for an end-to-end split decision and an end-to-end craft/diagnosis.

## Output

Map the active mode to its template section, then fill only the relevant sections:

```markdown
# Hai PRD: <topic or document name>
## Mode               (Need PRD / Design PRD / Craft PRD / Scope PRD)
## PRD Necessity       — Need PRD: recommend PRD / hai-goal / design doc / task / no separate artifact
## PRD Draft           — Design PRD: target outcome, problem, users, scope, requirements, acceptance
## Existing PRD Diagnosis — Craft PRD: main drift, conflicts, remove/keep/rewrite, acceptance repairs
## PRD Scope Assessment — Scope PRD: six-test signals, split/merge recommendation, suggested boundaries
## Remaining Open Questions
## Next Step
```

Read `references/output-template.md` before finalizing. Do not mechanically emit every section —
output only the mode(s) relevant to the question.

## Use a different skill when

Routing away from a PRD is the Need-PRD decision itself — see the table in **Mode 1**. In short:
settle execution phases/todos in **hai-goal**, module boundaries and tradeoffs in
**hai-architecture**, whether the idea is worth doing in **hai-idea**, a code/bugfix/test-first
task in **hai-tdd**, what fields an entity should have and where they live in
**entity-model-auditor**, documentation consistency in the **doc-audit** skills, and an
anchor-first rewrite of a drifted non-PRD document in **hai-rewrite-doc**. Return to PRD work
only when a product boundary and provable acceptance actually need to exist.

## What this skill is NOT

- Not project management — do not assign owners or dates unless asked.
- Not a wrapper that turns every idea into a PRD — if there is no product boundary or acceptance
  need, recommend the right artifact from the Need-PRD table instead of forcing a PRD.
