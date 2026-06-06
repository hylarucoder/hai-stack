---
name: hai-naming
description: |
  Produces 3-5 candidate names with one recommended final name, the three-stage reasoning
  trail behind it (research-stage / top-of-head / final-after-reading), and — for reviews — a
  priority-ordered rename list with old->new and migration scope. Use when the user asks how
  to name or rename anything (concept, variable, function, module, type, file, product surface,
  domain entity, event, workflow state, or abstraction), wants a naming review or audit, or
  says a name feels vague, stiff, misleading, inconsistent, too long, too generic, or hard to
  choose — even if they only mention it in passing while reviewing code. Be pushy: trigger on
  "what should I call this", "better name for X", "this name sucks", "rename this var", "whats
  a good name", "review my naming", and when every candidate feels awkward (usually a design-
  boundary problem, not a vocabulary one). Chinese triggers: 起名, 命名, 取名, 改名, 名字不好,
  这个叫什么好, 取个名字, 换个名, 这名字怎么样, 名字太长, 命名规范, 命名审查, 变量名/函数名怎么取.
---

# Hai Naming

For Chinese readers, see `SKILL.zh_CN.md`. The English `SKILL.md` is the execution source of truth.

## Overview

Treat naming as architecture expressed in language: a good name reflects the whole context, the
core actor's viewpoint, and the role the concept plays in the system. A name decides whether a
reader can understand the call flow, responsibility boundary, and operating subject without
translating between competing perspectives.

Do not turn naming into a mechanical debate about conventions. Conventions matter, but only
after the concept, responsibility, and system vocabulary are clear.

## Three-Stage Naming

Every recommendation exposes three stages instead of only showing the final answer — this makes
the reasoning path visible, not just the verdict:

1. **Research-stage naming**: the rough name from quick context gathering — existing vocabulary,
   neighboring concepts, initial constraints. Shows what the current system seems to teach
   before deep reading.
2. **Top-of-head naming**: the intuitive, fast, "拍脑袋" name from first-principles sense of the
   concept. Allowed to be slightly bold, raw, or imperfect; its value is exposing the first
   mental model before existing wording biases it.
3. **Final naming after reading**: the recommended name after reading the relevant docs, code,
   call flow, product context, or system vocabulary. This is the name to ship unless a stated
   constraint blocks it.

If the three names differ, explain what changed your mind. If they converge, explain why the
name stayed stable after deeper reading.

## Core Stance

These six principles are the judgment content; the Workflow and checks below reference them.

### 1. Name inside the whole context

Never name from an isolated snippet if broader context is available. First understand:

- The concrete scenario where a reader meets the name: reading a module, calling an API, editing
  a workflow, debugging a state transition, or using a product surface.
- The product/domain concept the name represents.
- The core operating subject: who or what acts, decides, owns state, or experiences the workflow.
- The layer and audience: product UI, domain model, API contract, persistence, runtime
  internals, tests, or tooling.
- Neighboring concepts and existing vocabulary.
- Lifecycle: how the thing is created, used, transformed, completed, archived, failed, retired.
- Boundaries: what this concept includes, excludes, owns, and delegates.

A name that sounds good locally can be wrong globally if it hides the main actor, duplicates an
existing concept, or names an implementation detail instead of the domain role.

### 2. Preserve information before shortening

Do not shorten names just to make them shorter. Brevity is only useful when the surrounding
context already carries the omitted information without forcing the reader to reconstruct it.

Prefer a longer explicit name when it prevents information compression, especially for:

- Exported functions, public APIs, domain entities, files, modules, events, workflow states, and
  cross-module types.
- Names that distinguish adjacent concepts: product vs domain, user work vs infrastructure
  execution, draft vs persisted state, request vs result, configuration vs runtime state.
- Code a reader is likely to enter from search results, stack traces, tests, docs, generated
  clients, or API contracts.

Short names are acceptable only when the scope is tiny and the missing words are immediately
visible in the same expression or block. If a reader has to infer a noun from the folder, a prior
paragraph, or tribal knowledge, the name is over-compressed.

### 3. Use the current core actor's viewpoint

Pick one viewpoint the naming set is organized around, then keep it stable across the module,
call chain, and related API surface. Do not name one function from module A's viewpoint and the
next from module B's viewpoint if they belong to the same conceptual flow — a hidden viewpoint
shift is worse than a slightly longer name.

Identify the viewpoint anchor before proposing or reviewing names:

- Product layer: name by what the user sees and intends.
- Domain layer: name by the durable business concept and its invariants.
- Runtime/infrastructure layer: name by execution responsibility, state transition, protocol role.
- Adapter/integration layer: name by the boundary being bridged.

If a name is hard to judge, ask: "From whose perspective is this name supposed to be obvious?"
If two adjacent names answer differently without crossing a real boundary, the naming is
inconsistent. When a real boundary is crossed, make the shift explicit through adapter, mapper,
handler, port, DTO, event, or boundary-specific vocabulary.

