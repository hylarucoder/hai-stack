# React Patterns for Bounded Reviews

Use within hai-architecture bounded mode for a component and its direct support surface.
Apply the shared evidence gate and deep-module tests; reuse evidence if scope expands.

## Trace the component

Read the entry component, direct hooks, utilities, context, types, tests, and callers needed for
its critical paths. State any files skipped. Map caller inputs → derivation/state/effects →
children/output → callbacks, then inspect the one or two highest-impact paths.
Attribute each root cause to one primary dimension; cross-reference rather than deduct twice.
Missing profiling or runtime evidence lowers confidence, not the score by itself.

## Dimensions

| Dimension | Core question |
|-----------|---------------|
| Consumer API | Can callers express valid use cases without learning internal mechanics? |
| Data flow | Is props/state/derived data/effect flow unidirectional and traceable? |
| Testability | Can important behavior be verified through stable public seams? |
| Extensibility | Does a likely change have a proportionate blast radius without speculative abstraction? |
| Performance | Is there evidenced unnecessary rendering, computation, allocation, or leaked work? |
| Mental model | Can a reader predict ownership and where behavior changes? |
| Boundaries & contracts | Are external data, third parties, errors, and trust boundaries handled once by the right owner? |

## Guardrails

- Prop, file, or line counts are clues, never automatic deductions.
- Do not reward a new type at every layer. A new shape earns its cost only when meaning,
  constraints, audience, or ownership changes; otherwise preserve one canonical shape.
- Do not recommend `useMemo`, `useCallback`, context splitting, dynamic imports, adapters, slots,
  factories, or Error Boundaries by default. Name the observed rerender, computation, failure
  boundary, or change pressure that justifies them.
- A component can be large and coherent; a small component can still hide tangled state and effects.
- Praise only patterns supported by code, and award the top score only when the implementation is a
  useful local precedent.

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

## Output variant

For a full component diagnosis, use `references/react-output-template.md` with seven 1–5 scores,
file:line evidence, supported strengths, and P0/P1/P2 recommendations with effort. Mark a dimension
unverified when evidence is insufficient; do not invent scores or strengths to fill the template.
For a narrow props/effect/rerender question, use the quick bounded answer and only relevant lenses.
Diagnosis does not authorize a refactor. For nontrivial structural recommendations retain the
bounded review's alternatives, tradeoff, residual risk, and first proof point.
