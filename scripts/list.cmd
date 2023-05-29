@rem :filename:list   
@rem :description:manage all scripts  
@rem :category:system  

@echo off
setlocal EnableDelayedExpansion
rem chcp 65001
set cur=%~dp0%
set base=%cur:~0,-8%

set cf=%base%etc\scriptsDesp.txt
set awkst=%base%etc\showtable.awk
set awkud=%base%etc\update.awk


if "-h"=="%1" cls&&goto :help
if "-u"=="%1" cls&&goto :update
if "-o"=="%1" cls&&goto :open
if "-n"=="%1" cls&&goto :new
if "-d"=="%1" cls&&goto :delete
if "-m"=="%1" cls&&goto :modify
if "-c"=="%1" cls&&goto :out_category_by_awk
if "--home"=="%1" cls&&goto :openbasedir
if "-e"=="%1" cls&&goto :enterhome
if "-r"=="%1" cls&&goto :changename

gawk -v choice=1  -f %awkst% %cf%
rem goto :out_sorted_by_linux_sort

goto :EOL

:help
  printf "%%-40s\n" "Usage: %0    < -h | -c |--home | e >"
  printf "%%-40s\n" "Usage: %0    < -u | -o | -n | -d | -m > <name>"
  printf "%%-40s\n" "Usage: %0    < -r> <oldname> <newname>"
  printf "%%-40s\n" "Usage: %0    "
  echox 
  printf "%%-10s%%-30s\n" options details
  echox  "********************"
  printf "%%-10s%%-30s\n" -h "show this"
  printf "%%-10s%%-30s\n" -u "update command list"
  printf "%%-10s%%-30s\n" -o "open specified script by name"
  printf "%%-10s%%-30s\n" -n "generate new script by name"
  printf "%%-10s%%-30s\n" -d "delete script by name"
  printf "%%-10s%%-30s\n" -m "modify script, specify three arg: name, desc, cate"
  printf "%%-10s%%-30s\n" -c "show category list, show cmds categorized by name ,if specified" 
  printf "%%-10s%%-30s\n" --home "open home directory"
  printf "%%-10s%%-30s\n" -e "change dir to home on console"
  printf "%%-10s%%-30s\n" -r "rename, list -r oldname newname"

  goto :EOL

:changename

  pushd %cur%
  if not exist %~2.cmd (
    echo %~2.cmd not found, in dir %cur%
    goto :EOL
  )
  rename %~2.cmd %~3.cmd
  echo sucessful, from %~2.cmd to %~3.cmd
  popd

  goto :EOL

:update

  IF EXIST %cf% (
    @del %cf% 
  )

  FOR /R %base%scripts\ %%i IN (*.cmd) DO (
    set fs=!fs! %%i
  )

  rem ensure that scriptsdesp.txt is generated in dir etc
  pushd %base%etc
  gawk  -F ":" -v savefile="scriptsDesp.txt" -f %awkud% %fs% 
  popd

  goto :EOL

:open
    notepad %base%scripts\%2.cmd
  goto :EOL

:new
    pushd %base%scripts
    IF EXIST %2.cmd (
      echo %2.cmd is already existing, action aborted
    ) else ( 
      echo @rem :filename:      > %2.cmd
      echo @rem :description:     >>%2.cmd
      echo @rem :category:     >>%2.cmd
      notepad %base%scripts\%2.cmd
      list -u %2.cmd
    ) 
    popd
  goto :EOL

:delete

  pushd %base%scripts
  IF EXIST %2.cmd (
    echo %2.cmd move to backup directory instead of delete
    move %2.cmd ../backup > nul
    list -u %2.cmd
  ) else (
    echo %2.cmd not exist, check name first...
  )
  popd
  goto :EOL

:modify
  pushd %base%scripts
  IF EXIST %2.cmd (
    FOR /F "usebackq tokens=* delims=:" %%i IN (`gawk -F ":" "FNR==1{print NF}" %2.cmd`) DO (
      echo %%i
      if "%%i"=="0" (
        echo @rem :filename:      >> %2.cmd
        echo @rem :description:     >>%2.cmd
        echo @rem :category:     >>%2.cmd
        notepad %2.cmd
        list -u %2.cmd
      ) 

      if "%%i"=="1" (
        sed -i "1 i @rem :filename:   " %2.cmd
        sed -i "1 a @rem :description:  " %2.cmd
        sed -i "2 a @rem :category:    " %2.cmd
        notepad %2.cmd
        list -u %2.cmd
      )

      if "%%i"=="2" (
        sed -i "1 i @rem :filename:   " %2.cmd
        sed -i "1 a @rem :description:  " %2.cmd
        sed -i "2 a @rem :category:    " %2.cmd
        notepad %2.cmd
        list -u %2.cmd
      )

      if "%%i"=="3" (
        rem 需要进一步测试对应位置是否和 model 一致
        notepad %2.cmd 
        list -u %2.cmd
      )
      if %%i gtr 3 (
        sed -i "1 i @rem :filename:   " %2.cmd
        sed -i "1 a @rem :description:  " %2.cmd
        sed -i "2 a @rem :category:    " %2.cmd
        notepad %2.cmd
        list -u %2.cmd
      )
    )

  ) else (
    echo %2.cmd not exist, check name first...
  )
  popd
  goto :EOL

:enterhome
   set eh_cur=%~dp0
   set home=%eh_cur:~0,-8%
   start cmd /k "cd /d %home%"
  goto :EOL

:categorylist
  rem todo
  rem 先用 coreutils 的 sort 和 uniq 做后续考虑自己实现
  pushd %base%etc
  gawk -F ":" "{print $3}" scriptsDesp.txt | coreutils sort | coreutils uniq -c
  popd
  goto :EOL

:openbasedir
  explorer %base%
goto :EOL


:out_sorted_by_linux_sort
  pushd %base%\etc
  coreutils sort -f -t "|" -k4 -k2 scriptsDesp.txt
  popd
  goto :EOL

:out_sorted_by_awk
  gawk -v choice=1  -f %awkst% %cf%
  goto :EOL

:out_category_by_awk
  gawk -v choice=2  -f %awkst% %cf%
  goto :EOL

:EOL