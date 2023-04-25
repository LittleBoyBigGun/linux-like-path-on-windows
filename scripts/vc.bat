@echo off
setlocal EnableDelayedExpansion
rem %1 command %2 bitrate %3 video formate , mp4,mkv for example
rem "%~1：当参数以引号开头时，%~1会自动将引号删除。"
rem "%1：当参数以引号开头时，%1不会自动将引号删除"

set command=%~1
set bitrate=%~2
set type=%~3

rem 引号为了区别空格
rem refer to https://blog.csdn.net/tuoni123/article/details/106525706
rem refer to https://www.cnblogs.com/mq0036/p/14302088.html
if "!command!"=="" (
	call:help
	goto eof
)

if !command!==help (
	call:help
	goto eof
)

if !command!==compressall (
	if "!bitrate!"=="" (
		echo =====bitreate is not setting, use default 600k=========
		set bitrate=600k
		if "!type!"=="" (
			echo ==========video type is not setting , use default mp4======
			set type=mp4
		)
	) else (
		if "!type!"=="" (
			echo ==========video type is not setting , use default mp4======
			set type=mp4
		)
	)
	echo ==========config================
	echo "bitreate => !bitrate!"
	echo "type     => !type!"
	call:videocompress !bitrate! !type!
	goto eof
)

call:help

goto eof

:videocompress
	rem %1 bitreate %2 video type
	echo ===========compressing==========================
	if not exist tmp mkdir tmp
	if not exist result mkdir result
	if not exist old mkdir old

	set currentPath=!cd!

	echo workfolder =^> !currentPath!
	
	for /f "delims=" %%i in ('dir /b *.*') do (
		
		rem set oldName=%%~ni%%~xi
		rem 每一行
		set item=%%i
		rem 扩展名
		set ext=!item:~-4!
		rem 文件名，不包含扩展名
		set Name=!item:~0,-4!
		
		if !ext!==.%2 (
		    echo %%i is processing
			echo.
			
            set video=!item!
			set targetName=!Name!.mp4
			set targetPath=.\tmp\!targetName!
			
			rem 测试是否可以使用gpu
			call:ffmpegGpu %1 "!video!" "!targetPath!" 
			echo =============tested===================
			for /f "tokens=3 delims= " %%t in ('dir "!targetPath!" ^| findstr "!targetName!"') do (
				echo "========%%t====================="
				if %%t equ 0 (
					echo "============CPU=============="
					del /q "!targetPath!"
					call:ffmpegCpu %1 "!video!" "!targetPath!"
					call:sort tmp old result "!targetName!" "!video!"
				) else (
					echo "============GPU=============="
					call:sort tmp old result "!targetName!" "!video!"
				)
			)	
		)
	)
	
	goto eof

:sort
		rem %1 tmp  %2 old %3 result %4 targetName %5 sourceName
        echo ================sort=============
		cd %1 
		move %4 "../%3"
		cd ..
		move %5 %2 
		goto eof 

:ffmpegGpu
		rem %1 bitrate  %2 input %3 output
		echo !cd!
		@echo on
		ffmpeg -hwaccel cuvid -c:v h264_cuvid -i %2 -c:v h264_nvenc -b:v %1 %3 
		@echo off
		goto eof
:ffmpegCpu
		rem %1 bitrate  %2 input %3 output
		echo !cd!
		@echo on
		ffmpeg -i %2 -b:v %1 %3 
		@echo off
		goto eof
:help
		cls
		echo =======video compresser=============
		echo.
		echo videocompress [command] params
		echo.
		echo command	meaning
		echo.
		echo help		show this page
		echo compressall   compress video
		echo ==command
		echo command   params
		echo help 	   nop
		echo compressall  bitrate video_type
		echo ==params
		echo bitreate default 600k
		echo video_type default mp4
		echo ==
		echo this script is located at %~dp0
		goto eof
:eof