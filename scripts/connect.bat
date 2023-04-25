@rem runas /user:yuxia /env cmd
@set phone_ip=192.168.31.159
@echo phone ip is %phone_ip%
@set /P port=please enter the port:

@set addr=%phone_ip%:%port%

@cls
@echo please choose a mode 
@echo 1 for connect
@echo 2 for pair

@set /P mode=MODE:

@if %mode%==1 @cls & @echo Connect Mode &adb connect %addr%
@if %mode%==2 @cls & @echo Pair Mode &adb pair %addr% & adb devices

@pause