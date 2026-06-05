---
name: hai-naming
description: |
  Use when the user asks how to name or rename a concept, variable, function, module, type, file,
  product surface, domain entity, workflow, or abstraction; asks for naming review; says a name feels
  vague, stiff, misleading, inconsistent, or hard to choose; or mentions 起名, 命名, 取名, 改名, 名字不好.
---

# Hai Naming

For Chinese readers, see `SKILL.zh_CN.md`. The English `SKILL.md` is the execution source of truth.

## Overview

Use this skill to help choose names that make the system easier to understand. Treat naming as architecture expressed in language: a good name reflects the whole context, the core actor's viewpoint, and the role a concept plays in the system.

Do not turn naming into a mechanical debate about conventions. Conventions matter, but only after the concept, responsibility, and system vocabulary are clear.

Core premise: name must be right before language can be smooth; if language is not smooth, work will not land. Naming is not cosmetic. It decides whether a reader can understand the call flow, responsibility boundary, and operating subject without translating between competing perspectives.

## Core Stance

### 1. Name inside the whole context

Never name from an isolated snippet if broader context is available. First understand:

- The concrete scenario where a reader meets the name: reading a module, calling an API, editing a workflow, debugging a state transition, or using a product surface.
- The product/domain concept the name represents.
- The core operating subject: who or what acts, decides, owns state, or experiences the workflow.
- The layer and audience: product UI, domain model, API contract, persistence, runtime internals, tests, or tooling.
- Neighboring concepts and existing vocabulary.
- Lifecycle: how the thing is created, used, transformed, completed, archived, failed, or retired.
- Boundaries: what this concept includes, excludes, owns, and delegates.

A name that sounds good locally can be wrong globally if it hides the main actor, duplicates an existing concept, or names an implementation detail instead of the domain role.

### 2. Preserve information before shortening

Do not shorten names just to make them shorter. Brevity is only useful when the surrounding context already carries the omitted information without forcing the reader to reconstruct it.

Prefer a longer explicit name when it prevents information compression, especially for:

- Exported functions, public APIs, domain entities, files, modules, events, workflow states, and cross-module types.
- Names that distinguish adjacent concepts, such as product vs domain, user work vs infrastructure execution, draft vs persisted state, request vs result, or configuration vs runtime state.
- Code a reader is likely to enter from search results, stack traces, tests, docs, generated clients, or API contracts.

Short names are acceptable only when the scope is tiny and the missing words are immediately visible in the same expression or block. If a reader has to infer a noun from the folder, a prior paragraph, or tribal knowledge, the name is over-compressed.

### 3. Use the current core actor's viewpoint

Pick one viewpoint that the naming set is organized around, then keep it stable across the module, call chain, and related API surface. Do not name one function from module A's viewpoint and the next function from module B's viewpoint if they belong to the same conceptual flow.

Before proposing or reviewing names, identify the viewpoint anchor:

- Product layer: name by what the user sees and intends.
- Domain layer: name by the durable business concept and its invariants.
- Runtime/infrastructure layer: name by execution responsibility, state transition, or protocol role.
- Adapter/integration layer: name by the boundary being bridged.

If a proposed name is hard to judge, ask: "From whose perspective is this name supposed to be obvious?" If two adjacent names answer that question differently without crossing a real boundary, the naming is inconsistent.

When a real boundary is crossed, make the perspective shift explicit through adapter, mapper, handler, port, DTO, event, or boundary-specific vocabulary. A hidden viewpoint shift is worse than a slightly longer name.

### 4. Follow the whole call flow

Naming must be checked against how the concept is called, passed, transformed, and returned. Do not judge names only at declaration sites.

Trace the relevant call flow:

- Who creates or receives the value?
- Which module owns the decision?
- Which module merely adapts, maps, forwards, stores, or renders it?
- What does the caller expect from the name before opening the implementation?
- Where does the perspective legitimately change?

Names in one flow should read like one sentence from one stable viewpoint. If reading a call chain forces the reader to switch between "what A sends", "what B receives", "what C stores", and "what the UI displays" without explicit boundaries, the names are not aligned.

### 5. Name the concept, not the rule

Avoid rigidly applying naming formulas. `fetch`, `get`, `load`, `create`, `build`, `manager`, `service`, `config`, and `context` are not automatically good or bad. Their quality depends on what they mean in this codebase.

Prefer a name that captures the real concept over one that merely satisfies a generic convention. If the project has a strong local vocabulary, follow it unless it actively misleads readers.

### 6. Let naming expose design problems

When all candidate names feel awkward, do not keep generating synonyms. Diagnose the design:

- Is one module mixing product, domain, and infrastructure concepts?
- Is one call flow switching viewpoints without an explicit boundary?
- Is the thing named by what it does today instead of what it owns?
- Are two different concepts sharing one name?
- Is one concept split across too many files?
- Is the current "thing" only a pass-through, glue layer, or temporary workflow step?

Say when the better answer is a design adjustment before a rename.

## Workflow

For a reusable recommendation or rename-audit skeleton, read `references/output-template.md` before finalizing the answer.

### Mode 1: Name a concept

1. Gather context.
   - Read related code, docs, schemas, routes, tests, UI labels, API names, and nearby naming patterns when available.
   - Identify the concrete reading or usage scenario where this name must make sense.
   - Trace the overall call flow around the concept, including caller, callee, adapter, storage, event, and UI/API entry points when relevant.
   - Identify the layer, caller, owner, lifecycle, and neighboring concepts.
   - Choose one viewpoint anchor for the naming decision and note where any real boundary requires a perspective shift.
   - Identify which details must stay visible in the name and which details are safely carried by local context.
   - Ask a focused question only if a missing fact changes the naming direction.

