# SSOT Findings Report Template

Fill every section. The Not-Counted note and the Positive List are mandatory — they carry the
report's credibility and give fixes local precedents.

```markdown
# SSOT 诊断 — <scope>（<date>）

## 总规律（先于清单）
<Where the violations clustered in THIS sweep, stated against the Core Law: which
type-system-unreachable seams produced them. One paragraph.>

## 违规清单

### S1 — <symptom-class>: <one-line title>（severity / disposition）
<Definition sites with file:line for EVERY copy. The change-amplification number when
relevant ("adding one X touches N places"). Past incidents this class already caused,
if any — they are the strongest evidence.>
**处置**: <recipe + where it lands: fix-now / plan-name phase / decision owner>

### S2 — …

## 判定要诚实（不计违规）
<Candidates examined and exonerated, each with the rule that exonerated it
(idiomatic package-qualified name / forward contract with live consumer /
information-carrying projection / adjudicated by ADR-x). This section prevents
re-litigation and "unify everything" overreach.>

## 已治理范本（正面清单）
| 范本 | 机制 |
|---|---|
| <healthy pattern in this repo> | <codegen + currency test / parity guard / single table + derivation> |

## 处置汇总
| 项 | 治法 | 归属 | 状态 |
|---|---|---|---|
| S1 … | constant promotion | fix-now | ✅ / 待排 |
| S2 … | parity guard | <plan> P2 | 已立计划 |
| S3 … | adjudication | 用户裁决 | 待裁决 |
```

Rules of the format:

- Number findings S1, S2, … and keep numbers stable across follow-up sweeps of the same scope
  (append, don't renumber).
- Every finding cites file:line for *all* sites, not just one example.
- Severity ordering: caused-incident > persisted/user-visible wire > cross-stack seam > intra-package.
- Dispositions must name a real destination: a same-day fix, a specific plan phase, or a named
  decision for the user. "待优化" with no owner is not a disposition.
- If quick wins are executed in the same session, mark them ✅ with the date inside the report —
  the report doubles as the execution record.
