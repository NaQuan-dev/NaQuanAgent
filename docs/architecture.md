# Architecture

本框架采用“核心规则常驻、详细规则按需读取”的结构，目标是减少上下文占用，同时保留可审计的安全边界。

## 核心层

- 根 `AGENTS.md` 只保存高频、低变化、必须始终遵守的规则。
- 根规则不写真实组织信息、真实人员信息和真实系统参数。
- 根规则通过路由表指向按需读取的规则文件。

## 规则层

`templates/agent_rules/` 提供可复制的规则模板：

- `identity_access.md`：用户身份、权限和资料访问。
- `external_actions.md`：外部消息、任务、日程、邮件等触达动作。
- `memory_context.md`：长期上下文、压缩和沉淀。
- `workspace_io.md`：文件、日志、临时目录和编码。
- `git_publish_safety.md`：提交和推送前的安全检查。

## 子 Agent 层

`templates/subagent/` 用于项目、群组、部门或业务域：

- `SUB_AGENT.md`：子 Agent 必须常驻的最小规则。
- `group_context.md`：长期背景、偏好、流程和分工。
- `workspace/`：本地处理区，真实内容不应提交到框架仓库。

## 脚本层

`templates/scripts/` 只提供骨架：

- 默认不写入真实数据。
- 默认不触达外部系统。
- 需要真实接入时，在私有工作区复制并补充实现。

## 数据层

真实数据应保存在使用者自己的私有目录中，并由 `.gitignore` 默认忽略。框架仓库只提供 example 文件和空模板。
