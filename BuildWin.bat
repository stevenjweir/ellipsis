@ECHO off

:START

ECHO ------------------------------
ECHO Ellipsis Build Menu
ECHO ------------------------------
ECHO.
ECHO   1 = Build (Images)
ECHO   2 = Build (XBT)
ECHO   3 = Build to XBMC (Images)
ECHO   4 = Build to XBMC (XBT)
ECHO   5 = Build to XBMC (No Textures)
ECHO   6 = Exit
ECHO.
CHOICE /C:123456 /N /M "Your choice: "

IF ERRORLEVEL == 1 SET MENUCHOICE=1
IF ERRORLEVEL == 2 SET MENUCHOICE=2
IF ERRORLEVEL == 3 SET MENUCHOICE=3
IF ERRORLEVEL == 4 SET MENUCHOICE=4
IF ERRORLEVEL == 5 SET MENUCHOICE=5
IF ERRORLEVEL == 6 SET MENUCHOICE=6

IF %MENUCHOICE%==6 GOTO END

ECHO.
ECHO ------------------------------
ECHO Creating Ellipsis Build Folder
RMDIR BUILD /S /Q
MD BUILD

IF %MENUCHOICE%==2 GOTO XBT
IF %MENUCHOICE%==4 GOTO XBT
IF %MENUCHOICE%==5 GOTO COPYMAIN

ECHO ------------------------------
ECHO Copying Image Files...
XCOPY "media\Default\*.*" "BUILD\skin.ellipsis\media\" /E /Q /I /Y

GOTO COPYMAIN

:XBT

ECHO ------------------------------
ECHO Creating XBT File...
CALL media\TexturePackerWin\TexturePacker.bat
ECHO ------------------------------
ECHO Copying XBT Files...
MD "BUILD\skin.ellipsis\media"
MOVE /Y "media\*.xbt" "BUILD\skin.ellipsis\media"

:COPYMAIN

ECHO ------------------------------
ECHO Building Skin Directory...
XCOPY "1080i" "BUILD\skin.ellipsis\1080i" /E /Q /I /Y
XCOPY "colors" "BUILD\skin.ellipsis\colors" /E /Q /I /Y
XCOPY "fonts" "BUILD\skin.ellipsis\fonts" /E /Q /I /Y
XCOPY "sounds" "BUILD\skin.ellipsis\sounds" /E /Q /I /Y
XCOPY "language" "BUILD\skin.ellipsis\language" /E /Q /I /Y
XCOPY "*.xml" "BUILD\skin.ellipsis\" /Q /I /Y
XCOPY "*.txt" "BUILD\skin.ellipsis\" /Q /I /Y
XCOPY "*.txt" "BUILD\"
XCOPY "icon.png" "BUILD\skin.ellipsis\" /Q /I /Y
XCOPY "fanart.png" "BUILD\skin.ellipsis\" /Q /I /Y

ECHO ------------------------------
ECHO Making Revision.xml Include
ECHO ^<includes^>>> "BUILD\skin.ellipsis\1080i\Revision.xml"
ECHO     ^<include name="Revision"^>>> "BUILD\skin.ellipsis\1080i\Revision.xml"
ECHO         ^<label^>Ellipsis ^(Compiled : %date% %time%^)^</label^>>> "BUILD\skin.ellipsis\1080i\Revision.xml"
ECHO     ^</include^>>> "BUILD\skin.ellipsis\1080i\Revision.xml"
ECHO ^</includes^>>> "BUILD\skin.ellipsis\1080i\Revision.xml"

IF %MENUCHOICE%==1 GOTO COMPLETE
IF %MENUCHOICE%==2 GOTO COMPLETE

ECHO ------------------------------
ECHO Killing XBMC...
TASKLIST /FI "IMAGENAME eq XBMC.exe" 2>NUL | find /I /N "XBMC.exe">NUL
IF NOT "%ERRORLEVEL%"=="0" GOTO NOXBMC
TASKKILL /F /IM XBMC.exe /T >NUL
ECHO ------------------------------
ECHO Waiting for XBMC to close...
:XBMCTEST
TASKLIST /FI "IMAGENAME eq XBMC.exe" 2>NUL | find /I /N "XBMC.exe">NUL
IF NOT "%ERRORLEVEL%"=="0" GOTO NOXBMC
GOTO XBMCTEST
:NOXBMC

ECHO ------------------------------
ECHO Copying Files...
IF %MENUCHOICE%==5 GOTO SKIPREMOVE
RD "%appdata%\XBMC\addons\skin.ellipsis" /S /Q >NUL
:SKIPREMOVE
XCOPY "BUILD\skin.ellipsis" "%appdata%\XBMC\addons\skin.ellipsis" /Q /I /Y /S /E
RMDIR BUILD /S /Q

ECHO ------------------------------
ECHO Restarting XBMC...
IF "%PROGRAMFILES(x86)%"=="" GOTO 32BIT
START /D "%PROGRAMFILES(x86)%\XBMC" /B XBMC.exe
GOTO COMPLETE
:32BIT
START /D "%PROGRAMFILES%\XBMC" /B XBMC.exe

:COMPLETE

ECHO ------------------------------
ECHO.
ECHO Build Complete - Check above for errors.
ECHO.
GOTO START

:END
