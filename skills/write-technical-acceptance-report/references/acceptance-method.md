# Acceptance method for high-risk changes

## Evidence strength

Use the strongest available evidence and label weaker evidence honestly.

| Level | Evidence | What it proves |
| --- | --- | --- |
| E4 | Live/staging end-to-end result plus persisted-state reconciliation | The deployed path behaved correctly in that environment |
| E3 | Real dependency integration on a clean isolated fixture | Transactions, constraints, scripts, and concurrency behave as asserted |
| E2 | Unit/contract test executed now | The tested module behavior and contract pass |
| E1 | Static code/config inspection | An implementation path exists; runtime behavior is not proven |
| E0 | Plan, comment, historical report, or unverified claim | Intent or prior evidence only |

Never use E0/E1 alone to mark a release-critical runtime requirement `PASS`.

## Status and severity

Status:

- `PASS`: all acceptance assertions executed and met.
- `PARTIAL`: some assertions pass; material assertions remain.
- `FAIL`: an assertion executed and did not meet the expected result.
- `BLOCKED`: execution could not proceed because a required environment, credential, decision, or dependency was unavailable.
- `NOT RUN`: intentionally deferred or outside the current execution window.

Severity:

- `P0`: can cause wrong money/data, cross-tenant access, irreversible corruption, broad outage, or guaranteed release failure.
- `P1`: major behavior, recovery, security, or observability gap with plausible user/operational impact.
- `P2`: bounded defect or regression weakness with a workaround.
- `P3`: low-risk polish, maintainability, or reporting issue.

## Financial and quota invariants

Express the accounting identity as executable SQL or code. Typical examples:

```text
current_spent
= sum(current-window billable spend coalesce(actual, estimate))
 - sum(current-window refunds actual)

available = quota - current_spent
```

Check after every scenario, not only after the happy path. Cover:

1. concurrent admission near the boundary;
2. concurrent delivery of the same idempotency key;
3. settle twice, void twice, and settle-after-void;
4. actual below, equal to, and above estimate;
5. failure before the expensive call and after partial usage;
6. window rollover with old pending entries;
7. same-window and cross-window refund policy;
8. non-billable recording without balance change;
9. Redis failure and database failure according to the chosen fail mode;
10. account isolation and cursor pagination.

Use deterministic centi-unit assertions. Avoid floating-point comparisons at the storage boundary.

## Migration validation

Test two distinct paths:

1. Clean install: create an empty database and apply every migration in order.
2. Supported upgrade: restore the latest released schema/data fixture, then apply only new migrations.

If a migration file changed after any shared environment applied it, `CREATE TABLE IF NOT EXISTS` will not add new columns or constraints. Either confirm the earlier version was never released/shared, reset disposable developer databases, or add a new forward migration. Never call a stale long-lived database a clean-install test.

Also run down/up only when rollback is supported. Verify table/column/constraint/index presence and representative data preservation.

## Repeatable regression architecture

Build a pyramid with explicit cost controls:

| Lane | Trigger | Dependencies | Purpose |
| --- | --- | --- | --- |
| Fast | every push | none/mocks | formulas, DTOs, mappings, error taxonomy, source freshness |
| Stateful | every MR | disposable Postgres + Redis | locks, idempotency, migrations, Lua, reconciliation |
| Story | merge candidate/nightly | local or staging stack + fake provider | public event + database state together |
| Live canary | scheduled/manual approval | real provider with capped budget | protocol/usage drift and real charging |

Make the fake provider stream protocol-correct usage and scripted failures so normal story regression does not spend external money. Reserve real-provider tests for a small canary matrix with a hard daily budget, dedicated accounts, maximum token caps, and automatic cleanup.

## False-green guards

Require preconditions to fail loudly:

- dedicated integration commands must exit non-zero when Postgres/Redis is unavailable;
- a skipped case must remain a skip in the report and must not increment the passed count;
- assert at least the expected number of tests/cases ran;
- use fresh account IDs and a fresh database or schema per run;
- write a machine-readable artifact containing environment, commit, cases, assertions, and cleanup status;
- reject stale generated mirrors and missing feature-flag activation;
- reconcile database invariants after the suite and fail on orphan `pending` rows.

## Automation prioritization

Prioritize by expected manual burden removed and failure impact:

```text
priority = execution_frequency × manual_minutes × defect_impact × determinism
```

Automate deterministic money/data assertions first. Keep visual taste and policy approval manual, but automate their preconditions and evidence capture.
