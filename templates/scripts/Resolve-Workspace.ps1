Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

param(
  [string]$SessionKey = $env:AGENT_SESSION_KEY,
  [string]$RegistryPath = ""
)

$result = [ordered]@{
  context_type = "local"
  session_key_present = [bool]$SessionKey
  workspace_id = ""
  context_path = ""
  message = "Template only. Copy to a private workspace and implement registry lookup."
}

$result | ConvertTo-Json -Depth 5
