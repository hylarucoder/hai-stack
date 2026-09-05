# ast-grep Rule Output Template

Use this template when delivering an ast-grep search or rewrite rule. Include enough validation detail that the rule can be trusted and rerun.

````markdown
# ast-grep Rule: <rule name>

## Goal
<What code pattern this rule should find or rewrite.>

## Rule

```yaml
id: <rule-id>
language: <language>
rule:
  pattern: <pattern>
message: <reader-facing message>
severity: warning
```

## Fix, If Applicable

```yaml
fix: <replacement>
```

## Validation
- **Positive fixture**: <code that should match>
- **Negative fixture**: <code that should not match>
- **Command run**: `ast-grep scan -r <rule-file> <target>`
- **Result**: <matches found / fixture behavior>

## Notes
- **False positives avoided**: <how>
- **Known limits**: <cases intentionally not covered>
````
