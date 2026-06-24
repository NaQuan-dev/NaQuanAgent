param(
  [Parameter(Mandatory = $true)]
  [string]$InputPath,

  [string]$ProfileName = "<NAS_PROFILE>",

  [string]$OutputPath,

  [switch]$Apply
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

if ($Apply) {
  throw "This template is dry-run only. Copy it to a private workspace and implement the NAS adapter before applying changes."
}

if (-not (Test-Path -LiteralPath $InputPath -PathType Leaf)) {
  throw "InputPath not found: $InputPath"
}

$rows = @(Import-Csv -LiteralPath $InputPath)
if ($rows.Count -eq 0) {
  throw "Input file has no records."
}

$requiredColumns = @(
  "employee_ref",
  "nas_username",
  "display_name",
  "status",
  "groups",
  "quota_gb",
  "home_enabled"
)

$headers = @($rows[0].PSObject.Properties.Name)
$missingColumns = @($requiredColumns | Where-Object { $headers -notcontains $_ })
if ($missingColumns.Count -gt 0) {
  throw "Missing required columns: $($missingColumns -join ', ')"
}

$validStatuses = @("active", "disabled")
$trueValues = @("true", "yes", "1")
$falseValues = @("false", "no", "0")
$usernamePattern = "^[a-z][a-z0-9._-]{1,31}$"
$errors = New-Object System.Collections.Generic.List[object]
$warnings = New-Object System.Collections.Generic.List[object]
$operations = New-Object System.Collections.Generic.List[object]
$seenEmployeeRefs = @{}
$seenNasUsernames = @{}

function Test-Placeholder {
  param([string]$Value)

  return $Value -match "^<[^>]+>$"
}

for ($index = 0; $index -lt $rows.Count; $index++) {
  $row = $rows[$index]
  $lineNumber = $index + 2

  $employeeRef = ([string]$row.employee_ref).Trim()
  $nasUsername = ([string]$row.nas_username).Trim()
  $displayName = ([string]$row.display_name).Trim()
  $status = ([string]$row.status).Trim().ToLowerInvariant()
  $groups = @(([string]$row.groups).Split(";") | ForEach-Object { $_.Trim() } | Where-Object { $_ })
  $quotaText = ([string]$row.quota_gb).Trim()
  $homeText = ([string]$row.home_enabled).Trim().ToLowerInvariant()

  if (Test-Placeholder -Value $employeeRef) {
    $warnings.Add([ordered]@{ line = $lineNumber; field = "employee_ref"; message = "Placeholder value found. Replace it before real use." })
  }

  if (Test-Placeholder -Value $nasUsername) {
    $warnings.Add([ordered]@{ line = $lineNumber; field = "nas_username"; message = "Placeholder value found. Replace it before real use." })
  }

  if (Test-Placeholder -Value $displayName) {
    $warnings.Add([ordered]@{ line = $lineNumber; field = "display_name"; message = "Placeholder value found. Replace it before real use." })
  }

  foreach ($group in $groups) {
    if (Test-Placeholder -Value $group) {
      $warnings.Add([ordered]@{ line = $lineNumber; field = "groups"; message = "Placeholder group found: $group" })
    }
  }

  if (-not $employeeRef) {
    $errors.Add([ordered]@{ line = $lineNumber; field = "employee_ref"; message = "Value is required." })
  } elseif ($seenEmployeeRefs.ContainsKey($employeeRef)) {
    $errors.Add([ordered]@{ line = $lineNumber; field = "employee_ref"; message = "Duplicate value. First seen on line $($seenEmployeeRefs[$employeeRef])." })
  } else {
    $seenEmployeeRefs[$employeeRef] = $lineNumber
  }

  if (-not $nasUsername) {
    $errors.Add([ordered]@{ line = $lineNumber; field = "nas_username"; message = "Value is required." })
  } elseif ($seenNasUsernames.ContainsKey($nasUsername)) {
    $errors.Add([ordered]@{ line = $lineNumber; field = "nas_username"; message = "Duplicate value. First seen on line $($seenNasUsernames[$nasUsername])." })
  } elseif ((-not (Test-Placeholder -Value $nasUsername)) -and ($nasUsername -notmatch $usernamePattern)) {
    $errors.Add([ordered]@{ line = $lineNumber; field = "nas_username"; message = "Use 2-32 lowercase letters, numbers, dots, underscores, or hyphens. Start with a letter." })
  } else {
    $seenNasUsernames[$nasUsername] = $lineNumber
  }

  if (-not $displayName) {
    $errors.Add([ordered]@{ line = $lineNumber; field = "display_name"; message = "Value is required." })
  }

  if ($validStatuses -notcontains $status) {
    $errors.Add([ordered]@{ line = $lineNumber; field = "status"; message = "Use active or disabled." })
  }

  if ($status -eq "active" -and $groups.Count -eq 0) {
    $errors.Add([ordered]@{ line = $lineNumber; field = "groups"; message = "At least one group is required for active users." })
  }

  $quotaGb = 0
  if (-not [decimal]::TryParse(
      $quotaText,
      [System.Globalization.NumberStyles]::Number,
      [System.Globalization.CultureInfo]::InvariantCulture,
      [ref]$quotaGb
    )) {
    $errors.Add([ordered]@{ line = $lineNumber; field = "quota_gb"; message = "Use a numeric quota in GB." })
  } elseif ($quotaGb -lt 0) {
    $errors.Add([ordered]@{ line = $lineNumber; field = "quota_gb"; message = "Quota cannot be negative." })
  }

  if (($trueValues -notcontains $homeText) -and ($falseValues -notcontains $homeText)) {
    $errors.Add([ordered]@{ line = $lineNumber; field = "home_enabled"; message = "Use true/false, yes/no, or 1/0." })
  }

  $homeEnabled = $trueValues -contains $homeText
  $action = if ($status -eq "disabled") { "disable_user" } else { "upsert_user" }

  $operations.Add([ordered]@{
      action = $action
      user = [ordered]@{
        employee_ref = $employeeRef
        nas_username = $nasUsername
        display_name = $displayName
        status = $status
        groups = $groups
        quota_gb = $quotaGb
        home_enabled = $homeEnabled
      }
    })
}

$result = if ($errors.Count -gt 0) {
  [ordered]@{
    status = "invalid"
    dry_run = $true
    profile = $ProfileName
    errors = $errors
    message = "Input validation failed. No NAS API was called."
  }
} else {
  $status = if ($warnings.Count -gt 0) { "template" } else { "ready" }
  $message = if ($warnings.Count -gt 0) {
    "Input contains placeholder values. Replace them before using a private NAS adapter."
  } else {
    "Template only. No NAS API was called."
  }

  [ordered]@{
    status = $status
    dry_run = $true
    profile = $ProfileName
    warnings = $warnings
    counts = [ordered]@{
      total = $operations.Count
      upsert_user = @($operations | Where-Object { $_.action -eq "upsert_user" }).Count
      disable_user = @($operations | Where-Object { $_.action -eq "disable_user" }).Count
    }
  operations = $operations
  message = $message
  }
}

$json = $result | ConvertTo-Json -Depth 8

if ($OutputPath) {
  $outputDirectory = Split-Path -Parent $OutputPath
  if ($outputDirectory -and (-not (Test-Path -LiteralPath $outputDirectory -PathType Container))) {
    throw "Output directory not found: $outputDirectory"
  }

  Set-Content -LiteralPath $OutputPath -Value $json -Encoding UTF8
}

$json

if ($errors.Count -gt 0) {
  exit 1
}
