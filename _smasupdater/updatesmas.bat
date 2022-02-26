@ECHO off
cls
:start
@echo off
setlocal enableDelayedExpansion

set /a size=80-1 & rem screen size minus one

title Super Mario All-Stars++ Updater
echo Starting updater... MAKE SURE THIS BAT
echo AND PortableGit IS IN THE WORLDS FOLDER
@timeout 1 /nobreak>nul
echo Checking for SMAS^+^+ updates...
@timeout 0 /nobreak>nul
if not exist .git ( goto nogit )

:noportgit
echo PortableGit is not found. Please download it and extract it to
echo the worlds folder and try again.
pause
exit

:yesgit
goto updatesmas

:nogit
PING -n 5 127.0.0.1>nul
call PortableGit\bin\git.exe init
call PortableGit\bin\git.exe remote add origin https://github.com/SpencerEverly/smasplusplus.git
set GIT_TRACE_PACKET=1
set GIT_TRACE=1
set GIT_CURL_VERBOSE=1
call PortableGit\bin\git.exe pull origin main
cls
cd "Super Mario All-Stars++"
__7zip\7zG.exe x "__World Map.7z" -aoa
cd..
cd..
cd..
start SMBX2.exe
echo The episode has been updated^^! Executing SMBX2.exe and exiting in 5 seconds...
@timeout 5 /nobreak>nul
exit

:updatesmas
echo Pulling the latest update from GitHub...
call PortableGit\bin\git.exe fetch --all
call PortableGit\bin\git.exe reset --hard
set GIT_TRACE_PACKET=1
set GIT_TRACE=1
set GIT_CURL_VERBOSE=1
call PortableGit\bin\git.exe pull origin main
cls
cd "Super Mario All-Stars++"
__7zip\7zG.exe x "__World Map.7z" -aoa
cd..
cd..
cd..
start SMBX2.exe
echo The episode has been updated^^! Executing SMBX2.exe and exiting in 5 seconds...
@timeout 5 /nobreak>nul
exit