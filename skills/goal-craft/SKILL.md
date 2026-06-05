---
name: goal-craft
description: Use when a user asks to refine, break down, structure, or operationalize goals into phases and todos; especially when a broad goal needs staged delivery, dependencies, and verifiable task-level proof.
---

# Goal Craft

## Overview

Use this skill to refine a clear goal into phases and todos. It keeps the goal intact while making the path inspectable, staged, and verifiable.

## Core Principle

Craft goals into phases without losing verification:

- Each phase should make the goal more true in a meaningful way.
- Each phase needs its own completion proof.
- Each todo should have an action, surface, and verification rule.
- Dependencies should be explicit.
- Avoid turning phases into vague themes; phases should be executable slices.

## Workflow

1. Confirm the goal.
   - If the goal is vague or unverifiable, use `goal-make` first.
   - Restate the goal, boundary, and verification rule.

2. Choose phase boundaries.
   - Split by learning, risk reduction, user-visible value, system boundary, or dependency order.
   - Do not split only by department, file type, or arbitrary chronology.
   - Each phase should end in a reviewable state.

3. Create todos per phase.
   - Convert phase intent into concrete tasks.
   - Attach proof to each todo.
   - Mark dependencies and blockers.
   - Keep todos small enough to execute, but not so small they lose meaning.

4. Validate the breakdown.
   - Does every todo serve the goal?
   - Does every phase have a proof point?
   - Are any prerequisites missing?
   - Is there a clear stopping point if later phases are deferred?
   - Read `references/output-template.md` before finalizing.

## Todo Shape

Use this structure when useful:

- **Todo**: <action>
- **Surface**: <file/document/system/user flow>
- **Proof**: <test/metric/review/artifact/command>
- **Depends on**: <dependency or none>

## What This Skill Is Not

- Not initial goal definition. Use `goal-make` when the goal itself is unclear.
- Not full implementation planning. Use `plan-craft` when the user needs a detailed execution plan.
