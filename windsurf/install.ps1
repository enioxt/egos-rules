# EGOS Windsurf Profile Installer — Windows (PowerShell)
# Run as: .\install.ps1
# Applies .windsurfrules, settings.json, and mcp.json from this repo.

param(
    [string]$EgosDir = "$env:USERPROFILE\.egos"
)

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$EgosDir = Split-Path -Parent $ScriptDir

Write-Host "=== EGOS Windsurf Profile Installer (Windows) ===" -ForegroundColor Cyan
Write-Host "Source: $ScriptDir"

# 1. .windsurfrules → global symlink
$RulesSrc = Join-Path $EgosDir ".windsurfrules"
$RulesDst = Join-Path $env:USERPROFILE ".windsurfrules"
if (Test-Path $RulesSrc) {
    Copy-Item $RulesSrc $RulesDst -Force
    Write-Host "✓ .windsurfrules copied to $RulesDst" -ForegroundColor Green
} else {
    Write-Host "⚠ .windsurfrules not found" -ForegroundColor Yellow
}

# 2. settings.json → Windsurf user settings
$SettingsSrc = Join-Path $ScriptDir "settings.json"
$WindsurfPaths = @(
    "$env:APPDATA\Windsurf\User",
    "$env:APPDATA\windsurf-next\WindsurfNextUser\User",
    "$env:APPDATA\Code\User"
)
foreach ($Path in $WindsurfPaths) {
    if (Test-Path $Path) {
        Copy-Item $SettingsSrc (Join-Path $Path "settings.json") -Force
        Write-Host "✓ settings.json → $Path\settings.json" -ForegroundColor Green
        break
    }
}

# 3. mcp.json
$McpTemplate = Join-Path $ScriptDir "mcp.template.json"
$McpEnv = Join-Path $ScriptDir ".env.local"
$McpDst = "$env:APPDATA\windsurf\mcp.json"

New-Item -ItemType Directory -Force -Path (Split-Path $McpDst) | Out-Null

if (Test-Path $McpEnv) {
    Write-Host "✓ Found .env.local — copy mcp.template.json and fill secrets" -ForegroundColor Yellow
    Copy-Item $McpTemplate $McpDst -Force
    Write-Host "  Edit $McpDst and replace `$`{VAR`} with actual values from .env.local"
} else {
    Copy-Item $McpTemplate $McpDst -Force
    Write-Host "⚠ mcp.json copied as template — edit $McpDst with your secrets" -ForegroundColor Yellow
}

# 4. Extensions
Write-Host "`n=== Extensions to install ===" -ForegroundColor Cyan
Write-Host "Run in Windsurf terminal (Ctrl+``): "
Get-Content (Join-Path $ScriptDir "extensions.list") | ForEach-Object {
    Write-Host "  windsurf --install-extension $_"
}

Write-Host "`n✅ Profile applied. Restart Windsurf." -ForegroundColor Green
