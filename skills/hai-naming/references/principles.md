# Naming Review Principles

Load this reference for public vocabulary, cross-module naming, or a rename plan.

## Context to inspect

- Where readers encounter the name: API, module, workflow, trace, test, UI, or schema.
- Product/domain concept and core actor.
- Layer and audience.
- Neighboring terms and existing glossary.
- Lifecycle from creation through completion, failure, archival, or retirement.
- What the concept includes, excludes, owns, and delegates.

## Information and scope

Longer explicit names are useful for exported functions, public contracts, entities, events,
workflow states, and cross-module types. Short names work when the omitted noun is visible in the
same expression or tiny scope. Do not make a reader recover meaning from folders or tribal knowledge.

## Call-flow check

Trace who creates, receives, transforms, stores, and renders the concept. Names in one flow should
read from one stable viewpoint. Make a viewpoint shift explicit only at a real adapter, mapper,
handler, DTO, event, or trust boundary.

## Mechanical checks

- Paired operations should be symmetric when they are true inverses.
- Entities are nouns, actions verbs, and predicates questions unless local conventions say otherwise.
- Lifecycle state names describe real transitions rather than arbitrary UI phases.
- A rename must account for source, tests, docs, contracts, wire values, persisted data, and generated
  artifacts as applicable.

## Design smell

Naming difficulty often reveals mixed product/domain/infrastructure concerns, viewpoint changes
without a boundary, ownership hidden behind mechanics, one word serving different concepts, or a
pass-through layer that has no concept of its own. Diagnose that shape before inventing a prettier
label.
