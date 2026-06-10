---
name: hai-idea
description: |
  Evaluates whether an idea deserves attention and returns a clear verdict — Do / Validate first / Reframe / Defer / Kill — with a dimension-by-dimension scorecard, the strongest objection, a stronger reframe, and the cheapest validation test. Use whenever the user wonders if an idea, feature, product, or project is good, worth doing, worth their time, a distraction, or a fake need; wants two or more ideas compared and ranked; or asks whether to build, ship, kill, postpone, or reframe — even when said casually, never as an explicit "evaluate this". Trigger on 想法是不是好主意, 我有个想法, 帮我看看这个想法, 这个点子怎么样, 值不值得做, 值得投入吗, 要不要做, 该不该做, 这个需求要不要接, 是否应该验证, 该不该砍掉, 是不是伪需求, 是不是在瞎折腾, 哪个更值得做, and casual English like "should I build this", "is this worth my time", "worth doing? or kill it".
---

# Hai Idea

For Chinese readers, see `SKILL.zh_CN.md`. The English `SKILL.md` is the execution source of truth.

## Overview

Return one clear verdict per idea, never a survey of considerations. When the user hands you two or more ideas, rank them by decision value, not novelty.

## Core Principle

Make bold judgments, then verify carefully.

Give a clear call, but attach the call to evidence. Do not hide behind "it depends" when the audience is vague, the pain is weak, the cost is high, timing is wrong, or no proof path exists.

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

1. Restate the idea in one sentence. Remove decoration and excitement, name the target user or affected system, and state the expected outcome.

2. Identify the decision. Is the current decision to do, validate, prioritize, reframe, or kill? If comparing ideas, rank by decision value rather than novelty.

3. Evaluate the decisive dimensions from the Evaluation Frame above. Penalize vague users, fake urgency, high maintenance cost, missing evidence, and high opportunity cost. Reward sharp pain, repeated use, cheap validation, high leverage, and clear exit criteria.

4. Make the call. Pick exactly one verdict from the Verdict Guide below, explain the reason directly, and state your confidence (high / medium / low). If the idea has potential but is not executable yet, state what must become true first.

5. State the strongest objection. Name the single best reason not to do this now, even if your verdict is Do — a call you cannot argue against yourself is not yet verified.

6. Offer a stronger version. If the current idea is weak or only partly right, give the strongest nearby reframe. Skip only when the idea is already at its best form.

7. Define the smallest useful validation. What is the cheapest test that could change the decision? What signal would prove demand, feasibility, quality, or strategic value, and what result would show the idea is not worth continuing? Bound it with a timebox when one applies.

Read `references/output-template.md` — it is the canonical output shape — before finalizing.

## Verdict Guide

The verdict is exactly one of these five calls:

- **Do**: clear audience, real pain, good timing, manageable cost, and enough evidence to proceed.
- **Validate first**: plausible upside, but a key assumption is unproven.
- **Reframe**: the current idea is weak, but a stronger nearby direction exists.
- **Defer**: potentially good, but timing, dependencies, or opportunity cost are wrong now.
- **Kill**: weak pain, unclear audience, low leverage, high cost, or no credible proof path.

## Common Mistakes

- Treating an interesting idea as a good idea.
- Confusing "I can build it" with "it is worth doing".
- Accepting vague audiences like "everyone", "developers", or "teams" without a concrete scenario.
- Designing the full solution before deciding whether the idea deserves one.

## Use a different skill when

- The decision to build is already made and the user wants phases, todos, or an execution plan: use `hai-goal`.
- The idea is solid and now needs product requirements: use `hai-prd`.
- The user wants to challenge scope or ambition without a do/kill verdict — open the frame and think bigger: use `geju`.
- The problem is purely choosing or fixing a name: use `hai-naming`.
