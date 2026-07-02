# Voice Note Minutes Retention

This rule covers audio/video files that are uploaded by an agent to generate meeting-minutes/transcript artifacts through an external connector.

## Principle

Generated minutes are temporary processing artifacts. The durable archive is the requester's private employee workspace.

Audio, video, transcripts, and generated minutes never imply business-system or CRM matching. Treat them as transcription, summary, or archive inputs unless the same conversation also contains a separate explicit text command and that conversation is an approved business-system entry point.

Before any generated minutes object is deleted, the agent must verify that all durable outputs are saved locally:

- Source audio/video file.
- Full transcript.
- Final summary or structured notes.
- Metadata linking the generated minutes object to the local archive.

## Requester Ownership

Archive under the employee who requested the recording to be processed.

Do not infer ownership from:

- Names mentioned in the recording.
- The latest unrelated speaker in a group chat.
- Nicknames or display names without identity verification.
- Customer names, phone numbers, quotes, requirements, or other business clues mentioned in the recording.

Prefer stable connector identity fields such as `<USER_ID>` or `<OPEN_ID>` and a trusted employee index.

## Archive Location

Use the requester's employee directory under `<EMPLOYEE_ROOT>`:

```text
<EMPLOYEE_ROOT>/<DEPARTMENT_PATH>/<EMPLOYEE_NAME>/archive/voice_notes/YYYY/YYYYMMDD_HHMMSS_<minutes_id_short>/
  source/<original_media_filename>
  transcript.md
  summary.md
  metadata.json
```

If the requester cannot be mapped to exactly one employee directory, do not delete the generated minutes object. Record the issue for admin review.

## Cleanup Registry

Track generated minutes in a private runtime registry such as:

```text
<PRIVATE_DATA_DIR>/minutes_cleanup/generated_minutes.csv
```

Suggested columns:

```text
minutes_id,minutes_url,requester_id,requester_name,source_message_ref,created_at,archived_at,archive_dir,source_media_path,transcript_path,summary_path,metadata_path,cleanup_status,deleted_at,notes
```

This registry is runtime data and must not be committed to a reusable framework repository.

## Daily Cleanup Guardrails

A scheduled cleanup may delete only generated minutes records that are:

- Present in the cleanup registry.
- Produced by the agent's own recording-processing workflow.
- Fully archived under the requester's employee directory.

The cleanup must not delete:

- Source media files.
- Local transcripts, summaries, metadata, or employee archives.
- Original chat attachments.
- Cloud-drive source files unless a separate admin-approved retention policy says so.

If the connector does not expose a reliable "delete generated minutes object" operation, produce a blocked cleanup report. Do not substitute unrelated operations such as deleting cloud-drive files, clearing summaries, or deleting embedded to-dos.

## User-Facing Response

When replying through an employee-facing connector, do not expose local absolute paths, private IDs, registry paths, or internal cleanup script names. Say only that the source file, transcript, and summary were saved to the employee workspace.
