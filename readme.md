# 架构

安装软件后，如果想在命令行中运行，必须在`path` 添加该软件的路径，有些安装程序替用户做了这个工作。这种方式有个非常严重的问题， path 无法备份，导致一旦 path 被误删，需要手动逐条恢复，同时也不利于分享。

为了解决这个问题，仿照 linux 的方案提供 `INIT_HOME`来存放二进制文件和脚本，其目录树如下

```txt
INIT_HOME
	- bin
	- scripts
```



## bin

存放 exe 文件或者 exe 链接， 对于一些不大的文件建议直接存放在这个文件夹，较大的文件可以链接到这里，参看 mklink

## scripts

存放一些自己写的脚本，或者 exe 程序的包装(wrapper)，还有个按需导入 path 的 init 脚本。

**init** 

这是个特殊的脚本，用于动态修改 path。打开 cmd 运行程序之前，必须执行该文件 （`init` ）。每一条指定一个运行路径。

```cmd
@echo off
rem 使用前 init
rem 添加一条 path 
rem set path=%path%;newpaht
rem sc 命令开机运行这个命令

rem mirai
set path=%path%;d:\SoftWare\mirai

rem maven
set path=%path%;d:\work\apache-maven-3.8.1\bin

rem typst
set path=%path%;D:\work\typst
```

如果开机时能够自动执行 init 脚本， 或者每次运行 cmd 时也自动执行，则无需手动执行 init 命令。可能通过 sc 命令解决。



**wrapper**

该脚本和目标 exe 同名，它启动 exe 并把参数传递过去。

```cmd
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
```

经测试，这种包装有个大问题，如果用在 bat 脚本中则会出现传参问题



# 使用

只需要把 bin, scripts 添加到环境变量 path 中即可。
