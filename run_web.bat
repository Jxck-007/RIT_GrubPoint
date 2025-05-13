@echo off
echo Setting up environment...

:: Add Git to PATH
set PATH=%PATH%;C:\Program Files\Git\bin

:: Add Flutter to PATH
set PATH=%PATH%;C:\dev\flutter\bin

echo Running RIT GrubPoint in Chrome...
flutter run -d chrome

echo.
echo Press any key to exit...
pause > nul 