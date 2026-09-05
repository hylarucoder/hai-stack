---
name: entity-model-auditor
description: |
  Audits an entity model field by field: what should exist, what exists now, where each value belongs (column, config, computed runtime value, or removal), and what must migrate. Use when comparing a PRD with a schema/model, designing entity fields, or deciding “store or compute?”, “column or JSON?”, or “does this field belong at all?”. Use hai-prd first when the product intent is still unsettled.
---

# Entity Model Auditor

Given a PRD (product requirements document) and an optional codebase, produce a structured
data model audit for each entity. The audit answers: what fields should exist, where should
they live, what do we have now, and what needs to change.

Two stances run through the whole process:

- **Establish the target truth source.** A settled PRD can define intended behavior, while code,
  schemas, and migrations define the current implementation. If they disagree, report the delta;
  do not silently assume either side is authoritative for every decision.
- **Price the full lifecycle.** Storage choices affect queryability, integrity, migration, API
  compatibility, ownership, and operational debugging. JSON/config usually lowers schema-change
  cost, but it is never "free" when validation, consumers, or persisted data must evolve.

The final artifact is both a specification (the target design) and a migration guide (the work
to get there). Anyone reading it should know the target, the current state, and the change.

## Output shape

Produce one audit document per entity: target/current field tables, computed fields, related
entities, a grouped change list, and non-obvious design decisions. The canonical section and column
shape is in `references/output-template.md`; read it before finalizing.

## Workflow

### Step 1: Extract fields from the PRD

Read the PRD the user provides. For each entity mentioned, extract every field or attribute —
explicit or implied. Group them by the PRD's own sections if it has them.

If the user also points to codebase files (DB models, API types, schemas), read those too.
If no codebase is provided, the "current state" columns will be marked as unknown.

### Step 2: Apply the Five Cuts to each field

Every field goes through five questions in order:

1. What current goal, invariant, contract, audit need, or observable behavior proves it should exist?
2. Can it be derived from durable authoritative data, or must it be persisted?
3. If persisted, does it belong in a column, cohesive config object, or related entity?
4. Does backend behavior interpret it, or is it content carried through unchanged?
5. What exact form is stored versus returned or displayed?

Read `references/field-classification.md` before making these decisions. Explain non-obvious
classifications and mark unresolved authority or derivation as undecided rather than guessing.

### Step 3: Build the audit table (fills sections 1 and 2)

For each entity, fill the canonical eight-column table in `references/output-template.md`, split
between table-level and config fields by classification.

Group fields by logical section (identity, behavior, parameters, access control, etc.)
based on what makes sense for the entity. Use the PRD's own grouping as a starting point
but don't follow it blindly — regroup if the PRD's sections mix concerns.

### Step 4: Produce the change list (fills section 5)

After the table, summarize all changes needed in a flat list grouped by change type:

- **Renames** — field X → field Y (list the full scope: DB migration, API, contract, frontend)
- **New fields** — fields to add, with default values
- **Removals** — fields to drop (moved to runtime / merged / unnecessary)
- **Moves** — fields changing storage location (column → config, config → runtime)
- **API gaps** — fields that exist in storage but have no update/read path through the API

### Step 5: Document runtime-computed fields (fills section 3)

List all fields that are not stored but need to be available at the API or runtime level.
For each, document:
- The derivation rule (how to compute it)
- Where the source data lives
- When the computation happens (API response time? request execution time?)

Junction tables, version tables, and other related entities go in **section 4** — apply the same
five cuts to each related entity's fields.

### Step 6: List design decisions (fills section 6)

For any non-obvious classification decision, write a one-row justification:

| Decision | Reasoning |
|----------|-----------|
| `summary` is a column, not config | Card list displays it directly; avoiding jsonb parse on every list query |
| `theme` moved from column to config | Not a query/filter dimension; keeping columns minimal |

## Output

Fill the canonical `references/output-template.md`; do not reproduce a second schema here. Keep
unknown current-state values explicit and distinguish verified evidence from design recommendations.

Two ordering rules to keep the result honest:

- Question every field's existence (Cut 1) before deciding where to put it. A field that
  shouldn't exist doesn't need a storage decision.
- Name each field for what it is, not where it came from or how it's used — and surface the
  stored form, not the presentation form (an object storage key, not a full URL). For deeper
  naming disputes, hand off to hai-naming.

## When to hand off

This skill assumes the PRD is roughly settled and focuses on field placement and the
storage/migration delta. Route elsewhere when the real problem is upstream:

- **hai-naming** — the dispute is purely what to call a field/concept, not where it should live.
- **hai-prd** — the PRD itself is the problem: scope is wrong, requirements conflict, or the
  fields are undecided because the product intent is undecided. Fix the PRD first, then audit.
- **clean-code-reviewer / react-component-diagnosis** — the user wants general code-quality or
  component-design review, not a field-level data-model audit.
