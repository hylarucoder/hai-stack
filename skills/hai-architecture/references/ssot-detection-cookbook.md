# Detection Cookbook — per-symptom search recipes

Adapt the patterns to the repo's languages. The examples assume Go backend + TS frontend +
SQL migrations, but every class has an analog in other stacks. Language-specific idioms and
exemptions live in the Language notes section at the bottom.

## 1. Multi-source literals

- Pick the wire vocabularies in scope (event types, status enums, error codes). For each value,
  count definition sites:
  `grep -rn '"the.literal"' --include='*.go' --include='*.ts' | grep -v _test`
  A healthy literal has exactly one non-test definition; references go through the constant.
- Hunt private constants shadowing public ones: `grep -rn 'EventType = "' | sort by value`.
- Registries/manifests that mix constant references with bare strings: scan the registry file for
  quoted literals — each one either lacks a constant (create it) or ignores an existing one.
- Find parity/pin/currency tests (`grep -rni 'pin\|currency\|stays in sync' *_test*`) — each marks
  a multi-source site, treated or untreated.

## 2. Shape proliferation

- For each wire payload: locate the producing struct and the consuming schema. Hand-written
  schema + struct = dual source. Evidence to capture: a field that already diverged (the
  strongest possible exhibit is a past incident).
- Typed→map regressions: grep seams for `map[string]any{` literals built from a typed value's
  fields (`Foo: x.Foo` inside a map build), and `AsPayload()`/`AsMap()` methods whose keys nobody
  reads back.
- Count shapes per concept: list every struct whose doc/name claims the same noun ("event",
  "result", "snapshot") and diff their field sets.

## 3. Word overload

- Take the domain's load-bearing nouns (from the glossary / core beliefs). For each, inventory
  every file/dir/type that uses the word: `find . -iname '*word*'` +
  `grep -rn 'type.*Word' --include='*.go'`. Classify by meaning; ≥2 meanings = finding.
