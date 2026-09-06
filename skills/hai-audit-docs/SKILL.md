---
name: hai-audit-docs
description: |
  Audits documentation for internal contradictions and/or mismatches with code, config, schemas, and approved contracts. Use for 文档审计、前后冲突、术语漂移、README 是否过时、文档和代码一致吗, including check-and-fix requests. Select evidence sources from the request; return prioritized findings, source precedence, and repair ownership. Apply clear local repairs only when requested. Use hai-rewrite-doc for wholesale reconstruction, hai-prd for product shaping, and readme-beautifier for formatting only.
---

# Hai Audit Docs

For Chinese readers, see `SKILL.zh_CN.md`. The English file is the execution source of truth.

## Principle

A coherent document can be factually wrong; implementation can violate an approved requirement.
Declare which authority settles each claim before deciding which side needs repair.

## Select evidence and action

- **Internal**: compare claims within the named document set. Respect "only docs/no code".
  Internal agreement proves consistency, not runtime truth.
- **Implementation/contract**: compare current-behavior claims with code/config and intended
  behavior with approved specs/contracts. Inspect related internal contradictions as useful.
- **Combined**: use both when the user asks for both or a general accuracy audit has both sources
  available. State the chosen scope; if code is unavailable, mark claims unverified instead of
  implying they match.
- **Audit only**: deliver findings without editing.
- **Check and fix**: when requested, apply evidence-backed repairs to the named local documents,
  then recheck affected claims and links. Do not silently change implementation to make docs true.
  Escalate unresolved product/authority choices; continue independent clear repairs.

These are internal modes, not questions the user must answer before work starts.

## Workflow

1. Identify the named document surface, audience, scenarios, and requested action. Do not expand
   named targets into sibling documents without reason or authorization. With no named targets,
   inspect README, setup/API docs, and examples relevant to the question.
2. Build a claim map: behavior, commands, defaults, lifecycle, permissions, terminology,
   assumptions, acceptance, and cross-links. Record source precedence per class of claim.
3. For internal evidence, read `references/internal-audit.md`; distinguish explicit supersession
   from unsupported claims. Absence of support alone does not prove a claim false or obsolete.
4. For implementation evidence, read `references/checklist.md`. Trace documented scenarios to
   implementation and inspect public/config contracts back toward documentation for important
   omissions. Cite both locations and identify generated versus canonical sources.
5. Classify each finding as document defect, implementation gap, internal conflict, or needs
   evidence/decision. If a doc describes approved future behavior, mark the implementation gap;
   do not rewrite it to bless current behavior. Consult `references/worked-examples.md` when
   authority is disputed.
6. Recommend update, move, merge, remove, split, or resolve. Separate a suggested repair from an
   applied edit. Preserve real contracts and unresolved claims explicitly.
7. If repairs were requested, make the bounded authorized edits and verify them. Route a wholesale
   rewrite to `hai-rewrite-doc` with the established evidence; product decisions belong to
   `hai-prd`, plan changes to `hai-goal`.
8. Read `references/output-template.md` and report scope, findings, actual edits, verification,
   and unresolved decisions without repeating a full report for each evidence mode.

## Impact

- P0: evidenced severe wrong decision, data/security harm, or launch failure.
- P1: core scenario, scope, or acceptance is materially wrong.
- P2: bounded drift, omission, duplication, or misleading terminology.
- P3: minor wording or link issue.
- Needs evidence/decision: unresolved; not a confirmed defect.

Rate actual impact, not the presence of a sensitive keyword. A security-related typo alone
does not become a release blocker.

## Boundaries

- Formatting without factual changes → `readme-beautifier`.
- Whole-document reconstruction → `hai-rewrite-doc`.
- Product requirements or acceptance definition → `hai-prd`.
- Entity fields and storage/migration placement → `entity-model-auditor`.
- Proving a software change works → `write-technical-acceptance-report`; documentation
  inspection alone does not prove runtime acceptance.
