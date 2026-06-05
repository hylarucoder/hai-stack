---
name: goal-make
description: Use when a user asks to define, create, clarify, or evaluate goals; especially when goals must be verifiable, measurable, outcome-oriented, or translated from vague intent into clear success criteria.
---

# Goal Make

## Overview

Use this skill to turn intent into goals that can be trusted. A goal is only useful when someone can tell whether it was achieved.

## Core Principle

Every goal needs a verification rule:

- Prefer observable outcomes over activity statements.
- Define what evidence proves the goal is done.
- Quantify when useful, but do not force fake metrics.
- If a goal cannot be verified directly, define the strongest available proxy.
- Separate the goal from the plan that will achieve it.

## Workflow

1. Capture the intent.
   - What does the user want to be true?
   - Who or what benefits?
   - What current uncertainty or pain should disappear?

2. Convert intent into candidate goals.
   - Rewrite vague actions into target outcomes.
   - Identify whether the goal is product, technical, operational, learning, quality, or delivery oriented.
   - Remove bundled goals that should be separate.

3. Add verification.
   - Define the evidence source: test, metric, user behavior, checklist, document review, runtime trace, command output, or stakeholder acceptance.
   - Define pass/fail criteria.
   - Add a baseline or threshold when quantification is meaningful.
   - State when qualitative judgment is required and who/what makes it credible.

4. Check goal quality.
   - Is it outcome-oriented?
   - Is it clear enough that two people would judge completion the same way?
   - Is the verification rule available without heroic effort?
   - Does it avoid prescribing an implementation too early?
   - Read `references/output-template.md` before finalizing.

## Goal Quality Bar

A strong goal has:

- **Outcome**: the desired state.
- **Boundary**: what is included and excluded.
- **Verification**: how to prove it.
- **Confidence**: why the evidence is credible.
- **Owner of judgment**: system, test, metric, reviewer, or user signal.

## What This Skill Is Not

- Not a planning skill. Use `goal-craft` or `plan-craft` after goals are defined.
- Not a metrics dashboard skill. Metrics can verify goals, but the skill designs the goal first.
