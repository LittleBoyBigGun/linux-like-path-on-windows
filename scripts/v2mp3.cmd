@rem :filename:v2mp3   
@rem :description:  video to mp3 based on ffmpeg
@rem :category:    media
@echo off
setlocal EnableDelayedExpansion

if not exist tmp mkdir tmp
if not exist result mkdir result
if not exist old mkdir old

for /f "delims=" %%i in ('dir /b *.*') do ( 
	rem set oldName=%%~ni%%~xi
	rem 每一行
	set item=%%i
	rem 扩展名
	set ext=!item:~-4!
	rem 文件名，不包含扩展名
	set Name=!item:~0,-4!

	if !ext!==.mp4 (
		set targetName=!Name!.mp3
		ffmpeg -i !Name!!ext! .\tmp\!targetName!
		cd tmp
		move "!targetName!" ..\result
		cd ..
		move "!Name!!ext!" .\old
	)
	
	
	
)



:EOF