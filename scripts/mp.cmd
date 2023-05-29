@rem :filename: mp 
@rem :description:  change to project home and open it with vscode   
@rem :category:     tool

@echo off
setlocal EnableDelayedExpansion

set base=%~dp0
set curpp=%base:~0,-9%
set cfg=%curpp%\etc\myproject.txt

if "add"=="%1" (
  call :add %~2 %~3
  goto :eol
) 

if not exist %cfg% (
  echo configure file not found, please check %cfg%
  echo you can **%0 add path** to add generate a configure file
  goto :eol
)


if "help"=="%1" (
  goto :help
  goto :eol
)
if "show"=="%1" (
  call :show %cfg%
  goto :eol
)

if "open"=="%1" ( 
  call :open %cfg% %2 
  goto :eol
)
if "delete"=="%1" ( 
  call :delete %cfg% %2 
  goto :eol
)

if "use"=="%1" (
  call :use %cfg% %2 
  goto :eol
)

mp open cur

goto :eol


rem===========================
rem      use 
rem===========================
:use
  rem %1 cfg file path
  rem %2 name 

  sed -i "/^%2\s/s/\\/#/g" %1
  FOR /F "usebackq tokens=1,2" %%i IN (`sed -n -e "/^%2\s/p" %1`) DO (
    set use_t=%%i %%j
    sed -i "1a !use_t!" %1
    sed -i "/^%2\s/s/#/\\/g" %1
    sed -i "1d" %1
    sed -i "1s/^%2\s/cur /" %1
  )
  goto :eol


rem===========================
rem       show 
rem===========================
:show 
  FOR /F "tokens=1,2" %%i IN (%1) DO (
    printf "%%-20s%%-100s\n" %%i %%j
  )
  goto :eol

rem===========================
rem        open 
rem===========================
:open
  FOR /F "tokens=1,2 " %%i IN (%1) DO (
    if %%i==%2 (
      pushd %%j
      code .
      popd
    )
  ) 
  goto :eol

rem===========================
rem        delete
rem===========================
:delete
   rem %1 cfg file path
   rem %2 filename deleted
   sed -i "/^%2\s/d" %cfg% 
  goto :eol

rem===========================
rem        add 
rem===========================
:add
  rem %1 name
  rem %2 path
  echo %~1 %~2 >>%cfg%
  goto :eol


rem===========================
rem         help 
rem===========================
:help
  printf "%%-40s\n" "Usage: %0    [ help | show]" 
  printf "%%-40s\n" "Usage: %0    < add > <name> <basedir> " 
  printf "%%-40s\n" "Usage: %0    < open | modify > <name> " 
  echox 
  printf "%%-10s%%-30s\n" "commands" "details"
  echox  "********************"
  printf "%%-10s%%-30s\n" "help" "show this"
  printf "%%-10s%%-30s\n" "use" "change defualt base"
  printf "%%-10s%%-30s\n" "show" "show current project base"
  printf "%%-10s%%-30s\n" "add" "add project base"
  printf "%%-10s%%-30s\n" "open" "open project with vscode"

  goto :eol


rem===========================
rem        eol 
rem===========================
:eol