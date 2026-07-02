# Git Publish Safety

## Publishing Principle

- Commit only framework docs, templates, script skeletons, and redacted examples.
- Default to rejecting local runtime data.
- Treat even private repositories as if they may be shared later.
- In a private runtime workspace, the local `templates/` directory is the publish source. Publish its contents to the GitHub repository root instead of publishing the live workspace root or a nested `templates/` layer.
- Use `scripts/Publish-TemplateMirror.ps1` or an equivalent temporary-worktree workflow so the staged tree can be reviewed and scanned before push.

## Do Not Commit

- Real organization, employee, customer, or vendor information.
- External platform sessions, chat records, attachments, user IDs, or group IDs.
- Tokens, keys, account passwords, app secrets, cookies, or private config.
- Logs, caches, downloads, temporary files, and runtime state.
- Real business-system API parameters, order numbers, project numbers, quotes, finance, and HR records.

## Pre-Commit Checks

```powershell
git status -sb
git diff --cached --name-status
git diff --cached --check
git grep --cached -n -E "token|secret|password|passwd|Authorization|Bearer|cookie|open_id|chat_id|user_id|client_secret|app_secret" -- .
```

Also scan for environment-specific organization names, employee names, customer names, internal system names, and internal project keywords.

## History Risk

- Deleting a file in the current commit does not remove it from Git history.
- If old commits contain sensitive content, evaluate history rewriting and force-push risk separately.
