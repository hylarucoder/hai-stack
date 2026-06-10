---
name: react-component-diagnosis
description: |
  Produces a structured diagnosis report on one React component's design: a 7-dimension scorecard
  (consumer API, data flow, testability, extensibility, performance, mental model, boundaries &
  contracts — each scored 1-5 with code evidence), design highlights, and P0/P1/P2 recommendations
  with effort estimates, every score grounded in line-by-line reading. Be pushy: trigger whenever
  the user points at a component directory or .tsx file and asks about its design, quality,
  props/API, or re-render behavior, even casually — 组件诊断, 组件体检, 架构审查, 设计分析, 组件评审,
  组件 API, props 设计, 组件要不要重构, "这个组件设计得怎么样", "帮我看看这个组件", "为什么每次都
  re-render", "useEffect 写对了吗", "props 设计合理吗", "review this React component", "is this
  component well designed", "audit this component", "should I refactor this component".
---

# React Component Architecture Diagnosis

## Overview

Run a deep health check on a single React component across 7 dimensions and output a structured diagnosis report.

## Workflow

```
1. Locate the component → read ALL source files (including subdirectories). Real defects often
   hide in sub-files (hooks/utils); skipping any file means missing them
2. Summarize the responsibility → state in one sentence what the component does
3. Score each dimension → answer the core question + score + find code evidence
4. Cross-check → revisit every dimension and fill in missed concrete issues
5. Apply the template → scorecard + highlights + recommendations
```

One principle runs through the whole flow: **report only problems that can be found by reading code line by line, never surface-level structural judgments a directory scan would produce.** The full set of principles is in "Diagnosis Principles" at the end.

## The Seven Dimensions

Each dimension answers one core question, scored 1-5:

| Score | Meaning |
|-------|---------|
| 5 | Textbook-level; can serve as the team benchmark |
| 4 | Solid; minor flaws that don't affect the big picture |
| 3 | Passing; usable but with clear room for improvement |
| 2 | Prominent problems; will slow development or plant traps |
| 1 | Needs a rewrite or major refactor |

Base every score on concrete code evidence, not gut feel. Deduct for a given problem in the single most relevant dimension only — double-counting skews the overall score and makes one root cause look like several independent problems.

### 1. Consumer API

**Core question: can callers do the right thing with the least cognitive load?**

Inspection points:
- **Minimal working example**: how many props must be passed to get it running? More than 3 required props is a warning sign
- **Default coverage**: can 80% of use cases run with zero configuration? Check for sensible defaultProps or parameter defaults
- **Self-documenting types**: do props type names make sense at a glance? Is there a distinction between "input types" (loose) and "internal types" (strict)?
- **Error guidance**: when a wrong argument is passed, does the error message point toward the fix, or does it just throw a TypeScript type error?
- **API consistency**: is the naming style uniform? Are callbacks `onXxx` or `handleXxx`? Is there a clear pattern for state props vs. control props?

```
High-score signals:
- Preset/factory functions simplify common configurations
- The props interface has JSDoc without being verbose
- Estimate/utility functions are exported so callers can do calculations

Low-score signals:
- More than 5 required props
- Boolean props with double negatives (noDisableX)
- Multiple ways to configure the same concept, with no docs on which to pick
```

### 2. Data Flow

**Core question: from props to render output, is the transformation chain clear, unidirectional, and traceable?**

Inspection points:
- **Transformation layers**: how many layers of transformation does the data pass through? Are the input/output types of each layer explicit?
- **Unidirectionality**: do reverse callbacks mutate upstream data? Is there implicit two-way binding?
- **Side-effect isolation**: are pure computation and side effects (API calls, DOM operations, timers) separated?
- **Intermediate products**: is the data mid-transformation serializable and console.log-debuggable?
- **State placement**: is state at the right level? Any unnecessary lifting or sinking?

```
High-score signals:
- Pure computation extracted into standalone functions/files, with no React dependency
- Data transformation reads like a pipeline: A → B → C → render, each step with explicit types
- useEffect handles only true side effects, never data derivation

Low-score signals:
- Complex useEffect chains inside the component triggering each other
- The same data stored redundantly in multiple states
- Props copied into useState after arrival (the props→state sync anti-pattern)
```

### 3. Testability

**Core question: can the core logic be verified without launching a browser?**

Inspection points:
- **Pure-function ratio**: what fraction of the core business logic is pure functions? Pure functions can be unit-tested directly, no mocks needed
- **Dependency replaceability**: can external dependencies (API, storage, third-party libraries) be replaced in tests?
- **Test existence**: are there tests? Do they cover the core paths or only the fringes?
- **Test granularity**: does test granularity match code change frequency? Are the most frequently changed modules the most thickly tested?
- **Boundary coverage**: are empty input, zero values, out-of-range values, and exception paths covered?

