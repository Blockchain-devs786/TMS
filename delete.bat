@echo off
setlocal enabledelayedexpansion
echo ========================================
echo Deleting all files from GitHub repository
echo ========================================
echo.
echo WARNING: This will delete ALL files and folders from the repository!
echo Note: This will NOT delete your local files, only from GitHub.
echo.
set /p CONFIRM="Are you sure you want to continue? (y/yes/n/no): "
if /i "!CONFIRM!"=="y" goto :confirm
if /i "!CONFIRM!"=="yes" goto :confirm
echo Operation cancelled.
pause
exit /b 0
:confirm

REM Check if git is installed
where git >nul 2>&1
if !ERRORLEVEL! NEQ 0 (
    echo ERROR: Git is not installed or not in PATH
    echo Please install Git and try again.
    pause
    exit /b 1
)

REM Check if .git folder exists
if not exist ".git" (
    echo ERROR: Not a git repository!
    echo Please run this script in a directory that is a git repository.
    pause
    exit /b 1
)

REM Check if remote origin exists
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
    echo Remote origin found
)

REM Set branch to main
echo Setting branch to main...
git branch -M main >nul 2>&1

REM Configure Git user email and name
echo.
echo Configuring Git user settings...
git config user.email "malikazan8768@gmail.com"
git config user.name "Blockchain Devs"

REM Remove all files from git tracking (but keep local files)
echo.
echo Removing all files from repository...
git rm -r --cached . >nul 2>&1
if !ERRORLEVEL! NEQ 0 (
    echo WARNING: Some files may not be tracked, continuing...
)

REM Add all deletions to git
echo Adding deletions to git...
git add -A
if !ERRORLEVEL! NEQ 0 (
    echo ERROR: Failed to add deletions
    pause
    exit /b 1
)

REM Check if there are changes to commit
git diff --cached --quiet >nul 2>&1
if !ERRORLEVEL! EQU 0 (
    echo No changes to commit. Repository is already empty.
    goto :push
)

REM Commit the deletion
echo.
echo Committing deletion...
git commit -m "Delete all files from repository: %date% %time%"
if !ERRORLEVEL! NEQ 0 (
    echo ERROR: Failed to commit deletion
    pause
    exit /b 1
)

:push

REM Push to remote
echo.
echo Pushing deletion to GitHub...
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
echo All files deleted from repository successfully!
echo Local files are preserved.
echo ========================================
pause
