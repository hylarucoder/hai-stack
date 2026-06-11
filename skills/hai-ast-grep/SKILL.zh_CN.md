# hai-ast-grep 中文版

本文件是中文阅读版；执行规则以 `SKILL.md` 为准。

ast-grep 用 tree-sitter 把代码解析成 AST，从而做到精确的模式匹配。凡是搜索或重构依赖语法结构的场景都该用它：一次性的搜索和改写直接走 CLI，可复用的 lint/codemod 规则用 YAML 编写。无论哪种形态，任务都不是"写一个 pattern"——而是交付一个经过正例和反例双重验证的 pattern 或规则：该匹配的都匹配，不该匹配的一个不碰。

## 项目配置

通过 `ast-grep scan` 做项目级批量扫描需要 `sgconfig.yml` 配置文件；通过 `ast-grep run -p '<pattern>'` 做一次性 pattern 测试则不需要。

```yaml
# sgconfig.yml（项目根目录）
ruleDirs:
  - rules          # 规则目录；递归加载所有 .yml 文件
```

典型项目结构：

```
my-project/
├── sgconfig.yml
├── rules/
│   ├── no-console.yml
│   └── custom/
│       └── team-rules.yml
└── src/
```

运行项目扫描：

```bash
ast-grep scan              # 自动发现 sgconfig.yml
ast-grep scan --config path/to/sgconfig.yml  # 显式指定配置
```

> **注意**：`ast-grep scan` 命令需要 `sgconfig.yml`，而 `ast-grep run -p` 可以独立运行。

## 日常 CLI 用法（不写规则文件）

日常的搜索和重构大多数根本不需要 YAML 和 sgconfig——`ast-grep run`（默认子命令）直接搞定：

```bash
# 搜索：fetch 的全部调用点，无视换行和格式差异
ast-grep run -p 'fetch($URL)' -l ts src/

# 带上下文行搜索，或输出机器可读的 JSON 用于报告
ast-grep run -p 'console.log($$$)' -C 2 src/
ast-grep run -p 'console.log($$$)' --json=stream src/

# 一次性改写：逐个交互确认（-i），或全量应用（-U）
ast-grep run -p 'console.log($$$A)' -r 'logger.log($$$A)' -l ts -i src/
ast-grep run -p 'oldFn($A, $B)' -r 'newFn($B, $A)' -l ts -U src/
```

关键参数：

| 参数 | 含义 |
|------|------|
| `-p <pattern>` | 要匹配的 AST pattern |
| `-r <template>` | 改写模板——这是 `run` 里的含义；在 `scan` 里 `-r` 指规则**文件**，不要混淆 |
| `-l <lang>` | 语言（`ts`、`tsx`、`py`、`go`、`rs`……）；省略时按文件扩展名推断 |
| `-i` | 逐个匹配交互式接受/拒绝——任何批量改写前默认先用它 |
| `-U` | 应用全部改写；不带它时只报告匹配，不动文件 |
| `-C <n>` / `--json` | 上下文行数 / JSON 输出 |

交付 pattern、所用的完整命令和匹配摘要。只有当匹配需要 `constraints` / `not` / `inside` 收窄，或者会被反复运行（CI 守护、可复用 codemod）时，才升级成 YAML 规则。

## 规则工作流

### Lint 规则（最常见）

只检查、不修复——用于 CI / 编辑器诊断：

```yaml
# rules/no-console-log.yml
id: no-console-log
language: JavaScript
severity: warning
message: Avoid console.log in production code
rule:
  pattern: console.log($$$ARGS)
```

验证：

```bash
ast-grep scan -r rules/no-console-log.yml src/
```

### 改写规则（可选）

要自动修复，在上面的 lint 规则里加**一行** `fix:`——其余不变：

```yaml
# ……规则同上，外加：
fix: logger.log($$$ARGS)
```

应用修复（注意 `--update-all` 参数——不带它的 `scan` 只报告不改写）：

```bash
ast-grep scan -r rules/no-console-log.yml --update-all src/
```

### 开发流程（规范工作流——按步骤执行）

1. **先用 CLI 探索** pattern，再写 YAML：`ast-grep -p 'console.log($ARG)' src/`。pattern 匹配不上时用 `--debug-query ast` 查看节点类型：
   ```bash
   ast-grep -p 'console.log($ARG)' --debug-query ast
   ```
