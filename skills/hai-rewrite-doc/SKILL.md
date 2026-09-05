---
name: hai-rewrite-doc
description: |
  Rebuilds a drifted, repeatedly patched document from verified current conclusions. It inventories old blocks, preserves verified wording, removes disproved material, writes authoritative replacement coverage only from verified sources, and reports keep/delete/replace/undecided dispositions. Use when the user wants a rotten document verified and rewritten rather than patched again（按最新结论重写、逐条核实、推倒重写）. Use hai-prd for PRDs, hai-goal for plans, and a document-audit skill when no rewrite is requested.
---

# Hai Rewrite Doc

For Chinese readers, see `SKILL.zh_CN.md`. The English `SKILL.md` is the execution source of truth.

## Overview

Take one document that has rotted through rounds of discussion and patching, verify it block by
block, and rewrite it around what survives. The old document is raw material and evidence —
never the base to patch.

The default stance toward old content is **preservation**: every block gets verified and what
passes keeps its wording. A failed block is never patched from guesswork; delete it, or replace its
coverage only when the anchor or another authoritative source supplies the correction.

Verification runs at two levels: **macro** (frontmatter, title, purpose) and **micro** (individual
claims, tables, commands, and examples). Both use the same evidence rules.

Deliver the rewritten document, a disposition verdict for every old block, and the open questions
that cannot be verified without the user.

## Core Principle

A document rots because the real consensus lives in the conversation while the document only
receives patches — and each patch was written against a different snapshot of that consensus.
More patching cannot fix this. The fix is to make the consensus explicit first, then re-derive
the document from it.

So the order is fixed: **anchor first, then rewrite**. Never start writing before the anchor is
written down, and never merge old text into the new document without a verdict.

And verdicts are earned by verification, not by smell. A claim that can be checked — against the
anchor, the codebase, a config file, a schema, a runnable command — must actually be checked
before it is kept or deleted. A claim that cannot be checked is never silently kept or dropped;
it goes to Open Questions.

**Verification failure forbids guessed repair.** A disproved block cannot be paraphrased into a
plausible-looking correction. Delete it when the topic is no longer needed; use **Replace** when a
verified anchor, contract, code path, or other named authority supplies the correct coverage; use
**Undecided** when no authority settles it.

## Workflow

1. **Build the anchor.** Collect the conclusions that are true *now*: decisions made, decisions
   later reversed (the reversal wins), constraints still standing, and the document's target
   reader and job. Sources: the user's message, the discussion history, linked docs. Write the
   anchor as a numbered list of conclusions — it ships in the output so the reader can check the
   rewrite against it.

2. **Interrogate the holes.** If the anchor cannot answer "who is this document for" or "what did
   we finally decide about X", ask the user pointed questions before writing anything. A rewrite
   from a guessed anchor just produces the next rotten version.

3. **Inventory the old document.** Split it into blocks (sections, claims, tables, examples,
   commands, numbers). The inventory exists so that every block gets verified — none skipped.

4. **Verify at two levels: macro first, then micro.**
   - **Macro — the document's frame.** Verify the frontmatter/YAML metadata, title, stated
     purpose, and top-level framing before anything else. A frame that no longer fits the
     current scenario, or has simply fallen behind it, fails like any other block: remove it
     (replacement framing comes from the anchor). And a failed frame casts suspicion downward —
     content that existed only to serve the dead frame must be re-verified against the anchor,
     not against the frame.
   - **Micro — every point, one by one.** Check each block against the anchor, then against
     anything else checkable: the code, config, schema, the commands and paths it cites, linked
     documents. List-heavy documents are where rot hides: a list is never verified wholesale —
     it passes only when every item in it has passed individually, and failed items are removed
     individually.

   Record what was checked at both levels — the disposition table cites it.

5. **Give every block exactly one verdict:**
   - **Keep** — verified still true; reuse it with the original wording and voice.
   - **Delete** — failed verification and no longer needed. Cite the failed check.
   - **Replace** — the old block failed, but a named authoritative source supplies necessary,
     verified replacement coverage. Cite both the failure and replacement source.
   - **Undecided** — unverifiable without the user; park it in Open Questions. Never silently
     keep or drop it.

6. **Decide the structure deliberately.** Keep the old structure when it still serves the anchor
   — preservation extends to structure, not only wording. Re-derive it from the anchor only when
   the structure itself is patch residue.

7. **Write the new document in full.** It must stand alone — a reader with no access to the
   discussion history should understand it. Match the original language and register unless the
   anchor changes the audience.

8. **Check the rewrite against the anchor, item by item.** Every anchor conclusion is
   represented; everything in the new document traces to the anchor or to a Keep verdict.
   Anything that fails this check gets fixed or moved to Open Questions.

## Output and file safety

Read `references/output-template.md` before finalizing. Edit the original in place only when the
user explicitly targeted that file for modification and a recoverable history such as version
control exists. Otherwise write a clearly named sibling or user-specified output and leave the
source untouched. Report the actual path and whether the original changed.

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
- Not a fresh composition — verified-true content is preserved, not paraphrased.
- Not a guess-based repair shop — replacement text must trace to a verified authority.
- Not silent — nothing from the old document disappears without a line in the disposition table.

## Common Mistakes

- Writing before the anchor is explicit — the rewrite inherits guesses instead of conclusions.
- Judging blocks by smell instead of checking them — checkable claims get checked.
- Passing a list wholesale — a list passes only when every item in it passed individually.
- Skipping the frame because it "looks structural" — stale frontmatter/YAML metadata fails and
  gets removed like any other block.
- Repairing a failing block from intuition. Delete it or replace it from a cited authority.
- Deleting without citing the check that failed; a Delete verdict is earned, not asserted.
- Treating "it was discussed once" as consensus; only the latest standing decision counts.
- Silently dropping blocks instead of recording a Delete verdict.
- Rewriting Keep blocks anyway and destroying the author's voice.
