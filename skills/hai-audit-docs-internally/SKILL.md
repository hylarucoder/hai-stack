---
name: hai-audit-docs-internally
description: |
  Audits a document or document set for internal conflicts, terminology drift, duplicated or misplaced content, unsupported claims, and explicitly stale signals, then recommends update/move/merge/remove/split actions in repair order. Use for document self-consistency checks（文档前后不一致、内部冲突、重复内容）when no external implementation is the truth source. Use hai-audit-docs-against-code when claims must be checked against code or contracts.
---

# Hai Audit Docs Internally

For Chinese readers, see `SKILL.zh_CN.md`. The English `SKILL.md` is the execution source of truth.

## Overview

The source of truth is the document's own goal, structure, terminology, claims, and cross-references — not the codebase.

## Core Principle

A document is a coherent argument, and the audit reads it as one. Judge it for consistency of purpose, terms, and claims: every section should serve the same target, the same concept should carry the same name, and nothing should assert what another section denies or what no evidence supports. The enumerated consistency checks live in Workflow step 3.

## Workflow

1. Identify the document scope.
   - The scope is exactly what the user points at: a single file, an arbitrary batch of files, a
     PRD pack, README plus docs, or a generated spec set. Do not widen it to a directory uninvited.
   - Note the document's apparent audience, purpose, and expected decision/use.

2. Build a document map.
   - List the main sections and what each section is trying to do.
   - Extract key claims, definitions, terminology, assumptions, scope boundaries, examples, dates, owners, statuses, and cross-links.
   - Identify repeated claims and places where the same concept appears under different names.

3. Find internal issues.
   - **Direct conflict**: two sections make incompatible claims.
   - **Scope conflict**: in-scope and out-of-scope sections disagree.
   - **Terminology drift**: the same concept uses different names, or one name means different things.
   - **Lifecycle conflict**: statuses, phases, dates, or dependencies do not line up.
   - **Acceptance conflict**: success criteria do not prove the stated goal.
   - **Stale signal**: the document itself contains dates, statuses, replacement notices,
     decision order, or cross-references proving that text is superseded. Without such evidence,
     label it unsupported or needs decision—not stale.
   - **Redundant content**: repeated paragraphs, examples, or checklists should be merged or removed.
   - **Misplaced content**: implementation detail, policy, background, or task planning lives in the wrong document section.
   - **Unsupported claim**: a strong claim lacks evidence, owner, source, or decision record.

4. Decide the repair type.
   - **Update** when the content is useful but stale or imprecise.
   - **Move** when the content belongs elsewhere in the same document.
   - **Merge** when repeated content fragments one idea.
   - **Remove** when content is out of scope, obsolete, unsupported, or harmful.
   - **Split** when one document contains multiple independent goals or audiences.
   - **Ask** when a conflict cannot be resolved from the document itself.

5. Produce the audit.
   - Deliver: Verdict, Document Map, prioritized Findings (each with type, location, evidence, impact, repair), a Remove/Update/Move decision table, Open Decisions, and a Suggested Repair Order.
   - Read `references/output-template.md` before finalizing.
   - Prioritize issues that change understanding, decisions, scope, or execution.
   - Keep wording fixes secondary unless wording causes ambiguity or conflict.

## Severity

| Level | Meaning |
|-------|---------|
| P0 | Internal conflict could cause a wrong decision, unsafe action, or failed launch |
| P1 | Core goal, scope, terminology, or acceptance is inconsistent |
| P2 | Stale, duplicated, misplaced, or unsupported content creates confusion |
| P3 | Minor clarity, structure, or formatting issue |
| Needs decision | The document has a real fork that requires owner input |

## Use a different skill when

- The truth source is the code: use `hai-audit-docs-against-code` to check docs against implementation, config, and API contracts. This skill never compares against code.
- The document is a PRD that needs product-requirement crafting or repair (scope, acceptance, structure as a spec): use `hai-prd`.
- The docs just need formatting and presentation cleanup, not consistency judgment: use `readme-beautifier`.
- The user wants the document rewritten around the current conclusions, not a findings report: use `hai-rewrite-doc`. This skill diagnoses; it does not rewrite.
