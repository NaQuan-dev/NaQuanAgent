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
    Add-Check -Level $LevelOnMissing -Area $Area -Message "File is missing" -Path $Path
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

$templateWorkspace = $WorkspaceRoot
if (-not (Test-Path -LiteralPath (Join-Path $templateWorkspace "agent_rules") -PathType Container)) {
  $nestedTemplateWorkspace = Join-Path $WorkspaceRoot "templates"
  if (Test-Path -LiteralPath (Join-Path $nestedTemplateWorkspace "agent_rules") -PathType Container) {
    $templateWorkspace = $nestedTemplateWorkspace
  }
}
$templateWorkspace = (Resolve-Path -LiteralPath $templateWorkspace).Path

function Join-TemplatePath {
  param([string]$RelativePath)
  return Join-Path $templateWorkspace $RelativePath
}

$rootRules = Join-TemplatePath "AGENTS.md"
$ignoreFile = Join-WorkspacePath ".ignore"
if (-not (Test-Path -LiteralPath $ignoreFile -PathType Leaf)) {
  $parentIgnoreFile = Join-Path (Split-Path -Parent $templateWorkspace) ".ignore"
  if (Test-Path -LiteralPath $parentIgnoreFile -PathType Leaf) {
    $ignoreFile = $parentIgnoreFile
  }
}
$commonErrors = Join-WorkspacePath "COMMON_ERRORS.md"
if (-not (Test-Path -LiteralPath $commonErrors -PathType Leaf)) {
  $parentCommonErrors = Join-Path (Split-Path -Parent $templateWorkspace) "COMMON_ERRORS.md"
  if (Test-Path -LiteralPath $parentCommonErrors -PathType Leaf) {
    $commonErrors = $parentCommonErrors
  }
}
$templateRootRules = $rootRules
$templateSubAgentRules = Join-TemplatePath "subagent\SUB_AGENT.md"
$rulesIndex = Join-TemplatePath "agent_rules\index.md"
$registry = Join-TemplatePath "agent_rules\rule_registry.example.json"
$preflight = Join-TemplatePath "agent_rules\common_error_preflight.md"
$hookGuardrails = Join-TemplatePath "agent_rules\hook_guardrails.md"
$companySources = Join-TemplatePath "agent_rules\company_sources.md"
$agentKnowledge = Join-TemplatePath "agent_rules\agent_knowledge.md"
$businessSystemSecurity = Join-TemplatePath "agent_rules\business_system_security.md"
$workerRuntime = Join-TemplatePath "agent_rules\worker_runtime.md"
$graphDiagnostics = Join-TemplatePath "agent_rules\graph_diagnostics.md"
$governanceReview = Join-TemplatePath "agent_rules\governance_review.md"
$systemSlimming = Join-TemplatePath "agent_rules\system_slimming.md"
$contextBudget = Join-TemplatePath "agent_rules\context_budget.md"
$dailyReview = Join-TemplatePath "agent_rules\daily_review_core.md"
$profile = Join-TemplatePath "subagent\agent_profile.example.json"
$commonErrorCandidates = Join-TemplatePath "memory_review\common_errors_update_pending.md"
$knowledgeStatus = Join-TemplatePath "memory_review\knowledge_intake_status.example.csv"

Read-JsonFile -Path $registry -Area "rule registry" | Out-Null
Read-JsonFile -Path $profile -Area "agent profile" | Out-Null

Assert-FileContains -Path $rootRules -Needle "COMMON_ERRORS.md" -Area "common error preflight" -Message "Root rules reference COMMON_ERRORS.md"
Assert-FileContains -Path $rootRules -Needle "sanitized scaffolds" -Area "template boundary" -Message "Root rules prevent template files from being treated as runtime context"
Assert-FileContains -Path $rootRules -Needle "company_sources.md" -Area "company knowledge sources" -Message "Root rules route company-material tasks to company_sources.md"
Assert-FileContains -Path $rootRules -Needle "agent_knowledge.md" -Area "company knowledge sources" -Message "Root rules route company-material tasks to agent_knowledge.md"
Assert-FileContains -Path $ignoreFile -Needle "templates/" -Area "template boundary" -Message ".ignore hides templates from default local search" -LevelOnMissing "WARNING"
Assert-FileContains -Path $templateRootRules -Needle "TEMPLATE ONLY" -Area "template boundary" -Message "Template AGENTS.md has a template-only banner" -LevelOnMissing "WARNING"
Assert-FileContains -Path $templateSubAgentRules -Needle "TEMPLATE ONLY" -Area "template boundary" -Message "Template SUB_AGENT.md has a template-only banner" -LevelOnMissing "WARNING"
Assert-FileContains -Path $preflight -Needle "common_errors_update_pending.md" -Area "common error preflight" -Message "Preflight rule references update candidates"
Assert-FileContains -Path $hookGuardrails -Needle "pre-model" -Area "hook guardrails" -Message "Hook guardrails cover pre-model connector failures"
Assert-FileContains -Path $companySources -Needle "agent_knowledge.md" -Area "company knowledge sources" -Message "Company sources route to Agent knowledge"
Assert-FileContains -Path $companySources -Needle "human knowledge base" -Area "company knowledge sources" -Message "Company sources reference human KB verification"
Assert-FileContains -Path $agentKnowledge -Needle "human-KB current-version map" -Area "company knowledge sources" -Message "Agent knowledge rule references human-KB current-version map"
Assert-FileContains -Path $businessSystemSecurity -Needle "Audio, video, transcripts" -Area "business-system security" -Message "Business-system rule blocks audio-only intent"
Assert-FileContains -Path $workerRuntime -Needle "Do not send" -Area "worker runtime" -Message "Worker rule blocks placeholder replies"
Assert-FileContains -Path $graphDiagnostics -Needle "not an authoritative knowledge source" -Area "graph diagnostics" -Message "Graph diagnostics are not authoritative"
Assert-FileContains -Path $governanceReview -Needle "sanitized template" -Area "governance review" -Message "Governance review separates live and template updates"
Assert-FileContains -Path $systemSlimming -Needle "startup files short" -Area "system slimming" -Message "System slimming rule exists"
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
