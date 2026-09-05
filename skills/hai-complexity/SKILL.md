---
name: hai-complexity
description: |
  Audits a whole repository or large subsystem by tracing runtime entrypoints through core call chains, state/configuration flow, dependencies, and test protection to locate the operational complexity center. Use for broad requests such as 复杂度审计、系统太绕、调用链太长、配置构建太散, or “why is this repo hard to change?”, including keyword-led investigations that must expand into the enclosing runtime path. Use hai-architecture for one bounded module boundary or design decision.
---

# Hai Complexity

For Chinese readers, see `SKILL.zh_CN.md`. The English `SKILL.md` is the execution source of truth.

## Purpose

Explain why a repository or large subsystem is hard to change by connecting topology, dependency
direction, runtime entrypoints, core call chains, state/configuration flow, and test protection into
one evidence-backed risk map.

This is not a larger synonym for `hai-architecture`: it starts from how the system actually enters
and runs, traces one to three important paths end to end, and locates operational complexity across
boundaries. Use `hai-architecture` for a bounded split/merge/ownership decision.

## Entry mode

- **Keyword-led**: start from the user's term, symptom, module, error, or suspicious concept, then
  climb to its enclosing owner, runtime chain, state/config surface, and tests.
- **Global**: start from repository topology, manifests, entrypoints, and test roots, then converge
  on the one to three paths with the most product/runtime importance and change pressure.

Keywords are clues, not scope boundaries. A global audit maps broadly but does not inspect every
file equally.

## Evidence gate

A valid finding connects at least three of these anchors:

1. Repository/package ownership.
2. Dependency direction.
3. Runtime entrypoint and caller/callee trace.
4. State, configuration, or data flow.
5. Tests or verification that protect—or fail to protect—the path.

Read every cited file; identify real entrypoints; trace callers/callees before claiming a chain;
inspect manifests/config before judging construction or layering; and label inference as unverified.
A large file or awkward abstraction alone is not a system-complexity finding.

## Workflow

1. Confirm whole-repository or large-subsystem scope and choose keyword-led or global entry.
2. Map top-level packages, manifests, build/config files, test roots, and declared boundaries.
3. Identify runtime entrypoints: boot files, servers, routes, CLIs, workers, jobs, and scripts.
4. Trace one to three core paths through domain logic, state/config, persistence or external effects,
   and their tests.
5. Apply only relevant lenses from `references/lenses.md`.
6. Name the complexity center where change amplification, cognitive load, or unknown unknowns
   accumulate, and explain why easier smells are secondary.
7. For each important finding, compare a conservative repair with a cleaner boundary; add a staged
   option only when migration risk is real.
8. Return the evidence map, ranked findings, what to preserve, cost, change order, and stop rule.

## Severity and cost

Rate impact before ugliness:

- **P0**: hidden complexity creates likely correctness, data-loss, security, or operability risk.
- **P1**: a core path has high change amplification or unknown-unknown risk.
- **P2**: boundary drift or cognitive load materially slows normal work.
- **P3**: local cleanup worth doing only while touching the area.

Use **S** for a local low-risk repair, **M** for a boundary/test change, and **L** for ownership,
public-contract, persistence, or rollout change. Explain why the cost is worth paying—or why it is
not worth paying yet.

## Output

Match the user's language and keep identifiers unchanged. Fill
`references/output-template.md`; do not duplicate the schema here. One deeply traced chain is more
valuable than ten shallow smells, but do not claim a whole-repo audit if major entrypoint families
were never mapped.

## Use a different skill when

- One bounded architecture/design decision → `hai-architecture`.
- One duplicated authority, shape, literal, default, or conversion chain → `hai-ssot`.
- File/function-level cleanliness → `clean-code-reviewer`.
- One React component → `react-component-diagnosis`.
- Turning accepted findings into phases and todos → `hai-goal`.
