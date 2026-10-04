#!/usr/bin/env python3
"""Mechanical checks for simplified technical English and Chinese.

Usage: check.py FILE... (or - for stdin) [--lang auto|en|zh]

Rule numbers refer to references/rules-en.md and references/rules-zh.md, which share one
numbering. With --lang auto (the default) each line is checked as Chinese when it has at
least as many CJK characters as Latin words, and as English when it has no CJK characters.

Prints one line per hit: path:line: [rule level] message: snippet
Fenced code blocks, inline code, URLs and table separator rows are skipped; inline code
counts as one word. Quoted words ("…") are treated as examples, not violations.
A hit is a place to look at, not a verdict: a soft rule may stay when there is a reason.
Exit status: 1 if any hard-rule hit, else 0. Standard library only; Python 3.8+.
"""
import re
import sys

CJK = '一-鿿㐀-䶿'
C = f'[{CJK}]'
I = re.IGNORECASE

# (rule, level, message, pattern, flags)
ZH_WORDS = [
    ('1.4', 'hard', '含糊词，写成数字、名称或条件',
     r'适当|有关的|一定程度上?|较为|基本上|基本(?=[无不没都])|若干|显著|大幅|明显', 0),
    ('1.4', 'soft', '"相关"常是含糊词，写出是哪些', r'相关(?![系性])', 0),
    ('3.1', 'hard', '包装动词，把名词改回动词', r'进行|加以|予以|做出|实现了?对[^。；，]{1,20}的', 0),
    ('3.3', 'soft', '陈述事实不用"正在"', r'正在', 0),
    ('3.4', 'hard', '写要求只用 应/不应/宜/不宜/可/不必（不是要求时可保留）', r'必须|务必|最好|尽量|建议', 0),
    ('9.4', 'soft', '套话，写出具体做了什么',
     r'开箱即用|无缝|一劳永逸|飞跃|极致|赋能|抓手|闭环|全方位|强大的', 0),
]
ZH_PUNCT = [
    ('8.1', 'hard', '中文旁用了半角标点', rf'{C}[,;:?!]|[,;:?!]{C}|{C}\(|\){C}', 0),
    ('8.3', 'hard', '中文和英文、数字之间缺空格', rf'{C}[A-Za-z0-9]|[A-Za-z0-9]{C}', 0),
    ('8.6', 'hard', '范围用"–"，不用"~"', r'\d\s*[~～]\s*\d', 0),
]
EN_WORDS = [
    ('1.4', 'hard', 'vague word: give a number, a name or a condition',
     r'\b(appropriate(ly)?|relevant|various|significant(ly)?|substantial(ly)?|a number of|'
     r'reasonabl[ey]|fairly|quite|somewhat|basically|essentially)\b', I),
    ('1.4', 'soft', 'possibly vague: say how many', r'\b(several|many|a few|some)\b', I),
    ('3.1', 'hard', 'wrapper verb: turn the noun back into the verb',
     r'\b(perform(s|ed|ing)?|carr(y|ies|ied|ying) out|conduct(s|ed|ing)?)\b|'
     r'\b(make|makes|made|give|gives|gave) (an?|the) \w+(ion|ment|ance|ence)\b', I),
    ('3.2', 'soft', 'passive voice: name who does it',
     r'\b(is|are|was|were|be|been|being)\s+(\w+ed|built|done|made|sent|written|run|set|kept|held|'
     r'found|given|taken|shown|known|seen|thrown|chosen|broken|stored)\b', I),
    ('3.3', 'soft', 'progressive form: state facts in the simple tense',
     r'\b(is|are|was|were)\s+(being\s+)?\w{3,}ing\b', I),
    ('3.4', 'hard', 'requirement words: use must / must not / should / should not / can / need not',
     r'\b(needs? to|ha(ve|s) to|make sure|ensure that|ideally|try to|it is recommended|recommended to)\b', I),
    ('9.4', 'soft', 'filler or marketing word: state the fact',
     r'\b(simply|just|easily|obviously|clearly|seamless(ly)?|leverag(e|es|ed|ing)|out of the box|'
     r'under the hood|robust|powerful|game.?chang\w*|cutting.?edge|best.in.class|blazing(ly)?|please)\b', I),
    ('9.7', 'soft', 'Latin abbreviation: write "for example", "that is", "and so on", "through"',
     r'(?<!\w)(e\.g\.|i\.e\.|etc\.|via|vs\.?)(?!\w)', I),
    ('9.7', 'soft', 'contraction: write the full form', r"\b\w+(n['’]t|['’]re|['’]ve|['’]ll)\b", I),
    ('8.9', 'soft', '"and/or": say which', r'\band/or\b', I),
]
EN_PUNCT = [
    ('8.1', 'hard', 'full-width punctuation in English text', r'[，。；：？！（）、]', 0),
    ('8.5', 'soft', 'space between a number and its unit', r'\b\d+(\.\d+)?(ms|s|min|h|KB|MB|GB|TB|KiB|MiB|GiB|px|Hz|kHz|GHz)\b', 0),
    ('8.6', 'hard', 'ranges take an en dash "–" or "to", not "~"', r'\d\s*[~～]\s*\d', 0),
]
QUOTE_STYLES = {'straight ""': r'"', 'curly “”': r'[“”]', 'corner 「」': r'[「」『』]'}
LIMITS = {'en': (25, 20), 'zh': (50, 40)}  # (descriptive, procedural)


