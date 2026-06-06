---
name: clean-code-reviewer
description: Produces a severity-rated (高/中/低) Clean Code findings report across 7 dimensions (naming, function size/SRP, duplication/DRY, over-engineering/YAGNI, magic numbers, structural clarity, project conventions), each with a location and a behavior-preserving refactor suggestion — never changing functionality. Use whenever the user asks for a code review, quality check, refactor advice, or code-smell / Clean Code analysis, OR points at a file/function/diff and asks if it is well-written, too long, too repetitive, over-engineered, or poorly named — even casually, and even if they never say "review" ("I just wrote this, look it over", "does this look good before I commit"). Trigger on 代码体检, 代码质量, 重构检查, 代码审查, 这段代码写得怎么样, 帮我看看代码有没有问题, 有没有坏味道, 这函数是不是太长了, 命名规范吗, 魔法数字, 重复代码, 过度设计, and English like "is this code clean", "any code smells", "check this file".
---

# Clean Code Review

基于《代码整洁之道》原则，聚焦 7 个高收益检查维度。

## Review Workflow

```
Review Progress:
- [ ] 1. Scan codebase: identify files to review (default to recently changed code if scope is unspecified)
- [ ] 2. Check each dimension (naming, functions, DRY, YAGNI, magic numbers, clarity, conventions)
- [ ] 3. Rate severity (高/中/低) for each issue
- [ ] 4. Generate report sorted by severity (highest first)
```

Severity reflects maintainability impact, so the report leads with what to fix first. Prefer the few highest-leverage findings over an exhaustive list of 低 smells — a signal-dense report the human acts on beats a long one they ignore.

When the codebase is primarily Python or Go, consult [references/language-patterns.md](references/language-patterns.md) for language-specific smells before finalizing.

## 核心原则：功能保留

所有建议仅针对**实现方式**优化——绝不建议改变代码的功能、输出或行为。

## Check Dimensions

These are the detection signals and thresholds — the load-bearing decision criteria. Full ❌/✅ worked examples for dimensions 1–5 live in [references/detailed-examples.md](references/detailed-examples.md); read it when you need richer cases or are unsure a finding qualifies.

### 1. 命名问题【有意义的命名】

检查标志：
- `data1`, `temp`, `result`, `info`, `obj` 等无意义命名
- 同一概念多种命名（`get`/`fetch`/`retrieve` 混用）
- 布尔值缺少 `is`/`has`/`can`/`should` 前缀

```typescript
const data1 = fetchUser();   // ❌  →  const userProfile = fetchUser();  // ✅
```

### 2. 函数问题【函数短小 + SRP】

检查标志：
- 函数超过 **100 行**
- 参数超过 **3 个**（改用参数对象）
- 函数做多件事（违反单一职责）
- 函数名暗示只读却有副作用

### 3. 重复问题【DRY】

检查标志：
- 相似的 if-else 结构
- 相似的数据转换/错误处理逻辑
- Copy-paste 痕迹

### 4. 过度设计【YAGNI】

检查标志：
- 从未为 true 的 `if (config.legacyMode)` 分支（死代码）
- 只有一个实现的接口
- 过度防御 / 无用的 try-catch 或 if-else

### 5. 魔法数字【避免硬编码】

检查标志：
- 裸露数字无解释（`retryCount > 3`、`setTimeout(fn, 86400000)`）
- 硬编码字符串、状态码、时间常量

```typescript
if (retryCount > 3) {}   // ❌  →  const MAX_RETRY_COUNT = 3; if (retryCount > MAX_RETRY_COUNT) {}  // ✅
```

### 6. 结构清晰度【可读性优先】

检查标志：
- 嵌套三元运算符
- 过度紧凑的单行代码
- 过深的条件嵌套（**> 3 层**）——优先用 guard clauses 早返回

### 7. 项目规范【一致性】

检查标志：
- import 顺序混乱（外部库 vs 内部模块）
- 函数声明风格不一致
- 命名规范不统一（camelCase vs snake_case 混用）

> [!TIP]
> 项目规范应参照 `CLAUDE.md` `AGENTS.md` 或项目约定的编码标准。

## Severity Levels

| 级别 | 标准 |
|------|------|
| 高 | 影响可维护性/可读性，应立即修复 |
| 中 | 有改进空间，建议修复 |
| 低 | 代码气味，可选优化 |

## Output Format

Emit a Summary first, then P-numbered findings sorted by severity, then patterns worth keeping and any tests needed to refactor safely. Skeleton (read [references/output-template.md](references/output-template.md) before finalizing — it is the full, canonical shape):

```markdown
# Clean Code Review: <scope>

## Summary
<最高杠杆的可维护性风险，一段话>

## Findings

### P1: <问题简述>
- **原则**: <命名 / 单一职责 / DRY / YAGNI / 魔法数字 / 结构清晰度 / 项目规范>
- **位置**: `文件:行号`
- **级别**: 高 / 中 / 低
- **问题**: <为什么让代码更难读、改、测>
- **建议**: <保留行为的重构方向>
- **Why now**: <不改的风险>

## Good Patterns To Keep
- <值得保留的实现选择>

## Test Gaps
- <重构期间为保护行为所需的测试>
```

## References

- [references/output-template.md](references/output-template.md) — the full canonical report shape; read before finalizing output.
- [references/detailed-examples.md](references/detailed-examples.md) — full ❌/✅ worked cases for the 5 core dimensions (命名、函数、DRY、YAGNI、魔法数字); read when you need richer cases or are unsure a finding qualifies.
- [references/language-patterns.md](references/language-patterns.md) — TypeScript/JavaScript、Python、Go 各自的语言特定坏味道; consult when the codebase is primarily one of these languages.

## Multi-Agent Parallel

When parallelizing across subagents, split the work along one axis, then dedupe and reconcile severity ratings when merging:

1. **按检查维度** — 7 维度各一个 agent
2. **按模块/目录** — 不同模块各一个 agent
3. **按语言** — TypeScript、Python、Go 各一个 agent
4. **按文件类型** — 组件、hooks、工具函数、类型定义

## Use a different skill when

This skill reports file/function-level Clean Code findings and does not modify code. Route elsewhere when:

- **Architecture / module boundaries / abstraction quality** (system-level, APoSD) → `hai-architecture`.
- **Eliminating `any` / TypeScript type safety** → `ts-type-safety-reviewer`.
- **Actually applying the refactors** (not just reporting) → `code-simplifier`.
- **React component design** (使用者 API、数据流、可测试性) → `component-diagnosis` / `react-component-diagnosis`.
