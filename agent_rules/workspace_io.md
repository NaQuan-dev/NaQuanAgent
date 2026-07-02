# 工作区 I/O、编码、日志和临时文件

<!-- TEMPLATE ONLY - sanitized publishing mirror: generated from a private system file. Review placeholders before use. -->


## Windows 与 PowerShell

- 当前系统按 Windows 环境处理。
- 默认 shell 使用 PowerShell；本工作区已内置便携版 PowerShell 7，入口为 `<WORKSPACE_ROOT>\tools\pwsh7.cmd`。
- 运行需要 PowerShell 7 语法、现代参数或稳定 UTF-8 编码的命令时，优先调用 `<WORKSPACE_ROOT>\tools\pwsh7.cmd`，不要默认依赖 Windows PowerShell 5.1。
- 避免在 `C:\Windows`、`C:\Program Files` 等系统目录下做非必要操作。
- Windows 下优先使用 PowerShell 原生命令。
- 搜索文件优先使用 `rg` 或 `rg --files`。

## 中文与编码

- 输出文件名优先使用英文或拼音，减少中文路径和编码导致的问题。
- 给 AI 长期读取、检索、自动化处理的文件名优先使用英文，尤其是 Markdown 文件，例如 `long_term_context.md`、`chat_history.md`、`employee_context_rules.md`；文件正文可以继续使用简体中文。
- 大部分工作内容使用中文，读取和编写文件时必须注意中文编码兼容。
- PowerShell 读写文本优先显式使用 `-Encoding UTF8`，脚本生成文件优先使用 UTF-8，避免把中文内容写成乱码。
- 处理中文文件名、中文路径或中文命令参数时，优先使用 PowerShell 原生命令、`-LiteralPath`、Base64/UTF-8 参数传递或脚本内部构造字符串，避免 Windows 命令行转义和编码导致中文变形。
- 当前系统自带 PowerShell 仍是 Windows PowerShell 5.1；只有必须使用系统内置模块或兼容旧脚本时才回退到 5.1。
- 包含中文字符串的 `.ps1` 脚本若必须由 5.1 执行，优先保存为 UTF-8 BOM，避免 5.1 按系统 ANSI 代码页解析导致乱码或语法错误。
- Codex 后续创建或修改面向中文业务的 CSV、Markdown、JSON、日志和脚本时，应主动验证中文读写效果；不要只验证命令退出码。
- 需要向 PowerShell 传递中文 JSON、长文本或复杂参数时，优先使用 UTF-8 Base64、临时 UTF-8 文件或脚本内部对象构造，避免直接在命令行拼接中文字符串。

## 日志和临时文件

- 工作区日志类文件统一存放在 `<WORKSPACE_ROOT>\log`，包括 `.log`、`.err.log`、运行日志、排查日志和脚本输出日志；除外部工具强制生成外，不在工作区根目录散放日志。
- 工作区临时生成、可重建、阶段性转换的文件统一存放在 `<WORKSPACE_ROOT>\temp`，必要时按任务名建立子目录；任务完成后的正式成果应迁出到对应业务目录。
- 清理 `<WORKSPACE_ROOT>\temp` 前必须先提醒用户，说明计划清理范围、数量、大小和保留项；未得到明确确认前只做预览，不删除文件。
- `temp` 默认按每周检查和清理预览处理；用户另有指定时按用户指定周期执行。

## 生成文件与交付格式

