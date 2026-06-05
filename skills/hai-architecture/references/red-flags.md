# APoSD Red Flags — Detection Guide

These are the 14 design smells identified by John Ousterhout. For each one, this document describes what to look for in real code.

## 1. Shallow Module

**What it is**: A module whose interface is nearly as complex as its implementation. It doesn't hide much.

**How to detect**:
- Count the exported symbols (functions, types, constants) vs. the internal logic. If the ratio is close to 1:1, the module is shallow.
- A function that is 3-5 lines and takes 3+ parameters is often shallow — the caller already knows almost everything the function does.
- A package with many exported types but little internal logic.
- Wrapper functions that add no value — they just rename another function.

**Exception**: Some shallow modules are unavoidable and correct. HTTP handlers that translate between protocol and domain are inherently shallow, and that's fine — their job *is* protocol translation. The problem is when shallow modules are created out of a belief that "small is always better."

## 2. Information Leakage

**What it is**: The same design decision (data format, algorithm, protocol detail) is reflected in multiple modules.

**How to detect**:
- Two modules that both know about the internal structure of a data format (e.g., JSON field names, wire protocol details).
- When changing one module's implementation requires changing another module too.
- Shared constants or types that expose implementation decisions (not just shared domain concepts).
- Two modules that must be modified in lockstep.

**This is the most damaging red flag.** It creates invisible coupling. Prioritize fixing it.

## 3. Temporal Decomposition

**What it is**: Code organized by the order operations happen (read → process → write) rather than by what information each operation needs.

**How to detect**:
- Modules or functions named after phases: `reader`, `processor`, `writer`, `parser`, `formatter`.
- If two "phases" both need access to the same data structure, they probably belong in the same module.
- The telltale sign: data is extracted in one module, passed through an intermediate representation, and consumed in another — and both modules understand the same internal structure.

## 4. Overexposure

**What it is**: An API forces callers to know about rarely-used features just to use common features.

**How to detect**:
- Functions with many parameters where most callers pass zero/default for several of them.
- Options structs where 80% of fields are only used by 5% of callers.
- Required setup steps that are only necessary for advanced use cases.

## 5. Pass-Through Method

**What it is**: A method that does almost nothing except call another method with a similar signature.

**How to detect**:
- Method A calls method B with the same (or nearly the same) parameters.
- The method adds no logic, no transformation, no validation — it just forwards.
- Three-layer stacks where the middle layer is pure delegation.
- If you removed the pass-through method and had callers call the target directly, nothing of value would be lost.

**Exception**: Protocol translation (HTTP handler → domain method) is pass-through by nature and is usually correct.

## 6. Repetition

**What it is**: A nontrivial piece of logic appears in multiple places.

**How to detect**:
- Copy-pasted code blocks (even with slight variations).
- Multiple modules that implement the same algorithm independently.
- The "if you change this, you must also change that" pattern.

**Important nuance**: Three similar lines is not repetition — it's coincidence. Repetition means the same *decision* or *algorithm* is encoded in multiple places, so changing the decision requires finding and updating all copies.

## 7. Special-General Mixture

**What it is**: Special-purpose code tangled with general-purpose code in the same module.

**How to detect**:
- A utility function that has special handling for one specific caller.
- A general-purpose library that contains business-logic-specific branches.
- `if caller == "X" { special behavior }` inside what should be a generic module.
- A module whose name suggests generality ("store", "client", "service") but whose implementation is deeply specific to one use case.

## 8. Conjoined Methods

**What it is**: You cannot understand method A without also reading method B.

**How to detect**:
- Method A sets up state that method B depends on, with no documentation of the contract between them.
- Two methods that must be called in a specific order, but nothing enforces or documents this.
- Splitting what was one operation into two methods that share implicit assumptions.

## 9. Comment Repeats Code

**What it is**: A comment that says exactly what the code already says.

**How to detect**:
- `// increment counter` above `counter++`
- `// returns the user` above `func GetUser() User`
- Comments that could be deleted without any loss of understanding.

## 10. Implementation Leaks into Interface Docs

**What it is**: Documentation for a public API describes internal implementation details that callers don't need.

**How to detect**:
- Interface comments mentioning internal data structures, algorithms, or implementation choices.
- Documentation that would need to change if the implementation changed (even though the behavior stays the same).

## 11. Vague Name

**What it is**: A name broad enough to refer to many different things.

**How to detect**:
- Names like: `data`, `info`, `result`, `item`, `element`, `thing`, `object`, `value`, `tmp`, `temp`, `manager`, `handler`, `helper`, `util`, `misc`, `common`.
- A name that, in isolation, does not tell you what the thing *is* or *does*.
- Multiple different concepts using the same name in different parts of the codebase.

## 12. Hard to Pick Name

**What it is**: Struggling to find a good name is a signal that the design might be unclear.

**How to detect**:
- Variables or functions with compound names that try to describe everything: `userDataProcessorAndValidator`.
- Names that keep getting renamed because none of them feel right.
- When you ask "what does this module do?" and the answer requires the word "and" — it probably does too many things.

## 13. Hard to Describe

**What it is**: If a complete description of a method requires a long, complex explanation, the method may be doing too much.

**How to detect**:
- Doc comments that are longer than the method body.
- Descriptions that require multiple paragraphs.
- Descriptions that contain "if...then..." conditionals explaining different behaviors.

## 14. Nonobvious Code

**What it is**: Code whose behavior or meaning cannot be understood quickly by reading it.

**How to detect**:
- Clever tricks or micro-optimizations that sacrifice readability.
- Generic container types without context (`Pair<String, String>` — what are the two strings?).
- Event-driven flows where cause and effect are far apart in the code.
- Behavior that differs from what a reasonable reader would expect from a quick scan.
- Variables declared far from their usage.
- Type assertions or casts without explanation of why they're safe.
