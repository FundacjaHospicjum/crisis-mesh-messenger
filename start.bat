@echo off
setlocal

echo Setting up environment...
set "PATH=C:\Program Files\Git\cmd;C:\Program Files\Git\bin;C:\flutter\bin;%PATH%"
set "GIT_HOME=C:\Program Files\Git"

echo Checking Git...
git --version
if errorlevel 1 (
    echo ERROR: Git not found!
    pause
    exit /b 1
)

echo Checking Flutter...
flutter --version
if errorlevel 1 (
    echo ERROR: Flutter not found!
    pause
    exit /b 1
)

echo.
echo Enabling Windows desktop...
flutter config --enable-windows-desktop

echo.
echo Getting dependencies...
flutter pub get

echo.
echo Starting app...
echo ========================================
echo   Controls:
echo   r  = Hot reload
echo   R  = Hot restart  
echo   q  = Quit
echo ========================================
echo.

flutter run -d windows

pause
