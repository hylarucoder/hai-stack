---
name: visual-card
description: Generate high-quality visual cards as self-contained HTML. Use when the user asks to create a visual card, info card, 信息卡, design card, social card, or any visually rich HTML summary of content. Triggers on phrases like "make a visual card", "信息卡", "设计一张卡片", "create a visual card", "generate a visual card".
---

# Visual Card Generator

Generate magazine-quality visual information cards as self-contained HTML files.

## Output

A single `.html` file with embedded CSS. Width: 1024px. After writing the HTML, screenshot it using the bundled Playwright script and send the PNG image to the user.

## Design System

### Fonts

```html
<link href="https://fonts.googleapis.com/css2?family=Noto+Serif+SC:wght@700;900&family=Noto+Sans+SC:wght@400;500;700&family=Oswald:wght@500;700&family=Inter:wght@400;600;700&display=swap" rel="stylesheet">
```

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

- Noise texture: `background-image: url("data:image/svg+xml,...")` at 4% opacity
- Heavy divider: 4-6px solid bar in accent color, width ~100px
- Background blocks: `rgba(0,0,0,0.03)`
- Base background: `#f5f3ed` (warm paper)

### Core CSS Variables

```css
:root {
  --color-accent: #d4440f;
  --color-bg: #f5f3ed;
  --color-text: #1a1a1a;
  --color-muted: #555;
}
```

## Layout Strategy

**Low density** (few key points): "Big character" — blow up titles to 80px+, core data to 120px+. Let typography be the design.

**Medium density**: Balanced sections with accent bars and background blocks.

**High density** (lots of data): Multi-column newspaper grid, 2-3 columns, vertical dividers.

## Workflow

1. Analyze content density (high/medium/low) in one sentence.
2. Choose layout strategy based on density.
3. Write complete HTML with embedded CSS to workspace.
4. Screenshot the `.card` element using the bundled script:
   ```bash
   node <workspace>/scripts/screenshot.mjs <file>.html .card 1024
   ```
   This uses Playwright to open the file directly (no server needed), renders at 2x DPR, and outputs a PNG.
5. Send the PNG to the user via the `message` tool.
6. Self-check: body text ≥ 18px, readable on mobile.

## Template Skeleton

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
  .card { width: 900px; max-width: 100%; margin: 0 auto; background: var(--color-bg); padding: 50px; }
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

## Design Philosophy

Swiss internationalism structure + modern magazine visual impact. Rigorous grid, bold typography, warm paper texture. Every element earns its space.
