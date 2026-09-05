---
name: hai-audit-docs-against-code
description: |
  Audits documentation against code, configuration, schemas, and API contracts, producing severity-ranked mismatches with evidence, impact, and the smallest honest repair. Use when checking whether README/docs, commands, environment variables, endpoints, examples, or public behavior still match implementation（文档和代码一致吗、README 是否过时）. Use hai-audit-docs-internally when the truth source is only the document set itself.
---

# Hai Audit Docs Against Code

For Chinese readers, see `SKILL.zh_CN.md`. The English `SKILL.md` is the execution source of truth.

## Overview

Find stale or implementation-inconsistent claims in README and documentation, each backed by evidence
from source code, configuration, schemas, API contracts, or generated types. The audit runs in both
directions — docs-to-code and code-to-docs — and reports findings as a severity-ranked list, not prose.

## Core Principles

1. **Declare precedence before judging**: current implementation proves what runs now; an approved
   PRD/spec may define intended behavior; public contracts and persisted schemas constrain what can
   change. A mismatch is not automatically a documentation defect.
2. **Prefer authoritative sources over derivatives**: identify which OpenAPI/protobuf/schema/type is
   generated or canonical before treating it as truth.
3. **Tighten safety defaults**: security, permissions, sandboxing, privacy, billing, and destructive operations get elevated severity (see Severity table).
4. **Evidence before judgment**: every issue needs a concrete doc location and a concrete code/config/contract reference — operationalized in the Workflow.
5. **Audit by scenario**: organize around real user/developer/operator scenarios, not file-by-file scavenging — operationalized in the Workflow.
6. **Explain the repair value**: every fix states the benefit (reduced misuse, smoother onboarding, fewer failed integrations) — a required per-issue field.

## Workflow

1. Establish the audit question and source precedence.
   - Is the document claiming current behavior, intended behavior, or a public promise?
   - Record which code, contract, approved spec, or configuration is authoritative for each class
     of claim. If authority is unresolved, report "needs evidence/decision".

2. Enumerate the documentation surface.
   - When the user names targets — a single file or any batch of files — audit exactly those.
     Do not widen the scope to sibling docs or a whole directory uninvited.
   - Only when no target is given, default to the standard surface: root README, `docs/**/*.md`,
     API docs, examples, setup guides, generated docs.
   - Contract files: OpenAPI, protobuf, GraphQL schema, database schema, and TS types.

3. Define audit themes.
   - Extract 3-8 concrete scenarios from the README, docs, APIs, and configuration (quickstart setup, API integration, environment configuration, permissions/security, lifecycle states, domain entities).
   - Group issues by theme; use a general documentation-hygiene bucket only when no theme fits.

4. Review each document (docs-to-code), driven by `references/checklist.md`.
   - Use the checklist to extract important claims: behavior, commands, defaults, fields, API endpoints, permissions, examples, lifecycle states, configuration.
   - Search the codebase for the matching implementation or contract.
   - Classify mismatches: missing feature, renamed concept, changed behavior, outdated default, broken command, stale example, wrong API shape, or unsupported claim.
   - Record each issue with the per-issue fields under Output.

5. Cross-check from implementation back to docs (code-to-docs), also driven by `references/checklist.md`.
   - Use contract files, configuration, routes, CLI definitions, public types, and tests to find user-facing behavior that docs omit or describe incorrectly.
   - Prioritize omissions that cause setup failure, integration failure, unsafe operation, or wrong mental models.

6. Produce the audit.
   - Assemble findings into the report; keep uncertain findings as "needs evidence" rather than overstating them.
   - Read `references/output-template.md` and fill it in before finalizing.

## Severity

| Level | Meaning | Example |
|-------|---------|---------|
| P0 | Security issue or severe misleading claim | Docs say sandboxing is enabled but code does not enforce it |
| P1 | Core workflow mismatch | Following docs causes setup, API use, or execution to fail |
| P2 | Incomplete example, naming mismatch, or stale non-blocking detail | Docs use an old field name |
| P3 | Minor wording, formatting, or link issue | Broken low-impact link |
| Needs evidence | Suspicion without enough proof | Requires further investigation |

Elevate severity by at least one level when the claim touches security, permissions, sandboxing,
privacy, billing, or destructive operations — a wrong claim there is more dangerous than elsewhere.

## Output

Each issue carries: severity, document location, implementation/config/contract evidence, impact,
minimal suggested fix, repair value, and related principle. End with a summary verdict (pass /
conditional pass / fail), counts by severity, and a recommended fix order.

The full report shape — issue fields, summary verdict table, and worked examples — lives in
`references/output-template.md`. Read it and fill it in before finalizing; do not invent a second schema.

## Use a different skill when

- The comparison is doc-vs-doc with no codebase as truth source (internal contradictions, stale sections, duplication) — use `hai-audit-docs-internally`.
- You are auditing entity/data-model fields against a PRD (which fields exist, store-vs-compute, column-vs-config) — use `entity-model-auditor`.
- The document has drifted from the discussion conclusions and the user wants it rewritten, not a mismatch report — use `hai-rewrite-doc`.
