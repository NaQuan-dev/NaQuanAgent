# <AGENT_KB_NAME> 公司知识库读取规则

<!-- TEMPLATE ONLY - sanitized publishing mirror: generated from a private system file. Review placeholders before use. -->


本规则用于让<AGENT_NAME>和各群聊子 Agent 在工作时稳定读取 <AGENT_KB_NAME> 版公司知识库。<AGENT_KB_NAME> 主要给 Agent 看，是本地 Agent 检索、交叉关联、任务手册、执行路径和沉淀候选入口；<HUMAN_KB_NAME>主要给人看，用于员工长期阅读、协作和复用的正式 SOP、FAQ、模板和资料正文。<AGENT_KB_NAME> 不是普通员工的交付渠道，也不是替代权限校验的公开资料库。

## 入口

- <AGENT_KB_NAME> vault 名称：`<COMPANY_SHORT_NAME>`。
- 本地 vault：`<WORKSPACE_ROOT>\<ORG_DIR>\知识库\<COMPANY_SHORT_NAME>`。
- <AGENT_KB_NAME> CLI：`D:\obsidian\<AGENT_KB_NAME>.com`。
- 首读入口：`欢迎.md`、`99_<AGENT_NAME>工作台\<AGENT_NAME>检索指南.md`。
- 线上<HUMAN_KB_NAME>对照：`13_<HUMAN_KB_NAME>同步\<HUMAN_KB_NAME>当前对照.md`。
- 聊天沉淀入口：`99_<AGENT_NAME>工作台\聊天沉淀候选总览.md`。
- <GRAPH_DIAGNOSTICS_TOOL> 诊断候选入口：`99_<AGENT_NAME>工作台\<GRAPH_DIAGNOSTICS_TOOL>关系诊断候选.md`。
- Agent Dashboard 入口：`99_<AGENT_NAME>工作台\<AGENT_NAME> Agent Dashboard使用说明.md` 和本地插件 `xiaoquan-agent-dashboard`。

## 什么时候读取

遇到以下任务时，先读取本规则，再按任务读取 <AGENT_KB_NAME>：

- 任何需要“查公司文件”“看公司资料”“按公司资料回答”“参考知识库/资料库/手册”的任务。
- 公司介绍、产品资料、销售资料、新媒体资料、共享资料、受控资料边界。
- SOP、FAQ、模板、员工培训、制度说明、正式资料目录、对外可发布资料。
- 产品选型、客户痛点、销售接待、交付售后、新媒体内容、报价/合同/证书/资料发送边界。
- <AGENT_NAME>执行类任务：报价文件检查、销售纪要同步新媒体、新媒体选题入库、财务月报交付、管理会议任务单。
- 需要判断某条聊天记录、群聊经验或员工反馈是否应沉淀到<HUMAN_KB_NAME>、<AGENT_KB_NAME> 或 `Company.md`。

## 推荐读取顺序

公司资料类任务的默认读取链路：

1. 先读 `Company.md`，取得稳定公司事实、业务边界和对外表达红线。
2. 再查 <AGENT_KB_NAME> 的主题地图和任务手册，取得<AGENT_NAME>可执行路径。
3. 如涉及员工可见的正式文档，以<HUMAN_KB_NAME>当前正文或 <AGENT_KB_NAME> 中的<MESSAGE_PLATFORM>对照页确认是否已有正式版本。
4. 如涉及当前群聊的任务背景，再读当前群 `group_context.md` 和任务必要片段。
5. 不用其他群聊的私有资料、聊天记录、文件或归档来补公司认知。

## 检索方法

优先使用 <AGENT_KB_NAME> CLI：

```powershell
& 'D:\obsidian\<AGENT_KB_NAME>.com' search query='<关键词>' format=json
```

常用关键词：

