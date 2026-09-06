---
name: hai-debug
description: |
  Diagnoses an unexplained software failure through reproduction, competing hypotheses, discriminating checks, and a causal explanation. Use for 排障、根因分析、偶发失败、环境差异、重复执行, or a bug whose cause is unclear. Return observed evidence, ruled-out hypotheses, cause/confidence, and a regression target; fix and verify only when the request includes fixing. Use hai-tdd when the cause and desired behavior are already known, and hai-architecture for change complexity without a malfunction.
---

# Hai Debug

For Chinese readers, see `SKILL.zh_CN.md`. English is the execution source of truth.
Status: trial. The method has not yet demonstrated improvement across representative real tasks.

## Principle

An explanation must account for the observed failure and predict a check that could disprove it.
A plausible patch is not causal evidence. Begin with the cheapest check that separates likely causes.

## Workflow

1. Establish expected versus actual behavior, scope, timing, environment/version, and requested
   action (diagnose or fix). Read available logs, errors, code, recent changes, and existing tests
   before asking for information that is already available.
2. Reproduce on an isolated local fixture when possible. Record inputs, preconditions, command,
   and observed result. For intermittent failures, capture frequency/order/concurrency and a
   bounded repeat strategy; do not loop indefinitely or hammer live services.
3. Trace the symptom backward through callers, state/config, persistence, and external boundaries.
   Compare working and failing cases. Distinguish observations, assumptions, and historical claims.
4. Form a small set of plausible competing hypotheses. For each, record supporting/conflicting
   evidence and one cheap discriminating check. A trivial obvious cause needs no ceremonial table.
5. Run the highest-information safe check, update confidence, and eliminate contradicted
   hypotheses. Instrument narrowly if authorized by the fix request; diagnose-only work uses
   read-only checks or separate disposable reproductions, not edits to user code.
6. Explain the causal chain: precondition → faulty decision/state → observable symptom.
   Cite actual file:line/log/test evidence. A failed reproduction leaves the cause unconfirmed;
   report the best next check and missing evidence rather than guessing.
7. If only diagnosis was requested, stop with the cause and a proposed repair/regression target.
   If fixing was requested, continue through the smallest complete repair and verification:
   use `hai-tdd` when a meaningful behavioral RED exists; otherwise use honest targeted
   integration/runtime checks. Reproduce the original case again and check nearby contracts.
8. Deliver using `references/output-template.md`. Separate symptom mitigation from root-cause
   repair and executed checks from proposed checks.

## Constraints and stop rules

Respect the user's environment and authority. Reproduction does not authorize destructive
production operations, external messages, paid calls, or traffic load. Prefer isolated fixtures.
After repeated checks yield no new evidence, change the hypothesis or evidence source; identify
the exact blocker if progress needs unavailable data. Elapsed time is not proof.

Do not broadly refactor, suppress errors, add blind retries, or change expected behavior merely
to make the symptom disappear. A mitigation may be useful but must be labeled and bounded.
Preserve unrelated work and remove only temporary instrumentation created for this task when
its diagnostic purpose is complete.

## Handoffs

- Cause known, implement a behavior change → `hai-tdd` when suitable, otherwise normal execution.
- System hard to change without a specific failure → `hai-architecture`.
- Review a completed change → `code-review-and-quality`.
- Prove the full change against requirements → `write-technical-acceptance-report`.
- Multi-phase repair with unresolved execution dependencies → `hai-goal`.
