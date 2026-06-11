---
name: hai-ssot
description: >-
  Diagnoses single-source-of-truth (SSOT) violations and produces a numbered findings report —
  file:line evidence, honest adjudication (real violation vs idiomatic false positive),
  severity, and disposition per finding, plus a treatment-recipe table. Covers ten symptom classes:
  multi-source literals, shape proliferation, word overload, legacy-vocabulary mapping layers,
  dual-pathway behavior forks, scattered defaults, pure-subset shape pairs,
  same-name-different-shape types, redundant conversion chains, and re-implemented
  derivations. Use whenever the user suspects duplicated definitions, drift between layers,
  redundant converting or re-validating, or inconsistency — even casually:
  "这两个地方会不会不同步", "加一个 X 要改几处", "这个常量好像定义了两遍", "前后端形状对不上",
  "形状可以统一吗", "没有单一数据源", "SSOT", "双源", "漂移", "字面量重复", "同名异形",
  "这个类型转来转去", "转换了好几次", "没必要转这么多次", "到处都在校验/解析这个",
  "为什么有两个一样的 struct", "check for drift", "single source of truth", "defined twice",
  "converted back and forth", "do these stay in sync".
---

# Hai SSOT

For Chinese readers, see `SKILL.zh_CN.md`. The English `SKILL.md` is the execution source of truth.

## Overview

Hunt down places where one fact, one shape, or one word has more than one authoritative home —
or where one name secretly serves several facts. Produce a findings report that an engineer can
execute from: every finding numbered, evidenced, honestly adjudicated, and routed to a concrete
disposition. The skill is a diagnostic with a strong opinion about treatment, not a linter.

## The Core Law

SSOT violations cluster, almost without exception, **at boundaries the type system cannot
reach**: language↔database (string literals in raw SQL and CHECK constraints), language↔wire
(hand-written schemas mirroring the producing types), layer↔layer (untyped payload envelopes —
`Record<string, unknown>`, `map[string]any`, bare dicts — keyed by raw strings), code↔docs,
production↔fixture. Inside one compiler's reach, multi-source dies
naturally — a second definition is a compile error or an obvious dead symbol. Outside it,
multi-source is the *equilibrium state*: every producer hand-builds, every consumer hand-gropes,
every layer re-copies the strings it needs.

Two corollaries that direct the hunt:

1. Start at the cross-stack seams; don't burn time grepping for intra-language duplication.
2. A test that pins two copies equal ("parity test", "pin test", "currency test") is a flag:
   either the copy should not exist (eliminate it, then delete the test), or both sides are
   genuinely real artifacts that cannot share a source (then the test IS the correct treatment).
   Locate every such test early — each one marks either a violation or a treatment already applied.

## The Ten Symptom Classes

Read `references/detection-cookbook.md` for concrete search recipes per class before sweeping.

