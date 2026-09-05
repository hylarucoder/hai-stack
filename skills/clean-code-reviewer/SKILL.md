---
name: clean-code-reviewer
description: Reviews file- and function-level code quality and returns severity-ranked, behavior-preserving refactor findings across naming, responsibility, duplication, unnecessary abstraction, constants, clarity, and project conventions. Use for code smells, maintainability checks, or “is this code clean?”. Prefer react-component-diagnosis for one React component and hai-architecture for module or system boundaries. This skill diagnoses; it does not apply refactors.
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
- Function length makes its responsibility or control flow hard to explain; line count is evidence,
  not a verdict
- A parameter list forces callers to remember several related values or their order; introduce a
  parameter object only when it creates a real concept
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
- Bare numbers or strings whose meaning is domain-specific or repeated
- Hardcoded strings, status codes, time constants

Do not flag universally obvious local values such as `0`, `1`, array indexes, or a one-off dimension
whose meaning is already clear from the expression.

```typescript
if (retryCount > 3) {}   // ❌  →  const MAX_RETRY_COUNT = 3; if (retryCount > MAX_RETRY_COUNT) {}  // ✅
```

### 6. Structural Clarity (Readability First)

Detection signals:
- Nested ternary operators
- Overly compact one-liners
- Conditional nesting that obscures the main path or forces unrelated conditions into one mental stack; prefer guard clauses when they clarify it

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

Emit a summary first, then P-numbered findings sorted by severity, followed by patterns worth
keeping and tests needed to refactor safely. Read
[references/output-template.md](references/output-template.md) before finalizing; it is the single
canonical report shape. Scale the number of findings to the scope instead of filling every category.

## References

- [references/output-template.md](references/output-template.md) — the full canonical report shape; read before finalizing output.
- [references/detailed-examples.md](references/detailed-examples.md) — full ❌/✅ worked cases for the 5 core dimensions (naming, functions, DRY, YAGNI, magic numbers); read when you need richer cases or are unsure a finding qualifies.
- [references/language-patterns.md](references/language-patterns.md) — language-specific smells for TypeScript/JavaScript, Python, and Go; consult when the codebase is primarily one of these languages.

## Use a different skill when

This skill reports file/function-level Clean Code findings and does not modify code. Route elsewhere when:

- **Architecture / module boundaries / abstraction quality** (system-level, APoSD) → `hai-architecture`.
- **Eliminating `any` / TypeScript type safety** → use an available type-safety skill or compiler workflow.
- **Actually applying the refactors** (not just reporting) → use an available implementation/refactoring workflow.
- **React component design** (consumer API, data flow, testability) → `react-component-diagnosis`.
