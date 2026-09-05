---
name: hai-razor
description: |
  Tests whether each requirement, step, role, field, state, module, layer, abstraction, or rule deserves independent existence, then classifies it as Keep, Merge, Defer, Delete, Replace, or Prove first. Use when the explicit decision is what can be removed or collapsed（奥卡姆剃刀、砍需求、这个字段/状态/层有必要吗、是否过度设计）. Use hai-prd to shape product requirements and hai-architecture to redesign module boundaries after the cuts are known.
---

# Hai Razor

For Chinese readers, see `SKILL.zh_CN.md`. The English `SKILL.md` is the execution source of truth.

## Overview

Audit the existence of product requirements, workflow steps, data fields, states, modules, layers,
abstractions, service boundaries, and design choices, then classify each as
Keep/Merge/Defer/Delete/Replace/Prove-first with evidence. The goal is not a smaller system — see
Core Principle for the bar a concept must clear.

## Core Principle

Every concept must earn its existence.

A thing deserves to exist only when removing it would break a real goal, erase a real distinction,
hide an important risk, or push unavoidable complexity onto a worse owner. If a concept survives only
because of habit, fear, symmetry, imagined future needs, or aesthetic completeness, cut it, merge it,
defer it, or demand proof. Cutting real distinctions, safety, observability, permissions, migration
paths, or a deep module that hides genuine complexity is not simplification — it is damage.

## Razor Targets

Audit anything that claims a separate existence. The existence question is the lens for each type.

| Target | Existence question |
|--------|--------------------|
| Requirement | What user, business, operator, or maintainer pain proves this is needed? |
| Workflow step | What decision, transformation, or risk does this step own? |
| Role | What capability or responsibility is unique to this actor? |
| Field | What behavior, decision, audit, or invariant depends on this data? |
| State | What transition, permission, recovery path, or user meaning requires this state? |
| Module | What complexity does this module hide from callers? |
| Layer | What boundary does this layer protect, translate, or stabilize? |
| Abstraction | What family of variation exists now, and what must callers no longer know? |
| Rule | What failure, conflict, or decision would become ambiguous without it? |

## Classify Each Concept

After running the deletion test and finding the hidden owner (Workflow steps 4-5), assign every
concept exactly one verdict.

| Decision | Use when |
|----------|----------|
| **Keep** | It carries irreducible responsibility, protects correctness, hides real complexity, or preserves a needed distinction. |
| **Merge** | It has some value, but not enough independent meaning to justify its own name, module, field, state, or step. |
| **Defer** | It may become necessary, but current evidence is too weak and adding it now creates ballast. |
| **Delete** | It does not protect a goal, invariant, decision, or meaningful distinction. |
| **Replace** | The responsibility is real, but the current shape is the wrong owner, boundary, name, or mechanism. |
| **Prove first** | The concept may be necessary, but evidence is missing and the cost or risk is nontrivial. |

## Workflow

1. **Name the chain being cut.** State the scope (PRD section, feature flow, data model, module
   boundary, architecture chain, or implementation plan), the current goal it claims to serve, and
   list every concept asking for independent existence.

2. **Gather evidence before judgment.** Review the PRDs, docs, code, schemas, traces, tests,
   metrics, user flows, support cases, or decision records that bear on each concept. Separate
   evidence from inference — if a claim is plausible but unproven, label it an assumption or "prove
   first." Prefer concrete evidence about current behavior over imagined future extensibility. Every
   keep/cut/merge/defer/replace verdict needs a reason grounded in evidence, or an explicit statement
   that evidence is missing. For code-level over-engineering signals such as defensive over-checking,
   speculative parameters, pass-through layers, reimplemented standard behavior, or ceremonial
   error handling, consult `references/llm-complexity-tells.md` and apply its behavior-preservation
   gate before recommending a cut.

3. **Map the current chain when the cut is structural.** Show before/after responsibility when a
   workflow, state machine, module chain, or service boundary materially changes. Use Mermaid only
   when it makes the ownership move clearer than a table or short explanation.

4. **Run the deletion test.** For each concept ask: if this disappears, what concretely breaks?
   Distinguish "something feels less complete" from "a user goal, invariant, operation, safety
   property, or decision fails." If nothing breaks, the concept is suspect.

5. **Find the hidden owner.** If the concept is removed, who must absorb its responsibility? If it
   moves to a worse place, the concept may deserve to stay. If an existing concept can absorb it with
   less cognitive load, merge it.

6. **Classify each concept** using the decision table above. Give every concept exactly one verdict
   with its reason.

7. **Protect necessary complexity.** Explicitly name what should not be cut: complexity that prevents
   invalid states, secures trust boundaries, supports recovery, improves observability, or hides
   implementation behind a deep interface.

8. **Attack the remaining design.** Ask how future builders would reintroduce the deleted concept,
   and whether the cut creates hidden coupling, vague ownership, migration risk, or unclear
   acceptance. Add a guardrail: naming, test, doc boundary, acceptance criterion, architecture note,
   or follow-up proof.

9. **Render only when requested.** The default deliverable is Markdown. If the user explicitly asks
   for HTML or a visual report, hand the completed judgment to `hai-visual-report`; do not duplicate
   its rendering workflow here.

## Output

Read `references/output-template.md` before finalizing. The answer must contain, at minimum:

- A razor verdict for the reviewed scope, the stated razor principle used, and an explicit
  not-audited scope (to prevent mis-cutting).
- An evidence table, or a clear statement that evidence is missing.
- A classification table mapping each concept to Keep / Merge / Defer / Delete / Replace / Prove
  first, with the strongest survival argument for anything cut.
- The complexity that must be preserved.
- A concrete cut list or prove-first list, plus risks and guardrails.

For structural cuts, include before/after ownership only when it materially improves understanding.
HTML remains opt-in and belongs to `hai-visual-report`.

## Use a different skill when

- The target is a requirement document or product scope — use `hai-prd`.
- The target is module boundaries, dependency direction, or abstraction depth — use `hai-architecture`.
- The question is whether the whole idea is worth doing at all — use `hai-idea`.
- The user wants the cuts turned into an execution plan — use `hai-goal`.

## Common Mistakes

- Cutting a concept because it is large, not because it is unnecessary.
- Treating "future extensibility" as evidence without naming the expected variation.
- Replacing a visible concept with a hidden convention and calling that simplification.
- Keeping a concept only because it has a name, a file, a meeting, or an owner.
