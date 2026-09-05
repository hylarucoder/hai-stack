# LLM Complexity Tells — the over-engineering an LLM adds by default

Read this when the audit target is **code** (or a code-shaped design) and the suspected problem is
over-engineering. It is the "LLM lens" for the razor: a catalog of complexity that language models
produce by reflex, mapped to the same verdict vocabulary as `SKILL.md`
(Keep / Merge / Defer / Delete / Replace / Prove first).

## Why the lens exists

An LLM cannot see the call graph, the caller's guarantees, or which futures are real. So it hedges:
it pattern-matches "production-grade / robust / extensible" code and emits the ceremony that *looks*
like quality. The result is complexity with no owner — code that survives because it resembles good
code, not because removing it would break a goal. That is exactly the razor's target, so each tell
below is read through the **existence question**: *what concretely breaks if this disappears?*

## The behavior-preservation gate (applies to every tell)

This lens proposes simplifications that must **preserve observable behavior**. Before recommending a
cut, name the result that must not change and the paths it travels — return values, side effects,
error/exception surface, ordering, concurrency, and performance characteristics. A cut you cannot
prove behavior-equivalent is **Prove first**, not Delete. Edge cases LLM code quietly relies on
(empty input, nil/null, overflow, the one error branch that *does* recover) are where "obvious"
simplifications change behavior — check them explicitly.

## Tells

Each tell: how to spot it · the existence question it fails · the typical verdict · the boundary
where cutting becomes damage (do NOT cut past this).

### 1. Defensive over-checking

- **Spot**: nil/null/type guards on values the type system or an upstream contract already
  guarantees; re-validating an argument the only caller already validated; checks for conditions
  that cannot occur on any real path; `if x == nil { return }` where `x` is never nil.
- **Fails**: *what behavior, decision, or invariant depends on this check?* — none, if it can't fire.
- **Verdict**: usually **Delete**.
- **Boundary**: a **trust boundary** is real defense, not duplication — client→server re-validation,
  parsing untrusted input, public API arguments, DB constraints backing app checks. Keep those.

### 2. Speculative parameters & config for the future

- **Spot**: function params / options objects / flags with exactly one caller and one value;
  `enabled bool` that is always true; "extensible" hooks, registries, or strategy slots with one
  entry; constants lifted into env/config that never vary.
- **Fails**: *what variation exists now that this parameterizes?* — naming an imagined future is not
  evidence (see `SKILL.md` Common Mistakes).
- **Verdict**: **Delete** the knob and inline the single value; **Defer** if a concrete near-term
  variation is named.
- **Boundary**: a knob with two real callers passing different values earns its existence.

### 3. Premature abstraction / pass-through layers

- **Spot**: an interface/abstract class with exactly one implementation; a `Manager`/`Service`/
  `Helper`/`Wrapper` whose methods just forward to one collaborator; a factory that constructs one
  concrete type; a layer that translates A→A.
- **Fails**: *what complexity does this hide from callers? what boundary does it protect?* — none,
  if it forwards 1:1.
- **Verdict**: **Merge** (inline the wrapper into its caller) or **Delete** the interface and use the
  concrete type.
- **Boundary**: a one-impl interface earns existence if it is a genuine **seam for testing** (mocked
  in tests) or a published extension point with a named second implementer coming. A **deep module**
  that hides real complexity behind a small interface is Keep, not Merge.

### 4. Re-implementing the standard library / existing helpers

- **Spot**: hand-rolled map/filter/reduce/dedup/group-by loops; manual JSON assembly via string
  concat or `map[string]any`; bespoke clamp/min/max/date-math; a local copy of a helper that already
  exists one package over.
- **Fails**: *what does this re-implementation add over the stdlib/existing one?* — usually nothing,
  and it drifts (see `SKILL.md` / ssot re-implemented derivations).
- **Verdict**: **Replace** with the library/existing call.
- **Boundary**: behavior-preservation gate is sharp here — verify empty-collection, overflow,
  locale/timezone, and nil semantics match before replacing. If they differ, the hand-rolled version
  may encode a real requirement → **Prove first**.

