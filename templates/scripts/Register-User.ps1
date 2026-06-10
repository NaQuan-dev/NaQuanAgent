Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

param(
  [string]$UserId,
  [string]$DisplayName,
  [string]$Role = "staff",
  [switch]$DryRun
)

if (-not $UserId) {
  throw "UserId is required. Use a placeholder in templates and real IDs only in private workspaces."
}

$record = [ordered]@{
  user_id = $UserId
  display_name = $DisplayName
  role = $Role
  dry_run = [bool]$DryRun
  message = "Template only. No file was written."
}

$record | ConvertTo-Json -Depth 5
