# Hook 守门规则

<!-- TEMPLATE ONLY - sanitized publishing mirror: generated from a private system file. Review placeholders before use. -->


本文件定义<MESSAGE_PLATFORM>到 Codex 链路中必须由 hook 或只读巡检兜底的规则。模型只能处理已经进入 Codex 的事件；如果事件在 `<CONNECTOR_NAME>` 层被拦截、恢复失败或报错，必须由 `<CONNECTOR_NAME>` 的 hook、日志巡检和会话修复脚本处理，不能只依赖 `AGENTS.md` 或模型自觉。

## 总原则

- 第一轮治理只定义守门规则和只读校验，不直接修改实际 `.<CONNECTOR_NAME>` 配置。
- 所有 hook 都必须默认最小权限、可重复执行、可审计；写入会话索引前必须备份，优先保留 dry-run 能力。
- hook 不能把本地路径、`chat_id`、`open_id`、session key、日志路径或错误堆栈展示给普通员工。
- hook 只做路由、归档、交付、防错和状态记录；不能替代业务审批、客户承诺、报价确认或正式知识库发布。
- 任何自动发送、写入正式知识库、扩大群聊权限、跨群读取或人类账号代发，都必须先满足对应规则文件和当前 `agent_profile.json`。
- 同一类已知墙重复出现时，优先把 `common_error_registry.json` 的 `do_not_try/use_instead/verify` 落成 hook、脚本默认行为或只读巡检，不继续只依赖模型记忆。

## 1. 入站路由 hook

触发事件：`message.received`。

目标：

- 先定位当前<MESSAGE_PLATFORM>消息属于个人会话、已登记群聊、未登记会话还是异常会话。
- 生成或刷新路由快照，确保模型读取的是当前 `chat_id` / `open_id` 对应上下文。
- 自动处理员工姓名登记、个人会话合并、群聊归档和会话一致性巡检。

当前脚本映射：

- `scripts/Resolve-FeishuWorkspaceHook.ps1`
- `scripts/Archive-FeishuGroupMessage.ps1`
- `scripts/Archive-FeishuPersonalMessage.ps1`
- `scripts/AutoRegister-FeishuNameMessage.ps1`
- `scripts/Xiaogongdan-ProcessRoutingIntakeHook.ps1`
- `scripts/Crm-XiaoquanIntakeHook.ps1`
- `scripts/Merge-FeishuPersonalSessions.ps1`
- `scripts/Audit-FeishuSessionConsistency.ps1`

拦截或降级：

- 路由快照缺失、过期或与当前消息不一致时，重新解析；仍无法定位时按个人/未登记会话处理，不读取群聊私有资料。
- 群聊消息不能因为 Codex 窗口标题、历史线程名称或 <AI_ADMIN_ROLE>调试上下文看似相关，就进入非当前群聊工作区。
- 个人消息不能混入群聊 `chat_history.md`；群聊互动不能全文写入员工个人历史。
- 小工单工艺拍照录入 hook 只能识别意图、下载图片和生成审查记录；不得从入站 hook 直接调用小工单创建、更新或删除接口。后续必须经过 OCR/人工审查草稿和显式写入确认。
- CRM 录入 hook 不能把录音、语音、音频、视频或妙记本身当成 CRM 意图。<SALES_GROUP>也不能因音频消息自动进入 CRM；只有当前会话是<SALES_GROUP>，或当前会话是一对一私聊且 CRM 后端能通过当前<MESSAGE_PLATFORM> `open_id` 映射到有效 CRM 账号，并且当前文字消息明确要求 CRM 匹配、查询、录入、修改或分析时，才允许进入 CRM 流程。其他任何群聊里，不管发起人是谁，都必须跳过 CRM；hook 不得用本地<SALES_DEPARTMENT>门或硬编码名单提前拒绝一对一私聊，应交给 CRM 后端校验账号映射和权限。
- CRM 录音转写或客户匹配未完成前，不得发送“正在处理”“正在匹配 CRM”等占位回复；只在完成、失败或需要确认时反馈。

