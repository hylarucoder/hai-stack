---
name: hai-ast-grep
description: |
  Produces a ready-to-run ast-grep pattern or YAML rule that structurally searches, lints, or auto-rewrites code via tree-sitter AST matching, validated against positive + negative fixtures. Trigger on ast-grep, sg scan, sgconfig, tree-sitter, AST matching, structural search-and-replace, codemod — and ALSO on these tasks unnamed: (1) structural search — "list every call site of X before I refactor", "find async functions that never await", or whenever grep/regex over/under-matches (hits comments/strings, misses formatting variants); (2) batch rewrite — "replace all console.log with logger", "rename this function everywhere", "change this signature at every call site", "migrate this API repo-wide"; (3) guard — "write a lint rule for this", "ban this usage in CI". Chinese triggers: 写 ast-grep 规则, 结构化搜索, 结构化搜索替换, 语法树匹配, 按语法找代码, 找出所有调用 X 的地方, 哪些地方用了这个 API, 重构前先找全调用点, grep 误报太多, 正则匹配不准, 批量改写代码, 批量重命名, 全局改函数签名, 改参数顺序, 升级旧 API, codemod, 写个 lint 规则, 禁止这种写法, 自动改写代码.
---

# hai-ast-grep

ast-grep uses tree-sitter to parse code into AST, enabling precise pattern matching. Reach for it whenever a search or refactor depends on syntax structure: one-off searches and rewrites run straight from the CLI, reusable lint/codemod rules are written in YAML. Either way the job is not "write a pattern" — it is to ship a pattern or rule validated against a positive AND a negative case, so it catches what it should and nothing it shouldn't.

## Project Configuration

Project-level batch scanning via `ast-grep scan` requires an `sgconfig.yml` config file; one-off pattern tests via `ast-grep run -p '<pattern>'` do not.

```yaml
# sgconfig.yml (project root)
ruleDirs:
  - rules          # rule directory; recursively loads all .yml files
```

Typical project structure:

```
my-project/
├── sgconfig.yml
├── rules/
│   ├── no-console.yml
│   └── custom/
│       └── team-rules.yml
└── src/
```

Run a project scan:

```bash
ast-grep scan              # auto-discovers sgconfig.yml
ast-grep scan --config path/to/sgconfig.yml  # explicit config
```

> **Note**: the `ast-grep scan` command requires `sgconfig.yml`, while `ast-grep run -p` works standalone.

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

1. **Explore** the pattern via CLI before writing YAML: `ast-grep -p 'console.log($ARG)' src/`. Inspect node types with `--debug-query ast` when the pattern won't match:
   ```bash
   ast-grep -p 'console.log($ARG)' --debug-query ast
   ```
2. **Write** the rule file (`.yml`) — start with the lint form (pattern + message + severity).
3. **Validate against a POSITIVE fixture** — code that should match: `ast-grep scan -r rule.yml fixtures/`. Confirm it matches.
4. **Validate against a NEGATIVE fixture** — code that looks similar but should NOT match. If it matches, you have a false positive: add `constraints`, `not`, `inside`, or `has` to narrow the rule, then re-run both fixtures.
5. **Add `fix:`** only if a mechanical rewrite is wanted, then dry-run before `--update-all`.
6. **Deliver** using the deliverable shape below (and `references/output-template.md`) — never hand back a bare YAML block.

## Essential Syntax

Cheat sheet for fast in-context lookup. Full syntax in [references/rule-syntax.md](references/rule-syntax.md#pattern-syntax).

| Element | Syntax | Example |
|---------|--------|---------|
| Single node | `$VAR` | `console.log($MSG)` |
| Multiple nodes | `$$$ARGS` | `fn($$$ARGS)` |
| Same content | Use same name | `$A == $A` |
| Non-capturing | `$_VAR` | `$_FN($_FN)` |
| Capture unnamed | `$$VAR` | `async function $$NAME() {}` |

## Core Rules Quick Reference

Cheat sheet. Full atomic / composite / relational rules in [references/rule-syntax.md](references/rule-syntax.md).

| Type | Purpose | Example |
|------|---------|---------|
| `pattern` | Match code structure | `pattern: if ($COND) {}` |
| `kind` | Match AST node type | `kind: function_declaration` |
| `all` | Match ALL conditions | `all: [pattern: X, kind: Y]` |
| `any` | Match ANY condition | `any: [pattern: var $A, pattern: let $A]` |
| `not` | Exclude matches | `not: {pattern: safe_call()}` |
| `has` | Must have child | `has: {kind: return_statement}` |
| `inside` | Must be in ancestor | `inside: {kind: class_body}` |

## Deliverable Shape

Hand back the rule in this shape — not a bare YAML block. These are the five headers from `references/output-template.md`; read that file for the full template before finalizing.

- **Goal** — what code pattern this finds or rewrites.
- **Rule** — the `.yml` (id, language, rule, message, severity).
- **Fix, if applicable** — the added `fix:` line.
- **Validation** — positive fixture (should match), negative fixture (should NOT match), the exact command run (`ast-grep scan --rule <file>` or `-r <file> src/`), and the result.
- **Notes** — false positives avoided (how), and known limits (cases intentionally not covered).

## Detailed References

**Complete syntax guide**: See [references/rule-syntax.md](references/rule-syntax.md)
- Atomic rules (pattern, kind, regex, nthChild, range)
- Composite rules (all, any, not, matches)
- Relational rules (has, inside, follows, precedes)
- Transform and fixConfig

**Language-specific patterns**: See [references/common-patterns.md](references/common-patterns.md)
- JavaScript/TypeScript examples
- Python examples
- Go and Rust examples

**Output template**: See [references/output-template.md](references/output-template.md) — the full, copy-pasteable version of the Deliverable Shape above (positive/negative fixtures, exact validation command, known-limits field).

## Supported Languages

Bash, C, Cpp, CSharp, Css, Elixir, Go, Haskell, Hcl, Html, Java, JavaScript, Json, Kotlin, Lua, Nix, Php, Python, Ruby, Rust, Scala, Solidity, Swift, Tsx, TypeScript, Yaml

## Use a Different Skill When

ast-grep is the right hammer only when the match depends on syntax structure — search, lint, or rewrite. Route elsewhere when:

- **Plain text or regex find-and-replace** with no syntax-tree shape (rename a string literal, swap a URL, find a unique identifier that grep already nails) — just use grep / a normal edit / `sed`; an AST pattern is overkill.
- **One-off edit in a single file** — edit it directly; a rule only pays off across many call sites.
- **Type-aware or semantic refactor** (driven by what a value's type is, not its syntax — e.g. eliminate `any`) — use `ts-type-safety-reviewer`. ast-grep matches syntax, not types.
- **Subjective code-quality review** ("is this clean / well-named / over-engineered", code smells) — use `clean-code-reviewer`; for a behavior-preserving cleanup pass use `code-simplifier`.
- **Pure formatting / whitespace / import order** — that is a formatter's job (Prettier, Biome, gofmt), not a structural rule.
