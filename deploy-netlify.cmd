@echo off
echo ===================================================
echo   SudokuForge Netlify Deployer (One-Click Build)
echo ===================================================
echo.

REM Verify node modules
if not exist node_modules (
    echo [ERROR] node_modules folder not found!
    echo Please run "npm install" first.
    pause
    exit /b 1
)

REM Run build
echo [1/3] Building the production bundle...
call npm.cmd run build
if %ERRORLEVEL% neq 0 (
    echo [ERROR] Production compilation failed!
    pause
    exit /b %ERRORLEVEL%
)

REM Ask for Netlify Auth Token if not set
if "%NETLIFY_AUTH_TOKEN%"=="" (
    set /p NETLIFY_AUTH_TOKEN="Enter your Netlify Auth Token (or press Enter if CLI is already logged in): "
)

REM Run deploy
echo [2/3] Deploying build output directory to Netlify...
if "%NETLIFY_AUTH_TOKEN%"=="" (
    npx.cmd -y netlify deploy --prod
) else (
    set NETLIFY_AUTH_TOKEN=%NETLIFY_AUTH_TOKEN%
    npx.cmd -y netlify deploy --prod
)

if %ERRORLEVEL% neq 0 (
    echo [ERROR] Deployment failed!
    pause
    exit /b %ERRORLEVEL%
)

echo [3/3] Deployment complete!
echo Live Site URL: https://sudokuforge.netlify.app
echo.
pause
