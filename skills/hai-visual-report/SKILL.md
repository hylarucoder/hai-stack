---
name: hai-visual-report
description: |
  Generates a complete, self-contained multi-section HTML report — header + one-line verdict,
  Mermaid structure map, decision matrix, risk/proof table, and next-move block — from an idea,
  requirement, PRD, goal, review, architecture topic, plan, or proposal, and returns the generated
  file path. Use whenever the user wants content turned into a visual report, visualized page, HTML
  report, webpage version, dashboard, or slides/PPT-like web artifact — and trigger even on casual
  phrasings: 可视化一下, 做个可视化, 做成网页, 做个网页版, 把这个评审做成网页, 做成一页 HTML, 输出 HTML,
  做个汇报页/展示页, 做成 PPT 样子的网页, 弄个好看点的报告, 整理成一份报告页面, 带 mermaid 图的报告,
  render this as a page/webpage, make it visual/interactive, turn my analysis into slides-like html,
  dashboard of this. When the user wants a single shareable card instead of a multi-section
  report, use create-visual-card.
---

# Hai Visual Report

For Chinese readers, see `SKILL.zh_CN.md`. The English `SKILL.md` is the execution source of truth.

## Overview

Turn an idea, requirement, proposal, review result, or goal document into a readable, presentable, multi-section HTML report — a real `.html` artifact with a title, verdict, diagrams, matrices, sections, and next steps.

Two common misclassifications to rule out first:

- This is not `create-visual-card`. A visual card is a single-screen summary for sharing; `hai-visual-report` is a multi-section report for understanding structure, judgment, tradeoffs, route, risk, and evidence.
- This is not a Markdown-only answer. The user wants a generated HTML file, not prose.

## Core Principle

Visualize the structure before polishing the copy.

Given an idea or request, do not stack paragraphs. First identify the core judgment, actors, relationships, route, risks, and verification. Then turn those into a scannable HTML page.

## Report Content Model

This is the single canonical structure. Default reports include these eight blocks (drop one only with a stated reason):

1. **Header**: title, scope, generation date.
2. **Verdict**: one-sentence conclusion and the most important judgment.
3. **Structure Map**: Mermaid or layout diagram of actors, relationships, flow, or decision path — placed near the top as the reader's coordinate system.
4. **Core Sections**: problem, goal, solution, users, flow, architecture, tradeoffs, risks, or other relevant themes. Each should carry at least one visual object (chart, table, matrix, stepper, callout, or checklist).
5. **Decision Matrix**: options, risks, cost, value, or priority.
6. **Timeline / Phases**: stages, exit proof, and next step when execution is involved.
7. **Risks and Proof**: key risks, validation method, pass/fail signal.
8. **Next Move**: explicit next action.

Pick the visual structure for each block from the content itself — complex relationships become a Mermaid graph, a clear flow becomes a timeline or stepper, option comparison becomes a matrix, risk becomes a grid, scope becomes inclusion/exclusion panels.

## Workflow

1. **Identify report type**, which sets the emphasis of the eight blocks:
   - Idea report: idea value, opportunity cost, validation path.
   - Requirement report: requirement structure, scope, acceptance, risk.
   - Goal report: target, phases, todos, verification.
   - Review report: issues, evidence, recommendation, priority.
   - Architecture-style report: current chain, boundary, options, why-not, red/blue review.

2. **Extract the core judgment** (apply the Core Principle). Write the one thing the report should make the reader remember, and the most important actor, relationship, conflict, risk, or decision. If information is missing, state assumptions rather than inventing facts — and keep facts, assumptions, and judgments visibly separate.

3. **Read the output shape before writing.** Open `references/output-template.md` for the delivery format and `references/html-skeleton.md` for a minimal Tailwind + Mermaid scaffold of the eight blocks, so you produce against the target instead of inventing a page layout.

4. **Write the HTML.**
   - Output one complete `.html` file.
   - Prefer a system temporary directory such as `$TMPDIR/hai-visual-report-<topic>/`; follow the user-specified path when provided.
   - Keep CSS and JS inline or CDN-based (Tailwind CDN and Mermaid CDN are fine); avoid project-local assets unless requested, so the `.html` stays a single portable artifact the user can open or send without a build step.
   - Use Chinese UI copy for Chinese requests and English UI copy for English requests. Keep code identifiers unchanged.

5. **QA, then return the path** (see the QA checks below). Deliver the absolute path to the generated `.html`.

### Style constraints

- Quiet, professional report style — not a marketing landing page.
- Use cards only for repeated findings, options, risks, metrics, or callouts.
- If the report comes from an architecture review, preserve architecture-map-first, options matrix, why-not alternatives, and red/blue adversarial review (the judgment itself stays owned by `hai-architecture` — see below).

## Output

Deliver this skeleton in your reply, with the file actually written:

```
## Report Type
<idea / requirement / goal / review / architecture-style / custom> — <one line>

## Core Judgment
<the one thing the report makes the reader remember>

## Generated HTML
`<absolute path to the .html>`

## QA
- HTML generated: yes/no
- Verdict + map + next step visible near top: pass/issue
- Mermaid readable (split if dense): pass/issue/omitted because <reason>
- Multi-section page, not one long card: pass/issue
- Text fits — no overflow past cards or buttons: pass/issue
- Facts vs assumptions separated: pass/issue
```

Read `references/output-template.md` before finalizing; the inline skeleton above is its summary.

## Two traps to avoid

- A decorative page that hides the verdict and the next step. Readability and judgment beat ornament.
- Mixing facts, assumptions, and judgments together so the reader cannot tell which is which.

## Use a different skill when

- The user wants a single visual card, info card, social card, or one-screen summary — use `create-visual-card`.
- The user needs architecture-level judgment (APoSD/Ousterhout review, module-boundary critique) — use `hai-architecture`. Even when they also want HTML, the architecture judgment is owned by `hai-architecture`; this skill renders a report, it does not produce the architecture verdict.