- 本地生成文件是制作或归档步骤，不等于对<MESSAGE_PLATFORM>普通员工完成交付；最终应把文件、在线文档链接或正文内容发到当前<MESSAGE_PLATFORM>会话。
- <MESSAGE_PLATFORM>请求生成文件时，正式生成物默认保存到当前请求来源对应的 `outputs` 目录：个人会话写入该员工个人目录下的 `outputs`，群聊会话写入该群聊工作区下的 `outputs`。不得把正式 `.docx`、`.xlsx`、`.pptx`、`.pdf`、图片或压缩包散放在工作区根目录。
- 如果临时生成物已经落到工作区根目录，发送前必须先迁移到当前请求来源对应的 `outputs` 目录，再把该目录中的文件作为附件发送；根目录只能作为兼容兜底，不作为完成状态。
- 面向<MESSAGE_PLATFORM>员工交付本地文件时，当前 <CONNECTOR_NAME> 会话内优先调用 `<CONNECTOR_NAME> send --file <path> -s $env:CC_HOOK_SESSION_KEY` 把附件直接发到当前会话；需要显式指定员工或群聊时再用 `scripts\Send-FeishuFile.cmd`。确认返回成功前，不要把任务视为已完成。
- 面向<MESSAGE_PLATFORM>员工交付本地图片时，当前 <CONNECTOR_NAME> 会话内优先调用 `<CONNECTOR_NAME> send --image <path> -s $env:CC_HOOK_SESSION_KEY` 把图片直接发到当前会话；需要显式指定员工或群聊时再用 `scripts\Send-FeishuImage.cmd`。确认返回成功前，不要回复“图片已生成”“已发图”。
- Codex 内置 `image_gen` 的生成图默认在 `$HOME\.codex\generated_images\...`，不是<MESSAGE_PLATFORM>附件；面向<MESSAGE_PLATFORM>员工时，优先用 `<CONNECTOR_NAME> send --image <path> -s $env:CC_HOOK_SESSION_KEY` 回传；如果需要定位当前生成目录，先用 `<CONNECTOR_NAME> agent-sid`，再用 `scripts\Send-CodexGeneratedImage.cmd` 从该会话目录复制并发送图片。
- 生成物交付的当前会话指原始提出需求的员工个人会话或群聊，不是 <AI_ADMIN_ROLE>调试窗口。脚本默认目标解析到 admin 角色时会阻断；只有管理员明确要求自收时才使用 `-AllowAdminTarget`。
- <MESSAGE_PLATFORM>云空间里的“我的空间/私密云空间”属于当前授权用户；`lark-cli --as user` 不是代表当前请求员工。员工要求保存到本人私密云空间时，必须确认当前授权用户 open_id 与请求员工一致；不一致时不能把文件夹建到当前授权用户根目录，必须让员工分享目标文件夹或改为发送到当前<MESSAGE_PLATFORM>会话。
- 本机 `tools\lark-cli.cmd` 已加 Drive 写入守卫；从 <CONNECTOR_NAME> 会话里不要绕过它直接调用真实 `lark-cli.cmd`。守卫拦截时，说明当前写入目标可能会落到 AI 管理侧云空间，应停止并改用用户分享的文件夹或会话附件交付。
- `lark-cli im +messages-send --file` 的文件路径必须是当前工作目录下的相对路径；需要发送绝对路径文件时，使用 `scripts\Send-FeishuFile.cmd` 让脚本切换到文件所在目录后发送。
- `lark-cli im +messages-send --image` 的图片路径也必须是当前工作目录下的相对路径；需要发送绝对路径图片时，使用 `scripts\Send-FeishuImage.cmd` 让脚本切换到图片所在目录后发送。
- 面向普通员工不要回复本机绝对路径、用户目录、工作区路径、临时目录或日志目录；管理员调试场景需要路径时，也应只给必要路径。
- 对普通员工发送前，如果正文中出现 `<LOCAL_DRIVE>\`、`<LOCAL_USER_HOME>\`、`.<CONNECTOR_NAME>`、`log\`、`temp\`、`<ORG_DIR>\`、`templates\` 等本地或内部路径，应先改写为用户可理解的文件名、附件说明或在线链接；主动发送文本可用 `scripts\Guard-FeishuOutboundText.cmd` 预检。
- 短文案、简短总结、话术、少量清单优先直接用<MESSAGE_PLATFORM>消息正文发送。
- 正式报告、客户可转发材料、会议纪要、制度流程、需要排版或后续编辑的文档，优先使用在线文档或 `.docx`。
- 简单纯文本、日志、无需排版的草稿、可复制的清单或给程序继续处理的文本，优先使用 `.txt`。
- 表格、台账、明细数据优先使用在线表格、`.xlsx` 或 `.csv`，不要塞进 `.txt` 里交付。
- 不默认用 Markdown 文件交付给普通员工；除非用户明确要求 Markdown，或这是 <AI_ADMIN_ROLE>/框架维护任务。

## 文件编辑安全

- 修改文件前先读取现有内容。
- 不覆盖用户已有改动，除非用户明确要求。
- 不删除、清空或批量移动重要目录。
- 如果创建新文件，优先放在用户指定目录；未指定时放在当前任务相关目录。
- 用户要求“先给我看”“先输出一版”“不要直接改”时，只输出草案，不写入文件。
- 能跑测试就跑最相关的测试；没有测试时做实际 smoke check。
- 如果无法验证，明确说明没验证什么、原因是什么、剩余风险是什么。
