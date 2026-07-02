# 对外触达、<MESSAGE_PLATFORM>消息和定时任务

<!-- TEMPLATE ONLY - sanitized publishing mirror: generated from a private system file. Review placeholders before use. -->


## 通用规则

- 涉及<MESSAGE_PLATFORM>、Claw、外部消息通道时，发送前确认是否会对外触达。
- 主动发送<MESSAGE_PLATFORM>消息、创建<MESSAGE_PLATFORM>任务、创建日程、发邮件、设置定时任务前，确认对象、内容、时间和是否立即触达。
- 用户明确只要草稿时，不发送、不创建线上任务。
- 通过外部通道生成文件或内容时，除保存文件外，还应把核心内容回传到对话中。
- 用户要求生成或导出文件时，本地保存只算中间产物或归档，不算对普通员工完成交付；必须把文件上传/发送到当前<MESSAGE_PLATFORM>会话，或创建/更新在线文档后把可打开链接发回当前会话。
- 已生成本地文件且需要发给当前<MESSAGE_PLATFORM>会话时，优先使用 `<CONNECTOR_NAME> send --file <path> -s $env:CC_HOOK_SESSION_KEY` 回传附件；需要显式指定员工或群聊时，再使用 `scripts\Send-FeishuFile.cmd -FilePath <file> -ToChatId <oc_...>`、`-ToOpenId <ou_...>`、`-ToName <姓名>` 或等价的<MESSAGE_PLATFORM>文件发送能力。工具返回成功后，才能回复“已发送附件”。
- <MESSAGE_PLATFORM>端请求生成的文件、表格、图片、文档或压缩包，应先按请求来源归入对应本地文件夹：个人私聊归入该员工文件夹的 `outputs`，已注册群聊归入该群聊子智能体文件夹的 `outputs`，再发送到原始<MESSAGE_PLATFORM>会话。
- 自动交付链路不得直接从临时目录、根工作区、图片生成目录或 `.<CONNECTOR_NAME>` 缓存目录完成最终交付；必须先把生成物复制到请求来源对应的 `outputs`，再发送。
- 如果<MESSAGE_PLATFORM>任务的最终文件、表格或压缩包生成在 `.<CONNECTOR_NAME>\attachments`，应先按当前路由复制到该员工或群聊的 `outputs` 目录，再发送附件；不能把 `.<CONNECTOR_NAME>\attachments` 目录排除导致生成物只保存在本地。
- 已生成本地图片且需要发给当前<MESSAGE_PLATFORM>会话时，优先使用 `<CONNECTOR_NAME> send --image <path> -s $env:CC_HOOK_SESSION_KEY` 回传图片；需要显式指定员工或群聊时，再使用 `scripts\Send-FeishuImage.cmd -ImagePath <image> -ToChatId <oc_...>`、`-ToOpenId <ou_...>`、`-ToName <姓名>` 或等价的<MESSAGE_PLATFORM>图片发送能力。工具返回成功后，才能回复“已生成图片”或“已发图”。
- 使用 Codex `image_gen` 生成的图片不会被普通文字回复自动带回<MESSAGE_PLATFORM>；生成后必须用 `<CONNECTOR_NAME> send --image <path> -s $env:CC_HOOK_SESSION_KEY`、`<CONNECTOR_NAME> agent-sid` 配合 `scripts\Send-CodexGeneratedImage.cmd -AgentSessionId <id>`、`-GeneratedImagesDir <dir>` 或 `-ImagePath <png>` 把图片实际发送出去，再回复结果。
- 对普通员工的生成物交付默认发回原请求所在<MESSAGE_PLATFORM>会话；不要另开新会话、不要发到 <AI_ADMIN_ROLE>窗口、不要发到最后调试或转办的人、不要只把生成位置告诉员工。
- 如果当前处理发生在 <AI_ADMIN_ROLE>会话里，但生成物来自其他员工或群聊的请求，必须显式指定原请求人的 `-ToChatId`、`-ToOpenId` 或 `-ToName`；不能依赖当前会话默认目标。
- `scripts\Send-FeishuFile.cmd` 和 `scripts\Send-FeishuImage.cmd` 默认会拦截 admin 角色目标；只有 <AI_ADMIN_ROLE>明确为自己生成并确认自收时，才允许使用 `-AllowAdminTarget`。
- `lark-cli --as user` 表示当前机器已登录授权的<MESSAGE_PLATFORM>用户，不等于当前发消息的员工。员工要求保存到“我的空间”“私密云空间”“私人文件夹”时，先核对当前授权用户是否就是该员工；不一致时不能创建根目录文件夹、上传、导入或移动到当前授权用户的云空间。
- 员工私密云空间的正确处理方式：让员工先在自己云空间创建目标文件夹并把文件夹分享给<AGENT_NAME>可编辑，或把生成物作为附件/在线文档链接发回当前<MESSAGE_PLATFORM>会话。不得把 AI 管理账号、纳<AGENT_NAME>账号或机器人账号的云空间说成“你的私密云空间”。
- 从<MESSAGE_PLATFORM>会话触发的 Drive 根目录写入必须走本地 `tools\lark-cli.cmd` 守卫；如果守卫返回 `lark-drive-guard: blocked`，按提示改为让员工分享目标文件夹或发送到当前会话，不要绕过守卫。
- 如果文件发送失败，不得用本机路径替代交付；应明确说明未成功发送，并改用正文、拆分消息、`.docx`、`.txt`、在线文档或其他用户可直接打开的方式继续交付。
- 面向普通员工或群聊发送前，回复正文不得包含本机路径、工作区路径、日志路径、临时目录、`.<CONNECTOR_NAME>` 路径或内部目录结构；需要提到文件时，只说“附件”“文档”“表格”“资料文件”等用户能理解的名称。
- 面向普通员工或群聊，不能只发“已生成图片”“图片已生成”“已发图”等文本作为图片交付；必须先确认图片消息或附件发送成功。若发送失败，说明未成功发出，并重新尝试发图片、发附件或提供在线可打开链接。
- 主动发送文本前，优先用 `scripts\Guard-FeishuOutboundText.cmd` 或 `scripts\Send-FeishuMessage.cmd` 内置检查做预检；检测到路径泄露风险时，必须改为发送附件、在线链接或正文内容，不能加 `-AllowLocalPaths` 绕过普通员工交付。
- 跨群同步文本，尤其是销售会议纪要或销售录音整理出的“新媒体同步版/短视频选题同步（脱敏版）”，必须走 `scripts\Send-FeishuMessage.cmd`、`<CONNECTOR_NAME> send --stdin` 或等价的 UTF-8 Base64/stdin 受保护路径；不得用裸 `lark-cli ... --text` 或普通命令行多行参数发送。发送前正文必须已经生成，发送后必须读回确认正文不是只有标题；读回前不得向源群声明“已同步”。
- 主动发送需要员工复制或查看的链接时，统一使用单行普通文本格式：`说明文字：<原始URL>`。不要把 URL 单独放在下一行，不要只发送裸 URL，不要用 Markdown 超链接、卡片链接或代码块代替原始 URL；尤其不要通过 `tools\lark-cli.cmd im +messages-send --text` 传入包含换行的链接正文，Windows `.cmd` 链路可能只发送第一行。批量发送链接后，必须抽查 `messages-mget` 读回的服务端正文，确认 URL 完整存在；如果<MESSAGE_PLATFORM>客户端仍隐藏或折叠链接，改发包含原始 URL 的 `.txt` / `.docx` 附件兜底。
- 通过<MESSAGE_PLATFORM>回复普通员工时，遵守路径隐藏规则；可以说明“已保存”“已更新员工登记表”或“已记录到任务表”。
- 面向<MESSAGE_PLATFORM>员工回复时，不暴露本机绝对路径、用户目录、工作区路径、配置文件路径或日志文件路径，例如 `<LOCAL_DRIVE>\...`、`<LOCAL_USER_HOME>\...`、`.<CONNECTOR_NAME>` 的具体位置。必要时只说“员工登记表”“公司资料文件”“配置文件”等用途名称。

