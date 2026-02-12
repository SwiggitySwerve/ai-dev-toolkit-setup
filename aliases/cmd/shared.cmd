@echo off
REM Shared AI Workflow Aliases for Windows CMD

IF "%AI_PROJECTS_DIR%"=="" SET AI_PROJECTS_DIR=%USERPROFILE%\Projects

DOSKEY aidir=cd /d "%AI_PROJECTS_DIR%"
DOSKEY gp=git push $*
DOSKEY gac=git add -A $T git commit -m $*
DOSKEY gacp=git add -A $T git commit -m $1 $T git push
