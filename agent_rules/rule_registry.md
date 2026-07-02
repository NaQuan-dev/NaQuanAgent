# 规则注册表

<!-- TEMPLATE ONLY - sanitized publishing mirror: generated from a private system file. Review placeholders before use. -->


本文件是 `rule_registry.json` 的人工可读说明。Agent 处理复杂任务时，先看注册表，再按任务只读必要规则，避免把所有长上下文一次性塞进模型。

## 核心分工

| 类型 | 唯一来源 | 作用 |
| --- | --- | --- |
| Live 全局入口 | `AGENTS.md` | <AGENT_NAME>运行时的全局安全底线、路由原则和交付底线 |
| 公司事实 | `Company.md` | 稳定公司事实、业务边界和对外表达红线 |
| 公司资料读取规则 | `<RULES_DIR>/company_sources.md` | 公司文件、产品资料、SOP、FAQ、模板、受控资料边界的读取顺序 |
| 人可读知识 | <HUMAN_KB_NAME> | 员工长期阅读、协作和复用的正式 SOP、FAQ、模板、资料正文 |
| Agent 执行知识 | <AGENT_KB_NAME> | <AGENT_NAME>检索地图、任务手册、执行路径、权限判断和沉淀候选 |
| 公司规则 | `<RULES_DIR>/index.md` | 按场景读取的公司级规则路由 |
| CRM 安全规则 | `<RULES_DIR>/business_system_security.md` | CRM 后端账号映射、允许会话位置、授权数据范围、管理员全局可见性、客户归属、录音触发边界和写入审计 |
| 智能体系统瘦身规则 | `<RULES_DIR>/system_slimming.md` | 判断启动文件、正式规则、<AGENT_KB_NAME> 和候选记录之间的职责边界 |
| 常见错误预检 | `COMMON_ERRORS.md` + `<RULES_DIR>/common_error_preflight.md` | 已知工程/运行错误的事前避坑策略和验证方式 |
| 常见错误候选 | `<MEMORY_REVIEW_DIR>/common_errors_update_pending.md` | 每周沉淀中准备写入 `COMMON_ERRORS.md` 的脱敏候选，审核后合并 |
| 群入口 | 群 `SUB_AGENT.md` | 群身份、红线、入口和按需规则 |
| 群长期上下文 | 群 `group_context.md` | 当前群稳定背景、协作习惯、输出偏好和长期规则 |
| 员工长期上下文 | 员工 `long_term_context.md` | 员工当前画像、长期偏好、长期任务背景和待确认事项 |
| 机器配置 | 群 `agent_profile.json` | 自动化和 hook 判断是否允许发送、写回、跨群同步和生成草稿 |
| 知识状态 | `memory_review/knowledge_intake_status.csv` | 跟踪候选知识是否审核、发布到<MESSAGE_PLATFORM>、索引到 <AGENT_KB_NAME> 或驳回 |

## 更新原则

- `Company.md`、正式<HUMAN_KB_NAME>、`SUB_AGENT.md` 默认不由自动化直接改，只生成候选。
- `COMMON_ERRORS.md` 默认不由自动化直接改；自动化只整理 `common_errors_update_pending.md` 候选。
- `group_context.md` 和 `long_term_context.md` 可以由已授权自动化更新，但必须先去重、压缩和敏感检查。
- <MESSAGE_PLATFORM>群聊和员工私聊按当前 `chat_id` / `open_id` 路由隔离；本机文件系统可读不等于可以读取其他群或其他员工上下文。
- 公司资料类任务不能只靠模型记忆；先读 `company_sources.md` 和 `Company.md`，再按 `agent_knowledge.md` 查 <AGENT_KB_NAME> 主题地图/任务手册，必要时核对<HUMAN_KB_NAME>当前正式正文。
- <HUMAN_KB_NAME>主要给人看，<AGENT_KB_NAME> 主要给 Agent 看。
- 启动文件保持短而硬；细节规则按确认等级进入 `agent_rules` 或 <AGENT_KB_NAME>。
- 原始聊天、录音逐字稿、客户隐私、员工隐私、报价、合同、路径和调试日志不进入普通知识正文。