2. Define the concept before naming it.
   - Write one sentence: "This thing is..."
   - Write one sentence: "It is not..."
   - Identify the core actor or viewpoint.
   - State how this name should read in the surrounding call flow.
   - State what information the name must not compress away.

3. Propose 3-5 candidates.
   - Include at least one name aligned with existing vocabulary.
   - Include at least one name that reflects the clean conceptual model, even if it implies broader design cleanup.
   - Include at least one explicit, non-shortened name when the concept crosses module, API, or domain boundaries.
   - Avoid obscure synonyms and overly clever phrasing.
   - Do not rank a candidate higher just because it is shorter.

4. Recommend one.
   - Explain what mental model the name creates.
   - Explain what context the name preserves for someone reading the module cold.
   - Explain why the recommended name keeps the call flow in one coherent perspective.
   - Explain why the rejected names are weaker.
   - If no name is satisfactory, recommend the design clarification needed first.

Use this output shape:

```markdown
## Context Read
- <files/docs/concepts checked, or assumptions if unavailable>
- **Call flow checked**: <caller -> callee -> adapter/storage/UI/API shape, or unavailable>

## Concept
- **Is**: <one-sentence definition>
- **Is not**: <boundary>
- **Viewpoint**: <product/domain/runtime/etc. and core actor>
- **Call-flow reading**: <how the name should read in the surrounding calls>
- **Must preserve**: <information that should remain visible in the name>

## Candidates
### `candidateName`
- **Mental model**: <what a reader will assume>
- **Works because**: <fit to context>
- **Viewpoint consistency**: <whether it stays in the chosen perspective>
- **Information preserved**: <which important details remain explicit>
- **Risk**: <where it may mislead>

## Recommendation
`recommendedName` because <reason>.
```

### Mode 2: Review or rename existing names

1. Read the surrounding system, not only the declarations.
2. Build a small vocabulary map:
   - Core actors/entities.
   - Workflows and state transitions.
   - Calling modules and called modules in the relevant flow.
   - Layer-specific names for the same or related concept.
   - Terms that are overloaded or inconsistent.
3. Flag names that harm understanding:
   - They name the wrong actor or viewpoint.
   - They mix caller, callee, storage, UI, or adapter viewpoints inside one conceptual flow.
   - They flatten different concepts into one word.
   - They are over-compressed and require readers to recover missing context from memory, folder paths, or surrounding prose.
   - They expose implementation details at a product/domain boundary.
   - They preserve legacy vocabulary after the model changed.
   - They are too generic for their scope.
   - They are locally consistent but globally misleading.
4. Suggest changes in priority order. Prefer high-impact exported/API/domain names over small local variables.

Use this output shape:

```markdown
## Vocabulary Map
- <important concepts and current names>
- **Viewpoint anchor**: <chosen perspective for the reviewed naming set>
- **Call flow**: <important caller/callee/boundary sequence>

## Findings
### `oldName` -> `suggestedName`
- **Location**: <file:line>
- **Problem**: <why this hurts the system model>
- **Better model**: <what the new name makes clear>
- **Viewpoint repair**: <how the suggested name restores a single perspective or marks a real boundary>
- **Information restored**: <what the current name compressed away>
- **Impact**: <rename scope and migration concern>
```

## Practical Naming Checks

Use these as checks, not as laws.

- Scope: Wider scope requires more explicit names; tiny local scope can be terse.
- Scenario fit: Judge names from the reader's concrete entry point, not from the author's memory of the implementation.
- Viewpoint unity: One naming set should use one viewpoint unless a real boundary is explicitly named.
- Call-flow coherence: Read the caller, callee, and return path together; the names should not force perspective switching mid-flow.
- Information density: A name should not hide the actor, boundary, lifecycle state, or domain role when those distinctions matter.
- Consistency: Same concept should usually use the same word; different concepts should not share one word.
- Symmetry: Paired operations should read as peers: start/stop, open/close, encode/decode.
- Part of speech: Entities are usually nouns; actions are verbs; predicates read as questions.
- Boundary: API and domain names should avoid storage, transport, or framework details unless that boundary is the point.
- Lifecycle: State names should match real transitions, not arbitrary UI or implementation phases.
- Familiarity: Prefer common team vocabulary over clever or academic synonyms.
- Brevity: A shorter name is worse when it removes the distinction the module is responsible for teaching.
- Friction: If a name needs a paragraph of explanation, the concept or boundary may be wrong; if the name needs a hidden backstory, it is too compressed.

## Common Traps

- Debating synonyms before agreeing on the concept.
- Naming from the implementer's convenience instead of the caller's or domain actor's perspective.
- Switching between A-module and B-module viewpoints while naming one coherent flow.
- Naming declarations in isolation without checking how they read at call sites.
- Optimizing for shortness before preserving the concrete scenario, actor, and boundary.
- Dropping qualifiers that distinguish nearby concepts, then relying on readers to infer them from file paths or prior context.
- Treating generic conventions as universal truth.
- Keeping a legacy term because renaming feels disruptive, even though the old term now teaches the wrong model.
- Adding suffixes like `Manager`, `Service`, `Helper`, `Util`, `Data`, `Info`, or `Context` to avoid deciding what the thing actually owns.
- Renaming many small locals while leaving the exported/domain vocabulary confused.

## What This Skill Is Not

- Not a linter. Casing and style conventions are project-level constraints, not the center of the naming decision.
- Not a thesaurus. Do not solve unclear concepts by generating prettier synonyms.
- Not a rigid naming standard. Strong local vocabulary and architectural clarity beat generic formulas.
- Not only about identifiers. Product terms, API resources, domain entities, event names, workflow states, document titles, and file names all shape the system model.
