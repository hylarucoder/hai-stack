---
name: readme-beautifier
description: |
  Produces a restructured, consistently formatted, professional-looking README (or similar markdown project doc such as CONTRIBUTING.md, docs/index.md, 项目说明.md) plus a short change summary — content untouched: nothing added, nothing removed, only structure and formatting fixed (heading hierarchy, lists, code blocks, tables, spacing). Use whenever the user asks to beautify, tidy, reorganize, reformat, format, or fix a README — and be pushy: fire even when the user just dumps a messy README and says 太乱了 / 看下 / 帮我弄一下, without ever saying "beautify". Triggers: 美化 README, README 美化, 整理 README, README 排版, README 格式化, README 太乱了, 看下我这个 README, beautify README, fix/format/clean up/tidy/polish/reformat README, reorganize readme, my readme looks messy/ugly, make my README look professional.
---

# Readme Beautifier

## Overview

Take a README whose structure is messy or whose formatting is inconsistent, and deliver a version with clear structure, consistent formatting, and a professional look.

## Core Principles

- **Content unchanged — nothing added, nothing removed**: do not invent information, do not delete valid content; improve only at the structure and formatting level.
- **Faithful to the original meaning**: preserve the author's intent and tone; do not rewrite for style.
- **Minimal change**: prefer a small fix over a big one; prefer adjusting formatting over rewriting.
- **Respect the original; never force-fit**: keep every reasonable choice the original already made (section order, whether to include badges / a TOC / spaces between Chinese and English), and do not proactively add what is missing — apply the checklist below under this principle instead of restating it per item.

## Workflow

```
1. Read the README → understand what the project is and who it is for
2. Diagnose problems → check every item in the checklist below
3. Plan the changes → list what to change and why
4. Apply the beautification
5. Deliver the summary
```

Deliver steps 4 and 5 in the format defined under "Output" below.

## Checklist

Ordered from highest to lowest priority. Fix an item only when the problem actually exists.

### 1. Heading hierarchy

- Use h1 exactly once, for the project name.
- Keep levels consecutive — never skip (h1 → h3 is wrong).
- Align granularity across same-level headings (do not have one h2 be "Install" and another h2 be "How to mount config files with a Docker volume").

### 2. One-line description

- Place a single sentence right under the project name that says what the project is and does.
- A `>` blockquote or a plain paragraph both work, but it must exist.
- If the original has one buried in the middle, move it to the top.

### 3. Section structure

- Give every section a single clear responsibility; do not mix topics.
- A common sensible order: what it is → quick start → usage → configuration → directory layout → contributing → license.
- Delete empty sections (heading with no content) or add one explanatory sentence.

### 4. List formatting

- Keep item markers uniform within one list (all `-` or all `*`, never mixed).
- Keep nesting indentation consistent (2 spaces or 4 spaces, never mixed).
- Use `1.` auto-numbering for ordered lists instead of manual numbers (avoids renumbering when items are inserted).
- Surround lists with blank lines.

### 5. Code blocks

- Tag every code block with a language (```bash / ```yaml / ```text, etc.).
- Wrap inline code in backticks: commands, file names, variable names, package names.
- Strip unnecessary `$` prefixes from command examples (unless input must be distinguished from output).
- Put multi-line commands in code blocks, not inline code.

### 6. Tables

- Align columns (pixel-perfect alignment is not required, but they should look tidy).
- Make headers meaningful.
- If a table has only two columns of short content, consider whether a list fits better.
- If a list carries three or more parallel dimensions of information, consider whether a table fits better.

### 7. Links and references

- Make link text meaningful (no "click here", no "link").
- Check for obviously broken link formats (`[text]()` empty links, `[text](TODO)` placeholders).
- Check that relative vs absolute paths are used sensibly.

### 8. Whitespace and separation

- Put a blank line before headings.
- Put a blank line between paragraphs.
- Never allow more than two consecutive blank lines.
- Spaces between Chinese and English: if the original mostly has them, fill in the gaps for consistency; if it mostly does not, follow the original.
- Put a blank line between lists and paragraphs.
- End the file with a single newline (no trailing blank lines, no missing newline).

### 9. Badges

- Tidy badges only if the original has them: gather them right below the project name and above the one-line description.
- Separate badges with spaces, no line breaks.

### 10. Table of contents (TOC)

- Suggest adding a TOC when there are more than 6 sections; do not add one at 6 or fewer.
- Build the TOC as a link list pointing to the headings' anchors.
- If the original already has a TOC with broken anchors, repair it rather than delete it.

## Do not

- **Do not add decorative elements**: no emoji, no horizontal rules, no fancy ASCII art, unless the original already has them.
- **Do not change technical content**: do not alter commands, configuration options, or the logic of code examples.
- **Do not translate**: do not turn Chinese into English or the reverse.
- **Do not add content**: if a "Contributing" section is missing, do not auto-create one — only mention in the summary that it could be added.
- **Do not rename the file**: the output stays README.md, never something else.

## Use a different skill when

This skill handles only formatting and structure, never whether the content is correct. Content-level problems are out of scope — this skill never changes meaning. When the user says "check my README", distinguish the intent:

- The user wants to confirm the README matches the code / config / API, or whether it is stale → use **hai-audit-docs-against-code**.
- The user wants an internal-consistency / stale-content audit of the docs themselves (internal contradictions, no code comparison) → use **hai-audit-docs-internally**.
- The user wants the content rewritten around the current conclusions because the doc drifted through rounds of discussion → use **hai-rewrite-doc**.
- The user wants the layout beautified, the formatting unified, the structure straightened out → this skill.

## Output

Normal path: output the complete beautified README content directly, followed by a short summary.

```markdown
<full beautified README.md content>

---

**Beautification summary**

Changed the following:
- ...

Suggested follow-up additions (out of scope for this pass):
- ...
```

For the output format when the README is already clean and needs no changes (the check summary), see the end of [references/output-template.md](references/output-template.md). Both complete delivery templates live in that file — compare against it before finalizing.

## Edge cases

- **Very short README (< 10 lines)**: only fix formatting; do not pad the length.
- **Very long README (> 300 lines)**: fix structural problems first; fix only the most glaring formatting problems.
- **Multilingual README**: beautify only the current file; do not touch other language versions.
- **README is already good**: do not force changes; reply using the "check summary" format at the end of references/output-template.md.
