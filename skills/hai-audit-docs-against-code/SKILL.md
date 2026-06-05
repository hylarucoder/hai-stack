---
name: hai-audit-docs-against-code
description: Audit whether documentation matches code implementation, configuration, and API contracts. Use when the user asks to verify README/docs/API docs against implementation, check whether docs are stale, compare documentation with code, or find doc-code mismatches. Trigger phrases include 文档和代码一致性, 文档是否过时, verify docs against code, docs vs implementation.
---

# Hai Audit Docs Against Code

For Chinese readers, see `SKILL.zh_CN.md`. The English `SKILL.md` is the execution source of truth.

## Goal

Find stale or implementation-inconsistent claims in README and documentation, with evidence from source code, configuration, schemas, API contracts, or generated types.

## Core Principles

1. **Code is truth**: when documentation conflicts with implementation, source code, configuration, and contract files win.
2. **Evidence before judgment**: every issue needs a concrete document location and a concrete implementation/config/contract reference.
3. **Contracts first**: OpenAPI, protobuf, GraphQL schema, database schema, and TypeScript types are strong sources of truth.
4. **Tighten safety defaults**: security, permissions, sandboxing, privacy, billing, and destructive operations should be reviewed with higher severity.
5. **Audit by scenario**: organize the audit around real user/developer/operator scenarios, not loose file-by-file scavenging.
6. **Explain the repair value**: every fix should state the benefit, such as reducing misuse, improving onboarding, or preventing failed integration.

## Workflow

1. Enumerate the documentation surface.
   - Root README.
   - `docs/**/*.md`.
   - API docs, examples, setup guides, generated docs, or user-provided documentation paths.
   - Contract files such as OpenAPI, protobuf, GraphQL schema, database schema, and TS types.

2. Define audit themes.
   - Extract 3-8 concrete scenarios from the README, docs, APIs, and configuration.
   - Examples: quickstart setup, API integration, environment configuration, permissions/security, lifecycle states, domain entities.
   - Group issues by theme; use a general documentation hygiene bucket only when no theme fits.

3. Review each document.
   - Extract important claims: behavior, commands, defaults, fields, API endpoints, permissions, examples, lifecycle states, and configuration.
   - Search the codebase for the matching implementation or contract.
   - Classify mismatches: missing feature, renamed concept, changed behavior, outdated default, broken command, stale example, wrong API shape, or unsupported claim.
   - Record each issue with document evidence, implementation evidence, impact, suggested fix, and repair value.

4. Cross-check from implementation back to docs.
   - Use contract files, configuration files, routes, CLI definitions, public types, and tests to find user-facing behavior that docs omit or describe incorrectly.
   - Prioritize omissions that would cause setup failure, integration failure, unsafe operation, or wrong mental models.

5. Produce the audit.
   - Read `references/checklist.md` and `references/output-template.md` before finalizing.
   - Use `references/output-format.md` for issue fields.
   - Keep uncertain findings as "needs evidence" rather than overstating them.

## Severity

| Level | Meaning | Example |
|-------|---------|---------|
| P0 | Security issue or severe misleading claim | Docs say sandboxing is enabled but code does not enforce it |
| P1 | Core workflow mismatch | Following docs causes setup, API use, or execution to fail |
| P2 | Incomplete example, naming mismatch, or stale non-blocking detail | Docs use an old field name |
| P3 | Minor wording, formatting, or link issue | Broken low-impact link |
| Needs evidence | Suspicion without enough proof | Requires further investigation |

## Output Requirements

For each issue, include:

- Severity.
- Document location.
- Implementation/config/contract evidence.
- Impact.
- Minimal suggested fix.
- Repair value.
- Related principle.

End with a summary verdict:

- Pass / conditional pass / fail.
- Counts by severity.
- Recommended fix order.

## Parallelization

If the scope is large, split work by:

- Documentation type: README, API docs, setup docs, guides.
- Module or feature area.
- Direction: docs-to-code and code-to-docs.

When combining parallel audits, deduplicate issues and normalize severity.
