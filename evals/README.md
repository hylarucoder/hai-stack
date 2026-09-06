# Skill regression checks

`trigger-cases.json` records owning and excluded skills. Optional `expected_mode` and
`expected_action` distinguish merged modes and audit-versus-fix requests.
Expected skills own the entry request; supporting skills may be used later.

`make validate` checks names, IDs, positive coverage, modes, fixture existence, retired
references, resources, script syntax, and isolated installer tests. It does not execute
natural-language requests or measure model behavior.

`workflow-cases.json` contains three local tasks with fixtures and outcome assertions.
Run new and pre-change baseline independently, preserving fixtures; debug baseline has no skill.
Use `output/skill-reorg/iteration-N/eval-ID/{with_skill,without_skill}/outputs/`.

Record evidence-based grading and caveats. Do not infer trigger accuracy from explicit loading,
general quality from a small fixture, or efficiency without metrics.
Initial results: [reorganization smoke](results/2026-09-05-reorganization.md).

Priority boundaries:
1. Global/bounded architecture, and architecture versus unexplained faults.
2. Internal/implementation/combined doc evidence; audit versus check-and-fix versus full rewrite.
3. Cause-unknown debugging versus cause-known TDD.
4. Code review versus actual acceptance; compact versus high-risk acceptance.
5. Planning plus authorized implementation versus plan-only.
6. Structural/config/style changes that should proceed without ceremony.

Fixtures deliberately contain faults. Do not run retry loops without a bounded send stub,
or repair fixtures as incidental repository cleanup.
