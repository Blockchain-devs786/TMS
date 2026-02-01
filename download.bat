@echo off
echo ========================================
echo Downloading 'update' folder from GitHub
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

REM Create temporary directory for cloning
set TEMP_REPO=%TEMP%\TMS_temp_%RANDOM%
echo Creating temporary directory: %TEMP_REPO%

REM Clone the repository to temp location
echo Cloning repository...
git clone https://github.com/Blockchain-devs786/TMS.git %TEMP_REPO%
if %ERRORLEVEL% NEQ 0 (
    echo ERROR: Failed to clone repository
    echo This might be due to:
    echo 1. Authentication issues
    echo 2. Network issues
    echo 3. Repository access permissions
    pause
    exit /b 1
)

REM Check if 'update' folder exists in cloned repository
if not exist "%TEMP_REPO%\update" (
    echo WARNING: 'update' folder not found in repository
    echo The repository may be empty or the folder doesn't exist yet.
    rmdir /s /q "%TEMP_REPO%" 2>nul
    pause
    exit /b 1
)

REM Copy the 'update' folder to current directory
echo.
echo Copying 'update' folder to current directory...
if exist "update" (
    echo Existing 'update' folder found. Replacing it...
    rmdir /s /q "update" 2>nul
)
xcopy "%TEMP_REPO%\update" "update\" /E /I /Y >nul
if %ERRORLEVEL% NEQ 0 (
    echo ERROR: Failed to copy 'update' folder
    rmdir /s /q "%TEMP_REPO%" 2>nul
    pause
    exit /b 1
)

REM Clean up temporary directory
echo Cleaning up temporary files...
rmdir /s /q "%TEMP_REPO%" 2>nul

echo.
echo ========================================
echo 'update' folder downloaded successfully!
echo ========================================
pause
