#!/usr/bin/env node
// Visual card screenshot tool - no server needed
import { chromium } from 'playwright';
import path from 'path';
import fs from 'fs';

const htmlPath = process.argv[2];
if (!htmlPath) { console.error('Usage: node screenshot.mjs <html-file> [selector] [width]'); process.exit(1); }
const selector = process.argv[3] || 'body';
const requestedWidth = Number.parseInt(process.argv[4], 10);

(async () => {
  const browser = await chromium.launch();
  try {
    const page = await browser.newPage({ viewport: { width: requestedWidth || 1440, height: 800 }, deviceScaleFactor: 2 });
    await page.goto('file://' + path.resolve(htmlPath), { waitUntil: 'networkidle' });
    const el = await page.$(selector);
    if (!el) throw new Error(`Selector not found: ${selector}`);
    if (!requestedWidth) {
      const box = await el.boundingBox();
      if (!box) throw new Error(`Selector is not visible: ${selector}`);
      await page.setViewportSize({ width: Math.ceil(box.width), height: 800 });
    }
    const buf = await el.screenshot({ type: 'png' });
    const outPath = htmlPath.replace(/\.html?$/i, '.png');
    fs.writeFileSync(outPath, buf);
    console.log(outPath);
  } finally {
    await browser.close();
  }
})();
