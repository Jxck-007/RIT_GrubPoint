@echo off
echo Setting up environment...

:: Add Git to PATH
set PATH=%PATH%;C:\Program Files\Git\bin

:: Add Flutter to PATH
set PATH=%PATH%;C:\dev\flutter\bin

:menu
cls
echo RIT GrubPoint - Choose Platform
echo =============================
echo.
echo 1. Run on Android
echo 2. Run in Chrome (Web)
echo 3. Exit
echo.
set /p choice="Enter your choice (1-3): "

if "%choice%"=="1" goto android
if "%choice%"=="2" goto web
if "%choice%"=="3" goto end
goto menu

:android
echo.
echo Running RIT GrubPoint on Android...
flutter run -d android
goto end

:web
echo.
echo Running RIT GrubPoint in Chrome...
flutter run -d chrome
goto end

:end
echo.
echo Press any key to exit...
pause > nul 