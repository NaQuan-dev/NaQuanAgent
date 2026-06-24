param(
  [Parameter(Mandatory = $true)]
  [string]$MinutesId,

  [string]$MinutesUrl = "",

  [Parameter(Mandatory = $true)]
  [string]$RequesterId,

  [string]$RequesterName = "",

  [string]$SourceMessageRef = "",

  [Parameter(Mandatory = $true)]
  [string]$SourceMediaPath,

  [Parameter(Mandatory = $true)]
  [string]$TranscriptPath,

  [Parameter(Mandatory = $true)]
  [string]$SummaryPath,

  [string]$EmployeeRoot = "<EMPLOYEE_ROOT>",

  [string]$EmployeeIndexPath = "<EMPLOYEE_INDEX_PATH>",

  [string]$RegistryPath = "<PRIVATE_DATA_DIR>\minutes_cleanup\generated_minutes.csv",

  [switch]$Apply
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

if (-not $Apply) {
  [ordered]@{
    status = "preview_only"
    minutes_id = $MinutesId
    requester_id_present = [bool]$RequesterId
    source_media_path = $SourceMediaPath
    transcript_path = $TranscriptPath
    summary_path = $SummaryPath
    message = "Template only. Copy to a private workspace and implement employee lookup before applying."
  } | ConvertTo-Json -Depth 5
  exit 0
}

throw "This template does not archive real files. Copy it to a private workspace and implement trusted employee lookup first."
