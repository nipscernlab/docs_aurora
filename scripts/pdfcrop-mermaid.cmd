@ECHO OFF
SETLOCAL
SET "INPUT=%~1"
SET "INPUT=%INPUT:\=/%"

REM O pdfcrop do MiKTeX e um script Perl. Se nao houver Perl no PATH,
REM usa o interpretador que acompanha o Git for Windows.
WHERE perl.exe >NUL 2>&1
IF ERRORLEVEL 1 (
  IF EXIST "%ProgramFiles%\Git\usr\bin\perl.exe" SET "PATH=%ProgramFiles%\Git\usr\bin;%PATH%"
)

pdfcrop.exe --margins 6 "%INPUT%"
EXIT /B %ERRORLEVEL%