```
High-score signals:
- Core logic lives in standalone files; import it and test it directly
- Test files sit in the same directory as, or right next to, the source
- Test descriptions read like a specification

Low-score signals:
- All logic lives inside the component; rendering is required to test anything
- Tests lean heavily on mocks; the mocks outnumber the real code
- No tests
```

### 4. Extensibility

**Core question: to add a new feature, how many files must change and how many layers must be touched?**

Inspection points:
- **Extension pattern**: is adding a new variant/type "add a case" or "modify an if-else chain"?
- **Composition over inheritance**: is extension done through composition (children, render props, hooks) rather than inheritance?
- **Plugin points**: are there explicit extension points (handler arrays, strategy pattern, slot pattern)?
- **Change blast radius**: does changing one feature ripple into unrelated code?
- **Over-engineering detection**: are there abstractions added for "maybe in the future" that nothing uses today?

```
High-score signals:
- Discriminated unions used for type dispatch
- Render strategies extended through handler/plugin arrays
- New features only require adding files, never editing existing ones

Low-score signals:
- One giant switch/if-else scattered across multiple places
- Adding a small feature requires changing 5+ files
- 3 layers of abstraction with only 1 implementation
```

### 5. Performance

**Core question: under typical usage, is there unnecessary computation or rendering?**

Inspection points:
- **Render efficiency**: are there unnecessary re-renders? Is Context split appropriately?
- **Computation placement**: does heavy computation happen inside or outside the render loop? Are useMemo/useCallback used in the right places?
- **Async handling**: are big computations async/deferred? Do they block the first render?
- **Memory**: any uncleaned subscriptions, timers, or event listeners? Does the useEffect cleanup actually cancel in-flight async operations?
- **Bundle impact**: how heavy are the third-party dependencies? Can they be tree-shaken?

#### Frame-Level Analysis (mandatory for animation/render-heavy components)

If the component involves animation, video rendering, or high-frequency updates (e.g. 60fps), do frame-level analysis — trace which computations actually execute on every frame render:

