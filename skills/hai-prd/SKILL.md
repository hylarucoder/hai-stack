---
name: hai-prd
description: Use when a user asks whether something needs a PRD, how to split or merge PRDs, PRD granularity, PRD scope, PRD design, writing product requirements, or rewriting, refining, auditing, repairing, or improving an existing PRD or requirements document.
---

# Hai PRD

For Chinese readers, see `SKILL.zh_CN.md`. The English `SKILL.md` is the execution source of truth.

## Overview

Use this skill for all PRD-related work: deciding whether a PRD is needed, choosing PRD granularity, splitting or merging PRDs, writing a PRD from an idea, and refining an existing PRD.

A PRD is not the default artifact. Not every idea, field, API, configuration change, or technical decision needs one. A PRD should serve product judgment: who needs to do what, why it matters now, where the boundary is, and how acceptance will be proven.

## Core Principle

Decide whether a PRD is needed before writing one.

- A PRD is a product argument, not a feature list.
- PRD granularity should follow user mental models and independent acceptance, not technical layers, teams, or files.
- One PRD should usually have one clear outcome, one main user journey or product boundary, and verifiable acceptance.
- Existing PRDs should be edited as systems: goal, scope, behavior, acceptance, risks, and rollout must agree.
- If the PRD boundary is wrong, split, merge, or reframe the boundary before polishing local wording.

## When To Use

Use this skill for:

- Deciding whether an idea needs a PRD.
- Deciding whether a requirement belongs in a PRD, goal, design doc, or task.
- Writing a PRD from a product problem or user scenario.
- Rewriting, refining, auditing, or repairing an existing PRD.
- Finding internal conflicts, unreasonable content, stale sections, local patches, or unverifiable acceptance.
- Deciding whether a PRD is too large, too small, unclear, or should be split or merged.
- Auditing a PRD set for duplicate boundaries, circular dependencies, or broken user journeys.

## Modes

### 1. Need PRD

First decide the artifact type:

| Situation | Better artifact |
|-----------|-----------------|
| User or business behavior changes and goal, scope, and acceptance need alignment | PRD |
| Execution goal, phases, and verification are the main need | `hai-goal` |
| Architecture, module boundaries, or technical tradeoffs are the main need | `hai-architecture` |
| The main question is whether the idea is worth doing | `hai-idea` |
| The work is a code task, bugfix, or test-first implementation | `hai-tdd` or task note |
| The work is documentation consistency auditing | documentation audit skill |

Ask:

- Is there a user-, buyer-, operator-, maintainer-, or business-visible behavior change?
- Does the work need explicit in-scope and out-of-scope boundaries?
- Does it need acceptance criteria to prove it was done correctly?
- Are there product-level options, risks, constraints, or rollout concerns to record?
- Would the team disagree on goal, scope, or acceptance without a PRD?

If most answers are no, do not force a PRD.

### 2. Design PRD

Turn a feature idea or product problem into PRD-level requirements:

1. Gather context.
   - Target user, product surface, current behavior, desired outcome, constraints, and assumptions.
   - Existing PRDs, docs, screenshots, user flows, issues, data, or adjacent specs.

2. Frame the requirement.
   - Write the problem in product language.
   - Define target outcome and non-goals.
   - Identify the user journey or workflow boundary.
   - Separate facts, assumptions, and open questions.

3. Shape scope.
   - Decide what belongs in this PRD versus another PRD, design doc, goal, or task.
   - Avoid bundling unrelated cleanup, platform work, or implementation refactors unless they directly affect product behavior or acceptance.

4. Define behavior and acceptance.
   - Describe expected behavior by scenario.
   - Add observable acceptance criteria.
   - Include edge cases, failure states, permissions, empty states, data dependencies, and rollout only when relevant.

### 3. Craft PRD

Refine an existing PRD as a whole product argument:

1. Read the full document first.
   - Identify title, target user, goal, journey, scope, non-goals, acceptance, risks, and open questions.
   - Mark contradictions, duplication, stale sections, local patches, and unreasonable content.

2. Diagnose document drift.
   - **Goal drift**: sections optimize for different outcomes.
   - **Scope drift**: requirements pull in unrelated work.
   - **Conflict drift**: behavior, state, permissions, data, or rollout disagree across sections.
   - **Acceptance drift**: acceptance criteria cannot prove the target outcome.
   - **Solution drift**: implementation choices replace product requirements.
   - **Local-edit drift**: one section improves while the whole PRD becomes worse.

3. Reframe before rewriting.
   - State the corrected target outcome.
   - State the PRD boundary.
   - Decide whether to preserve, reorganize, split, merge, or rewrite.

4. Craft the document.
   - Edit directly when the user provides a file.
   - Preserve useful content but move it to the right section.
   - Remove unsupported, duplicated, obsolete, or out-of-scope content.
   - Explain why removal is better than rewriting or moving when content is deleted.

### 4. Scope PRD

Judge PRD granularity by user mental model and independent acceptance, not technical modules or teams.

Six tests:

| Test | Question | Signal |
|------|----------|--------|
| Press Release | Can one sentence express one clear user value? | Multiple unrelated values lean split |
| Independent Value | Does this PRD deliver value on its own? | Independent value can split; no value leans merge |
| Independent Acceptance | Can it be accepted independently? | Independent acceptance can split |
| Domain Language | Does it share the same core entity, terminology, and lifecycle? | Same entity leans merge; different contexts lean split |
| User Journey | Does splitting break the user journey? | Broken journey means do not split |
| Time Appetite | Is the scope controlled? | Too large should split or cut; too small should merge |

Preferred split dimensions:

- User journey stage.
- Core path vs enhancement.
- User role.
- Risk or complexity.
- Platform or channel.

Do not split by:

- Technical layer: API PRD + frontend PRD + DB PRD.
- CRUD action: create/read/delete PRDs.
- Team ownership.

Three-tier classification:

| Tier | Definition | Rule |
|------|------------|------|
| Tier 1: Entity lifecycle | Full lifecycle of a core entity | One core entity usually gets one PRD |
| Tier 2: Aggregate view | Cross-entity view that owns no core entity | One aggregate surface gets one PRD |
| Tier 3: Platform extension | Distinct platform or channel experience | One platform/channel gets one PRD |

New feature decision flow:

1. Is it a new core entity with an independent lifecycle? If yes, likely new PRD.
2. Is it a cross-entity aggregate view? If yes, likely new PRD.
3. Is it a new platform or channel? If yes, likely new PRD.
4. If none apply, it usually belongs inside an existing PRD.

## Output Requirements

Read `references/output-template.md` before finalizing and choose the relevant mode:

- Need PRD: recommend PRD / goal / design doc / task / no separate artifact.
- Design PRD: output a PRD draft or edit the document directly.
- Craft PRD: output document-level diagnosis, repairs, and keep/remove/rewrite decisions.
- Scope PRD: output six-test assessment, split/merge recommendation, and proposed boundaries.

## What This Skill Is Not

- Not project management. Do not assign owners or dates unless asked.
- Not technical architecture design; use `hai-architecture`.
- Not execution planning; use `hai-goal` for phases and todos.
- Not a wrapper that turns every idea into a PRD. If there is no product boundary or acceptance need, do not force one.
