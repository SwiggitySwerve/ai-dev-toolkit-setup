# OpenCode Aliases for PowerShell

Set-Alias -Name oc -Value opencode
function ocv { opencode --version }
function ochelp { opencode --help }

# Update - try scoop first, fall back to go
function ocup {
    if (Get-Command scoop -ErrorAction SilentlyContinue) {
        scoop update opencode
    } elseif (Get-Command go -ErrorAction SilentlyContinue) {
        go install github.com/opencode-ai/opencode@latest
    } else {
        Write-Host "No supported package manager found. Install via scoop or go."
    }
}
