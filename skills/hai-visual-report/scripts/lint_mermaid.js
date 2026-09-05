#!/usr/bin/env node
/**
 * Simple Mermaid linter for hai-visual-report HTML files.
 *
 * A zero-dependency static checker: no Puppeteer, no browser, no npm install.
 * It extracts every <pre class="mermaid"> block and runs cheap structural
 * checks that catch the breakage seen most often in generated reports —
 * missing diagram type, unbalanced brackets/quotes, empty blocks — and warns
 * when a diagram is dense enough that the skill's "split if dense" rule applies.
 *
 * This does NOT guarantee Mermaid will render (only the real parser does).
 * It is a fast pre-flight gate to run before delivering a report.
 *
 * Usage:
 *   node lint_mermaid.js <file.html | dir> [...more]
 *   node lint_mermaid.js report.html
 *   node lint_mermaid.js $TMPDIR/hai-visual-report-foo/
 *
 * Exit code: 0 if no errors (warnings allowed), 1 if any error.
 */

const fs = require("fs");
const path = require("path");

// First token Mermaid accepts as a diagram declaration.
const DIAGRAM_TYPES = [
  "flowchart", "graph", "sequenceDiagram", "classDiagram", "stateDiagram",
  "stateDiagram-v2", "erDiagram", "journey", "gantt", "pie", "quadrantChart",
  "requirementDiagram", "gitGraph", "mindmap", "timeline", "sankey-beta",
  "xychart-beta", "block-beta", "C4Context",
];

const DENSE_EDGE_THRESHOLD = 24; // edges above this → "split if dense" warning

function extractBlocks(html, file) {
  const blocks = [];
  const re = /<pre\s+class="mermaid"[^>]*>([\s\S]*?)<\/pre>/gi;
  let m;
  while ((m = re.exec(html)) !== null) {
    const line = html.slice(0, m.index).split("\n").length;
    blocks.push({ file, line, text: m[1].replace(/^\n+|\n+$/g, "") });
  }
  return blocks;
}

function checkBlock(text) {
  const errors = [];
  const warnings = [];

  const trimmed = text.trim();
  if (!trimmed) {
    errors.push("empty mermaid block");
    return { errors, warnings };
  }

  // 1. Must declare a known diagram type on the first meaningful line.
  const firstLine = trimmed.split("\n").find((l) => l.trim() && !l.trim().startsWith("%%"));
  const firstToken = (firstLine || "").trim().split(/\s+/)[0];
  if (!DIAGRAM_TYPES.includes(firstToken)) {
    errors.push(`unknown or missing diagram type: "${firstToken || ""}"`);
  }

  // 2. Balanced brackets/parens/braces (ignoring those inside quotes).
  const stripped = trimmed.replace(/"[^"]*"/g, "").replace(/'[^']*'/g, "");
  for (const [open, close, name] of [["[", "]", "[]"], ["(", ")", "()"], ["{", "}", "{}"]]) {
    const o = (stripped.match(new RegExp("\\" + open, "g")) || []).length;
    const c = (stripped.match(new RegExp("\\" + close, "g")) || []).length;
    if (o !== c) errors.push(`unbalanced ${name} (${o} open, ${c} close)`);
  }

  // 3. Even number of double quotes.
  const quotes = (trimmed.match(/"/g) || []).length;
  if (quotes % 2 !== 0) errors.push(`odd number of double-quotes (${quotes})`);

  // 4. Unquoted "/" inside a node/edge label → Mermaid syntax error.
  //    A slash in label text must be quoted: ["Timeline / Phases"] or the entity #47;.
  //    Skip %% comment lines and parallelogram/trapezoid shapes ([/text/], [\text\]),
  //    where a leading/trailing slash is a shape delimiter, not label text.
  const labelRe = /\[([^\[\]]*)\]|\(([^()]*)\)|\{([^{}]*)\}|\|([^|]*)\|/g;
  for (const line of trimmed.split("\n")) {
    if (line.trim().startsWith("%%")) continue;
    let lm;
    while ((lm = labelRe.exec(line)) !== null) {
      const content = (lm[1] ?? lm[2] ?? lm[3] ?? lm[4] ?? "").trim();
      if (!content.includes("/")) continue;
      if (content.startsWith('"') && content.endsWith('"')) continue; // quoted is safe
      const inner = content.replace(/^[/\\]/, "").replace(/[/\\]$/, ""); // drop shape markers
      if (inner.includes("/")) {
        errors.push(`unquoted "/" in label "${content}" — wrap it in double-quotes (e.g. ["a / b"]) or use the entity #47;`);
        break;
      }
    }
  }

  // 5. Density heuristic → "split if dense".
  const edges = (trimmed.match(/--+>|--+|==+>|-\.->|\.\.>/g) || []).length;
  if (edges > DENSE_EDGE_THRESHOLD) {
    warnings.push(`dense diagram (~${edges} edges) — consider splitting per the skill's QA rule`);
  }

  return { errors, warnings };
}

function collectHtml(input) {
  const stat = fs.existsSync(input) ? fs.statSync(input) : null;
  if (!stat) return [];
  if (stat.isFile()) return input.endsWith(".html") ? [input] : [];
  // shallow + recursive directory walk, no glob dependency
  const out = [];
  for (const entry of fs.readdirSync(input, { withFileTypes: true })) {
    const full = path.join(input, entry.name);
    if (entry.isDirectory()) out.push(...collectHtml(full));
    else if (entry.isFile() && entry.name.endsWith(".html")) out.push(full);
  }
  return out;
}

function main() {
  const inputs = process.argv.slice(2);
  if (inputs.length === 0) {
    console.error("Usage: node lint_mermaid.js <file.html | dir> [...]");
    process.exit(1);
  }

  const files = [...new Set(inputs.flatMap((i) => collectHtml(path.resolve(i))))].sort();
  if (files.length === 0) {
    console.error("No .html files found for:", inputs.join(", "));
    process.exit(1);
  }

  let total = 0, errorCount = 0, warnCount = 0;
  for (const file of files) {
    const rel = path.relative(process.cwd(), file);
    const blocks = extractBlocks(fs.readFileSync(file, "utf8"), file);
    for (const b of blocks) {
      total++;
      const { errors, warnings } = checkBlock(b.text);
      if (errors.length === 0 && warnings.length === 0) {
        console.log(`OK   ${rel}:${b.line}`);
      }
      for (const e of errors) {
        errorCount++;
        console.error(`ERR  ${rel}:${b.line}: ${e}`);
      }
      for (const w of warnings) {
        warnCount++;
        console.warn(`WARN ${rel}:${b.line}: ${w}`);
      }
    }
  }

  if (total === 0) {
    console.log("No Mermaid diagrams found.");
    process.exit(0);
  }

  console.error(
    `\nSummary: ${total} diagram(s), ${errorCount} error(s), ${warnCount} warning(s).`
  );
  process.exit(errorCount > 0 ? 1 : 0);
}

main();
