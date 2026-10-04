---
name: hai-visual-explainer
description: |
  Turns supplied content into self-contained HTML and PNG in two modes: card for one shareable frame（知识卡、信息卡、金句卡、封面、把要点做成一张图）, report for multi-section documents（可视化报告、HTML 汇报页、PRD/计划/评审做成网页）. Preserve source meaning and use structure-appropriate typography, diagrams, matrices, and evidence. Owns presentation, not the underlying architecture or product judgment; use a frontend or document-design skill for apps or print artifacts.
---

# Hai Visual Explainer

For Chinese readers, see `SKILL.zh_CN.md`. The English `SKILL.md` is the execution source of truth.

## Overview

Turn supplied content into a readable, portable HTML artifact and a PNG preview. Choose the
output scale from the request; both modes share source mapping, authoring, rendering, and QA.

## Select the mode

- **Card**: one decorative, single-frame information, quote, knowledge, social, summary, or cover
  image. Preserve the supplied points and qualifications within the requested scope. Read
  `references/card-design.md`, start from `assets/card-template.html`, and use
  `references/card-output-template.md` for delivery. Choose big typography for low density,
  balanced sections for medium density, or a newspaper grid for high density.
- **Report**: a multi-section or scroll-length document for understanding structure, decisions,
  tradeoffs, risks, and evidence. Use the report content model below and read
  `references/output-template.md` plus `references/html-skeleton.md`.
- Infer the mode from the requested artifact. Do not compress a full document into a card unless
  a summary is requested; do not turn a request for one card into a long report.

## Core Principle

**Enhance readability with emphasis — don't summarize the content away.**

Preserve the source's meaning within the requested scope while improving navigation, emphasis, and reading flow. Reword,
reorder, or trim genuine repetition when useful, but do not replace a substantive document with a
bullet summary unless the user explicitly requests a summary card; preserve qualifications even then. Visuals support the content; they do not excuse dropping it. For a raw idea rather
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

1. **Select card or report mode.** For a card, state content density and layout choice in one sentence.
   For a report, identify its type to set the emphasis of the optional blocks:
   - Idea report: idea value, opportunity cost, validation path.
   - Requirement report: requirement structure, scope, acceptance, risk.
   - Goal report: target, phases, todos, verification.
   - Review report: issues, evidence, recommendation, priority.
   - Architecture-style report: current chain, boundary, options, why-not, red/blue review.

2. **Map the source, then decide where to add emphasis** (apply the Core Principle). Read the whole input and note its sections and key points, so the artifact carries the substance of the requested scope. Then decide where a visual (map, matrix, stepper, card grid) or typographic emphasis would help the reader — that's where you add value, rather than by cutting the content into a summary. If information is genuinely missing, state assumptions rather than inventing facts, and keep facts, assumptions, and judgments visibly separate.

3. **Read the mode-specific design and output resources listed above before writing.**

4. **Write the HTML.**
   - Output one complete `.html` file.
   - Follow a user-specified path. Otherwise create a unique temporary directory with `mktemp -d`
     and write the HTML there; do not rely on an unresolved environment variable.
   - Keep CSS and JS inline or CDN-based (Tailwind CDN and Mermaid CDN are fine); avoid project-local assets unless requested, so the `.html` stays a single portable artifact the user can open or send without a build step.
   - Use Chinese UI copy for Chinese requests and English UI copy for English requests. Keep code identifiers unchanged.

5. **QA, then return the path.** If the HTML contains Mermaid, run
   `node scripts/lint_mermaid.js <file.html>` and fix every `ERR`; treat density warnings as a
   prompt to simplify. Then render the page with
   `node scripts/render_report.mjs <file.html> --mode report` for a full-page preview or
   `node scripts/render_report.mjs <file.html> --mode card` for the `.card` element at 2x DPR.
   Inspect the generated PNG for failed
   diagrams, overflow, clipping, unreadable type, and broken hierarchy. If browser rendering is
   unavailable, state that visual QA is incomplete rather than claiming a pass.

### Mermaid label safety

Mermaid breaks on special characters in **unquoted** node/edge labels — `/` is the most common culprit (`A[Timeline / Phases]` is a syntax error), along with `()`, `[]`, `{}`, `<>`, `&`, `:`, and `#`. Always wrap any label containing punctuation in double quotes:

- ❌ `A[Timeline / Phases]` → ✅ `A["Timeline / Phases"]`
- ❌ `B[Risks/Proof]` → ✅ `B["Risks/Proof"]`

If a quoted label still errors (or you need the character inside quotes), use the HTML entity code: `/` → `#47;`, `(` → `#40;`, `)` → `#41;` — e.g. `A["Timeline #47; Phases"]`. When in doubt, quote every label. The bundled linter (step 5) flags unquoted slashes as `ERR`.

### Report style constraints

- Quiet, professional report style — not a marketing landing page.
- Use cards only for repeated findings, options, risks, metrics, or callouts.
- If the report comes from an architecture review, preserve architecture-map-first, options matrix, why-not alternatives, and red/blue adversarial review (the judgment itself stays owned by `hai-architecture` — see below).

## Output

Use the selected mode’s output template and report the real HTML and PNG paths, source-fidelity
status, and completed QA. For cards, present the PNG inline when supported and check body text
≥ 18px, mobile readability, and visual hierarchy. Do not duplicate the delivery schema here or claim checks that were not
run.

## Two traps to avoid

- **Summarizing instead of enhancing.** The reader should retain the source's substantive meaning.
- Mixing facts, assumptions, and judgments together so the reader cannot tell which is which.

## Use a different skill when

- The user wants an interactive app or reusable UI component — use an available frontend-building skill.
- The user wants a print poster or document artifact — use an available document or image-design skill.
- The user needs architecture-level judgment (APoSD/Ousterhout review, module-boundary critique) — use `hai-architecture`. Even when they also want HTML, the architecture judgment is owned by `hai-architecture`; this skill renders a report, it does not produce the architecture verdict.
