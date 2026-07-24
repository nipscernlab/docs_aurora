@ECHO OFF
pushd %~dp0
powershell.exe -NoProfile -ExecutionPolicy Bypass -File scripts\stop-watch.ps1
set EXITCODE=%ERRORLEVEL%
popd
exit /B %EXITCODE%
