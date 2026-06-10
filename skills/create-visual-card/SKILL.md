---
name: create-visual-card
description: |
  Generate a magazine-quality visual card as a single self-contained HTML file (embedded CSS, Swiss-grid + bold-type design system), then screenshot it to a shareable PNG and hand back both files. Use this whenever the user wants content turned into a visually rich card or shareable image — even if they don't say the word "card." Triggers: make/create/generate/design a visual card, info card, knowledge card, quote card, social card, summary/takeaway/cheatsheet card; 信息卡, 知识卡片, 金句卡, 语录卡, 做张卡片, 设计一张卡片, 把这段内容做成卡片, 把要点排成一张图, 总结成一张图, 小红书封面, 公众号封面图, 朋友圈配图. Prefer this over generic HTML/frontend skills when the goal is one decorative card image. When the content is a multi-section report instead of a single card, use hai-visual-report.
---

# Create Visual Card

Generate magazine-quality visual information cards as self-contained HTML files, then render them to a shareable PNG.

## Output

A single `.html` file with embedded CSS, rendered to a `.png`. The card width must equal the screenshot width argument (default **1024px**) so the `.card` element fills the frame with no uneven margins — keep `.card { width }`, the screenshot command's width arg, and this value in sync.

For the final handoff format, read `references/output-template.md` after generating and checking the card, and fill every field it lists.

## Design System

The font `<link>`, `:root` color variables, and noise-texture SVG live in the **Template Skeleton** below (the copy-pasteable artifact). This section holds only the decisions the skeleton can't encode: type scale, spacing, and density intent.

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
3. Write complete HTML with embedded CSS to the workspace, starting from the Template Skeleton.
4. Screenshot the `.card` element using the bundled script (path is relative to this skill's directory):
   ```bash
   node scripts/screenshot.mjs <file>.html .card 1024
   ```
   It uses Playwright to open the file directly (no server), renders at 2x DPR, writes `<file>.png` next to the HTML, and prints that path to stdout — capture it for the handoff. If chromium is missing, run `npx playwright install chromium` first.
5. Present the PNG to the user inline and provide the absolute HTML and PNG paths.
6. Self-check against the four QA items in `references/output-template.md` (screenshot generated, body text ≥ 18px, mobile readability, visual hierarchy) — it is the single source of truth for the handoff.

## Template Skeleton

Start from this. The card width is **1024px** to match the screenshot width arg (step 4).

```html
<!DOCTYPE html>
<html lang="zh-CN">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link href="https://fonts.googleapis.com/css2?family=Noto+Serif+SC:wght@700;900&family=Noto+Sans+SC:wght@400;500;700&family=Oswald:wght@500;700&family=Inter:wght@400;600;700&display=swap" rel="stylesheet">
<style>
  :root { --color-accent: #d4440f; --color-bg: #f5f3ed; --color-text: #1a1a1a; --color-muted: #555; }
  * { margin: 0; padding: 0; box-sizing: border-box; }
  body { background: var(--color-bg); }
  .card { width: 1024px; max-width: 100%; margin: 0 auto; background: var(--color-bg); padding: 50px; }
  /* noise overlay */
  .card::before { content: ''; position: fixed; inset: 0; opacity: 0.04; pointer-events: none;
    background-image: url("data:image/svg+xml,%3Csvg viewBox='0 0 256 256' xmlns='http://www.w3.org/2000/svg'%3E%3Cfilter id='n'%3E%3CfeTurbulence type='fractalNoise' baseFrequency='0.9' numOctaves='4' stitchTiles='stitch'/%3E%3C/filter%3E%3Crect width='100%25' height='100%25' filter='url(%23n)'/%3E%3C/svg%3E");
  }
  .main-title { font-family: 'Noto Serif SC', serif; font-size: 80px; font-weight: 900; line-height: 1.0; color: #0a0a0a; letter-spacing: -0.04em; }
  .accent-bar { height: 6px; width: 100px; background: var(--color-accent); margin: 10px 0; }
  .body { font-family: 'Inter', 'Noto Sans SC', sans-serif; font-size: 19px; line-height: 1.6; color: var(--color-text); }
  .tag { font-size: 13px; font-weight: 700; letter-spacing: 0.15em; text-transform: uppercase; color: var(--color-muted); }
  .caption { font-size: 15px; line-height: 1.5; color: var(--color-muted); }
</style>
</head>
<body>
<div class="card">
  <!-- build content here -->
</div>
</body>
</html>
```

(`assets/` is intentionally empty — it's where local font fallbacks or bundled images would go if added later; the skeleton currently loads fonts from a CDN.)

## Design Philosophy

Swiss internationalism structure + modern magazine visual impact. Rigorous grid, bold typography, warm paper texture. Every element earns its space.

## Use a different skill when

- The user wants a multi-section / scroll-length **report** (idea, PRD, plan, review turned into a presentation-like web page) → use `hai-visual-report`, not a single card.
- The user wants an interactive page, app, or reusable UI component → use `frontend-design`.
- The user wants a print poster as PNG/PDF (canvas/document output, not a web card) → use `canvas-design`.

Keep create-visual-card scoped to one decorative, single-frame card image.
