---
name: entity-model-auditor
description: |
  Audit entity data models by comparing PRD specifications against current codebase implementation.
  Produces a structured field-by-field review table that shows target design vs current state,
  with classification decisions and a migration change list.

  Use this skill when the user asks to: review a data model, audit entity fields against a PRD,
  check if backend fields match product spec, design a data model from a PRD,
  compare PRD fields with database schema, or when they mention
  "实体建模", "数据模型审核", "字段审查", "PRD 对齐", "模型设计".
  Also use when the user points at a PRD and says things like
  "check what's missing", "are the fields right", "review this entity".
---

# Entity Model Auditor

Given a PRD (product requirements document) and an optional codebase, produce a structured
data model audit for each entity. The audit answers: what fields should exist, where should
they live, what do we have now, and what needs to change.

## Workflow

### Step 1: Extract fields from the PRD

Read the PRD the user provides. For each entity mentioned, extract every field or attribute —
explicit or implied. Group them by the PRD's own sections if it has them.

If the user also points to codebase files (DB models, API types, schemas), read those too.
If no codebase is provided, the "current state" columns will be marked as unknown.

### Step 2: Apply the Five Cuts to each field

Every field goes through five classification questions, in order. Each cut narrows down
where and how the field should exist. The reasoning behind each cut matters more than
the answer — explain non-obvious decisions.

#### Cut 1 — Should this field exist at all?

A field earns its place only if it meets at least one condition:

| Condition | Test |
|-----------|------|
| System necessary | The backend cannot function without this value (e.g., a permission level that determines access control logic) |
| Non-redundant | The information it carries is not already covered by another field |
| User-perceptible | When the user changes this value, they can observe a difference in behavior or output |

If a field fails all three, it should be removed or merged into another field.
Flag it in the table as "existence questioned" with the reasoning.

Common patterns to watch for:
- Fields that look independent but are highly correlated (e.g., a "relationship" field and a "communication style" field that always move together)
- Numeric sliders with false precision (a 0-100 slider where the system only distinguishes 3 behaviors)
- Descriptive fields that could be absorbed into a free-text prompt field instead of existing as separate structured inputs

#### Cut 2 — Store or compute?

| If... | Then... |
|-------|---------|
| The value can be derived from other persisted data | Do not store. Compute at runtime. |
| The value is a pure function of other fields | Do not store. Compute when needed. |
| The value changes automatically based on system events, not user actions | Do not store. Derive from the source of truth. |
| None of the above | Store it. |

Runtime-computed fields still appear in the audit table, marked as "runtime" in the storage column.
Document the derivation rule (e.g., "status = derived from active task states in the task table").

Also watch for **storage vs presentation** splits: a field may store a raw value (like an
object storage key) but the API returns a transformed version (like a full URL). In this case,
the stored field and the API field are different things — name them accordingly
(e.g., `photoKey` in storage, `photoUrl` in API response).

#### Cut 3 — Table column or config blob?

For fields that should be stored, decide where:

| If... | Then... |
|-------|---------|
| You need to filter, sort, or query by this value | Table column |
| It's a user-facing "tuning knob" that doesn't affect queries | Config blob (jsonb / json) |

The benefit of config blob: adding a new field requires no database migration.
This matters a lot during intensive iteration periods.

