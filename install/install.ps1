# antislop installer (Windows PowerShell)
# Copies antislop.md + selected skills into a target location and writes the
# antislop pointer block into the agent's entry file (idempotent via markers).
[CmdletBinding()]
param(
    [switch]$Local,
    [switch]$Global,
    [string]$Agent = "",
    [string]$Skills = "",
    [switch]$DryRun,
    [switch]$Yes
)

$ErrorActionPreference = "Stop"

$POINTER_START = "<!-- antislop:start -->"
$POINTER_END   = "<!-- antislop:end -->"

# The pointer block written into entry files (single-quoted here-string keeps
# the backticks literal).
$POINTER_BLOCK = @'
<!-- antislop:start -->
## antislop

For UI, copy, human-centered details, responsive layout, or code comments work, read `antislop.md` (core) and then the skill for the task:
- UI / visual: `skills/ui.md`
- Copy & text: `skills/copywriting.md`
- Human-centered / a11y: `skills/human.md`
- Responsive / mobile: `skills/responsive.md`
- Code comments: `skills/code-comments.md`

Before starting, ask the user when antislop applies: during the work, or after it is done.
<!-- antislop:end -->
'@

# --- locate the antislop source tree ---------------------------------------
$SOURCE_DIR  = Resolve-Path (Join-Path $PSScriptRoot "..")
$CORE_MD     = Join-Path $SOURCE_DIR "antislop.md"
$SKILLS_DIR  = Join-Path $SOURCE_DIR "skills"

# --- skill helpers ----------------------------------------------------------
$ALL_SKILLS = @("ui", "copywriting", "human", "responsive", "code-comments")
function Skill-File($name) {
  switch ($name) {
    "ui"            { "ui.md" }
    "copywriting"   { "copywriting.md" }
    "human"         { "human.md" }
    "responsive"    { "responsive.md" }
    "code-comments" { "code-comments.md" }
    default         { "" }
  }
}

# Resolve the list of selected skills.
$SELECTED = @()
if ([string]::IsNullOrEmpty($Skills)) {
  $interactiveInput = $false
  try { $interactiveInput = [Environment]::UserInteractive } catch { $interactiveInput = $false }
  if ($interactiveInput -and -not $Yes) {
    Write-Host "Select skills to install (comma-separated numbers/names, or 'a' for all):"
    for ($i = 0; $i -lt $ALL_SKILLS.Count; $i++) { Write-Host ("  {0}) {1}" -f ($i + 1), $ALL_SKILLS[$i]) }
    $choice = Read-Host ">"
    if ($choice -eq "a" -or $choice -eq "") {
      $SELECTED = $ALL_SKILLS
    } else {
      foreach ($p in ($choice -split ",")) {
        $p = $p.Trim()
        if ($p -match '^\d+$' -and [int]$p -ge 1 -and [int]$p -le $ALL_SKILLS.Count) {
          $SELECTED += $ALL_SKILLS[[int]$p - 1]
        } elseif ((Skill-File $p) -ne "") {
          $SELECTED += $p
        } else {
          Write-Warning "Ignoring unknown skill: $p"
        }
      }
    }
    if ($SELECTED.Count -eq 0) { $SELECTED = $ALL_SKILLS }
  } else {
    $SELECTED = $ALL_SKILLS
  }
} else {
  if ($Skills -eq "all") {
    $SELECTED = $ALL_SKILLS
  } else {
    foreach ($p in ($Skills -split ",")) {
      $p = $p.Trim()
      if ((Skill-File $p) -ne "") { $SELECTED += $p } else { Write-Warning "Unknown skill: $p" }
    }
  }
}
if ($SELECTED.Count -eq 0) { Write-Error "No valid skills selected."; exit 1 }

# --- agent selection --------------------------------------------------------
$KNOWN = @("claude-code", "cursor", "cline", "windsurf", "aider", "codex", "opencode", "continue")

function Detect-Agents {
  $found = @()
  if (Test-Path ".claude")         { $found += "claude-code" }
  if (Test-Path ".cursor")         { $found += "cursor" }
  if (Test-Path ".clinerules")     { $found += "cline" }
  if (Test-Path ".windsurfrules")  { $found += "windsurf" }
  if (Test-Path ".aider.conf.yml") { $found += "aider" }
  if (Test-Path "AGENTS.md")       { $found += "codex" }
  if (Test-Path "opencode.json")   { $found += "opencode" }
  if (Test-Path "config.yaml")     { $found += "continue" }
  return $found
}

if ([string]::IsNullOrEmpty($Agent) -or $Agent -eq "auto") {
  $detected = Detect-Agents
  $interactiveInput = $false
  try { $interactiveInput = [Environment]::UserInteractive } catch { $interactiveInput = $false }
  if ($interactiveInput -and -not $Yes) {
    if ($detected.Count -eq 0) {
      $ans = Read-Host "No agent config detected in $(Get-Location). Install a generic AGENTS.md at the repo root? [Y/n]"
      if ($ans -eq "n" -or $ans -eq "N") { Write-Host "Aborted."; exit 0 }
      $Agent = "codex"
    } else {
      Write-Host "Detected agent config(s): $($detected -join ', ')"
      Write-Host "Pick one to install for (number, or 'g' for generic AGENTS.md):"
      for ($i = 0; $i -lt $detected.Count; $i++) { Write-Host ("  {0}) {1}" -f ($i + 1), $detected[$i]) }
      Write-Host "  g) generic AGENTS.md at repo root"
      $pick = Read-Host ">"
      if ($pick -eq "g") {
        $Agent = "codex"
      } elseif ($pick -match '^\d+$' -and [int]$pick -ge 1 -and [int]$pick -le $detected.Count) {
        $Agent = $detected[[int]$pick - 1]
      } else {
        $Agent = "codex"
      }
    }
  } elseif ($Yes) {
    if ($detected.Count -gt 0) { $Agent = $detected[0] } else { $Agent = "codex" }
  } else {
    Write-Error "Error: -Agent is required when running non-interactively. Pass -Agent <claude-code|cursor|cline|windsurf|aider|codex|opencode|continue>."
    exit 1
  }
}

