---
name: hai-audit-docs-internally
description: Use when a user asks to audit documentation for internal conflicts, stale sections, duplicate or contradictory claims, unclear structure, outdated assumptions, or content that should be updated, moved, merged, or removed without comparing against code implementation.
---

# Hai Audit Docs Internally

For Chinese readers, see `SKILL.zh_CN.md`. The English `SKILL.md` is the execution source of truth.

## Overview

Use this skill to audit one document or a documentation set from the inside. The source of truth is the document's own goal, structure, terminology, claims, and cross-references, not the codebase.

## Core Principle

Treat documentation as a coherent argument:

- A document should have one clear purpose and audience.
- Sections should support the same target outcome.
- Definitions, terms, assumptions, flows, and examples should not contradict each other.
- Repeated content should either reinforce intentionally or be merged.
- Stale or unsupported content should be updated, moved, marked as open, or removed.
- Do not compare against code unless the user explicitly asks for doc-vs-code verification; use `hai-audit-docs-against-code` for that.

## Workflow

1. Identify the document scope.
   - Single document, related docs set, PRD pack, README plus docs, or generated spec set.
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
   - **Stale signal**: text references old decisions, old names, old dates, deprecated sections, or superseded assumptions.
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

## What This Skill Is Not

- Not a doc-vs-code audit. Use `hai-audit-docs-against-code` when implementation is the truth source.
- Not PRD-specific crafting. Use `hai-prd` when the document is a PRD and needs product-requirement repair.
- Not README beautification. Use `readme-beautifier` for formatting and presentation cleanup.
