# Complexity Audit Lenses

Choose only the lenses that bear on the traced paths.

| Lens | Question | Evidence |
|------|----------|----------|
| Topology | Does repository shape match runtime/domain ownership? | tree, exports, ADRs, ownership rules |
| Dependency direction | Do policy modules depend on details or vice versa? | imports, manifests, generated/framework wiring |
| Runtime entrypoints | Can a reader predict how execution reaches core logic? | boot files, route/command registries, workers |
| Core call chain | Is the important path understandable and stable to change? | caller/callee trace, hops, effects |
| Module boundary | Does each owner hide complexity or leak downstream knowledge? | public API, repeated parameters, pass-through layers |
| State flow | Who owns lifecycle state and where can it change? | types, stores, DB fields, events, mutation sites |
| Abstraction depth | Does an abstraction hide more than it exposes? | interface versus internal complexity, real variations |
| Config construction | Is precedence assembled once or scattered through runtime? | env parsing, defaults, flags, builders, test overrides |
| Test protection | Do tests protect the path and contracts or only local mechanics? | integration, contract, unit, architecture tests |

Avoid two symmetric mistakes: treating every abstraction as valuable, and treating every duplicate
or trust-boundary recheck as waste. Ask what rule, distinction, or risk it owns.
