param(
  [string]$RegistryPath = "<PRIVATE_DATA_DIR>\minutes_cleanup\generated_minutes.csv",
  [string]$DeleteAdapterPath = "",
  [switch]$ApplyDelete
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

if (-not (Test-Path -LiteralPath $RegistryPath -PathType Leaf)) {
  [ordered]@{
    status = "no_registry"
    dry_run = -not [bool]$ApplyDelete
    message = "No generated minutes registry exists."
  } | ConvertTo-Json -Depth 5
  exit 0
}

$rows = @(Import-Csv -LiteralPath $RegistryPath)
$requiredColumns = @(
  "minutes_id",
  "requester_id",
  "source_media_path",
  "transcript_path",
  "summary_path",
  "metadata_path",
  "cleanup_status"
)

if ($rows.Count -gt 0) {
  $headers = @($rows[0].PSObject.Properties.Name)
  $missing = @($requiredColumns | Where-Object { $headers -notcontains $_ })
  if ($missing.Count -gt 0) {
    throw "Registry is missing required columns: $($missing -join ', ')"
  }
}

$ready = @()
$blocked = @()
foreach ($row in $rows) {
  if ($row.cleanup_status -eq "deleted") {
    continue
  }

  $archiveReady = (
    (Test-Path -LiteralPath $row.source_media_path -PathType Leaf) -and
    (Test-Path -LiteralPath $row.transcript_path -PathType Leaf) -and
    (Test-Path -LiteralPath $row.summary_path -PathType Leaf) -and
    (Test-Path -LiteralPath $row.metadata_path -PathType Leaf)
  )

  if ($archiveReady) {
    $ready += $row.minutes_id
  } else {
    $blocked += $row.minutes_id
  }
}

if ($ApplyDelete) {
  throw "This template is dry-run only. Copy it to a private workspace and implement a connector-specific delete adapter before deleting generated minutes."
}

[ordered]@{
  status = "preview_only"
  ready_for_delete = $ready.Count
  blocked_archive_incomplete = $blocked.Count
  delete_adapter_configured = [bool]$DeleteAdapterPath
  message = "Template only. No external API was called."
} | ConvertTo-Json -Depth 5
