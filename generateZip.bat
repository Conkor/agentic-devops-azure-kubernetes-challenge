@echo off
setlocal

for %%i in ("%CD%") do set "CURRENT_DIR_NAME=%%~nxi"
set "FILE_NAME=%CURRENT_DIR_NAME%.zip"

echo Creating %FILE_NAME% from tracked files...
git archive --format=zip --output="%FILE_NAME%" HEAD
if errorlevel 1 exit /b 1

echo Packaging complete: %CD%\%FILE_NAME%
exit /b 0
