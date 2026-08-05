@ECHO OFF
SETLOCAL
SET "INPUT=%~1"
SET "INPUT=%INPUT:\=/%"

REM O pdfcrop do MiKTeX e um script Perl. Quando nao ha Perl no PATH,
REM procura interpretadores conhecidos do Windows antes de desistir.
WHERE perl.exe >NUL 2>&1
IF ERRORLEVEL 1 (
  FOR %%P IN (
    "C:\Program Files\Git\usr\bin"
    "C:\Program Files (x86)\Git\usr\bin"
    "C:\Strawberry\perl\bin"
  ) DO (
    IF EXIST "%%~P\perl.exe" (
      SET "PATH=%%~P;%PATH%"
      GOTO :run
    )
  )
  ECHO Perl nao encontrado. Instale o Git para Windows ou o Strawberry Perl. 1>&2
  EXIT /B 1
)

:run
pdfcrop.exe --margins 6 "%INPUT%"
EXIT /B %ERRORLEVEL%
