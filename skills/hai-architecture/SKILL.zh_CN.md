# Hai Architecture 中文版

本文件是中文阅读版；执行规则以 `SKILL.md` 为准。

## 概览

用这个 skill 做架构层审查，思路基于 John Ousterhout 的《A Philosophy of Software Design》。重点不是机械检查清单，而是围绕复杂度进行判断：系统是否更容易理解、修改和演进。

## 激活边界

用于模块/包边界、抽象深度、信息隐藏、接口、所有权、依赖方向、错误边界、APoSD/Ousterhout 视角的架构 review。不要用于普通代码风格、命名、PRD 写作或局部实现清理。

## 核心框架

- 复杂度是核心敌人。
- 先找最痛的中心，不要被低价值 smell 分散注意力。
- 深模块优先：好的模块用小而稳定的接口隐藏重要复杂度。
- 先画架构图，再列 findings。
- 根据场景选择 3-6 个 lens：业务适配、边界所有权、依赖方向、模块深度、变更放大、认知负担、生命周期、数据语义、接口稳定性、可观测性、错误边界、安全边界、测试面、迁移成本等。
- 重要建议必须解释 why-not：为什么不保持现状、为什么不拆更多、为什么不合并、为什么不用泛化抽象。
- 对关键建议做 red/blue 对抗审查。

## HTML 报告要求

如果用户要 HTML 架构报告，应写到系统临时目录。报告先放整体 architecture map，再给 verdict、边界、review lenses、painful center、options matrix、finding sections、recommended change order 和 evidence reviewed。

## 输出重点

优先 2-4 个高杠杆架构问题，而不是大量局部小问题。每个 finding 都要能解释它如何增加复杂度，以及推荐变更如何降低复杂度。
