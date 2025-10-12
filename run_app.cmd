@echo off
echo Crisis Mesh Messenger - Starting...
echo.

set PATH=C:\Program Files\Git\cmd;C:\flutter\bin;%PATH%

echo Step 1: Enabling Windows desktop...
call flutter config --enable-windows-desktop

echo.
echo Step 2: Getting dependencies...
call flutter pub get

echo.
echo Step 3: Launching app...
echo.
echo ========================================
echo   App Controls:
echo   Press 'r' - Hot reload
echo   Press 'R' - Hot restart  
echo   Press 'q' - Quit
echo ========================================
echo.

call flutter run -d windows
