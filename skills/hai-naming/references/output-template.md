# Naming Output Template

Use this template for naming recommendations, naming audits, or rename proposals. Start from concept clarity before word choice.

```markdown
# Naming Recommendation: <concept or scope>

## Concept Diagnosis
- **Thing being named**: <entity/action/state/boundary>
- **Reader viewpoint**: <caller/user/domain/owner>
- **Information that must remain visible**: <actor, lifecycle, boundary, precision, domain role>

## Recommendation

### Best name: `<name>`
- **Why it works**: <how it preserves the concept>
- **Information preserved**: <details kept explicit>
- **Tradeoff**: <length, migration, team vocabulary concern>

### Alternatives
| Name | When it works | Why it loses |
|------|---------------|--------------|
| `<name>` | <context> | <weakness> |

## Rename Plan, If Needed
- **Scope**: <files/API/docs/product copy>
- **Compatibility**: <whether old name is kept and why>
- **Validation**: <grep, typecheck, contract check, doc update>

## Names To Avoid
- `<name>`: <misleading or compressed meaning>
```
