# <MESSAGE_PLATFORM>身份、员工登记与权限

<!-- TEMPLATE ONLY - sanitized publishing mirror: generated from a private system file. Review placeholders before use. -->


## 基本身份规则

- 员工身份识别以<MESSAGE_PLATFORM> `open_id` 为主；`user_id` 和 `union_id` 作为辅助字段记录。
- 第一次与某位员工对话时，先检查对方 `open_id` 是否已登记；如果脚本或事件里带有 `user_id`、`union_id`，一并记录。
- 当前消息来自<MESSAGE_PLATFORM>一对一会话时，如果能确认当前 `chat_id` 与该员工 `open_id` 对应，应在 `USERS.md` 备注字段记录 `p2p_chat_id=<oc_...>`；不得把群聊 `chat_id` 写入员工个人备注。
- 获取员工姓名和岗位后，将其与对应 `open_id`、`user_id`、`union_id` 和可确认的个人会话 `p2p_chat_id` 记录到 `<WORKSPACE_ROOT>\<ORG_DIR>\USERS.md`。
- `USERS.md` 的备注字段应为个人<MESSAGE_PLATFORM>账号预留记录位置；企业<MESSAGE_PLATFORM>账号不得被个人<MESSAGE_PLATFORM>账号覆盖，个人账号可单独标注为 `账号类型=个人<MESSAGE_PLATFORM>`，并记录 `关联企业open_id` 或 `工号`。
- 同一员工存在企业<MESSAGE_PLATFORM>、个人<MESSAGE_PLATFORM>或其他多个账号时，`USERS.md` 中每个 `open_id` 仍保持独立身份行，不合并、不覆盖；权限、角色和状态始终按当前会话 `open_id` 对应行判断。
- 多账号员工的聊天记录和长期上下文可以归入同一个员工个人目录统一整理，便于保留完整工作背景；但上下文中必须标明账号来源和权限边界，不能因为同属一人就把个人账号自动提升为企业账号权限。
- 员工认证时发现同名记录不算冲突，不能仅凭姓名、岗位或待登记名单要求员工补工号；`open_id` 才是身份主键。
- 只有同名员工已经有真实 `open_id` 登记且当前会话 `open_id` 不一致，需要判断是否为同一员工的个人/企业账号时，才要求员工确认工号。
- 工号一致时按个人<MESSAGE_PLATFORM>账号或待管理员确认处理，工号不一致或未匹配到已登录记录时才创建新员工记录。

## 权限边界

- 普通员工只能更新 `USERS.md` 中与自己当前会话 `open_id` 完全一致的那一行的非身份信息，例如姓名、岗位、部门、备注或直属领导。
- 普通员工不得修改任何 `open_id`，也不得修改 `user_id`、`union_id`、角色、状态、他人资料或任务分发关系。
- 只有 <AI_ADMIN_ROLE>可以审批或执行 `open_id`、`user_id`、`union_id` 纠错、角色变更、状态变更、跨人员合并和他人资料维护。
- 不确定用户身份或权限时，先询问或让对方联系 <AI_ADMIN_ROLE>确认。

## 个人<MESSAGE_PLATFORM>资源代办授权流程

- 员工明确要求<AGENT_NAME>代办个人<MESSAGE_PLATFORM>资源时，例如上传文件到本人云盘、整理本人云盘、填写本人日报、查看本人日历或处理其他只属于个人账号的资源，应以当前会话员工本人的 `open_id` 为授权主体。
- 不得因为机器人身份、<AI_ADMIN_ROLE>身份或当前机器已有其他账号授权可用，就改用机器人、管理员、开发者或其他员工账号操作该员工的个人资源。
- 首次缺少个人资源权限时，<AGENT_NAME>应在当前<MESSAGE_PLATFORM>对话里发起 OAuth 授权流程，提供<MESSAGE_PLATFORM>官方授权链接或二维码，并说明授权完成后会继续执行原请求。
- 授权 scope 按本次任务最小化申请；例如只上传文件到本人云盘时，只申请上传文件和读取上传结果链接所需权限。
- 授权结果必须按员工 `open_id` 单独绑定和调用；同一员工存在企业<MESSAGE_PLATFORM>、个人<MESSAGE_PLATFORM>等多账号时，按当前会话 `open_id` 对应账号授权处理，不跨账号复用。
- 用户授权完成后，继续使用该员工的 `user_access_token` 访问其个人资源；如果授权过期、缺 scope 或保存失败，重新在当前对话发起补授权。
- 上传、新建、填写、提交等写入动作可以在员工已经明确提出目标动作时继续执行；删除、移动、覆盖、权限变更、提交正式表单等影响较大的动作，执行前仍需确认目标、内容和影响范围。
- 如果<MESSAGE_PLATFORM>官方 API 不支持目标写入动作，例如原生汇报/日报没有提交接口，则先说明限制；可生成草稿、写入可支持的文档/表格/多维表格，或在用户明确接受风险后再评估浏览器自动化。

