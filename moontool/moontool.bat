@echo off
set "SCRIPT_DIR=%~dp0"
where git.exe >nul 2>&1
if %errorlevel% equ 0 (
    for /f "tokens=*" %%i in ('where git.exe') do (
        set "GIT_PATH=%%i"
        goto :found
    )
)
:found
for %%i in ("%GIT_PATH%") do set "GIT_DIR=%%~dpi"
set "BASH_PATH=%GIT_DIR%bash.exe"
if exist "%BASH_PATH%" (
    "%BASH_PATH%" "%SCRIPT_DIR%moontool.sh" %*
    goto :end
)
set "BASH_PATH=%GIT_DIR%..\bin\bash.exe"
if exist "%BASH_PATH%" (
    "%BASH_PATH%" "%SCRIPT_DIR%moontool.sh" %*
    goto :end
)
echo Error: Could not find bash.exe in Git installation.
exit /b 1
:end