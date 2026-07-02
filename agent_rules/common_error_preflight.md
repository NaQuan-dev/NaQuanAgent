# 常见错误预检

<!-- TEMPLATE ONLY - sanitized publishing mirror: generated from a private system file. Review placeholders before use. -->


本规则用于把 `COMMON_ERRORS.md` 从“事后记录”变成“事前预检”和“避墙系统”。遇到已知高风险任务时，不等报错后再查经验；先按任务类型读取对应条目，应用提前策略，再执行工具或修改。

机器可读入口：

- `<RULES_DIR>/common_error_registry.json` 保存已知墙的 `do_not_try`、`use_instead` 和 `verify`。
- `scripts/Resolve-CommonErrorPreflight.ps1` 根据任务文本、任务类型、来源和路由摘要匹配已知墙。
- <AGENT_NAME>后台 worker 在执行 Codex 前必须把匹配到的避墙结果注入任务 prompt。

全局 <MEMORY_TOOL> 召回层：

- `naquan-global` 保存 Common Error 的全局可召回记忆，用于让<AGENT_NAME>在任务开始前更快想起高频错误、失败路径、推荐绕法和验证方式。
- 通过 <MEMORY_TOOL> MCP 读取或写入全局避坑记忆时，显式传入 `agent_id = naquan-global`；不要使用部门默认 agent。
- <MEMORY_TOOL> 不是权威来源；命中 Common Error 场景时，仍以 `COMMON_ERRORS.md`、`common_error_registry.json` 和本文件为准。
- 写入 <MEMORY_TOOL> 时应保留有用的技术细节，例如错误类别、组件名、脚本/命令家族、文件类型、失败机制、`do_not_try`、`use_instead` 和 `verify`。
- 不把原始聊天、日志全文、客户/员工隐私、token、密钥、`open_id`、`chat_id`、session key 或可外泄业务数据写入 <MEMORY_TOOL>。

## 读取时机

以下任务开始前，先读取仓库根目录 `COMMON_ERRORS.md` 的相关条目：

- 修改 JSON、TOML、YAML、PowerShell、脚本入口、连接器配置或自动化配置。
- 发送、写入或传递中文、多行文本、长文案、JSON、Base64、URL 或命令行参数。
- 处理模型容量、限流、上下文窗口、长附件、长引用链、群聊历史或录音逐字稿。
- 处理 Codex 远端 `403 Forbidden`、`responses/compact`、`Unable to load site`、桌面窗口不活跃导致任务停滞或 <CONNECTOR_NAME> 调用链路卡住。
- 查找真实运行目录、员工资料、群聊子 Agent、私有知识库或被 `.gitignore` 隐藏的内容。
- 做 Git 提交、模板同步、公开仓库整理或敏感信息扫描。
- 处理 `<CONNECTOR_NAME>`、hook、会话恢复、线程归档、路由快照、消息归档或事件没有进入模型层的问题。
- 处理<MESSAGE_PLATFORM>端生成文件、表格、图片、压缩包、附件自动交付或“本地已生成但员工没收到”的问题。
- 处理跨群同步、销售素材同步新媒体、短视频选题同步、只发标题、空正文、正文被截断或“没有内容”的问题。
- 升级或调整智能体运行方式、worker、hook、自动化、子智能体路由、记忆规则或交付行为。

## 预检步骤

1. 先运行 `scripts/Resolve-CommonErrorPreflight.ps1` 或按同等逻辑匹配 `common_error_registry.json`，找出任务命中的已知墙。
2. 如果 <MEMORY_TOOL> 可用，召回 `naquan-global` 中与任务相关的 Common Error 记忆，用于补充提醒，但不替代机器注册表。
3. 对命中的墙，先执行 `do_not_try` 禁止项检查，禁止先硬闯已知失败路径。
4. 直接采用 `use_instead` 推荐绕法；只有推荐绕法不适用时，才说明原因并选择同等安全路径。
5. 执行后按 `verify` 和 `COMMON_ERRORS.md` 里的验证方式做最小验证。
6. 如果出现新错误，先判断是否是已知条目的变体；不是变体时，整理成候选，等待 <AI_ADMIN_ROLE>审核后追加。

重复撞墙升级规则：

- 第一次遇到可复用墙：写入候选或补充现有候选。
- 第二次重复：合并进正式 common error 或机器可读 registry。
- 第三次重复：必须评估并新增 hook、脚本默认行为、worker 预检或只读巡检；不能继续只靠文档提醒。

## 更新机制

`COMMON_ERRORS.md` 的更新分为候选、审核、合并三步：

1. 日常任务或每周沉淀发现可复用错误经验时，先写入 `<MEMORY_REVIEW_DIR>/common_errors_update_pending.md`。
2. 候选应保留足够精确的技术细节，只排除不应长期保存或可能外泄的信息。
3. 候选必须先查重：已有条目能覆盖时，只提出补充或改写建议。
4. <AI_ADMIN_ROLE>审核通过后，才允许合并到仓库根目录 `COMMON_ERRORS.md` 或 `common_error_registry.json`。
5. 合并后可把对应摘要同步写入 `naquan-global`，用于后续召回。
6. 合并后运行治理校验，确认根规则、规则索引、注册表、resolver 输出和敏感扫描仍通过。

## 候选标准

应进入候选：

- 同类任务可能重复遇到的问题。
- 已经明确提前策略和验证方式的问题。
- 发生在模型前、工具层、编码层、文件格式层、权限路由层或交付链路的问题。
- 可以脱敏成通用工程经验的问题。

不应进入候选：

- 某个员工、客户、群聊或业务系统的具体事实。
- 单次偶发且没有通用提前策略的问题。
- 只能靠人工判断、没有可复用验证方式的问题。
- 含真实路径、真实 ID、token、密钥、日志全文、聊天全文或客户/员工隐私的问题。

## 不允许

- 不把 `COMMON_ERRORS.md` 当成聊天日志、业务事实库或真实运行记录。
- 不写真实组织、员工、客户、会话 ID、open_id、chat_id、token、密钥、外部系统地址或本地私有路径细节。
- 不因为常见错误条目存在，就绕过权限、脱敏、交付确认或人工审核。
- 不把“事后报错再重试”当作默认策略；已记录的问题必须先用提前策略。

## 与其他规则的关系

- `runtime_limits.md` 负责容量、上下文和长内容处理的详细规则。
- `hook_guardrails.md` 负责<MESSAGE_PLATFORM>、`<CONNECTOR_NAME>`、模型前错误、出站和生成物交付守门。
- `workspace_io.md` 负责本地文件、日志、临时目录和编码细节。
- `git_publish_safety.md` 负责提交、推送和公开模板安全。
- `COMMON_ERRORS.md` 只保存通用现象、原因、提前策略和验证方式，是上述规则的错误案例索引。
- `common_error_registry.json` 是机器可读避墙索引，负责让 worker、hook 和脚本在任务开始前绕开已知失败路径。
