---
name: hai-goal
description: |
  Creates or rewrites a goal document for ambiguous, multi-phase, high-risk, or explicitly planned execution: verifiable outcome, boundary, current state, phases, proof-bearing todos, dry-run, and Go/No-Go. Use when the user asks for a goal, plan, phases, todos, or to re-anchor an existing plan（定目标、拆阶段、执行计划）. Do not interpose it on a small implementation whose outcome and verification are clear; hand ready work to normal execution, using hai-tdd only for suitable behavior changes.
---

# Hai Goal

For Chinese readers, see `SKILL.zh_CN.md`. The English `SKILL.md` is the execution source of truth.

## Overview

Use this skill when execution is ambiguous, spans meaningful phases, carries material risk, or the
user explicitly asks for a plan. It turns the work into a verifiable target, boundary, route, and
proof. It also rewrites an existing plan around a newly stated target. A small task with an obvious
outcome and verification should proceed directly without ceremony.

## Core Principle

Write the goal before you go.

When this skill's trigger conditions apply, do not start implementation while hoping execution will
clarify the target. The "run and watch" failure mode looks like:

- Start implementation before the target is stable.
- Discover missing decisions halfway through.
- Patch local problems instead of shaping the whole route.
- Let phase boundaries emerge accidentally.
- Forget to define what counts as done.
- Treat validation as an afterthought.

Complex or unclear work should first become a goal document with boundaries, phases, dependencies,
and proof. When a plan already exists, the target takes priority over the old plan shape.

## The Goal Document

A goal document is a runnable plan for execution. It answers:

- **Target**: what are we trying to make true?
- **Boundary**: what is included, excluded, and intentionally deferred?
- **Current state**: what exists now, with known constraints and risks?
- **Route**: what phases get us there?
- **Rules**: what constraints or working agreements govern each phase?
- **Todos**: what concrete tasks belong in each phase?
- **Progress management**: for multi-phase execution, what checklist should stay current?
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

8. **Add progress management when execution will continue across phases or sessions.** Use one
   phase checklist with nested proof-bearing todos. Mark a phase complete only after its exit proof
   passes, and record any reprioritization instead of silently following stale order. Omit this
   machinery for a short one-session plan.

9. **Dry-run the route.** Walk the phases in order without executing them; look for missing
   prerequisites, circular dependencies, vague todos, and unverified assumptions; revise the goal
   document before any real work. This step is what separates a goal document from generic planning.

10. **Decide whether to Go.** If the route is coherent, execution can start. If it carries unresolved
   decisions, resolve them with the right skill first (see below) and re-run the dry-run.

## Output

Return a goal document, not generic advice. Fill `references/output-template.md` and omit conditional
sections that do not apply: rewrite notes for a fresh goal, and progress tracking for a short plan.
Do not duplicate the template inside the main instructions.

## Use a different skill when

- **hai-idea** — it is unclear the work is worth doing at all. Validate or kill the idea before
  spending effort on a goal document.
- **hai-prd** — the route has unresolved product or scope decisions. Settle the requirement, then
  return to write the goal.
- **hai-architecture** — the route has unresolved structural or boundary decisions. Settle the
  design, then return.
- **Execution** — once a phase is ready and implementation is requested, continue through the
  complete change and proportionate verification. Use **hai-tdd** for testable behavior; use
  compiler checks, existing tests, and focused runtime checks for structural/config/style work.
  Do not stop after producing a plan when the user already asked to implement.
- **code-review-and-quality** — inspect completed changes for defects.
- **write-technical-acceptance-report** — prove the outcome against acceptance; use compact mode
  for low-risk work. Reuse existing current evidence instead of repeating checks without cause.
- **hai-rewrite-doc** — the drifted artifact is a general document, not a plan or goal document.
  This skill's rewrite mode owns plans; anchor-first rewriting of everything else lives there.

## What this skill is NOT

- Not generic planning detached from action — a "plan" here is a runnable goal document, and it
  must be executable.
- Not a project management calendar. Dates and owners are optional unless the user asks for them.
