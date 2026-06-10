# Reusable Agent Framework

这是一个可复用的 Agent 工作区框架仓库。它只保存框架、模板、脚本骨架和脱敏文档；真实组织资料、员工信息、外部消息会话、日志、运行状态和密钥应保存在使用者自己的本地私有目录中，并被 Git 忽略。

## 适用场景

- 为一个团队建立本地 Agent 工作区。
- 把根 `AGENTS.md` 拆成最小常驻规则和按需读取规则。
- 为不同项目、群组或部门建立子 Agent 上下文模板。
- 给外部消息平台、任务系统或业务系统接入预留脚本骨架，但不提交真实实现和凭据。

## 仓库内容

```text
AGENTS.md                  # 本框架仓库自身的维护规则
COMMON_ERRORS.md           # 通用问题记录模板
SUBAGENTS.md               # 子 Agent 模板索引
docs/                      # 架构和发布安全说明
templates/AGENTS.md        # 新工作区根规则模板
templates/agent_rules/     # 按需读取规则模板
templates/subagent/        # 子 Agent 模板
templates/subagents/       # 具体场景子 Agent 模板
templates/scripts/         # 脚本骨架，只做 dry-run 或占位
scripts/README.md          # 真实本地脚本不进仓库的说明
```

## 不包含

- 真实公司或组织资料。
- 真实用户、员工、客户、供应商或联系人信息。
- 外部平台会话、聊天记录、附件、群组或用户 ID。
- 日志、缓存、下载、临时文件和运行状态。
- token、密钥、账号密码、app secret、cookie 和私有配置。

## 使用方式

1. 复制 `templates/AGENTS.md` 到你的真实工作区根目录。
2. 按需要复制 `templates/agent_rules/` 到真实工作区的私有规则目录。
3. 为每个项目或子 Agent 复制 `templates/subagent/`。
4. 需要新媒体内容运营场景时，可复制 `templates/subagents/new_media/`。
5. 将真实数据目录、运行目录、日志目录和密钥配置加入本地 `.gitignore`。
6. 根据 `docs/publish_safety.md` 做提交前检查。

## 安全原则

- GitHub 仓库只保存可复用框架，不保存真实运行数据。
- 所有示例必须使用 `<PLACEHOLDER>`。
- 任何会触达外部系统的脚本必须默认 dry-run。
- 如果历史提交曾包含敏感信息，删除当前文件不能清除历史，需要单独处理 Git 历史。
