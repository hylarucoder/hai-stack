---
name: create-visual-card
description: |
  Creates one decorative, single-frame visual card from supplied content as self-contained HTML and a shareable PNG. Use for information, quote, knowledge, social, summary, or cover cards, including “把要点做成一张图” and “做张卡片”. Use hai-visual-report for multi-section or scroll-length reports; use an available frontend or document-design skill for interactive pages or print artifacts.
---

# Create Visual Card

Generate magazine-quality visual information cards as self-contained HTML files, then render them to a shareable PNG.

## Output

A single `.html` file with embedded CSS, rendered to a `.png`. Start from
`assets/card-template.html`; its `--card-width` value is the canonical width and the screenshot
script reads the rendered element width automatically.

For the final handoff format, read `references/output-template.md` after generating and checking the card, and fill every field it lists.

## Design System

The font link, color variables, width, and noise texture live in `assets/card-template.html`. The
guidance below covers only choices that vary by content.

### Type Scale

| Role        | Size       | Weight | Notes                              |
|-------------|------------|--------|------------------------------------|
| Super title | 72-84px    | 900    | Core visual hook, lh: 1.0, ls: -0.04em |
| Section     | 56px       | 700    | lh: 1.1                            |
| Sub section | 32px       | 700    | lh: 1.2                            |
| Body        | 18-20px    | 400    | lh: 1.6, color: #1a1a1a           |
| Caption     | 15-16px    | 400    | lh: 1.5, color: #555              |
| Tag/meta    | 13px       | 700    | ls: 0.15em, uppercase              |

### Spacing

- Container padding: 40-50px
- Paragraph gap: ≤ 1.5em
- Component gap: 30-40px

### Visual Decorations

- Noise texture: SVG data-URI at 4% opacity (in skeleton)
- Heavy divider: 4-6px solid bar in accent color, width ~100px
- Background blocks: `rgba(0,0,0,0.03)`
- Base background: `#f5f3ed` (warm paper)

## Layout Strategy

Pick layout by content density — this drives the whole composition:

**Low density** (few key points): "Big character" — blow up titles to 80px+, core data to 120px+. Let typography be the design.

**Medium density**: Balanced sections with accent bars and background blocks.

**High density** (lots of data): Multi-column newspaper grid, 2-3 columns, vertical dividers.

## Workflow

1. Analyze content density (high/medium/low) in one sentence.
2. Choose layout strategy based on density (see Layout Strategy above).
3. Copy `assets/card-template.html` to the requested workspace location and fill in the content.
4. Screenshot the `.card` element using the bundled script (path is relative to this skill's directory):
   ```bash
   node scripts/screenshot.mjs <file>.html .card
   ```
   It uses Playwright to open the file directly, reads the rendered card width, renders at 2x DPR,
   writes `<file>.png` next to the HTML, and prints that path. If Chromium is missing, run
   `npx playwright install chromium` first.
5. Present the PNG to the user inline and provide the absolute HTML and PNG paths.
6. Self-check against the four QA items in `references/output-template.md` (screenshot generated, body text ≥ 18px, mobile readability, visual hierarchy) — it is the single source of truth for the handoff.

## Design Philosophy

Swiss internationalism structure + modern magazine visual impact. Rigorous grid, bold typography, warm paper texture. Every element earns its space.

## Use a different skill when

- The user wants a multi-section / scroll-length **report** (idea, PRD, plan, review turned into a presentation-like web page) → use `hai-visual-report`, not a single card.
- The user wants an interactive page, app, or reusable UI component → use an available frontend-building skill.
- The user wants a print poster or document artifact → use an available document or image-design skill.

Keep create-visual-card scoped to one decorative, single-frame card image.
