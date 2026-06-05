---
name: hai-tdd
description: Use when implementing a feature, fixing a bug, changing behavior, refactoring code, or when the user asks for TDD, test-driven development, test first, 红绿重构, 先写测试, or 用测试驱动开发.
---

# Hai TDD

For Chinese readers, see `SKILL.zh_CN.md`. The English `SKILL.md` is the execution source of truth.

## Overview

Use this skill to drive development with tests: write a failing test first, confirm it fails for the right reason, write the smallest implementation that passes, then refactor while keeping tests green.

This is not "add tests at the end." TDD defines behavior before implementation. If the test never failed first, it did not prove that it constrains the target behavior.

## Core Principle

Red, then green, then refactor.

Do not write production code before a failing test. If implementation already exists without a test, do not call the process TDD; either label it as tests-after or return to a test-first path.

## When To Use

Use this skill for:

- New feature implementation.
- Bug fixes.
- Behavior changes.
- Refactoring when behavior must be protected.
- Explicit requests for TDD, test-first, red-green-refactor, or test-driven development.

Ask or skip when:

- The work is a throwaway prototype.
- The change is pure configuration, copy, or styling.
- The behavior cannot reasonably be verified automatically yet.
- The user explicitly asks for a spike or code reading before implementation.

## Workflow

1. Define the target behavior.
   - Pick one minimal behavior slice.
   - State input, output, side effect, boundary, and failure condition.
   - If the work is too broad, use `hai-goal` to split it into verifiable phases.

2. RED: write the failing test first.
   - The test name should describe behavior, not say "works".
   - Test one behavior at a time.
   - Prefer public APIs, user-observable behavior, or stable boundaries.
   - Avoid mocks unless external systems, time, network, randomness, or permissions make them necessary.

3. Verify RED.
   - Run the smallest relevant test command.
   - Confirm the test fails.
   - Confirm it fails because the target behavior is missing, not because of syntax, imports, bad test code, or environment setup.
   - If the test passes immediately, it did not prove new behavior; fix the test.

4. GREEN: write the minimal implementation.
   - Write only enough code to pass the current test.
   - Do not add future features.
   - Do not mix in unrelated refactors.
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

Read `references/output-template.md` before finalizing.

## Test Quality Bar

Good TDD tests:

- Test behavior rather than implementation details.
- Have names that communicate business or system meaning.
- Fail with a message that points to the missing behavior.
- Are stable under refactoring.
- Are small, but not brittle white-box tests.
- Serve as behavior documentation for future maintainers.

## Common Mistakes

- Writing implementation first, adding tests later, and calling it TDD.
- Writing one large test that covers many behaviors.
- Distorting the production API just to make tests convenient.
- Testing only whether a mock was called, not real behavior.
- Skipping RED failure verification.
- Over-designing during GREEN.
- Refactoring without rerunning tests.

## Output Requirements

When reporting work, include:

- Target behavior.
- RED test.
- RED command and failure reason.
- Minimal GREEN implementation.
- GREEN command and pass result.
- Refactor decision and post-refactor verification.
