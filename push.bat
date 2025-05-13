@echo off
echo Adding all changes...
git add .

echo.
echo Committing changes...
git commit -m "Update project files"

echo.
echo Pulling latest changes...
git pull origin main

echo.
echo Pushing to GitHub...
git push origin main

echo.
echo Done! Press any key to exit...
pause > nul 