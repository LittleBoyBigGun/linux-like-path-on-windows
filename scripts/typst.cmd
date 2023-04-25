@ECHO off
SETLOCAL
CALL :find_dp0

IF EXIST "%dp0%\typst.exe" (
  SET "_prog=%dp0%\typst.exe"
) ELSE (
  SET "_prog=D:\work\typst\typst.exe"
)

"%_prog%" %*
ENDLOCAL
EXIT /b %errorlevel%
:find_dp0
SET dp0=%~dp0
EXIT /b