"""Writes the README hero: docs/assets/flow.svg.

Run `python3 docs/assets/make_flow.py` after a skill is added, removed or moved to another stage.
"""

from pathlib import Path
from xml.sax.saxutils import escape

STAGES = [
    ("01 · DECIDE", "判断", "值不值得做", ["hai-idea", "hai-prd"]),
    ("02 · DESIGN", "设计", "系统怎么改", ["hai-architecture", "entity-model-auditor", "hai-naming"]),
    ("03 · BUILD", "动手", "把事做对", ["hai-goal", "hai-tdd", "hai-debug", "hai-ast-grep"]),
    ("04 · VERIFY", "确认", "拿证据确认", ["code-review-and-quality", "write-technical-acceptance-report"]),
    ("05 · RECORD", "沉淀", "留下准确的文档", ["hai-audit-docs", "hai-rewrite-doc", "hai-simplified-technical",
                                         "hai-visual-explainer", "readme-beautifier"]),
]
HIGHLIGHT = 3  # the stage drawn solid: proving the work is done is the point of hai-stack
LENSES = [("geju", "打开格局"), ("goudi", "压实第一步"), ("hai-razor", "剃掉多余的概念")]

THEMES = {
    "light": dict(bg="#FAF9F7", card="#FFFFFF", stroke="#E7E5E4", ink="#1C1917", body="#78716C", faint="#A8A29E",
                  acc="#EA580C", accSoft="#FFF7ED", accLine="#FDBA74", chip="#F5F5F4", chipInk="#292524",
                  hiCard="#1C1917", hiInk="#FFFFFF", hiBody="#D6D3D1", hiChip="#292524", hiChipInk="#FDBA74",
                  bar="#F5F5F4", barInk="#44403C")
}

W, H = 1400, 900
MARGIN, GAP = 48, 36
CARD_W = (W - 2 * MARGIN - 4 * GAP) // 5
CARD_Y, CARD_H = 222, 402
CHIP_CHARS = 18  # 16px monospace in a chip as wide as the card


def wrap(name):
    """Break a skill name after hyphens so that no line is longer than CHIP_CHARS."""
    lines, line = [], ""
    for part in name.split("-"):
        piece = part if not line else "-" + part
        if line and len(line) + len(piece) + 1 > CHIP_CHARS:
            lines.append(line + "-")
            line = part
        else:
            line += piece
    return lines + [line]


