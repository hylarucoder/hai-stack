# Plan Craft Output Template

Use this template when rewriting or improving a plan into coherent phases and verifiable todos.

```markdown
# Plan: <Goal-Oriented Title>

## Target Outcome
<What should be true when the plan succeeds.>

## Invariants
- <behavior, boundary, or contract that must remain true>

## Non-Goals
- <work intentionally excluded>

## Phases
### Phase 1: <reviewable slice>
- **Purpose**: <why this phase exists>
- **Exit proof**: <test/command/review/artifact/behavior>

Todos:
- [ ] <action>
  - **Surface**: <file/module/doc/API/UI>
  - **Proof**: <how to verify completion>
  - **Depends on**: <dependency or none>

### Phase 2: <next slice>
- **Purpose**: <why this phase exists>
- **Exit proof**: <proof>

Todos:
- [ ] <action with surface and proof>

## Validation
- <final validation command, review, trace, metric, or acceptance check>

## Risks
- <risk that could change ordering or scope>
```