Fields promoted to table columns should be ones the product actually filters on
(check the PRD's list/search/filter requirements), not ones that "might" be useful to query.

#### Cut 4 — System field or content field?

This only applies to fields stored in the config blob:

| Type | Definition | Implication |
|------|-----------|-------------|
| System field | Backend logic branches on this value (if/switch statements, query parameters, API behavior changes) | Validate against an enum. Backend must understand every possible value. |
| Content field | Flows into prompts, display, or descriptions without the backend interpreting it | Free text. No enum validation. Template/seed data provides initial values. |

Why this matters: system fields need code changes when you add a new option.
Content fields can get new options by updating template data alone.

#### Cut 5 — What form is the stored value?

For each stored field, clarify what exactly gets persisted:

| Pattern | Example |
|---------|---------|
| The stored value IS the display value | A "one-line description" field stores the actual text users see |
| The stored value is a key that maps to display text | `priority: "high"` → displayed as "紧急" or "High Priority" via i18n |
| The stored value is raw material, the API transforms it | `photoKey: "users/abc.png"` → API returns `photoUrl: "https://cdn.example.com/users/abc.png"` |
| The stored value is an input, a computed output is derived | `template` (stored) → `renderedContent` (computed by merging template with context data) |

Content fields sourced from templates typically store the actual display value,
not an abstract key — because the template IS the source of truth for what options exist.

### Step 3: Build the audit table

For each entity, produce a table with these columns:

| Column | What it answers |
|--------|----------------|
| **Target field** | What this field should be called in the ideal design |
| **Type** | Data type (string, int, enum, jsonb, etc.) |
| **Classification** | Where it belongs after the five cuts (table column / config / runtime / remove) |
| **Field nature** | System or content (for config fields only) |
| **Existence justification** | Why this field needs to exist (system necessary / non-redundant / user-perceptible), or "questioned" if dubious |
| **Current field** | What it's called in the current codebase, or "—" if it doesn't exist |
| **Current source** | Where it currently lives (DB column, config json, not implemented, etc.) |
| **Change** | What needs to happen (—, rename, new, move, remove, connect API) |

Group fields by logical section (identity, behavior, parameters, access control, etc.)
based on what makes sense for the entity. Use the PRD's own grouping as a starting point
but don't follow it blindly — regroup if the PRD's sections mix concerns.

### Step 4: Produce the change list

After the table, summarize all changes needed in a flat list grouped by change type:

- **Renames** — field X → field Y (list the full scope: DB migration, API, contract, frontend)
- **New fields** — fields to add, with default values
- **Removals** — fields to drop (moved to runtime / merged / unnecessary)
- **Moves** — fields changing storage location (column → config, config → runtime)
- **API gaps** — fields that exist in storage but have no update/read path through the API

### Step 5: Document runtime-computed fields

List all fields that are NOT stored but need to be available at the API or runtime level.
For each, document:
- The derivation rule (how to compute it)
- Where the source data lives
- When the computation happens (API response time? request execution time?)

### Step 6: List design decisions

For any non-obvious classification decision, write a one-row justification:

| Decision | Reasoning |
|----------|-----------|
| `summary` is a column, not config | Card list displays it directly; avoiding jsonb parse on every list query |
| `theme` moved from column to config | Not a query/filter dimension; keeping columns minimal |

## Output format

The final output is a single markdown document with these sections:

```
# [Entity Name] Data Model Audit

> Design principle: [one-line summary of the storage philosophy]

## 1. [Entity] Table
[Audit table for table-level fields]

## 2. Config Fields
[Audit table for config fields, grouped by logical section]

## 3. Runtime Fields
[List of computed/derived fields with derivation rules]

## 4. Related Entities
[Junction tables, version tables, etc.]

## 5. Change List
[Grouped by change type]

## 6. Design Decisions
[Non-obvious justifications]
```

## Principles to follow

- Start from the PRD, not the codebase. The PRD defines what SHOULD exist.
  The codebase shows what DOES exist. The delta is the work.
- Question every field's existence before deciding where to put it.
  A field that shouldn't exist doesn't need a storage decision.
- Prefer fewer table columns. Each column is a migration when you change it.
  Config blob fields are free to add/remove during iteration.
- Separate runtime state from persistent configuration.
  If a value changes automatically based on system events (not user actions), it's runtime.
- Name fields for what they ARE, not where they came from or how they're used.
  Store the raw form, not the presentation form (e.g., an object storage key, not a full URL).
- The audit table is both a specification AND a migration guide.
  Anyone reading it should know: what's the target, what's the current state, what's the work.
