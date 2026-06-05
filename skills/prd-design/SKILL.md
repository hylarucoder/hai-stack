---
name: prd-design
description: Use when a user asks to design, specify, shape, or write a PRD or product requirement before implementation; especially when the work needs clear user goals, scope boundaries, acceptance criteria, evidence, tradeoffs, and validation rules.
---

# PRD Design

## Overview

Use this skill to turn a feature idea or product problem into a coherent PRD-level design. Focus on what the product should achieve, who it serves, what is in and out of scope, and how success will be verified.

## Core Principle

Design the product requirement before designing the implementation:

- Start from the user or business outcome, not from modules, screens, or implementation tasks.
- Separate goal, scope, behavior, acceptance criteria, non-goals, risks, and rollout.
- Make every important requirement testable through user behavior, product state, observable output, data check, or reviewable artifact.
- Treat compatibility and migration as explicit constraints, not defaults.
- Do not write a PRD that only lists features. Explain why the boundaries are right.

## Workflow

1. Gather context.
   - Read existing PRDs, docs, screenshots, user flows, issue descriptions, analytics notes, and adjacent feature specs.
   - Identify the target user, product surface, current behavior, desired outcome, constraints, and stakeholder assumptions.

2. Frame the requirement.
   - State the problem in product terms.
   - Define the target outcome and the non-goals.
   - Identify the user journey or workflow boundary.
   - Note assumptions separately from verified facts.

3. Shape scope.
   - Decide what belongs in this PRD versus another PRD, design doc, or implementation plan.
   - Use `prd-splitter` when the boundary itself is the main question.
   - Avoid bundling unrelated cleanup, platform work, or implementation refactors into the PRD unless they are required for the product outcome.

4. Define behavior and acceptance.
   - Describe expected behavior by scenario.
   - Add acceptance criteria that can be verified.
   - Include edge cases, failure states, permissions, empty states, and data dependencies when relevant.

5. Write the PRD or design answer.
   - If editing a document, update the document directly.
   - If answering inline, keep the structure clear enough that it can become a PRD.
   - Read `references/output-template.md` before finalizing.

## Quality Bar

- The PRD has one clear target outcome.
- Every major requirement has a verification rule.
- Non-goals prevent real scope creep, not arbitrary exclusions.
- Open questions are limited to decisions that can change scope or acceptance.
- Implementation detail appears only when it constrains product behavior or validation.

## What This Skill Is Not

- Not a low-level technical architecture plan. Use architecture or implementation planning skills for that.
- Not a PRD split advisor. Use `prd-splitter` when the main question is PRD granularity.
- Not a task tracker. It defines product requirements; task breakdown comes later.
