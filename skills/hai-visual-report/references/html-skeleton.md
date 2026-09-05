# Hai Visual Report — HTML Skeleton

Read this at the start of the write phase. It is a minimal, complete `.html` scaffold for the eight blocks in the Report Content Model (Header, Verdict, Structure Map, Core Sections, Decision Matrix, Timeline / Phases, Risks and Proof, Next Move). These blocks are scaffolding around the content, not a template to compress it into — the Core Sections carry the source's substance (reworded or reformatted for readability, not cut to a summary), and you typically repeat that block once per theme in the document. Fill in the sections; drop a block only with a stated reason.

It uses Tailwind CDN and Mermaid CDN so the file stays a single portable artifact — no build step. Keep the quiet, professional report style; use cards only for repeated findings, options, risks, metrics, or callouts. Use Chinese UI copy for Chinese requests and English for English; keep code identifiers unchanged.

```html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>REPORT TITLE</title>
  <script src="https://cdn.tailwindcss.com"></script>
  <script type="module">
    import mermaid from "https://cdn.jsdelivr.net/npm/mermaid@11/dist/mermaid.esm.min.mjs";
    mermaid.initialize({ startOnLoad: true, theme: "neutral" });
  </script>
</head>
<body class="bg-slate-50 text-slate-800">
  <main class="max-w-5xl mx-auto px-6 py-10 space-y-10">

    <!-- 1. Header -->
    <header class="border-b border-slate-200 pb-6">
      <h1 class="text-3xl font-semibold tracking-tight">REPORT TITLE</h1>
      <p class="mt-2 text-slate-500">Scope · Generated YYYY-MM-DD</p>
    </header>

    <!-- 2. Verdict (optional — only if the SOURCE states a conclusion; surface it, don't author a new summary) -->
    <section class="rounded-lg bg-white border border-slate-200 p-6">
      <h2 class="text-sm font-medium uppercase tracking-wide text-slate-400">Verdict</h2>
      <p class="mt-2 text-xl font-medium">THE SOURCE'S OWN CONCLUSION — OMIT THIS BLOCK IF IT HAS NONE</p>
    </section>

    <!-- 3. Structure Map (reader's coordinate system — keep near the top) -->
    <!-- Mermaid label safety: any label with punctuation MUST be double-quoted, especially "/".
         e.g. C["Timeline / Phases"], never C[Timeline / Phases]. If still broken, use #47; for "/". -->
    <section>
      <h2 class="text-xl font-semibold mb-4">Structure Map</h2>
      <div class="rounded-lg bg-white border border-slate-200 p-6 overflow-x-auto">
        <pre class="mermaid">
flowchart TD
  A["Actor"] --> B["Relationship"]
  B --> C["Outcome / Result"]
        </pre>
      </div>
    </section>

    <!-- 4. Core Sections — repeat once per theme in the source. Carry its substance here.
         Add a visual only when it clarifies a relationship, comparison, sequence, hierarchy,
         or evidence set. -->
    <section>
      <h2 class="text-xl font-semibold mb-4">Source Section Title</h2>
      <div class="rounded-lg bg-white border border-slate-200 p-6 space-y-4">
        <p>Body text carrying this section's substance — key points emphasized, not reduced to a one-liner.</p>
        <!-- + a chart / table / matrix / stepper / callout / checklist that helps the reader navigate this section -->
      </div>
    </section>

    <!-- 5. Decision Matrix -->
    <section>
      <h2 class="text-xl font-semibold mb-4">Decision Matrix</h2>
      <table class="w-full text-left border-collapse">
        <thead>
          <tr class="border-b border-slate-300 text-slate-500">
            <th class="py-2 pr-4">Option</th><th class="py-2 pr-4">Cost</th>
            <th class="py-2 pr-4">Value</th><th class="py-2">Risk</th>
          </tr>
        </thead>
        <tbody>
          <tr class="border-b border-slate-100"><td class="py-2 pr-4">A</td><td></td><td></td><td></td></tr>
        </tbody>
      </table>
    </section>

    <!-- 6. Timeline / Phases (when execution is involved) -->
    <section>
      <h2 class="text-xl font-semibold mb-4">Timeline / Phases</h2>
      <ol class="space-y-3">
        <li class="rounded-lg bg-white border border-slate-200 p-4"><span class="font-medium">Phase 1</span> — exit proof / next step</li>
      </ol>
    </section>

    <!-- 7. Risks and Proof -->
    <section>
      <h2 class="text-xl font-semibold mb-4">Risks and Proof</h2>
      <div class="grid gap-4 sm:grid-cols-2">
        <div class="rounded-lg bg-white border border-slate-200 p-4">
          <p class="font-medium">Risk</p>
          <p class="text-sm text-slate-500">Validation method · pass/fail signal</p>
        </div>
      </div>
    </section>

    <!-- 8. Next Move -->
    <section class="rounded-lg bg-slate-900 text-slate-50 p-6">
      <h2 class="text-sm font-medium uppercase tracking-wide text-slate-400">Next Move</h2>
      <p class="mt-2 text-lg">EXPLICIT NEXT ACTION</p>
    </section>

  </main>
</body>
</html>
```