- Special case: infrastructure adjectives squatting on domain nouns ("memory" = in-process vs
  the product's memory system).

## 4. Legacy mapping layers

- Grep retired vocabulary (old enum words, pre-rename terms) — survivors usually sit inside
  display-mapping switch statements and test fixtures.
- Then check whether the *mapping itself* exists more than once: same old→new pairs in two files.

## 5. Dual-pathway behavior forks

- List every entry point into a shared engine/service (server worker, CLI, scheduled job, test
  harness). Diff the options each entry passes: nil-vs-explicit-empty collections, skipped
  middleware/pipelines, different defaults. A fork only documented by a code comment is a finding.

## 6. Scattered defaults

- For each default-looking literal (paths, durations, limits, model IDs): count birth sites.
  Constants + inline fallbacks (`if x == "" { x = ... }`) for the same value in different layers,
  not referencing each other, = finding.
- `firstNonEmpty`/`cmp.Or` cascades are where these hide.

## 7. Pure-subset shape pairs

- Grep converter functions that only copy fields (`return B{X: a.X, Y: a.Y, ...}` with no
  transformation). Diff the two field sets; if B ⊆ A and the converter adds nothing, it's a
  finding.

## 8. Same-name-different-shape

- `grep -rn '^type Name struct' --include='*.go'` for each exported type name appearing more
  than once inside one module tree; flag only same-semantic-domain pairs (see adjudication).

## 9. Redundant conversion chains

- Pick a concept that crosses layers; trace one value end-to-end and count shape changes
  between the system edge and the point of use. More than one conversion = candidate chain.
- Grep converter compositions and round-trips: nested `toX(fromY(...))` calls,
  `FromDTO(ToDTO(x))`, mapper functions whose output feeds straight into another mapper.
- Typed→string→typed relays: a value serialized (`json.Marshal`, `JSON.stringify`,
  `.toString()`) and re-parsed downstream **within the same process** — grep marshal/unmarshal
  pairs on the same type inside one call path.
- Evidence to capture: every hop with file:line, and the per-hop answer to "what information
  does this shape add?" Hops with no answer are the finding; hops at real boundaries
  (audience change, info added) are exonerated individually.

## 10. Re-implemented derivations

- Pick rule-shaped logic: validation regexes, normalizations (trim / lowercase / URL / date
  parsing), derived flags and labels (`isActive`, `displayName`, totals, status computation).
  For each, count implementation sites across layers — duplicated-but-slightly-different is
  the strongest exhibit (the small diff IS the drift).
- Grep the same regex / threshold / format string appearing in more than one layer; grep the
  same field parsed (`time.Parse`, `new Date(`, `parseInt`) at more than one point on one path.
- Adjudicate trust boundaries first: client→server re-validation and DB constraints backing
  app checks are defense, not duplication. Flag only same-trust-level re-implementation.

## Cross-stack seam checklist (where to aim all of the above)

- Raw SQL strings and CHECK constraints vs language enums
- Hand-written wire schemas (Zod/JSON Schema/OpenAPI) vs producing types
- Untyped envelopes crossing package/layer boundaries (suspension payloads,
  evidence/metadata bags, magic request keys)
- Generated artifacts and their generators (is everything claimed-generated actually generated?)
- Docs that claim authority (glossaries, registries) vs the code they describe
- Test fixtures vs current wire vocabulary

## Language notes — idioms and exemptions per stack

### Go

- Untyped envelopes look like `map[string]any` / `map[string]interface{}` built with bare
  string keys; grep map literals whose fields copy a typed value (`Foo: x.Foo` inside a map build).
- Package-qualified generic names (`stream.Message` vs `processor.Message`) are the stdlib's own
  `bytes.Buffer` / `http.Client` pattern — exempt unless they share a semantic domain (class #8).
- Port/impl package pairs and per-plugin packages are layout conventions, not shape proliferation.
- Round-trip tells for class #9: `json.Marshal` + `json.Unmarshal` on the same type within one
  call path; struct↔map↔struct shuffles at layer boundaries.

### TypeScript

- Untyped envelopes look like `Record<string, unknown>` / `any` bags / index signatures; the
  class-2 regression tell is an `as` cast or a spread that flattens a typed object at a seam.
- Hand-written Zod / JSON Schema / OpenAPI fragments mirroring a server type are the canonical
  shape-proliferation site — prefer generating one from the other (`z.infer`, openapi-typescript).
- The same union-of-literals re-declared per layer (`'active' | 'archived'` in three files) is a
  class-1 multi-source literal even though no `enum` keyword appears.
- Interfaces re-declared per layer with one optional-field diff are class-7 pure-subset pairs;
  prefer `Pick` / `Omit` / `Partial` over a hand-copied interface.
- Round-trip tells for class #9: `JSON.parse(JSON.stringify(x))` clones, `toJSON`/`fromJSON`
  pairs inside one process, DTO↔domain mappers stacked per layer.

## 键集子集聚类（concept fracture 检测，2026-06-11 增补）

字符串键反复出现时，先别急着常量化/读侧收编——它可能是**一个概念被拆碎**的指纹。做法：把同一事件/payload 家族的全部构造器键集列成表，按共享核心键聚类。N 个形互为纯子集、判别子其实是事件类型/调用方时 = 一个概念 N 个形（shape proliferation 的概念级形态），治法是**单家族 struct（omitempty 全字段）+ 类型当判别子**，而不是给每个碎片各铸一个正式 struct。

伴生检查：payload 是否携带信封/外层已有的身份键（如 runId vs subject_id 列）——同一事实每条记录出生两次；存量 wire 冻结豁免，新增立"身份键不进 payload"规矩。

实例：everme store 4 个 params struct + 7 个 map 构造器 + timeline 第 5 形，全是"run 生命周期事件事实集"一个概念的子集。
