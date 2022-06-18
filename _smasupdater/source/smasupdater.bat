::Super Mario All-Stars++ Updater
::By Spencer Everly
::Hi there, thanks for analyzing this code. It's... not the best, but it gets the job done.
::Comments will be around this code to explain what each does for easier readability.
@ECHO off
cls
:start
@echo off
setlocal enableDelayedExpansion
::Make sure commands don't get in the way...

set /a size=80-1 & rem screen size minus one

::With that out of the way, we can start
title Super Mario All-Stars++ Updater ^(v1.2.0^)
echo Starting updater...
::This makes sure we go into the root of the .bat, preventing errors
pushd "%~dp0"
@timeout 0 /nobreak>nul
::Check to see if we're running as an admin. If so, don't launch the updater.
fsutil dirty query !systemdrive! >NUL 2>&1
if /i !ERRORLEVEL!==0 (
	cls
	echo You can^'t run this as an admin.
	echo.
	echo Please restart the program as an normal elevated user
	echo and try again.
	pause
	exit
)
::We then start the menu.
:start
cls
echo Super Mario All-Stars^+^+ Updater
echo v1.2.0
echo.
echo Make SURE this .bat is in the SMBX2 folder^, and the ^"PortableGit^"
echo folder is in the worlds folder ^(Located under data^/worlds^, or
echo just worlds^) before downloading^/updating!^^!^^!^^!^^!
echo.
echo Press 1 and enter to download^/update Super Mario All^-Stars^+^+.
echo Press 2 and enter to exit.
::These are choices set to launch certain parts of the .bat.
set choice=
set /p choice=
if not '%choice%'=='' set choice=%choice:~0,1%
if '%choice%'=='1' goto precheck
if '%choice%'=='2' goto exit
echo "%choice%" is not valid, try again.
goto start

::Precheck checks to see if there's a .git folder which holds the latest update data. If one doesn't exist, it goes to the nogit part.
:precheck
cls
echo Checking for SMAS^+^+ updates...
@timeout 0 /nobreak>nul
cd data
cd worlds
if not exist .git ( goto nogit )
if exist .git ( goto yesgit )

:yesgit
::Now we start updating the episode if .git wasn't found.
echo Pulling the latest update from GitHub...
::This reads the .git for the repository that's saved
call PortableGit\bin\git.exe fetch --all
::This resets to download a different branch if so
call PortableGit\bin\git.exe reset --hard
::The set stuff improves the connection when downloading the repo
set GIT_TRACE_PACKET=1
set GIT_TRACE=1
set GIT_CURL_VERBOSE=1
::Downloads the specific branch from the repo that is stored
call PortableGit\bin\git.exe pull origin main
::After downloading, there's a weird world map corruption issue when downloading from GitHub. Make sure to extract the .7z automatically from both worlds to prevent crashes and errors.
cd "Super Mario All-Stars++"
__7zip\7zG.exe x "__World Map.7z" -aoa
cd..
cd..
cd..
::The download is finally complete
goto updatecomplete

:nogit
::Ping the Internet to start a connection
PING -n 5 127.0.0.1>nul
::Make a .git folder
call PortableGit\bin\git.exe init
::Add the SMAS++ repo to the .git list
call PortableGit\bin\git.exe remote add origin https://github.com/SpencerEverly/smasplusplus.git
::The set stuff improves the connection when downloading the repo
set GIT_TRACE_PACKET=1
set GIT_TRACE=1
set GIT_CURL_VERBOSE=1
::Downloads the specific branch from the repo that is stored
call PortableGit\bin\git.exe pull origin main
::After downloading, there's a weird world map corruption issue when downloading from GitHub. Make sure to extract the .7z automatically from both worlds to prevent crashes and errors.
cd "Super Mario All-Stars++"
__7zip\7zG.exe x "__World Map.7z" -aoa
cd..
cd..
cd..
::The download is finally complete
goto updatecomplete

:updatecomplete
echo Episode updated. Check above to see if there are any errors. If any,
echo you can correct them by doing what is above.
echo.
echo If you want to run SMBX2.exe just press 1 and enter.
echo If you don^'t want to^, just press 2 and enter ^(Or close the window^).
set choice=
set /p choice=
if not '%choice%'=='' set choice=%choice:~0,1%
if '%choice%'=='1' goto launchsmbx2
if '%choice%'=='2' goto dontlaunchsmbx2
echo "%choice%" is not valid, try again.
goto launchsmbx2

:dontlaunchsmbx2
cls
echo The episode has been updated^^! Exiting in 5 seconds...
@timeout 5 /nobreak>nul
exit

:launchsmbx2
cls
start SMBX2.exe
echo The episode has been updated^^! Executing SMBX2.exe and exiting in 5 seconds...
@timeout 5 /nobreak>nul
exit

:exit
cls
echo Exiting in 5 seconds...
@timeout 5 /nobreak>nul
exit