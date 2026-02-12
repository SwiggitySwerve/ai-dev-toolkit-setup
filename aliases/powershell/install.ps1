# AI Dev Toolkit - PowerShell Alias Installer
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$ProfilePath = $PROFILE.CurrentUserCurrentHost
$AliasFiles = @("claude-code.ps1", "opencode.ps1", "shared.ps1")

Write-Host "AI Dev Toolkit - PowerShell Alias Installer" -ForegroundColor Cyan
Write-Host "=============================================" -ForegroundColor Cyan
Write-Host "Profile: $ProfilePath"
Write-Host ""

# Create profile if it doesn't exist
if (-not (Test-Path $ProfilePath)) {
    New-Item -ItemType File -Path $ProfilePath -Force | Out-Null
    Write-Host "Created PowerShell profile at $ProfilePath"
}

foreach ($file in $AliasFiles) {
    $sourceLine = ". `"$ScriptDir\$file`""
    $profileContent = Get-Content $ProfilePath -Raw -ErrorAction SilentlyContinue

    if ($profileContent -and $profileContent.Contains($sourceLine)) {
        Write-Host "Already installed: $file" -ForegroundColor Yellow
    } else {
        Add-Content -Path $ProfilePath -Value "`n# AI Dev Toolkit - $file"
        Add-Content -Path $ProfilePath -Value $sourceLine
        Write-Host "Installed: $file -> $ProfilePath" -ForegroundColor Green
    }
}

Write-Host ""
Write-Host "Done! Run '. `$PROFILE' or restart PowerShell to activate." -ForegroundColor Green
