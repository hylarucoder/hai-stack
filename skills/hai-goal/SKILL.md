---
name: hai-goal
description: |
  Produces a written goal document before execution starts — a verifiable target, boundary,
  current state, phased route, per-phase rules, todos with proof, a dry-run, and a Go / No-Go
  judgment — instead of coding while watching to see if it works. Use whenever the user wants to
  start, go, implement, ship, build, or move forward; gives a vague intent that needs a concrete
  goal; asks to break work into phases or todos; or hands over an existing plan plus a target and
  wants it rewritten and re-anchored around that target. Trigger even when they never say "goal"
  or "plan": 开始干, 开搞, 我们开始吧, 先别急着写代码先定个目标, 把这个拆成阶段, 拆 todo, 落地方案,
  执行计划, 怎么落地, 立个目标, 围绕X重新规划, 重写这个计划, "lets just ship this", "gonna start
  building now", or just a one-line intent plus "do it". To first decide whether the work is even
  worth doing, use hai-idea instead.
---

# Hai Goal

For Chinese readers, see `SKILL.zh_CN.md`. The English `SKILL.md` is the execution source of truth.

## Overview

Use this skill before meaningful execution. Its job is to stop "running while watching" and first
write a goal document: a concrete, goal-oriented plan that defines what should become true, how to
phase the work, what rules govern each phase, and how completion will be verified. It also handles
a second common case — the user already has a plan but names a target and asks you to rewrite the
plan around that target — by preserving useful material, discarding local noise, reprioritizing
phases, and producing a stronger goal document.

## Core Principle

Write the goal before you go.

Do not start by coding, editing, or loosely exploring while hoping execution will clarify the
target. The "run and watch" failure mode — which this skill exists to prevent — looks like:

- Start implementation before the target is stable.
- Discover missing decisions halfway through.
- Patch local problems instead of shaping the whole route.
- Let phase boundaries emerge accidentally.
- Forget to define what counts as done.
- Treat validation as an afterthought.

Most work should first become a written goal document with a verifiable goal, boundaries, phases,
rules, todos, dependencies, and proof. When a plan already exists, the target takes priority over
the old plan shape.

## The Goal Document

A goal document is a runnable plan for execution. It answers:

- **Target**: what are we trying to make true?
- **Boundary**: what is included, excluded, and intentionally deferred?
- **Current state**: what exists now, with known constraints and risks?
- **Route**: what phases get us there?
- **Rules**: what constraints or working agreements govern each phase?
- **Todos**: what concrete tasks belong in each phase?
- **Verification**: how do we prove each phase, and the whole goal, is done?
- **Stop conditions**: when should we pause, ask, or revise the plan?

The exact output shape — including the conditional rewrite sections — lives in
`references/output-template.md`. Read it before finalizing; do not re-derive the field list here.

A fresh goal document and a plan rewrite use the same template; the rewrite case additionally fills
the **Plan Rewrite Notes** and **Drift Diagnosis** sections (see step 4).

## Workflow

This single sequence covers every case — making a goal from vague intent, crafting phases for a
known goal, and rewriting an existing plan around a target. Run step 4 only when an existing plan
is provided.

1. **Freeze the intent.** What does the user want to start? What outcome would make the work worth
   doing? What must not be broken? What is still unknown?

2. **Make the goal verifiable.** Rewrite vague activity into a target outcome. Define the boundary
   (included, excluded, deferred). Choose the strongest available evidence source — test, metric,
   review, artifact, command, behavior, user signal, or trace — and a clear pass/fail rule with a
   confidence note, and name the judgment owner — who or what is authorized to declare it done.
   Quantify when useful, but do not invent fake metrics. If one intent contains
   multiple goals, split them.

3. **Convert the goal into a goal document.** Record assumptions and unresolved decisions, identify
   affected surfaces (docs, code, schema, API, UI, tests, workflows, links), and define what "ready
   to execute" means.

4. **If rewriting an existing plan, re-anchor it to the target.** Extract the plan's phases, todos,
   assumptions, dependencies, and highlighted focus points. Diagnose drift — goal drift, phase
   drift, validation drift, compatibility drift, cleanup drift — and decide per item what to keep,
   reorder, merge, or remove. Move high-risk, high-uncertainty, or high-leverage work earlier unless
   dependencies forbid it. Keep old wording only when it remains accurate under the new target.

5. **Split into phases.** Each phase should produce a reviewable state. Split by learning, risk
   reduction, user-visible value, system boundary, dependency order, vertical slice, decision
   boundary, or validation boundary — never by department, file type, arbitrary chronology, or topic
   heading. Avoid phases that only say "implement X" without proof.

6. **Define phase rules.** For each phase, state what is allowed, what is explicitly not allowed yet,
   what compatibility or migration rule applies, what documentation update is required, and what
   validation must pass before moving on. Concrete patterns to draw from:
   - Do not touch implementation until the target doc is updated.
   - This phase may rename internal callers directly; no compatibility shim unless a public contract exists.
   - This phase may only change docs and tests, not production code.
   - This phase exits only when the command/test/check passes.
   - Stop if a todo requires a product decision not present in the goal document.

7. **Create todos with action + surface + proof** (see template). Make them concrete enough to
   execute without guessing, mark dependencies and blockers that affect order, and keep unrelated
   cleanup out unless the phase goal requires it.

8. **Dry-run the route.** Walk the phases in order without executing them; look for missing
   prerequisites, circular dependencies, vague todos, and unverified assumptions; revise the goal
   document before any real work. This step is what separates a goal document from generic planning.

9. **Decide whether to Go.** If the route is coherent, execution can start. If it carries unresolved
   decisions, resolve them with the right skill first (see below) and re-run the dry-run.

## Output

Return a goal document, not just advice. Inline skeleton (fill every section in
`references/output-template.md`):

```markdown
# Goal Document: <work name>
## Go / No-Go            — Go / No-Go / Go after decisions, plus reason
## Target Outcome
## Goal Definition       — boundary, non-goals, deferred, verification rule, evidence source, pass criteria, confidence note, judgment owner (who/what declares it done)
## Current State
## Plan Rewrite Notes    — rewrite case only
## Drift Diagnosis       — rewrite case only
## Priority Rationale
## Assumptions and Open Decisions
## Phases                — per phase: purpose, entry condition, phase rules, todos (action/surface/proof/depends-on), exit proof, stop condition
## Dry-Run Findings
## Final Validation
## First Execution Step
```

Read `references/output-template.md` before finalizing. Omit **Plan Rewrite Notes** and **Drift
Diagnosis** for a fresh goal document.

## Use a different skill when

- **hai-idea** — it is unclear the work is worth doing at all. Validate or kill the idea before
  spending effort on a goal document.
- **hai-prd** — the route has unresolved product or scope decisions. Settle the requirement, then
  return to write the goal.
- **hai-architecture** — the route has unresolved structural or boundary decisions. Settle the
  design, then return.
- **hai-tdd** — a phase is ready to implement. The goal document hands off to test-driven execution
  inside each phase.

## What this skill is NOT

- Not generic planning detached from action — a "plan" here is a runnable goal document, and it
  must be executable.
- Not a project management calendar. Dates and owners are optional unless the user asks for them.