| # | Symptom | One-line definition | Canonical tell |
|---|---|---|---|
| 1 | **Multi-source literals** | One wire string / enum value defined independently in N places | Same quoted literal in two modules; a private const shadowing a public one |
| 2 | **Shape proliferation** | One concept carried by N type/schema shapes across seams | Hand-written schema on one side of a wire mirroring the producing type on the other; typed→untyped "regressions" where a typed object gets flattened back into a string-keyed map at a seam |
| 3 | **Word overload** | One word meaning N different things (the mirror of #1) | The domain's most valuable word (e.g. "memory" as product moat) also used for infrastructure ("in-memory"); a term with 2-3 documented senses |
| 4 | **Legacy-vocabulary mapping layers** | Old vocabulary survives inside display/fixture mapping functions after a wire rename — and the mappings themselves get copy-pasted | The same old→new word map appearing in two files; fixtures asserting retired vocabulary |
| 5 | **Dual-pathway behavior forks** | The same operation behaves differently depending on which entry path/host ran it | A CLI path skipping the safety pipeline the server path runs; one caller passing explicit-empty where another gets defaults |
| 6 | **Scattered defaults** | The same fallback value born independently at multiple layers | A default directory/timeout/limit defined as a constant in one layer AND as an inline fallback in another, neither referencing the other |
| 7 | **Pure-subset shape pairs** | Type B = type A minus k fields, plus a field-by-field copy converter | A converter function that only copies fields; the "information" carried by the second shape is merely hiding fields |
| 8 | **Same-name-different-shape** | Two exported types with the same name in the same semantic domain but different fields | `RunSnapshot` in two sibling modules meaning related-but-different things |
| 9 | **Redundant conversion chains** | One concept reshaped at multiple hops along a single call path, where the intermediate shapes add no information | A value converted A→B→C on its way through layers; round-trips (A→B→A); typed→string→typed relays where a value is serialized and re-parsed inside one process. Kill question per hop: "what information does this shape add?" — no answer means the hop merges |
| 10 | **Re-implemented derivations** | The same rule — validation, normalization, parsing, a derived field — implemented independently at N layers, each a drift point | The same regex/threshold/branching duplicated with small diffs; a date string parsed at three layers; `isActive`/`displayName` computed differently in two views |

Severity logic: a violation that has **already caused a production symptom** (silent empty
rendering, correctness bug, wrong cursor) outranks everything; next, violations on persisted or
user-visible wire; then cross-team/cross-stack seams; intra-module duplication last.

## Honest Adjudication — what NOT to flag

Findings are leads, not verdicts. Run these checks before a finding enters the report; record
exonerated candidates in a "not counted" note so the next sweeper doesn't re-litigate:

- **Module-qualified generic names are idiomatic, not violations.** A short generic type name
  qualified by its module (`stream.Message` vs `processor.Message`) is the standard-library
  pattern in every module system (see the cookbook's language notes for per-language exemplars).
  Flag same-name types only when they share a semantic domain and confuse a cross-module reader
  (class #8), or collide in one file.
- **Forward contracts are alive even with zero producers.** A registry entry / enum value with no
  backend producer may be consumed by a frontend switch as a forward contract. Grep every consumer
  surface (web, contract, seeds) before calling anything dead. Disposition for these: annotate and
  group, never delete on producer-absence alone.
- **Persisted wire literals are frozen.** The fix unifies *definition sites*; the string values
  on disk/in events never change. Even naming inconsistencies baked into the wire (mixed prefixes)
  get documented, not repaired.
- **A shape change is legitimate when it carries information** — adds a sequence number, hides
  internal fields for an audience, renames into a consumer's vocabulary. The disease is reshaping
  that carries nothing (class #7), typed→map regressions, and chains where every hop re-converts
  without adding anything (class #9). Judge each hop separately: a chain can contain one real
  boundary and two gratuitous ones.
- **Re-checks at trust boundaries are defense, not duplication.** A server re-validating client
  input, or a DB constraint backing an app-level check, is deliberate redundancy across trust
  levels. Class #10 flags re-implemented rules at the *same* trust level — two layers behind the
  same boundary each owning their own copy of the regex, threshold, or parse.
- **Port/impl module pairs and per-plugin modules are conventions**, not fragmentation. Don't
  recommend flattening them in an SSOT report.
- **Deliberate, adjudicated dual vocabularies can exist** (e.g. an ADR chose a flat result type
  with a closed discriminator). Check decision records before flagging; contrast honestly — a
  4-field type with a closed-set kind is not the same disease as a 9-field union with no
  discriminator semantics.

The credibility of the whole report rests on this section. One overreaching finding ("unify all
the Messages!") teaches the reader to ignore the real ones.

## Treatment Recipes

Every confirmed finding routes to exactly one recipe; the recipe determines the disposition:

| Recipe | When | Notes |
|---|---|---|
| **Codegen** | One side can mechanically generate the other (type → schema, registry → enum file) | Strongest fix; pairs with a *currency test* (guards "forgot to regenerate" — that is a constructive gap a compiler can't close, so the test is legitimate) |
| **Parity guard** | Both sides are real artifacts that cannot share a source (language enum vs DB CHECK constraint) | Include a *red drill*: deliberately desync once and confirm the guard fires |
| **Constant promotion** | Bare string keys in map envelopes crossing layers | Promote to a named constant next to its siblings; both writer and reader reference it |
| **Typed payload** | Shape proliferation / map regressions at seams | Often a phase of a larger contract plan; don't band-aid per-field |
| **Convert at the edge** | Redundant conversion chains | Convert once where the value enters the system; pass one canonical type through the interior; merge hops that add no information |
| **Single rule owner** | Re-implemented derivations | Hoist the rule into one named function/type and make every layer call it; where possible encode the proof in the type (parse, don't validate) so downstream layers cannot re-do the work |
| **Vocabulary close-out** | Word overload, legacy mapping layers | Glossary entry + rename of the cheap side; map function single-sourced or fixtures moved to current vocabulary |
| **Adjudication** | Behavior forks | These need a *decision*, not a patch: unify the behavior, or promote the fork into an explicitly documented contract. Present both options with a default recommendation |
| **Delete the pin** | After any recipe eliminates a copy, delete the parity test that was holding the copies together — its survival is evidence of remaining multi-source |

## Workflow

1. **Scope.** Agree on the sweep surface (a module, a contract plane, the whole repo). Note any
   prior sweeps/plans to avoid re-finding adjudicated items.
2. **Map the seams first.** List the type-system-unreachable boundaries in scope (which wires,
   which DB constraints, which untyped envelopes, which generated artifacts). The Core Law says
   the findings live there.
3. **Hunt per symptom class** using the cookbook greps. For each candidate, capture file:line for
   *every* definition/use site — counts matter ("this literal is defined in exactly 2 places",
   "adding one event touches 6 files" is the change-amplification number that lands the point).
4. **Verify producer AND consumer** for anything you might call dead or removable. The
   three-surface discipline: backend producers, frontend/contract consumers, seeds/fixtures.
5. **Adjudicate honestly** (section above). Sort exonerated candidates into the "not counted" note.
6. **Write the report** using `references/output-template.md`: numbered findings, evidence,
   severity, recipe, disposition table, positive list ("already-healthy patterns to copy" —
   naming what the repo already does right makes the report constructive and gives fixes a local
   precedent to imitate).
7. **Execute quick wins if asked** — constant promotions and literal de-duplications are usually
   safe same-day (zero wire change, full test gate). Bigger recipes get routed to plans; behavior
   forks get routed to the user as decisions.

## Hand off when

- The finding's root cause is a module-boundary or layering problem → **hai-architecture**.
- A finding needs a new name, or the report turns into a rename list → **hai-naming**.
- The dispositions need to become a phased, verifiable plan → **hai-goal**.
- The user wants to reframe the whole contract surface rather than patch findings → **geju**.

## What this skill is NOT

- Not a linter: it reports adjudicated findings with treatment routes, not raw matches.
- Not "unify everything": its credibility comes from the not-counted list as much as the findings.
- Not a wire-migration tool: persisted values are out of bounds; only definition sites move.