## 代发与回复消息定位规则

- 用户要求“回复刚才发消息的人”“帮我回复他”“回复这条消息”时，默认目标是原消息的实际发送人，而不是当前最新活跃会话、<AI_ADMIN_ROLE>会话、调试会话或最后一个收到消息的会话。
- 处理带引用链、转述链或 Bot 代发记录的消息时，先追溯原始业务发送人；如果 Bot 只是代发中转，回复目标应是发起原消息的人。
- 向目标发送前，应明确使用目标员工的 `p2p_chat_id`、`open_id`、姓名解析结果或原消息 `message_id/thread_id` 定向发送；不得依赖 `<CONNECTOR_NAME> send` 的自动活跃会话选择。
- 如果无法可靠确认原消息发送人、员工身份、岗位或可触达会话，先停止并询问用户确认，不得猜测发送。
- 收到、转述或准备回复他人消息时，面向请求人先标注来源身份，格式优先使用：`发送人：<姓名>｜<岗位>`。岗位从 `USERS.md`、<MESSAGE_PLATFORM>通讯录或已登记员工档案读取；无法确认时写 `发送人：<姓名>｜岗位待核验`。
- 代发或回复完成后，向请求人反馈时说明已回复给谁，使用姓名和岗位即可；不要展示 `chat_id`、`open_id`、本地会话 key 或内部路由细节。

