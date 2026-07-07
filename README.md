# Lark Card Designer

中文 | [English](#english)

`Lark Card Designer` 是一个面向 AI coding CLI 的飞书/Lark 卡片设计 skill。它不负责发送卡片、调用飞书 API 或生成生产可发送 JSON，而是根据数据类型、数据意图和输出口径，稳定给出卡片样式、信息架构、组件组合、视觉状态、交互规则和 JSON 2.0 风格骨架。

## 适用场景

- 日报、周报、经营汇报卡片
- 商品数据、SKU、库存、转化、退款等运营卡片
- 销售数据、目标达成、预测缺口、漏斗和商机卡片
- 前沿 blog、文章、资讯、知识聚合卡片
- 审批、确认、执行动作卡片
- 复盘分析、根因分析、证据链卡片
- 已有飞书/Lark 卡片的信息层级、组件选择和视觉状态评审

## 核心能力

- 根据 `数据类型 + 数据意图 + 输出口径` 选择卡片模式
- 区分管理层、业务运营、一线执行、复盘分析、知识/资讯口径
- 根据数据类型判断必须展示的关键字段、首屏优先级、折叠字段和可读性控制
- 输出信息架构、组件计划、视觉状态、交互状态和校验清单
- 细化到内联文字色、标签、字号、间距、表格列、按钮状态等原子化施工参数
- 细化按钮排布、输入框、选择器、表单布局、校验状态和提交后状态
- 提供接近飞书 JSON 2.0 的结构骨架，但明确不作为生产可发送 JSON
- 参考 CardKit 的卡片实体、局部更新、流式更新和模板化概念
- 兼容 Codex、Claude Code、OpenCode 等 coding CLI 的轻量使用方式

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
atomic_parameters
interaction_rules
json_skeleton
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
- 通用 Markdown 美化器

它的角色是飞书/Lark 卡片设计师，负责设计判断和评审。

## 验证

可使用 Codex skill creator 的校验脚本验证 skill 结构：

```powershell
python C:\Users\<you>\.codex\skills\.system\skill-creator\scripts\quick_validate.py .\lark-card-designer
```

---

## English

`Lark Card Designer` is a Feishu/Lark card design skill for AI coding CLIs. It does not send cards, call Feishu APIs, or generate production-ready JSON. Instead, it chooses card styles, information architecture, component plans, visual/status rules, interaction states, and JSON 2.0-style skeletons from the data type, data intent, and target audience.

## Use Cases

- Daily, weekly, and business report cards
- Product, SKU, inventory, conversion, and refund operation cards
- Sales target, forecast gap, funnel, and opportunity cards
- Blog, article, news, and knowledge digest cards
- Approval, confirmation, and execution cards
- Retrospective, root-cause, and evidence-chain cards
- Review and improvement of existing Feishu/Lark card designs

## Capabilities

- Select card patterns from `data type + data intent + audience`
- Adapt designs for management, business operations, frontline execution, retrospective analysis, and knowledge/news audiences
- Identify must-show key fields, first-screen priority, folded fields, and readability controls by data type
- Produce information architecture, component plans, visual rules, interaction rules, and validation checklists
- Provide atomic implementation-facing parameters such as inline text color, tags, typography, spacing, table columns, and button states
- Specify button layout, input fields, selects, form layout, validation states, and post-action states
- Provide Feishu JSON 2.0-like skeletons while explicitly avoiding production-sendable JSON
- Reference CardKit concepts such as card entities, partial updates, streaming updates, and templates
- Work across Codex, Claude Code, OpenCode, and other coding CLI environments

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
atomic_parameters
interaction_rules
json_skeleton
design_red_lines
validation_checklist
```

## Non-Goals

This project is not a Feishu card SDK, webhook sender, API wrapper, production JSON generator, template marketplace, or generic Markdown formatter. Its role is design guidance and review.
