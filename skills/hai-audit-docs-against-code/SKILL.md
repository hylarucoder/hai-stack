---
name: hai-audit-docs-against-code
description: |
  Audits documentation against the actual code, config, schemas, and API contracts and produces a
  severity-ranked (P0-P3 + needs-evidence) report of every stale or mismatched claim, each with a doc
  location, a code/contract reference, the impact, and a minimal suggested fix. Use whenever the user
  wants to verify README/docs/API docs against the implementation, check whether docs fell behind, or
  confirm setup steps / env vars / endpoints / examples still match the code after a rename or refactor —
  even on casual asks like "是不是过时了", "README 和代码对不上", "readme 还准吗", "我们改了接口文档忘了更新吧",
  "audit our docs", or "do the docs still match". Trigger on 文档和代码一致性, 文档是否过时, 文档跟实现不一致,
  这个 API 文档还准不准, openapi 和文档对得上吗, verify docs against code, docs vs implementation. For doc-vs-doc
  internal contradictions with no code comparison, use hai-audit-docs-internally instead.
---

# Hai Audit Docs Against Code

For Chinese readers, see `SKILL.zh_CN.md`. The English `SKILL.md` is the execution source of truth.

## Overview

Find stale or implementation-inconsistent claims in README and documentation, each backed by evidence
from source code, configuration, schemas, API contracts, or generated types. The audit runs in both
directions — docs-to-code and code-to-docs — and reports findings as a severity-ranked list, not prose.

## Core Principles

1. **Code is truth**: when documentation conflicts with implementation, source code, configuration, and contract files win.
2. **Contracts first**: OpenAPI, protobuf, GraphQL schema, database schema, and TypeScript types are strong sources of truth — prefer them over hand-written prose.
3. **Tighten safety defaults**: security, permissions, sandboxing, privacy, billing, and destructive operations get elevated severity (see Severity table).
4. **Evidence before judgment**: every issue needs a concrete doc location and a concrete code/config/contract reference — operationalized in the Workflow.
5. **Audit by scenario**: organize around real user/developer/operator scenarios, not file-by-file scavenging — operationalized in the Workflow.
6. **Explain the repair value**: every fix states the benefit (reduced misuse, smoother onboarding, fewer failed integrations) — a required per-issue field.

## Workflow

1. Enumerate the documentation surface.
   - When the user names targets — a single file or any batch of files — audit exactly those.
     Do not widen the scope to sibling docs or a whole directory uninvited.
   - Only when no target is given, default to the standard surface: root README, `docs/**/*.md`,
     API docs, examples, setup guides, generated docs.
   - Contract files: OpenAPI, protobuf, GraphQL schema, database schema, and TS types.

2. Define audit themes.
   - Extract 3-8 concrete scenarios from the README, docs, APIs, and configuration (quickstart setup, API integration, environment configuration, permissions/security, lifecycle states, domain entities).
   - Group issues by theme; use a general documentation-hygiene bucket only when no theme fits.

3. Review each document (docs-to-code), driven by `references/checklist.md`.
   - Use the checklist to extract important claims: behavior, commands, defaults, fields, API endpoints, permissions, examples, lifecycle states, configuration.
   - Search the codebase for the matching implementation or contract.
   - Classify mismatches: missing feature, renamed concept, changed behavior, outdated default, broken command, stale example, wrong API shape, or unsupported claim.
   - Record each issue with the per-issue fields under Output.

4. Cross-check from implementation back to docs (code-to-docs), also driven by `references/checklist.md`.
   - Use contract files, configuration, routes, CLI definitions, public types, and tests to find user-facing behavior that docs omit or describe incorrectly.
   - Prioritize omissions that cause setup failure, integration failure, unsafe operation, or wrong mental models.

5. Produce the audit.
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

## Parallelization

If scope is large, split work by documentation type (README / API docs / setup docs / guides),
module or feature area, or direction (docs-to-code and code-to-docs). When combining parallel
audits, deduplicate issues and normalize severity.

## Use a different skill when

- The comparison is doc-vs-doc with no codebase as truth source (internal contradictions, stale sections, duplication) — use `hai-audit-docs-internally`.
- You are auditing entity/data-model fields against a PRD (which fields exist, store-vs-compute, column-vs-config) — use `entity-model-auditor`.
- The document has drifted from the discussion conclusions and the user wants it rewritten, not a mismatch report — use `hai-rewrite-doc`.
