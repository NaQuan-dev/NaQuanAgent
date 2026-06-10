Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

param(
  [string]$TargetId,
  [string]$Message,
  [bool]$DryRun = $true
)

if (-not $DryRun) {
  throw "This template does not send messages. Implement a private connector adapter before disabling DryRun."
}

[ordered]@{
  target_id = $TargetId
  message_preview = if ($Message.Length -gt 120) { $Message.Substring(0, 120) } else { $Message }
  dry_run = $true
  status = "preview_only"
} | ConvertTo-Json -Depth 5