2. **编写**规则文件（`.yml`）——从 lint 形态起步（pattern + message + severity）。
3. **用正例 fixture 验证**——应该匹配的代码：`ast-grep scan -r rule.yml fixtures/`，确认匹配。
4. **用反例 fixture 验证**——长得像但不该匹配的代码。如果匹配了就是误报：加 `constraints`、`not`、`inside` 或 `has` 收窄规则，然后两个 fixture 重新跑一遍。
5. 只在需要机械化改写时**加 `fix:`**，并在 `--update-all` 之前先 dry-run。
6. **按下方交付形态交付**（以及 `references/output-template.md`）——绝不只甩回一段裸 YAML。

## 基础语法

供上下文内快速查阅的速查表。完整语法见 [references/rule-syntax.md](references/rule-syntax.md#pattern-syntax)。

| 元素 | 语法 | 示例 |
|------|------|------|
| 单个节点 | `$VAR` | `console.log($MSG)` |
| 多个节点 | `$$$ARGS` | `fn($$$ARGS)` |
| 内容相同 | 使用同名变量 | `$A == $A` |
| 不捕获 | `$_VAR` | `$_FN($_FN)` |
| 捕获匿名节点 | `$$VAR` | `async function $$NAME() {}` |

## 核心规则速查

速查表。完整的原子 / 组合 / 关系规则见 [references/rule-syntax.md](references/rule-syntax.md)。

| 类型 | 用途 | 示例 |
|------|------|------|
| `pattern` | 匹配代码结构 | `pattern: if ($COND) {}` |
| `kind` | 匹配 AST 节点类型 | `kind: function_declaration` |
| `all` | 满足全部条件 | `all: [pattern: X, kind: Y]` |
| `any` | 满足任一条件 | `any: [pattern: var $A, pattern: let $A]` |
| `not` | 排除匹配 | `not: {pattern: safe_call()}` |
| `has` | 必须包含某子节点 | `has: {kind: return_statement}` |
| `inside` | 必须位于某祖先内 | `inside: {kind: class_body}` |

## 交付形态

按这个形态交付规则——不是一段裸 YAML。以下是 `references/output-template.md` 的五个标题；定稿前读那个文件拿完整模板。

- **目标**——这条规则找到或改写什么代码模式。
- **规则**——`.yml` 文件（id、language、rule、message、severity）。
- **修复（如适用）**——新增的 `fix:` 行。
- **验证**——正例 fixture（应匹配）、反例 fixture（不应匹配）、实际运行的完整命令（`ast-grep scan --rule <file>` 或 `-r <file> src/`）及结果。
- **备注**——规避了哪些误报（如何规避），以及已知边界（有意不覆盖的情况）。

## 详细参考

**完整语法指南**：见 [references/rule-syntax.md](references/rule-syntax.md)
- 原子规则（pattern、kind、regex、nthChild、range）
- 组合规则（all、any、not、matches）
- 关系规则（has、inside、follows、precedes）
- Transform 与 fixConfig

**特定语言的常用模式**：见 [references/common-patterns.md](references/common-patterns.md)
- JavaScript/TypeScript 示例
- Python 示例
- Go 和 Rust 示例

**输出模板**：见 [references/output-template.md](references/output-template.md)——上方交付形态的完整可复制版本（正反例 fixture、完整验证命令、已知边界字段）。

## 支持的语言

Bash, C, Cpp, CSharp, Css, Elixir, Go, Haskell, Hcl, Html, Java, JavaScript, Json, Kotlin, Lua, Nix, Php, Python, Ruby, Rust, Scala, Solidity, Swift, Tsx, TypeScript, Yaml

## 何时改用其他 skill

只有当匹配依赖语法结构时——搜索、lint 或改写——ast-grep 才是对的锤子。以下情况换路：

- **纯文本或正则查找替换**，不涉及语法树形状（改一个字符串字面量、换一个 URL、找一个 grep 一发就命中的唯一标识符）——直接 grep / 普通编辑 / `sed`；AST pattern 是杀鸡用牛刀。
- **单文件一次性修改**——直接改；规则只有跨大量调用点才回本。
- **类型感知或语义重构**（由值的类型而非语法驱动——例如消除 `any`）——用 `ts-type-safety-reviewer`。ast-grep 匹配的是语法，不是类型。
- **主观代码质量评审**（"这代码干不干净 / 命名好不好 / 是否过度设计"、坏味道）——用 `clean-code-reviewer`；保持行为不变的清理用 `code-simplifier`。
- **纯格式化 / 空白 / import 顺序**——那是格式化器的活（Prettier、Biome、gofmt），不是结构化规则的活。
