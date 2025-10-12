@echo off
echo Crisis Mesh Messenger - Starting...
echo.

REM Set complete PATH with System32 and PowerShell
set "PATH=C:\Windows\System32;C:\Windows;C:\Windows\System32\WindowsPowerShell\v1.0;C:\Program Files\Git\cmd;C:\flutter\bin\mingit\cmd;C:\flutter\bin;%PATH%"

echo Checking environment...
where git
if errorlevel 1 (
    echo ERROR: Git not found
    pause
    exit /b 1
)

echo Git found!
echo.

echo Step 1: Enabling Windows desktop...
flutter config --enable-windows-desktop

echo.
echo Step 2: Getting dependencies...
flutter pub get

echo.
echo Step 3: Starting app...
flutter run -d windows

pause
