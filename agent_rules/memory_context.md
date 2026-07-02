# 长期上下文、压缩和 Codex 用量提醒

<!-- TEMPLATE ONLY - sanitized publishing mirror: generated from a private system file. Review placeholders before use. -->


## 全局外部记忆

- `codex-local-projects` 是本机 Codex 项目记忆 agent，用于保存每个长期项目的用途、当前进度、下一步、关键决定和接手提示。
- `naquan-global` 是<AGENT_NAME>全局 <MEMORY_TOOL> agent，用于保存跨群共享的系统维护偏好、Common Error 避坑策略和可复用运行经验。
- Common Error 相关记忆用于提前召回高频错误、失败路径、推荐绕法和验证方式；权威来源仍是 `COMMON_ERRORS.md`、`agent_rules/common_error_preflight.md` 和 `agent_rules/common_error_registry.json`。
- 处理本机 Codex 长期项目时，先按 `agent_rules/codex_local_project_memory.md` 召回 `codex-local-projects`；任务结束后，把稳定进度、下一步、长期决策或阻塞点写回。
- 部门或群聊专属偏好继续写入各自外部记忆 agent，例如<CONTENT_TEAM> `naquan-newmedia`；不要把部门文案偏好、群聊复盘经验混入 `naquan-global`。
- 写入 <MEMORY_TOOL> 时保留可执行技术细节和项目断点，但不写原始聊天、日志全文、客户/员工隐私、token、密钥、`open_id`、`chat_id`、session key 或可外泄业务数据。

## 员工个人上下文

每次来自<MESSAGE_PLATFORM>的员工对话，在完成 `Register-FeishuUser.ps1 -Check` 身份识别后：

- 如果能确认员工姓名和部门，先定位 `<WORKSPACE_ROOT>\<ORG_DIR>\员工\架构` 下该员工个人目录。
- 优先读取员工个人目录下的 `long_term_context.md`，再按需要查看近期 `chat_history.md`。
- 如果同一员工存在企业<MESSAGE_PLATFORM>、个人<MESSAGE_PLATFORM>或其他多个账号，一对一聊天记录和长期上下文按同一员工个人目录统一整理；同时在摘要中保留账号来源、关联关系和权限边界。权限判断仍以当前会话 `open_id` 在 `USERS.md` 中对应的角色和状态为准，不因多账号归档而合并权限。
- 员工个人 `chat_history.md` 只保存一对一私聊原文；群聊完整记录保存到对应群聊工作区。员工个人目录如需体现群聊参与，只写入 `group_participation.md` 索引，不把群聊原文混入个人 `chat_history.md`。
- <MESSAGE_PLATFORM>一对一会话的 `CC_SESSION_KEY` 可能只有 `feishu:<chat_id>`，不一定带 `open_id`；维护个人上下文时应通过最近的 p2p 接收日志、`user_meta` 和 `USERS.md` 反查当前员工，不能只依赖 session key 中的 `open_id`。
- 如果同一员工的一对一消息被拆到多个本地 Codex 窗口，使用 `scripts\Merge-FeishuPersonalSessions.ps1` 合并 p2p session key；不要把已登记群聊窗口合并进个人窗口。
- `long_term_context.md` 只保留员工个人相关的长期信息，例如基本工作内容、职责范围、工作习惯、协作偏好、重要历史结论和待确认事项。
- 每次更新 `long_term_context.md` 时，不只追加新内容；必须同时压缩整理现有长期上下文：去重、合并同类项、删除或改写过时结论，把一次性任务细节改成短摘要或归档索引，保持文件是“当前稳定画像”而不是第二份聊天历史。
- `long_term_context.md` 应控制为短而可读；如果某位员工长期上下文已经变长，优先保留身份/权限边界、当前职责、稳定偏好、常用协作方式、仍有效的重要结论和待确认事项，历史细节回到 `chat_history.md` 或 `archive`。
- 公司通用事实、产品信息、客户画像、统一业务口径不要重复写入员工长期上下文，统一参考 `Company.md` 和公司资料库。
- `chat_history.md` 用于保留近期或原始对话；需要定期压缩，压缩后的长期信息写入 `long_term_context.md`。
- `group_participation.md` 用于记录员工在群聊里与<AGENT_NAME>互动的索引、群名、消息 ID 和必要摘要；读取个人上下文时不得把它当作个人授权或个人偏好的直接依据。
- 压缩时不要写入手机号、证件号、住址、银行卡、私人家庭信息等非必要敏感信息，也不要写入与该员工无关的其他员工隐私或聊天内容。
- 员工上下文维护规则参考 `<WORKSPACE_ROOT>\<ORG_DIR>\员工\架构\employee_context_rules.md`。
- 员工请求<AGENT_NAME>整理录音、音频或视频并生成<MESSAGE_PLATFORM>妙记时，源文件、完整逐字稿、整理稿和归档元数据保存到该员工个人目录的 `archive\voice_notes`；不要只保存在群聊目录、临时目录或<MESSAGE_PLATFORM>妙记里。妙记清理前必须按 `voice_note_minutes_retention.md` 核验归档完整。

