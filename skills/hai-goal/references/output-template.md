# Hai Goal Output Template

Use this template to produce the goal document before execution starts. If the user provides an existing plan and a target, use the rewrite sections to show how the plan was re-anchored.

```markdown
# Goal Document: <work name>

## Go / No-Go
- **Judgment**: Go / No-Go / Go after decisions
- **Reason**: <why execution can or cannot start>

## Target Outcome
<What should be true when this work is complete.>

## Goal Definition
- **Type**: product / technical / operational / learning / quality / delivery
- **Boundary**: <what is included and excluded>
- **Non-goals**:
  - <nearby work intentionally excluded>
- **Deferred work**:
  - <related work not required for this goal>
- **Verification rule**: <how goal completion is proven>
- **Evidence source**: <test, metric, review, artifact, command, user signal, trace, behavior>
- **Pass criteria**: <clear pass/fail rule>
- **Confidence note**: <why this evidence is credible, or what proxy is being used>
- **Judgment owner**: <who or what is authorized to declare it done: system, test, metric, reviewer, user signal, or explicit acceptance>

## Current State
- <what exists now>
- <known constraints>
- <known risks>

## Plan Rewrite Notes
Use this section when rewriting an existing plan; omit it for a fresh goal document.

| Existing item | Decision | Reason |
|---------------|----------|--------|
| <phase/todo/focus point> | keep / reorder / merge / remove / rewrite | <how this serves or fails the target> |

## Drift Diagnosis
Use this section when rewriting an existing plan; omit it for a fresh goal document.

- **Goal drift**: <tasks that do not prove the target outcome>
- **Phase drift**: <phases grouped by topic rather than execution order or reviewable slices>
- **Validation drift**: <success stated as changed files instead of proven behavior>
- **Compatibility drift**: <aliases, shims, or dual paths without a named contract>
- **Cleanup drift**: <unrelated cleanup mixed into core work>

## Priority Rationale
- <why the new phase order is better for the target>
- <which risk, dependency, or leverage point should be handled first>

## Assumptions and Open Decisions
| Item | Status | Impact | Owner / Next step |
|------|--------|--------|-------------------|
| <assumption or decision> | assumed / unresolved / confirmed | <why it matters> | <how to resolve> |

## Progress Management (multi-phase or multi-session execution only; otherwise omit)
- **Update rule**: Check off a nested todo as soon as its proof is satisfied; check off a phase only after its exit proof passes.
- **Reprioritization rule**: Whenever a phase completes or this document is reopened for continued work, re-evaluate priority before continuing. If a cleaner, higher-leverage, or dependency-unblocked item can finish the goal sooner, move it earlier and record why.
- **Phase checklist**:
  - [ ] Phase 1: <phase name>
    - [ ] <proof-bearing nested todo>
    - [ ] <proof-bearing nested todo>
  - [ ] Phase 2: <phase name>
    - [ ] <proof-bearing nested todo>
    - [ ] <proof-bearing nested todo>

## Phases

### Phase 1: <phase name>
- **Purpose**: <why this phase exists>
- **Entry condition**: <what must be true before starting>
- **Phase rules**:
  - <allowed / not allowed / compatibility / doc sync / validation rule>
- **Todos**:
  - [ ] <action or small phase>
    - **Surface**: <doc/code/API/UI/test/etc.>
    - **Proof**: <test, command, review, artifact, trace, or behavior>
    - **Depends on**: <dependency or none>
    - **Sub-todos**:
      - [ ] <smaller action checked off when done>
      - [ ] <smaller action checked off when done>
- **Exit proof**: <how phase completion is verified>
- **Stop condition**: <what should pause execution>

### Phase 2: <phase name>
- **Purpose**: <why this phase exists>
- **Entry condition**: <condition>
- **Phase rules**:
  - <rule>
- **Todos**:
  - [ ] <action or small phase with surface, proof, depends-on, and optional sub-todos>
- **Exit proof**: <proof>
- **Stop condition**: <condition>

## Dry-Run Findings
- <missing prerequisite, dependency issue, vague todo, or validation gap found before execution>
- <priority or phase-order issue found while reworking the plan>

## Final Validation
- <final validation command, review, trace, metric, or acceptance check>

## First Execution Step
<The first concrete action after the goal document is accepted.>
```
