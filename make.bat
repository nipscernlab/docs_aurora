@ECHO OFF
pushd %~dp0

if /I "%~1" == "pdf" (
  powershell.exe -NoProfile -ExecutionPolicy Bypass -File scripts\build-pdf.ps1
  set EXITCODE=%ERRORLEVEL%
  popd
  exit /B %EXITCODE%
)

if /I not "%~1" == "html-only" (
  powershell.exe -NoProfile -ExecutionPolicy Bypass -File scripts\build-pdf.ps1
  if ERRORLEVEL 1 (
    set EXITCODE=%ERRORLEVEL%
    popd
    exit /B %EXITCODE%
  )
)

if "%SPHINXBUILD%" == "" set SPHINXBUILD=.venv\Scripts\sphinx-build.exe
%SPHINXBUILD% -M html source build -E -a %SPHINXOPTS% %O%
set EXITCODE=%ERRORLEVEL%
popd
exit /B %EXITCODE%
