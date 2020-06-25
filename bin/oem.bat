@echo off
title Oem Stuff
:oemstrart
color 3
echo -------------------------------------
echo 6- Oem Lock
echo 7- Oem Unlock
echo 8- Back
echo ------------------------------------

set /p option=choose: || set option="0"

if /I %option%==6 goto 6

if /I %option%==7 goto 7

if /I %option%==8 goto 8

:b
call .\Install.bat
:6
title Locking..
cls
color 4
echo		OEM Locking...
adb reboot bootloader
cls
fastboot oem lock-go
pause
goto oemstart

:7
title Unlocking..
cls
color 7

echo		OEM UnLocking...

adb reboot bootloader
cls
fastboot oem unlock-go
pause
goto oemstart

:8
cls
call .\Install.bat