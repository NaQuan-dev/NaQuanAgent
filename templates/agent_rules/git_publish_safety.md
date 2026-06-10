# Git Publish Safety

## 发布原则

- 仓库只提交框架、模板、脚本骨架和脱敏文档。
- 默认拒绝提交本地真实运行数据。
- 即使仓库是私有，也按未来可能共享处理。

## 禁止提交

- 真实组织资料、员工信息、客户信息、供应商信息。
- 外部平台会话、聊天记录、附件、用户 ID、群组 ID。
- token、密钥、账号密码、app secret、cookie、私有配置。
- 日志、缓存、下载、临时文件和运行状态。
- 真实业务系统接口参数、订单号、项目号、报价、财务和人事资料。

## 提交前检查

```powershell
git status -sb
git diff --cached --name-status
git diff --cached --check
git grep --cached -n -E "token|secret|password|passwd|Authorization|Bearer|cookie|open_id|chat_id|user_id|client_secret|app_secret" -- .
```

还应按当前组织追加组织名、员工姓名、客户名称、内部系统名称和内部项目关键词扫描。

## 历史风险

- 删除当前文件不会删除 Git 历史。
- 旧提交如果含敏感内容，需要单独评估历史重写和强推。
