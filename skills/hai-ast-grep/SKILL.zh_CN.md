# hai-ast-grep 中文版

本文件是中文阅读版；执行规则以 `SKILL.md` 为准。

ast-grep 用 tree-sitter 按 AST 结构匹配代码。一次性搜索/改写使用 CLI，可重复执行的 lint 或 codemod 使用 YAML。交付重点不是“写出 pattern”，而是用正例和反例证明它该匹配的能匹配、不该匹配的不会误伤。

## 何时使用

- 搜索依赖语法结构，文本 grep 会命中注释/字符串或漏掉格式变体。
- 批量修改调用签名、参数顺序或一种结构化写法。
- 建立可重复执行的 lint/codemod 规则。

纯文本替换直接使用普通搜索编辑；依赖类型语义的重构使用编译器或类型工具。

## 项目配置

一次性 `ast-grep run` 不需要项目配置。可复用规则用 `sgconfig.yml` 和规则目录；只有建立或修改这套配置时读取 `references/project-setup.md`。

## 日常 CLI

```bash
# 搜索
ast-grep run -p 'fetch($URL)' -l ts src/

# 查看上下文或 JSON
ast-grep run -p 'console.log($$$)' -C 2 src/
ast-grep run -p 'console.log($$$)' --json=stream src/

# 交互确认改写；确认安全后才全量应用
ast-grep run -p 'console.log($$$A)' -r 'logger.log($$$A)' -l ts -i src/
ast-grep run -p 'oldFn($A, $B)' -r 'newFn($B, $A)' -l ts -U src/
```

先交付 pattern、完整命令和匹配摘要。只有需要 `constraints`、`not`、`inside` 等收窄条件，或规则会在 CI/后续重复运行时，才升级为 YAML。

## YAML 规则

检查型规则：

```yaml
id: no-console-log
language: JavaScript
severity: warning
message: Avoid console.log in production code
rule:
  pattern: console.log($$$ARGS)
```

```bash
ast-grep scan -r rules/no-console-log.yml src/
```

需要机械修复时再添加：

```yaml
fix: logger.log($$$ARGS)
```

```bash
ast-grep scan -r rules/no-console-log.yml --update-all src/
```

## 标准工作流

1. 先用 `ast-grep run -p '<pattern>' <target>` 探索；匹配异常时用 `--debug-query ast` 看节点。
2. 需要复用才写 YAML，从只检查的 rule 开始。
3. 用一个应匹配的正例 fixture 验证。
4. 用一个外观相似但不应匹配的反例 fixture 验证；误报时用约束继续收窄。
5. 用户需要机械改写时才加 `fix:`，全量应用前先 dry-run/交互检查。
6. 按 `references/output-template.md` 交付目标、规则、可选 fix、验证和已知边界。

## 语法参考

单节点用 `$VAR`，多节点用 `$$$ARGS`。`kind`、`regex`、`all/any/not`、`has/inside`、transform 和 fix 配置见 `references/rule-syntax.md`；语言例子见 `references/common-patterns.md`。

## 不适用

- 不依赖 AST 的纯文本/正则替换。
- 单文件一次性小编辑。
- 需要类型信息的语义重构。
- 主观代码质量审查。
- 格式化、空白或 import 排序。
