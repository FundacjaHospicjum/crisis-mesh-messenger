# Flutter App Runner - Sets PATH and runs the app

Write-Host "Crisis Mesh Messenger - Starting..." -ForegroundColor Cyan
Write-Host ""

# Set PATH for this session
$env:Path = "C:\Program Files\Git\cmd;C:\flutter\bin;$env:Path"

Write-Host "Step 1: Enabling Windows desktop support..." -ForegroundColor Yellow
flutter config --enable-windows-desktop

Write-Host ""
Write-Host "Step 2: Getting dependencies..." -ForegroundColor Yellow
flutter pub get

Write-Host ""
Write-Host "Step 3: Launching app..." -ForegroundColor Yellow
Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  App Controls:" -ForegroundColor Cyan
Write-Host "  Press 'r' - Hot reload" -ForegroundColor White
Write-Host "  Press 'R' - Hot restart" -ForegroundColor White
Write-Host "  Press 'q' - Quit app" -ForegroundColor White
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

flutter run -d windows
