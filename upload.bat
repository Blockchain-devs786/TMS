@echo off
setlocal enabledelayedexpansion
echo ========================================
echo Uploading 'update' folder to GitHub
echo ========================================
echo.

REM Check if git is installed
where git >nul 2>&1
if !ERRORLEVEL! NEQ 0 (
    echo ERROR: Git is not installed or not in PATH
    echo Please install Git and try again.
    pause
    exit /b 1
)

REM Initialize git repository if not already initialized
if not exist ".git" (
    echo Initializing git repository...
    git init
    if !ERRORLEVEL! NEQ 0 (
        echo ERROR: Failed to initialize git repository
        pause
        exit /b 1
    )
)

REM Check if remote origin exists, if not add it
git remote get-url origin >nul 2>&1
if !ERRORLEVEL! NEQ 0 (
    echo Adding remote origin...
    git remote add origin https://github.com/Blockchain-devs786/TMS.git
    if !ERRORLEVEL! NEQ 0 (
        echo ERROR: Failed to add remote origin
        pause
        exit /b 1
    )
) else (
    echo Remote origin already exists
)

REM Set branch to main
echo Setting branch to main...
git branch -M main >nul 2>&1
if !ERRORLEVEL! NEQ 0 (
    echo WARNING: Failed to set branch to main, continuing...
)

REM Configure Git user email and name
echo.
echo Configuring Git user settings...
git config user.email "malikazan8768@gmail.com"
git config user.name "Blockchain Devs"
if !ERRORLEVEL! NEQ 0 (
    echo WARNING: Failed to configure Git user settings, continuing...
)

REM Check if 'update' folder exists
if not exist "update" (
    echo ERROR: 'update' folder not found!
    echo Please make sure the 'update' folder exists in the current directory.
    pause
    exit /b 1
)

REM Add only the 'update' folder
echo.
echo Adding 'update' folder...
git add update/
if !ERRORLEVEL! NEQ 0 (
    echo ERROR: Failed to add 'update' folder
    pause
    exit /b 1
)

REM Check if there are changes to commit
git diff --cached --quiet >nul 2>&1
if !ERRORLEVEL! EQU 0 (
    echo No changes to commit.
    goto :push
)

REM Commit changes
echo.
echo Committing changes...
git commit -m "Auto-upload: %date% %time%"
if !ERRORLEVEL! NEQ 0 (
    echo ERROR: Failed to commit changes
    pause
    exit /b 1
)

:push

REM Push to remote
echo.
echo Pushing to GitHub...
git push -u origin main
if !ERRORLEVEL! NEQ 0 (
    echo.
    echo ERROR: Failed to push to GitHub
    echo This might be due to authentication issues.
    echo Please make sure you have:
    echo 1. Configured your Git credentials
    echo 2. Have push access to the repository
    echo 3. Set up authentication (SSH key or Personal Access Token)
    pause
    exit /b 1
)

echo.
echo ========================================
echo 'update' folder uploaded successfully!
echo ========================================
pause
