# HTML Architecture Report — Standard Structure

Read this only when the user asks for an HTML architecture report. For verbal/markdown reviews, use the canonical skeleton in `SKILL.md` (Output section) and `references/output-template.md` instead.

Write the artifact to a system temporary directory, not the repository. Prefer `$TMPDIR` when available; otherwise `/tmp`. Use a disposable subdirectory such as `$TMPDIR/<project-or-topic>-architecture-review/`.

The report should:

- Start with a simple overall architecture map before any issue sections.
- Use Mermaid diagrams for architecture flows when useful.
- Include before/after diagrams for each major recommendation.
- Organize each major section around: current state, problem, solution, benefit.
- Include Deep Module analysis, why-not alternatives, and red/blue adversarial review.
- Prefer Tailwind utility classes for layout and styling. Avoid large custom CSS and avoid project-local assets unless requested.

## Standard Structure

Use this structure unless the user asks for a different layout:

1. **Header** — Report title; scope in one paragraph; generation date; artifact location note (system temporary directory).

2. **Verdict** — One concise conclusion; the most important architectural pain point; the recommended direction in one callout.

3. **Architecture Map First** — A simple Mermaid map of the current chain before any findings. Show actors/modules, dependency direction, state/data flow, and current boundary assumptions. If there are multiple plausible approaches, show where option A/B/C would change the map.

4. **Boundary** — State the large module, ownership boundary, or call chain being reviewed. State assumptions. If the boundary is ambiguous, ask the user before producing the full report.

5. **Review Lenses** — List the 3-6 selected architecture lenses (from the menu in `SKILL.md`) and why each matters for this scope. Do not present every lens mechanically.

6. **Painful Center** — Identify the highest-leverage complexity source. Explain why easier smells are secondary. Tie the pain point back to the architecture map.

7. **Options Matrix** — At least two viable options. For nontrivial changes, include a conservative and a stronger option. Compare by boundary clarity, module depth, current-needs fit, change amplification, migration cost, and risk. Explicitly state the recommended option.

8. **Finding Sections** — Each major finding is a large section containing: current state; problem; solution; benefit; before Mermaid diagram; after Mermaid diagram; why-not alternatives; red team attack; blue team defense; residual risk. Prefer 2-4 high-leverage findings over many shallow findings.

9. **Recommended Change Order** — Step-by-step implementation order; why this step comes first; why not the obvious alternative order; suggested validation commands or checks.

10. **Evidence Reviewed** — Files, packages, docs, schemas, and call chains actually read, plus the searches actually run (this is the output of the evidence gate in `SKILL.md`). Keep it factual; do not hide unsupported assumptions.

## Layout

- Use a constrained max width such as `max-w-7xl`.
- Use Tailwind grid layouts for side-by-side comparisons.
- Use cards only for repeated findings, comparison panels, and callouts.
- Keep diagrams readable; avoid putting too much detail into one Mermaid graph.
- Use Chinese labels when the user asked in Chinese and English labels when the user asked in English. Keep code identifiers unchanged.
