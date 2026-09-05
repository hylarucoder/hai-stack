# Hai Visual Report 输出模板

用于交付可视化 HTML 报告。HTML 路径必须是真实生成的文件路径。

```markdown
# Hai Visual Report Delivery

## Report Type
<idea / requirement / goal / review / architecture-style / custom> — <一句话说明>

## Source Fidelity
<原文若有自己的结论就写在这里，否则 "n/a"；再确认实质已承载下来、未压成摘要。>

## Visual Structure
- **Map**: <Mermaid graph / flow / system map / none and why>
- **Matrix**: <options / risk / priority / decision / none and why>
- **Sections**: <主要 section 列表>
- **Next Move Block**: yes / no

## Generated File
- **HTML**: `<absolute path>`
- **Preview PNG**: `<absolute path, or unavailable with reason>`

## QA Checks
- **HTML generated**: yes / no
- **Browser render inspected**: pass / issue / unavailable because <reason>
- **Substance preserved (same understanding as source, not reduced to a summary)**: pass / issue
- **Readability enhanced — key points emphasized, visuals aid rather than replace content**: pass / issue
- **Mermaid included or intentionally omitted**: yes / no / omitted because <reason>
- **Source conclusion surfaced when present**: pass / issue / n/a
- **Map near top**: pass / intentionally omitted because <reason> / issue
- **Readable structure**: pass / issue
- **No single-card misuse**: pass / issue
- **Facts vs assumptions separated**: pass / issue

## Notes
- <重要设计选择、限制或后续建议>
```
