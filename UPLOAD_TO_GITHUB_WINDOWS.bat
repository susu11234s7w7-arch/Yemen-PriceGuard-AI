@echo off
setlocal
cd /d "%~dp0"
echo Yemen PriceGuard AI - GitHub upload helper
echo -----------------------------------------
where git >nul 2>nul
if errorlevel 1 (
  echo ERROR: Git is not installed or not available in PATH.
  echo Install Git for Windows, then run this file again.
  pause
  exit /b 1
)
set /p REPO_URL=Paste the HTTPS URL of your EMPTY GitHub repository: 
if "%REPO_URL%"=="" (
  echo ERROR: No repository URL was provided.
  pause
  exit /b 1
)
if not exist ".git" git init -b main
if errorlevel 1 goto fail
git add .
if errorlevel 1 goto fail
git commit -m "Initial commit: Yemen PriceGuard AI"
if errorlevel 1 (
  echo Note: Commit may already exist or there may be no changes. Continuing to push.
)
git branch -M main
git remote get-url origin >nul 2>nul
if errorlevel 1 (
  git remote add origin "%REPO_URL%"
) else (
  git remote set-url origin "%REPO_URL%"
)
if errorlevel 1 goto fail
git push -u origin main
if errorlevel 1 goto fail
echo.
echo SUCCESS: Push command completed. Open your GitHub repository to verify files.
pause
exit /b 0
:fail
echo.
echo Upload failed. Check your GitHub sign-in, repository URL, and whether the repo was created empty.
pause
exit /b 1
