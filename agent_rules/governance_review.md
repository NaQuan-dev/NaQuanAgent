# 智能体治理复盘复用工作流

<!-- TEMPLATE ONLY - sanitized publishing mirror: generated from a private system file. Review placeholders before use. -->


本规则用于复用“先盘点、再设计、再候选、再校验、再发布”的治理模式。以后遇到整理、沉淀、复盘、优化智能体工作内容、规则体系、上下文、hook、自动化、知识库、common error 或 GitHub 模板发布等任务时，先读取本文件。

## 触发场景

- 用户要求整理、沉淀、复盘、优化智能体工作内容。
- 用户要求推广某个部门已有能力到其他部门，但保留原部门内容不变。
- 用户要求检查 Agent 漏洞、上下文过长、规则被忽略、hook、自动化、知识库更新、common error 更新。
- 用户要求升级或调整智能体运行方式、`<CONNECTOR_NAME>`、worker、hook、自动化、子智能体路由、记忆规则或交付行为。
- 用户要求把当前运行规则脱敏后发布到 GitHub。
- 自动化或每周沉淀任务发现规则、上下文、知识库、common error 或 hook 需要系统化整理。

## 总原则

- 不从结论开始改文件；先读注册表和短入口，确认真实运行目录、模板目录和本次任务边界。
- 不把 `templates/` 当作当前运行规则；命中模板只能说明有公开模板，不能代替私有运行工作区。
- 先生成候选和草稿，再进入正式规则、正式知识库或公开模板。
- 机器可读配置优先落到 `agent_profile.json`、`rule_registry.json`、状态表或校验脚本；人可读说明再写入 Markdown。
- <HUMAN_KB_NAME>主要给人看；<AGENT_KB_NAME> 主要给 Agent 看。
- common error 必须从“事后记录”变成“事前预检”；自动化只能整理候选，不能直接改正式 `COMMON_ERRORS.md`。
- 同一类墙重复出现时，不能继续只靠文档提醒；第三次重复必须评估升级为 `common_error_registry.json`、worker 预检、hook、脚本默认行为或只读巡检。
- hook 负责模型前、模型后和交付链路的兜底；模型规则不能覆盖事件根本没进模型的场景。

## 固定执行顺序

### 1. 读短入口

按任务相关性读取，不一次性加载全部文件：

- `rule_registry.md` / `rule_registry.json`
- `index.md`
- `common_error_preflight.md` 和仓库根目录 `COMMON_ERRORS.md`
- `common_error_registry.json` 和 `scripts/Resolve-CommonErrorPreflight.ps1`
- `context_budget.md`
- `hook_guardrails.md`
- `memory_context.md`
- 相关群聊或员工的 `agent_profile.json`、`SUB_AGENT.md`、`group_context.md`
- `memory_review/README.md` 和相关候选文件
- 涉及 GitHub 发布时，再读取 `git_publish_safety.md` 和公开 `templates/`

### 2. 先盘点现状

至少盘点：

- 哪些规则是真实运行规则，哪些只是模板。
- 哪些文件是人读的，哪些是 Agent 读的，哪些是机器可读配置。
- 当前自动化有哪些，是否会发群、写回、跨群同步或发布知识库。
- 当前 hook 覆盖哪些阶段：入站、模型前错误、出站、生成物交付、记忆写入、自动化写回。
- 是否已有 common error 条目或候选。
- 是否已有机器可读避墙条目，是否已经接入 worker、hook 或脚本默认行为。
- 是否存在上下文过长、重复规则、部门专属机制被泛化、正式资料被自动化直接改写等风险。

### 3. 给出落地计划

计划必须区分：

- 直接写回项：低风险、当前群/员工范围内、profile 允许的长期上下文或 TODO。
- 候选项：公司事实、`SUB_AGENT.md`、正式知识库、`COMMON_ERRORS.md`、跨部门 SOP、公开模板。
- 校验项：JSON 解析、PowerShell 解析、敏感扫描、上下文预算、自动化 prompt 检查、hook/<CONNECTOR_NAME> 错误日志检查。
- 需要用户确认的事项：发送范围、是否发群、是否发布到 GitHub、是否直接改正式资料。
- 智能体系统文件同步项：运行方式、连接器、worker、hook、自动化、子智能体继承、记忆或交付行为有变化时，同步规划根规则、公司级规则、相关群规则、机器配置和预检文档的更新；除非只是一次性临时调试且不改变长期运行规则。

### 4. 分层落地

优先按这个顺序做：

1. 系统文件同步检查：凡是运行方式、连接器、worker、hook、自动化、子智能体继承、记忆或交付行为发生长期变化，必须同步更新相关实时系统文件；默认范围包括 `<ORG_DIR>/AGENTS.md`、`<RULES_DIR>/index.md`、`rule_registry.json`、相关群 `SUB_AGENT.md`、`group_context.md`、`agent_profile.json`、运行说明和 common error/preflight 文档。
2. 规则入口：更新 `index.md`、`rule_registry.json` 和必要的说明文档。
3. 机器配置：更新或新增 `agent_profile.json`、状态表、自动化配置。
4. 候选区：更新 `memory_review/*_pending.md`、`knowledge_intake_status.csv`、`common_errors_update_pending.md`。
5. Hook 守门：补充 `hook_guardrails.md`，明确模型前错误不能靠模型规则兜底。
6. 自动化：更新定时任务，让它读 profile、只做允许的写回，并把正式资料改为候选。
7. 避墙执行：更新 `common_error_registry.json`、resolver、worker 预检、hook 或脚本默认行为，让重复错误在执行前被绕开。
8. 校验脚本：更新只读治理校验，确保以后这套规则不悄悄失效。
9. GitHub 发布：只把脱敏英文模板放入 `templates/`，不发布私有运行规则。

### 5. 验证

最小验证包括：

- JSON 文件可解析。
- PowerShell 模板或脚本可解析。
- 治理校验脚本通过，或明确列出 warning/error。
- 暂存区或发布目录不包含真实 token、密钥、用户 ID、会话 ID、群聊 ID、本地绝对路径、客户/员工隐私。
- `templates/` 不会被当作运行规则。
- 涉及自动化时，检查自动化仍符合发送范围和写回边界。
- 涉及 <CONNECTOR_NAME>/hook 时，检查模型前错误有日志、巡检和恢复路径。
- 涉及智能体运行升级时，检查根规则、公司级规则索引、注册表、相关群规则和运行说明是否已经同步更新；未同步时必须说明原因。

### 6. 输出给用户

最终回复先给：

- 已做什么。
- 哪些内容进入正式规则，哪些只是候选或草稿。
- 验证结果。
- 剩余风险或未处理项。

不要用本地路径作为普通交付结果。<AI_ADMIN_ROLE>维护场景可以引用文件名和必要路径，但不把真实业务数据、会话标识或私有日志内容暴露给普通员工。

## 禁止事项

- 不把某个部门专属机制直接复制给全公司。
- 不把正式知识库、公司事实、`SUB_AGENT.md`、`COMMON_ERRORS.md` 交给自动化直接改，除非 <AI_ADMIN_ROLE>明确要求。
- 不把 common error 写成真实事故日志；只能写通用现象、原因、提前策略和验证方式。
- 不因 GitHub 发布需求把私有运行目录、真实规则、真实聊天记录或业务资料提交到模板仓库。
- 不把模型前连接器失败归因成模型不听规则，必须先查 hook、路由快照、日志和会话索引。

<!-- template-check: sanitized template -->
