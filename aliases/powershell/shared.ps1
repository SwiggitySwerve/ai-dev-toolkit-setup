# Shared AI Workflow Aliases for PowerShell

# Set default projects directory
if (-not $env:AI_PROJECTS_DIR) {
    $env:AI_PROJECTS_DIR = Join-Path $HOME "Projects"
}

function aidir { Set-Location $env:AI_PROJECTS_DIR }
function gp { git push @args }

function gac {
    param([Parameter(Mandatory=$true, Position=0)][string]$Message)
    git add -A
    if ($LASTEXITCODE -eq 0) { git commit -m $Message }
}

function gacp {
    param([Parameter(Mandatory=$true, Position=0)][string]$Message)
    git add -A
    if ($LASTEXITCODE -eq 0) { git commit -m $Message }
    if ($LASTEXITCODE -eq 0) { git push }
}

function newai {
    param([Parameter(Mandatory=$true, Position=0)][string]$Name)
    $projectPath = Join-Path $env:AI_PROJECTS_DIR $Name
    New-Item -ItemType Directory -Path $projectPath -Force | Out-Null
    Set-Location $projectPath
    git init
    "# $Name" | Out-File -FilePath "README.md" -Encoding utf8
    Write-Host "Created new project: $Name"
}