def clean(line):
    line = re.sub(r'`[^`]*`', 'X', line)
    line = re.sub(r'\]\([^)]*\)', ']', line)
    return re.sub(r'https?://\S+', 'X', line)


def language(line, forced):
    if forced != 'auto':
        return forced
    cjk = len(re.findall(C, line))
    words = len(re.findall(r'[A-Za-z]+', line))
    if cjk and cjk >= words:
        return 'zh'
    if not cjk and words >= 3:
        return 'en'
    return None


def length(sentence, lang):
    words = len(re.findall(r"[A-Za-z0-9_.+'’-]+", sentence))
    return words + (len(re.findall(C, sentence)) if lang == 'zh' else 0)


def sentences(text, lang):
    pattern = r'[。？！；]' if lang == 'zh' else r'(?<=[.?!;])\s+'
    return [s.strip() for s in re.split(pattern, text) if s.strip()]


def check(path, text, forced):
    hits = []
    in_fence = False
    quote_seen = {}
    for n, raw in enumerate(text.split('\n'), 1):
        if raw.lstrip().startswith(('```', '~~~')):
            in_fence = not in_fence
            continue
        if in_fence or re.match(r'^\s*\|?\s*:?-{3,}', raw) or raw.lstrip().startswith('<!--'):
            continue
        line = clean(raw)
        lang = language(line, forced)
        if lang is None:
            continue
        for name, pat in QUOTE_STYLES.items():
            if re.search(pat, line):
                quote_seen.setdefault(name, n)
        bare = re.sub(r'"[^"]{1,40}"|“[^”]{1,40}”|「[^」]{1,40}」', '""', line)
        words, punct = (ZH_WORDS, ZH_PUNCT) if lang == 'zh' else (EN_WORDS, EN_PUNCT)
        for rule, level, msg, pat, flags in words:
            for m in re.finditer(pat, bare, flags):
                hits.append((n, rule, level, msg, m.group(0)))
        for rule, level, msg, pat, flags in punct:
            for m in re.finditer(pat, line, flags):
                hits.append((n, rule, level, msg, m.group(0)))
        if lang == 'zh':
            for clause in re.split(r'[，。；：、？！,;:]', bare):
                if clause.count('的') > 2:
                    hits.append((n, '2.1', 'soft', '一个分句里超过两个"的"，考虑拆开', clause.strip()[:30]))
        if line.lstrip().startswith('|'):
            continue
        is_step = re.match(r'^\s*\d+[.、)]\s', line) is not None
        desc, step = LIMITS[lang]
        limit = step if is_step else desc
        body = re.sub(r'^\s*(?:[-*+]|\d+[.、)]|#+|>)\s*', '', line)
        for s in sentences(body, lang):
            k = length(s, lang)
            if k > limit:
                rule = '5.4' if is_step else '6.3'
                unit = '字' if lang == 'zh' else 'words'
                hits.append((n, rule, 'soft', f'{k} {unit} > {limit}', s[:40] + '…'))
            if lang == 'en' and re.match(r'(it|there)\s+(is|are|was|were)\b', s, I):
                hits.append((n, '4.2', 'soft', 'empty subject: name the actor', s[:30] + '…'))
    if len(quote_seen) > 1:
        styles = ', '.join(f'{k} (from line {v})' for k, v in quote_seen.items())
        hits.append((min(quote_seen.values()), '8.2', 'hard', 'mixed quotation styles: ' + styles, ''))
    hits.sort(key=lambda h: h[0])
    for n, rule, level, msg, snip in hits:
        print(f'{path}:{n}: [{rule} {level}] {msg}' + (f': {snip}' if snip else ''))
    return hits


def main(argv):
    forced = 'auto'
    paths = []
    args = iter(argv)
    for a in args:
        if a == '--lang':
            forced = next(args)
        else:
            paths.append(a)
    if not paths or forced not in ('auto', 'en', 'zh'):
        print(__doc__.strip())
        return 2
    hard = soft = 0
    for p in paths:
        text = sys.stdin.read() if p == '-' else open(p, encoding='utf-8').read()
        for h in check(p, text, forced):
            hard += h[2] == 'hard'
            soft += h[2] == 'soft'
    print(f'-- {hard} hard, {soft} soft', file=sys.stderr)
    return 1 if hard else 0


if __name__ == '__main__':
    sys.exit(main(sys.argv[1:]))
