title Magisk Flashler
@echo off
echo Rebootting Fastboot mode..
adb wait-for-device
adb reboot bootloader

echo booting TWRP
.\bin\fastboot.exe boot .\bin\twrp.img

echo Flashing Magisk..
adb wait-for-device
echo Tap "Advanced"
echo Tab "ADB Sideload"
echo "Swipe"
adb sideload Magisk-v20.3.zip
adb reboot
pause
call .\install.bat