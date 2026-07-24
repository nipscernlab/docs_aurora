@ECHO OFF
pushd %~dp0
powershell.exe -NoProfile -ExecutionPolicy Bypass -File scripts\build-pdf.ps1
set EXITCODE=%ERRORLEVEL%
popd
exit /B %EXITCODE%
