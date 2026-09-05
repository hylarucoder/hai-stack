# Skill Trigger Regression Set

`trigger-cases.json` records the highest-risk routing boundaries across all skills. Each case has:

- `expected_skills`: skills that should own the request.
- `excluded_skills`: tempting near-miss skills that should not take over.

`make validate` checks the file's structure, skill names, duplicate IDs, and positive coverage for
all installed skills. It does not pretend to measure model behavior. When changing descriptions,
run these prompts through the target model/host and record actual trigger results before claiming
trigger accuracy improved.

Prioritize these collision groups during model evaluation:

1. `hai-goal` / `hai-tdd`.
2. `hai-architecture` / `hai-complexity` / `hai-razor`.
3. `hai-prd` / document audit / `hai-rewrite-doc` / `readme-beautifier`.
4. `clean-code-reviewer` / `react-component-diagnosis`.
5. `create-visual-card` / `hai-visual-report`.
