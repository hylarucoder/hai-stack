#!/usr/bin/env node
import { chromium } from "playwright";
import path from "node:path";

const htmlPath = process.argv[2];
if (!htmlPath) {
  console.error("Usage: node render_report.mjs <html-file> [output-png]");
  process.exit(1);
}

const absoluteHtml = path.resolve(htmlPath);
const outputPath = path.resolve(
  process.argv[3] || absoluteHtml.replace(/\.html?$/i, ".preview.png"),
);

const browser = await chromium.launch();
try {
  const page = await browser.newPage({
    viewport: { width: 1440, height: 1000 },
    deviceScaleFactor: 1,
  });
  const pageErrors = [];
  page.on("pageerror", (error) => pageErrors.push(error.message));
  await page.goto(`file://${absoluteHtml}`, { waitUntil: "networkidle" });
  const mermaidCount = await page.locator(".mermaid").count();
  if (mermaidCount > 0) {
    await page.waitForFunction(
      () => [...document.querySelectorAll(".mermaid")].every((node) => node.querySelector("svg")),
      null,
      { timeout: 10_000 },
    );
  }
  if (pageErrors.length > 0) {
    throw new Error(`Page error: ${pageErrors.join(" | ")}`);
  }
  await page.screenshot({ path: outputPath, fullPage: true });
  console.log(outputPath);
} finally {
  await browser.close();
}
