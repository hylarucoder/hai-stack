# Hai Rewrite Doc Output Template

The canonical report shape. The rewritten document replaces the original file in place (version
control and the Disposition Table carry the history); write a separate file only when the user
explicitly asked to keep the original. This report is the reply. Every block of the old document
must appear in the Disposition Table — nothing disappears silently. User-visible text may be
written in Chinese when the audience is Chinese.

```markdown
# Hai Rewrite Doc: <document name>

## Anchor

The current conclusions this rewrite derives from. Numbered, so dispositions and the final check
can cite them.

1. <conclusion — e.g. "the doc targets new contributors, not maintainers">
2. <conclusion — e.g. "the X mechanism was replaced by Y in the 6/08 discussion">
3. <reversed decision — state the reversal explicitly: "A was decided on 6/01, overturned 6/09">
...

## Rewritten Document

Path: `<absolute path to the rewritten file>`

<inline the full document only when it is short enough to read in the reply>

## Disposition Table

Every verdict cites the check it passed or failed — an anchor item, a code/config/schema
reference, a command that was run, or a linked document. "Looked wrong" is not a check.

A failed check means the block is removed, never repaired into a passing version — replacement
coverage, when needed, comes from the anchor.

| # | Old block | Verdict | Check (passed / failed) |
| --- | --- | --- | --- |
| 1 | <section / claim / table> | Keep | verified against anchor 2 + `src/config.ts:14`; wording preserved |
| 2 | <section / claim> | Delete | verified wrong: default value contradicts `settings.py:88` |
| 3 | <section / claim> | Delete | verified wrong: command no longer exists (`make build` removed in a1b2c3) |
| 4 | <section / claim> | Undecided | unverifiable without user — see Open Question 1 |

## Open Questions

Each question names what it blocks. The rewrite ships without these sections resolved; do not
guess answers into the document.

1. <question> — blocks <section> (old block #4)
2. <question> — blocks <section>

## Next Step

<one line: what the user should confirm or decide for the rewrite to be final>
```
