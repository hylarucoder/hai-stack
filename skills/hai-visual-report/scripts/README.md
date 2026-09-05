# Visual Report QA Scripts

## `lint_mermaid.js`

A zero-dependency static pre-flight for `<pre class="mermaid">` blocks.

```bash
node scripts/lint_mermaid.js <file.html | directory> [...more]
```

It reports errors for missing diagram types, unbalanced delimiters or quotes, empty blocks, and
unsafe unquoted slash labels. It warns on dense diagrams. Passing static checks does not prove the
diagram renders.

## `render_report.mjs`

The browser-backed proof step. It opens the HTML through Playwright, waits for every Mermaid block
to contain rendered SVG, fails on page errors, and writes a full-page PNG for visual inspection.

```bash
node scripts/render_report.mjs <file.html> [output.png]
```

Install the optional tooling from the repository root first:

```bash
npm install
npx playwright install chromium
```

Use both steps: static lint catches common authoring mistakes quickly; browser rendering catches CDN,
parser, layout, and visual failures that static heuristics cannot prove away.
