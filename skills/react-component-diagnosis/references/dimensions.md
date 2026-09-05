# React Component Diagnosis Dimensions

Use these as evidence prompts, not universal style rules.

## Score calibration

| Score | Meaning |
|-------|---------|
| 5 | Strong local precedent with concrete patterns worth reusing |
| 4 | Solid design; only minor, evidenced friction |
| 3 | Usable but with a meaningful improvement opportunity |
| 2 | Prominent problems slow changes or create likely defects |
| 1 | The current design cannot safely support its core responsibility without major change |

No observed defect is not enough for a 5; missing evidence should lower confidence, not invent a
problem.

## Consumer API

Inspect required knowledge, defaults, invalid combinations, callback/control conventions, public
types, and error guidance. A larger API can be appropriate for a genuinely capable component; the
question is whether each option represents an independent concept and valid combinations are clear.

## Data flow

Trace inputs through pure derivation, state, effects, callbacks, and output. Look for props copied
into state without a lifecycle reason, effect chains that trigger each other, redundant sources of
truth, mutations hidden in callbacks, or derivation performed as an effect.

## Testability

Inspect whether important behavior can be exercised through public seams, whether pure domain logic
is separable when useful, and whether tests cover core, boundary, empty, and failure paths. Mocks are
a cost when they mirror implementation, but necessary external boundaries may justify them.

## Extensibility

Use current or credible near-term change pressure. Look for scattered dispatch logic, edits across
unrelated owners, or abstractions with no present variation. Do not reward “new features only add
files”; editing one clear owner is often simpler than a plugin system.

## Performance

Require evidence from render paths, dependency identity, profiling, input scale, or high-frequency
execution. Inspect unnecessary state updates, unstable context values, repeated heavy work, leaked
timers/listeners/requests, and bundle-heavy dependencies. Memoization is useful only when it removes
measurable work without making dependencies harder to reason about.

For frame-driven components, trace per-frame computation, temporary allocations, DOM volume,
reference stability, and cancellation of in-flight work.

## Mental model

Inspect whether names, ownership, directory boundaries, and dependency direction let a reader
predict where behavior lives. Vague utility drawers, surprise side effects, circular dependencies,
and competing names for one concept increase cognitive load.

## Boundaries and contracts

Inspect validation at trust boundaries, third-party leakage, type assertions, error ownership, and
whether conversions add meaning. Wrap a dependency only when the wrapper owns policy or isolates a
real replacement/compatibility risk. Create Input/Resolved/Render shapes only when their semantics
or guarantees differ—not merely because data crossed a function.
