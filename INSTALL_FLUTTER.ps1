# Flutter Installation Helper Script
# This script will guide you through installing Flutter

Write-Host "======================================" -ForegroundColor Cyan
Write-Host "  Flutter Installation Helper" -ForegroundColor Cyan
Write-Host "======================================" -ForegroundColor Cyan
Write-Host ""

# Step 1: Download Flutter
Write-Host "STEP 1: Download Flutter SDK" -ForegroundColor Yellow
Write-Host ""
Write-Host "The download page is already open in your browser." -ForegroundColor White
Write-Host "On that page:" -ForegroundColor White
Write-Host "  1. Click the blue 'Download and install' button" -ForegroundColor Cyan
Write-Host "  2. The file 'flutter_windows_X.X.X-stable.zip' will download" -ForegroundColor Cyan
Write-Host ""
$downloaded = Read-Host "Have you downloaded the ZIP file? (yes/no)"

if ($downloaded -ne "yes" -and $downloaded -ne "y") {
    Write-Host ""
    Write-Host "Please download the Flutter SDK and run this script again." -ForegroundColor Yellow
    exit
}

# Step 2: Extract Flutter
Write-Host ""
Write-Host "STEP 2: Extract Flutter" -ForegroundColor Yellow
Write-Host ""
Write-Host "Please extract the ZIP file to: C:\src\flutter" -ForegroundColor Cyan
Write-Host ""
Write-Host "Instructions:" -ForegroundColor White
Write-Host "  1. Right-click the downloaded ZIP file" -ForegroundColor White
Write-Host "  2. Choose 'Extract All...'" -ForegroundColor White
Write-Host "  3. Change destination to: C:\src\" -ForegroundColor White
Write-Host "  4. Click 'Extract'" -ForegroundColor White
Write-Host ""
Write-Host "This will create: C:\src\flutter\" -ForegroundColor Green
Write-Host ""
$extracted = Read-Host "Have you extracted Flutter to C:\src\flutter? (yes/no)"

if ($extracted -ne "yes" -and $extracted -ne "y") {
    Write-Host ""
    Write-Host "Please extract Flutter to C:\src\flutter and run this script again." -ForegroundColor Yellow
    exit
}

# Step 3: Add Flutter to PATH
Write-Host ""
Write-Host "STEP 3: Add Flutter to PATH" -ForegroundColor Yellow
Write-Host ""
Write-Host "Adding Flutter to your system PATH..." -ForegroundColor White

$flutterPath = "C:\src\flutter\bin"
$currentPath = [Environment]::GetEnvironmentVariable("Path", "Machine")

if ($currentPath -notlike "*$flutterPath*") {
    try {
        Write-Host "Adding Flutter to PATH... (requires administrator)" -ForegroundColor Yellow
        $newPath = "$currentPath;$flutterPath"
        [Environment]::SetEnvironmentVariable("Path", $newPath, "Machine")
        $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
        Write-Host "✓ Flutter added to PATH successfully!" -ForegroundColor Green
    } catch {
        Write-Host "⚠ Could not add to PATH automatically (need admin rights)" -ForegroundColor Red
        Write-Host ""
        Write-Host "Please add manually:" -ForegroundColor Yellow
        Write-Host "  1. Open System Properties (Win + Pause)" -ForegroundColor White
        Write-Host "  2. Click 'Environment Variables'" -ForegroundColor White
        Write-Host "  3. Edit 'Path' under System variables" -ForegroundColor White
        Write-Host "  4. Add: C:\src\flutter\bin" -ForegroundColor White
        Write-Host ""
        Read-Host "Press Enter after adding Flutter to PATH manually"
    }
} else {
    Write-Host "✓ Flutter is already in PATH!" -ForegroundColor Green
}

# Refresh PATH in current session
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")

