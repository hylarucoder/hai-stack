# 实体模型审计输出模板

用于对照 PRD、现有 schema 和代码实现输出字段级审计结果。

```markdown
# <Entity Name> Data Model Audit

> Design principle: <one-line storage philosophy>

## 1. Target Entity Model
| Field | Target meaning | Storage decision | Required? | Source |
|-------|----------------|------------------|-----------|--------|
| `<field>` | <PRD meaning> | table column / config / runtime / derived / remove | yes/no | <PRD/code ref> |

## 2. Current State
| Field | Current location | Current behavior | Gap |
|-------|------------------|------------------|-----|
| `<field>` | <table/config/code> | <observed behavior> | missing / extra / wrong type / wrong owner |

## 3. Field Decisions
### `<field>`
- **Decision**: keep / add / move / rename / remove
- **Reason**: <why this field exists or should not exist>
- **Migration**: <schema or data migration, if needed>

## 4. Runtime and Derived Fields
- `<field>`: <derivation rule and owner>

## 5. Change List
- **Schema**: <DDL or model changes>
- **API/types**: <contract changes>
- **UI/admin**: <surface changes>
- **Docs**: <documentation updates>

## 6. Open Questions
- <question that could change the model>
```
