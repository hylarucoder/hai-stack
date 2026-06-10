---
name: goudi
description: |
  Pressure-tests an ambitious proposal and returns a grounded landing judgment (go / shrink / pause / reject / validate-first) with one minimum-viable first move, an explicit cut list, success/failure signals, and a stop rule. Use whenever a discussion has more vision than executable grounding, or the user asks how to land/ship a bold idea, define the smallest first step, scope down, pressure-test feasibility, price risk, or set a stop/rollback rule — even if they never name the skill. Triggers on 苟帝, 落地, 先落地, 怎么落地, 别太飘, 太理想化, 收一收, 砍范围, 可执行, 可验证, 最小可行, MVP, 止损, 回滚, 风险有多大, and on "make this real / be realistic / what do I do first / is this plan feasible" — including right after a geju or architecture session. Use geju instead when the goal is to open the frame and think bigger.
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

`goudi` and `geju` are a designed pair:

- `geju`: "What is the clean target if we stop being scared?"
- `goudi`: "What is the first proof that this target can survive contact with reality?"

Do not let `goudi` erase the bold target. Compress the first step, not the ambition.

## Workflow

1. Restate the bold direction in one sentence. Do not flatten the ambition. Name where it came from — `geju`, a PRD, an architecture review, or the user's idea.

2. Run a reality check. Scan for the five anti-patterns, then name the constraints they expose:
   - **Vision without first step** — sounds right, but nobody knows what to do this afternoon.
   - **Fake migration plan** — clean target, but the path assumes everything changes at once.
   - **Unpriced risk** — "we can refactor" with no cost on data loss, blast radius, missing tests, or hidden callers.
   - **Long-term correct, short-term irresponsible** — the full thing now would starve the current goal.
   - **No stop rule** — the plan can only continue; it cannot fail gracefully.

   Then answer: what real contracts constrain the work? What area carries the most blast radius? What assumptions are unproven? What part is mostly aesthetic, speculative, or premature? For the per-pattern counter-moves, read `references/anti-patterns.md`.

3. Choose the minimum viable move. Pick one narrow vertical slice, proof point, or decision artifact. Define what it changes and what it refuses to change. Prefer something that creates evidence, not just more planning.

4. Make verification explicit. Success criteria must be observable; failure signals must be named; the check must be cheap enough to run before confidence decays. If behavior needs to be driven by tests, route to `hai-tdd`.

5. Cut scope aggressively. List what the first move should not attempt. Cut compatibility work not tied to a real contract, architecture polish that does not affect the proof point, and broad migration until the narrow slice is proven.

6. Define the stop rule. What evidence would kill or pause this direction? What would force a smaller target? What can be rolled back or isolated? What decision should not be made yet?

## Output

Produce the answer using `references/output-template.md` — load it before drafting. It fixes the section order: Landing Judgment / Bold Direction Kept / Reality Check / Minimum Viable Move / Verification / Cut List / Stop Rule / Next Move.

Beyond the template's per-field shape, hold these constraints:

- Lead with the verdict — go / shrink / pause / reject / validate first — not with the analysis.
- Name real constraints separately from anxiety or inertia.
- Preserve the bold target when it is useful, but do not let it replace execution.
- The default is a smaller proof, not paralysis. Do not turn `goudi` into "do nothing."
- Do not write a giant plan; route to `hai-goal` when the output needs phases, todos, and execution tracking.

## Route elsewhere when

- The goal is to open the frame, escape compatibility fear, and think bigger — use `geju`. (`goudi` grounds an already opened frame; it does not open one.)
- The question is whether the idea deserves doing at all — use `hai-idea`. `goudi` pressure-tests how to land a proposal, not whether it should exist.
- Behavior needs to be driven by tests — use `hai-tdd`.
- The output needs full phases, todos, and execution tracking — use `hai-goal`.

## What This Skill Is Not

- Not generic project management. It is a pressure test for whether a proposal can land.
- Not anti-refactor and not timid. It rejects fantasy migrations, not clean targets — and the default is a smaller proof, not standing still.
