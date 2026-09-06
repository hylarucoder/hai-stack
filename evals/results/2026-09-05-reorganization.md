# Skill reorganization smoke results

Date: 2026-09-05. Three paired synthetic tasks, one execution per configuration.
Skills explicitly loaded; not a natural-discovery or trigger-accuracy benchmark.
Baseline: old documentation/complexity snapshots; debug uses no skill.

| Task | New | Baseline | Evidence preserved |
| --- | --- | --- | --- |
| Document authority | 4/4 | 4/4 | current vs future, timeout, unsupported claim, no edits |
| Global runtime audit | 5/5 | 5/5 | both entries, config/state, test gap, options/proof, no edits |
| Debug string flag | 4/4 | 4/4 | reproduction, cause, proposed vs executed, no edits |

Both passed 13/13 smoke assertions. This supports method preservation on these fixtures,
not general equivalence or improvement. No timing/token efficiency evidence is available.

Caveats:
- Merged docs leave unsupported configuration unresolved; baseline recommends removal.
- New architecture report puts P1 before P0. Assertions do not measure ordering; include it
  in future evaluation rather than treating every passing report as flawless.
- Debug was equally solved without a skill; it remains trial.
- Check-and-fix execution, acceptance, code review, and automatic selection were not tested here.
- Fixture contents were compared with the creation patch and remained unchanged.

Reports, grading JSON, baseline snapshots, and the generated viewer live under ignored
`output/skill-reorg/`. They are session artifacts, not required installed resources.
Next use real ambiguous tasks, authorized repairs, missing evidence, host selection and user
corrections, instead of scoring only explicit keyword prompts.
