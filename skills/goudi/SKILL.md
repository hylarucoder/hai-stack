---
name: goudi
description: Use when the user asks to be grounded, avoid over-grand designs, make a bold proposal executable, pressure-test feasibility, prevent "too much vision and too little landing", or mentions 苟帝, 落地, 先落地, 别太飘, 收一收, 可执行, 可验证, 止损.
---

# Goudi

For Chinese readers, see `SKILL.zh_CN.md`. The English `SKILL.md` is the execution source of truth.

## Overview

Use this skill when a discussion has too much ambition and too little executable grounding. `goudi` is the counterweight to `geju`: `geju` opens the frame; `goudi` forces the move to land.

This skill is not about being timid, conservative, or anti-refactor. It is about making the chosen direction survivable, verifiable, reversible where possible, and useful in the next concrete step.

## Core Principle

先把路踩实，再谈大胜利。

Big ideas are allowed. Sweeping redesigns are allowed. Strong architecture opinions are allowed. But a useful proposal must answer:

- What is the smallest move that proves this direction?
- What evidence says the move is working?
- What real constraint can break it?
- What should be deliberately cut from the first attempt?
- Where is the stop rule if the thesis is wrong?

If the answer cannot produce a concrete first move, it is not a plan yet. It is only a mood.

## Relationship To Geju

Use `geju` when Codex is trapped by local details, compatibility fear, and small-patch thinking.

Use `goudi` when the answer has escaped too far upward and now needs to become an executable, testable, staged move.

They are designed to work as a pair:

- `geju`: "What is the clean target if we stop being scared?"
- `goudi`: "What is the first proof that this target can survive contact with reality?"

Do not let `goudi` erase the bold target. Compress the first step, not the ambition.

## What To Fight

### 1. Vision Without First Step

The proposal sounds right, but nobody knows what to do this afternoon.

Counter-move:

- Name the first concrete artifact: test, PRD patch, interface change, migration spike, prototype, benchmark, audit, or decision record.
- Define the exact scope of the first step.
- State what is intentionally out of scope.

### 2. Fake Migration Plan

The target model is clean, but the path assumes everything can be changed at once.

Counter-move:

- Identify existing contracts: persisted data, public API, user workflow, deployment, compliance, team ownership, or documented integration.
- Split target design from migration path.
- Prefer one narrow vertical slice over broad partial rewrites.
- Name the irreversible step and delay it until evidence exists.

### 3. Unpriced Risk

The answer says "we can refactor" without pricing data loss, behavior changes, blast radius, missing tests, or hidden callers.

Counter-move:

- List the top 3 risks by blast radius.
- Give each risk a verification method.
- Decide which risk must be retired before implementation.
- Reject work that cannot be validated inside a reasonable feedback loop.

### 4. Long-Term Correct, Short-Term Irresponsible

The direction may be right, but doing the full thing now would starve the current goal.

Counter-move:

- Separate the end-state from the next milestone.
- Ask whether the next milestone makes the system more correct even if the full target is not finished.
- Cut impressive but non-essential work.
- Preserve optionality when confidence is still low.

### 5. No Stop Rule

The plan can only continue; it cannot fail gracefully.

Counter-move:

- Define failure signals before starting.
- Define rollback or containment.
- Define when to pause and gather evidence.
- Make sunk-cost continuation unacceptable.

## Workflow

1. Restate the bold direction in one sentence.
   - Do not flatten the ambition.
   - Name whether it came from `geju`, a PRD, an architecture review, or the user's idea.

2. Run a reality check.
   - What real contracts constrain the work?
   - What system area carries the most blast radius?
   - What assumptions are unproven?
   - What part of the proposal is mostly aesthetic, speculative, or premature?

3. Choose the minimum viable move.
   - Pick one narrow vertical slice, proof point, or decision artifact.
   - Define what it changes and what it refuses to change.
   - Prefer something that creates evidence, not just more planning.

4. Make verification explicit.
   - Success criteria must be observable.
   - Failure signals must be named.
   - Verification should be cheap enough to run before confidence decays.
   - If testing is relevant, connect with `hai-tdd`.

5. Cut scope aggressively.
   - List the parts that should not be attempted in the first move.
   - Cut compatibility work that is not tied to a real contract.
   - Cut architecture polish that does not affect the proof point.
   - Cut broad migration until the narrow slice is proven.

6. Define the stop rule.
   - What evidence would kill or pause this direction?
   - What would force a smaller target?
   - What can be rolled back or isolated?
   - What decision should not be made yet?

7. Read `references/output-template.md` before finalizing the answer.

## Output Rules

- Lead with the landing judgment: go / shrink / pause / reject / validate first.
- Be concrete about the first move.
- Include what to cut from the first attempt.
- Include success criteria and failure signals.
- Name real constraints separately from anxiety or inertia.
- Preserve the bold target when it is useful, but do not let it replace execution.
- Do not write a giant plan unless the user asks for a full goal document; route to `hai-goal` for that.
- Do not turn `goudi` into "do nothing." The default is a smaller proof, not paralysis.

## What This Skill Is Not

- Not `geju`. It does not open the frame; it grounds an already opened frame.
- Not generic project management. It is a pressure test for whether a proposal can land.
- Not anti-refactor. It rejects fantasy migrations, not clean targets.
- Not TDD itself. Use `hai-tdd` when behavior needs to be driven by tests.
- Not a full goal document. Use `hai-goal` when the output needs phases, todos, and execution tracking.
