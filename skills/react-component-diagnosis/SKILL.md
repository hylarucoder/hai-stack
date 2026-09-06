---
name: react-component-diagnosis
description: |
  Diagnoses one React component or component directory across consumer API, data flow, testability, extensibility, performance, mental model, and boundaries/contracts, with code evidence and prioritized recommendations. Use when the user points to a component or .tsx file and asks about props/API design, effects, rerenders, architecture, or refactor need（组件诊断、props 设计、为什么 re-render）. Use code-review-and-quality for non-React files and hai-architecture when the scope crosses multiple system modules.
---

# React Component Diagnosis

## Purpose

Diagnose one React component's design from code that was actually read. The report should explain
the highest-leverage behavior, API, state, effect, rendering, or boundary problem—not reward a
fashionable directory shape or fill seven categories with generic advice.

## Evidence gate

1. Read the component entry file and the direct hooks, utilities, context, types, tests, and callers
   needed to understand its critical paths. Do not claim the whole directory was reviewed if some
   files were skipped.
2. Trace props and external data through derivation, state, effects, callbacks, and rendered output.
3. Cite concrete `file:line` evidence for every score deduction and recommendation.
4. Attribute one root problem to its most relevant dimension; do not double-count it.
5. Mark anything inferred from missing runtime/profile evidence as unverified.

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

Read `references/dimensions.md` for detailed evidence prompts, React-specific failure modes, and
score calibration. Use only the prompts relevant to the component.

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

## Workflow

1. Define the component boundary and summarize its responsibility in one sentence.
2. Build a small map: caller inputs → derivation/state/effects → children/output → callbacks.
3. Identify the one or two critical paths most likely to affect users or future changes.
4. Inspect the seven dimensions against those paths and tests.
5. Score each dimension from 1–5 using `references/dimensions.md`, citing evidence and avoiding
   double-counting.
6. Rank recommendations by impact and effort; distinguish confirmed problems from profiling or
   product questions that still need evidence.
7. Check the report against `references/output-template.md` before finalizing.

For animation, video, or other high-frequency rendering, explicitly trace what changes each frame,
which computations and allocations rerun, DOM-node volume, dependency stability, and whether cleanup
actually cancels work. Do not infer a performance defect from hook presence alone.

## Output

Use `references/output-template.md`, trimmed to the component's scale: responsibility, seven-score
card, evidence-backed analysis, strengths, and P0/P1/P2 recommendations with effort. Include a
diagram only when the multi-step data/effect flow is otherwise hard to understand.

## Use a different skill when

- Non-React file/function code smells → `code-review-and-quality`.
- Multiple modules, package boundaries, or system ownership → `hai-architecture`.
- One identifier or prop name only → `hai-naming`.
- Type-safety-only work → an available TypeScript type-safety skill.
- Applying the refactor rather than diagnosing it → an implementation/refactoring workflow.

Decision boundary: one component and its direct support surface stays here; a cross-system design
question moves to architecture.
