# Goudi Anti-Patterns and Counter-Moves

The five failure patterns goudi exists to catch. Step 2 of the Workflow scans a proposal
for these; when one is present, apply its counter-move while choosing the minimum viable
move and the stop rule.

## 1. Vision Without First Step

The proposal sounds right, but nobody knows what to do this afternoon.

Counter-move:

- Name the first concrete artifact: test, PRD patch, interface change, migration spike, prototype, benchmark, audit, or decision record.
- Define the exact scope of the first step.
- State what is intentionally out of scope.

## 2. Fake Migration Plan

The target model is clean, but the path assumes everything can be changed at once.

Counter-move:

- Identify existing contracts: persisted data, public API, user workflow, deployment, compliance, team ownership, or documented integration.
- Split target design from migration path.
- Prefer one narrow vertical slice over broad partial rewrites.
- Name the irreversible step and delay it until evidence exists.

## 3. Unpriced Risk

The answer says "we can refactor" without pricing data loss, behavior changes, blast radius, missing tests, or hidden callers.

Counter-move:

- List the top 3 risks by blast radius.
- Give each risk a verification method.
- Decide which risk must be retired before implementation.
- Reject work that cannot be validated inside a reasonable feedback loop.

## 4. Long-Term Correct, Short-Term Irresponsible

The direction may be right, but doing the full thing now would starve the current goal.

Counter-move:

- Separate the end-state from the next milestone.
- Ask whether the next milestone makes the system more correct even if the full target is not finished.
- Cut impressive but non-essential work.
- Preserve optionality when confidence is still low.

## 5. No Stop Rule

The plan can only continue; it cannot fail gracefully.

Counter-move:

- Define failure signals before starting.
- Define rollback or containment.
- Define when to pause and gather evidence.
- Make sunk-cost continuation unacceptable.
