---
name: hai-idea
description: Use when the user asks whether an idea is good, worth doing, worth validating, too vague, risky, low-value, or should be killed, postponed, reframed, or turned into a goal. Trigger on 想法是不是好主意, 值不值得做, 要不要做, 是否应该验证, 该不该砍掉.
---

# Hai Idea

For Chinese readers, see `SKILL.zh_CN.md`. The English `SKILL.md` is the execution source of truth.

## Overview

Use this skill to judge whether an idea deserves attention.

The goal is not to politely praise the idea or produce a bland pros/cons list. The goal is to make the decision clear: do it, validate first, reframe it, defer it, or kill it.

An idea can be interesting and still be the wrong thing to do now. A good evaluation separates excitement, real value, opportunity cost, and proof.

## Core Principle

Make bold judgments, then verify carefully.

Give a clear call, but attach the call to evidence. Do not hide behind "it depends" when the audience is vague, the pain is weak, the cost is high, timing is wrong, or no proof path exists.

## When To Use

Use this skill when the user asks:

- Is this idea good?
- Is it worth doing?
- Should we build, write, launch, or spend time on it?
- Which idea is more worth doing?
- Does this idea have value, leverage, timing, market fit, or system value?
- Should this idea become a goal, PRD, experiment, or backlog item?
- Is this a distraction?

## Evaluation Frame

Evaluate only the dimensions that affect the decision:

- **Pain**: what real problem does it solve? Is the pain frequent, urgent, expensive, or emotionally sharp?
- **Audience**: who specifically benefits? Is the user, buyer, reviewer, maintainer, or operator clear?
- **Current workaround**: what do people do today? If the workaround is cheap and good enough, the idea is weaker.
- **Leverage**: does it create repeated value, reduce future cost, improve decisions, or compound across workflows?
- **Timing**: is now the right moment, or is the idea blocked by infrastructure, demand, trust, data, distribution, or attention?
- **Differentiation**: why is this not a generic clone, tiny convenience, or local preference?
- **Feasibility**: can it be done with available tools, skills, time, permissions, and dependencies?
- **Cost**: what does it consume: time, focus, architecture complexity, coordination, maintenance, reputation, or money?
- **Risk**: how could it fail, mislead, regress, create lock-in, or make later work harder?
- **Proof path**: what evidence would make the idea clearly stronger or weaker?

## Workflow

1. Restate the idea in one sentence.
   - Remove decoration and excitement.
   - Name the target user or affected system.
   - State the expected outcome.

2. Identify the decision.
   - Is the current decision to do, validate, prioritize, reframe, or kill?
   - If comparing ideas, rank by decision value rather than novelty.

3. Evaluate the decisive dimensions.
   - Penalize vague users, fake urgency, high maintenance cost, missing evidence, and high opportunity cost.
   - Reward sharp pain, repeated use, cheap validation, high leverage, and clear exit criteria.

4. Make the call.
   - Use exactly one of: **Do**, **Validate first**, **Reframe**, **Defer**, **Kill**.
   - Explain the reason directly.
   - If the idea has potential but is not executable yet, state what must become true first.

5. Define the smallest useful validation.
   - What is the cheapest test that could change the decision?
   - What signal would prove demand, feasibility, quality, or strategic value?
   - What result would show the idea is not worth continuing?

6. Choose the next skill if needed.
   - If the idea is worth executing, use `hai-goal`.
   - If it needs product requirements, use `hai-prd`.
   - If it needs bigger strategic challenge, use `geju`.
   - If it is mainly blocked by naming, use `hai-naming`.

Read `references/output-template.md` before finalizing.

## Verdict Guide

- **Do**: clear audience, real pain, good timing, manageable cost, and enough evidence to proceed.
- **Validate first**: plausible upside, but a key assumption is unproven.
- **Reframe**: the current idea is weak, but a stronger nearby direction exists.
- **Defer**: potentially good, but timing, dependencies, or opportunity cost are wrong now.
- **Kill**: weak pain, unclear audience, low leverage, high cost, or no credible proof path.

## Common Mistakes

- Treating an interesting idea as a good idea.
- Confusing "I can build it" with "it is worth doing".
- Ignoring opportunity cost.
- Accepting vague audiences like "everyone", "developers", or "teams" without a concrete scenario.
- Treating lack of evidence as neutral. Lack of evidence is itself a risk.
- Designing the full solution before deciding whether the idea deserves one.
