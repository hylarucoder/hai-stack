import test from "node:test";
import assert from "node:assert/strict";
import { mkdtemp, writeFile, readFile, rm } from "node:fs/promises";
import { tmpdir } from "node:os";
import path from "node:path";
import { fileURLToPath } from "node:url";
import { promisify } from "node:util";
import { execFile } from "node:child_process";

const exec = promisify(execFile);
const renderer = fileURLToPath(new URL("../skills/hai-visual-explainer/scripts/render_report.mjs", import.meta.url));
const run = (...args) => exec(process.execPath, [renderer, ...args], { timeout: 30_000 });
const dimensions = async (file) => {
  const png = await readFile(file);
  assert.equal(png.subarray(1, 4).toString(), "PNG");
  return [png.readUInt32BE(16), png.readUInt32BE(20)];
};

test("unified renderer preserves card and report behavior", async (t) => {
  const dir = await mkdtemp(path.join(tmpdir(), "hai-render # "));
  try {
    const html = path.join(dir, "input # card.html");
    await writeFile(html, '<style>body{margin:0}.card{width:620px;max-width:100%;height:180px;background:#f5f3ed}.tail{height:1200px}</style><div class="card">Render fixture</div><div class="tail"></div>');
    await t.test("default report captures full page and preserves positional output", async () => {
      const out = path.join(dir, "report.png");
      await run(html, out);
      assert.deepEqual(await dimensions(out), [1440, 1380]);
    });
    await t.test("card measures element width and renders at 2x", async () => {
      await run(html, "--mode", "card");
      assert.deepEqual(await dimensions(html.replace('.html', '.png')), [1240, 360]);
    });
    await t.test("custom selector and viewport width", async () => {
      const out = path.join(dir, "custom.png");
      await run(html, out, "--mode", "card", "--selector", ".card", "--width", "400");
      assert.deepEqual(await dimensions(out), [800, 360]);
    });
    await t.test("missing selector and page errors fail", async () => {
      await assert.rejects(run(html, "--mode", "card", "--selector", ".missing"), /Expected one element/);
      const bad = path.join(dir, "error.html");
      await writeFile(bad, '<script>throw new Error("fixture failure")</script>');
      for (const mode of ["report", "card"]) {
        await assert.rejects(run(bad, "--mode", mode), /Page error: fixture failure/);
      }
    });
    await t.test("waits for diagram SVG and rejects incomplete rendering", async () => {
      const diagram = path.join(dir, "diagram.html");
      await writeFile(diagram, '<div class="mermaid"></div><script>setTimeout(()=>document.querySelector(".mermaid").innerHTML=\'<svg width="100" height="80"></svg>\', 800)</script>');
      await run(diagram);
      assert.deepEqual(await dimensions(diagram.replace('.html', '.preview.png')), [1440, 1000]);
      await writeFile(diagram, '<div class="mermaid">unrendered graph</div>');
      await assert.rejects(run(diagram), /Timeout/);
    });
    await t.test("rejects invalid options and source overwrite", async () => {
      await assert.rejects(run(html, "--mode", "unknown"), /Unknown mode/);
      await assert.rejects(run(html, "--width", "400junk"), /positive integer/);
      await assert.rejects(run(html, html), /must not overwrite/);
    });
  } finally {
    await rm(dir, { recursive: true, force: true });
  }
});
