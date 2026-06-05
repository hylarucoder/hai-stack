---
name: hai-visual-report
description: Use when the user asks to turn an idea, requirement, PRD, goal, review, architecture topic, plan, or proposal into a visual HTML report, visual report, 可视化报告, HTML report, or presentation-like web artifact.
---

# Hai Visual Report

For Chinese readers, see `SKILL.zh_CN.md`. The English `SKILL.md` is the execution source of truth.

## Overview

Use this skill to turn an idea, requirement, proposal, review result, or goal document into a readable and presentable visual HTML report.

This is not `create-visual-card`. A visual card is a single-screen summary for sharing. `hai-visual-report` is a multi-section report for understanding structure, judgment, tradeoffs, route, risk, and evidence.

This is also not a Markdown-only answer. The user is asking for a real HTML artifact: a page with a clear title, verdict, diagrams, matrices, sections, and next steps.

## Core Principle

Visualize the structure before polishing the copy.

Given an idea or request, do not stack paragraphs. First identify the core judgment, actors, relationships, route, risks, and verification. Then turn those into a scannable HTML page.

## When To Use

Use this skill when the user asks for:

- A visual report, HTML report, or visualized report.
- A visual HTML page for an idea.
- A presentation-like web report for a requirement.
- Something like an architecture review HTML artifact.
- A visualized PRD, goal, plan, proposal, or review result.
- A report rather than a single card.

## Boundaries

- Use `create-visual-card` when the user wants a single visual card, info card, social card, or one-screen summary.
- Use `hai-architecture` when the user needs architecture-level judgment, APoSD/Ousterhout review, or module-boundary critique. If the user also wants HTML, architecture judgment remains owned by `hai-architecture`.
- Use `hai-visual-report` when the user already has an idea, requirement, proposal, or judgment and wants a structured, multi-section HTML report.

## Report Content Model

Default reports should include:

1. **Header**: title, scope, generation date.
2. **Verdict**: one-sentence conclusion and the most important judgment.
3. **Structure Map**: Mermaid or layout diagram showing actors, relationships, flow, or decision path.
4. **Core Sections**: problem, goal, solution, users, flow, architecture, tradeoffs, risks, or other relevant themes.
5. **Decision Matrix**: options, risks, cost, value, or priority.
6. **Timeline / Phases**: stages, exit proof, and next step if execution is involved.
7. **Risks and Proof**: key risks, validation method, pass/fail signal.
8. **Next Move**: explicit next action.

## Workflow

1. Identify report type.
   - Idea report: idea value, opportunity cost, validation path.
   - Requirement report: requirement structure, scope, acceptance, risk.
   - Goal report: target, phases, todos, verification.
   - Review report: issues, evidence, recommendation, priority.
   - Architecture-style report: current chain, boundary, options, why-not, red/blue review.

2. Extract the core judgment.
   - Write the one thing the report should make the reader remember.
   - Find the most important actor, relationship, conflict, risk, or decision.
   - If information is missing, state assumptions rather than inventing facts.

3. Choose visualization structures.
   - Complex relationships: Mermaid graph.
   - Clear flow: timeline or stepper.
   - Option comparison: options matrix.
   - Risk judgment: risk grid.
   - Scope split: inclusion/exclusion panels.
   - Goal execution: phases + proof table.

4. Write HTML.
   - Output a complete `.html` file.
   - Prefer a system temporary directory such as `$TMPDIR/hai-visual-report-<topic>/`; follow the user-specified path when provided.
   - Tailwind CDN and Mermaid CDN are acceptable.
   - Keep CSS and JS inline or CDN-based; avoid project-local assets unless requested.
   - Use Chinese UI copy for Chinese requests and English UI copy for English requests. Keep code identifiers unchanged.

5. QA the visual report.
   - Title, verdict, map, matrix, and next step should be visible near the top.
   - Mermaid diagrams must be readable; split dense diagrams.
   - Text must not overflow cards or buttons.
   - The report must be a multi-section page, not one very long card.
   - Favor readability and judgment over decoration.

Read `references/output-template.md` before finalizing.

## HTML Design Requirements

- Use clear information architecture: header, verdict, map, sections, matrix, next move.
- Use a quiet professional report style, not a marketing landing page.
- Use cards only for repeated findings, options, risks, metrics, or callouts.
- Put the Mermaid map near the beginning as the reader's coordinate system.
- Each core section should include at least one visual object: chart, table, matrix, stepper, callout, or checklist.
- If the report comes from architecture review, preserve architecture-map-first, options matrix, why-not alternatives, and red/blue adversarial review.

## Common Mistakes

- Returning Markdown only.
- Turning the report into a single visual card.
- Making the page decorative while hiding the verdict and next step.
- Creating an unreadably dense Mermaid graph.
- Mixing facts, assumptions, and judgments.
- Forgetting to provide the generated HTML path.