# Step 4: Verify Flutter Installation
Write-Host ""
Write-Host "STEP 4: Verify Flutter Installation" -ForegroundColor Yellow
Write-Host ""
Write-Host "Checking Flutter installation..." -ForegroundColor White

try {
    $flutterVersion = flutter --version 2>&1
    Write-Host "✓ Flutter installed successfully!" -ForegroundColor Green
    Write-Host ""
    Write-Host $flutterVersion
} catch {
    Write-Host "✗ Flutter not found in PATH" -ForegroundColor Red
    Write-Host ""
    Write-Host "Please:" -ForegroundColor Yellow
    Write-Host "  1. Close this PowerShell window" -ForegroundColor White
    Write-Host "  2. Open a NEW PowerShell window" -ForegroundColor White
    Write-Host "  3. Run: flutter --version" -ForegroundColor White
    Write-Host ""
    exit
}

# Step 5: Run Flutter Doctor
Write-Host ""
Write-Host "STEP 5: Flutter Doctor Check" -ForegroundColor Yellow
Write-Host ""
Write-Host "Running flutter doctor to check your setup..." -ForegroundColor White
Write-Host ""

flutter doctor

Write-Host ""
Write-Host "======================================" -ForegroundColor Green
Write-Host "  Flutter Installation Complete!" -ForegroundColor Green
Write-Host "======================================" -ForegroundColor Green
Write-Host ""

# Step 6: Set up for Windows Desktop
Write-Host "STEP 6: Enable Windows Desktop (Easiest for Testing)" -ForegroundColor Yellow
Write-Host ""
Write-Host "Enabling Windows desktop support..." -ForegroundColor White

flutter config --enable-windows-desktop

Write-Host "✓ Windows desktop enabled!" -ForegroundColor Green
Write-Host ""

# Step 7: Install Dependencies
Write-Host "STEP 7: Install Project Dependencies" -ForegroundColor Yellow
Write-Host ""
Write-Host "Installing Crisis Mesh Messenger dependencies..." -ForegroundColor White
Write-Host ""

Set-Location "c:\Users\Hipek\OneDrive\Pulpit\New Network\CascadeProjects\windsurf-project\crisis_mesh"

flutter pub get

Write-Host ""
Write-Host "✓ Dependencies installed!" -ForegroundColor Green
Write-Host ""

# Step 8: Ready to Run
Write-Host "======================================" -ForegroundColor Cyan
Write-Host "  READY TO RUN YOUR APP!" -ForegroundColor Cyan
Write-Host "======================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "To run Crisis Mesh Messenger:" -ForegroundColor Yellow
Write-Host ""
Write-Host "  flutter run -d windows" -ForegroundColor Cyan
Write-Host ""
Write-Host "Or run this command now?" -ForegroundColor Yellow
$runNow = Read-Host "(yes/no)"

if ($runNow -eq "yes" -or $runNow -eq "y") {
    Write-Host ""
    Write-Host "Starting Crisis Mesh Messenger..." -ForegroundColor Green
    Write-Host ""
    Write-Host "===============================================" -ForegroundColor Cyan
    Write-Host "  App Controls:" -ForegroundColor Cyan
    Write-Host "  Press 'r' - Hot reload" -ForegroundColor White
    Write-Host "  Press 'R' - Hot restart" -ForegroundColor White
    Write-Host "  Press 'q' - Quit" -ForegroundColor White
    Write-Host "===============================================" -ForegroundColor Cyan
    Write-Host ""
    
    flutter run -d windows
} else {
    Write-Host ""
    Write-Host "You can run the app anytime with:" -ForegroundColor Yellow
    Write-Host "  cd ""c:\Users\Hipek\OneDrive\Pulpit\New Network\CascadeProjects\windsurf-project\crisis_mesh""" -ForegroundColor Cyan
    Write-Host "  flutter run -d windows" -ForegroundColor Cyan
    Write-Host ""
}

Write-Host ""
Write-Host "Happy coding!" -ForegroundColor Green
Write-Host ""
