# 智能体系统文件瘦身规则

<!-- TEMPLATE ONLY - sanitized publishing mirror: generated from a private system file. Review placeholders before use. -->


本规则是正式治理规则，用于维护<AGENT_NAME>主 Agent、子 Agent、公司级规则和 <AGENT_KB_NAME> 知识库之间的职责边界。目标是让启动文件更短、更稳定，让详细业务知识沉淀到 <AGENT_KB_NAME>，让安全和工具规则仍保留在 `agent_rules`。

## 触发场景

遇到以下任务时，先读取本文件：

- 用户要求整理、瘦身、重构、合并或迁移智能体系统文件。
- `SUB_AGENT.md`、`group_context.md`、`agent_rules` 或 <AGENT_KB_NAME> 出现重复规则。
- 日常规则沉淀确认中，有规则需要从候选升级为正式规则。
- 新增部门 SOP、话术、模板、任务手册、知识地图或长期规则。
- 修改 worker、hook、自动化、外发、路由、记忆、交付或 <AGENT_KB_NAME> 读取方式。

## 分层职责

| 层级 | 保留内容 | 不承载内容 |
|---|---|---|
| `AGENTS.md` | 全局安全底线、路由原则、交付底线、仓库边界 | 部门 SOP、业务资料、长流程细则 |
| `SUB_AGENT.md` | 群身份、用途、资料优先级、群专属偏好、群专属红线 | 运行稳定性全文、交付全文、群成员检索全文 |
| `agent_rules` | 怎么安全做事：身份权限、群聊上下文、外发、运行限制、<AGENT_KB_NAME> 读取、worker、hook、上下文预算 | 产品资料、销售话术、内容 SOP 原文 |
| `Company.md` | 稳定公司事实、业务边界、对外表达红线 | 流程细节、个人偏好、客户资料、价格和执行日志 |
| <AGENT_KB_NAME> | 主题地图、实体卡片、任务手册、SOP、<HUMAN_KB_NAME>对照、聊天沉淀候选、规则候选 | 原始聊天、客户隐私、报价合同、token、路径和会话 ID |

## 升级路径

### 从临时规则升级

一条临时规则满足以下条件之一时，可以进入正式层：

- 用户明确确认“升级”“以后都这样”“记成正式规则”等。
- 同类问题重复出现，且不沉淀会影响交付质量。
- 涉及权限、隐私、客户资料、报价、合同、财务、人事、路径暴露、跨群读取等安全边界。
- 规则适用范围明确，能说明适用于谁、什么场景、不适用于什么场景。

### 写入位置

- 全公司硬安全底线：极少数进入 `AGENTS.md`。
- 工具、权限、外发、路由、运行限制、<AGENT_KB_NAME> 读取：进入 `agent_rules`。
- 群专属身份、边界和资料优先级：进入对应 `SUB_AGENT.md`。
- 业务 SOP、话术、模板、任务手册：进入 <AGENT_KB_NAME>，必要时标记为可同步<HUMAN_KB_NAME>。
- 稳定公司事实：负责人确认后才进入 `Company.md`。
- 仍不确定但有价值：留在 <AGENT_KB_NAME> 候选区。

## 瘦身规则

- 不把共享长规则复制进每个 `SUB_AGENT.md`；用 `agent_rules\index.md` 和具体规则文件引用。
- `SUB_AGENT.md` 只在群身份、群职责、群专属边界、读取顺序变化时更新。
- `group_context.md` 只保留当前群稳定背景、长期协作偏好和已经压缩的长期结论。
- `chat_history.md` 只做原始归档，不作为长期知识库。
- 自动化只能整理候选；未经用户确认，不自动改 `AGENTS.md`、`SUB_AGENT.md`、`agent_rules` 或 `Company.md`。
- <AGENT_KB_NAME> 可以承接详细知识，但不能替代权限校验。

## 必查规则

按任务读取以下规则，不一次性加载所有文件：

- 公司级规则索引：`agent_rules\index.md`
- <AGENT_KB_NAME> 读取：`agent_rules\agent_knowledge.md`
- 上下文预算：`agent_rules\context_budget.md`
- 群聊和跨群资料：`agent_rules\identity_access.md and memory_context.md`
- 外发交付：`agent_rules\external_actions.md`
- 治理复盘：`agent_rules\governance_review.md`
- 规则注册表：`agent_rules\rule_registry.md` / `agent_rules\rule_registry.json`

## 验证

每次瘦身或升级后，至少检查：

- 相关 JSON 可解析。
- `agent_rules\index.md` 是否有入口。
- 相关 `SUB_AGENT.md` 是否仍保留身份、边界和共享规则引用。
- <AGENT_KB_NAME> 是否有正式页或候选页承接业务知识。
- 不含原始聊天、客户隐私、报价、合同、财务、人事、token、本地路径或会话 ID。
- 私有运行资料没有进入 Git 待提交。

<!-- template-check: startup files short -->