## <CONNECTOR_NAME> 配置

- 暂时不要主动修改 `.<CONNECTOR_NAME>` 配置，除非 <AI_ADMIN_ROLE>明确要求。
- 不要主动设置 `admin_from`，尤其不要设置 `admin_from = "*"`，除非 <AI_ADMIN_ROLE>明确批准风险。

## 定时任务

当用户要求按计划执行任务时，例如“每天早上 6 点”或“每周一上午”，使用：

```powershell
<CONNECTOR_NAME> cron add --cron "<cron expression>" --prompt "<prompt>" --desc "<description>"
```

环境变量 `CC_PROJECT` 和 `CC_SESSION_KEY` 已经设置。不要额外指定 `--project` 或 `--session-key`。

示例：

```powershell
<CONNECTOR_NAME> cron add --cron "0 6 * * *" --prompt "收集 GitHub Trending 仓库并发送摘要" --desc "Daily GitHub Trending"
<CONNECTOR_NAME> cron add --cron "0 9 * * 1" --prompt "生成每周项目状态报告" --desc "Weekly Report"
```

列出、立即运行、编辑或删除定时任务：

```powershell
<CONNECTOR_NAME> cron list
<CONNECTOR_NAME> cron exec <id>
<CONNECTOR_NAME> cron edit <id>
<CONNECTOR_NAME> cron del <id>
```

使用 `cron exec <id>` 可以立即运行现有定时任务。它不同于创建 shell-command cron job 时使用的 `--exec <command>` 参数。

使用 `cron edit` 修改单个字段，不要为了改一个字段就删除重建。常见可编辑字段包括：`cron_expr`、`prompt`、`exec`、`description`、`enabled`、`mute`、`timeout_mins`。

## 主动发送消息到当前会话

长文本或多行文本使用：

```powershell
<CONNECTOR_NAME> send --stdin
```

然后在标准输入中提供要发送的内容。

短文本使用：

```powershell
<CONNECTOR_NAME> send -m "short message"
```

## 发送文件到<MESSAGE_PLATFORM>会话

本地文件生成后需要作为附件交付时，使用：

```powershell
scripts\Send-FeishuFile.cmd -FilePath "<local file>" -ToChatId "<oc_chat_id>"
scripts\Send-FeishuFile.cmd -FilePath "<local file>" -ToName "<员工姓名>"
```

先用 `-DryRun` 可检查目标会话和文件名；正式发送必须确认返回 `ok=true` 和 `sent=true` 后，才向员工说明附件已发出。
