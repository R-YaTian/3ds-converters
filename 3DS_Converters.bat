@echo off
setlocal EnableDelayedExpansion
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
echo 2)Batch CCI/CIA decrypter
echo 3)CIA to CCI converter (Decrypted Files Only)
echo 4)CCI to CIA packer with template cia
echo 5)Exit
set UserChoice=""
set /p UserChoice="Enter Choice: "
if "%UserChoice%"=="0" goto 0
if "%UserChoice%"=="1" goto 1
if "%UserChoice%"=="2" goto 2
if "%UserChoice%"=="3" goto 3
if "%UserChoice%"=="4" goto 4
if "%UserChoice%"=="5" goto 5
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
set content=bin^\CTR_Content.txt
set /p cciName="Enter rom name: "
set /p Template="Enter template cia name: "
for %%a in ("%Template%") do (
    set CUTN=%%~na
)
for %%b in ("%cciName%") do (
    set CUTB=%%~nb
)
set ARG=
set /a i=0
set /a j=0
set /a cid=0
if exist "!content!" del /s "!content!" >nul 2>&1
bin\ctrtool.exe --seeddb=bin\seeddb.bin "%Template%" >!content!
for /f "tokens=4 delims= " %%x in ('findstr "TitleVersion" !content!') do set "TitleVersion=%%x"
set TitleVersion=!TitleVersion:~1,-1!
echo | bin\decrypt.exe "%cciName%" >nul 2>nul
echo | bin\decrypt.exe "%Template%" >nul 2>nul
for %%f in ("%CUTN%.*.ncch") do (
    set CONLINE=%%f
    call :EXF
    for %%k in ("%CUTB%.*.ncch") do (
        if %%k==%CUTB%.Main.00000000.ncch set j=0
        if %%k==%CUTB%.Manual.00000001.ncch set j=1
        if %%k==%CUTB%.DownloadPlay.00000002.ncch set j=2
        if %%k==%CUTB%.Partition4.00000003.ncch set j=3
        if %%k==%CUTB%.Partition5.00000004.ncch set j=4
        if %%k==%CUTB%.Partition6.00000005.ncch set j=5
        if %%k==%CUTB%.N3DSUpdateData.00000006.ncch set j=6
        if %%k==%CUTB%.UpdateData.00000007.ncch set j=7
        if !i!==!j! set ARG=!ARG! -i "%%k:!i!:!cid!"
    )
)
bin\makerom.exe -f cia -ignoresign -target p -o "!CUTB!_repack.cia"!ARG! -ver !TitleVersion! >nul 2>nul
for %%a in (*.ncch) do del /s "%%a" >nul 2>&1
if exist "!content!" del /s "!content!" >nul 2>&1
echo conversion Complete!
pause
color && cls
goto start
:5
color && cls
exit

:EXF
set PARSE=!CONLINE:~-15!
set i=!PARSE:~0,1!
set CONLINE=!PARSE:~2,8!
call :GETX !CONLINE!, ID
set cid=!ID!
exit/B

:GETX v dec
set /a dec=0x%~1
if [%~2] neq [] set %~2=%dec%
exit/b
