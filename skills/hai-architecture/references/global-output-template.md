# Global Architecture Audit Output Template

```markdown
# Complexity Audit: <scope>

## Verdict
<complexity center and highest-leverage move>

## System Map
<topology -> entrypoints -> core chains -> state/config/effects/tests>

## Evidence Reviewed
<files, manifests, configs, tests, docs, and searches actually read or run>

## Core Call Chains
1. `<entrypoint> -> <owner> -> <state/effect> -> <test>`

## Complexity Center
<where change amplification, cognitive load, or unknown unknowns concentrate>

## Findings
### P1: <finding> — Cost: S/M/L
- **Impact**: <what becomes harder or riskier>
- **Evidence**: <file:line plus traced path>
- **Cause**: <underlying force>
- **Conservative option**: <small useful repair>
- **Cleaner option**: <stronger ownership/boundary move>
- **Recommendation**: <choice and why>
- **Verification**: <proof and tests>

## What To Preserve
<existing boundaries, tests, or conventions that reduce complexity>

## Change Order
1. <first proof-producing move>
2. <next move after proof>
3. Stop or reframe if <signal>.
```
