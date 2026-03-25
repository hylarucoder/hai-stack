#!/usr/bin/env node
// Info card screenshot tool - no server needed
import { chromium } from 'playwright';
import path from 'path';
import fs from 'fs';

const htmlPath = process.argv[2];
if (!htmlPath) { console.error('Usage: node screenshot.mjs <html-file> [selector] [width]'); process.exit(1); }
const selector = process.argv[3] || 'body';
const width = parseInt(process.argv[4]) || 1024;

(async () => {
  const browser = await chromium.launch();
  const page = await browser.newPage({ viewport: { width, height: 800 }, deviceScaleFactor: 2 });
  await page.goto('file://' + path.resolve(htmlPath), { waitUntil: 'networkidle' });
  const el = await page.$(selector);
  if (!el) { console.error('Selector not found:', selector); process.exit(1); }
  const buf = await el.screenshot({ type: 'png' });
  const outPath = htmlPath.replace(/\.html?$/i, '.png');
  fs.writeFileSync(outPath, buf);
  console.log(outPath);
  await browser.close();
})();
