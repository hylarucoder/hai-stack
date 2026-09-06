## Core Principle: Behavior Preservation

In maintainability-only mode, suggest behavior-preserving changes. A discovered correctness defect may be reported separately; it must not be smuggled into a cleanup.

## Check Dimensions

These are the detection signals and thresholds — the load-bearing decision criteria. Full ❌/✅ worked examples for dimensions 1–5 live in [references/detailed-examples.md](references/detailed-examples.md); read it when you need richer cases or are unsure a finding qualifies.

### 1. Naming Problems (Meaningful Names)

Detection signals:
- Meaningless names like `data1`, `temp`, `result`, `info`, `obj`
- Multiple names for the same concept (mixing `get`/`fetch`/`retrieve`)
- Boolean names whose meaning is ambiguous in their actual usage; prefixes are not mandatory

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
- Interfaces whose callers learn no less than from the concrete implementation; one implementation alone is not evidence
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
