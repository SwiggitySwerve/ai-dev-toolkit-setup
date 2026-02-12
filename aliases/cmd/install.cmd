@echo off
REM AI Dev Toolkit - CMD Alias Installer
REM Adds alias files to CMD AutoRun via registry

echo AI Dev Toolkit - CMD Alias Installer
echo =====================================
echo.

SET SCRIPT_DIR=%~dp0
SET AUTORUN_KEY=HKCU\Software\Microsoft\Command Processor

REM Create a combined loader script
SET LOADER=%SCRIPT_DIR%ai-toolkit-autorun.cmd
echo @echo off > "%LOADER%"
echo REM AI Dev Toolkit - Auto-loaded aliases >> "%LOADER%"
echo call "%SCRIPT_DIR%claude-code.cmd" >> "%LOADER%"
echo call "%SCRIPT_DIR%opencode.cmd" >> "%LOADER%"
echo call "%SCRIPT_DIR%shared.cmd" >> "%LOADER%"

REM Check existing AutoRun
FOR /F "tokens=2*" %%A IN ('REG QUERY "%AUTORUN_KEY%" /v AutoRun 2^>nul') DO SET CURRENT_AUTORUN=%%B

IF DEFINED CURRENT_AUTORUN (
    echo Existing AutoRun found: %CURRENT_AUTORUN%
    echo Adding AI toolkit loader alongside existing AutoRun...
    REG ADD "%AUTORUN_KEY%" /v AutoRun /t REG_SZ /d "%CURRENT_AUTORUN% & \"%LOADER%\"" /f >nul
) ELSE (
    REG ADD "%AUTORUN_KEY%" /v AutoRun /t REG_SZ /d "\"%LOADER%\"" /f >nul
)

echo.
echo Done! Aliases will load automatically in new CMD windows.
echo Restart CMD to activate.
