# agent_rules index

<!-- TEMPLATE ONLY - sanitized publishing mirror: generated from a private system file. Review placeholders before use. -->


本目录存放公司内部按需读取的详细规则。根目录 `AGENTS.md` 是运行区 live 全局入口，只保留全局核心守则和路由表；遇到对应任务时，先读取本目录下的相关文件，再继续处理。

## 路由表

| 场景 | 先读取 |
| --- | --- |
| 普通员工粗略需求、提示词门槛、任务澄清、默认假设推进 | `request_intake.md` |
| <MESSAGE_PLATFORM>个人身份、员工登记、权限判断、任务分发 | `identity_access.md` |
| <MESSAGE_PLATFORM>群聊、群成员、跨群资料、群聊上下文 | `identity_access.md and memory_context.md` |
| CRM 查询、录入、修改、客户归属、销售权限、管理员全局可见性、允许会话位置、录音是否允许触发 CRM | `business_system_security.md` |
| <CONNECTOR_NAME> 会话、归档线程、恢复失败、Codex 远端 403/compact、hooks | `hook_guardrails.md` |
| <AGENT_NAME>后台 worker、长任务后台执行、自动化任务状态、`codex exec` 执行边界 | `worker_runtime.md` |
| 模型占用上限、上下文窗口、长消息、引用链、附件正文或批量历史检索 | `runtime_limits.md` |
| 已知常见错误预检、Codex 避墙、编码/参数/搜索/Git/<CONNECTOR_NAME> 事前避坑 | `common_error_preflight.md` + `common_error_registry.json` + 仓库根目录 `COMMON_ERRORS.md`；<MEMORY_TOOL> 可用时召回全局 agent `naquan-global` |
| 智能体治理、规则整理、沉淀复盘、运行架构升级后的系统文件同步、自动化优化、hook/common error/知识库体系化 | `governance_review.md` |
| 智能体系统文件瘦身、启动文件职责边界、临时规则升级正式规则、<AGENT_KB_NAME> 承接规则细节 | `system_slimming.md` |
| 公司资料、公司文件、产品事实、客户画像、共享资料、SOP/FAQ/模板、员工可见正式资料、受控资料边界 | `company_sources.md` + `agent_knowledge.md` |
| <AGENT_KB_NAME> 公司知识库、本地知识图谱、<AGENT_NAME>任务手册、聊天沉淀候选、<HUMAN_KB_NAME>对照 | `agent_knowledge.md` |
| <GRAPH_DIAGNOSTICS_TOOL> 自动关系图、结构诊断、孤立节点、规则冲突候选、知识库健康检查 | `graph_diagnostics.md` |
| 每日复盘、部门沉淀、知识库候选、复盘自动化写回边界 | `daily_review_core.md` |
| 规则唯一来源、读取条件、写回权限和审核要求 | `rule_registry.md` / `rule_registry.json` |
| Hook 守门、入站/出站/交付/记忆写入/自动化写回边界 | `hook_guardrails.md` |
| 上下文预算、长期记忆瘦身、文件长度阈值 | `context_budget.md` |
| 小工单 OpenAPI、生产业务系统、报表、写操作、<MESSAGE_PLATFORM>拍照工艺录入 | `xiaogongdan_openapi.md` |
| 主动发<MESSAGE_PLATFORM>消息、建任务、发邮件、定时任务、对外触达 | `external_actions.md` |
| 员工/群聊长期上下文、记忆压缩、Codex 用量提醒 | `memory_context.md` |
| 本机 Codex 项目记忆、长期项目进度、继续上次项目、<MEMORY_TOOL> 项目断点 | `codex_local_project_memory.md`；<MEMORY_TOOL> 可用时召回 `codex-local-projects` |
| 外部记忆层、<MEMORY_TOOL> 试点、全局 Common Error 记忆、群聊专用记忆召回边界 | 全局避坑先读 `common_error_preflight.md` 并可召回 <MEMORY_TOOL> `naquan-global`；本机项目进度读 `codex_local_project_memory.md` 并可召回 `codex-local-projects`；群聊专用记忆先读目标群 `agent_profile.json`，再读目标群 `agent_rules\memanto_memory.md`；没有群专用规则时读 `memory_context.md` |
| 录音、音视频、<MESSAGE_PLATFORM>妙记转写归档、每日清理、录音是否允许触发 CRM | `voice_note_minutes_retention.md` + `business_system_security.md` |
| Git 提交、推送 GitHub、公开/私有仓库安全 | `git_publish_safety.md` |
| 日志、临时文件、Windows/PowerShell/UTF-8 细节 | `workspace_io.md` |

## 使用原则

- 需要处理某个场景时，只读取相关规则文件，不要把本目录全部加载进上下文。
- 多个场景同时出现时，按风险优先级读取：受控资料、小工单写操作、对外触达、身份权限、Git 发布。
- 如果规则文件和用户要求冲突，先执行更严格的安全规则；无法判断时向 <AI_ADMIN_ROLE>确认。
- 本目录属于公司内部资料，默认不提交到 GitHub。
