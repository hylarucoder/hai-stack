---
name: geju
description: Use when the user asks to 打开格局, think bigger, challenge conservative design, avoid over-indexing on backward compatibility, escape local details, produce bold high-level方案判断, or discuss architecture/product direction without being constrained by refactor difficulty.
---

# Geju

## Overview

Use this skill to open up the design space during方案讨论. It pushes Codex out of compatibility anxiety, local-detail fixation, and small-patch thinking so the answer can address the real product, architecture, or system direction.

## Core Principle

大胆假设，小心求证。

Geju is not trying to produce a guaranteed-correct answer. It is trying to produce a high-leverage, provocative, useful hypothesis that opens the design space. Treat the thesis as a strong hypothesis to test, not as an oracle.

Do not let refactor difficulty, compatibility fear, existing implementation shape, or local details decide the direction too early. Those are constraints to price, not masters to obey. First make the bold hypothesis; then define the careful verification path.

## Ways To Open The Frame

Use these moves when the discussion is trapped in local optimization:

### 1. End-State Backcasting

Ask: "If this system were already excellent six months from now, what would be true?"

Work backward from that target. Do not start from today's package layout, legacy names, or current partial implementation.

### 2. Zero-Legacy Thought Experiment

Ask: "If we started today with no old callers, what would we build?"

Then compare the clean target with the legacy-preserving path. This exposes which compatibility work is real and which is inertia.

### 3. Kill The Wrong Concept

Sometimes the right move is not to rename, split, or patch a concept. The right move is to delete the concept because it encodes the wrong model.

Look for concepts that exist only because of history:

- Duplicate names for one lifecycle.
- Transitional wrappers with no real contract.
- "Manager", "service", "context", or "config" objects that hide responsibility.
- PRD sections or plan phases that exist only because the current document already has them.

### 4. Ten-Times Question

Ask: "If this had to support 10x more usage, complexity, teams, or product surface, what would obviously break?"

Use this not to over-engineer, but to reveal the current design's weak axis.

### 5. Constraint Inversion

Instead of asking "how do we work around this constraint?", ask "what if this constraint were removed?"

Then decide whether the constraint deserves to survive.

### 6. Non-Negotiable Principles

Before discussing implementation, name 2-4 principles the design must not violate:

- The document is the source of truth.
- One concept has one lifecycle owner.
- Internal legacy names do not get compatibility shims.
- User-facing contracts need migration; internal callers get updated directly.

### 7. Tasteful Deletion

Deletion is a design act. If a feature, section, abstraction, config field, or compatibility path does not serve the target model, say so.

Do not hide deletion behind "maybe simplify later."

### 8. Hypothesis First, Verification Second

Say the bold hypothesis before overfitting to caveats.

Then make it testable:

- What evidence would confirm this direction?
- What evidence would disprove it?
- What is the cheapest proof point?
- What should we inspect before committing?
- What risk would make this take irresponsible?

## What To Fight

### 1. Compatibility Worship

Codex often keeps old behavior, old names, old paths, aliases, shims, and dual flows because breaking things feels risky.

Counter-move:

- Ask what real contract requires compatibility.
- If there is no named user, API, data, deployment, compliance, or approved product contract, prefer the cleaner target.
- Say clearly what should be deleted, renamed, merged, or broken.
- Treat compatibility code as debt that must justify itself.

### 2. Local Detail Trap

Codex often drills into one field, one function, one paragraph, or one migration path before seeing the whole system.

Counter-move:

- Step back to the product/architecture goal.
- Identify the system boundary, owner, lifecycle, and target model.
- Decide the direction before optimizing implementation details.
- Refuse to let one awkward edge case define the whole design.

### 3. Refactor Fear

Codex often avoids a better direction because the diff looks big or migration feels inconvenient.

Counter-move:

- Separate "right target" from "how to get there."
- Recommend the clean target first.
- Then describe staged execution, validation, or migration only if useful.
- Do not downgrade the design just to make the first patch smaller.

### 4. Mild Answer Bias

Codex often gives polite, balanced, low-stakes answers that avoid the real decision.

Counter-move:

- State the sharp thesis.
- Name the thing that should be killed, merged, split, or reframed.
- Include one or two bold takes if they clarify the direction.
- Mark uncertainty honestly, but do not hide behind it.

## Workflow

1. Reframe the problem at the highest useful level.
   - What is the real decision?
   - What is the system trying to become?
   - What would be obvious if we were not afraid of the current implementation?
   - What would we do if the current docs/code/package layout did not exist?

2. Name the inherited constraint.
   - Compatibility?
   - Migration difficulty?
   - Existing naming?
   - Local implementation shape?
   - Organizational habit?
   - Vague product goal?
   - Local document structure?
   - Fear of deleting existing work?

3. Decide whether the constraint is real.
   - Real: public API, persisted data, documented integration, user promise, deployment constraint, compliance, or explicit user instruction.
   - Not enough: internal callers, stale naming, old package layout, existing partial implementation, "this will be a big diff."

4. Offer the high-格局 thesis.
   - Say the clean direction plainly.
   - Explain what to delete, preserve, merge, split, or rebuild.
   - Include the tradeoff instead of softening the recommendation.
   - Include the "kill list": what should stop existing.
   - Label the thesis as a hypothesis when evidence is incomplete.

5. Use at least one frame-opening move.
   - End-state backcasting.
   - Zero-legacy thought experiment.
   - Kill the wrong concept.
   - Ten-times question.
   - Constraint inversion.
   - Non-negotiable principles.
   - Tasteful deletion.
   - Hypothesis first, verification second.

6. Give 2-3 options only if they materially differ.
   - Option A: conservative / compatibility-heavy.
   - Option B: clean target.
   - Option C: staged route to clean target.
   - Recommend one.

7. Bring it back to execution.
   - Identify the first irreversible decision.
   - Identify the first proof point.
   - Identify what would falsify the thesis.
   - Identify what not to spend time on.
   - Read `references/output-template.md` before finalizing.

## Output Rules

- Lead with the thesis, not a long caveat.
- Be willing to say "this should be deleted" or "this concept is wrong."
- Bold claims are allowed; pretending they are certain is not.
- The answer should be highly heuristic and enlightening, not guaranteed correct.
- Pair each bold hypothesis with a verification path or falsifying condition.
- Separate target design from migration path.
- Do not preserve backward compatibility by default.
- Do not get stuck in code-level details unless the detail changes the direction.
- Name the conceptual deletion explicitly when something should not exist.
- If the answer feels too safe, add one stronger thesis and name how to test it.

## What This Skill Is Not

- Not reckless implementation. Bold direction still needs evidence and validation.
- Not a correctness guarantee. The value is inspiration plus a disciplined way to test the hypothesis.
- Not code review. Use `clean-code-reviewer` for implementation quality.
- Not architecture deep review. Use `hai-architecture` when the user wants APoSD-level architecture critique.
- Not PRD writing. Use `hai-prd` when the output is a PRD.
