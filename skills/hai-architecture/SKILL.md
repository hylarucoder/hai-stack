---
name: hai-architecture
description: |
  Investigates architecture and change complexity from repository runtime paths to bounded modules, React components, and shared contracts. Use for 系统太绕、架构审查、模块边界、组件诊断、props API、effect/re-render, or SSOT/双源/漂移、重复规则、多处默认值、同名异形. Select global or bounded mode; return traced evidence, the complexity center, alternatives, and a first proof. React and SSOT lenses retain scored diagnosis or adjudicated treatment reports. Use hai-debug for unexplained faults and code-review-and-quality for diff/local-smell reviews.
---

# Hai Architecture

For Chinese readers, see `SKILL.zh_CN.md`. The English `SKILL.md` is the execution source of truth.

## Purpose

Review existing architecture or guide one design decision through the lens of managing complexity.
Find the boundary where change amplification, cognitive load, or unknown unknowns concentrate, then
recommend the smallest structural move that makes the system easier to understand and change.

## Select the work mode

- **Global investigation**: the cause or boundary of change friction is unclear, or the request
  spans a repository/large subsystem. Read `references/global-audit.md` and follow its entrypoint,
  call-chain, state/config, and test tracing procedure. Converge on important paths after mapping
  the entrypoint families; do not substitute a local smell review.
- **Bounded review/design**: a component, module, package boundary, or design choice is already identified.
  Follow the workflow below, inspecting its direct callers, contracts, and tests. For React
  components, read `references/react-patterns.md` for the seven dimensions and React-specific checks.
- **SSOT is a lens within either mode**, not a separate sweep: for duplicated definitions, rules,
  defaults, conversions, or vocabulary, read `references/ssot-patterns.md`, then only the relevant
  recipes in `references/ssot-detection-cookbook.md`. A named concept/contract is bounded; a broad
  repository sweep uses global investigation. Reuse the same evidence if ownership is the root cause.
- A request can move from global investigation into a bounded decision. Reuse collected evidence;
  do not rerun two full reviews or ask the user to choose an internal mode.

## Evidence gate

Before making an architecture claim:

1. Read every cited file in this session and cite real `file:line` locations.
2. Trace callers and implementations before asserting a call chain or blast radius; name the search.
3. Read ADRs, dependency rules, architecture tests, and public contracts that declare intended
   boundaries.
4. Compare a module's public surface with the complexity it actually hides before calling it deep
   or shallow.
5. Count each root cause once; cross-reference related symptoms instead of multiplying findings.
6. Label inference as unverified instead of presenting it as evidence.

A fabricated finding costs more trust than several missed findings. Prefer one verified painful
center over a checklist of plausible smells.

## Core judgments

### Find the painful center

Start with the boundary or call chain under review. Ask where a common change crosses owners,
requires several layers of knowledge, mixes lifecycle/persistence/execution concerns, or makes it
unclear what else must change. Local naming or style issues matter only when they reveal that deeper
force.

### Prefer deep modules

A useful module hides significant, related complexity behind a small, stable interface. Do not
split because a file is long or merge because files are adjacent. Split when the new boundary hides
information; merge when separate pieces share hidden knowledge and must be understood together.

For each layer or new shape, ask:

- Does the caller know less?
- Does this layer own a rule or invariant?
- Does it make illegal states harder to express?
- Can downstream change stop here?
- Does a conversion add meaning, constraints, or ownership?

If every answer is no, the layer is probably a pass-through tax. Do not create a new shape merely
because data crossed a function.

### Compare real alternatives

For a nontrivial decision, compare at least two materially different options. Explain why the
current design, a further split, a merge, or a generic abstraction is rejected when each is
plausible. For key recommendations, include a concise red-team misuse, blue-team defense, and
residual risk.

Read `references/principles.md` when the decision needs the full lens catalog, error-boundary
guidance, complexity vocabulary, or adversarial-review detail.

## Workflow

### Review existing code

1. State the reviewed boundary and the request's scale.
2. Pass the evidence gate: read implementation, callers, contracts, tests, and relevant decisions.
3. Draw a simple current map of actors/modules, dependency or state flow, and the intended hiding
   boundary.
4. Locate the highest-leverage complexity center.
5. Select only the relevant lenses from `references/principles.md`; do not score every lens by
   default. A full React component diagnosis uses the seven-dimension output variant; a narrow
   question uses only the relevant dimensions.
6. Apply the deep-module and layer-cost tests.
7. For SSOT candidates, adjudicate legitimate projections, trust-boundary rechecks, generated
   artifacts, and forward contracts before counting a violation; preserve persisted wire values.
8. Check relevant red flags in `references/red-flags.md`; use
   `references/worked-example.md` when calibrating a difficult finding or false positive.
9. Write a proportional report with evidence-backed findings ordered by impact.

### Guide a design decision

1. Clarify the goal, boundary, current constraints, and contracts that must survive.
2. Map the current chain before proposing changes.
3. Design at least two fundamentally different options.
4. Compare business fit, boundary clarity, module depth, migration cost, operational risk, and
   rejected alternatives.
5. Recommend one option, state residual risk, and name the first proof point.

## Scale

- **Quick**: one bounded question. Return the map, conclusion, evidence, main tradeoff, and next step.
- **Standard**: one package or call chain. Use the full markdown template.
- **Full**: multiple boundaries explicitly requested by the user. Map broadly, then converge on the
  painful center; increase evidence breadth without multiplying boilerplate.

The evidence gate applies at every scale. Do not make a quick question perform a full audit, and do
not call a repository-wide sweep complete after reading one attractive file.

## Output

Match the user's language and keep code identifiers unchanged. For standard/full Markdown reviews,
fill `references/output-template.md` in bounded mode; use `references/global-output-template.md` in global mode; for a quick answer, preserve its decision fields without
emitting empty sections. When the user explicitly asks for HTML, also read
`references/html-report.md`. Language-specific guidance is available in
`references/go-patterns.md`, `references/typescript-patterns.md`, and `references/react-patterns.md`.
For a full React component diagnosis, use `references/react-output-template.md` instead of a second
bounded report; preserve alternatives and first proof for nontrivial structural decisions.

For an SSOT-focused review use `references/ssot-output-template.md`; for a mixed review embed its
all-site evidence, not-counted candidates, treatment, and disposition fields in the main report.
Global coverage remains required; do not write a second report for the same root cause.
Diagnosis alone does not authorize edits; when fixes are requested, carry them through verification.

## Use a different skill when

- An unexplained malfunction needing reproduction and causal evidence → `hai-debug`.
- Local naming, function, or style smells without duplicated authority → `code-review-and-quality` or `hai-naming`.
- Product requirements rather than technical design → `hai-prd`.

## Not this skill

Do not use it as a formatter, feature-completeness audit, generic test advisor, or performance
review unless performance architecture or a React render/effect path is the explicit decision. Keep the focus on design quality
as it affects complexity.
