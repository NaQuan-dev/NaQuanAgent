# <GRAPH_DIAGNOSTICS_TOOL> 关系诊断规则

<!-- TEMPLATE ONLY - sanitized publishing mirror: generated from a private system file. Review placeholders before use. -->


<GRAPH_DIAGNOSTICS_TOOL> 是自动关系图和健康检查工具，不是第三套正式知识库，也不是事实来源。它用于帮助<AGENT_NAME>和维护者发现代码、规则、模板、<AGENT_KB_NAME> 页面之间的结构关系、孤立节点、冲突候选和缺口提示。

## 定位

| 层 | 角色 | 谁读 | 内容类型 |
|---|---|---|---|
| <HUMAN_KB_NAME> | 正式人类知识库 | 员工、管理者 | SOP、制度、说明、培训、可发布文档 |
| <AGENT_KB_NAME> 主库 | Agent 长期知识库 | <AGENT_NAME>、维护者 | 执行手册、检索地图、系统边界、规则索引、经验沉淀 |
| <GRAPH_DIAGNOSTICS_TOOL> | 自动关系图和诊断层 | <AGENT_NAME>、维护者 | 自动抽取的关系、桥接节点、缺口提示、冲突候选 |

## 输出边界

- <GRAPH_DIAGNOSTICS_TOOL> 原始输出保留在 `graphify-out/`。
- `graphify-out/graph.html` 和 `graphify-out/graph.json` 是分析产物，只可作为诊断输入。
- 如果 <GRAPH_DIAGNOSTICS_TOOL> 导出 <AGENT_KB_NAME> Markdown，只放在 `graphify-out/obsidian/`，必要时作为独立临时 vault 打开。
- 不要把 <GRAPH_DIAGNOSTICS_TOOL> 全量导出直接合并进 `<ORG_DIR>/知识库/<COMPANY_SHORT_NAME>` 主 vault。
- 不要把 <GRAPH_DIAGNOSTICS_TOOL> 发现自动写入<HUMAN_KB_NAME>、`Company.md`、`AGENTS.md`、`SUB_AGENT.md` 或正式 `agent_rules`。

## 允许使用的场景

- 检查规则之间是否存在明显冲突或重复。
- 找出孤立的 <AGENT_KB_NAME> 页面、规则文件或脚本入口。
- 发现模板目录被误当成 live 规则的风险。
- 发现 `COMMON_ERRORS.md`、`common_error_registry.json` 和相关脚本之间缺少关联。
- 分析 worker、hook、交付脚本、<CONNECTOR_NAME>、<MESSAGE_PLATFORM>归档、小工单、CRM 等模块关系。
- 为系统治理、知识库整理、发布安全检查提供候选线索。

## 禁止做的事

- 不把 <GRAPH_DIAGNOSTICS_TOOL> 结果当成权威结论。
- 不把自动图谱里的关系自动发布给员工。
- 不把 <GRAPH_DIAGNOSTICS_TOOL> 全量 Markdown 导入 <AGENT_KB_NAME> 主库。
- 不让 <GRAPH_DIAGNOSTICS_TOOL> 覆盖人工整理过的 <AGENT_KB_NAME> 页面。
- 不把原始聊天、日志、客户隐私、员工隐私、账号 ID、密钥或 token 写入 <GRAPH_DIAGNOSTICS_TOOL> 候选页。
- 不因为 <GRAPH_DIAGNOSTICS_TOOL> 找不到某个关系，就判断该文件无用或可以删除。

## 候选升级流程

1. 先读取 <GRAPH_DIAGNOSTICS_TOOL> 原始输出，形成候选发现。
2. 对每条候选发现回到源文件确认，不能只凭图谱节点判断。
3. 如果只是结构提示，记录到 <AGENT_KB_NAME> 工作台候选页。
4. 如果影响运行安全、交付行为、worker、hook、自动化或子智能体路由，按 `governance_review.md` 同步更新相关系统文件。
5. 如果是高频撞墙经验，补充到 `COMMON_ERRORS.md` 和 `common_error_registry.json`。
6. 如果需要给员工长期阅读，先整理成人类可读文档，再进入<HUMAN_KB_NAME>流程。

## <AGENT_KB_NAME> 写入规则

- 主 vault 只接收人工确认后的摘要、入口、复核任务和结论。
- 推荐入口为 `99_<AGENT_NAME>工作台/<GRAPH_DIAGNOSTICS_TOOL>关系诊断候选.md`。
- <GRAPH_DIAGNOSTICS_TOOL> 候选页必须标明来源是自动诊断，不得写成已确认事实。
- 进入正式任务手册或规则页前，必须有人工确认或可复现验证。

## 复核清单

- 是否回到源文件确认过？
- 是否只是候选，而不是事实？
- 是否涉及隐私、账号、密钥、客户或员工信息？
- 是否需要同步 `agent_rules/index.md`、`rule_registry.json` 或 <AGENT_KB_NAME> 入口？
- 是否需要补 `COMMON_ERRORS.md`？
- 是否会影响普通员工看到的<HUMAN_KB_NAME>正文？

<!-- template-check: not an authoritative knowledge source -->
