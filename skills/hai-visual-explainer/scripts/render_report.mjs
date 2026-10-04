#!/usr/bin/env node
import { chromium } from "playwright";
import path from "node:path";
import { pathToFileURL } from "node:url";

const usage = "Usage: node render_report.mjs <html-file> [output-png] [--mode card|report] [--selector .card] [--width pixels]";
const args = process.argv.slice(2);
const htmlPath = args.shift();
let mode = "report";
let selector;
let width;
let output;
try {
  if (!htmlPath || htmlPath.startsWith("--")) throw new Error(usage);
  while (args.length) {
    const arg = args.shift();
    if (["--mode", "--selector", "--width"].includes(arg)) {
      const value = args.shift();
      if (!value || value.startsWith("--")) throw new Error(`Missing value for ${arg}`);
      if (arg === "--mode") mode = value;
      if (arg === "--selector") selector = value;
      if (arg === "--width") {
        if (!/^\d+$/.test(value) || !Number.isSafeInteger(Number(value)) || Number(value) < 1) {
          throw new Error("Width must be a positive integer");
        }
        width = Number(value);
      }
    } else if (arg.startsWith("--") || output) {
      throw new Error(`Unexpected argument: ${arg}`);
    } else output = arg;
  }
  if (!["card", "report"].includes(mode)) throw new Error(`Unknown mode: ${mode}`);
  if (selector && mode !== "card") throw new Error("--selector requires --mode card");
} catch (error) {
  console.error(error.message);
  process.exit(1);
}

const absoluteHtml = path.resolve(htmlPath);
const suffix = mode === "card" ? ".png" : ".preview.png";
const stem = absoluteHtml.replace(/\.html?$/i, "");
const outputPath = path.resolve(output || stem + suffix);
if (outputPath === absoluteHtml) {
  console.error("Output must not overwrite the source HTML");
  process.exit(1);
}

const browser = await chromium.launch();
try {
  const page = await browser.newPage({
    viewport: { width: width || 1440, height: 1000 },
    deviceScaleFactor: mode === "card" ? 2 : 1,
  });
  const pageErrors = [];
  page.on("pageerror", (error) => pageErrors.push(error.message));
  await page.goto(pathToFileURL(absoluteHtml).href, { waitUntil: "networkidle" });
  if (await page.locator(".mermaid").count()) {
    await page.waitForFunction(
      () => [...document.querySelectorAll(".mermaid")].every((node) => node.querySelector("svg")),
      null,
      { timeout: 10_000 },
    );
  }
  await page.evaluate(() => document.fonts.ready);
  if (pageErrors.length) throw new Error(`Page error: ${pageErrors.join(" | ")}`);

  if (mode === "card") {
    const card = page.locator(selector || ".card");
    if (await card.count() !== 1) throw new Error(`Expected one element: ${selector || ".card"}`);
    const box = await card.boundingBox();
    if (!box || box.width <= 0 || box.height <= 0) throw new Error("Card is not visible or is empty");
    if (!width) await page.setViewportSize({ width: Math.ceil(box.width), height: 1000 });
    await card.screenshot({ path: outputPath, type: "png" });
  } else {
    await page.screenshot({ path: outputPath, fullPage: true });
  }
  if (pageErrors.length) throw new Error(`Page error: ${pageErrors.join(" | ")}`);
  console.log(outputPath);
} finally {
  await browser.close();
}
