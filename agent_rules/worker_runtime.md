# <AGENT_NAME>后台 Worker 运行规则

<!-- TEMPLATE ONLY - sanitized publishing mirror: generated from a private system file. Review placeholders before use. -->


本规则适用于<AGENT_NAME>后台 worker、自动化任务、长任务迁移、`codex exec` 后台执行和相关脚本维护。它不替代现有 `<CONNECTOR_NAME> + Codex + <MESSAGE_PLATFORM>` 普通对话链路。

## 适用场景

- 定时自动化任务。
- 大文件处理、报告整理、批量生成、跨系统查询。
- 明确可能超过普通聊天等待时间，且不需要即时追问澄清的任务。
- 需要避免依赖 Codex 桌面窗口活跃状态的后台执行任务。

普通聊天、短文案、翻译、轻量问答、需要实时澄清或高风险审批的任务，不默认进入 worker。

## 用户体验规则

- 任务未完成前，不向员工发送“正在处理”“已收到”“请稍等”“task_id”等占位回复。
- 只有任务完成、任务失败、或确实需要用户补充必要信息时，才向<MESSAGE_PLATFORM>发送消息。
- 面向员工的最终消息只展示结果、必要说明和下一步；不得暴露本机路径、日志路径、session_key、task_id、open_id、token、内部脚本名或调试细节。
- 管理员排查可查看任务库和日志，但这些状态信息不主动发送给普通员工。

## 子智能体继承规则

worker 执行群聊任务时，必须保持现有智能体-子智能体结构：

1. 先遵守运行区根目录 `AGENTS.md` 和公司级安全要求。
2. 根据<MESSAGE_PLATFORM> `session_key` / `chat_id` 解析所属群聊。
3. 已注册群聊必须读取该群 `SUB_AGENT.md` 和 `group_context.md`。
4. 如任务涉及群专属流程、素材、记忆或技能，再按该群 `SUB_AGENT.md` 的按需读取表读取本群 `agent_rules`。
5. 不得把 `templates/` 下的规则当成实时运行规则。
6. 不得把其他群私有资料、聊天记录、附件正文或客户信息迁入当前群上下文。

## 执行边界

- worker 是后台执行器，不是新的智能体身份；它只负责取任务、调用 `codex exec`、记录状态和完成后回传结果。
- `<CONNECTOR_NAME>` 仍保留现有<MESSAGE_PLATFORM>入口、会话映射和普通对话体验。
- 不允许为了接入 worker 而把所有消息强制改成异步队列。
- 同一<MESSAGE_PLATFORM>会话的长任务应避免并发执行，防止上下文串话、文件覆盖和重复交付。
- 当 `<CONNECTOR_NAME>` 入口遇到 Codex 远端 `403 Forbidden`、`responses/compact` 或桌面窗口不活跃导致的长任务停滞时，长任务应迁移到 worker 执行；worker 必须按当前 `session_key` / `chat_id` 重新解析并读取个人或群聊上下文，不能丢失子智能体规则。
- 写入、删除、外部系统变更、群发、代表员工发送等高风险操作仍必须遵守现有审批和出站规则；worker 不绕过确认边界。
- worker 在调用 `codex exec` 前必须运行 `scripts\Resolve-CommonErrorPreflight.ps1` 或等效逻辑，根据任务文本、任务类型、来源和路由摘要匹配 `common_error_registry.json`。
- 命中已知墙时，worker prompt 必须包含 `do_not_try`、`use_instead` 和 `verify`，让 Codex 直接绕开重复失败路径，而不是先硬闯再修正。

## 状态与恢复

- 任务状态最少包括：`queued`、`running`、`done`、`failed`。
- 运行中任务应记录 `step`、`updated_at`、`last_heartbeat`、错误原因和输出位置。
- 超时、Codex 非零退出、无最终消息、发送失败等必须记录到任务状态和日志。
- 自动重试次数要有限；多次失败后进入失败状态，由管理员查看日志处理。
- 任务失败通知必须清楚说明失败原因或需要人工处理，不得用“还在处理”替代失败。

## 本机运行位置

- worker 脚本：`scripts\xiaoquan_worker.py`
- 入队脚本：`scripts\Enqueue-XiaoQuanTask.cmd`
- worker 启动脚本：`scripts\Run-XiaoQuanWorker.cmd`
- 状态查看脚本：`scripts\Status-XiaoQuanTask.cmd`
- 本地状态库：`.<CONNECTOR_NAME>\xiaoquan-worker\tasks.sqlite3`
- 本地日志：`log\xiaoquan-worker.log`

这些文件和状态属于本机运行资料，不发布到公开模板或 GitHub。

<!-- template-check: Do not send -->