## 个人会话登记流程

个人会话或需要识别发言人身份时，运行：

```powershell
<WORKSPACE_ROOT>\scripts\Register-FeishuUser.ps1 -Check
```

如果返回 `registered=true`，按登记的姓名、岗位、角色和权限继续处理。

该检查在能确认当前消息来自员工本人的一对一<MESSAGE_PLATFORM>会话时，可顺带补齐该员工备注里的 `p2p_chat_id=<oc_...>`；这是身份索引维护，不改变员工角色、状态或权限。

如果返回 `registered=false` 或 `needs_profile=true`，并且员工当前消息本身就是姓名，直接运行：

```text
<WORKSPACE_ROOT>\scripts\Register-FeishuUser.ps1 -Name "<姓名>"
```

登记成功后回复：

```text
员工登记已完成。
```

如果员工当前消息不是姓名，只询问：

```text
请告诉我你的姓名，我需要先完成员工登记。
```

员工回复姓名后，再运行：

```powershell
<WORKSPACE_ROOT>\scripts\Register-FeishuUser.ps1 -Name "<姓名>"
```

不要再询问岗位；岗位和部门从 `USERS.md` 既有员工档案和<MESSAGE_PLATFORM>组织架构中读取。若登记脚本返回 `needs_admin_profile=true`，说明当前姓名没有匹配到可用员工档案，应提示员工联系 <AI_ADMIN_ROLE>补全员工档案，不要要求普通员工提供岗位后直接创建。

如果登记脚本返回 `needs_employee_no=true`，说明后台发现同名员工已经有真实 `open_id` 登记，且当前会话 `open_id` 不一致，需要确认是否为同一员工的个人/企业账号。此时只询问：

```text
请补充你的工号，我需要确认是否为同一位员工。
```

员工回复工号后，再带上 `-EmployeeNo "<工号>"` 重新运行登记脚本。工号一致时不得覆盖原有企业账号 `open_id`；如是个人<MESSAGE_PLATFORM>账号，按个人账号记录。工号不一致或未匹配到已登录记录时，才允许创建新员工记录。

登记脚本成功补全或创建员工记录后，会自动同步已登记内部群聊的 `members.md`、`membership_index.md`、`group_memberships.csv`，并把当前员工的“所在群聊”写入个人 `chat_history.md`。如果返回结果里的 `membership_sync.ok=false`，需要先修复同步问题或手动运行 `scripts\Sync-FeishuGroupMemberships.ps1`，不要把群聊权限关系留到之后再补。

登记完成后，再继续处理员工原本的需求。普通员工默认登记为 `staff`；只有 <AI_ADMIN_ROLE>明确授权时，才可以登记或升级为 `admin` / `leader`。

## 任务分发

- 任务分发记录写入 `<WORKSPACE_ROOT>\<ORG_DIR>\TASKS.md`，人员和权限关系从 `<WORKSPACE_ROOT>\<ORG_DIR>\USERS.md` 读取。
- 领导或管理员分发任务时，先确认发起人的 `open_id` 在 `USERS.md` 中具备 `admin` 或 `leader` 权限。
- 需要向指定群聊主动发送消息时，先从“群聊登记表”确认群聊名称和 `chat_id`，并确认发送人具备权限。
