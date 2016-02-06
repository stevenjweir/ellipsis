@ECHO off

ECHO ------------------------------
ECHO Test PVR Build Menu
ECHO ------------------------------
ECHO.
ECHO   1 = Build to XBMC
ECHO   2 = Exit
ECHO.
CHOICE /C:12 /N /M "Your choice: "

IF ERRORLEVEL == 1 SET MENUCHOICE=1
IF ERRORLEVEL == 2 SET MENUCHOICE=2

IF %MENUCHOICE%==2 GOTO END

ECHO ------------------------------
ECHO Killing XBMC...
ECHO ------------------------------

TASKLIST /FI "IMAGENAME eq XBMC.exe" 2>NUL | find /I /N "XBMC.exe">NUL
IF NOT "%ERRORLEVEL%"=="0" GOTO NOXBMC
TASKKILL /F /IM XBMC.exe /T >NUL
ECHO Waiting for XBMC to close...
:XBMCTEST
TASKLIST /FI "IMAGENAME eq XBMC.exe" 2>NUL | find /I /N "XBMC.exe">NUL
IF NOT "%ERRORLEVEL%"=="0" GOTO NOXBMC
GOTO XBMCTEST
:NOXBMC

ECHO ------------------------------
ECHO Copying Files...
ECHO ------------------------------
XCOPY "pvr.demo" "%appdata%\XBMC\addons\pvr.demo" /Q /I /Y /S /E

ECHO ------------------------------
ECHO Restarting XBMC...
ECHO ------------------------------

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
PAUSE

:END
