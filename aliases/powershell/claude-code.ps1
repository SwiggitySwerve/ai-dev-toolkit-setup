# Claude Code Aliases for PowerShell
# Add to your $PROFILE or source with . .\claude-code.ps1

# Core aliases
Set-Alias -Name cc -Value claude
function ccc { claude --continue @args }
function ccr { claude --resume @args }
function ccp { claude --print @args }
function ccd { claude doctor @args }
function ccv { claude --version }
function ccmod { claude --model @args }
function cchelp { claude --help }
function ccup { npm update -g @anthropic-ai/claude-code }

# Functions
function ccask {
    param([Parameter(Mandatory=$true, Position=0, ValueFromRemainingArguments=$true)][string[]]$Question)
    claude --print ($Question -join ' ')
}

function ccfix {
    $lastCmd = (Get-History -Count 1).CommandLine
    try {
        $output = Invoke-Expression $lastCmd 2>&1 | Out-String
    } catch {
        $output = $_.Exception.Message
    }
    $output | claude --print "The command '$lastCmd' produced this output/error. Help me fix it:"
}

function ccpr {
    $diff = git diff | Out-String
    $diff | claude --print "Review this git diff for potential issues, bugs, and improvements:"
}

function ccinit {
    if (Test-Path "CLAUDE.md") {
        Write-Host "CLAUDE.md already exists in this directory."
        return
    }
    @"
# Project Instructions for Claude Code

## Project Overview
<!-- Describe your project here -->

## Key Conventions
<!-- List coding conventions, preferred patterns, etc. -->

## Important Files
<!-- List key files Claude should be aware of -->
"@ | Out-File -FilePath "CLAUDE.md" -Encoding utf8
    Write-Host "Created CLAUDE.md - customize it for your project!"
}
