# Hai Rewrite Doc Output Template

The canonical report shape. Edit the original only when the user targeted that file and recoverable
history exists; otherwise preserve it and write a clearly named output. Every old block must appear
in the Disposition Table. User-visible text may be written in Chinese when the audience is Chinese.

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

- **Path**: `<absolute path to the rewritten file>`
- **Original changed**: yes / no
- **Recovery source**: version control / preserved original path / n/a

<inline the full document only when it is short enough to read in the reply>

## Disposition Table

Every verdict cites the check it passed or failed — an anchor item, a code/config/schema
reference, a command that was run, or a linked document. "Looked wrong" is not a check.

A failed check cannot be repaired from guesswork. Delete it when no longer needed, or mark Replace
when a cited anchor or authority supplies necessary corrected coverage. Cover both macro rows
(frontmatter/title/purpose) and micro rows (individual claims and list items).

| # | Old block | Verdict | Check (passed / failed) |
| --- | --- | --- | --- |
| 1 | frontmatter / YAML metadata | Delete | macro: frame no longer fits the current scenario (anchor 1) |
| 2 | <section / claim / table> | Keep | verified against anchor 2 + `src/config.ts:14`; wording preserved |
| 3 | <list item 3 of section X> | Delete | verified wrong: default value contradicts `settings.py:88` |
| 4 | <section / claim> | Replace | old command failed; replacement comes from current CLI help + anchor 3 |
| 5 | <section / claim> | Undecided | unverifiable without user — see Open Question 1 |

## Open Questions

Each question names what it blocks. The rewrite ships without these sections resolved; do not
guess answers into the document.

1. <question> — blocks <section> (old block #4)
2. <question> — blocks <section>

## Next Step

<one line: what the user should confirm or decide for the rewrite to be final>
```