## 2. 模型前 <CONNECTOR_NAME> 错误 hook

触发事件：`error`，以及 `message.received` 阶段中发生在调用 Codex 前的失败。

适用问题：

- `thread/resume failed`
- session 指向已归档或不存在的 Codex 线程
- `<CONNECTOR_NAME>` 会话索引 JSON 损坏或 BOM 导致无法解析
- 当前 hook session 映射到错误本地 session
- 路由、归档或自动登记脚本在模型收到消息前失败
- <CONNECTOR_NAME> 进程中断、重启后 active 映射回退、消息进入前被拦截
- Codex 远端 `responses/compact`、`403 Forbidden` 或 `Unable to load site` 导致当前 <CONNECTOR_NAME> 调用链路卡住

当前脚本映射：

- `scripts/Repair-CcConnectArchivedSession.ps1`
- `scripts/Merge-FeishuGroupSessions.ps1`
- `scripts/Merge-FeishuPersonalSessions.ps1`
- `scripts/Merge-AllFeishuPersonalSessions.ps1`
- `scripts/Run-<CONNECTOR_NAME>.ps1`
- `scripts/Install-CcConnectHooks.ps1`
- `scripts/Test-CcConnectHealth.ps1`
- `scripts/Run-CcConnectHealthMonitor.ps1`

守门要求：

- 这类失败通常不会进入模型上下文，必须写入本地错误日志或修复日志，并由只读巡检检查断档。
- 修复会话索引必须先备份 JSON，写回必须使用无 BOM UTF-8，并验证 `<CONNECTOR_NAME> sessions list` 和目标 session 映射。
- 如果无法停止旧进程，应先把已归档线程临时解除归档作为止血，再提示需要管理员重启 `<CONNECTOR_NAME>`。
- 如果同一员工或同一群聊出现多个本地窗口，先 dry-run 合并映射，再执行修复；不得删除旧窗口。
- 自动恢复完成后，必须验证新消息仍进入同一个个人或群聊长期窗口。
- 命中 Codex 远端 403/compact 错误时，先运行极小 Codex 健康检查；只有健康检查成功且冷却时间允许时，才自动重启 `<CONNECTOR_NAME>`。如果健康检查失败，记录为模型运行时降级，不做无意义反复重启。

只读巡检至少检查：

- `log/<CONNECTOR_NAME>-run.err.log` 是否出现新增错误。
- `log/<CONNECTOR_NAME>-run.log` 是否近期有启动记录。
- `log/<CONNECTOR_NAME>-run.log` 是否新增 `403 Forbidden`、`responses/compact`、`Unable to load site` 或 `codexSession` 失败，并由健康巡检写入 `log/<CONNECTOR_NAME>-health.log`。
- 路由、归档、会话一致性、修复脚本的日志是否近期断档或连续失败。
- 自动化和群聊 profile 是否仍要求销售试点不发群、新媒体专属复盘不被复制。

## 3. 出站安全 hook

触发事件：`message.sent`、主动发送脚本调用前、模型回复含本地路径或生成物声明时。

目标：

- 拦截本地路径、内部目录、调试日志、session key、未脱敏 ID、token、密钥和不完整链接。
- 区分当前会话<AGENT_NAME>发送、人类账号代发、群聊发送、私聊发送和文件/图片交付。
- 防止员工请求的生成物被默认发送给 AI 管理账号。

当前脚本映射：

- `scripts/Guard-FeishuOutboundText.ps1`
- `scripts/Send-FeishuCurrentSessionMessage.ps1`
- `scripts/Send-FeishuMessage.ps1`
- `scripts/Invoke-LarkCliGuarded.ps1`

拦截或降级：

