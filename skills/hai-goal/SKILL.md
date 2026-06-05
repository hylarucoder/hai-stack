---
name: hai-goal
description: Use when the user wants to start execution, "go", implement, ship, move forward, define a vague goal, break a goal into phases and todos, or rewrite an existing plan around a specified goal before execution.
---

# Hai Goal

For Chinese readers, see `SKILL.zh_CN.md`. The English `SKILL.md` is the execution source of truth.

## Overview

Use this skill before meaningful execution. Its job is to stop "running while watching" and first write a goal document: a concrete goal-oriented plan that defines what should become true, how to phase the work, what rules govern each phase, and how completion will be verified.

It also handles a second common case: the user already has a plan, but names a target and asks you to rewrite the plan around that target. In that case, preserve useful material, discard local noise, reprioritize phases, and turn the result into a stronger goal document.

## Core Principle

Write the goal before you go.

Do not start by coding, editing, or loosely exploring while hoping execution will clarify the target. Most work should first become a written goal document with a verifiable goal, boundaries, phases, rules, todos, dependencies, and proof.

## Why This Exists

The common failure mode is "run and watch":

- Start implementation before the target is stable.
- Discover missing decisions halfway through.
- Patch local problems instead of shaping the whole route.
- Let phase boundaries emerge accidentally.
- Forget to define what counts as done.
- Treat validation as an afterthought.

`hai-goal` merges the previous goal and plan workflows into one method: before going, write the goal document; while crafting it, ensure it is executable. When a plan already exists, the goal takes priority over the old plan shape.

## Goal Document

A goal document is a plan for execution. It should answer:

- **Target**: what are we trying to make true?
- **Boundary**: what is included, excluded, and intentionally deferred?
- **Current state**: what exists now?
- **Route**: what phases get us there?
- **Rules**: what constraints or working agreements govern each phase?
- **Todos**: what concrete tasks belong in each phase?
- **Verification**: how do we prove each phase is done?
- **Stop conditions**: when should we pause, ask, or revise the plan?

Read `references/output-template.md` before finalizing the goal document.

## Modes

- **Make goal**: use when the user gives vague intent and needs clear, verifiable goals.
- **Craft goal**: use when the user gives a goal and needs phases, todos, dependencies, and proof.
- **Rewrite around target**: use when the user gives an existing plan plus a target, priority, constraint, or new direction. The output should be a rewritten goal document, not a light edit of the old plan.
- **Go document**: use when the user wants execution to start, but the route needs to be written before acting.

## Workflow

1. Freeze the intent.
   - What does the user want to start?
   - What outcome would make the work worth doing?
   - What must not be broken?
   - What is still unknown?

2. Make the goal verifiable.
   - Rewrite vague activity into a target outcome.
   - Define the boundary: included, excluded, and intentionally deferred.
   - Choose the strongest available evidence source: test, metric, review, artifact, command, behavior, user signal, or trace.
   - Define pass/fail criteria and a confidence note. Quantify when useful, but do not invent fake metrics.
   - If one intent contains multiple goals, split them.

3. Convert the goal into a goal document.
   - Record assumptions and unresolved decisions.
   - Identify affected surfaces: docs, code, schema, API, UI, tests, workflows, or links.
   - Define what "ready to execute" means.

4. If rewriting an existing plan, re-anchor it to the target.
   - Extract the plan's existing phases, todos, assumptions, dependencies, and highlighted focus points.
   - Diagnose drift: goal drift, phase drift, validation drift, compatibility drift, and cleanup drift.
   - Decide what still serves the target, what should be reordered, what should be merged, and what should be removed.
   - Move high-risk, high-uncertainty, or high-leverage work earlier unless dependencies make that impossible.
   - Convert vague phases into phase outcomes with proof.
   - Keep old wording only when it remains accurate under the new target.

5. Split into phases.
   - Each phase should produce a reviewable state.
   - Split by learning, risk reduction, user-visible value, system boundary, dependency order, vertical slice, decision boundary, or validation boundary.
   - Do not split by department, file type, arbitrary chronology, or topic headings.
   - Avoid phases that only say "implement X" without proof.

6. Define phase rules.
   - What is allowed in this phase?
   - What is explicitly not allowed yet?
   - What compatibility or migration rule applies?
   - What documentation update is required?
   - What validation must pass before moving on?

7. Create todos.
   - Each todo needs an action, surface, and proof.
   - Todos should be concrete enough to execute without guessing.
   - Keep unrelated cleanup out unless it is required by the phase goal.
   - Mark dependencies and blockers when they affect order.

8. Dry-run the route.
   - Walk the phases in order without executing them.
   - Look for missing prerequisites, circular dependencies, vague todos, and unverified assumptions.
   - Revise the goal document before starting real work.

9. Decide whether to Go.
   - If the route is coherent, execution can start.
   - If the route has unresolved product or architecture issues, use `hai-prd` or `hai-architecture` before execution.

## Goal Quality Bar

A strong goal has:

- **Outcome**: the desired state, not a vague activity.
- **Boundary**: what is included, excluded, and deferred.
- **Verification**: how to prove it.
- **Evidence source**: test, metric, review, artifact, command, user signal, trace, or observable behavior.
- **Pass criteria**: a clear pass/fail rule.
- **Confidence**: why the evidence is credible, or which proxy is being used.
- **Judgment owner**: system, test, metric, reviewer, user signal, or explicit acceptance.

## Phase Rule Examples

Use rules like these when relevant:

- Do not touch implementation until the target doc is updated.
- This phase may rename internal callers directly; no compatibility shim unless a public contract exists.
- This phase may only change docs and tests, not production code.
- This phase exits only when the command/test/check passes.
- Stop if a todo requires a product decision not present in the goal document.

## Output Standard

Return a goal document, not just advice. It should include:

1. Target outcome.
2. Assumptions and open decisions.
3. Boundary, non-goals, and deferred work.
4. Verification rule and evidence source.
5. Priority rationale, especially when rewriting an existing plan.
6. Phase list.
7. Rules per phase.
8. Todos per phase.
9. Verification per phase.
10. Go / No-Go judgment.

## What This Skill Is Not

- Not implementation. It prepares execution.
- Not generic planning detached from action. Plan is a specialized goal document here, and it must be runnable.
- Not a project management calendar. Dates and owners are optional unless asked.
- Not a cosmetic plan rewrite. If an existing plan conflicts with the target, rewrite the structure.
- Not a place to preserve a plan because it exists. If the plan does not serve the goal, delete or restructure it.
