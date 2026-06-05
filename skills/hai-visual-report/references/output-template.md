# Hai Visual Report 输出模板

用于交付可视化 HTML 报告。HTML 路径必须是真实生成的文件路径。

```markdown
# Hai Visual Report Delivery

## Report Type
<idea / requirement / goal / review / architecture-style / custom> — <一句话说明>

## Core Judgment
<这份报告最想让读者记住的判断。>

## Visual Structure
- **Map**: <Mermaid graph / flow / system map / none and why>
- **Matrix**: <options / risk / priority / decision / none and why>
- **Sections**: <主要 section 列表>
- **Next Move Block**: yes / no

## Generated File
- **HTML**: `<absolute path>`

## QA Checks
- **HTML generated**: yes / no
- **Mermaid included or intentionally omitted**: yes / no / omitted because <reason>
- **Verdict visible near top**: pass / issue
- **Readable structure**: pass / issue
- **No single-card misuse**: pass / issue
- **Facts vs assumptions separated**: pass / issue

## Notes
- <重要设计选择、限制或后续建议>
```
