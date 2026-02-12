#Requires -Version 5.1
<#
.SYNOPSIS
    AI Dev Toolkit - Windows PowerShell Setup Script

.DESCRIPTION
    One-command setup for AI-powered development tools on Windows.
    Installs Claude Code, OpenCode, or both via npm, and configures
    PowerShell aliases in your $PROFILE.

.PARAMETER Tool
    Which tool(s) to install: Claude, OpenCode, or All. Default: interactive prompt.

.PARAMETER NoAliases
    Skip alias installation.

.PARAMETER DryRun
    Preview actions without executing.

.PARAMETER Help
    Show help message.

.EXAMPLE
    .\setup.ps1
    .\setup.ps1 -Tool All
    .\setup.ps1 -Tool Claude -DryRun
#>

param(
    [ValidateSet("Claude", "OpenCode", "All")]
    [string]$Tool = "",

    [switch]$NoAliases,
    [switch]$DryRun,
    [switch]$Help
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

# ---------------------------------------------------------------------------
# Constants
# ---------------------------------------------------------------------------
$script:Version = "1.0.0"
$script:InstallClaude = $false
$script:InstallOpenCode = $false
$script:NodeInstalledByUs = $false

# ---------------------------------------------------------------------------
# Output Helpers
# ---------------------------------------------------------------------------
function Write-Step    { param([string]$Msg) Write-Host "`n>>> $Msg" -ForegroundColor Cyan }
function Write-Info    { param([string]$Msg) Write-Host "[INFO]  $Msg" -ForegroundColor Blue }
function Write-Ok      { param([string]$Msg) Write-Host "[OK]    $Msg" -ForegroundColor Green }
function Write-Caution { param([string]$Msg) Write-Host "[WARN]  $Msg" -ForegroundColor Yellow }
function Write-Err     { param([string]$Msg) Write-Host "[ERROR] $Msg" -ForegroundColor Red }

function Show-Help {
    Write-Host ""
    Write-Host "AI Dev Toolkit Setup v$script:Version" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Usage: .\setup.ps1 [OPTIONS]"
    Write-Host ""
    Write-Host "Parameters:"
    Write-Host "  -Tool <Claude|OpenCode|All>   Choose which tool(s) to install"
    Write-Host "  -NoAliases                    Skip PowerShell alias setup"
    Write-Host "  -DryRun                       Preview without executing"
    Write-Host "  -Help                         Show this message"
    Write-Host ""
    Write-Host "Examples:"
    Write-Host "  .\setup.ps1                   Interactive mode"
    Write-Host "  .\setup.ps1 -Tool All         Install everything"
    Write-Host "  .\setup.ps1 -Tool Claude      Install Claude Code only"
    exit 0
}

function Confirm-Action {
    param([string]$Prompt, [bool]$Default = $true)
    $suffix = if ($Default) { "[Y/n]" } else { "[y/N]" }
    $response = Read-Host "$Prompt $suffix"
    if ([string]::IsNullOrWhiteSpace($response)) { return $Default }
    return $response -match '^[Yy]'
}

function Invoke-Checked {
    param([string]$Description, [scriptblock]$Command)
    if ($DryRun) {
        Write-Info "(dry-run) $Description"
    } else {
        Write-Info $Description
        & $Command
        if ($LASTEXITCODE -and $LASTEXITCODE -ne 0) {
            throw "Command failed with exit code $LASTEXITCODE"
        }
    }
}

# ---------------------------------------------------------------------------
# Node.js
# ---------------------------------------------------------------------------
function Test-NodeInstalled {
    Write-Step "Checking for Node.js"
    $node = Get-Command node -ErrorAction SilentlyContinue
    if ($null -eq $node) {
        Write-Caution "Node.js not found"
        return $false
    }

    $ver = & node --version 2>$null
    $major = [int]($ver -replace '^v(\d+)\..*', '$1')
    if ($major -ge 18) {
        Write-Ok "Node.js $ver found (meets minimum v18)"
        return $true
    } else {
        Write-Caution "Node.js $ver found but v18+ is required"
        return $false
    }
}

function Install-NodeJS {
    Write-Step "Installing Node.js"

    # Try winget first, then scoop, then manual
    $winget = Get-Command winget -ErrorAction SilentlyContinue
    $scoop  = Get-Command scoop  -ErrorAction SilentlyContinue

    if ($null -ne $winget) {
        Invoke-Checked "Installing Node.js LTS via winget" {
            winget install --id OpenJS.NodeJS.LTS --accept-source-agreements --accept-package-agreements
        }
        Write-Ok "Node.js installed via winget"
        Write-Caution "You may need to restart your terminal for 'node' to be available."
    } elseif ($null -ne $scoop) {
        Invoke-Checked "Installing Node.js LTS via scoop" {
            scoop install nodejs-lts
        }
        Write-Ok "Node.js installed via scoop"
    } else {
        Write-Err "Neither winget nor scoop found."
        Write-Err "Please install Node.js v18+ from https://nodejs.org/ and re-run this script."
        exit 1
    }

    # Refresh PATH
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" +
                [System.Environment]::GetEnvironmentVariable("Path", "User")
    $script:NodeInstalledByUs = $true
}

# ---------------------------------------------------------------------------
# Tool Selection
# ---------------------------------------------------------------------------
function Select-Tools {
    Write-Step "Tool Selection"
    Write-Host ""
    Write-Host "  Available tools:"
    Write-Host "    1) Claude Code  - Anthropic's CLI for Claude"
    Write-Host "    2) OpenCode     - Open-source AI coding assistant"
    Write-Host "    3) Both         - Install all tools"
    Write-Host ""
    $choice = Read-Host "  Select [1/2/3] (default: 3)"
    if ([string]::IsNullOrWhiteSpace($choice)) { $choice = "3" }

    switch ($choice) {
        "1" { $script:InstallClaude = $true }
        "2" { $script:InstallOpenCode = $true }
        "3" { $script:InstallClaude = $true; $script:InstallOpenCode = $true }
        default {
            Write-Caution "Invalid selection, installing both."
            $script:InstallClaude = $true
            $script:InstallOpenCode = $true
        }
    }
}

# ---------------------------------------------------------------------------
# Install Tools
# ---------------------------------------------------------------------------
function Install-DevTool {
    param([string]$Name, [string]$Command, [string]$Package)

    $existing = Get-Command $Command -ErrorAction SilentlyContinue
    if ($null -ne $existing) {
        $ver = & $Command --version 2>$null
        Write-Ok "$Name is already installed ($ver)"
        if (Confirm-Action "  Reinstall / upgrade $Name?" $false) {
            Invoke-Checked "Upgrading $Name" { npm install -g $Package }
            Write-Ok "$Name upgraded"
        }
    } else {
        Invoke-Checked "Installing $Name" { npm install -g $Package }
        Write-Ok "$Name installed"
    }
}

function Install-SelectedTools {
    Write-Step "Installing tools"

    if ($script:InstallClaude) {
        Install-DevTool -Name "Claude Code" -Command "claude" -Package "@anthropic-ai/claude-code"
    }
    if ($script:InstallOpenCode) {
        Install-DevTool -Name "OpenCode" -Command "opencode" -Package "opencode-ai"
    }
}

# ---------------------------------------------------------------------------
# Aliases
# ---------------------------------------------------------------------------
function Install-Aliases {
    if ($NoAliases) {
        Write-Info "Skipping alias installation (-NoAliases)"
        return
    }

    Write-Step "Installing PowerShell aliases"

    $profilePath = $PROFILE.CurrentUserCurrentHost
    $profileDir  = Split-Path $profilePath -Parent

    if (-not (Test-Path $profileDir)) {
        Write-Info "Creating profile directory: $profileDir"
        if (-not $DryRun) { New-Item -ItemType Directory -Path $profileDir -Force | Out-Null }
    }

    if (-not (Test-Path $profilePath)) {
        Write-Info "Creating PowerShell profile: $profilePath"
        if (-not $DryRun) { New-Item -ItemType File -Path $profilePath -Force | Out-Null }
    }

    # Build alias block
    $startMarker = "# --- AI Dev Toolkit Aliases ---"
    $endMarker   = "# --- End AI Dev Toolkit Aliases ---"

    $aliasLines = @($startMarker)
    if ($script:InstallClaude) {
        $aliasLines += 'Set-Alias -Name cc  -Value claude  -Scope Global'
        $aliasLines += 'function cch { claude --help }'
    }
    if ($script:InstallOpenCode) {
        $aliasLines += 'Set-Alias -Name oc  -Value opencode  -Scope Global'
        $aliasLines += 'function och { opencode --help }'
    }
    $aliasLines += $endMarker
    $aliasBlock = $aliasLines -join "`r`n"

    if (-not $DryRun) {
        $content = ""
        if (Test-Path $profilePath) {
            $content = Get-Content $profilePath -Raw -ErrorAction SilentlyContinue
            if ($null -eq $content) { $content = "" }
        }

        # Idempotent: remove old block
        if ($content -match [regex]::Escape($startMarker)) {
            Write-Info "Removing previous AI Dev Toolkit aliases from profile"
            $pattern = "(?s)$([regex]::Escape($startMarker)).*?$([regex]::Escape($endMarker))\r?\n?"
            $content = [regex]::Replace($content, $pattern, "")
        }

        $content = $content.TrimEnd() + "`r`n`r`n" + $aliasBlock + "`r`n"
        Set-Content -Path $profilePath -Value $content -Encoding UTF8
    }

    Write-Ok "Aliases installed in $profilePath"
    Write-Info "Run '. `$PROFILE' or open a new terminal to activate."
}

# ---------------------------------------------------------------------------
# Summary
# ---------------------------------------------------------------------------
function Show-Summary {
    Write-Step "Setup Complete"
    Write-Host ""
    Write-Host "  Installed tools:"
    if ($script:InstallClaude)   { Write-Host "    - Claude Code (claude)" }
    if ($script:InstallOpenCode) { Write-Host "    - OpenCode    (opencode)" }
    Write-Host ""
    if (-not $NoAliases) {
        Write-Host "  Aliases added to your PowerShell profile:"
        if ($script:InstallClaude)   { Write-Host "    cc  -> claude" }
        if ($script:InstallOpenCode) { Write-Host "    oc  -> opencode" }
        Write-Host ""
    }
    Write-Host "  Next steps:"
    Write-Host "    1. Open a new PowerShell window (or dot-source your profile)"
    Write-Host "    2. Run 'claude' or 'opencode' to get started"
    Write-Host "    3. See the docs/ folder for configuration guides"
    Write-Host ""
    Write-Ok "Happy coding!"
}

# ---------------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------------
function Main {
    Write-Host ""
    Write-Host "  =====================================" -ForegroundColor Cyan
    Write-Host "   AI Dev Toolkit Setup v$script:Version" -ForegroundColor Cyan
    Write-Host "  =====================================" -ForegroundColor Cyan
    Write-Host ""

    if ($Help) { Show-Help }
    if ($DryRun) { Write-Caution "Dry-run mode enabled" }

    # Node.js
    if (-not (Test-NodeInstalled)) {
        if (Confirm-Action "Install Node.js LTS now?") {
            Install-NodeJS
        } else {
            Write-Err "Node.js v18+ is required. Aborting."
            exit 1
        }
    }

    # Tool selection
    if ([string]::IsNullOrWhiteSpace($Tool)) {
        Select-Tools
    } else {
        switch ($Tool) {
            "Claude"   { $script:InstallClaude = $true }
            "OpenCode" { $script:InstallOpenCode = $true }
            "All"      { $script:InstallClaude = $true; $script:InstallOpenCode = $true }
        }
    }

    if (-not $script:InstallClaude -and -not $script:InstallOpenCode) {
        Write-Caution "No tools selected. Nothing to install."
        exit 0
    }

    Install-SelectedTools
    Install-Aliases
    Show-Summary
}

Main
