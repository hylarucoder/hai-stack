# ast-grep Project Setup

Use this only for reusable rules scanned through project configuration.

```yaml
# sgconfig.yml
ruleDirs:
  - rules
```

```text
my-project/
├── sgconfig.yml
├── rules/
│   ├── no-console.yml
│   └── custom/
│       └── team-rules.yml
└── src/
```

```bash
ast-grep scan
ast-grep scan --config path/to/sgconfig.yml
ast-grep scan -r rules/no-console.yml src/
```

`ast-grep scan` requires project configuration for rule discovery. A one-off
`ast-grep run -p '<pattern>'` command works without it.
