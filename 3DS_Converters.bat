@echo off
title 3DS_Converters V1.1
echo A tool to convert CIA into CCI and also to decrypt them and make them playable in citra!
echo shijimasoft - decrypt.exe (Aka Rust ctrdecrypt)
echo 3DSGuy ^& jakcron - makerom.exe, ctrtool.exe
echo matif ^& xxmichibxx - Batch CIA 3DS Decryptor Redux.bat
echo ihaveamac ^& soarqin - 3dsconv.exe
echo rohithvishaal - original python version of this batch
echo R-YaTian - this automation batch
echo make sure the file and the script are in the same folder!
echo.
:start
echo MENU:
echo 0)CCI to CIA converter (via makerom by 3DSGuy ^& jakcron)
echo 1)CCI to CIA converter (via 3dsconv by ihaveamac ^& soarqin)
echo 2)CCI/CIA decrypter
echo 3)CIA to CCI converter (Decrypted Files Only)
echo 4)Exit
set UserChoice=""
set /p UserChoice="Enter Choice: "
if "%UserChoice%"=="0" goto 0
if "%UserChoice%"=="1" goto 1
if "%UserChoice%"=="2" goto 2
if "%UserChoice%"=="3" goto 3
if "%UserChoice%"=="4" goto 4
echo.
cls
echo Please enter a valid Choice!
goto start
:0
set /p RomName="Enter rom name: "
echo Beggining Conversion!
bin\\makerom -ccitocia "%RomName%"
echo conversion Complete!
pause
color && cls
goto start
:1
set /p RomName="Enter rom name: "
echo Beggining Conversion!
bin\\3dsconv --no-fw-spoof --overwrite "%RomName%"
echo conversion Complete!
pause
color && cls
goto start
:2
echo Do this if your rom is encrypted only!
echo     to check whether your rom is encrypted just load the .cci file in citra
echo Place your ROM file in the batch folder
echo This takes some time don't think your screen is frozen :)
pause
"Batch CIA 3DS Decryptor Redux.bat"
:3
set /p RomName="Enter rom name: "
echo Beggining Conversion to .cci!
bin\\makerom -ciatocci "%RomName%"
echo conversion Complete!
pause
color && cls
goto start
:4
color && cls
exit
