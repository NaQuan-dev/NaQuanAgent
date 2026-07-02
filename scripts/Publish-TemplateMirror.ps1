param(
  [string]$TemplateRoot = "templates",
  [string]$Remote = "origin",
  [string]$Branch = "main",
  [string]$WorktreePath = ".tmp\publish-template-mirror",
  [string]$CommitMessage = "Publish sanitized template mirror",
  [string]$SensitivePattern = "",
  [switch]$Commit,
  [switch]$Push,
  [switch]$KeepWorktree
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function Invoke-Git {
  param(
    [string]$Cwd,
    [string[]]$GitArgs
  )

  & git -C $Cwd @GitArgs
  if ($LASTEXITCODE -ne 0) {
    throw ("git failed: {0}" -f ($GitArgs -join " "))
  }
}

function Assert-InsidePath {
  param(
    [string]$Child,
    [string]$Parent,
    [string]$Label
  )

  $childFull = [System.IO.Path]::GetFullPath($Child)
  $parentFull = [System.IO.Path]::GetFullPath($Parent)
  if (-not $childFull.StartsWith($parentFull, [System.StringComparison]::OrdinalIgnoreCase)) {
    throw "$Label must stay inside $parentFull"
  }
}

$repoRoot = (& git rev-parse --show-toplevel).Trim()
if ($LASTEXITCODE -ne 0 -or [string]::IsNullOrWhiteSpace($repoRoot)) {
  throw "Run this script inside a Git repository."
}

$templateRootFull = [System.IO.Path]::GetFullPath((Join-Path $repoRoot $TemplateRoot))
$worktreeFull = [System.IO.Path]::GetFullPath((Join-Path $repoRoot $WorktreePath))

if ([string]::IsNullOrWhiteSpace($SensitivePattern)) {
  $windowsDrive = "E:" + [regex]::Escape("\")
  $windowsUsers = "C:" + [regex]::Escape("\") + "Users" + [regex]::Escape("\")
  $macUsers = "/" + "Users" + "/[^<][^/]+"
  $linuxHome = "/" + "home" + "/[^<][^/]+"
  $SensitivePattern = @(
    $windowsDrive,
    $windowsUsers,
    $macUsers,
    $linuxHome,
    "ou_[0-9A-Fa-f]{12,}",
    "oc_[0-9A-Fa-f]{12,}",
    "app_secret\s*[:=]",
    "client_secret\s*[:=]",
    "Authorization:\s*Bearer",
    "Bearer\s+[A-Za-z0-9._-]{20,}",
    "sk-[A-Za-z0-9_-]{20,}"
  ) -join "|"
}

Assert-InsidePath -Child $templateRootFull -Parent $repoRoot -Label "TemplateRoot"
Assert-InsidePath -Child $worktreeFull -Parent $repoRoot -Label "WorktreePath"

if (-not (Test-Path -LiteralPath $templateRootFull -PathType Container)) {
  throw "Template root is missing: $templateRootFull"
}

foreach ($required in @("AGENTS.md", "README.md", ".gitignore")) {
  $requiredPath = Join-Path $templateRootFull $required
  if (-not (Test-Path -LiteralPath $requiredPath -PathType Leaf)) {
    throw "Template mirror is missing required file: $required"
  }
}

if (Test-Path -LiteralPath $worktreeFull) {
  throw "Worktree path already exists. Remove it or choose another WorktreePath: $worktreeFull"
}

$rg = Get-Command rg -ErrorAction SilentlyContinue
if ($rg) {
  & rg -n -S $SensitivePattern $templateRootFull
  if ($LASTEXITCODE -eq 0) {
    throw "Sensitive scan matched content in TemplateRoot. Review output before publishing."
  } elseif ($LASTEXITCODE -gt 1) {
    throw "Sensitive scan failed."
  }
}

Invoke-Git -Cwd $repoRoot -GitArgs @("fetch", $Remote, $Branch)
Invoke-Git -Cwd $repoRoot -GitArgs @("worktree", "add", $worktreeFull, "$Remote/$Branch")

try {
  $tracked = & git -C $worktreeFull ls-files
  if ($LASTEXITCODE -ne 0) {
    throw "Unable to list tracked files in publish worktree."
  }

  foreach ($path in $tracked) {
    $target = Join-Path $worktreeFull $path
    Assert-InsidePath -Child $target -Parent $worktreeFull -Label "tracked file"
    if (Test-Path -LiteralPath $target -PathType Leaf) {
      Remove-Item -LiteralPath $target -Force
    }
  }

  Get-ChildItem -LiteralPath $templateRootFull -Force | ForEach-Object {
    Copy-Item -LiteralPath $_.FullName -Destination $worktreeFull -Recurse -Force
  }

  Invoke-Git -Cwd $worktreeFull -GitArgs @("add", "-A")
  Invoke-Git -Cwd $worktreeFull -GitArgs @("diff", "--cached", "--check")

  & git -C $worktreeFull grep --cached -n -E $SensitivePattern -- .
  if ($LASTEXITCODE -eq 0) {
    throw "Sensitive scan matched staged content. Review output before publishing."
  } elseif ($LASTEXITCODE -gt 1) {
    throw "Staged sensitive scan failed."
  }

  Invoke-Git -Cwd $worktreeFull -GitArgs @("diff", "--cached", "--name-status")

  if ($Push) {
    $Commit = $true
  }

  if ($Commit) {
    $hasChanges = & git -C $worktreeFull diff --cached --quiet
    if ($LASTEXITCODE -eq 0) {
      Write-Host "No template mirror changes to commit."
    } else {
      Invoke-Git -Cwd $worktreeFull -GitArgs @("commit", "-m", $CommitMessage)
      if ($Push) {
        Invoke-Git -Cwd $worktreeFull -GitArgs @("push", $Remote, "HEAD:$Branch")
      }
    }
  } else {
    Write-Host "Preview only. Review the temporary worktree before committing:"
    Write-Host $worktreeFull
    $KeepWorktree = $true
  }
}
finally {
  if (-not $KeepWorktree -and (Test-Path -LiteralPath $worktreeFull -PathType Container)) {
    Invoke-Git -Cwd $repoRoot -GitArgs @("worktree", "remove", "--force", $worktreeFull)
  }
}
