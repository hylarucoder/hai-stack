---
name: hai-rewrite-doc
description: |
  Rewrites a drifted, patched-over document from scratch around an explicit anchor of current
  conclusions, and returns the full rewritten document plus a disposition table (keep / rewrite /
  delete / undecided for every block of the old doc) and an open-questions list. Use whenever a
  document has been through several rounds of discussion and no longer matches what was actually
  decided — stale judgments, leftover patches, sections nobody remembers the reason for — and the
  user wants it rewritten rather than patched again. Trigger on 重写这份文档, 这文档已经烂了,
  文档已经不对了, 推倒重写, 按最新结论重写, 文档跟讨论结论对不上, 别再缝缝补补了, 重新整理这份文档,
  and English like "rewrite this doc", "this doc has drifted, redo it from our conclusions",
  "rebaseline this document". For a findings report without a rewrite use hai-audit-docs-internally;
  if the document is a PRD use hai-prd; if it is a plan or goal document use hai-goal.
---

# Hai Rewrite Doc

For Chinese readers, see `SKILL.zh_CN.md`. The English `SKILL.md` is the execution source of truth.

## Overview

Take one document that has rotted through rounds of discussion and patching, and rewrite it as a
whole from an explicit anchor of current conclusions. The old document is raw material and
evidence — never the base to patch.

Deliver three things: the rewritten document, a disposition verdict for every block of the old
one, and the open questions the anchor cannot settle.

## Core Principle

A document rots because the real consensus lives in the conversation while the document only
receives patches — and each patch was written against a different snapshot of that consensus.
More patching cannot fix this. The fix is to make the consensus explicit first, then re-derive
the document from it.

So the order is fixed: **anchor first, then rewrite**. Never start writing before the anchor is
written down, and never merge old text into the new document without a verdict.

## Workflow

1. **Build the anchor.** Collect the conclusions that are true *now*: decisions made, decisions
   later reversed (the reversal wins), constraints still standing, and the document's target
   reader and job. Sources: the user's message, the discussion history, linked docs. Write the
   anchor as a numbered list of conclusions — it ships in the output so the reader can check the
   rewrite against it.

2. **Interrogate the holes.** If the anchor cannot answer "who is this document for" or "what did
   we finally decide about X", ask the user pointed questions before writing anything. A rewrite
   from a guessed anchor just produces the next rotten version.

3. **Inventory the old document.** Split it into blocks (sections, claims, tables, examples). For
   each block ask: is it still true under the anchor? why does it exist? would anyone miss it?

4. **Give every block exactly one verdict:**
   - **Keep** — still true and well written; reuse it, preserving the author's voice.
   - **Rewrite** — the idea survives but the judgment or wording is stale.
   - **Delete** — contradicts the anchor, or is patch residue nobody can explain.
   - **Undecided** — cannot be judged without the user; park it in Open Questions. Never silently
     keep or drop it.

5. **Re-derive the structure from the anchor**, not from the old table of contents. The old
   structure is itself an accumulation of patches; reusing it quietly re-imports the rot.

6. **Write the new document in full.** It must stand alone — a reader with no access to the
   discussion history should understand it. Match the original language and register unless the
   anchor changes the audience.

7. **Check the rewrite against the anchor, item by item.** Every anchor conclusion is
   represented; everything in the new document traces to the anchor or to a Keep verdict.
   Anything that fails this check gets fixed or moved to Open Questions.

## Output

Replace the original file in place — version control and the disposition table carry the
history; a sibling copy just becomes the next piece of patch residue. Write to a separate file
only when the user explicitly asks to keep the original untouched. The reply carries the rest:

```markdown
# Hai Rewrite Doc: <document>
## Anchor               — numbered current conclusions the rewrite derives from
## Rewritten Document   — path to the rewritten file (inline only when the document is short)
## Disposition Table    — old block → Keep / Rewrite / Delete / Undecided, each with a reason
## Open Questions       — what the anchor cannot settle, and which section each one blocks
```

Read `references/output-template.md` before finalizing.

## Use a different skill when

- The user wants a findings report, not a rewritten document — use `hai-audit-docs-internally`.
- The truth source is the code, not the discussion — use `hai-audit-docs-against-code`.
- The document is a PRD — use `hai-prd`; its Craft mode owns PRD repair and rewrite.
- The document is a plan or goal document — use `hai-goal`; its rewrite mode re-anchors plans
  around a target.
- Only structure and formatting are wrong and the content is fine — use `readme-beautifier`.
- The real question is which concepts deserve to exist at all — run `hai-razor` first, then
  rewrite.

## What this skill is NOT

- Not a beautifier — it changes content and judgment, not just formatting.
- Not a patch merger — it never produces "the old doc plus the latest edits".
- Not a summarizer — the output is a full working document, not a digest.
- Not silent — nothing from the old document disappears without a line in the disposition table.

## Common Mistakes

- Writing before the anchor is explicit — the rewrite inherits guesses instead of conclusions.
- Reusing the old table of contents out of habit.
- Treating "it was discussed once" as consensus; only the latest standing decision counts.
- Silently dropping blocks instead of recording a Delete verdict.
- Rewriting Keep blocks anyway and destroying the author's voice.
