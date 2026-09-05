---
name: hai-visual-report
description: |
  Turns an idea, PRD, plan, review, architecture topic, or other substantive source into a self-contained, multi-section HTML report with structure-appropriate diagrams, matrices, evidence, risks, and next moves while preserving the source’s meaning. Use when the user asks for a visual/HTML/web/slides-like report（可视化报告、做成网页、汇报页）. Use create-visual-card for one single-frame shareable image; this skill owns presentation, not the underlying architecture or product judgment.
---

# Hai Visual Report

For Chinese readers, see `SKILL.zh_CN.md`. The English `SKILL.md` is the execution source of truth.

## Overview

Turn an idea, requirement, proposal, review result, or goal document into a readable, presentable, multi-section HTML report — a real `.html` artifact with a title, diagrams, matrices, sections, and next steps. The goal is a better *reading experience* of the source, with the important parts brought forward — not a shorter summary of it. When given a document, carry its substance through and use visuals to highlight and make it scan well (see Core Principle).

Two common misclassifications to rule out first:

- This is not `create-visual-card`. A visual card is a single-screen summary for sharing; `hai-visual-report` is a multi-section report for understanding structure, judgment, tradeoffs, route, risk, and evidence.
- This is not a Markdown-only answer. The user wants a generated HTML file, not prose.

## Core Principle

**Enhance readability with emphasis — don't summarize the content away.**

Preserve the source's meaning while improving navigation, emphasis, and reading flow. Reword,
reorder, or trim genuine repetition when useful, but do not replace a substantive document with a
bullet summary. Visuals support the content; they do not excuse dropping it. For a raw idea rather
than a finished source, distinguish supplied facts from assumptions and newly authored judgment.

## Report Content Model

These blocks are optional scaffolding. Choose only what helps the source; do not emit empty or
ceremonial blocks:

1. **Header**: title, scope, generation date.
2. **Verdict** (optional): if the source *itself* states a conclusion, surface it here as an entry point. Don't manufacture a condensed judgment that substitutes for the body; omit the block rather than inventing one.
3. **Structure Map**: Mermaid or layout diagram of actors, relationships, flow, or decision path — placed near the top as the reader's coordinate system. This is navigation, not a summary.
4. **Core Sections**: the source body carried through theme by theme, with visuals only where they
   clarify a relationship, comparison, sequence, hierarchy, or evidence set.
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

2. **Map the source, then decide where to add emphasis** (apply the Core Principle). Read the whole input and note its sections and key points, so the report carries the same substance. Then decide where a visual (map, matrix, stepper, card grid) or typographic emphasis would help the reader — that's where you add value, rather than by cutting the content into a summary. If information is genuinely missing, state assumptions rather than inventing facts, and keep facts, assumptions, and judgments visibly separate.

3. **Read the output shape before writing.** Open `references/output-template.md` for the delivery format and `references/html-skeleton.md` for a minimal Tailwind + Mermaid scaffold of the eight blocks, so you produce against the target instead of inventing a page layout.

4. **Write the HTML.**
   - Output one complete `.html` file.
   - Follow a user-specified path. Otherwise create a unique temporary directory with `mktemp -d`
     and write the report there; do not rely on an unresolved environment variable.
   - Keep CSS and JS inline or CDN-based (Tailwind CDN and Mermaid CDN are fine); avoid project-local assets unless requested, so the `.html` stays a single portable artifact the user can open or send without a build step.
   - Use Chinese UI copy for Chinese requests and English UI copy for English requests. Keep code identifiers unchanged.

5. **QA, then return the path.** If the report contains Mermaid, run
   `node scripts/lint_mermaid.js <file.html>` and fix every `ERR`; treat density warnings as a
   prompt to simplify. Then render the page with
   `node scripts/render_report.mjs <file.html>` and inspect the generated full-page PNG for failed
   diagrams, overflow, clipping, unreadable type, and broken hierarchy. If browser rendering is
   unavailable, state that visual QA is incomplete rather than claiming a pass.

### Mermaid label safety

Mermaid breaks on special characters in **unquoted** node/edge labels — `/` is the most common culprit (`A[Timeline / Phases]` is a syntax error), along with `()`, `[]`, `{}`, `<>`, `&`, `:`, and `#`. Always wrap any label containing punctuation in double quotes:

- ❌ `A[Timeline / Phases]` → ✅ `A["Timeline / Phases"]`
- ❌ `B[Risks/Proof]` → ✅ `B["Risks/Proof"]`

If a quoted label still errors (or you need the character inside quotes), use the HTML entity code: `/` → `#47;`, `(` → `#40;`, `)` → `#41;` — e.g. `A["Timeline #47; Phases"]`. When in doubt, quote every label. The bundled linter (step 5) flags unquoted slashes as `ERR`.

### Style constraints

- Quiet, professional report style — not a marketing landing page.
- Use cards only for repeated findings, options, risks, metrics, or callouts.
- If the report comes from an architecture review, preserve architecture-map-first, options matrix, why-not alternatives, and red/blue adversarial review (the judgment itself stays owned by `hai-architecture` — see below).

## Output

Read `references/output-template.md` and report the real HTML and preview PNG paths, source-fidelity
status, and completed QA. Do not duplicate the delivery schema here or claim checks that were not
run.

## Two traps to avoid

- **Summarizing instead of enhancing.** The reader should retain the source's substantive meaning.
- Mixing facts, assumptions, and judgments together so the reader cannot tell which is which.

## Use a different skill when

- The user wants a single visual card, info card, social card, or one-screen summary — use `create-visual-card`.
- The user needs architecture-level judgment (APoSD/Ousterhout review, module-boundary critique) — use `hai-architecture`. Even when they also want HTML, the architecture judgment is owned by `hai-architecture`; this skill renders a report, it does not produce the architecture verdict.
