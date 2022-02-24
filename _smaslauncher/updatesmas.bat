@ECHO off
cls
:start
@echo off
setlocal enableDelayedExpansion

set /a size=80-1 & rem screen size minus one

title Super Mario All-Stars++ Updater
echo Starting updater... MAKE SURE THIS BAT AND _PortableGit IS
echo IN THE WORLDS FOLDER
@timeout 1 /nobreak>nul
echo Checking for SMAS^+^+ updates...
@timeout 0 /nobreak>nul
if not exist .git ( goto nogit )

:yesgit
goto updatesmas

:nogit
PING -n 5 127.0.0.1>nul
echo Pulling the latest update from GitHub...
call __PortableGit\bin\git.exe init
call __PortableGit\bin\git.exe remote add origin https://github.com/SpencerEverly/smasplusplus.git
call __PortableGit\bin\git.exe pull origin main
cls
cd "Super Mario All-Stars++"
__7zip\7zG.exe x "__World Map.7z" -aoa
echo The episode has been updated^^! Exiting in 5 seconds...
@timeout 5 /nobreak>nul
exit

:updatesmas
echo Pulling the latest update from GitHub...
PING -n 5 127.0.0.1>nul
call __PortableGit\bin\git.exe fetch --all
call __PortableGit\bin\git.exe reset --hard
call __PortableGit\bin\git.exe pull origin main
cls
cd "Super Mario All-Stars++"
__7zip\7zG.exe x "__World Map.7z" -aoa
echo The episode has been updated^^! Exiting in 5 seconds...
@timeout 5 /nobreak>nul
exit