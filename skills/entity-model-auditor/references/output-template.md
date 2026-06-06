# 实体模型审计输出模板

Fill-in-the-blanks instance of the canonical audit report. Sections, column names, and order
match the "Output shape" skeleton and the Step 3 audit table in `SKILL.md` exactly — do not
invent different columns. Copy this, then replace every `<...>` placeholder.

```markdown
# <Entity Name> Data Model Audit

> Design principle: <one-line summary of the storage philosophy>

## 1. <Entity> Table

Table-level fields (Classification = table column). 8-column audit table:

| Target field | Type | Classification | Field nature | Existence justification | Current field | Current source | Change |
|--------------|------|----------------|--------------|-------------------------|---------------|----------------|--------|
| `<field>` | string/int/enum/jsonb | table column | — | system necessary / non-redundant / user-perceptible / questioned | `<current>` or — | DB column / not implemented | — / rename / new / move / remove / connect API |

## 2. Config Fields

Config-blob fields (Classification = config), grouped by logical section. Same 8 columns:

### <logical section, e.g. behavior / parameters>

| Target field | Type | Classification | Field nature | Existence justification | Current field | Current source | Change |
|--------------|------|----------------|--------------|-------------------------|---------------|----------------|--------|
| `<field>` | string/int/enum | config | system / content | <justification> | `<current>` or — | config json / not implemented | — / rename / new / move / remove |

## 3. Runtime Fields

Fields not stored, computed at API or runtime level:

- `<field>`: <derivation rule> | source: <where source data lives> | computed: <API response time / request execution time>

## 4. Related Entities

Junction tables, version tables, etc. Apply the same five cuts; reuse the 8-column table per entity:

| Target field | Type | Classification | Field nature | Existence justification | Current field | Current source | Change |
|--------------|------|----------------|--------------|-------------------------|---------------|----------------|--------|
| `<field>` | <type> | <classification> | <nature> | <justification> | `<current>` or — | <source> | <change> |

## 5. Change List

Grouped by change type:

- **Renames**: `<X>` → `<Y>` (scope: DB migration, API, contract, frontend)
- **New fields**: `<field>` (default: `<value>`)
- **Removals**: `<field>` (moved to runtime / merged / unnecessary)
- **Moves**: `<field>` (column → config / config → runtime)
- **API gaps**: `<field>` (in storage, no update/read path through API)

## 6. Design Decisions

Non-obvious classification justifications:

| Decision | Reasoning |
|----------|-----------|
| `<field>` is a column, not config | <why> |
| `<field>` moved from column to config | <why> |
```
