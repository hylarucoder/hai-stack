---
name: hai-tdd
description: |
  Drives implementation through a strict red-green-refactor loop and produces a filled-in
  test-evidence report (target behavior, the failing RED test + why it failed for the right
  reason, the minimal GREEN implementation, the refactor decision, and verification commands).
  Use whenever the user implements a feature, fixes a bug, changes or protects behavior,
  refactors, or asks to add/write a test or unit test — even when they never say "TDD". Trigger
  on TDD, test-driven development, test first, red-green-refactor, tdd this, do it test first,
  add test coverage, unit test for this; and on 红绿重构, 先写测试, 用测试驱动开发, 写测试, 加测试,
  补个测试, 单元测试, 给这个写个测试, 测一下, 帮我测; plus the regression-safety intent — refactor
  without breaking behavior, 确保不回归, 别改坏了, 保证行为不变.
---

# Hai TDD

For Chinese readers, see `SKILL.zh_CN.md`. The English `SKILL.md` is the execution source of truth.

## Overview

Drive development with tests: write a failing test first, confirm it fails for the right reason, write the smallest implementation that passes, then refactor while keeping tests green. This is not "add tests at the end" — TDD defines behavior before implementation.

## Core Principle

Red, then green, then refactor.

Do not write production code before a failing test. A test that never failed first has not proven it constrains the target behavior — so the RED failure is the evidence, not a formality. If implementation already exists without a test, do not call the process TDD; either label it as tests-after or return to a test-first path.

## Skip or ask first when

The skill is already triggered; the open decision is whether TDD fits this change. Pause and confirm with the user when:

- The work is a throwaway prototype or a spike, or the user asked for code reading before implementation.
- The change is pure configuration, copy, or styling.
- The behavior cannot reasonably be verified automatically yet.

## Workflow

1. Define the target behavior.
   - Pick one minimal behavior slice.
   - State input, output, side effect, boundary, and failure condition.
   - If the work is too broad, use `hai-goal` to split it into verifiable phases.

2. RED: write the failing test first.
   - The test name should describe behavior, not say "works".
   - Test one behavior at a time.
   - Prefer public APIs, user-observable behavior, or stable boundaries — they keep the test stable when you refactor internals.
   - Avoid mocks unless external systems, time, network, randomness, or permissions force them; mocks tie the test to implementation and hide real behavior.

3. Verify RED.
   - Run the smallest relevant test command and confirm the test fails.
   - Confirm it fails because the target behavior is missing, not because of syntax, imports, bad test code, or environment setup — that distinction is what makes the RED a real constraint rather than a broken test.
   - If the test passes immediately, it did not prove new behavior; fix the test.

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

- Distorting the production API just to make tests convenient — the test should adapt to a good design, not the design to the test.
- Testing only whether a mock was called, not the real behavior, so the test passes even when the behavior is wrong.

## Use a different skill when

- The work is too broad to slice into one verifiable behavior, or the goal/phasing is unclear — use `hai-goal` to turn it into verifiable phases first, then return here to drive each phase.
- The question is module boundaries, abstraction depth, or dependency direction rather than behavior under test — use `hai-architecture`.
- You are deciding whether the feature is worth building at all — use `hai-idea`.
- You are choosing the name of the unit, function, or concept under test — use `hai-naming`.

## Output

Report using `references/output-template.md` — fill every RED / GREEN / REFACTOR field with real evidence; do not collapse it to "tested, passing". Read the template before finalizing.
