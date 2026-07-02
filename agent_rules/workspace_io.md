# Workspace I/O

## Directory Use

- Temporary files go under `<TEMP_DIR>`.
- Logs go under `<LOG_DIR>`.
- Deliverables go to the user-approved destination or the relevant business output directory.
- When a request comes through a messaging connector, generated files should be sent back to the current conversation by default. A local path is not final delivery.
- Do not expose local paths, workspace paths, or internal directory structure to ordinary users.
- Text deliverables should usually be online documents, `.docx`, `.txt`, or message text, not Markdown by default.

## Encoding

- Use UTF-8 for text files.
- For JSON/TOML/YAML config, verify parser compatibility and avoid BOM when the parser is strict.
- For Windows PowerShell 5.1 scripts that contain non-ASCII text, test PowerShell 5.1 explicitly or keep source ASCII and restore non-ASCII strings at runtime.

## File Edits

- Read before editing.
- Prefer structured parsers for JSON, CSV, TOML, YAML, and similar formats.
- Keep backups before changing runtime indexes or connector state.
- Do not bulk-delete or bulk-move private runtime directories unless explicitly confirmed.

## User-Facing Paths

- Do not show internal local paths to ordinary users.
- If a generated file must be delivered, send it through the connector, upload it to an approved destination, or provide an approved share link.
- If delivery fails, say it failed and provide a fallback such as message text, split messages, `.txt`, `.docx`, or an online document.
