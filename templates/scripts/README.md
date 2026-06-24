# Script Templates

Scripts in this directory are reusable skeletons only.

Rules:

- Do not read real private data.
- Do not touch real external systems.
- Default to dry-run or preview behavior.
- Copy a skeleton into a private workspace before implementing real adapters and credential loading.

## Current Skeletons

- `Register-User.ps1`: single-user registration example; outputs JSON only.
- `Import-NasUsers.ps1`: validates a CSV and creates a NAS user import plan; dry-run only.
- `Archive-VoiceNote.ps1`: preview entrypoint for archiving audio/video processing outputs; real employee lookup must be implemented privately.
- `Cleanup-GeneratedMinutes.ps1`: preview cleanup for generated transcript/minutes artifacts; does not call external delete APIs.
- `Test-AgentGovernance.ps1`: read-only governance check template for rule registry, common-error preflight, hook guardrails, context budget, daily review policy, and review candidate files.

Example NAS import data lives in `templates/data/NAS_USERS_IMPORT.example.csv`. Real employee lists, NAS addresses, group mappings, tokens, and execution logs must stay in a private workspace.

Example:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\templates\scripts\Import-NasUsers.ps1 `
  -InputPath .\templates\data\NAS_USERS_IMPORT.example.csv `
  -OutputPath .\private\nas-import\plan.preview.json
```

`Import-NasUsers.ps1` validates required fields, duplicate employee references, duplicate NAS usernames, username format, status values, groups, quota, and home-directory flags. The template rejects `-Apply`; real changes are allowed only after copying the script into a private workspace and implementing a real NAS adapter.
