# Naming Output Templates

Single source of truth for the fill-in shapes. The inline skeletons in `SKILL.md` are a
strict subset of these; match these section names. Show the three-stage naming path before
the final recommendation in both modes.

---

## Mode 1: Name a concept

Expanded steps (the lean numbered list in `SKILL.md` references these by name):

1. **Research-stage name** — read related code, docs, schemas, routes, tests, UI labels, API
   names, and nearby naming patterns when available; identify the concrete reading/usage
   scenario; scan existing vocabulary (current terms, adjacent names, product phrases,
   file/module/API names, document headings, state names). Produce the surface name and mark
   it provisional.
2. **Top-of-head name** — before overfitting to existing wording, name the concept from first
   principles: the name you would pick to explain the concept cleanly to a new reader. It may
   disagree with existing vocabulary; that disagreement is useful evidence.
3. **Deep-read, then final name** — trace the call flow (caller, callee, adapter, storage,
   event, UI/API entry points); identify layer, caller, owner, lifecycle, neighboring
   concepts; choose one viewpoint anchor and note where a real boundary forces a perspective
   shift; decide which details must stay visible vs which are carried by local context. Write
   "This thing is…" and "It is not…". Ask a focused question only if a missing fact changes
   the naming direction.
4. **Propose 3-5 candidates** — include at least one aligned with existing vocabulary, at
   least one reflecting the clean conceptual model (even if it implies design cleanup), and at
   least one explicit non-shortened name when the concept crosses module/API/domain
   boundaries. Carry forward the research-stage and top-of-head names if still plausible.
   Avoid obscure synonyms; do not rank a candidate higher just because it is shorter.
5. **Recommend the final name** — explain the mental model it creates, what context it
   preserves for a cold reader, why it keeps the call flow in one perspective, how it differs
   from the research-stage and top-of-head names, and why the rejected names are weaker. If no
   name is satisfactory, recommend the design clarification needed first.

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

## Three-Stage Naming
| Stage | Name | Why this name appears |
|-------|------|-----------------------|
| 调研阶段的命名 / Research-stage naming | `<name>` | <surface context, existing vocabulary, neighboring terms> |
| 拍脑袋想出的命名 / Top-of-head naming | `<name>` | <first-principles intuition before deep reading> |
| 阅读完后的最终命名 / Final naming after reading | `<name>` | <evidence-backed final recommendation> |

## What Changed After Reading
<Why the final name stayed the same or changed after reading docs/code/call flow.>

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

---

## Mode 2: Review or rename existing names

Expanded steps:

1. Read the surrounding system, not only the declarations.
2. Build a small vocabulary map: core actors/entities; workflows and state transitions;
   calling and called modules in the relevant flow; layer-specific names for the same concept;
   overloaded or inconsistent terms.
3. For each important rename, show the three-stage naming path (research-stage from current
   vocabulary, top-of-head from the clean concept, final after reading the flow).
4. Flag names that harm understanding — they name the wrong actor/viewpoint; mix
   caller/callee/storage/UI/adapter viewpoints inside one flow; flatten different concepts into
   one word; are over-compressed; expose implementation details at a product/domain boundary;
   keep legacy vocabulary after the model changed; are too generic for their scope; or are
   locally consistent but globally misleading.
5. Suggest changes in priority order; prefer high-impact exported/API/domain names over small
   local variables.

```markdown
## Vocabulary Map
- <important concepts and current names>
- **Viewpoint anchor**: <chosen perspective for the reviewed naming set>
- **Call flow**: <important caller/callee/boundary sequence>

## Findings
### `oldName` -> `suggestedName`
- **Location**: <file:line>
- **Research-stage name**: `<name>` because <surface context>
- **Top-of-head name**: `<name>` because <first-principles intuition>
- **Final name after reading**: `<name>` because <deep-read evidence>
- **Problem**: <why this hurts the system model>
- **Better model**: <what the new name makes clear>
- **Viewpoint repair**: <how the suggested name restores a single perspective or marks a real boundary>
- **Information restored**: <what the current name compressed away>
- **Impact**: <rename scope and migration concern>

## Rename Plan, If Needed
- **Scope**: <files / API / docs / product copy the rename touches>
- **Compatibility**: <whether the old name is kept as an alias, and why>
- **Validation**: <grep, typecheck, contract check, doc update to confirm the rename is complete>

## Names To Avoid
- `<name>`: <the misleading or over-compressed meaning it would imply>
```

For a rename audit with many names, use this compact row shape instead of one block per name:

```markdown
| Current | Research-stage name | Top-of-head name | Final name after reading | Why final wins |
|---------|---------------------|------------------|--------------------------|----------------|
| `<old>` | `<name>` | `<name>` | `<name>` | <evidence from context, viewpoint, boundary, or call flow> |
```