def svg(t):
    c = THEMES[t]
    out = [f'<svg xmlns="http://www.w3.org/2000/svg" width="{W}" height="{H}" viewBox="0 0 {W} {H}" role="img" aria-labelledby="title desc">',
           '<title id="title">hai-stack：一次迭代的每一步都有技能接手</title>',
           '<desc id="desc">一次迭代分五步：判断、设计、动手、确认、沉淀，每一步列出接手的技能。geju、goudi、hai-razor 三个纠偏视角在任何一步都能调用。</desc>',
           f'''<defs>
  <marker id="arrow" viewBox="0 0 10 10" refX="8.5" refY="5" markerWidth="7" markerHeight="7" orient="auto-start-reverse"><path d="M 0 0 L 10 5 L 0 10 z" fill="{c['acc']}"/></marker>
  <style>
    text {{ font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", "PingFang SC", "Microsoft YaHei", sans-serif; }}
    .mono {{ font-family: "SF Mono", Menlo, Consolas, "Liberation Mono", monospace; }}
  </style>
</defs>''',
           f'<rect width="{W}" height="{H}" fill="{c["bg"]}"/>']
    T = lambda x, y, s, size, fill, weight=400, cls="", anchor="start", ls=0: out.append(
        f'<text x="{x}" y="{y}" font-size="{size}" font-weight="{weight}" fill="{fill}"'
        + (f' class="{cls}"' if cls else "") + (f' text-anchor="{anchor}"' if anchor != "start" else "")
        + (f' letter-spacing="{ls}"' if ls else "") + f'>{escape(s)}</text>')

    # header
    out.append(f'<rect x="{MARGIN}" y="58" width="40" height="5" rx="2.5" fill="{c["acc"]}"/>')
    T(MARGIN + 56, 66, "HAI-STACK · 软件迭代", 16, c["acc"], 700, ls=1.8)
    T(MARGIN, 122, "一次迭代的每一步，都有技能接手", 38, c["ink"], 700)
    T(MARGIN, 160, "卡在哪一步，就从哪一步进入。每个技能交出能检查的结果，不要求每次走完一圈。", 18, c["body"])

    xs = [MARGIN + i * (CARD_W + GAP) for i in range(5)]
    mid = lambda i: xs[i] + CARD_W / 2

    # the loop back to the next iteration, over the cards
    ly = CARD_Y - 22
    out.append(f'<path d="M {mid(4)} {CARD_Y} L {mid(4)} {ly} L {mid(0)} {ly} L {mid(0)} {CARD_Y - 4}" fill="none" '
               f'stroke="{c["accLine"]}" stroke-width="1.5" stroke-dasharray="5 5" marker-end="url(#arrow)"/>')
    lx = (mid(0) + mid(4)) / 2
    out.append(f'<rect x="{lx - 62}" y="{ly - 13}" width="124" height="26" rx="13" fill="{c["bg"]}"/>')
    T(lx, ly + 5, "进入下一轮", 15, c["acc"], 700, anchor="middle")

    for i, (eyebrow, stage, title, skills) in enumerate(STAGES):
        x, hi = xs[i], i == HIGHLIGHT
        out.append(f'<rect x="{x}" y="{CARD_Y}" width="{CARD_W}" height="{CARD_H}" rx="16" '
                   f'fill="{c["hiCard"] if hi else c["card"]}" stroke="{c["hiCard"] if hi else c["stroke"]}" stroke-width="1.5"/>')
        T(x + 22, CARD_Y + 36, eyebrow, 14, c["hiBody"] if hi else c["faint"], 700, ls=0.6)
        T(x + 22, CARD_Y + 74, stage, 26, c["hiInk"] if hi else c["ink"], 700)
        T(x + 22, CARD_Y + 102, title, 16, c["hiBody"] if hi else c["body"])
        y = CARD_Y + 126
        for name in skills:
            lines = wrap(name)
            h = 14 + 22 * len(lines)
            out.append(f'<rect x="{x + 16}" y="{y}" width="{CARD_W - 32}" height="{h}" rx="8" fill="{c["hiChip"] if hi else c["chip"]}"/>')
            for k, line in enumerate(lines):
                T(x + 28, y + 23 + 22 * k, line, 16, c["hiChipInk"] if hi else c["chipInk"], 600, cls="mono")
            y += h + 8
        if i < 4:
            ay = CARD_Y + CARD_H / 2
            out.append(f'<line x1="{x + CARD_W + 4}" y1="{ay}" x2="{x + CARD_W + GAP - 6}" y2="{ay}" stroke="{c["acc"]}" stroke-width="2" marker-end="url(#arrow)"/>')

    # the lenses, reachable from every stage
    by, bh = CARD_Y + CARD_H + 44, 112
    for i in range(5):
        out.append(f'<line x1="{mid(i)}" y1="{CARD_Y + CARD_H}" x2="{mid(i)}" y2="{by}" stroke="{c["accLine"]}" stroke-width="1.5" stroke-dasharray="4 5"/>')
    out.append(f'<rect x="{MARGIN}" y="{by}" width="{W - 2 * MARGIN}" height="{bh}" rx="16" fill="{c["accSoft"]}" stroke="{c["accLine"]}" stroke-width="1.5"/>')
    T(MARGIN + 28, by + 48, "纠偏视角", 24, c["ink"], 700)
    T(MARGIN + 28, by + 80, "任何一步都能调用", 16, c["body"])
    for k, (name, what) in enumerate(LENSES):
        x = MARGIN + 300 + k * 340
        out.append(f'<circle cx="{x}" cy="{by + bh / 2}" r="7" fill="{c["acc"]}"/>')
        T(x + 22, by + 50, name, 20, c["ink"], 700, cls="mono")
        T(x + 22, by + 80, what, 17, c["body"])

    # principle
    py = by + bh + 34
    out.append(f'<rect x="{MARGIN}" y="{py}" width="{W - 2 * MARGIN}" height="54" rx="12" fill="{c["bar"]}"/>')
    out.append(f'<circle cx="{MARGIN + 28}" cy="{py + 27}" r="6" fill="{c["acc"]}"/>')
    T(MARGIN + 46, py + 33, "原则：原因已知的小 bug 直接 TDD，原因不明先诊断；“做完了”要有实际运行的检查；评审通过不等于授权合并。",
      17, c["barInk"], 700)
    out.append("</svg>")
    return "\n".join(out) + "\n"


if __name__ == "__main__":
    out = Path(__file__).parent / "flow.svg"
    out.write_text(svg("light"), encoding="utf-8")
    print(out)
