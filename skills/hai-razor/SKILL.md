---
name: hai-razor
description: Use when users ask to apply Occam's razor, simplify requirements, challenge necessity, remove unnecessary product or architecture complexity, or audit whether requirements, steps, modules, fields, states, abstractions, layers, roles, or workflows deserve to exist.
---

# Hai Razor

For Chinese readers, see `SKILL.zh_CN.md`. The English `SKILL.md` is the execution source of truth.

## Overview

Use this skill to audit existence. It applies an Occam's razor lens to product requirements, workflows, data fields, states, modules, abstractions, service boundaries, process steps, and design choices.

The goal is not to make everything smaller. The goal is to cut away concepts that cannot prove they are necessary while preserving complexity that carries real responsibility.

## Core Principle

Every concept must earn its existence.

A thing deserves to exist only when removing it would break a real goal, erase a real distinction, hide an important risk, or push unavoidable complexity onto a worse owner. If a concept survives only because of habit, fear, symmetry, imagined future needs, or aesthetic completeness, cut it, merge it, defer it, or demand proof.

## When To Use

Use this skill when the user wants to:

- Apply Occam's razor or "razor" thinking to requirements, PRDs, architecture, or workflows.
- Simplify a product, module, process, field list, state machine, API, data model, or implementation plan.
- Challenge whether a requirement, role, module, layer, field, state, rule, abstraction, or process step is necessary.
- Identify fake requirements, decorative completeness, shallow modules, pass-through layers, premature abstractions, or invented future-proofing.
- Review a chain and ask where to cut, merge, defer, or keep complexity.

Use it alongside:

- `hai-prd` when the target is a requirement document or product scope.
- `hai-architecture` when the target is module boundaries, dependency direction, or abstraction depth.
- `hai-idea` when the target is whether the whole idea is worth doing.
- `hai-goal` when the user wants the cuts turned into an execution plan.

## What This Skill Is Not

- Not minimalism for its own sake. A smaller system can be more confusing if it deletes real distinctions.
- Not a license to remove safety, observability, permissions, migration paths, or validation.
- Not generic cleanup. The unit of judgment is existence necessity, not style.
- Not anti-abstraction. Deep modules that hide real complexity should usually survive.

## Razor Targets

Audit anything that claims a separate existence:

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

## Workflow

1. Name the chain being cut.
   - State the scope: PRD section, feature flow, data model, module boundary, architecture chain, or implementation plan.
   - Identify the current goal the chain claims to serve.
   - List the concepts that ask for independent existence.

2. Gather evidence before judgment.
   - Review available PRDs, docs, code, schemas, traces, tests, metrics, user flows, support cases, or decision records that bear on the concept.
   - Separate evidence from inference. If a claim is plausible but unproven, label it as an assumption or "prove first."
   - Prefer concrete evidence about current behavior and near-term pressure over imagined future extensibility.
   - Do not give only a viewpoint. Every keep, cut, merge, defer, or replace judgment needs a reason grounded in evidence or an explicit lack of evidence.

3. Map the current chain when the cut is structural.
   - If the recommendation changes a substantial workflow, process, module chain, state machine, service boundary, or architecture flow, include before/after Mermaid diagrams.
   - The before diagram should show the existing actors, modules, steps, state/data flow, and where complexity currently lives.
   - The after diagram should show what is deleted, merged, deferred, or moved, and who now owns the remaining responsibility.
   - Skip diagrams only for small local audits where a table is clearer than a flow map.

4. Run the deletion test.
   - For each concept, ask: if this disappears, what concretely breaks?
   - Distinguish "something feels less complete" from "a user goal, invariant, operation, safety property, or decision fails."
   - If nothing breaks, the concept is suspect.

5. Find the hidden owner.
   - If the concept is removed, who must absorb its responsibility?
   - If the responsibility moves to a worse place, the concept may deserve to stay.
   - If the responsibility can be absorbed by an existing concept with less cognitive load, merge it.

6. Classify each concept.

| Decision | Use when |
|----------|----------|
| **Keep** | It carries irreducible responsibility, protects correctness, hides real complexity, or preserves a needed distinction. |
| **Merge** | It has some value, but not enough independent meaning to justify its own name, module, field, state, or step. |
| **Defer** | It may become necessary, but current evidence is too weak and adding it now creates ballast. |
| **Delete** | It does not protect a goal, invariant, decision, or meaningful distinction. |
| **Replace** | The responsibility is real, but the current shape is the wrong owner, boundary, name, or mechanism. |
| **Prove first** | The concept may be necessary, but evidence is missing and the cost or risk is nontrivial. |

7. Protect necessary complexity.
   - Explicitly name what should not be cut.
   - Preserve complexity that prevents invalid states, secures trust boundaries, supports recovery, improves observability, or hides implementation details behind a deep interface.

8. Attack the remaining design.
   - Ask how future builders will reintroduce the deleted concept.
   - Ask whether the cut creates hidden coupling, vague ownership, migration risk, or unclear acceptance.
   - Add a guardrail: naming, test, doc boundary, acceptance criterion, architecture note, or follow-up proof.

9. Create an HTML artifact for full audits.
   - When the output is a full Razor audit, write a polished HTML report under `/tmp/hai-razor-<slug>/index.html` after producing the Markdown answer.
   - Include the verdict, evidence, before/after diagrams, Razor Map, cut/merge list, preserved complexity, risks, guardrails, and next steps.
   - Use a restrained, readable report style. The artifact should help a reviewer scan the judgment, evidence, and structural change quickly.
   - If the audit is small and local enough that HTML would add more ceremony than value, skip the artifact and say why.
   - The final response should include the absolute path to the HTML artifact when one is created.

## Output Requirements

Read `references/output-template.md` before finalizing.

The answer must include:

- A clear razor verdict for the reviewed scope.
- Evidence reviewed, or a clear statement that evidence is missing.
- Before/after Mermaid diagrams when the recommendation changes a substantial workflow, process, module chain, state machine, service boundary, or architecture flow.
- A table classifying concepts as Keep, Merge, Defer, Delete, Replace, or Prove first.
- The strongest survival argument for any concept being cut.
- The complexity that must be preserved.
- A concrete cut list or proof list.
- For full audits, an HTML report written under `/tmp/hai-razor-<slug>/index.html`, or an explicit reason for skipping it.

## Common Mistakes

- Cutting a concept because it is large, not because it is unnecessary.
- Keeping a concept because it has a name, a file, a meeting, or an owner.
- Giving a strong opinion without evidence, or hiding unsupported assumptions inside confident prose.
- Treating "future extensibility" as evidence without naming the expected variation.
- Recommending a large process or architecture cut without showing before/after flow.
- Producing a dense Markdown-only full audit when the user needs a reviewable artifact.
- Removing a boundary and accidentally forcing every caller to understand lower-level details.
- Deleting fields or states without checking audit, permissions, recovery, analytics, or migration needs.
- Replacing a visible concept with hidden convention and calling that simplification.
