---
name: geju
description: |
  Challenges an overly conservative, incremental, or compatibility-led proposal with a bold target model, a concrete kill/merge/split list, materially different options, and a falsifiable first proof point. Use when the user asks to think bigger, open the design space, or imagine the clean target without legacy constraints（打开格局、别太保守、不要被兼容绑架）. Use goudi to pressure-test how the chosen direction lands, and hai-idea to decide whether the idea deserves doing at all.
---

# Geju

For Chinese readers, see `SKILL.zh_CN.md`. The English `SKILL.md` is the execution source of truth.

## Overview

Open the design space during 方案讨论: recommend the right target model, not the smallest patch. The output is a 格局判断 — a sharp thesis plus a disciplined way to test it.

## Core Principle

大胆假设，小心求证。

Geju does not produce a guaranteed-correct answer. It produces a high-leverage, provocative hypothesis that opens the design space. Treat the thesis as a strong hypothesis to test, not as an oracle: first make the bold call, then define the careful verification path.

Refactor difficulty, compatibility fear, existing implementation shape, and local details are constraints to price, not masters to obey. Do not let them decide the direction too early.

## Ways To Open The Frame

Choose one or two moves that expose the trapped assumption; do not perform the whole catalog. The
available moves are end-state backcasting, zero-legacy thought experiment, killing the wrong
concept, the ten-times question, constraint inversion, non-negotiable principles, tasteful
deletion, and hypothesis-first verification. Read `references/frame-opening-moves.md` when a move
needs fuller guidance or examples.

## What To Fight

These are the failure modes that keep an answer small. Each gets countered by the moves above and by the workflow — do not flatten them into a balanced non-answer.

| Trap | What it looks like | Counter-move |
|------|--------------------|--------------|
| Compatibility worship | Keeps old behavior, names, paths, aliases, shims, dual flows because breaking feels risky | Demand the real contract; absent a named user/API/data/deployment/compliance/product promise, prefer the cleaner target and name what to delete. Treat compatibility code as debt that must justify itself. |
| Local detail trap | Drills into one field/function/paragraph/migration path before seeing the whole system | Step back to the product/architecture goal; fix the system boundary, owner, lifecycle, and target model first; refuse to let one awkward edge case define the design. |
| Refactor fear | Avoids a better direction because the diff looks big or migration feels inconvenient | Separate "right target" from "how to get there"; recommend the clean target first; describe staged migration only if useful; never downgrade the design to shrink the first patch. |
| Mild answer bias | Polite, balanced, low-stakes answers that dodge the real decision | State the sharp thesis; name what should be killed/merged/split/reframed; add a bold take if it clarifies; mark uncertainty honestly without hiding behind it. |

## Workflow

1. **Reframe at the highest useful level.** What is the real decision? What is the system trying to become? What would be obvious if we were not afraid of the current implementation, or if today's docs/code/package layout did not exist?

2. **Name the inherited constraint.** Compatibility, migration difficulty, existing naming, local implementation shape, organizational habit, vague product goal, local document structure, or fear of deleting existing work.

3. **Decide whether the constraint is real.** This is the operational heart of the skill — apply it in exactly this spot.
   - **Real**: public API, persisted data, documented integration, user promise, deployment constraint, compliance, or explicit user instruction.
   - **Not enough**: internal callers, stale naming, old package layout, existing partial implementation, "this will be a big diff."

4. **Offer the high-格局 thesis.** Say the clean direction plainly. Explain what to delete, preserve, merge, split, or rebuild. Include the tradeoff instead of softening the recommendation. Include the kill list (what should stop existing). Label the thesis as a hypothesis when evidence is incomplete.

5. **Apply at least one move from Ways To Open The Frame.**

6. **Give 2-3 options only if they materially differ**, using the canonical labels: Conservative path / Clean target / Staged clean path. Recommend one.

7. **Bring it back to execution.** Identify the first irreversible decision, the first proof point, what would falsify the thesis, and what not to spend time on.

## Output

Produce a 格局判断 using `references/output-template.md`. For a quick direction question, keep the
same decision fields but collapse them into Thesis / Trap / Direction / Proof. Use the full section
set only for a substantial proposal or when the user asks for a report.

- **Thesis** — sharp, high-leverage, in 1-3 sentences; not presented as guaranteed truth.
- **Confidence** — level (high / medium / low) plus why not certain.
- **The Trap** — the inherited constraint, whether it is real, and why.
- **High-格局 Direction** — the clean target model.
- **Frame-Opening Move** — which one or two moves you used and what they reveal.
- **Bold Takes** — defensible bold claims; what to delete / merge / split / rename; what not to preserve.
- **Options** — the Conservative path / Clean target / Staged clean path table with a verdict per row.
- **What Not To Do** — local optimizations, shims, or detail traps to avoid.
- **First Proof Point** — the smallest artifact that proves the direction.
- **Falsifier** — what evidence would prove the thesis wrong.
- **Payoff Ledger (收益账单)** — include for full reports: price paid now, specific pain removed or
  capability unlocked, and when the payoff becomes visible.

Output discipline that the sections do not already enforce:

- Lead with the thesis, not a long caveat. Bold claims are allowed; pretending they are certain is not.
- Separate target design from migration path.
- Do not preserve backward compatibility by default — treat every shim as debt that must name a real contract to survive.
- Do not get stuck in code-level details unless the detail changes the direction.
- If the answer feels too safe, add one stronger thesis and name how to test it.

## Use a different skill when

- The bold direction is chosen and now needs feasibility / landing pressure-testing — use `goudi` to make it executable and de-risk landing. geju and goudi are a paired stance: geju opens the frame, goudi puts it on the ground.
- The question is whether the idea is worth doing at all (do / kill / defer) — use `hai-idea`. geju assumes the work is worth doing and questions only its scope and altitude.
- The user wants implementation-quality review — use `code-review-and-quality`.
- The user wants APoSD-level architecture critique (module boundaries, abstraction depth) — use `hai-architecture`.
- The output is a PRD — use `hai-prd`.

## What this skill is NOT

- Not reckless implementation. Bold direction still needs evidence and validation.
- Not a correctness guarantee. The value is inspiration plus a disciplined way to test the hypothesis.
