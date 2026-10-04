# Card Design

Start from `assets/card-template.html`; its `--card-width` is the canonical width.

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


Swiss internationalism structure + modern magazine visual impact: rigorous grid, bold typography, warm paper texture. Every element earns its space.
