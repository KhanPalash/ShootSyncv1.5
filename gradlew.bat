@echo off
setlocal
set "GRADLE_VERSION=7.4.2"
set "GRADLE_DIR=%USERPROFILE%\.gradle\wrapper\dists\gradle-%GRADLE_VERSION%"
if exist "%GRADLE_DIR%\bin\gradle.bat" (
  "%GRADLE_DIR%\bin\gradle.bat" %*
  exit /b %errorlevel%
)
powershell -NoProfile -Command "
$zip = Join-Path $env:TEMP 'gradle.zip';
Invoke-WebRequest -Uri 'https://services.gradle.org/distributions/gradle-7.4.2-bin.zip' -OutFile $zip -UseBasicParsing;
$dest = Join-Path $env:TEMP 'gradle_extract';
if (Test-Path $dest) { Remove-Item -Recurse -Force $dest }
Expand-Archive -Path $zip -DestinationPath $dest -Force;
$src = Join-Path $dest 'gradle-7.4.2';
New-Item -ItemType Directory -Path "%USERPROFILE%\.gradle\wrapper\dists\gradle-7.4.2" -Force | Out-Null;
Move-Item -Path (Join-Path $src '*') -Destination "%USERPROFILE%\.gradle\wrapper\dists\gradle-7.4.2" -Force;
Remove-Item -Recurse -Force $dest;
Remove-Item -Force $zip;
"
"%USERPROFILE%\.gradle\wrapper\dists\gradle-7.4.2\bin\gradle.bat" %*
