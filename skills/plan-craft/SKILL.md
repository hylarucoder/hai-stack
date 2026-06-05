---
name: plan-craft
description: Use when a user asks to rewrite, refine, repair, or improve an implementation plan, execution plan, RFC plan, or task plan; especially when the plan has local edits but lacks whole-document coherence, phases, proof points, or verifiable todos.
---

# Plan Craft

## Overview

Use this skill to craft an existing plan into an executable whole. A good plan is not a bag of todos; it connects target outcome, constraints, phases, task order, and validation.

## Core Principle

Edit the plan from the whole-document goal:

- Start with the target outcome and success criteria.
- Make phases represent meaningful progress, not arbitrary headings.
- Ensure every todo has a proof point: test, command, review, trace, artifact, or observable behavior.
- Do not preserve compatibility work unless a real contract or explicit instruction requires it.
- Do not improve one section in a way that breaks phase order, scope, or validation elsewhere.

## Workflow

1. Read the whole plan.
   - Identify target outcome, assumptions, phases, todos, dependencies, risks, and validation.
   - Mark local edits that do not serve the overall plan.

2. Diagnose plan drift.
   - Goal drift: tasks do not prove the target outcome.
   - Phase drift: phases are grouped by topic instead of execution order or vertical slice.
   - Validation drift: success means "changed files" rather than proven behavior.
   - Compatibility drift: aliases, shims, or dual paths exist without a named contract.
   - Cleanup drift: unrelated refactors are mixed into the core work.

3. Recraft the plan.
   - Rewrite the target outcome in one clear paragraph.
   - Define invariants and non-goals.
   - Reorder phases so each phase produces a reviewable state.
   - Convert vague tasks into concrete todos with validation.
   - Read `references/output-template.md` before finalizing.

## Todo Quality Bar

Each todo should include:

- **Action**: what to change or inspect.
- **Surface**: file, module, document, API, UI, or command affected.
- **Proof**: how completion will be verified.
- **Dependency**: what must be true before it starts, if any.

## What This Skill Is Not

- Not a project manager. It does not assign owners or calendar dates unless asked.
- Not a PRD writer. Product requirements belong in `prd-design` or `prd-craft`.
- Not a code implementation skill. It creates a plan that implementation can follow.
