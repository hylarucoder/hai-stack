# Field Classification Guide

Apply these questions in order. A later storage decision cannot rescue a field that has not earned
its existence.

## 1. Existence

A field must serve a current goal, invariant, external contract, audit need, or observable behavior
and must not duplicate another authority. Ask what concretely breaks if it disappears. Uniqueness,
symmetry, completeness, or possible future use is not enough.

Watch for correlated fields that always move together, numeric controls with false precision, and
structured descriptive fields that a single owned content value already covers.

## 2. Store or compute

| Evidence | Treatment |
|----------|-----------|
| Deterministic and cheap derivation from durable authoritative data | Compute; do not persist a second authority |
| Expensive but reproducible derivation | Consider a cache/materialized projection; define invalidation and rebuild |
| History, external observation, lifecycle decision, or unreconstructable fact | Persist |
| Source or derivation unclear | Undecided; gather evidence |

Changing because of a system event does not imply “computed”. Durable workflow status often records
a decision or history and therefore belongs in storage.

## 3. Column, config, or related entity

| Evidence | Treatment |
|----------|-----------|
| Filtering, sorting, joins, uniqueness, referential integrity, indexing, or independent updates | Column or related table |
| Cohesive low-query configuration owned and versioned together | JSON/config object |
| Unbounded or independently growing child data | Related entity |

JSON may lower schema-migration frequency, but shifts cost into validation, versioning,
observability, and query limitations. Do not use it as the automatic home for “not queried today”.

## 4. System or content

- **System value**: backend behavior branches on it; define validation and supported evolution.
- **Content value**: passes into display, prompts, or descriptions without semantic branching;
  avoid an enum unless a contract requires a closed set.

## 5. Stored form

Distinguish the persisted value from presentation or derived forms: storage key versus URL, enum
key versus localized label, template versus rendered content, raw input versus computed output.
Name each form for what it actually contains.