if ($KNOWN -notcontains $Agent) { Write-Error "Unknown agent: $Agent"; exit 1 }

# --- path helpers -----------------------------------------------------------
function Entry-For($agent) {
  switch ($agent) {
    "claude-code" { "CLAUDE.md" }
    "cursor"      { ".cursor/rules/antislop.mdc" }
    "cline"       { ".clinerules" }
    "windsurf"    { ".windsurfrules" }
    "aider"       { "CONVENTIONS.md" }
    "codex"       { "AGENTS.md" }
    "opencode"    { "opencode.json" }
    "continue"    { "config.yaml" }
    default       { "AGENTS.md" }
  }
}
function UserEntry-For($agent) {
  switch ($agent) {
    "claude-code" { Join-Path $HOME ".claude/CLAUDE.md" }
    "cursor"      { Join-Path $HOME ".cursor/rules/antislop.mdc" }
    "cline"       { Join-Path $HOME ".clinerules" }
    "windsurf"    { Join-Path $HOME ".windsurfrules" }
    "aider"       { Join-Path $HOME ".aider.conf.yml" }
    "codex"       { Join-Path $HOME "AGENTS.md" }
    "opencode"    { Join-Path $HOME ".config/opencode/opencode.json" }
    "continue"    { Join-Path $HOME ".continue/config.yaml" }
    default       { Join-Path $HOME "AGENTS.md" }
  }
}

# --- file writers -----------------------------------------------------------
function Write-PointerMd($file) {
  $dir = Split-Path $file
  if (-not (Test-Path $dir)) { New-Item -ItemType Directory -Force -Path $dir | Out-Null }
  $body = ""
  if (Test-Path $file) {
    $content = Get-Content $file -Raw
    $pattern = [regex]::Escape($POINTER_START) + ".*?" + [regex]::Escape($POINTER_END)
    $body = [regex]::Replace($content, $pattern, "", [System.Text.RegularExpressions.RegexOptions]::Singleline)
    $body = $body.TrimEnd()
  }
  $newContent = if ($body) { "$body`n`n$POINTER_BLOCK" } else { $POINTER_BLOCK }
  Set-Content -Path $file -Value $newContent
}
function Write-Continue($file) {
  $dir = Split-Path $file
  if (-not (Test-Path $dir)) { New-Item -ItemType Directory -Force -Path $dir | Out-Null }
  $lines = @("# antislop: load the anti-slop filter every session", "rules:", "  - ./antislop.md")
  foreach ($s in $SELECTED) { $lines += "  - ./skills/$(Skill-File $s)" }
  Set-Content -Path $file -Value ($lines -join "`n")
}
function Write-OpenCode($file) {
  $dir = Split-Path $file
  if (-not (Test-Path $dir)) { New-Item -ItemType Directory -Force -Path $dir | Out-Null }
  $json = @{
    agents = @{
      default = @{
        prompt = "Read antislop.md and the matching skills/ file before UI, copy, human, responsive, or code-comment work. Run the Delivery Gate before shipping."
      }
    }
  }
  $json | ConvertTo-Json -Depth 5 | Set-Content -Path $file
}

# --- install for the chosen agent ------------------------------------------
$MODE = if ($Global) { "global" } else { "local" }
$target = if ($MODE -eq "global") { Join-Path $HOME ".antislop" } else { (Get-Location).Path }
$entry  = if ($MODE -eq "global") { UserEntry-For $Agent } else { Join-Path $target (Entry-For $Agent) }

Write-Host "==> Installing antislop for '$Agent' ($MODE)"
Write-Host "    files -> $target"
Write-Host "    entry -> $entry"

if (-not $DryRun) {
  if (-not (Test-Path $target)) { New-Item -ItemType Directory -Force -Path $target | Out-Null }
  New-Item -ItemType Directory -Force -Path (Join-Path $target "skills") | Out-Null
  Copy-Item $CORE_MD (Join-Path $target "antislop.md") -Force
  foreach ($s in $SELECTED) {
    Copy-Item (Join-Path $SKILLS_DIR (Skill-File $s)) (Join-Path $target "skills") -Force
  }

  switch ($Agent) {
    "opencode" { Write-OpenCode $entry }
    "continue" { Write-Continue $entry }
    "aider"    {
      Write-PointerMd $entry
      $conf = if ($MODE -eq "global") { Join-Path $HOME ".aider.conf.yml" } else { Join-Path $target ".aider.conf.yml" }
      Set-Content -Path $conf -Value ("read:`n  - CONVENTIONS.md`n  - antislop.md")
      Write-Host "    aider conf -> $conf"
    }
    default    { Write-PointerMd $entry }
  }
  Write-Host "    done."
}

Write-Host ""
Write-Host "antislop is installed. Restart / refresh your agent session to load it."
