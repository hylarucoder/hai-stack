---
name: audit-docs-against-code
description: 审计文档是否与代码实现、配置和 API 合同一致。Use when the user asks to verify README/docs/API docs against implementation, check whether docs are stale, compare documentation with code, or find doc-code mismatches. Trigger phrases include 文档和代码一致性、文档是否过时、verify docs against code、docs vs implementation。
---

# Audit Docs Against Code

## 目标

系统性找出 README + docs/ 中所有「过时」或「与实现/配置/API 合同不一致」的描述，输出有证据的问题项。

## 核心原则

1. **以代码为真** - 文档与代码冲突时，以源码/配置/合同文件为准
2. **有证据再下结论** - 每条问题必须引用代码/配置位置作为依据
3. **合同优先** - OpenAPI/proto/schema/TS types 视为 SSOT
4. **安全默认收紧** - 安全相关不一致优先标记为高严重级别
5. **场景主题切入** - 不做松散扫雷；围绕具体用户场景、模块主题或关键链路组织审查
6. **说明修复收益** - 每条建议必须写清改完后的收益，例如降低误用、减少排障成本、提升 onboarding 效率或避免错误集成

## 审核流程

### 1. 文档枚举

```bash
# 扫描范围
- README.md (根目录)
- docs/**/*.md (所有文档)
- 合同文件: OpenAPI/proto/GraphQL schema/TS types
```

### 2. 主题与场景拆分

先从项目目标、README、docs/ 入口、API/配置合同中抽取 3-8 个具体审查主题。主题应贴近真实使用场景，而不是只按文件名罗列。

示例：
- 新用户按快速开始启动项目
- 调用方按 API 文档集成接口
- 开发者按配置文档接入环境变量
- 运维/安全审计人员核对权限、沙箱、数据隔离
- 产品/领域读者理解核心实体、状态流转、命名边界

后续问题项按主题归类；如果某个问题无法归入具体主题，才放入「全局文档卫生」。

### 3. 逐文档审阅

对每份文档：
1. 列出关键声明/承诺/配置/接口条目
2. 在代码中搜索对应实现
3. 对比差异：缺失/重命名/行为不一致/默认值不一致
4. 按模板记录问题项
5. 写明最小修正后的具体收益

### 4. 横向交叉检查

- 从合同文件反向检查文档
- 从配置文件反查文档

详细检查清单见 [references/checklist.md](references/checklist.md)

## 严重级别

| 级别 | 定义 | 示例 |
|------|------|------|
| P0 | 安全问题/严重误导 | 文档称已启用沙箱但代码未启用 |
| P1 | 核心功能不一致 | 按文档操作会失败 |
| P2 | 示例不完整/命名不一致 | 不直接阻断使用 |
| P3 | 措辞/格式/链接小问题 | 不影响功能 |
| 待证据补充 | 有怀疑但证据不足 | 需进一步调查 |

## 输出格式

完整报告模板见 [references/output-template.md](references/output-template.md)，详细问题项字段见 [references/output-format.md](references/output-format.md)

### 单个问题项

```markdown
### [标题]
- **严重级别**: P0/P1/P2/P3/待证据补充
- **位置**: `<文件路径>:<行号>`
- **证据**:
  - 文档: [引用]
  - 代码: [引用]
- **影响**: [误导后果]
- **建议**: [最小修正]
- **修复收益**: [改完后带来的具体收益]
- **关联原则**: 以代码为真/合同优先/安全默认收紧/...
```

### 审核结论

```markdown
## 审核结论
- **结论**: 通过/有条件通过/不通过
- **汇总**: P0:x P1:x P2:x P3:x 待补充:x
- **修复优先级**: P0 → P1 → P2 → P3
```

## 多 Agent 并行

如需加速，可按以下维度拆分给多个 agent 并行执行：

1. **按文档类型拆分** - README、API 文档、开发指南各一个 agent
2. **按模块拆分** - 不同功能模块的文档各一个 agent
3. **按检查方向拆分** - 一个从文档查代码，一个从代码查文档

汇总时需去重和统一严重级别。

## 执行

审阅完成后，输出 `docs-against-code-audit.md` 报告文件。
