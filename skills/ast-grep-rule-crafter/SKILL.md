---
name: ast-grep-rule-crafter
description: |
  Produces a ready-to-run ast-grep YAML rule that searches, lints, or auto-rewrites code via tree-sitter AST patterns, delivered with positive + negative fixtures and an exact validation command. Use for lint rules, codemods, code modernizations, and API migrations with auto-fix. Trigger whenever the user mentions ast-grep, sg scan, sgconfig, tree-sitter patterns, AST matching, structural search-and-replace, or a codemod — and ALSO when they describe the task without naming the tool, e.g. "find every call to X and rewrite it", "replace all console.log with logger across the repo", "write a lint rule for this pattern", "upgrade all usages of the old SDK", or "migrate this API everywhere". Chinese triggers: 写 ast-grep 规则, 结构化搜索替换, 批量改写代码, 代码迁移规则, codemod, 写个 lint 规则, 语法树匹配, 自动改写代码.
---

# ast-grep Rule Crafter

ast-grep uses tree-sitter to parse code into AST, enabling precise pattern matching. Rules are defined in YAML for linting, searching, and rewriting code. The job is not "write a pattern" — it is to ship a rule that has been validated against a positive AND a negative fixture, so it catches what it should and nothing it shouldn't.

## Project Configuration

项目级扫描需要 `sgconfig.yml` 配置文件：

```yaml
# sgconfig.yml (项目根目录)
ruleDirs:
  - rules          # 规则目录，递归加载所有 .yml 文件
```

典型项目结构：

```
my-project/
├── sgconfig.yml
├── rules/
│   ├── no-console.yml
│   └── custom/
│       └── team-rules.yml
└── src/
```

运行项目扫描：

```bash
ast-grep scan              # 自动查找 sgconfig.yml
ast-grep scan --config path/to/sgconfig.yml  # 指定配置
```

> **注意**: `ast-grep scan` 命令必须有 `sgconfig.yml`，而 `ast-grep run -p` 可单独使用。

## Rule Workflow

### Lint Rule (常见)

只检查不修复，用于 CI/编辑器提示：

```yaml
# rules/no-console-log.yml
id: no-console-log
language: JavaScript
severity: warning
message: Avoid console.log in production code
rule:
  pattern: console.log($$$ARGS)
```

验证：

```bash
ast-grep scan -r rules/no-console-log.yml src/
```

### Rewrite Rule (可选)

To auto-fix, add ONE `fix:` line to the lint rule above — nothing else changes:

```yaml
# ... same rule as above, plus:
fix: logger.log($$$ARGS)
```

Apply the fix (note the `--update-all` flag — `scan` without it only reports):

```bash
ast-grep scan -r rules/no-console-log.yml --update-all src/
```

### 开发流程 (canonical workflow — follow these steps)

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

ast-grep is the right hammer only for structural, AST-level pattern matching plus mechanical rewrite across many files. Route elsewhere when:

- **Plain text or regex find-and-replace** with no syntax-tree shape (rename a string literal, swap a URL) — just do a normal edit / `sed`; an AST rule is overkill.
- **One-off edit in a single file** — edit it directly; a rule only pays off across many call sites.
- **Type-aware or semantic refactor** (driven by what a value's type is, not its syntax — e.g. eliminate `any`) — use `ts-type-safety-reviewer`. ast-grep matches syntax, not types.
- **Subjective code-quality review** ("is this clean / well-named / over-engineered", code smells) — use `clean-code-reviewer`; for a behavior-preserving cleanup pass use `code-simplifier`.
- **Pure formatting / whitespace / import order** — that is a formatter's job (Prettier, Biome, gofmt), not a structural rule.
