---
name: hai-tdd
description: |
  Drives a real behavior change through red-green-refactor and records the failing RED evidence, minimal GREEN implementation, refactor decision, and verification commands. Use when the user explicitly asks for TDD/tests first, adds or fixes testable behavior, or needs regression protection（先写测试、红绿重构、补回归测试）. Do not force TDD onto documentation, configuration, styling, renames, package moves, or other purely structural changes; report honest non-TDD verification instead.
---

# Hai TDD

For Chinese readers, see `SKILL.zh_CN.md`. The English `SKILL.md` is the execution source of truth.

## Overview

Drive development with tests: write a failing test first, confirm it fails for the right reason, write the smallest implementation that passes, then refactor while keeping tests green. This is not "add tests at the end" — TDD defines behavior before implementation.

## Core Principle

Red, then green, then refactor.

Do not write production code before a failing test. A test that never failed first has not proven it constrains the target behavior — so the RED failure is the evidence, not a formality. If implementation already exists without a test, do not call the process TDD; either label it as tests-after or return to a test-first path.

Do not invent a test merely to satisfy the ritual. TDD is for behavior and stable contracts, not for creating ad hoc structural tripwires around a one-off cleanup.

## When TDD does not fit

Select honest non-TDD verification without pausing for permission when:

- The work is a throwaway prototype or a spike, or the user asked for code reading before implementation.
- The change is pure configuration, copy, or styling.
- The behavior cannot reasonably be verified automatically yet.
- The change is purely structural and has no meaningful behavior-level RED, such as deleting a field, narrowing an interface, moving a type, renaming a symbol, removing an exported helper, or changing package ownership.

In these cases, say TDD does not fit this slice. Use compile failures, existing tests, static checks,
or tests-after verification instead of manufacturing a RED test. Ask the user only when the choice
would materially change the requested behavior or scope.

## No Fake RED

Never add tests whose only purpose is to make a structural refactor look like TDD. Do not add:

- AST/regex/reflection scans for a one-time shape cleanup.
- White-box guards that inspect source rather than a durable behavior or policy boundary.
- Tests that duplicate compiler checks unless the repository already maintains that policy class.
- One-off guards for renames, package moves, aliases, or visibility changes.

Architecture/static boundary tests are allowed only when all of the following are true:

- The boundary is a durable policy the project intends to keep checking over time.
- The test failure would catch a likely future regression, not just document today's edit.
- The user explicitly wants that kind of guard, or the repository already has an established policy-test pattern.

When no legitimate RED exists, prefer this sentence over a fake test: "No TDD for this slice: this is a structural refactor. I will validate it with compiler errors, existing tests, and focused runtime checks."

## Workflow

1. Define the target behavior.
   - Pick one minimal behavior slice.
   - State input, output, side effect, boundary, and failure condition.
   - If the slice is only structural, stop here and report "not TDD" instead of forcing RED.
   - If the work is too broad, use `hai-goal` to split it into verifiable phases.

2. RED: write the failing test first.
   - The test name should describe behavior, not say "works".
   - Test one behavior at a time.
   - Prefer public APIs, user-observable behavior, or stable boundaries — they keep the test stable when you refactor internals.
   - Avoid mocks unless external systems, time, network, randomness, or permissions force them; mocks tie the test to implementation and hide real behavior.

3. Verify RED.
   - Run the smallest relevant test command and confirm the test fails.
   - Confirm it fails because the target behavior is missing, not because of syntax, imports, bad test code, or environment setup — that distinction is what makes the RED a real constraint rather than a broken test.
   - If the test passes immediately, do not damage it merely to manufacture RED. Determine whether
     the behavior already exists, the reproduction is wrong, or this is regression/tests-after work,
     then label the evidence honestly.

4. GREEN: write the minimal implementation.
   - Write only enough code to pass the current test. Extra code is unverified by any failing test, so it falls outside TDD's safety net.
   - Do not add future features and do not mix in unrelated refactors.
   - Do not skip the minimal implementation step for a larger "complete" design.

5. Verify GREEN.
   - Rerun the relevant tests.
   - Confirm the new test passes.
   - Based on risk, run broader tests for the directory, module, or full suite.

6. REFACTOR.
   - Refactor only after green.
   - Improve duplication, naming, structure, or boundaries.
   - Rerun tests after refactoring.

7. Continue with the next behavior.
   - Every new behavior returns to RED.
   - Do not put multiple behaviors into one large test.

## Test Quality Bar

Good TDD tests:

- Test behavior rather than implementation details.
- Have names that communicate business or system meaning.
- Fail with a message that points to the missing behavior.
- Are stable under refactoring.
- Are small, but not brittle white-box tests.
- Serve as behavior documentation for future maintainers.

## Common Mistakes

Traps not already caught by the workflow steps above:

- Forcing TDD onto structural cleanup by writing AST/grep/reflection guard tests that do not protect user-visible behavior or a stable contract.
- Distorting the production API just to make tests convenient — the test should adapt to a good design, not the design to the test.
- Testing only whether a mock was called, not the real behavior, so the test passes even when the behavior is wrong.

## Use a different skill when

- The work is too broad to slice into one verifiable behavior, or the goal/phasing is unclear — use `hai-goal` to turn it into verifiable phases first, then return here to drive each phase.
- The question is module boundaries, abstraction depth, or dependency direction rather than behavior under test — use `hai-architecture`.
- You are deciding whether the feature is worth building at all — use `hai-idea`.
- You are choosing the name of the unit, function, or concept under test — use `hai-naming`.

## Output

Report using `references/output-template.md` — fill every RED / GREEN / REFACTOR field with real evidence when TDD applies; do not collapse it to "tested, passing". If no legitimate RED exists, use the template's "No Legitimate RED" path instead of pretending. Read the template before finalizing.
