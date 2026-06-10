# Publish Safety

本清单用于把工作区提交到 GitHub 前确认仓库只包含可复用框架。

## 应该提交

- 框架说明。
- 规则模板。
- 子 Agent 模板。
- 脱敏配置示例。
- 不触达真实外部系统的脚本骨架。

## 不应该提交

- 真实组织资料、员工信息、客户信息、供应商信息和业务数据。
- 外部平台会话、聊天记录、附件、用户 ID、群组 ID。
- token、密钥、账号密码、cookie、私有配置。
- 日志、缓存、下载、临时文件、运行状态。
- 真实内部系统接口参数、订单号、项目号、报价和财务信息。

## 建议检查命令

```powershell
git status -sb
git diff --cached --name-status
git diff --cached --check
git grep --cached -n -E "token|secret|password|passwd|Authorization|Bearer|cookie|open_id|chat_id|user_id|client_secret|app_secret" -- .
```

按项目实际情况追加组织名、人员名、客户名、内部系统名和内部项目关键词扫描。

## 历史风险

删除当前文件只会清理最新提交树，不会清除旧提交历史。如果旧提交已经包含敏感内容，需要评估是否用历史重写工具清理并强推。
