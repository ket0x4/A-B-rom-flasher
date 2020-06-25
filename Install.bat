:start
cls
@echo off
title FDoop's Custom Rom flashler
@shift /0
mode con cols=70 lines=30
color 3f

echo --------------------------------------------------------------------
echo  1- Device info
echo  2- Flash custom Rom
echo  3- Install Magisk (Beta)
echo  4- Oem Lock-Unlock
echo  5- Flash MIUI Port zip file
echo                                                          v2    
echo                                               FDoop's Daisy Tool  
echo --------------------------------------------------------------------
set /p option=choose: || set option="0"

if /I %option%==1 goto deviceinfo
if /I %option%==2 goto flashcustom
if /I %option%==3 goto magisk
if /I %option%==4 goto oem
if /I %option%==5 goto miui
goto start

:deviceinfo
cls

title Getting Device info
if exist .\bin\adb.txt del .\bin\adb.txt
.\bin\adb devices -l > .\bin\adb.txt

for /f "delims=" %%v in ('.\bin\adb.exe shell getprop ro.build.user') do set "ro_build_user=%%v"
for /f "delims=" %%v in ('.\bin\adb.exe shell getprop ro.product.cpu.abilist') do set "ro_product_cpu_abilist=%%v"
for /f "delims=" %%v in ('.\bin\adb.exe shell getprop ro.product.manufacturer') do set "ro_product_manufacturer=%%v"
for /f "delims=" %%v in ('.\bin\adb.exe shell getprop ro.product.model') do set "ro_product_model=%%v"
for /f "delims=" %%v in ('.\bin\adb.exe shell getprop ro.product.board') do set "ro_product_board=%%v"
for /f "delims=" %%v in ('.\bin\adb.exe shell getprop ro.product.device') do set "ro_product_device=%%v"
for /f "delims=" %%v in ('.\bin\adb.exe shell getprop ro.build.version.release') do set "ro_android_version=%%v"
for /f "delims=" %%v in ('.\bin\adb.exe shell getprop ro.build.sdk') do set "ro_build_sdk==%%v"

echo Manufacturer: %ro_product_manufacturer%
echo Device: %ro_product_device%
echo Model: %ro_product_model%
echo Board: %ro_product_board%
echo CPU: %ro_product_cpu_abilist%
echo Android Version: %ro_android_version%
echo Build User: %ro_build_user%
echo Build SDK: %ro_build_sdk%
pause
goto start

:flashcustom
echo Cleaning..
if exist .\bin\payload_output\boot.img del .\bin\payload_output\boot.img
if exist .\bin\payload_output\vendor.img del .\bin\payload_output\vendor.img
if exist .\bin\payload_output\system.img del .\bin\payload_output\system.img
if exist .\bin\payload_input\payload.bin del .\bin\payload_input\payload.bin
if exist .\sources\system.img del .\sources\system.img
if exist .\sources\vendor.img del .\sources\vendor.img
if exist .\sources\boot.img del .\sources\boot.img

timeout 3

cls
title Extracting Rom files...
echo Extracting Rom files...
echo Extracting Payload.bin Form Rom zip ..
.\bin\unzip.exe .\place_rom_here\*.zip *.bin

timeout 3

cls
title Moving Payload.bin...
echo Moving Payload.bin...
move payload.bin .\bin\payload_input\payload.bin
cd .\bin
echo unpacking payload.bin ...
payload_dumper.exe
cd ..
timeout 3
cls
move .\bin\payload_output\system.img .\sources
move .\bin\payload_output\vendor.img .\sources
move .\bin\payload_output\boot.img .\sources

cls
title Formattig "data"
echo Formattig "data"
.\bin\fastboot.exe erase userdata
title Flashing..
echo flashing slot A
echo flashing  System A
.\bin\fastboot.exe flash system_a .\sources\system.img
echo flashing  Vendor A
.\bin\fastboot.exe flash vendor_a .\sources\vendor.img
echo flashing  Boot A
.\bin\fastboot.exe flash boot_a .\sources\boot.img

cls

echo flashing slot B
echo flashing  System B
.\bin\fastboot.exe flash system_b .\sources\system.img
echo flashing  Vendor B
.\bin\fastboot.exe flash vendor_b .\sources\vendor.img
echo flashing  Boot B
.\bin\fastboot.exe flash boot_b .\sources\boot.img

fastboot sec active a
fastboot reboot

.\bin\adb kill-server

:clean
cls
call clean.bat
goto start

:oem
cls
call .\bin\oem.bat
cls
goto start

:magisk
cls
call .\bin\magisk.bat
goto start

:help
echo - If you need more info
echo - Telegram support group:
echo - https://t.me/daisyofficial/
goto start

:miui
cls
echo Cleaning..

if exist sources\system.img del sources\system.img
if exist sources\vendor.img del sources\vendor.img
if exist sources\boot.img del sources\boot.img

timeout 3

title Extracting Rom files...
echo Extracting Rom files...
echo Extracting image files form Rom zip..
bin\7za x place_rom_here\*.zip
rmdir /q /s META-INF
rmdir /q /s google
del /q /s modemfix.sh

timeout 3
cls

title Moving images...
echo Moving images...
if exist sources\miui rmdir /s /q sources\miui
move firmware-update sources\miui
move system.img sources\system.img
move boot.img sources\boot.img
move vendor.img sources\vendor.img

cls

title flashing miui stuff
echo flashing miui firmware images
bin\fastboot.exe flash splash sources\miui\splash.img
bin\fastboot.exe flash rpm sources\miui\rpm.mbn
bin\fastboot.exe flash tz sources\miui\tz.mbn
bin\fastboot.exe flash aboot sources\miui\emmc_appsboot.mbn
bin\fastboot.exe flash lksecapp sources\miui\lksecapp.mbn
bin\fastboot.exe flash keymaster sources\miui\keymaster64.mbn
bin\fastboot.exe flash sbl1 sources\miui\sbl1.mbn
bin\fastboot.exe flash cmnlib64 sources\miui\cmnlib64.mbn
bin\fastboot.exe flash cmnlib sources\miui\cmnlib.mbn
bin\fastboot.exe flash devcfg sources\miui\devcfg.mbn
bin\fastboot.exe flash rpmbak sources\miui\rpm.mbn
bin\fastboot.exe flash tzbak sources\miui\tz.mbn
bin\fastboot.exe flash abootbak sources\miui\emmc_appsboot.mbn
bin\fastboot.exe flash lksecappbak sources\miui\lksecapp.mbn
bin\fastboot.exe flash keymasterbak sources\miui\keymaster64.mbn
bin\fastboot.exe flash sbl1bak sources\miui\sbl1.mbn
bin\fastboot.exe flash cmnlibbak sources\miui\cmnlib.mbn
bin\fastboot.exe flash devcfgbak sources\miui\devcfg.mbn
bin\fastboot.exe flash modem sources\miui\NON-HLOS.bin
bin\fastboot.exe flash dsp sources\miui\dsp.mbn
bin\fastboot.exe flash persist sources\miui\persist.img
bin\fastboot.exe flash persistbak sources\miui\persist.img

cls

title Formattig "data"
echo Formattig "data"
bin\fastboot.exe erase userdata

title Flashing..
echo flashing  System
bin\fastboot.exe flash system_a .\sources\system.img
echo flashing  Vendor
bin\fastboot.exe flash vendor_a .\sources\vendor.img
echo flashing  Boot
bin\fastboot.exe flash boot_a .\sources\boot.img

fastboot set active a
fastboot reboot
bin\adb kill-server
goto start