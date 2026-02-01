@echo off
echo ========================================
echo Downloading files from GitHub repository
echo ========================================
echo.

REM Check if git is installed
where git >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo ERROR: Git is not installed or not in PATH
    echo Please install Git and try again.
    pause
    exit /b 1
)

REM Check if .git folder exists (repository already initialized)
if exist ".git" (
    echo Git repository detected. Pulling latest changes...
    echo.
    
    REM Check if remote origin exists
    git remote get-url origin >nul 2>&1
    if %ERRORLEVEL% NEQ 0 (
        echo Adding remote origin...
        git remote add origin https://github.com/Blockchain-devs786/TMS.git
        if %ERRORLEVEL% NEQ 0 (
            echo ERROR: Failed to add remote origin
            pause
            exit /b 1
        )
    )
    
    REM Set branch to main
    git branch -M main
    
    REM Pull latest changes
    echo Pulling latest changes from GitHub...
    git pull origin main
    if %ERRORLEVEL% NEQ 0 (
        echo.
        echo WARNING: Failed to pull from GitHub
        echo This might be due to:
        echo 1. Authentication issues
        echo 2. Merge conflicts
        echo 3. Network issues
        echo.
        echo Attempting to fetch instead...
        git fetch origin main
        if %ERRORLEVEL% NEQ 0 (
            echo ERROR: Failed to fetch from GitHub
            pause
            exit /b 1
        )
    )
) else (
    echo No git repository found. Cloning repository...
    echo.
    
    REM Clone the repository
    git clone https://github.com/Blockchain-devs786/TMS.git .
    if %ERRORLEVEL% NEQ 0 (
        echo ERROR: Failed to clone repository
        echo This might be due to:
        echo 1. Authentication issues
        echo 2. Network issues
        echo 3. Repository access permissions
        pause
        exit /b 1
    )
    
    REM Set branch to main
    git branch -M main
)

echo.
echo ========================================
echo Download completed successfully!
echo ========================================
pause
