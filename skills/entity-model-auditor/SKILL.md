---
name: entity-model-auditor
description: |
  Audit and design entity data models into a field-by-field markdown report: a target-vs-current
  audit table per entity, a classification of every field (table column / config blob /
  runtime-computed / remove), a grouped migration change list, and design-decision justifications.

  Use this whenever the user reasons about what fields an entity should have or where they should
  live, even if they never say "audit": designing a data model, checking PRD fields against a DB
  schema, deciding store-vs-compute or column-vs-jsonb, spotting a bloated or over-modeled
  entity, or planning a schema migration. Trigger
  even when they just paste a PRD, schema, or Prisma/SQLAlchemy model and ask "are the fields
  right", "what's missing", "should this be a column or jsonb", "is this field even needed". Also
  on 实体建模, 数据模型审核, 字段审查, 字段太多了, 这个表设计得对吗, PRD 对齐, 模型设计,
  该存还是该算, 列还是配置, 帮我看下这个模型.
---

# Entity Model Auditor

Given a PRD (product requirements document) and an optional codebase, produce a structured
data model audit for each entity. The audit answers: what fields should exist, where should
they live, what do we have now, and what needs to change.

Two stances run through the whole process:

- **Start from the PRD, not the codebase.** The PRD defines what should exist; the codebase
  shows what does exist. The delta between them is the work.
- **Every storage classification is really a "cost to change later" judgment.** A table column
  costs a schema migration to change; a config blob field is free to add or remove; a system
  field costs a code change; a content field changes by editing data alone. Cuts 3, 4, and 5
  are all pricing this same question — what does it cost to change this field after ship — so
  reason from that one idea instead of memorizing three separate tables.

The final artifact is both a specification (the target design) and a migration guide (the work
to get there). Anyone reading it should know the target, the current state, and the change.

## Output shape

The whole workflow fills in this one document. Build the sections in order; each step below
produces a named slot.

```
# [Entity Name] Data Model Audit

> Design principle: [one-line summary of the storage philosophy]

## 1. [Entity] Table        — audit table for table-level fields
## 2. Config Fields         — audit table for config fields, grouped by logical section
## 3. Runtime Fields        — computed/derived fields with derivation rules
## 4. Related Entities      — junction tables, version tables, etc.
## 5. Change List           — grouped by change type
## 6. Design Decisions      — non-obvious justifications
```

Sections 1 and 2 use the 8-column audit table defined in Step 3. Read
`references/output-template.md` for a fill-in-the-blanks instance of this exact shape before
finalizing.

## Workflow

### Step 1: Extract fields from the PRD

Read the PRD the user provides. For each entity mentioned, extract every field or attribute —
explicit or implied. Group them by the PRD's own sections if it has them.

If the user also points to codebase files (DB models, API types, schemas), read those too.
If no codebase is provided, the "current state" columns will be marked as unknown.

### Step 2: Apply the Five Cuts to each field

Every field goes through five classification questions, in order. Each cut narrows down
where and how the field should exist. Explain non-obvious decisions in the table rather than
just recording the answer.

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

The benefit of config blob: adding a new field requires no database migration (config avoids a
migration per change — the cost-to-change lens from the intro).

Fields promoted to table columns should be ones the product actually filters on
(check the PRD's list/search/filter requirements), not ones that "might" be useful to query.

#### Cut 4 — System field or content field?

This only applies to fields stored in the config blob:

| Type | Definition | Implication |
|------|-----------|-------------|
| System field | Backend logic branches on this value (if/switch statements, query parameters, API behavior changes) | Validate against an enum. Backend must understand every possible value. |
| Content field | Flows into prompts, display, or descriptions without the backend interpreting it | Free text. No enum validation. Template/seed data provides initial values. |

Why this matters (same cost-to-change lens): a system field costs a code change every time you
add an option, because the backend branches on it; a content field gets new options by updating
template data alone. Cuts 3, 4, and 5 are all pricing the same thing — Cut 3 prices a schema
migration, Cut 4 prices a code change, Cut 5 prices a data/transform change.

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

### Step 3: Build the audit table (fills sections 1 and 2)

For each entity, produce a table with these 8 columns. This is the canonical audit table used
by both **section 1 (table-level fields)** and **section 2 (config fields)** of the output —
split the rows between the two sections by their Classification.

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

Assemble the six sections from the "Output shape" skeleton at the top of this file: sections 1
and 2 hold the 8-column audit table (split by Classification), section 3 the runtime fields,
section 4 related entities, section 5 the change list, section 6 the design decisions. Before
finalizing, read `references/output-template.md` — it is a fill-in-the-blanks instance of exactly
that shape, with the same section headings and the same column set.

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
