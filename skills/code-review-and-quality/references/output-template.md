# Code review output

Lead with actionable findings ordered by impact; if none, say so.

For each finding give:
- Severity: P0 blocker / P1 high / P2 medium / P3 minor.
- Triggering scenario and consequence.
- File:line evidence and cause.
- Minimal remedy and closure proof.
- Whether it is new, pre-existing, or still unverified.

End with scope and baseline, checks actually run (including failures/skips), blind spots, and:
- Ready within reviewed scope.
- Changes required: named defects remain.
- Insufficient evidence: named question or inaccessible surface prevents a verdict.

In maintainability mode, the verdict concerns maintainability only.
When fixes were requested, distinguish fixed findings from remaining ones and link changed files.
A favorable review does not claim release acceptance or authorize a merge.
