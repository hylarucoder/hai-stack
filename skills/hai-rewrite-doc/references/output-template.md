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

| # | Old block | Verdict | Reason (cite anchor #) |
| --- | --- | --- | --- |
| 1 | <section / claim / table> | Keep | still true under anchor 2; wording preserved |
| 2 | <section / claim> | Rewrite | idea survives, judgment stale vs anchor 1 |
| 3 | <section / claim> | Delete | contradicts anchor 3 / unexplainable patch residue |
| 4 | <section / claim> | Undecided | needs user input — see Open Question 1 |

## Open Questions

Each question names what it blocks. The rewrite ships without these sections resolved; do not
guess answers into the document.

1. <question> — blocks <section> (old block #4)
2. <question> — blocks <section>

## Next Step

<one line: what the user should confirm or decide for the rewrite to be final>
```
