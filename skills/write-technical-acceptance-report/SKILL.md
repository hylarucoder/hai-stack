---
name: write-technical-acceptance-report
description: Verify a defined software change against requirements and produce a proportional, evidence-backed acceptance report with specification precedence, scope boundaries, requirement-to-evidence traceability, executed test results, risk findings, a release verdict, and an automation/regression plan. Use for 技术验收报告, 变更验收, release-readiness reviews, implementation-vs-spec audits, high-risk migrations, billing/quota/stateful changes, or requests to decide what can be validated automatically instead of manually.
---

# Write Technical Acceptance Report

Build a report that lets a decision-maker accept or reject a defined change without trusting undocumented claims. Separate facts observed now from historical claims and unexecuted expectations.

## Choose depth

- **Compact**: a bounded low-risk change. Establish the expected outcome, run the relevant
  authoritative checks, and return a small requirement/evidence/status table plus a scoped verdict.
  Do not require a standalone report file, database fixture, or twelve report sections.
- **Full**: high-risk/stateful/migration work or an explicit detailed report. Follow the complete
  workflow and template below, selecting only applicable risk surfaces.

Both modes distinguish actual results from inference and preserve unresolved evidence.
Acceptance does not authorize deployment or merge. A request to inspect/verify remains read-only
apart from isolated test artifacts; fixes need an implementation request.
Code review belongs to `code-review-and-quality`; unexplained failures to `hai-debug`.
Do not repair a failed requirement merely to obtain a favorable acceptance verdict.

## Establish the audit contract

1. Read the repository instruction hierarchy before inspecting or changing files.
2. Identify the requested acceptance scope, the implementation boundary, the target environment, and the report destination.
3. Locate the governing specifications, decisions, plans, review remediations, and product parameters.
4. Record precedence explicitly when documents conflict. Prefer later ratified decisions over earlier plans, and runtime contracts over stale prose unless the user says otherwise.
5. Treat the current diff plus explicitly named committed changes as the candidate under test. Preserve unrelated user work.

For a full Git-repository report, run `bash scripts/collect-repo-evidence.sh <repo>` from this skill's directory as an initial inventory. It prints metadata only; it does not run tests or expose diff contents.

## Build traceability before judging

Create one row per independently verifiable requirement. Do not merge separate behaviors merely because they live in one feature.

Capture:

- requirement ID and source;
- business or technical risk protected;
- expected observable behavior;
- implementation evidence using stable file and line references;
- verification method and exact command or procedure;
- observed result;
- status: `PASS`, `PARTIAL`, `FAIL`, `BLOCKED`, or `NOT RUN`;
- remaining manual or environment-dependent work.

Use `PARTIAL` when only part of a requirement is proven. Never convert `skip`, “not applicable”, stale historical logs, typecheck success, code presence, or a mocked path into an executed behavioral pass.

## Inspect the complete risk surface

Trace the feature end to end rather than reviewing files in isolation:

1. Entry points and authorization.
2. Domain decisions and state transitions.
3. Persistence schema, migrations, constraints, isolation, and rollback.
4. Concurrency, lock order, idempotency, retries, and duplicate delivery.
5. External calls, timeout, fail-open/fail-closed behavior, and compensation.
6. Public API/contracts, error codes, user-facing copy, and compatibility.
7. Configuration defaults, deployment overrides, feature flags, and generated mirrors.
8. Metrics, logs, alerts, reconciliation, and operational recovery.
9. Security, privacy, tenant isolation, and secret handling.

Read `references/acceptance-method.md` for stateful, concurrent, financial, migration, or otherwise high-risk changes.

## Execute verification in layers

Use project-authoritative commands. Start focused, then widen in proportion to risk:

1. Static integrity: dirty-tree boundary, generated-file freshness, formatting, lint, typecheck, migration shape, and contract consistency.
2. Unit/contract tests: calculations, mappings, error taxonomy, and negative paths.
3. Real dependency integration: use an isolated database/cache and real transaction or script behavior.
4. End-to-end/story tests: observe public API/UI events and persisted state together.
5. Operational probes: metrics, alerts, retry behavior, rollback, and recovery.

For stateful tests, prefer a freshly created disposable database or namespace, apply migrations from zero, seed deterministic identities, run cases, reconcile invariants, and remove only the resources created for the run. Also test upgrades from every supported deployed schema when applicable.

Record the exact command, timestamp/environment facts that matter, counts, exit status, skips, and failure cause. If an environment is unavailable, mark the case `BLOCKED` or `NOT RUN`; do not infer behavior from source.

## Design repeatable regression

Classify each acceptance item:

- `A0 fully automated`: deterministic and safe in every CI run;
- `A1 fixture integration`: needs disposable Postgres/Redis/object storage;
- `A2 controlled staging`: needs deployed services or sandbox credentials;
- `A3 live-cost canary`: consumes money, quota, or third-party capacity and requires a budget;
- `M product/manual`: visual judgment, policy approval, or destructive production verification.

For each automated item specify the trigger, fixture isolation, assertions, cleanup, artifact, owner, runtime budget, and false-green guard. Add invariant reconciliation after behavioral cases for ledgers, quotas, inventories, or other derived state.

Explicitly detect false greens:

- skipped tests exit zero;
- missing database silently skips integration;
- stale long-lived test data satisfies assertions;
- mocks bypass the behavior under acceptance;
- retries hide duplicate writes;
- only the HTTP response is checked while persisted state is wrong;
- only the database is checked while the public terminal event is wrong.

## Issue the verdict

Use one verdict only:

- `GO`: all release-critical requirements passed with current evidence;
- `CONDITIONAL GO`: no known release-blocking defect, but named preconditions remain;
- `NO-GO`: a release-critical behavior failed or has an unacceptable untested gap.

Rank findings as `P0` release blocker, `P1` high, `P2` medium, or `P3` low. State impact, evidence, reproduction, and the minimum closure proof. Do not soften a missing live test into “basically passed”.

## Write the report

In full mode use `assets/acceptance-report-template.md` as the structure, omitting inapplicable sections and gates. In compact mode use the small table and verdict described above. Lead with the verdict and the exact acceptance boundary. Keep the report self-contained and include:

- executive verdict and conditions;
- scope and explicit exclusions;
- specification precedence;
- system/change map;
- requirement traceability matrix;
- executed evidence ledger;
- severity-ranked findings;
- detailed acceptance cases;
- automation coverage and regression architecture;
- release gate and sign-off checklist;
- residual risks and follow-up ownership.

Place working reports according to repository policy. Prefer a local ignored work-document directory unless the user explicitly requests a tracked artifact.

## Quality gate

Before delivery, verify that:

- every conclusion points to evidence;
- every critical requirement has a status;
- executed and historical results are distinguishable;
- skips and blockers are visible;
- configuration needed to activate the feature is covered;
- database migrations are proven on clean and upgrade paths as required;
- high-risk state invariants are machine-checkable;
- the verdict follows from the matrix, not optimism;
- local files created by the run are listed, and temporary resources are cleaned up.
