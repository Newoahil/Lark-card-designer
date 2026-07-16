# Lark Card Designer

中文 | [English](#english)

`Lark Card Designer` 是一个面向 AI coding CLI 的飞书/Lark 卡片设计 skill。它不负责发送卡片、调用飞书 API、修改实现文件或生成生产可发送 JSON，而是根据数据类型、数据意图和输出口径，稳定给出卡片样式、信息架构、组件组合、视觉状态、交互规则和非生产结构草图。

## 适用场景

- 日报、周报、经营汇报卡片
- 运营分析、经营监控、治理提醒、异常诊断卡片
- AI 回答流式输出、长任务进度和过程到最终结果的状态设计
- 商品数据、SKU、库存、转化、退款等运营卡片
- 销售数据、目标达成、预测缺口、漏斗和商机卡片
- 前沿 blog、文章、资讯、知识聚合卡片
- 审批、确认、执行动作卡片
- 复盘分析、根因分析、证据链卡片
- 已有飞书/Lark 卡片的信息层级、组件选择和视觉状态评审
- 真实飞书客户端截图、桌面/移动端效果、交互状态和预览版本对比评审

## 核心能力

- 根据 `数据类型 + 数据意图 + 输出口径` 选择卡片模式
- 区分管理层、业务运营、一线执行、复盘分析、知识/资讯口径
- 根据数据类型判断必须展示的关键字段、首屏优先级、折叠字段和可读性控制
- 为运营分析场景补充主语、首要问题、置信度、趋势基线、优先级和下一步动作判断
- 区分绝对规模与相对贡献，约束分母口径、时间粒度、窗口对比和缺失值语义
- 为流式卡片选择文本流式、组件局部更新、全量替换或混合模式，并设计稳定区域、异常状态、交互切换和最终态
- 输出信息架构、组件计划、视觉状态、交互状态和校验清单
- 细化到内联文字色、标签、字号、间距、表格列、按钮状态等设计约束
- 细化按钮排布、输入框、选择器、表单布局、校验状态和提交后状态
- 提供非生产结构草图，用于设计交付，不作为字段级实现 schema 或生产可发送 JSON
- 参考 CardKit 的卡片实体、局部更新、流式更新和模板化概念，但不输出 API 调用或生产参数
- 基于真实客户端渲染证据给出分级修改建议和设计验收结论；预览发送仍由项目实现方负责
- 兼容 Codex、Claude Code、OpenCode 等 coding CLI 的轻量使用方式

## 设计与评审闭环

1. **判断场景**：结合数据类型、数据意图、读者口径和使用约束，选择日报/周报、运营分析、审批、摘要、告警、进度等卡片模式。
2. **形成设计交付**：确定首屏重点、关键数据、信息层级、组件组合、颜色语义、交互状态、响应式约束和验收条件；只提供非生产结构草图，不生成可直接发送的实现。
3. **项目侧实现预览**：由项目实现方将设计转换为卡片代码，并在隔离的非生产环境中渲染。涉及审批、删除、发布、改价等动作时，预览交互应无副作用。
4. **真实客户端评审**：根据具体风险检查飞书桌面端、移动端及初始、加载、错误、完成、折叠或流式结束等状态；评审结论必须绑定预览版本和实际证据。
5. **输出修改与验收结论**：区分直接观察到的问题与待验证风险，按优先级给出设计修改方向，并使用 `accepted`、`accepted_with_minor_changes`、`revise_and_preview_again` 或 `insufficient_evidence` 表达设计结论。

真实客户端预览是按需叠加的评审环节，不是所有简单卡片的必选流程。设计验收也不等于实现、安全、回调、部署或生产发布验收。

## 项目结构

```text
Lark-card-designer/
  lark-card-designer/
    SKILL.md
    references/
    agents/openai.yaml
    adapters/
    docs/
    scripts/
```

- `lark-card-designer/SKILL.md`：skill 入口和核心工作流
- `lark-card-designer/references/`：运行时按需读取的决策矩阵、口径画像、卡片模式、组件规则和视觉状态规则
- `lark-card-designer/agents/openai.yaml`：Codex UI 元数据
- `lark-card-designer/adapters/`：Claude Code / OpenCode 轻量入口
- `lark-card-designer/docs/`：飞书官方文档抓取结果、GitHub 调研和需求分析资料
- `lark-card-designer/scripts/`：文档抓取脚本

## 在 Codex 中使用

将 `lark-card-designer/` 文件夹放入 Codex skills 目录，例如：

```text
C:\Users\<you>\.codex\skills\lark-card-designer
```

之后可以在新会话中显式调用：

```text
使用 $lark-card-designer，帮我为这组销售数据设计飞书卡片样式。
```

也可以在涉及飞书/Lark 卡片设计、结构、组件、视觉状态或交互状态时由 Codex 自动命中。

## 在 Claude Code / OpenCode 中使用

优先引用核心 skill：

```text
参考 lark-card-designer/SKILL.md，为下面的数据设计飞书卡片样式。
```

也可以使用轻量适配入口：

- `lark-card-designer/adapters/claude-code.md`
- `lark-card-designer/adapters/opencode.md`

适配层只做指针，不复制核心规则，避免多端规则漂移。

## 默认输出

skill 默认输出 Markdown 说明和结构化决策块：

```text
card_intent
card_pattern
information_architecture
key_data_rules
component_plan
visual_rules
design_constraints
interaction_rules
streaming_design（仅流式场景）
preview_review（仅真实客户端预览规划或评审场景）
structure_sketch
design_red_lines
validation_checklist
```

## 边界

本项目不是：

- 飞书卡片 SDK
- webhook 发送工具
- 卡片模板市场
- API 调用封装
- 生产可发送 JSON 生成器
- 字段级 schema 或回调契约生成器
- 业务代码/卡片模板修改器
- 飞书预览发送、凭证配置或部署流程工具
- 通用 Markdown 美化器

它的角色是飞书/Lark 卡片设计师，负责设计判断、设计交付约束和评审，不直接施工。

## 验证

可使用 Codex skill creator 的校验脚本验证 skill 结构：

```powershell
python C:\Users\<you>\.codex\skills\.system\skill-creator\scripts\quick_validate.py .\lark-card-designer
```

---

## English

`Lark Card Designer` is a Feishu/Lark card design skill for AI coding CLIs. It does not send cards, call Feishu APIs, modify implementation files, or generate production-ready JSON. Instead, it chooses card styles, information architecture, component plans, visual/status rules, interaction states, and non-production structure sketches from the data type, data intent, and target audience.

## Use Cases

- Daily, weekly, and business report cards
- Operational analytics, business monitoring, governance reminder, and anomaly diagnosis cards
- Streaming AI responses, long-running task progress, and process-to-result state design
- Product, SKU, inventory, conversion, and refund operation cards
- Sales target, forecast gap, funnel, and opportunity cards
- Blog, article, news, and knowledge digest cards
- Approval, confirmation, and execution cards
- Retrospective, root-cause, and evidence-chain cards
- Review and improvement of existing Feishu/Lark card designs
- Review of real Feishu/Lark client screenshots, desktop/mobile rendering, interaction states, and preview-version comparisons

## Capabilities

- Select card patterns from `data type + data intent + audience`
- Adapt designs for management, business operations, frontline execution, retrospective analysis, and knowledge/news audiences
- Identify must-show key fields, first-screen priority, folded fields, and readability controls by data type
- Add operational analytics rules for primary subject, first question, confidence, trend baseline, priority order, and next-step judgment
- Distinguish absolute scale from relative contribution and constrain denominator, time grain, window comparison, and missing-value semantics
- Choose text streaming, component partial updates, full replacement, or hybrid behavior, including stable regions, exception states, interaction transitions, and finalization
- Produce information architecture, component plans, visual rules, interaction rules, and validation checklists
- Provide design constraints such as inline text color, tags, typography, spacing, table columns, and button states
- Specify button layout, input fields, selects, form layout, validation states, and post-action states
- Provide non-production structure sketches for design handoff while explicitly avoiding field-level schemas or production-sendable JSON
- Reference CardKit concepts such as card entities, partial updates, streaming updates, and templates without producing API calls or production parameters
- Give prioritized revisions and a design verdict from real-client render evidence while leaving preview delivery to the implementation owner
- Work across Codex, Claude Code, OpenCode, and other coding CLI environments

## Design And Review Loop

1. **Classify the scenario**: Use data type, intent, audience, and constraints to select a report, operational analytics, approval, digest, alert, progress, or other card pattern.
2. **Produce the design handoff**: Define first-screen priorities, key data, information hierarchy, component choices, semantic color, interaction states, responsive constraints, and acceptance criteria. Provide only a non-production structure sketch.
3. **Render on the implementation side**: The host project converts the design into card code and renders it in an isolated non-production environment. Consequential preview actions must have no side effects.
4. **Review the real client**: Inspect the relevant Feishu/Lark desktop, mobile, initial, loading, error, final, collapsed, or streaming-complete states. Tie every finding to a preview version and concrete evidence.
5. **Issue revisions and a verdict**: Separate observed problems from unverified risks, prioritize design changes, and use `accepted`, `accepted_with_minor_changes`, `revise_and_preview_again`, or `insufficient_evidence` for the design verdict.

Real-client preview is an optional review overlay for rendering-dependent risk, not a mandatory step for every simple card. Design acceptance does not approve implementation correctness, security, callbacks, deployment, or production release.

## Repository Layout

```text
Lark-card-designer/
  lark-card-designer/
    SKILL.md
    references/
    agents/openai.yaml
    adapters/
    docs/
    scripts/
```

## Usage

In Codex, install the `lark-card-designer/` folder into your skills directory, then invoke:

```text
Use $lark-card-designer to design a Feishu/Lark card for this sales dataset.
```

In Claude Code or OpenCode, reference:

```text
Use lark-card-designer/SKILL.md to design a Feishu/Lark card for the following data.
```

## Output Shape

The skill returns Markdown plus a structured decision block:

```text
card_intent
card_pattern
information_architecture
key_data_rules
component_plan
visual_rules
design_constraints
interaction_rules
streaming_design (streaming scenarios only)
preview_review (real-client preview planning or review only)
structure_sketch
design_red_lines
validation_checklist
```

## Non-Goals

This project is not a Feishu card SDK, webhook sender, preview-delivery tool, credential configurator, deployment workflow, API wrapper, production JSON generator, field-level schema generator, callback contract generator, implementation modifier, template marketplace, or generic Markdown formatter. Its role is design guidance, design handoff constraints, and review.
