# Git 发布与 GitHub 安全

<!-- TEMPLATE ONLY - sanitized publishing mirror: generated from a private system file. Review placeholders before use. -->


## 发布前检查

- 如果当前目录是 Git 仓库，较大改动前先查看 `git status`。
- 提交前确认 `.gitignore` 仍是默认拒绝、白名单放行模式。
- 不把公司资料目录、运行状态、日志、临时文件、下载文件、`.<CONNECTOR_NAME>`、`<ORG_DIR>/`、`agents/`、`tools/PowerShell/` 提交到 GitHub。
- 当前仓库即使是私有，也按“可能以后会共享 agent 架构”处理，不把公司业务资料、真实人员标识、聊天记录、客户资料、密钥或 token 放进可提交文件。
- 推送前用 `git status --short --ignored` 确认被忽略目录仍被忽略。
- GitHub 仓库根目录是公开模板镜像；发布源是本机 `templates\`，发布动作必须把 `templates\` 内容映射到远端根目录。
- 不直接推送 live 根目录，也不把远端保持成 `templates\` 子目录嵌套发布。使用 `templates\scripts\Publish-TemplateMirror.ps1` 或等效临时 worktree 流程。

## 敏感扫描建议

提交前至少检查：

```powershell
git diff --cached --name-status
git diff --cached --check
git grep --cached -n -E "oc_[0-9a-f]{20,}|ou_[0-9a-f]{20,}|Bearer [A-Za-z0-9._-]+|HMqy[a-zA-Z0-9]+|cli_[a-zA-Z0-9]+"
```

如需检查当前 `HEAD`：

```powershell
git grep -n -E "oc_[0-9a-f]{20,}|ou_[0-9a-f]{20,}|Bearer [A-Za-z0-9._-]+|HMqy[a-zA-Z0-9]+|cli_[a-zA-Z0-9]+" HEAD -- .
```

## 历史风险

- 删除当前文件不等于删除 Git 历史。
- 如果旧提交里已经含有真实 `open_id`、`chat_id`、token、客户资料或公司敏感流程，GitHub 历史仍可能查到。
- 彻底清理历史需要重写 Git 历史并强推；执行前必须由 <AI_ADMIN_ROLE>确认影响。

## 操作边界

- 不运行 `git reset --hard`、强制 checkout、大范围删除，除非用户明确要求。
- 不回滚用户或其他工具产生的无关改动。
- 如果创建提交或推送成功，最终说明提交哈希和推送分支。
