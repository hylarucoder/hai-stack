---
name: prd-craft
description: Use when a user asks to rewrite, refine, repair, rework, audit, or improve an existing PRD or requirements document; especially when the PRD may contain internal conflicts, unreasonable requirements, stale sections, content that should be removed, or local edits that fail to consider the whole document.
---

# PRD Craft

## Overview

Use this skill to craft an existing PRD into a stronger whole document. The job is not to polish one paragraph in isolation; it is to preserve the document's target outcome, repair structure, align sections, and make acceptance verifiable.

## Core Principle

Edit the PRD as a system:

- Treat each section as part of one product argument: problem, goal, scope, behavior, acceptance, risks, and rollout should agree.
- Do not make a local edit that contradicts another section.
- Identify content that should be removed, not only content that should be rewritten.
- Replace vague asks with product outcomes and observable behavior.
- Convert hidden assumptions into explicit assumptions, constraints, or open questions.
- Keep implementation detail only when it affects user behavior, product contracts, or validation.

## Workflow

1. Read the whole document first.
   - Identify title, target user, goal, user journey, scope, non-goals, acceptance criteria, risks, and open questions.
   - Mark contradictions, duplicate claims, stale sections, and places where local wording hides a document-level problem.
   - Mark unreasonable content: requirements with no user value, unsupported constraints, premature implementation detail, unverifiable acceptance, obsolete sections, and content outside the PRD boundary.

2. Diagnose document drift.
   - Goal drift: sections optimize for different outcomes.
   - Scope drift: requirements pull in unrelated work.
   - Conflict drift: two sections make incompatible claims about behavior, scope, state, permissions, data, or rollout.
   - Acceptance drift: criteria cannot prove the stated goal.
   - Solution drift: implementation choices replace product requirements.
   - Local-edit drift: one section improves while the whole PRD becomes less coherent.

3. Reframe before rewriting.
   - State the corrected target outcome.
   - State the intended PRD boundary.
   - Decide whether the document should be preserved, reorganized, split, or rewritten.

4. Craft the document.
   - Edit directly when the user gave a file.
   - Preserve useful content, but move it to the right section.
   - Remove or mark claims that are unsupported, duplicated, or outside scope.
   - For every removal, state why deletion is better than rewriting or moving.
   - Read `references/output-template.md` before finalizing.

## Output Standard

When editing a PRD, return:

1. What changed at the document level.
2. Which contradictions or scope issues were resolved.
3. What should be removed and why.
4. Which acceptance criteria became more verifiable.
5. Any remaining open questions that could change the PRD.

## What This Skill Is Not

- Not copyediting only. Language polish is secondary to document coherence.
- Not implementation planning. PRD craft stops at requirements and acceptance.
- Not PRD splitting unless the document-level diagnosis shows the PRD boundary is wrong.
