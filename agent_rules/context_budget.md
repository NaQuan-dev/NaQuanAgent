# 上下文预算规则

<!-- TEMPLATE ONLY - sanitized publishing mirror: generated from a private system file. Review placeholders before use. -->


本规则用于控制 `SUB_AGENT.md`、`group_context.md`、`long_term_context.md` 和 `tasks/TODO.md` 的长度，减少 Agent 因上下文过长忽略关键规则的风险。

## 软阈值

| 文件类型 | 建议上限 | 超过后处理 |
| --- | ---: | --- |
| `SUB_AGENT.md` | 120 行 | 只保留入口、身份、红线、路由；细节迁到 `group_context.md` 或按需规则 |
| `group_context.md` | 200 行 | 去重、合并、拆出历史摘要到 `archive` 或 `chat_history.md` |
| `long_term_context.md` | 80 行 | 保留当前画像、稳定偏好、长期任务和待确认；历史细节回到归档 |
| `tasks/TODO.md` | 160 行 | 按当前事项、技能建议、待确认、已完成归档分区 |
| `agent_profile.json` | 120 行 | 只保留机器判断字段，不写业务长文 |

## 写入前检查

- 是否把一次性任务、流水账、工具日志或完成态过程写成长记忆。
- 是否重复已有规则，只是换了表述。
- 是否包含本地路径、调试信息、open_id、chat_id、session key、token、密钥、客户隐私、报价、合同或 CRM 明细。
- 是否把群聊私有内容写进员工个人上下文，或把员工个人偏好写进公司事实。
- 是否越权修改 `Company.md`、正式<HUMAN_KB_NAME>、`SUB_AGENT.md` 或其他核心规则。

## 压缩原则

- 长期上下文是“当前有效画像和规则”，不是第二份聊天记录。
- 旧结论如果仍有效，合并为一条更短规则；如果已过时，改为归档索引或移除。
- 未确认事实只放 `tasks/TODO.md` 或每周审核草稿，不写成确定结论。
- 自动化没有足够证据时，输出“无稳定新沉淀”，不要制造规则。
