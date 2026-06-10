---
name: clean-code-reviewer
description: Produces a severity-rated (高/中/低) Clean Code findings report across 7 dimensions (naming, function size/SRP, duplication/DRY, over-engineering/YAGNI, magic numbers, structural clarity, project conventions), each with a location and a behavior-preserving refactor suggestion — never changing functionality. Use whenever the user asks for a code review, quality check, refactor advice, or code-smell / Clean Code analysis, OR points at a file/function/diff and asks if it is well-written, too long, too repetitive, over-engineered, or poorly named — even casually, and even if they never say "review" ("I just wrote this, look it over", "does this look good before I commit"). Trigger on 代码体检, 代码质量, 重构检查, 代码审查, 这段代码写得怎么样, 帮我看看代码有没有问题, 有没有坏味道, 这函数是不是太长了, 命名规范吗, 魔法数字, 重复代码, 过度设计, and English like "is this code clean", "any code smells", "check this file".
---

# Clean Code Review

Grounded in the principles of *Clean Code* (Robert C. Martin), focused on 7 high-leverage check dimensions.

## Workflow

```
Review Progress:
- [ ] 1. Scan codebase: identify files to review (default to recently changed code if scope is unspecified)
- [ ] 2. Check each dimension (naming, functions, DRY, YAGNI, magic numbers, clarity, conventions)
- [ ] 3. Rate severity (高/中/低) for each issue
- [ ] 4. Generate report sorted by severity (highest first)
```

Severity reflects maintainability impact, so the report leads with what to fix first. Prefer the few highest-leverage findings over an exhaustive list of 低 smells — a signal-dense report the human acts on beats a long one they ignore.

When the codebase is primarily Python or Go, consult [references/language-patterns.md](references/language-patterns.md) for language-specific smells before finalizing.

## Core Principle: Behavior Preservation

Every suggestion targets only **how the code is implemented** — never suggest changing the code's functionality, output, or behavior.

## Check Dimensions

These are the detection signals and thresholds — the load-bearing decision criteria. Full ❌/✅ worked examples for dimensions 1–5 live in [references/detailed-examples.md](references/detailed-examples.md); read it when you need richer cases or are unsure a finding qualifies.

### 1. Naming Problems (Meaningful Names)

Detection signals:
- Meaningless names like `data1`, `temp`, `result`, `info`, `obj`
- Multiple names for the same concept (mixing `get`/`fetch`/`retrieve`)
- Booleans missing an `is`/`has`/`can`/`should` prefix

```typescript
const data1 = fetchUser();   // ❌  →  const userProfile = fetchUser();  // ✅
```

### 2. Function Problems (Small Functions + SRP)

Detection signals:
- Function exceeds **100 lines**
- More than **3 parameters** (use a parameter object instead)
- Function does multiple things (violates Single Responsibility)
- Function name implies read-only but it has side effects

### 3. Duplication (DRY)

Detection signals:
- Similar if-else structures
- Similar data-transformation / error-handling logic
- Copy-paste traces

### 4. Over-Engineering (YAGNI)

Detection signals:
- `if (config.legacyMode)` branches that are never true (dead code)
- Interfaces with only one implementation
- Over-defensive / useless try-catch or if-else

### 5. Magic Numbers (Avoid Hardcoding)

Detection signals:
- Bare numbers with no explanation (`retryCount > 3`, `setTimeout(fn, 86400000)`)
- Hardcoded strings, status codes, time constants

```typescript
if (retryCount > 3) {}   // ❌  →  const MAX_RETRY_COUNT = 3; if (retryCount > MAX_RETRY_COUNT) {}  // ✅
```

### 6. Structural Clarity (Readability First)

Detection signals:
- Nested ternary operators
- Overly compact one-liners
- Deep conditional nesting (**> 3 levels**) — prefer guard clauses with early returns

### 7. Project Conventions (Consistency)

Detection signals:
- Disordered import order (external libraries vs internal modules)
- Inconsistent function declaration style
- Inconsistent naming conventions (mixing camelCase and snake_case)

> [!TIP]
> Source project conventions from the project root `CLAUDE.md` / `AGENTS.md`, plus linter configs (`.eslintrc`, `.prettierrc`, ruff/flake8 config).

## Severity Levels

Use 高 / 中 / 低 as the literal severity labels in the report — they are part of the output contract.

| Level | Criteria |
|------|------|
| 高 (High) | Hurts maintainability/readability; fix immediately |
| 中 (Medium) | Room for improvement; fix recommended |
| 低 (Low) | Code smell; optional optimization |

## Output

Emit a Summary first, then P-numbered findings sorted by severity, then patterns worth keeping and any tests needed to refactor safely. Skeleton (read [references/output-template.md](references/output-template.md) before finalizing — it is the full, canonical shape):

```markdown
# Clean Code Review: <scope>

## Summary
<the highest-leverage maintainability risk, one paragraph>

## Findings

### P1: <issue title>
- **原则**: <命名 / 单一职责 / DRY / YAGNI / 魔法数字 / 结构清晰度 / 项目规范>
- **位置**: `<file>:<line>`
- **级别**: 高 / 中 / 低
- **问题**: <what makes the code harder to read, change, or test>
- **建议**: <behavior-preserving refactor direction>
- **Why now**: <risk if left as-is>

## Good Patterns To Keep
- <implementation choice worth preserving>

## Test Gaps
- <tests needed to protect behavior during the refactor>
```

## References

- [references/output-template.md](references/output-template.md) — the full canonical report shape; read before finalizing output.
- [references/detailed-examples.md](references/detailed-examples.md) — full ❌/✅ worked cases for the 5 core dimensions (naming, functions, DRY, YAGNI, magic numbers); read when you need richer cases or are unsure a finding qualifies.
- [references/language-patterns.md](references/language-patterns.md) — language-specific smells for TypeScript/JavaScript, Python, and Go; consult when the codebase is primarily one of these languages.

## Multi-Agent Parallel

When parallelizing across subagents, split the work along one axis, then dedupe and reconcile severity ratings when merging:

1. **By check dimension** — one agent per dimension (7 total)
2. **By module/directory** — one agent per module
3. **By language** — one agent each for TypeScript, Python, Go
4. **By file type** — components, hooks, utility functions, type definitions

## Use a different skill when

This skill reports file/function-level Clean Code findings and does not modify code. Route elsewhere when:

- **Architecture / module boundaries / abstraction quality** (system-level, APoSD) → `hai-architecture`.
- **Eliminating `any` / TypeScript type safety** → `ts-type-safety-reviewer`.
- **Actually applying the refactors** (not just reporting) → `code-simplifier`.
- **React component design** (consumer API, data flow, testability) → `component-diagnosis` / `react-component-diagnosis`.