- 公司：公司档案、业务边界、核心能力、资质、交付流程。
- 产品：产品总览、灌封设备系列、整线交付、低氧、换型、罐型、盖型。
- 销售：<SALES_DEPARTMENT>标准流程、用户画像、痛点话术、CRM、报价、合同。
- 新媒体：企业 IP、创始人人设、内容工作流、表达边界、文案库、选题库。
- Agent 任务：销售纪要同步新媒体、报价文件检查、选题入库、财务月报、会议任务单。
- 治理：资料分级、受控资料边界、共享资料使用规则、<HUMAN_KB_NAME>当前对照。
- <GRAPH_DIAGNOSTICS_TOOL>：关系诊断、孤立节点、规则冲突候选、知识库健康检查。
- Dashboard：Agent Dashboard、操作中心、<AGENT_NAME>工作台、状态面板、任务卡片、worker 状态。

如果 <AGENT_KB_NAME> CLI 不可用，可退回直接读取 vault 内 Markdown；直接读取时仍必须先看 `<AGENT_NAME>检索指南.md`，不要只按文件名猜结论。

## 可用范围

- `sensitivity: internal`、`sensitivity: shareable` 且任务必要的内容，可用于<AGENT_NAME>内部判断和普通员工答复。
- `sensitivity: controlled-index` 只可用于判断资料边界、授权要求和下一步确认动作，不得展开原件内容。
- `agent_ready: true`、`status: active` 的页面优先；`review`、`candidate`、`draft`、`needs-review` 只能作为候选，不可当作确定事实。
- 任务手册用于指导<AGENT_NAME>做事，不应原文发给普通员工；普通员工只需要结果、正文、清单或文件交付。

## 外发边界

- 面向普通员工或客户回复时，不提 <AGENT_KB_NAME>、本地 vault、本地路径、`.obsidian`、工作区目录或内部检索过程。
- 回答时只输出对用户有用的结论、话术、清单、正文或下一步动作。
- 生成物的完成条件仍是发到原始<MESSAGE_PLATFORM>会话或明确授权的位置；<AGENT_KB_NAME> 中有文件不等于已交付。
- 价格、合同、客户信息、财务、人事、图纸、证书原件、系统 token、会话 ID、员工个人信息不能从 <AGENT_KB_NAME> 直接外发。

## 知识沉淀规则

- 稳定、已确认、公司级事实：先形成候选，再由 <AI_ADMIN_ROLE>或负责人确认后进入 `Company.md`。
- 员工需要长期复用的 SOP、FAQ、模板、正式资料：优先整理到<HUMAN_KB_NAME>，并在 <AGENT_KB_NAME> 建对照或索引。
- <AGENT_NAME>执行路径、跨群协作规则、权限判断、检索地图、候选沉淀：优先进入 <AGENT_KB_NAME>。
- 同一条内容如果既要给人看又要给 Agent 用，先整理成人可读的<HUMAN_KB_NAME>草稿，再在 <AGENT_KB_NAME> 建索引、任务手册或执行提示。
- <GRAPH_DIAGNOSTICS_TOOL> 自动输出只作为诊断候选；原始输出留在 `graphify-out/`，导出的 <AGENT_KB_NAME> Markdown 如需浏览应放在 `graphify-out/obsidian/` 作为独立临时 vault，不直接合并进主 vault。
- <GRAPH_DIAGNOSTICS_TOOL> 发现必须回到源文件确认后，才能整理成 <AGENT_KB_NAME> 主库中的候选摘要、复核任务或正式结论。
- 原始聊天、录音逐字稿、客户隐私、员工隐私、报价、合同、路径和调试日志不进入普通知识正文。

## 冲突处理

- `Company.md` 与 <AGENT_KB_NAME> 冲突时，先以 `Company.md` 为事实基线，并记录 <AGENT_KB_NAME> 待复核。
- <HUMAN_KB_NAME>正式正文与 <AGENT_KB_NAME> 导入页冲突时，先检查 `<HUMAN_KB_NAME>当前对照.md`，必要时重新拉取<MESSAGE_PLATFORM>当前版本。
- 群聊上下文与公司资料冲突时，不把群聊内容写成公司事实；先标记待确认。

<!-- template-check: human-KB current-version map -->
