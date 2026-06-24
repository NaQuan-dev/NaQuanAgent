# Publish Safety

Use this checklist before pushing a workspace to GitHub. The repository must contain only reusable framework assets.

## Safe To Commit

- Framework documentation.
- Rule templates.
- Sub-agent templates.
- Redacted configuration examples.
- Script skeletons that do not touch real external systems.

## Do Not Commit

- Real organization, employee, customer, vendor, or business data.
- External platform sessions, chat records, attachments, user IDs, or group IDs.
- Tokens, keys, account passwords, cookies, or private config.
- Logs, caches, downloads, temporary files, or runtime state.
- Real internal system API parameters, order numbers, project numbers, quotes, or finance data.

## Suggested Checks

```powershell
git status -sb
git diff --cached --name-status
git diff --cached --check
git grep --cached -n -E "token|secret|password|passwd|Authorization|Bearer|cookie|open_id|chat_id|user_id|client_secret|app_secret" -- .
```

Also scan for any real organization names, people names, customer names, internal system names, and internal project keywords that apply to your environment.

## History Risk

Deleting a file from the latest commit does not remove it from Git history. If an old commit contains sensitive data, evaluate history rewriting and force-push risk separately.
