# 公司资料与事实来源

<!-- TEMPLATE ONLY - sanitized publishing mirror: generated from a private system file. Review placeholders before use. -->


policy_anchor: `group_chat_isolation_active`
policy_anchor: `conversation_context_isolation`

## 事实来源

- 涉及公司业务、公司文件、产品数据、客户画像、销售资料、新媒体资料、SOP、FAQ、模板、员工可见正式资料或营销内容时，不得只靠模型记忆回答；必须先读取本规则。
- `<WORKSPACE_ROOT>\<COMPANY_FACTS_FILE>` 是稳定公司事实、业务边界和对外表达红线的主要来源。
- <HUMAN_KB_NAME>主要给人看，承载员工长期阅读、协作和复用的正式 SOP、FAQ、模板和资料正文。
- <AGENT_KB_NAME> 主要给 Agent 看；本地 vault `<WORKSPACE_ROOT>\<ORG_DIR>\知识库\<COMPANY_SHORT_NAME>` 是<AGENT_NAME>检索公司资料、主题地图、任务手册、执行路径和知识沉淀候选的入口；读取方式和外发边界见 `agent_knowledge.md`。
- 公司资料类任务默认读取链路：先读 `Company.md`，再读 `agent_knowledge.md`，再从 <AGENT_KB_NAME> 的 `欢迎.md`、`99_<AGENT_NAME>工作台\<AGENT_NAME>检索指南.md`、主题地图和任务手册检索必要资料。
- 涉及员工可见的正式 SOP、FAQ、模板、制度、培训、说明或对外可发布资料时，必须按 <AGENT_KB_NAME> 的 `13_<HUMAN_KB_NAME>同步\<HUMAN_KB_NAME>当前对照.md` 查找已确认正文，并在必要时回到公司<HUMAN_KB_NAME>核对当前线上版本。
- 群聊上下文、聊天记录或个人记忆不能替代公司资料来源；当前会话没有路由到某群时，也不得读取该群私有资料来补公司认知。
- 公司资料读取仍受身份、权限、资料敏感程度和任务必要性约束；群聊目录是运行时上下文边界，不是绕过权限的资料入口。

## 公司公开事实口径

- 公司：<COMPANY_LEGAL_NAME>。
- 业务方向：精酿啤酒灌装封口设备研发、生产，以及整线交钥匙工程。
- 典型客户：精酿酒馆、前店后厂、精酿酒厂、包装/代工客户、整线扩产客户和海外精酿客户。
- 内容创作或业务分析中，重点围绕设备可靠性、溶氧控制、灌装精度、换型效率、交钥匙交付和售后响应展开。
- 涉及竞品时保持事实口径，不做无依据贬低。
- 不得捏造技术参数、产能、客户案例、认证、销量、合作方或交付承诺。

## 受控资料

- `<WORKSPACE_ROOT>\<ORG_DIR>\知识库\06_受控资料\00_部门受控资料` 用于放置技术图纸、财务、人事、客户隐私、供应商敏感信息等敏感资料。
- 访问受控资料时，按用户权限、任务必要性和管理员要求谨慎处理。
- 技术图纸、报价底价、财务数据、人事资料、客户隐私、供应商敏感信息等只允许放入 `<WORKSPACE_ROOT>\<ORG_DIR>\知识库\06_受控资料` 或明确授权的群聊工作区，不得放入 `<WORKSPACE_ROOT>\<ORG_DIR>\知识库\05_可共享资料`。
- 受控资料不得自动复制、摘要、转发或迁移到其他群聊。
- 确需处理时必须由 <AI_ADMIN_ROLE>退出<MESSAGE_PLATFORM>群聊上下文，在本地维护上下文中明确授权来源、目标和用途。
- 访问 `<WORKSPACE_ROOT>\<ORG_DIR>\知识库\06_受控资料` 应记录到 `<WORKSPACE_ROOT>\<ORG_DIR>\知识库\06_受控资料\00_部门受控资料\access_log.md`。

## 核心文件保护

- 不直接修改 `<WORKSPACE_ROOT>\<COMPANY_FACTS_FILE>`、`<WORKSPACE_ROOT>\<ORG_DIR>\Buddy.md` 或其他核心规则文件，除非 <AI_ADMIN_ROLE>明确批准。
- 通过<MESSAGE_PLATFORM>接入的普通员工不允许修改 `<WORKSPACE_ROOT>\<ORG_DIR>\AGENTS.md` 或框架根目录 `<WORKSPACE_ROOT>\AGENTS.md`。

<!-- template-check: human knowledge base -->
