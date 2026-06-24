param(
  [string]$WorkspaceRoot = "<WORKSPACE_ROOT>",
  [switch]$Json,
  [switch]$Strict
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$checks = New-Object System.Collections.Generic.List[object]

function Add-Check {
  param(
    [ValidateSet("OK", "WARNING", "ERROR")]
    [string]$Level,
    [string]$Area,
    [string]$Message,
    [string]$Path = ""
  )

  $checks.Add([pscustomobject]@{
    level = $Level
    area = $Area
    message = $Message
    path = $Path
  }) | Out-Null
}

function Join-WorkspacePath {
  param([string]$RelativePath)
  return Join-Path $WorkspaceRoot $RelativePath
}

function Read-JsonFile {
  param(
    [string]$Path,
    [string]$Area
  )

  if (-not (Test-Path -LiteralPath $Path -PathType Leaf)) {
    Add-Check -Level "ERROR" -Area $Area -Message "File is missing" -Path $Path
    return $null
  }

  try {
    $raw = Get-Content -LiteralPath $Path -Raw -Encoding UTF8
    $value = $raw | ConvertFrom-Json -ErrorAction Stop
    Add-Check -Level "OK" -Area $Area -Message "JSON is valid" -Path $Path
    return $value
  } catch {
    Add-Check -Level "ERROR" -Area $Area -Message ("Invalid JSON: {0}" -f $_.Exception.Message) -Path $Path
    return $null
  }
}

function Assert-FileContains {
  param(
    [string]$Path,
    [string]$Needle,
    [string]$Area,
    [string]$Message,
    [ValidateSet("WARNING", "ERROR")]
    [string]$LevelOnMissing = "ERROR"
  )

  if (-not (Test-Path -LiteralPath $Path -PathType Leaf)) {
    Add-Check -Level "ERROR" -Area $Area -Message "File is missing" -Path $Path
    return
  }

  $content = Get-Content -LiteralPath $Path -Raw -Encoding UTF8
  if ($content -like "*$Needle*") {
    Add-Check -Level "OK" -Area $Area -Message $Message -Path $Path
  } else {
    Add-Check -Level $LevelOnMissing -Area $Area -Message $Message -Path $Path
  }
}

if (-not (Test-Path -LiteralPath $WorkspaceRoot -PathType Container)) {
  Add-Check -Level "ERROR" -Area "workspace" -Message "Workspace root is missing" -Path $WorkspaceRoot
} else {
  Add-Check -Level "OK" -Area "workspace" -Message "Workspace root is accessible" -Path $WorkspaceRoot
}

$rootRules = Join-WorkspacePath "AGENTS.md"
$ignoreFile = Join-WorkspacePath ".ignore"
$commonErrors = Join-WorkspacePath "COMMON_ERRORS.md"
$templateRootRules = Join-WorkspacePath "templates\AGENTS.md"
$templateSubAgentRules = Join-WorkspacePath "templates\subagent\SUB_AGENT.md"
$rulesIndex = Join-WorkspacePath "agent_rules\index.md"
$registry = Join-WorkspacePath "agent_rules\rule_registry.example.json"
$preflight = Join-WorkspacePath "agent_rules\common_error_preflight.md"
$hookGuardrails = Join-WorkspacePath "agent_rules\hook_guardrails.md"
$contextBudget = Join-WorkspacePath "agent_rules\context_budget.md"
$dailyReview = Join-WorkspacePath "agent_rules\daily_review_core.md"
$profile = Join-WorkspacePath "subagent\agent_profile.example.json"
$commonErrorCandidates = Join-WorkspacePath "memory_review\common_errors_update_pending.md"
$knowledgeStatus = Join-WorkspacePath "memory_review\knowledge_intake_status.example.csv"

Read-JsonFile -Path $registry -Area "rule registry" | Out-Null
Read-JsonFile -Path $profile -Area "agent profile" | Out-Null

Assert-FileContains -Path $rootRules -Needle "COMMON_ERRORS.md" -Area "common error preflight" -Message "Root rules reference COMMON_ERRORS.md"
Assert-FileContains -Path $rootRules -Needle "template hit only" -Area "template boundary" -Message "Root rules prevent template hits from being treated as runtime context"
Assert-FileContains -Path $ignoreFile -Needle "templates/" -Area "template boundary" -Message ".ignore hides templates from default local search" -LevelOnMissing "WARNING"
Assert-FileContains -Path $templateRootRules -Needle "TEMPLATE ONLY" -Area "template boundary" -Message "Template AGENTS.md has a template-only banner" -LevelOnMissing "WARNING"
Assert-FileContains -Path $templateSubAgentRules -Needle "TEMPLATE ONLY" -Area "template boundary" -Message "Template SUB_AGENT.md has a template-only banner" -LevelOnMissing "WARNING"
Assert-FileContains -Path $preflight -Needle "common_errors_update_pending.md" -Area "common error preflight" -Message "Preflight rule references update candidates"
Assert-FileContains -Path $hookGuardrails -Needle "pre-model" -Area "hook guardrails" -Message "Hook guardrails cover pre-model connector failures"
Assert-FileContains -Path $contextBudget -Needle "SUB_AGENT.md" -Area "context budget" -Message "Context budget covers SUB_AGENT.md"
Assert-FileContains -Path $dailyReview -Needle "send_to_group" -Area "daily review" -Message "Daily review send policy is profile-controlled"
Assert-FileContains -Path $commonErrors -Needle "pre-model" -Area "common errors" -Message "Common errors include pre-model failure guidance" -LevelOnMissing "WARNING"
Assert-FileContains -Path $commonErrorCandidates -Needle "COMMON_ERRORS.md" -Area "common error candidates" -Message "Candidate file references COMMON_ERRORS.md"

if (Test-Path -LiteralPath $knowledgeStatus -PathType Leaf) {
  $header = Get-Content -LiteralPath $knowledgeStatus -TotalCount 1 -Encoding UTF8
  if ($header -eq "id,source_type,source_scope,title,status,target,owner,created_at,reviewed_at,risk_level,notes") {
    Add-Check -Level "OK" -Area "knowledge intake status" -Message "CSV header is valid" -Path $knowledgeStatus
  } else {
    Add-Check -Level "ERROR" -Area "knowledge intake status" -Message "CSV header is invalid" -Path $knowledgeStatus
  }
} else {
  Add-Check -Level "ERROR" -Area "knowledge intake status" -Message "CSV template is missing" -Path $knowledgeStatus
}

$errorCount = @($checks | Where-Object { $_.level -eq "ERROR" }).Count
$warningCount = @($checks | Where-Object { $_.level -eq "WARNING" }).Count
$okCount = @($checks | Where-Object { $_.level -eq "OK" }).Count

$summary = [pscustomobject]@{
  ok = $okCount
  warnings = $warningCount
  errors = $errorCount
  strict = [bool]$Strict
  checks = $checks
}

if ($Json) {
  $summary | ConvertTo-Json -Depth 20
} else {
  Write-Output "# Agent governance check"
  Write-Output ""
  Write-Output ("- OK: {0}" -f $okCount)
  Write-Output ("- WARNING: {0}" -f $warningCount)
  Write-Output ("- ERROR: {0}" -f $errorCount)
  Write-Output ""
  foreach ($check in $checks) {
    $line = "- [{0}] {1}: {2}" -f $check.level, $check.area, $check.message
    if (-not [string]::IsNullOrWhiteSpace($check.path)) {
      $line += " ({0})" -f $check.path
    }
    Write-Output $line
  }
}

if ($errorCount -gt 0 -or ($Strict -and $warningCount -gt 0)) {
  exit 1
}
exit 0
