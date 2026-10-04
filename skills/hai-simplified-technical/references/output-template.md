# Output Templates

Write the report in the language of the user's request. Use the smallest form that answers it.

## Write or rewrite

Deliver the document (in place only when the user targeted that file and version control exists;
otherwise a clearly named sibling file). Then report briefly:

```markdown
## Changes
- Rules applied: 1.4 ×5, 3.1 ×2, 4.2 ×1, 8.3 throughout   <!-- counts by rule, not a sentence-by-sentence diff -->
- Check script: <hard> hard, <soft> soft left; <why each remaining soft hit stays>

## For the author
- Claims without data: <claim> (<where>) — kept as written; add the number and its conditions.
- Inline [TBD]: <only the facts the reader cannot act without, and where they are>
- <a risk or gap in the content that the rules do not fix, if any>
```

Omit "For the author" when nothing is open.

## Review only

List hard-rule findings first. Quote the original exactly; give a rewrite the author can paste.

```markdown
| Location | Rule | Original | Suggested |
|---|---|---|---|
| line 12 | 3.1 hard | Perform a validation of the input. | Validate the input. |
| line 30 | 1.4 hard | 性能有显著提升 | p99 从 120 毫秒降到 45 毫秒（[待补：测量条件]） |
```

End with one line: the count of hard and soft findings, and whether the document follows the
project glossary (or that no glossary was found).
