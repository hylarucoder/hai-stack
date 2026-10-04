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
to contain rendered SVG, fails on page errors, and writes a PNG for visual inspection. Report mode captures the full page at 1x DPR; card mode
captures one element at 2x DPR and uses its measured width unless overridden. Both wait for fonts.

```bash
node scripts/render_report.mjs <file.html> [output.png] --mode report
node scripts/render_report.mjs <file.html> [output.png] --mode card [--selector .card] [--width 1024]
```

The default mode is report, preserving the existing positional command. Default output names are
`<file>.preview.png` for reports and `<file>.png` for cards. `--selector` is card-only and must
match exactly one visible element. Paths with spaces or URL-special characters are supported.

Install the optional tooling from the repository root first:

```bash
npm install
npx playwright install chromium
```

Use both steps: static lint catches common authoring mistakes quickly; browser rendering catches CDN,
parser, layout, and visual failures that static heuristics cannot prove away.

From the repository root, run `npm run test:renderers` for browser-backed regression checks of
card/report dimensions, selectors, page errors, diagram readiness, and invalid arguments.