### 5. Ceremonial error handling

- **Spot**: try/catch (or `if err != nil`) that only re-throws / re-wraps with no added context;
  per-line wrapping; custom error types that carry the same information as the underlying error;
  catch-all blocks that log and continue.
- **Fails**: *what failure, recovery, or decision needs this handling?* — none, if it adds no context
  and changes no control flow.
- **Verdict**: **Delete** the redundant wrap (let the error propagate) or **Merge** wraps that add
  nothing.
- **Boundary**: a catch that **adds context**, **recovers**, **translates to a boundary's error
  contract**, or **prevents a silent failure** is Keep. Never turn a real handler into a swallowed
  error — that is damage, not simplification (this is the failure mode `avoid-fallback-logic` warns
  about).

### 6. Redundant intermediate state

- **Spot**: a temp variable assigned once and immediately returned; a collection built up only to be
  iterated once right after; intermediate DTO/map structs that exist only to be unpacked one line
  later (overlaps ssot conversion chains).
- **Fails**: *what reuse, clarity, or boundary justifies the intermediate?* — none, if used once.
- **Verdict**: **Merge** / inline.
- **Boundary**: keep the intermediate if it names a non-obvious value for readability, or is read
  more than once.

### 7. Symmetry & completeness padding

- **Spot**: full CRUD when only read is called; getters/setters for every field "for completeness";
  handling enum/case branches that cannot occur; implementing both directions of a conversion when
  one is used.
- **Fails**: *what caller exercises this?* — aesthetic completeness is not a caller.
- **Verdict**: **Delete** the unused arms; **Defer** if a near-term caller is named.
- **Boundary**: exhaustive `switch` arms that exist to fail loudly on a new enum value are a real
  guardrail — keep them (often as a single `default: panic/unreachable`).

### 8. Generalizing for one case

- **Spot**: generics / type parameters with one instantiation; `T extends ...` bounding a single
  type; a strategy/visitor/template-method with one concrete path.
- **Fails**: *what family of types varies here?* — one type is not a family.
- **Verdict**: **Replace** with the concrete type.
- **Boundary**: a second real instantiation, present in the codebase, earns the generic.

### 9. Defensive copies & over-immutability

- **Spot**: cloning an input that is never mutated; deep-copying for a read-only pass; freezing
  objects that are never shared across a mutation boundary.
- **Fails**: *what aliasing/mutation hazard does this copy prevent?* — none, if nothing mutates it.
- **Verdict**: **Delete** the copy.
- **Boundary**: a copy that protects a caller's slice/object from later in-place mutation, or guards a
  concurrency hazard, is Keep — and is a behavior-preservation landmine, so verify no mutation path.

### 10. Verbose control flow

- **Spot**: nested if/else pyramids that invert to guard clauses + early return; a boolean accumulated
  across branches then returned; a `switch`/`if-else` chain with one live arm.
- **Fails**: this is usually **fat, not unnecessary** — the concept deserves to exist.
- **Verdict**: **out of razor's scope.** Per `SKILL.md` Common Mistakes, do not cut a concept for
  being large. Route purely cosmetic restatement of a deserved concept to `/simplify` or the
  `code-simplifier` skill, which do behavior-preserving local cleanup. Note it and move on.

## How to fold these into the audit

- Treat tells **1–9** as code-level instances of the `SKILL.md` Razor Targets (abstraction, layer,
  field, rule, step). Run them through the normal Workflow: deletion test → hidden owner → classify →
  protect necessary complexity → guardrail. Record each in the Razor Map with its file:line evidence.
- For tell **10** (and anything that is "the concept is right, the implementation is just verbose"),
  do not classify it — hand it to `/simplify`. The razor judges *existence*, not line count.
- Always close with the behavior-preservation gate: every Delete/Merge/Replace verdict on code names
  the result that stays identical and the edge cases checked. Anything unproven is **Prove first**.
