# Run this script AS ADMINISTRATOR to fix PATH

Write-Host "Adding Flutter and Git to System PATH..." -ForegroundColor Cyan

$machinePath = [Environment]::GetEnvironmentVariable("Path", "Machine")
$gitPath = "C:\Program Files\Git\cmd"
$flutterPath = "C:\flutter\bin"

# Add if not already present
if ($machinePath -notlike "*$gitPath*") {
    $machinePath += ";$gitPath"
}
if ($machinePath -notlike "*$flutterPath*") {
    $machinePath += ";$flutterPath"
}

[Environment]::SetEnvironmentVariable("Path", $machinePath, "Machine")

Write-Host "PATH updated successfully!" -ForegroundColor Green
Write-Host ""
Write-Host "Close this window and open a NEW PowerShell" -ForegroundColor Yellow
Write-Host "Then run:" -ForegroundColor Yellow
Write-Host "  cd 'c:\Users\Hipek\OneDrive\Pulpit\New Network\CascadeProjects\windsurf-project\crisis_mesh'" -ForegroundColor Cyan
Write-Host "  flutter pub get" -ForegroundColor Cyan
Write-Host "  flutter run -d windows" -ForegroundColor Cyan
