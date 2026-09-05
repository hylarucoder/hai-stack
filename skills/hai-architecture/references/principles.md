# Architecture Review Principles

Load this reference when the bounded decision needs more than the core tests in `SKILL.md`.

## Complexity vocabulary

- **Change amplification**: one conceptual change requires edits across several owners or layers.
- **Cognitive load**: safe work requires holding too much unrelated context at once.
- **Unknown unknowns**: developers cannot predict what they need to inspect or change.

Dependencies and obscurity create all three. More code is not automatically more complex; explicit
code can reduce cognitive load.

## Review lenses

Choose three to six that affect the decision; never fill the list mechanically.

1. Business fit and near-term feature pressure.
2. Boundary and ownership clarity.
3. Dependency direction and policy/detail leakage.
4. Module depth and information hiding.
5. Change amplification.
6. Cognitive load and obviousness.
7. Runtime lifecycle ownership: run, retry, resume, wait, timeout, completion.
8. Data ownership and schema semantics.
9. Interface stability and credible extension paths.
10. Operational observability.
11. Error boundaries and recovery.
12. Security, policy, and trust boundaries.
13. Test and verification surfaces for architectural invariants.
14. Migration and compatibility cost.

## Error-boundary order

For each error path ask, in order:

1. Can API semantics define the error out of existence?
2. Can the lower layer mask it safely?
3. Can similar errors be aggregated behind one boundary?
4. Must the caller receive it?
5. Is recovery impossible enough that stopping is the honest behavior?

## Why-not test

A meaningful recommendation explains why plausible alternatives are weaker. Compare, when relevant:

- Keep the current boundary.
- Improve it conservatively.
- Merge shared knowledge into one owner.
- Split around a real information-hiding boundary.
- Introduce a deeper redesign.

Judge each against current needs, module depth, migration cost, and operational risk.

## Red/blue check

- **Red**: how could a future developer misuse, misunderstand, or break the proposed boundary?
- **Blue**: how do the interface, types, placement, tests, or docs prevent that?
- **Residual risk**: what remains after the defense?

Use this for lifecycle state, persistence, retry/resume behavior, public interfaces, security, and
other decisions where an attractive diagram can hide operational failure.

## Layer-cost test in detail

A layer earns its cost when it compresses knowledge, owns a rule, prevents invalid state, or stops
change propagation. Mapping fields one-to-one is not new meaning. A wrapper with no owned invariant
is not automatically an abstraction. A type prevents misuse only when downstream APIs require it
and arbitrary values cannot bypass it.
