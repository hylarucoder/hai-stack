---
name: hai-naming
description: |
  Recommends names for concepts, identifiers, modules, files, entities, events, or product terms, or audits an existing naming set for misleading vocabulary and viewpoint drift. Use for “what should I call this?”, rename requests, or naming reviews（起名、命名、改名、名字不清楚）. Give a concise answer for one local name; use the full vocabulary map and migration scope only for cross-module or public naming audits. Route boundary problems exposed by naming to hai-architecture.
---

# Hai Naming

For Chinese readers, see `SKILL.zh_CN.md`. The English `SKILL.md` is the execution source of truth.

## Purpose

Treat naming as a model of the system, not a thesaurus exercise. A useful name tells the intended
reader what the concept is, who owns it, and how it differs from its neighbors without forcing them
to reconstruct hidden context.

## Choose the mode

- **Quick naming**: one local variable, function, prop, file, or concept. Give three to five
  candidates, recommend one, and explain the decisive distinction briefly.
- **Naming audit**: public or cross-module vocabulary, several related names, or a rename with
  migration impact. Build a vocabulary map, trace the call flow, and return prioritized renames.

Do not force an audit-sized reasoning trail onto a local identifier question.

## Decision rules

1. **Name in context.** Read the declaration, callers, neighboring concepts, layer, audience, and
   lifecycle available in the user's scope. Never invent a global model from one isolated snippet.
2. **Choose a viewpoint.** Product names describe user intent, domain names describe durable
   concepts, runtime names describe execution responsibility, and adapter names describe the
   boundary crossed. Keep the viewpoint stable until a real boundary changes it.
3. **Preserve decisive information.** Shorten only when the surrounding expression carries the
   omitted meaning. Public and cross-module names should usually be more explicit than local ones.
4. **Use one word per concept.** The same concept keeps one term; different concepts do not share a
   convenient generic word.
5. **Name ownership, not incidental mechanics.** `Manager`, `Service`, `Helper`, `Data`, `Info`,
   `Context`, `get`, and `build` are acceptable only when they accurately express the local model.
6. **Treat naming friction as evidence.** If every candidate needs a paragraph of explanation, the
   concept may mix responsibilities or viewpoints. Recommend a design clarification instead of more
   synonyms.

Read `references/principles.md` when a public or cross-module decision needs the expanded context,
call-flow, symmetry, lifecycle, or migration checks.

## Workflow

### Quick naming

1. State the concept, reader, layer, and nearest competing term.
2. Inspect the surrounding code or text the user supplied.
3. Generate three to five candidates that differ meaningfully, not cosmetically.
4. Recommend one and explain why the closest alternative loses.
5. Flag a design problem only when the evidence actually makes naming unstable.

### Naming audit

1. Read the relevant declarations, callers, contracts, docs, and persisted/wire names.
2. Map actors, concepts, lifecycle states, layer-specific vocabulary, and overloaded terms.
3. Identify wrong viewpoint, lost information, stale vocabulary, collisions, and inconsistency.
4. Prioritize public/API/domain names before small locals.
5. For each rename, state `old -> new`, evidence, conceptual repair, affected surfaces, and whether
   compatibility is required by a real contract.
6. Separate the recommended vocabulary from the migration plan.

## Output

Use the matching mode in `references/output-template.md`. A quick answer should remain conversational
and compact. An audit must include evidence and migration scope, but it does not need to expose a
performative “top-of-head” reasoning chain. Explain only what changed after reading when that change
affects the recommendation.

## Use a different skill when

- The name is awkward because module ownership or abstraction is wrong → `hai-architecture`.
- The question is whether a field should exist or where it belongs → `entity-model-auditor`.
- The user wants a bold direction change rather than a name → `geju`.
- The scope is an entire React component API, not one identifier → `react-component-diagnosis`.

## Not this skill

Do not act as a casing linter, rigid naming standard, or synonym generator. Project conventions
constrain the answer, but conceptual clarity decides it.
