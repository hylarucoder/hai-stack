# Frame-Opening Moves

Load this reference when a proposal is trapped in local optimization. Pick the smallest set of
moves that exposes the inherited assumption.

## End-state backcasting

Ask what would be true if the system were excellent six months from now, then work backward from
that target instead of today's package layout or partial implementation.

## Zero-legacy thought experiment

Ask what would be built today with no old callers. Compare it with the compatibility-preserving
path to separate real contracts from inertia.

## Kill the wrong concept

Consider deletion when a concept exists only because of history: duplicate lifecycle names,
transitional wrappers without a contract, vague manager/service/context objects, or document
sections preserved only because they already exist.

## Ten-times question

Ask what would obviously break under ten times the usage, teams, complexity, or product surface.
Use the answer to reveal the weak axis, not to justify speculative infrastructure.

## Constraint inversion

Temporarily remove the named constraint, design the clean target, then decide whether the
constraint is a real contract that must survive.

## Non-negotiable principles

Name two to four rules the target must not violate, such as one lifecycle owner or no compatibility
shim without a public contract.

## Tasteful deletion

Delete features, sections, abstractions, fields, or compatibility paths that do not serve the
target model; do not defer the decision behind “simplify later”.

## Hypothesis first, verification second

State the bold hypothesis, then name confirming evidence, a falsifier, the cheapest proof point,
and any risk that would make the direction irresponsible.
