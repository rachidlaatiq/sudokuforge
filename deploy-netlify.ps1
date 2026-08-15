Write-Host "===================================================" -ForegroundColor Cyan
Write-Host "  SudokuForge Netlify Deployer (One-Click Build)" -ForegroundColor Cyan
Write-Host "===================================================" -ForegroundColor Cyan
Write-Host ""

# Verify node modules
if (-not (Test-Path "node_modules")) {
    Write-Host "[ERROR] node_modules folder not found! Please run 'npm install' first." -ForegroundColor Red
    pause
    exit 1
}

# Run build
Write-Host "[1/3] Building the production bundle..." -ForegroundColor Yellow
npm.cmd run build
if ($LASTEXITCODE -ne 0) {
    Write-Host "[ERROR] Production compilation failed!" -ForegroundColor Red
    pause
    exit $LASTEXITCODE
}

# Check Auth Token
if (-not $env:NETLIFY_AUTH_TOKEN) {
    $token = Read-Host "Enter your Netlify Auth Token (or press Enter if CLI is already logged in)"
    if ($token) {
        $env:NETLIFY_AUTH_TOKEN = $token
    }
}

# Run deploy
Write-Host "[2/3] Deploying build output directory to Netlify..." -ForegroundColor Yellow
npx.cmd -y netlify deploy --prod
if ($LASTEXITCODE -ne 0) {
    Write-Host "[ERROR] Deployment failed!" -ForegroundColor Red
    pause
    exit $LASTEXITCODE
}

Write-Host "[3/3] Deployment complete!" -ForegroundColor Green
Write-Host "Live Site URL: https://sudokuforge.netlify.app" -ForegroundColor Green
Write-Host ""
pause