- 普通员工回复命中 `<LOCAL_DRIVE>\`、`<LOCAL_USER_HOME>\`、`.<CONNECTOR_NAME>`、`log\`、`temp\`、`<ORG_DIR>\` 等本地或内部路径时，必须改写为正文、附件说明或在线链接。
- 未经 <AI_ADMIN_ROLE>明确授权，不允许使用人类账号代发。
- 链接必须用单行普通文本格式：`说明文字：<原始URL>`。
- 发送失败时，不能声称已经完成交付；应改用正文拆分、附件、在线文档或可打开链接兜底。
- 当前 `<CONNECTOR_NAME>` 的 `message.sent` hook 是发送后事件，只能发现并记录异常，不能阻止已经发出的第一条文本。需要跨群主动发送正文时，发送前必须走 `Guard-FeishuOutboundText.ps1`、`Send-FeishuMessage.ps1` 或等价的 Base64/stdin 受保护路径；不得绕过守门直接用不可靠的多行 `--text` 链路。

## 4. 生成物交付 hook

触发事件：模型声明“已生成”“已做好”“图片做好了”“文件已保存”等，或近期 outputs 中出现新文件。

目标：

- 生成物完成条件是已经发到原始请求人的当前<MESSAGE_PLATFORM>会话或其明确指定且权限正确的位置。
- 图片、文件、表格、文档、压缩包不能只停留在本地目录。
- 生成物应先归入<MESSAGE_PLATFORM>请求来源对应的本地文件夹：个人私聊归入该员工文件夹的 `outputs` 目录，已注册群聊归入该群聊子智能体文件夹的 `outputs` 目录，然后再发送到原始请求会话。
- 自动交付 hook 必须把“归入请求来源 `outputs`”作为强制步骤：凡是待发送生成物不在当前请求来源对应的 `outputs` 内，必须先复制进去，再发送附件或图片。
- 如果<MESSAGE_PLATFORM>触发的任务把最终文件生成在 `.<CONNECTOR_NAME>/attachments`，自动交付 hook 必须先复制到当前路由的 `outputs` 目录，再作为附件发送；不能因为该目录不是普通输出目录就静默阻断。

当前脚本映射：

- `scripts/AutoDeliver-FeishuArtifactsOnSent.ps1`
- `scripts/AutoSend-CodexImageOnClaim.ps1`
- `scripts/Send-FeishuFile.ps1`
- `scripts/Send-FeishuImage.ps1`
- `scripts/Send-CodexGeneratedImage.ps1`

拦截或降级：

- 找不到当前路由或发送目标不明确时，不自动发给 <AI_ADMIN_ROLE>；应停止并请求确认。
- 图片生成成功但发送失败时，必须说明未交付成功并尝试重发或改成可打开链接/附件。
- 文件、表格、压缩包生成成功但发送失败时，必须说明未交付成功并尝试重发附件或改为在线文档/可打开链接；不得只回复本机路径。
- 普通员工要求保存到个人云空间时，必须先核验当前授权身份是否就是请求人本人。

## 5. 记忆写入守门

触发事件：每日复盘、每周压缩、员工长期记忆更新、群聊 `group_context.md` 更新、`tasks/TODO.md` 更新。

目标：

- 长期上下文只保存稳定偏好、协作事实、流程约定和可复用经验。
- 一次性任务、原始聊天、客户隐私、报价、合同、CRM 细节、员工隐私和调试日志不得进入长期上下文。
- 更新前先看 `agent_profile.json` 和 `context_budget.md`，超过阈值时生成压缩建议。

写入边界：

- `Company.md`、正式<HUMAN_KB_NAME>正文、`SUB_AGENT.md` 和规则文件默认只生成候选，需 <AI_ADMIN_ROLE>审核。
- 群聊 `group_context.md` 可按 profile 写入当前群聊稳定背景。
- 员工 `long_term_context.md` 只写该员工个人偏好和稳定协作信息。
- <HUMAN_KB_NAME>主要给人看；<AGENT_KB_NAME> 主要给 Agent 看。

## 6. 自动化写回守门

触发事件：每日复盘、每周沉淀、定时巡检、自动发送、自动建任务。

目标：

- 自动化必须先读取当前群聊或员工 profile，再判断是否允许发群、写回、跨群同步或创建知识库草稿。
- 自动化不得因为复用<CONTENT_TEAM>机制而把新媒体专属复盘复制给其他部门。
- 跨群同步不得只按“源群出现录音、会议纪要、日报或复盘材料”触发；必须先确认源群 profile 允许跨群同步、目标群已登记、同步正文非空，且本次内容确有适合目标群处理的脱敏条目。没有合适条目时跳过同步，不发送标题占位消息；有正文时也必须保留可读结构，不能把多条同步内容压成一整段。
- 销售内容同步新媒体时，必须先生成完整“新媒体同步版”正文，再发送；发送前守门通过、发送后读回确认正文存在之前，不得在源群写“已同步”。如果 `message.sent` hook 检测到 `empty_new_media_topic_sync`，这次同步视为失败，后续必须补发完整正文，而不是继续复用已发送标题。
- 自动化不得直接发布正式知识库内容；只能整理草稿或候选。

当前要求：

- <CONTENT_TEAM>保留现有专属每日复盘机制。
- <SALES_GROUP>是公司级每日轻量复盘试点，初期不向销售群发送每日摘要。
- 每周沉淀审核清单只发给 <AI_ADMIN_ROLE>本人，不发<ADMIN_GROUP>、<SALES_GROUP>、<CONTENT_TEAM>或其他部门群。
- 公司级知识库更新先整理为草稿；<HUMAN_KB_NAME>给人看，<AGENT_KB_NAME> 给 Agent 看。

## 7. 系统文件脱敏同步与 GitHub 发布 hook

触发事件：本地 Git `post-commit`、`pre-push`，以及系统维护任务结束时的手动调用。

目标：

- 系统文件发生长期规则变更后，自动把白名单 live 系统文件脱敏同步到 `templates/`。
- 发布时把 `templates/` 内容映射到 GitHub 仓库根目录，而不是发布 live 根目录，也不是发布远端嵌套 `templates/` 子目录。
- 发布前必须通过模板治理检查、敏感扫描和模板镜像发布脚本的 staged 检查；失败时不推送。

当前脚本映射：

- `scripts/Sync-LiveSystemToTemplates.ps1`
- `scripts/Invoke-SystemTemplateSyncHook.ps1`
- `scripts/Install-SystemTemplateSyncHook.ps1`
- `templates/scripts/Publish-TemplateMirror.ps1`

拦截或降级：

- hook 只能同步白名单系统文件，不扫描或复制聊天记录、附件、日志、客户资料、员工资料、CRM 明细、token、密钥或其他运行数据。
- hook 必须设置递归保护，避免模板发布过程中再次触发自己。
- 如果脱敏后仍命中真实路径、公司名、<MESSAGE_PLATFORM> ID、密钥或治理检查错误，必须中止发布并写入本地 hook 日志。
- hook 发布失败时，不得把 GitHub 视为已更新；后续维护任务必须先修复 hook 或手动执行同等流程。

## 最小验证

任何 hook、自动化或治理规则调整后，至少验证：

- 当前路由快照指向正确个人或群聊会话。
- `chat_history.md` 写入正确位置，没有个人/群聊混写。
- 模型前 `<CONNECTOR_NAME>` 错误有日志、可被巡检发现，并有恢复路径。
- 出站文本不包含本地路径、内部目录、session key、密钥或未脱敏 ID。
- 生成物已交付到原始请求会话，而不是只保存在本地。
- 跨群同步消息不是空正文、只有标题、空表格或难以阅读的一整段；如果业务判断无可同步条目，应无消息发送，并在源群或内部记录中说明跳过原因。
- 销售试点仍不发群，新媒体专属机制仍不被复制。
- 每周沉淀仍只生成审核草稿，并只发送给 <AI_ADMIN_ROLE>本人。
- 系统文件模板同步 hook 已安装，`NoPush` 模式能运行通过；真实发布只走 `templates/` 到 GitHub 根目录的镜像流程。

<!-- template-check: pre-model -->