## 群聊上下文

- 群聊上下文可放在 `<WORKSPACE_ROOT>\<ORG_DIR>\员工\群聊`，按群聊名称或实际业务需要建立目录，并用<MESSAGE_PLATFORM> `chat_id` 辅助识别。
- 群聊目录内可包含 `skills` 目录；这些技能作为当前业务资料参考，不再通过脚本做强制隔离。
- 群聊长期上下文只沉淀重要结论、长期规则、流程和分工；无关闲聊不写入长期记忆。
- 每次更新群聊 `group_context.md` 时，也要压缩整理现有内容：合并重复规则，移除已弃用的一次性任务结论，把长过程改为短摘要和归档位置，确保后续进入群聊任务时优先读取的是精简当前规则。
- 每日复盘和部门沉淀按 `daily_review_core.md` 执行；<CONTENT_TEAM>保留专属 profile，<SALES_GROUP>试点初期只内部沉淀，不向销售群发送每日摘要。

## Codex 用量提醒

- 这里的“用量”指 Codex 当前可用额度或剩余额度，不是 context 长度、上下文窗口或 token 上下文占用。
- 当能够从运行环境、系统提示、状态信息、工具返回或 <CONNECTOR_NAME> 状态中感知 Codex 剩余用量比例时，按以下阈值提醒正在对话的用户。
- 剩余用量低于 20% 且本轮会话尚未提醒过 20% 时，发送：`提醒：当前 Codex 剩余用量已低于 20%，建议尽快整理当前任务或准备开启新会话。`
- 剩余用量低于 10% 且本轮会话尚未提醒过 10% 时，发送：`提醒：当前 Codex 剩余用量已低于 10%，建议立即整理关键结论，避免后续任务中断。`
- 剩余用量低于 5% 且本轮会话尚未提醒过 5% 时，发送：`提醒：当前 Codex 剩余用量已低于 5%，后续回复和工具调用可能受影响，请注意保存工作进度。我将开始压缩当前上下文，便于后续继续处理。`
- 剩余用量低于 5% 时，提醒后自动开始压缩当前上下文；通过<MESSAGE_PLATFORM>群聊接入时写入当前群聊工作区，通过<MESSAGE_PLATFORM>个人会话接入时才写入员工个人上下文文件。
- 通过<MESSAGE_PLATFORM>接入的群聊，如果能可靠定位对应群聊上下文目录，可把近期对话、已执行操作、关键结果和未完成事项写入该群聊的 `chat_history.md`，长期稳定规则和群聊偏好写入该群聊的 `group_context.md`；如果无法可靠定位，则只在当前对话中整理关键要点，不强制写入。
- 通过<MESSAGE_PLATFORM>接入的用户，先根据当前会话 `open_id` 在 `<WORKSPACE_ROOT>\<ORG_DIR>\员工\架构` 定位或创建其员工个人目录：近期对话、已执行操作、关键结果和未完成事项写入 `chat_history.md`；长期稳定信息、用户偏好、长期任务背景和反复需要保留的结论写入 `long_term_context.md`。
- 直接在 Codex 中对话的用户，只发送用量提醒并在对话中整理关键要点；不得自动写入员工个人 `chat_history.md` 或 `long_term_context.md`。
- 陈天乐与助手对话时，按 Codex 直接用户规则处理；即使通过<MESSAGE_PLATFORM>对话，也只发送用量提醒并在对话中整理关键要点，不自动写入员工个人 `chat_history.md` 或 `long_term_context.md`。
- 每个阈值在同一会话中只提醒一次，不要重复刷屏。
- 该规则同时适用于直接在 Codex 中对话的用户，以及通过<MESSAGE_PLATFORM>接入的用户。
- 通过<MESSAGE_PLATFORM>触发提醒时，直接把提醒内容发给当前<MESSAGE_PLATFORM>会话；不要附带本地路径、token 数、内部配置、调试信息或具体额度来源。
- 如果当前环境无法感知 Codex 剩余用量，不要猜测用量比例，也不要伪造提醒；只在能可靠感知时触发。

## 上下文压缩保留项

当需要总结或压缩上下文时，必须保留：

- 用户已经确认的决定。
- 当前环境约束。
- 已修改的文件和修改原因。
- 已运行的命令和关键结果。
- 未完成事项、阻塞点和下一步。
- 用户明确说过“不要做”的事项。
