---
name: hai-ast-grep
description: |
  Produces a ready-to-run ast-grep command or reusable YAML lint/codemod rule, validated against positive and negative fixtures. Use when search or rewrite depends on syntax structure: finding all call shapes, avoiding regex matches in comments/strings, batch-changing signatures, or enforcing a structural rule（结构化搜索、批量改写、写 lint 规则）. Do not use for plain-text replacement or type-semantic refactors that require a compiler/type checker.
---

# hai-ast-grep

ast-grep uses tree-sitter to parse code into AST, enabling precise pattern matching. Reach for it whenever a search or refactor depends on syntax structure: one-off searches and rewrites run straight from the CLI, reusable lint/codemod rules are written in YAML. Either way the job is not "write a pattern" — it is to ship a pattern or rule validated against a positive AND a negative case, so it catches what it should and nothing it shouldn't.

## Project Configuration

One-off `ast-grep run` commands need no project config. Reusable project scans use `sgconfig.yml`
and rule directories; read `references/project-setup.md` only when creating or changing that setup.

## Everyday CLI Usage (no rule file)

Most day-to-day search and refactor work never needs YAML or sgconfig — `ast-grep run` (the default subcommand) does it directly:

```bash
# Search: every fetch call site, regardless of formatting
ast-grep run -p 'fetch($URL)' -l ts src/

# Search with context lines, or machine-readable output for a report
ast-grep run -p 'console.log($$$)' -C 2 src/
ast-grep run -p 'console.log($$$)' --json=stream src/

# One-off rewrite: review each match interactively (-i), or apply all (-U)
ast-grep run -p 'console.log($$$A)' -r 'logger.log($$$A)' -l ts -i src/
ast-grep run -p 'oldFn($A, $B)' -r 'newFn($B, $A)' -l ts -U src/
```

Flags that matter:

| Flag | Meaning |
|------|---------|
| `-p <pattern>` | the AST pattern to match |
| `-r <template>` | rewrite template — in `run`; in `scan`, `-r` means rule FILE, don't mix them up |
| `-l <lang>` | language (`ts`, `tsx`, `py`, `go`, `rs`…); inferred from file extensions when omitted |
| `-i` | interactive accept/reject per match — default this before any mass rewrite |
| `-U` | apply all rewrites; without it matches are only reported |
| `-C <n>` / `--json` | context lines / JSON output |

Deliver the pattern, the exact command, and a match summary. Escalate to a YAML rule only when the match needs `constraints` / `not` / `inside` narrowing, or will be re-run (CI guard, reusable codemod).

## Rule Workflow

### Lint Rule (most common)

Check-only, no fix — for CI / editor diagnostics:

```yaml
# rules/no-console-log.yml
id: no-console-log
language: JavaScript
severity: warning
message: Avoid console.log in production code
rule:
  pattern: console.log($$$ARGS)
```

Validate:

```bash
ast-grep scan -r rules/no-console-log.yml src/
```

### Rewrite Rule (optional)

To auto-fix, add ONE `fix:` line to the lint rule above — nothing else changes:

```yaml
# ... same rule as above, plus:
fix: logger.log($$$ARGS)
```

Apply the fix (note the `--update-all` flag — `scan` without it only reports):

```bash
ast-grep scan -r rules/no-console-log.yml --update-all src/
```

### Development Flow (canonical workflow — follow these steps)

1. **Explore** the pattern via CLI before writing YAML:
   `ast-grep run -p 'console.log($ARG)' src/`. Inspect node types with `--debug-query ast` when the pattern won't match:
   ```bash
   ast-grep run -p 'console.log($ARG)' --debug-query ast
   ```
2. **Write** the rule file (`.yml`) — start with the lint form (pattern + message + severity).
3. **Validate against a POSITIVE fixture** — code that should match: `ast-grep scan -r rule.yml fixtures/`. Confirm it matches.
4. **Validate against a NEGATIVE fixture** — code that looks similar but should NOT match. If it matches, you have a false positive: add `constraints`, `not`, `inside`, or `has` to narrow the rule, then re-run both fixtures.
5. **Add `fix:`** only if a mechanical rewrite is wanted, then dry-run before `--update-all`.
6. **Deliver** using the deliverable shape below (and `references/output-template.md`) — never hand back a bare YAML block.

## Syntax references

Use `$VAR` for one node and `$$$ARGS` for multiple nodes. For `kind`, `regex`, `all`, `any`, `not`,
`has`, `inside`, transforms, and fix configuration, read
[references/rule-syntax.md](references/rule-syntax.md). For language-specific starting points, read
[references/common-patterns.md](references/common-patterns.md).

## Deliverable Shape

Hand back the rule in this shape — not a bare YAML block. These are the five headers from `references/output-template.md`; read that file for the full template before finalizing.

- **Goal** — what code pattern this finds or rewrites.
- **Rule** — the `.yml` (id, language, rule, message, severity).
- **Fix, if applicable** — the added `fix:` line.
- **Validation** — positive fixture, negative fixture, exact `ast-grep run` or
  `ast-grep scan -r <rule-file>` command, and result.
- **Notes** — false positives avoided (how), and known limits (cases intentionally not covered).

The canonical delivery shape is `references/output-template.md`; do not invent a second schema.

## Use a Different Skill When

ast-grep is the right hammer only when the match depends on syntax structure — search, lint, or rewrite. Route elsewhere when:

- **Plain text or regex find-and-replace** with no syntax-tree shape (rename a string literal, swap a URL, find a unique identifier that grep already nails) — just use grep / a normal edit / `sed`; an AST pattern is overkill.
- **One-off edit in a single file** — edit it directly; a rule only pays off across many call sites.
- **Type-aware or semantic refactor** (driven by types rather than syntax) — use the compiler or an available type-safety workflow.
- **Subjective code-quality review** — use `clean-code-reviewer`; for implementation, use an available refactoring workflow.
- **Pure formatting / whitespace / import order** — that is a formatter's job (Prettier, Biome, gofmt), not a structural rule.
