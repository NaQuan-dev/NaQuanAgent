# 录音、妙记归档与清理

<!-- TEMPLATE ONLY - sanitized publishing mirror: generated from a private system file. Review placeholders before use. -->


## 适用范围

本规则适用于员工通过<MESSAGE_PLATFORM>向<AGENT_NAME>发送、引用或要求整理录音、语音、音频、视频文件，并由<AGENT_NAME>上传生成<MESSAGE_PLATFORM>妙记后再读取逐字稿、总结和待办的场景。

<MESSAGE_PLATFORM>妙记只作为临时转写和读取工具，不作为长期保存位置。长期保存以员工个人文件夹下的本地归档为准。

## CRM 触发边界

- 录音、语音、音视频和<MESSAGE_PLATFORM>妙记默认只触发转写、总结、待办、风险和业务信息整理，永远不因音频类型本身触发 CRM 客户匹配、查询、录入或修改。
- 任何群聊收到录音时，即使录音内容提到客户、需求、报价或销售线索，也只按录音整理任务处理，不查 CRM、不匹配 CRM 客户、不写 CRM。
- 只有当前会话位置属于 `business_system_security.md` 允许的 CRM 入口，并且当前文字消息明确要求 CRM 匹配、查询、录入、修改或分析，且 CRM 后端确认当前<MESSAGE_PLATFORM> `open_id` 有有效账号映射和相应权限时，才可能转入 CRM 流程；<SALES_GROUP>也必须满足这个明确文字指令条件。
- “整理录音”“生成纪要”“提取客户沟通要点”不等于“匹配 CRM”；需要进入 CRM 时必须有明确 CRM 动作词。
- 任务未完成前不得向<MESSAGE_PLATFORM>发送“正在处理”“正在转写并匹配 CRM”等占位回复。

## 处理录音时必须保存

每次<AGENT_NAME>为员工生成妙记后，在回复整理结果前或最迟在本轮任务结束前，必须把以下内容保存到请求员工的个人文件夹下：

- 录音或音视频源文件本体。
- <MESSAGE_PLATFORM>妙记读取到的完整逐字稿。
- <AGENT_NAME>整理后的总结、待办、风险和业务信息。
- 归档元数据，用于记录来源消息、`minute_token`、请求人、生成时间、归档文件相对路径和清理状态。

请求员工是“发起整理请求的人”，不是被录音里提到的人，也不是群聊里最近发言的其他人。群聊场景中应使用当前消息的 sender `open_id` 或引用消息的请求链路确认请求人。

## 员工个人文件夹定位

1. 先按<MESSAGE_PLATFORM>身份规则运行员工识别，确认当前请求人的 `open_id`。
2. 优先用 `<ORG_DIR>\员工\架构\employee_org_index.md` 中的 `open_id` 定位员工姓名和主部门。
3. 员工个人目录应位于 `<ORG_DIR>\员工\架构\<主部门路径>\<员工姓名>`。
4. 如果 `open_id` 未登记、同名冲突、主部门不明或个人目录无法可靠定位，不得删除对应妙记；先把问题列入待处理清单，并要求补全员工登记或由 <AI_ADMIN_ROLE>核验。

不要仅凭姓名、岗位、群昵称或录音内容猜测员工目录。

## 推荐归档结构

在员工个人目录下使用以下结构：

```text
archive/
  voice_notes/
    YYYY/
      YYYYMMDD_HHMMSS_<minute_token_short>/
        source/
          <original_media_filename>
        transcript.md
        summary.md
        metadata.json
```

文件正文可使用中文；文件名优先使用英文、日期和 token 短码，避免中文路径和编码导致自动化失败。

`metadata.json` 至少记录：

- `minute_token`
- `minute_url`（如有）
- `requester_open_id`
- `requester_name`
- `source_message_ref`
- `source_media_path`
- `transcript_path`
- `summary_path`
- `created_at`
- `archived_at`
- `cleanup_status`

## 清理登记表

<AGENT_NAME>生成并需要后续清理的妙记，应登记到：

```text
<ORG_DIR>\minutes_cleanup\generated_minutes.csv
```

建议字段：

```text
minute_token,minute_url,requester_open_id,requester_name,source_message_ref,created_at,archived_at,archive_dir,source_media_path,transcript_path,summary_path,metadata_path,cleanup_status,deleted_at,notes
```

该登记表属于本地运行数据，不提交到公开仓库。没有进入登记表的妙记，不得被每日清理任务批量删除。

## 本地辅助脚本

录音整理完成后，可用以下脚本把源文件、逐字稿、整理稿和元数据归档到请求员工个人目录，并写入清理登记表：

```powershell
<WORKSPACE_ROOT>\scripts\Archive-XiaoQuanVoiceNote.ps1
```

每日清理任务使用以下脚本做归档完整性检查和清理状态登记：

```powershell
<WORKSPACE_ROOT>\scripts\Cleanup-XiaoQuanGeneratedMinutes.ps1
```

真正删除<MESSAGE_PLATFORM>妙记对象必须通过单独的私有删除适配器，例如 `scripts\Delete-FeishuMinute.ps1`。没有这个适配器时，清理脚本只能生成阻塞清单，不得用删除云盘文件、删除妙记待办、清空总结等方式替代。

## 每日清理规则

每日清理任务只处理“<AGENT_NAME>自己生成且已登记”的妙记，不扫描或删除员工个人创建的其他妙记。

删除某条<MESSAGE_PLATFORM>妙记前必须同时满足：

- 该条记录在 `generated_minutes.csv` 中。
- 请求员工个人目录已经可靠定位。
- 源录音或音视频文件已经保存到员工个人目录。
- 完整逐字稿已经保存到员工个人目录。
- <AGENT_NAME>整理后的总结已经保存到员工个人目录。
- `metadata.json` 已保存，并能对应同一个 `minute_token`。
- 以上本地文件存在且非空。

只允许删除<MESSAGE_PLATFORM>妙记对象本身，以释放妙记用量；不得删除：

- 员工个人目录下的 `archive/voice_notes`。
- 已保存的源录音或音视频文件。
- 已保存的逐字稿、总结、元数据。
- <MESSAGE_PLATFORM>聊天中的原始附件。
- <MESSAGE_PLATFORM>云盘中作为源文件保存的录音文件，除非 <AI_ADMIN_ROLE>另行明确要求。

如果当前连接器或 API 没有可靠的“删除整条妙记”能力，只生成待删除清单和阻塞原因，不得用删除 Drive 文件、删除待办、清空总结等方式替代删除妙记。

## 回复员工时的说明

面向<MESSAGE_PLATFORM>普通员工，只说明“源文件、逐字稿和整理结果已保存到你的个人工作区”，不要暴露本机绝对路径、`open_id`、`minute_token`、清理脚本路径或登记表路径。

如果归档失败或无法定位员工个人目录，应直接说明“这条录音暂未进入自动清理，我需要先完成员工登记或归档核验”，不要承诺已经删除妙记。