- **Code that runs every frame**: in useCurrentFrame()-driven rendering, which useMemo dependencies change every frame? How heavy is the computation inside those useMemos?
- **Object creation frequency**: are new array/object references created every frame? When consecutive frames produce identical results (e.g. the animation hasn't advanced), is there a skip mechanism?
- **GC pressure**: can high-frequency temporary objects (token array slices, string split results) be cached or reused?
- **DOM node count**: are large numbers of DOM nodes rendered all at once (e.g. one Sequence per sound-effect frame) rather than on demand?
- **Dependency-chain stability**: do useMemo/useEffect dependencies include reference-unstable objects? Even with the upstream computation wrapped in useMemo, are the rebuild conditions strict enough?

```
High-score signals:
- Heavy computation done once, result cached
- Context split by update frequency, avoiding whole-tree refreshes
- Large dependencies dynamically imported
- Early return or reference reuse when consecutive frames produce identical results

Low-score signals:
- Unchanging data recomputed every frame/render
- One Context holding all state, so any change re-renders the whole tree
- An uncleaned setInterval inside useEffect
- split/slice/concat creating piles of uncached temporary objects every frame
- useEffect cleanup only sets a cancelled flag without cancelling the async operation
```

### 6. Mental Model

**Core question: can a newcomer opening the code understand "how this thing works" within 10 minutes?**

Inspection points:
- **File as responsibility**: can you guess what a file does from its name?
- **Naming consistency**: is the same concept called the same name across different files?
- **Directory structure**: is the directory organized by responsibility or by technical type? Is there a vague utils/helpers junk drawer?
- **Dependency direction**: unidirectional? Any circular dependencies?
- **Surprise minimization**: any "surprise files" or "surprise behavior" — opening a file and finding it does something entirely unrelated to its name?

```
High-score signals:
- File names are responsibility descriptions
- The dependency graph is a DAG (directed acyclic)
- A README or the directory structure conveys the whole picture at a glance

Low-score signals:
- A utils.ts over 200 lines
- The same concept named differently in different places
- Circular imports between files
```

### 7. Boundaries & Contracts

**Core question: how small is this component's contact surface with the outside world, and how strict are the contracts?**

Inspection points:
- **Entry validation**: at which layer is validation done? Is it done once at the entry, with the internals trusting the data afterward?
- **Third-party encapsulation**: are third-party library dependencies wrapped? How costly would swapping a library be?
- **Type boundaries**: when data crosses layers, is there a type transformation, or is one type passed straight through?
- **Type safety**: are there `as`, `as never`, `as any` type assertions? What is the reason behind each — a design flaw, or a stopgap for mismatched external types?
- **Validation consistency**: is validation consistent across entry paths (component entry vs. direct utility-function calls)? Are there paths that bypass schema validation?
- **Error boundaries**: is there an ErrorBoundary catching component crashes? Are errors handled with severity tiers?
- **Touchpoint count**: how many touchpoints does this component have with the outside world? Can each one be replaced independently?

```
High-score signals:
- Zod/schema validation at the entry; no defensive programming inside
- Third-party libraries wrapped behind adapters, exposing only the needed interface
- Types evolve per layer: InputProps → ResolvedProps → RenderData
- Zero `as any`; few `as` assertions, each with a clear reason

Low-score signals:
- Every function does null checks and type assertions
- Third-party library types appear directly in the public API
- No ErrorBoundary; one child component crash white-screens the whole page
- Multiple `as never` / `as any` force-casts with unclear reasons
- Inconsistent validation of the same data across different call paths
```

## Output

Follow this skeleton, trimmed to the component's scale. Full field descriptions and examples are in [references/output-template.md](references/output-template.md); check against it before finalizing.

```markdown
# Component Diagnosis Report: {component name}
> {one-sentence summary of the component's responsibility}

## Scorecard              — 7 dimensions + overall, ★ ratings + a one-line verdict each
## Per-Dimension Analysis — strengths/weaknesses per dimension, citing filename:line,
                            stating "what it is + why it is a problem"
## Highlights             — 2-3 concrete designs worth spreading, with code locations
## Recommendations        — graded P0 (fix soon) / P1 (worth optimizing) / P2 (nice to have),
                            each with Problem / Impact / Suggestion (give direction, no code) /
                            Effort (small <1h / medium 1-4h / large >4h)
## Architecture Diagram (optional) — for multi-layer structures, draw the data flow as a
                            text diagram or mermaid
```

## Diagnosis Principles

- **Evidence-driven**: back every score with a concrete code location; never score by impression. Citation format: `filename:line`, or `functionName` in `filename`
- **Go deep into the code**: surface-level structural praise ("clean layering", "nice naming") is what anyone gets from scanning a directory, and is of limited value. Truly useful diagnosis comes from problems only a line-by-line read of the critical paths can reveal. Focus on these categories:
  - Trace the concrete data transformation at each layer; check the chain is clear and unidirectional
  - Check whether useMemo/useEffect dependency lists are actually stable (missing deps, references that change every time)
  - Trace where type assertions (`as`, `as never`, `as any`) appear and the design compromise behind each
  - Identify unnecessary repeated computation per frame / per render
  - Check that cleanup functions actually cancel async operations, not just set a flag
- **Context-aware**: a 50-line utility component and a 2000-line composite component deserve different standards. A simple component doesn't need a four-stage pipeline; a complex component with no tests is the real problem
- **No double-counting**: deduct for a given problem only in the most relevant dimension. Double-counting skews the overall score and makes one root cause look like several independent problems
- **Actionable suggestions**: recommendations must be concrete about "how to change it", not "it should be better"
- **Praise before criticism**: state highlights first, then problems. Good design deserves to be seen
- **Earn the deduction — and earn the high score**: deduct only when a concrete code problem is found, never because "it feels like it could be better"; likewise never give a 5 by default just because "no problems were found" — a 5 means you found design patterns in that dimension worth learning from

## Use a different skill when

This skill focuses on the 7-dimension deep diagnosis of a **single React component**. If the user actually wants something else, route there first:

- **The target is not a React component** — a util file, a service, a hook library, or a generic module → `clean-code-reviewer`
- **Whole codebase / module boundaries / abstraction depth / dependency direction** (not a single component) → `hai-architecture` (APoSD-based system-level architecture review) or `improve-codebase-architecture` (whole-repo refactor hunting)
- **Only eliminating `any` / tightening types** → `ts-type-safety-reviewer`
- **Generic code smells / Clean Code health check** (naming, long functions, duplication, over-engineering, magic numbers) → `clean-code-reviewer`
- **Naming a single prop/variable** → `hai-naming`; this skill scores the whole component API surface, not one identifier
- **Just simplifying and tidying recently changed code** → `code-simplifier`

Decision signal: the user points at a single component directory/.tsx and asks about design quality → stay here; the moment the scope expands to multiple modules, cross-file architecture, or whole-repo refactoring → route to an architecture skill.