### 4. Follow the whole call flow

Check names against how the concept is called, passed, transformed, and returned — not only at
declaration sites. Trace: who creates or receives the value, which module owns the decision,
which module merely adapts/maps/forwards/stores/renders it, what the caller expects from the
name before opening the implementation, and where the perspective legitimately changes.

Names in one flow should read like one sentence from one stable viewpoint. If reading a call
chain forces the reader to switch between "what A sends", "what B receives", "what C stores", and
"what the UI displays" without explicit boundaries, the names are not aligned.

### 5. Name the concept, not the rule

`fetch`, `get`, `load`, `create`, `build`, `manager`, `service`, `config`, and `context` are not
automatically good or bad; their quality depends on what they mean in this codebase. Prefer a
name that captures the real concept over one that merely satisfies a generic convention. If the
project has a strong local vocabulary, follow it unless it actively misleads readers. Suffixes
like `Manager`, `Service`, `Helper`, `Util`, `Data`, `Info`, or `Context` are often a way to
avoid deciding what the thing actually owns.

### 6. Let naming expose design problems

When all candidate names feel awkward, do not keep generating synonyms — diagnose the design:

- Is one module mixing product, domain, and infrastructure concepts?
- Is one call flow switching viewpoints without an explicit boundary?
- Is the thing named by what it does today instead of what it owns?
- Are two different concepts sharing one name?
- Is one concept split across too many files?
- Is the current "thing" only a pass-through, glue layer, or temporary workflow step?

A fast trigger for this diagnosis: if a name needs a paragraph of explanation, or a hidden
backstory, to make sense, the concept or boundary is probably wrong — or the name is
over-compressed. Treat that friction as a design signal, not a wording problem.

Say so when the better answer is a design adjustment before a rename, and route per "Hand off
when" below.

## Workflow

**Mode 1 — Name a concept:**

1. Produce the **research-stage name** from quick research context.
2. Produce the **top-of-head name** from first principles, before overfitting to existing wording.
3. Deep-read the call flow and concept, then produce the **final name after reading** (anchor one
   viewpoint per stance #3; decide what must stay visible per stance #2).
4. Propose 3-5 candidates per the rules in the template (include one vocabulary-aligned, one
   clean-concept, one explicit name for boundary-crossing concepts).
5. Recommend the final name and explain why the rejected ones are weaker; if none is satisfactory,
   recommend the design clarification needed first.

**Mode 2 — Review or rename existing names:**

1. Read the surrounding system, then build a small vocabulary map (actors, workflows, calling/
   called modules, layer-specific names for the same concept, overloaded terms).
2. For each important rename, show the three-stage path.
3. Flag names that harm understanding (wrong actor, mixed viewpoints, flattened concepts,
   over-compression, leaked implementation, stale legacy term, too generic, locally-consistent-
   but-globally-misleading).
4. Suggest changes in priority order — high-impact exported/API/domain names before small locals.

The expanded per-step detail lives in `references/output-template.md`.

## Output

Mode 1 fills `Context Read` / `Concept` / `Three-Stage Naming` / `What Changed After Reading` /
`Candidates` / `Recommendation`. Mode 2 fills `Vocabulary Map` / `Findings` (each `oldName ->
suggestedName` with location, three-stage path, problem, better model, viewpoint repair,
information restored, impact). Read `references/output-template.md` for the full fill-in blocks
before finalizing.

## Practical checks

Mechanical checks the principles above do not already cover — use as checks, not laws:

- **Symmetry**: paired operations should read as peers (start/stop, open/close, encode/decode);
  asymmetric pair names imply the operations are not actually inverses, misleading the reader.
- **Part of speech**: entities read as nouns, actions as verbs, predicates as questions — so the
  reader can tell what a name returns without opening it.
- **Consistency**: the same concept uses the same word; different concepts do not share one word.
- **Lifecycle states**: state names should match real transitions, not arbitrary UI or
  implementation phases.

## Hand off when

- The awkward name is really a module-boundary / abstraction problem (stance #6) — route to
  **hai-architecture** to fix the design before the rename.
- The concept is a data-model field question (should it exist, store vs compute, column vs jsonb)
  — route to **entity-model-auditor**.
- The user actually wants a bold direction change, not a name — route to **geju**.

## What this skill is NOT

- Not a linter. Casing and style conventions are project-level constraints, not the center of the
  naming decision.
- Not a thesaurus. Do not solve unclear concepts by generating prettier synonyms.
- Not a rigid naming standard. Strong local vocabulary and architectural clarity beat generic
  formulas.
- Not only about identifiers. Product terms, API resources, domain entities, event names,
  workflow states, document titles, and file names all shape the system model.
