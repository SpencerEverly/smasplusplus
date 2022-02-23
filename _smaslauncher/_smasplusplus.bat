@ECHO off
cls
:start
@echo off
setlocal enableDelayedExpansion

set /a size=80-1 & rem screen size minus one

title Super Mario All-Stars++ Launcher
echo Starting launcher...
@timeout 0 /nobreak>nul
echo Checking for cmdmp3win...
@timeout 0 /nobreak>nul
if not exist "cmdmp3win.exe" goto missingaudio
echo Checking dependencies...
@timeout 0 /nobreak>nul
if not exist "bootLauncher_start.wav" goto missingwavs
if not exist "bootSound_noTHX.wav" goto missingwavs
if not exist "bootLauncher_saveslot1.wav" goto missingwavs
if not exist "bootLauncher_character2.wav" goto missingwavs
if not exist "bootLauncher_unfocused3.wav" goto missingwavs
if not exist "bootLauncher_console4.wav" goto missingwavs
if not exist "bootLauncher_opengl5.wav" goto missingwavs
if not exist "bootLauncher_preload6.wav" goto missingwavs
if not exist "bootLauncher_custom.wav" goto missingwavs
if not exist "bootLauncher_finalizeSettings.wav" goto missingwavs
if not exist "bootLauncher_changecam.wav" goto missingwavs
if not exist "bootLauncher_dlSFX.wav" goto missingwavs
if not exist "bootLauncher_coin.wav" goto missingwavs
if not exist "bootLauncher_chosen.wav" goto missingwavs
echo Checking to see if SMBX2.exe exists...
@timeout 0 /nobreak>nul
cd..
if not exist "SMBX2.exe" goto directorycheck
cd _smaslauncher
echo Checking to see if SMAS^+^+ is installed...
@timeout 0 /nobreak>nul
cd..
cd data
cd worlds
if not exist "Super Mario All-Stars++" goto directorycheck2
cd "Super Mario All-Stars++"
if not exist "__World Map.wld" goto directorycheck3
cd..
cd..
cd..
cd _smaslauncher
goto simplelaunch

:directorycheck
cd..
if not exist "SMBX2\" goto wrongdirectory
goto dlsmbx2

:directorycheck2
cd..
cd..
cd _smaslauncher
goto dlsmas

:directorycheck3
cd..
cd..
cd..
cd _smaslauncher
goto dlsmas

:exitlauncher
exit

:dlsmas
start cmdmp3win.exe bootLauncher_changecam.wav
cls
echo Would you like to download Super Mario All-Stars^+^+^? (SMAS^+^+)
echo.
echo It is recommended to download SMAS^+^+ here for future updating
echo and more stability.
echo.
echo If you want to download SMAS^+^+^, press 1 and then press enter.
echo To try again later, press 2 and enter to quit.
echo.
set dlsmas=
set /p dlsmas=
if not '%dlsmas%'=='' set choice=%choice:~0,1%
if '%dlsmas%'=='1' goto startdlsmas2
if '%dlsmas%'=='2' goto exitasap
ECHO "%dlsmas%" is not valid, try again
ECHO.
goto dlsmas

:dlsmbx2
cls
cd SMBX2
cd _smaslauncher
start cmdmp3win.exe bootLauncher_changecam.wav
echo To make the episode work, you'll need to install Super Mario Bros. X2.
echo.
echo Without Super Mario Bros. X2, this episode would not function and operate.
echo.
echo Please download SMBX2^ by pressing press 1, then press enter.
echo To start this later, press 2 and enter to quit and
echo try running this launcher again when you have time.
echo.
echo If you already downloaded SMBX2 but haven^'t installed it, move the installination
echo EXE to this folder ^(^_smaslauncher^) then press 3 and enter.
echo.
set dlsmbx=
set /p dlsmbx=
if not '%dlsmbx%'=='' set choice=%choice:~0,1%
if '%dlsmbx%'=='1' goto startdlsmbx2
if '%dlsmbx%'=='2' goto exitasap
if '%dlsmbx%'=='3' goto exeto7zip
ECHO "%dlsmbx%" is not valid, try again
ECHO.
goto dlsmbx2

:exitasap
exit

:startdlsmas2
cls
start cmdmp3win.exe bootLauncher_chosen.wav
echo Because of the size of SMAS^+^+, this download will take a while
echo depending on your Internet connection.
echo.
echo Make sure that you are in an fast internet connection hotspot,
echo then press enter when you are ready.
pause
start cmdmp3win.exe bootLauncher_dlSFX.wav
echo Now starting... DON^'T CLOSE THIS WINDOW^^, OR ELSE THE DOWNLOAD WILL FAIL^^!
cd..
cd data
cd worlds
mkdir "__PortableGit"
cd..
cd..
cd _smaslauncher
start /wait move_smbx2_exextracted.bat "SMBX2\_smaslauncher\__PortableGit\" "SMBX2\data\worlds\__PortableGit"
echo Make sure that the ^"^_^_PortableGit^" folder has moved to the worlds folder.
echo This is so that the episode can update whenever choosing to update on the launcher.
echo.
echo Press enter if the folder has been moved. If not, move it yourself.
pause
cd..
cd data
cd worlds
PING -n 5 127.0.0.1>nul
call __PortableGit\bin\git.exe init
call __PortableGit\bin\git.exe remote add origin https://github.com/SpencerEverly/smasplusplus.git
call __PortableGit\bin\git.exe pull origin main
echo Super Mario All-Stars^+^+ is now installed!
echo.
echo We still need to do some post-prequisites before letting you into the episode,
echo such as fixing the map to prevent crashes.
echo.
echo Press enter to begin.
pause
cd..
cd..
start /wait move_smbx2_exextracted.bat "SMBX2\_smaslauncher\__7zip\" "SMBX2\data\worlds\__7zip\"
echo Make sure the 7zip folder from the ^_smaslauncher folder has been moved to the
echo SMAS^+^+ episode folder, then press enter.
pause
cd..
cd data
cd worlds
cd "Super Mario All-Stars++"
__7zip\7zG.exe x "__World Map.7z" -aoa
cd..
cd "Where SMB Attacks"
__7zip\7zG.exe x "__World Map.7z" -aoa
cd..
cd..
cd..
cd _smaslauncher
start cmdmp3win.exe bootLauncher_coin.wav
echo Super Mario All-Stars^+^+ is now installed! If you are planning to also launch
echo Where SMB Attacks^, you can also extract the World Map to fix issues.
echo.
echo You'll need to manually extract it yourself though. Go to
echo data^/worlds^/Where SMB Attacks^, then overwrite ^_^_World Map.wld with 7zip.
echo.
echo Pressing enter will recheck dependencies. Make sure the episode is IN the
echo worlds folder before you press enter^^! ^(The PortableGit and 7zip folders in the
echo data and episode folders will be used for updating the episode, this is normal^.)
pause
goto start

:startdlsmbx2
cls
start cmdmp3win.exe bootLauncher_dlSFX.wav
echo Starting download... DO NOT QUIT, OR ELSE THIS WILL FAIL^^!
wget.exe -c "https://wohlsoft.ru/docs/SMBX2/SMBX2b4.4.1 Installer.exe"
echo If the download finished without errors, press enter. If it errored out, close this window and
echo try again.
echo.
pause
goto exeto7zip

:exeto7zip
echo Moving file to the 7zip folder...
move "SMBX2b4.4.1 Installer.exe" "7zip_smbx2\"
goto choosesmbx2install

:choosesmbx2install
cls
start cmdmp3win.exe bootLauncher_coin.wav
echo SMBX2 downloaded^^! There are two options you can use to install SMBX2^:
echo.
echo 1. Official installination^: This uses Admin rights to use the mklink commands, which stabilizes the installination.
echo Do this option to prevent any reading errors (From episodes such as the Mario Challenge) from happening.
echo.
echo 2. EXE extraction^: For users who don't want to use admin rights or for anyone who is on a public computer.
echo This may have errors on SMAS^+^+, with the Mario Challenge not working as intended. This is also an experimental
echo feature^, so only use this if you know what you^'re doing.
echo.
echo Select an option by pressing 1 or 2, then press enter.
set smbx2installoption=
set /p smbx2installoption=
if not '%smbx2installoption%'=='' set choice=%choice:~0,1%
if '%smbx2installoption%'=='1' goto officialinstallengine
if '%smbx2installoption%'=='2' goto extractexe
ECHO "%smbx2installoption%" is not valid, try again
ECHO.
goto choosesmbx2install

:officialinstallengine
cls
start cmdmp3win.exe bootLauncher_chosen.wav
echo The EXE should run with admin rights activated^^! When a prompt appears press ^"Yes^" to
echo start the installination. When the program has closed, this program will recheck dependencies.
echo.
echo Install SMBX2 to the folder BEFORE the SMBX2 folder^, or this launcher will still say
echo that SMBX2 doesn't exist^^!
echo.
echo After installing^, the window will automatically update.
echo.
cd 7zip_smbx2
set smbx2exe=SMBX2b4.4.1 Installer.exe
"%smbx2exe%"
cd..
echo Has it finished without errors^? Press enter. If it errored out, close this window and
echo try again.
echo.
echo Pressing enter will recheck dependencies. Make sure SMBX2.exe is IN the
echo SMBX2 folder before you press enter^^!
pause
goto start

:extractexe
cls
start cmdmp3win.exe bootLauncher_chosen.wav
echo You have selected the extract option. After extracting^, you can rename the
echo SMBX2 folder to anything you want.
echo.
echo To start extracting^, press enter.
pause
echo Renaming EXE...
cd 7zip_smbx2
rename "SMBX2b4.4.1 Installer.exe" "SMBX2_Installer.exe"
echo Extracting EXE...
7zG.exe x "SMBX2_Installer.exe"
echo Moving the SMBX2 folder to the folder before ^"smaslauncher^"...
cd..
start /wait move_smbx2_exextracted.bat "SMBX2\_smaslauncher\7zip\SMBX2\" "SMBX2\"
echo Renaming the EXE back to normal...
cd SMBX2
cd _smaslauncher
cd 7zip_smbx2
rename "SMBX2_Installer.exe" "SMBX2b4.4.1 Installer.exe"
cd..
cd..
cd data
cd worlds
cd "Super Mario All-Stars"""
copy "Remove this file if you're playing SMAS on an official installination" exeextracted.txt
cd..
cd..
cd..
cd _smaslauncher
start cmdmp3win.exe bootLauncher_coin.wav
echo Done. Dependencies will now be rechecked in 5 seconds.
@timeout 5 /nobreak>nul
cls
goto start

:autoboot1
cls
set a=^&^#61^;
mode con:cols=80 lines=30
color 06
start cmdmp3win.exe bootLauncher_changecam.wav
echo v1.6.5
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
set s=Autoboot SMAS^+^+ with Mario in Save Slot 1^? Type Y and
for /L %%# in (1,2,!size!) do if "!s:~%size%,1!" == "" set "s= !s! "
set s=!s:~1,%size%!& echo(!s!
set s=press enter. You can skip this by pressing any other key.
for /L %%# in (1,2,!size!) do if "!s:~%size%,1!" == "" set "s= !s! "
set s=!s:~1,%size%!& echo(!s!
echo.
set /p autoboot1=
if /I "%autoboot1%"=="y" goto loadgame1
if /I "%autoboot1%"=="Y" goto loadgame1
if /I "%autoboot1%"=="" goto simplelaunch

:updatesmas
cls
@timeout 1 /nobreak>nul
echo Checking for SMAS^+^+ updates...
@timeout 0 /nobreak>nul
cd..
cd data
cd worlds
if not exist .git ( goto nogit )

:yesgit
cls
cd..
cd..
cd _smaslauncher
cmdmp3win.exe bootLauncher_2playermode.wav
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
set s=Here you can download the latest updates and releases.
for /L %%# in (1,2,!size!) do if "!s:~%size%,1!" == "" set "s= !s! "
set s=!s:~1,%size%!& echo(!s!
echo.
set s=Enter 1 to update the episode.
for /L %%# in (1,2,!size!) do if "!s:~%size%,1!" == "" set "s= !s! "
set s=!s:~1,%size%!& echo(!s!
set s=Enter 0 to return to the main menu.
for /L %%# in (1,2,!size!) do if "!s:~%size%,1!" == "" set "s= !s! "
set s=!s:~1,%size%!& echo(!s!
echo.
set /p autoboot1=
if /I "%autoboot1%"=="1" goto updatesmas2
if /I "%autoboot1%"=="2" goto simplelaunch
if /I "%autoboot1%"=="" goto simplelaunch

:nogit
cls
echo Unfortnately, this updater only works if you have downloaded the episode
echo from this launcher ^(It's using git^).
echo.
echo Please redownload the episode from here and try again.
pause
goto simplelaunch

:updatesmas2
cls
cmdmp3win.exe bootLauncher_dlSFX.wav
echo Pulling the latest update from GitHub...
cd..
cd data
cd worlds
call __PortableGit\bin\git.exe fetch --all
call __PortableGit\bin\git.exe reset --hard
call __PortableGit\bin\git.exe pull origin main
cls
cd "Super Mario All-Stars++"
__7zip\7zG.exe x "__World Map.7z" -aoa
cd..
cd "Where SMB Attacks"
__7zip\7zG.exe x "__World Map.7z" -aoa
cd..
cd..
cd..
cd _smaslauncher
echo The episode has been updated^^! Restarting in 5 seconds...
echo.
echo ^(To launch Where SMB Attacks^, you'll have to extract the 7z file in
echo the worlds folder and overwrite the world file manually. The file
echo is ^"^_^_World Map.7z^")
@timeout 5 /nobreak>nul
cls
goto start


:simplelaunch
cls
set a=^&^#61^;
mode con:cols=80 lines=30
color 06
start cmdmp3win.exe bootLauncher_start.wav
echo v2.0.6
echo.
echo.
set s=Hello^^! Welcome to the Super Mario All-Stars^+^+ launcher.
for /L %%# in (1,2,!size!) do if "!s:~%size%,1!" == "" set "s= !s! "
set s=!s:~1,%size%!& echo(!s!
set s=This is the most recommended launcher to receive new updates and
for /L %%# in (1,2,!size!) do if "!s:~%size%,1!" == "" set "s= !s! "
set s=!s:~1,%size%!& echo(!s!
set s=launch the game.
for /L %%# in (1,2,!size!) do if "!s:~%size%,1!" == "" set "s= !s! "
set s=!s:~1,%size%!& echo(!s!
echo.
set s=Make sure to configurate inputs using SMBX2.exe before using this launcher.
for /L %%# in (1,2,!size!) do if "!s:~%size%,1!" == "" set "s= !s! "
set s=!s:~1,%size%!& echo(!s!
echo.
set s=^-^-^-^-^-^-^-^-^-^-^-^-
for /L %%# in (1,2,!size!) do if "!s:~%size%,1!" == "" set "s= !s! "
set s=!s:~1,%size%!& echo(!s!
echo.
set s=Start^: Select manually from any save slot^, character^, episode^,
for /L %%# in (1,2,!size!) do if "!s:~%size%,1!" == "" set "s= !s! "
set s=!s:~1,%size%!& echo(!s!
set s=and other settings.
for /L %%# in (1,2,!size!) do if "!s:~%size%,1!" == "" set "s= !s! "
set s=!s:~1,%size%!& echo(!s!
set s=Start1^-9^: For loading any slot from 1 to 9, type up ^"Start1^",
for /L %%# in (1,2,!size!) do if "!s:~%size%,1!" == "" set "s= !s! "
set s=!s:~1,%size%!& echo(!s!
set s=^"Start2^", ^"Start3^"^, up to ^"Start9^". This will load up the slot
for /L %%# in (1,2,!size!) do if "!s:~%size%,1!" == "" set "s= !s! "
set s=!s:~1,%size%!& echo(!s!
set s=with Mario as the default character (SMAS^+^+ only).
for /L %%# in (1,2,!size!) do if "!s:~%size%,1!" == "" set "s= !s! "
set s=!s:~1,%size%!& echo(!s!
set s=DemoMode^: Load SMAS^+^+ without any saves. The slot^/character setup
for /L %%# in (1,2,!size!) do if "!s:~%size%,1!" == "" set "s= !s! "
set s=!s:~1,%size%!& echo(!s!
set s=is also similiar to Start1^-3 (SMAS^+^+ only).
for /L %%# in (1,2,!size!) do if "!s:~%size%,1!" == "" set "s= !s! "
set s=!s:~1,%size%!& echo(!s!
set s=CustomLoad^1^-9: Load any episode of your choice^^! Default settings
for /L %%# in (1,2,!size!) do if "!s:~%size%,1!" == "" set "s= !s! "
set s=!s:~1,%size%!& echo(!s!
set s=from Start1^-9 will apply. To load with custom settings, use ^"Start^".
for /L %%# in (1,2,!size!) do if "!s:~%size%,1!" == "" set "s= !s! "
set s=!s:~1,%size%!& echo(!s!
set s=UpdateSMAS: Update SMAS^+^+ to the latest version^^! Make sure you
for /L %%# in (1,2,!size!) do if "!s:~%size%,1!" == "" set "s= !s! "
set s=!s:~1,%size%!& echo(!s!
set s=have downloaded the episode from the launcher first.
for /L %%# in (1,2,!size!) do if "!s:~%size%,1!" == "" set "s= !s! "
set s=!s:~1,%size%!& echo(!s!
echo.
set s=^-^-^-^-^-^-^-^-^-^-^-^-
for /L %%# in (1,2,!size!) do if "!s:~%size%,1!" == "" set "s= !s! "
set s=!s:~1,%size%!& echo(!s!
echo.
set s=To officially load any episode^, please use ^"SMBX2.exe^".
for /L %%# in (1,2,!size!) do if "!s:~%size%,1!" == "" set "s= !s! "
set s=!s:~1,%size%!& echo(!s!
set s=To exit this launcher, type up ^"Exit^" and press enter.
for /L %%# in (1,2,!size!) do if "!s:~%size%,1!" == "" set "s= !s! "
set s=!s:~1,%size%!& echo(!s!
set simplelaunch=
set /p simplelaunch=
if not '%simplelaunch%'=='' set choice=%choice:~0,1%
if '%simplelaunch%'=='start1' goto loadgame1
if '%simplelaunch%'=='Start1' goto loadgame1
if '%simplelaunch%'=='START1' goto loadgame1
if '%simplelaunch%'=='start2' goto loadgame2
if '%simplelaunch%'=='Start2' goto loadgame2
if '%simplelaunch%'=='START2' goto loadgame2
if '%simplelaunch%'=='start3' goto loadgame3
if '%simplelaunch%'=='Start3' goto loadgame3
if '%simplelaunch%'=='START3' goto loadgame3
if '%simplelaunch%'=='start4' goto loadgame4
if '%simplelaunch%'=='Start4' goto loadgame4
if '%simplelaunch%'=='START4' goto loadgame4
if '%simplelaunch%'=='start5' goto loadgame5
if '%simplelaunch%'=='Start5' goto loadgame5
if '%simplelaunch%'=='START5' goto loadgame5
if '%simplelaunch%'=='start6' goto loadgame6
if '%simplelaunch%'=='Start6' goto loadgame6
if '%simplelaunch%'=='START6' goto loadgame6
if '%simplelaunch%'=='start7' goto loadgame7
if '%simplelaunch%'=='Start7' goto loadgame7
if '%simplelaunch%'=='START7' goto loadgame7
if '%simplelaunch%'=='start8' goto loadgame8
if '%simplelaunch%'=='Start8' goto loadgame8
if '%simplelaunch%'=='START8' goto loadgame8
if '%simplelaunch%'=='start9' goto loadgame9
if '%simplelaunch%'=='Start9' goto loadgame9
if '%simplelaunch%'=='START9' goto loadgame9
if '%simplelaunch%'=='start' goto begin
if '%simplelaunch%'=='Start' goto begin
if '%simplelaunch%'=='START' goto begin
if '%simplelaunch%'=='demomode' goto demoload
if '%simplelaunch%'=='DemoMode' goto demoload
if '%simplelaunch%'=='Demomode' goto demoload
if '%simplelaunch%'=='demoMode' goto demoload
if '%simplelaunch%'=='DEMOMODE' goto demoload
if '%simplelaunch%'=='customload1' goto customload1
if '%simplelaunch%'=='CustomLoad1' goto customload1
if '%simplelaunch%'=='Customload1' goto customload1
if '%simplelaunch%'=='customLoad1' goto customload1
if '%simplelaunch%'=='CUSTOMLOAD1' goto customload1
if '%simplelaunch%'=='customload2' goto customload2
if '%simplelaunch%'=='CustomLoad2' goto customload2
if '%simplelaunch%'=='Customload2' goto customload2
if '%simplelaunch%'=='customLoad2' goto customload2
if '%simplelaunch%'=='CUSTOMLOAD2' goto customload2
if '%simplelaunch%'=='customload3' goto customload3
if '%simplelaunch%'=='CustomLoad3' goto customload3
if '%simplelaunch%'=='Customload3' goto customload3
if '%simplelaunch%'=='customLoad3' goto customload3
if '%simplelaunch%'=='CUSTOMLOAD3' goto customload3
if '%simplelaunch%'=='customload4' goto customload4
if '%simplelaunch%'=='CustomLoad4' goto customload4
if '%simplelaunch%'=='Customload4' goto customload4
if '%simplelaunch%'=='customLoad4' goto customload4
if '%simplelaunch%'=='CUSTOMLOAD4' goto customload4
if '%simplelaunch%'=='customload5' goto customload5
if '%simplelaunch%'=='CustomLoad5' goto customload5
if '%simplelaunch%'=='Customload5' goto customload5
if '%simplelaunch%'=='customLoad5' goto customload5
if '%simplelaunch%'=='CUSTOMLOAD5' goto customload5
if '%simplelaunch%'=='customload6' goto customload6
if '%simplelaunch%'=='CustomLoad6' goto customload6
if '%simplelaunch%'=='Customload6' goto customload6
if '%simplelaunch%'=='customLoad6' goto customload6
if '%simplelaunch%'=='CUSTOMLOAD6' goto customload6
if '%simplelaunch%'=='customload7' goto customload7
if '%simplelaunch%'=='CustomLoad7' goto customload7
if '%simplelaunch%'=='Customload7' goto customload7
if '%simplelaunch%'=='customLoad7' goto customload7
if '%simplelaunch%'=='CUSTOMLOAD7' goto customload7
if '%simplelaunch%'=='customload8' goto customload8
if '%simplelaunch%'=='CustomLoad8' goto customload8
if '%simplelaunch%'=='Customload8' goto customload8
if '%simplelaunch%'=='customLoad8' goto customload8
if '%simplelaunch%'=='CUSTOMLOAD8' goto customload8
if '%simplelaunch%'=='customload9' goto customload9
if '%simplelaunch%'=='CustomLoad9' goto customload9
if '%simplelaunch%'=='Customload9' goto customload9
if '%simplelaunch%'=='customLoad9' goto customload9
if '%simplelaunch%'=='CUSTOMLOAD9' goto customload9
if '%simplelaunch%'=='LevelTest' goto testlevel
if '%simplelaunch%'=='leveltest' goto testlevel
if '%simplelaunch%'=='Leveltest' goto testlevel
if '%simplelaunch%'=='levelTest' goto testlevel
if '%simplelaunch%'=='LEVELTEST' goto testlevel
if '%simplelaunch%'=='exit' goto exitlauncher
if '%simplelaunch%'=='Exit' goto exitlauncher
if '%simplelaunch%'=='EXIT' goto exitlauncher
if '%simplelaunch%'=='EXIt' goto exitlauncher
if '%simplelaunch%'=='EXit' goto exitlauncher
if '%simplelaunch%'=='eXit' goto exitlauncher
if '%simplelaunch%'=='exIt' goto exitlauncher
if '%simplelaunch%'=='exiT' goto exitlauncher
if '%simplelaunch%'=='eXIt' goto exitlauncher
if '%simplelaunch%'=='updatesmas' goto updatesmas
if '%simplelaunch%'=='Updatesmas' goto updatesmas
if '%simplelaunch%'=='updateSMAS' goto updatesmas
if '%simplelaunch%'=='UpdateSMAS' goto updatesmas
ECHO "%simplelaunch%" is not valid, try again
ECHO.
goto simplelaunch

:begin
cls
start cmdmp3win.exe bootLauncher_saveslot1.wav
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
set s=Welcome^^! Here you can set some settings before
for /L %%# in (1,2,!size!) do if "!s:~%size%,1!" == "" set "s= !s! "
set s=!s:~1,%size%!& echo(!s!
set s=loading the game engine.
for /L %%# in (1,2,!size!) do if "!s:~%size%,1!" == "" set "s= !s! "
set s=!s:~1,%size%!& echo(!s!
echo.
set s=Which save slot do you want to use^? Max is 32,767.
for /L %%# in (1,2,!size!) do if "!s:~%size%,1!" == "" set "s= !s! "
set s=!s:~1,%size%!& echo(!s!
set s=Please enter with no commas, this is important to not do so.
for /L %%# in (1,2,!size!) do if "!s:~%size%,1!" == "" set "s= !s! "
set s=!s:~1,%size%!& echo(!s!
set s=Also note that this detects any input, so ONLY type up numbers^^!
for /L %%# in (1,2,!size!) do if "!s:~%size%,1!" == "" set "s= !s! "
set s=!s:~1,%size%!& echo(!s!
echo.
set s=(To go back, type ^"Back", no quotes)
for /L %%# in (1,2,!size!) do if "!s:~%size%,1!" == "" set "s= !s! "
set s=!s:~1,%size%!& echo(!s!
echo.
set slotnumber=
set /p slotnumber=
if '%slotnumber%'=='' goto character
if '%slotnumber%'=='back' goto simplelaunch
if '%slotnumber%'=='Back' goto simplelaunch

:character

start cmdmp3win.exe bootLauncher_character2.wav
cls
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
set s=Choose from one of the following characters to load for the episode^:
for /L %%# in (1,2,!size!) do if "!s:~%size%,1!" == "" set "s= !s! "
set s=!s:~1,%size%!& echo(!s!
set s=^| Mario ^= 1 ^| Luigi ^= 2 ^| Peach ^= 3 ^| Toad ^= 4 ^| Link ^= 5 ^|
for /L %%# in (1,2,!size!) do if "!s:~%size%,1!" == "" set "s= !s! "
set s=!s:~1,%size%!& echo(!s!
set s=You'll need to type up the number, not the name.
for /L %%# in (1,2,!size!) do if "!s:~%size%,1!" == "" set "s= !s! "
set s=!s:~1,%size%!& echo(!s!
echo.
set s=Only the first five shown can be used, the X2 characters
for /L %%# in (1,2,!size!) do if "!s:~%size%,1!" == "" set "s= !s! "
set s=!s:~1,%size%!& echo(!s!
set s=load after boot because of LunaLua execution.
for /L %%# in (1,2,!size!) do if "!s:~%size%,1!" == "" set "s= !s! "
set s=!s:~1,%size%!& echo(!s!
echo.
set character=
set /p character=
if not '%character%'=='' set choice=%choice:~0,1%
if '%character%'=='1' goto gameselect
if '%character%'=='2' goto gameselect
if '%character%'=='3' goto gameselect
if '%character%'=='4' goto gameselect
if '%character%'=='5' goto gameselect
ECHO "%character%" is not valid, try again
ECHO.
goto character

:gameselect
cls

start cmdmp3win.exe bootLauncher_preload6.wav
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
set s=Which game do you want to load^?
for /L %%# in (1,2,!size!) do if "!s:~%size%,1!" == "" set "s= !s! "
set s=!s:~1,%size%!& echo(!s!
echo.
set s=Type 1 for Super Mario All^-Stars^+^+^,
for /L %%# in (1,2,!size!) do if "!s:~%size%,1!" == "" set "s= !s! "
set s=!s:~1,%size%!& echo(!s!
set s=Type 2 for ^Where SMB Attacks,
for /L %%# in (1,2,!size!) do if "!s:~%size%,1!" == "" set "s= !s! "
set s=!s:~1,%size%!& echo(!s!
set s=Type 3 for the Mario Challenge,
for /L %%# in (1,2,!size!) do if "!s:~%size%,1!" == "" set "s= !s! "
set s=!s:~1,%size%!& echo(!s!
set s=Type 4 for the X2 Demo Stages,
for /L %%# in (1,2,!size!) do if "!s:~%size%,1!" == "" set "s= !s! "
set s=!s:~1,%size%!& echo(!s!
set s=Type 5 for The Invasion 2,
for /L %%# in (1,2,!size!) do if "!s:~%size%,1!" == "" set "s= !s! "
set s=!s:~1,%size%!& echo(!s!
set s=Or type 6 for The Princess Cliche.
for /L %%# in (1,2,!size!) do if "!s:~%size%,1!" == "" set "s= !s! "
set s=!s:~1,%size%!& echo(!s!
echo.
set s=You can also specify any episode below^^! You must specify the world
for /L %%# in (1,2,!size!) do if "!s:~%size%,1!" == "" set "s= !s! "
set s=!s:~1,%size%!& echo(!s!
set s=folder and world file (With extension) with quotes to load
for /L %%# in (1,2,!size!) do if "!s:~%size%,1!" == "" set "s= !s! "
set s=!s:~1,%size%!& echo(!s!
set s=the episode, or else this program will crash (Some episodes with ^"^^!^"
for /L %%# in (1,2,!size!) do if "!s:~%size%,1!" == "" set "s= !s! "
set s=!s:~1,%size%!& echo(!s!
set s=in the file^/folder name may not work).
for /L %%# in (1,2,!size!) do if "!s:~%size%,1!" == "" set "s= !s! "
set s=!s:~1,%size%!& echo(!s!
echo.
set game=
set /p game=
if '%game%'=='' goto unfocused
if '%game%'=='1' goto setsmas
if '%game%'=='2' goto setwsmba
if '%game%'=='3' goto setmchallenge
if '%game%'=='4' goto setx2demos
if '%game%'=='5' goto setti2
if '%game%'=='6' goto settpc

:unfocused
cls

start cmdmp3win.exe bootLauncher_unfocused3.wav
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
set s=Do you want to keep the game running while unfocused^?
for /L %%# in (1,2,!size!) do if "!s:~%size%,1!" == "" set "s= !s! "
set s=!s:~1,%size%!& echo(!s!
echo.
set s=Type 1 for yes, press enter for no (No quotes).
for /L %%# in (1,2,!size!) do if "!s:~%size%,1!" == "" set "s= !s! "
set s=!s:~1,%size%!& echo(!s!
echo.
set focusyesorno=
set /p focusyesorno=
if not '%focusyesorno%'=='' set choice=%choice:~0,1%
if '%focusyesorno%'=='1' goto remfocus
if '%focusyesorno%'=='' goto console1
ECHO "%focusyesorno%" is not valid, try again
ECHO.
goto unfocused

:remfocus

set focusyesorno=--runWhenUnfocused

goto console1

:console1
cls

start cmdmp3win.exe bootLauncher_console4.wav
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
set s=Do you want the console enabled^?
for /L %%# in (1,2,!size!) do if "!s:~%size%,1!" == "" set "s= !s! "
set s=!s:~1,%size%!& echo(!s!
echo.
set s=This is optional^, as this is for debugging purposes.
for /L %%# in (1,2,!size!) do if "!s:~%size%,1!" == "" set "s= !s! "
set s=!s:~1,%size%!& echo(!s!
echo.
set s=Type ^"1^" for yes, press enter for no (No quotes).
for /L %%# in (1,2,!size!) do if "!s:~%size%,1!" == "" set "s= !s! "
set s=!s:~1,%size%!& echo(!s!
echo.
set consoleyesorno=
set /p consoleyesorno=
if not '%consoleyesorno%'=='' set choice=%choice:~0,1%
if '%consoleyesorno%'=='1' goto remcon
if '%consoleyesorno%'=='' goto opengl
ECHO "%consoleyesorno%" is not valid, try again
ECHO.
goto console1

:remcon

set consoleyesorno=--console

goto opengl

:opengl
cls

start cmdmp3win.exe bootLauncher_opengl5.wav
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
set s=One more thing before we let you check what you selected.
for /L %%# in (1,2,!size!) do if "!s:~%size%,1!" == "" set "s= !s! "
set s=!s:~1,%size%!& echo(!s!
echo.
set s=Do you want OpenGL enabled^?
for /L %%# in (1,2,!size!) do if "!s:~%size%,1!" == "" set "s= !s! "
set s=!s:~1,%size%!& echo(!s!
echo.
set s=Type ^"1^" for yes, press enter for no (No quotes).
for /L %%# in (1,2,!size!) do if "!s:~%size%,1!" == "" set "s= !s! "
set s=!s:~1,%size%!& echo(!s!
echo.
set openglyesorno=
set /p openglyesorno=
if not '%openglyesorno%'=='' set choice=%choice:~0,1%
if '%openglyesorno%'=='1' goto remgl
if '%openglyesorno%'=='' goto check
ECHO "%openglyesorno%" is not valid, try again
ECHO.
goto console1

:remgl

set openglyesorno=--softGL

goto check

:check
cls

start cmdmp3win.exe bootLauncher_finalizeSettings.wav
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
set s=Please check if everything is correct. (^"^^!^" means important)
for /L %%# in (1,2,!size!) do if "!s:~%size%,1!" == "" set "s= !s! "
set s=!s:~1,%size%!& echo(!s!
echo.
set s=Game and World File (^^!)^: %game%
for /L %%# in (1,2,!size!) do if "!s:~%size%,1!" == "" set "s= !s! "
set s=!s:~1,%size%!& echo(!s!
set s=Save slot (^^!)^: %slotnumber%
for /L %%# in (1,2,!size!) do if "!s:~%size%,1!" == "" set "s= !s! "
set s=!s:~1,%size%!& echo(!s!
set s=Character selected (ID^, ^^!): %character%
for /L %%# in (1,2,!size!) do if "!s:~%size%,1!" == "" set "s= !s! "
set s=!s:~1,%size%!& echo(!s!
set s=Unfocused^ (^-^-runWhenUnfocused, if nothing then no): %focusyesorno%
for /L %%# in (1,2,!size!) do if "!s:~%size%,1!" == "" set "s= !s! "
set s=!s:~1,%size%!& echo(!s!
set s=Add console^ (^-^-console, if nothing then no): %consoleyesorno%
for /L %%# in (1,2,!size!) do if "!s:~%size%,1!" == "" set "s= !s! "
set s=!s:~1,%size%!& echo(!s!
set s=OpenGL enabled^ (^-^-softGL^, if nothing then no): %openglyesorno%
for /L %%# in (1,2,!size!) do if "!s:~%size%,1!" == "" set "s= !s! "
set s=!s:~1,%size%!& echo(!s!
echo.
set s=Type ^"Yes^" if this is correct^, else type ^"No^" to go back.
for /L %%# in (1,2,!size!) do if "!s:~%size%,1!" == "" set "s= !s! "
set s=!s:~1,%size%!& echo(!s!
set complete=
set /p complete=
if not '%complete%'=='' set choice=%choice:~0,1%
if '%complete%'=='yes' goto loadgame
if '%complete%'=='no' goto simplelaunch
if '%complete%'=='Yes' goto loadgame
if '%complete%'=='No' goto simplelaunch
if '%complete%'=='YES' goto loadgame
if '%complete%'=='NO' goto simplelaunch
ECHO "%complete%" is not valid, try again
ECHO.
goto check

:customload1
cls

start cmdmp3win.exe bootLauncher_custom.wav
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
set s=You have selected save slot 1.
for /L %%# in (1,2,!size!) do if "!s:~%size%,1!" == "" set "s= !s! "
set s=!s:~1,%size%!& echo(!s!
set s=Type up the world folder and the map name below.
for /L %%# in (1,2,!size!) do if "!s:~%size%,1!" == "" set "s= !s! "
set s=!s:~1,%size%!& echo(!s!
echo.
set s=Please put it in quotes. The quotes, and the world map file^,
for /L %%# in (1,2,!size!) do if "!s:~%size%,1!" == "" set "s= !s! "
set s=!s:~1,%size%!& echo(!s!
set s=are important to load the episode. For setting save slots^,
for /L %%# in (1,2,!size!) do if "!s:~%size%,1!" == "" set "s= !s! "
set s=!s:~1,%size%!& echo(!s!
set s=and more settings, please use ^"Start^" instead.
for /L %%# in (1,2,!size!) do if "!s:~%size%,1!" == "" set "s= !s! "
set s=!s:~1,%size%!& echo(!s!
echo.
set s=(To go back, type ^"Back", no quotes)
for /L %%# in (1,2,!size!) do if "!s:~%size%,1!" == "" set "s= !s! "
set s=!s:~1,%size%!& echo(!s!
echo.
set game=
set /p game=
if '%game%'=='' goto customsettings1
if '%game%'=='back' goto simplelaunch
if '%game%'=='Back' goto simplelaunch

:customsettings1
set slotnumber=1
set character=1
%focusyesorno%'=='
%console1%'=='
%openglyesorno%'=='

goto loadgame

:customload2
cls

start cmdmp3win.exe bootLauncher_custom.wav
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
set s=You have selected save slot 2.
for /L %%# in (1,2,!size!) do if "!s:~%size%,1!" == "" set "s= !s! "
set s=!s:~1,%size%!& echo(!s!
set s=Type up the world folder and the map name below.
for /L %%# in (1,2,!size!) do if "!s:~%size%,1!" == "" set "s= !s! "
set s=!s:~1,%size%!& echo(!s!
echo.
set s=Please put it in quotes. The quotes, and the world map file^,
for /L %%# in (1,2,!size!) do if "!s:~%size%,1!" == "" set "s= !s! "
set s=!s:~1,%size%!& echo(!s!
set s=are important to load the episode. For setting save slots^,
for /L %%# in (1,2,!size!) do if "!s:~%size%,1!" == "" set "s= !s! "
set s=!s:~1,%size%!& echo(!s!
set s=and more settings, please use ^"Start^" instead.
for /L %%# in (1,2,!size!) do if "!s:~%size%,1!" == "" set "s= !s! "
set s=!s:~1,%size%!& echo(!s!
echo.
set s=(To go back, type ^"Back", no quotes)
for /L %%# in (1,2,!size!) do if "!s:~%size%,1!" == "" set "s= !s! "
set s=!s:~1,%size%!& echo(!s!
echo.
set game=
set /p game=
if '%game%'=='' goto customsettings2
if '%game%'=='back' goto simplelaunch
if '%game%'=='Back' goto simplelaunch

:customsettings2
set slotnumber=2
set character=1
%focusyesorno%'=='
%console1%'=='
%openglyesorno%'=='

goto loadgame

:customload3
cls

start cmdmp3win.exe bootLauncher_custom.wav
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
set s=You have selected save slot 3.
for /L %%# in (1,2,!size!) do if "!s:~%size%,1!" == "" set "s= !s! "
set s=!s:~1,%size%!& echo(!s!
set s=Type up the world folder and the map name below.
for /L %%# in (1,2,!size!) do if "!s:~%size%,1!" == "" set "s= !s! "
set s=!s:~1,%size%!& echo(!s!
echo.
set s=Please put it in quotes. The quotes, and the world map file^,
for /L %%# in (1,2,!size!) do if "!s:~%size%,1!" == "" set "s= !s! "
set s=!s:~1,%size%!& echo(!s!
set s=are important to load the episode. For setting save slots^,
for /L %%# in (1,2,!size!) do if "!s:~%size%,1!" == "" set "s= !s! "
set s=!s:~1,%size%!& echo(!s!
set s=and more settings, please use ^"Start^" instead.
for /L %%# in (1,2,!size!) do if "!s:~%size%,1!" == "" set "s= !s! "
set s=!s:~1,%size%!& echo(!s!
echo.
set s=(To go back, type ^"Back", no quotes)
for /L %%# in (1,2,!size!) do if "!s:~%size%,1!" == "" set "s= !s! "
set s=!s:~1,%size%!& echo(!s!
echo.
set game=
set /p game=
if '%game%'=='' goto customsettings3
if '%game%'=='back' goto simplelaunch
if '%game%'=='Back' goto simplelaunch

:customsettings3
set slotnumber=3
set character=1
%focusyesorno%'=='
%console1%'=='
%openglyesorno%'=='

goto loadgame

:customload4
cls

start cmdmp3win.exe bootLauncher_custom.wav
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
set s=You have selected save slot 4.
for /L %%# in (1,2,!size!) do if "!s:~%size%,1!" == "" set "s= !s! "
set s=!s:~1,%size%!& echo(!s!
set s=Type up the world folder and the map name below.
for /L %%# in (1,2,!size!) do if "!s:~%size%,1!" == "" set "s= !s! "
set s=!s:~1,%size%!& echo(!s!
echo.
set s=Please put it in quotes. The quotes, and the world map file^,
for /L %%# in (1,2,!size!) do if "!s:~%size%,1!" == "" set "s= !s! "
set s=!s:~1,%size%!& echo(!s!
set s=are important to load the episode. For setting save slots^,
for /L %%# in (1,2,!size!) do if "!s:~%size%,1!" == "" set "s= !s! "
set s=!s:~1,%size%!& echo(!s!
set s=and more settings, please use ^"Start^" instead.
for /L %%# in (1,2,!size!) do if "!s:~%size%,1!" == "" set "s= !s! "
set s=!s:~1,%size%!& echo(!s!
echo.
set s=(To go back, type ^"Back", no quotes)
for /L %%# in (1,2,!size!) do if "!s:~%size%,1!" == "" set "s= !s! "
set s=!s:~1,%size%!& echo(!s!
echo.
set game=
set /p game=
if '%game%'=='' goto customsettings4
if '%game%'=='back' goto simplelaunch
if '%game%'=='Back' goto simplelaunch

:customsettings4
set slotnumber=4
set character=1
%focusyesorno%'=='
%console1%'=='
%openglyesorno%'=='

goto loadgame

:customload5
cls

start cmdmp3win.exe bootLauncher_custom.wav
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
set s=You have selected save slot 5.
for /L %%# in (1,2,!size!) do if "!s:~%size%,1!" == "" set "s= !s! "
set s=!s:~1,%size%!& echo(!s!
set s=Type up the world folder and the map name below.
for /L %%# in (1,2,!size!) do if "!s:~%size%,1!" == "" set "s= !s! "
set s=!s:~1,%size%!& echo(!s!
echo.
set s=Please put it in quotes. The quotes, and the world map file^,
for /L %%# in (1,2,!size!) do if "!s:~%size%,1!" == "" set "s= !s! "
set s=!s:~1,%size%!& echo(!s!
set s=are important to load the episode. For setting save slots^,
for /L %%# in (1,2,!size!) do if "!s:~%size%,1!" == "" set "s= !s! "
set s=!s:~1,%size%!& echo(!s!
set s=and more settings, please use ^"Start^" instead.
for /L %%# in (1,2,!size!) do if "!s:~%size%,1!" == "" set "s= !s! "
set s=!s:~1,%size%!& echo(!s!
echo.
set s=(To go back, type ^"Back", no quotes)
for /L %%# in (1,2,!size!) do if "!s:~%size%,1!" == "" set "s= !s! "
set s=!s:~1,%size%!& echo(!s!
echo.
set game=
set /p game=
if '%game%'=='' goto customsettings5
if '%game%'=='back' goto simplelaunch
if '%game%'=='Back' goto simplelaunch

:customsettings5
set slotnumber=5
set character=1
%focusyesorno%'=='
%console1%'=='
%openglyesorno%'=='

goto loadgame

:customload6
cls

start cmdmp3win.exe bootLauncher_custom.wav
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
set s=You have selected save slot 6.
for /L %%# in (1,2,!size!) do if "!s:~%size%,1!" == "" set "s= !s! "
set s=!s:~1,%size%!& echo(!s!
set s=Type up the world folder and the map name below.
for /L %%# in (1,2,!size!) do if "!s:~%size%,1!" == "" set "s= !s! "
set s=!s:~1,%size%!& echo(!s!
echo.
set s=Please put it in quotes. The quotes, and the world map file^,
for /L %%# in (1,2,!size!) do if "!s:~%size%,1!" == "" set "s= !s! "
set s=!s:~1,%size%!& echo(!s!
set s=are important to load the episode. For setting save slots^,
for /L %%# in (1,2,!size!) do if "!s:~%size%,1!" == "" set "s= !s! "
set s=!s:~1,%size%!& echo(!s!
set s=and more settings, please use ^"Start^" instead.
for /L %%# in (1,2,!size!) do if "!s:~%size%,1!" == "" set "s= !s! "
set s=!s:~1,%size%!& echo(!s!
echo.
set s=(To go back, type ^"Back", no quotes)
for /L %%# in (1,2,!size!) do if "!s:~%size%,1!" == "" set "s= !s! "
set s=!s:~1,%size%!& echo(!s!
echo.
set game=
set /p game=
if '%game%'=='' goto customsettings6
if '%game%'=='back' goto simplelaunch
if '%game%'=='Back' goto simplelaunch

:customsettings6
set slotnumber=6
set character=1
%focusyesorno%'=='
%console1%'=='
%openglyesorno%'=='

goto loadgame

:customload7
cls

start cmdmp3win.exe bootLauncher_custom.wav
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
set s=You have selected save slot 7.
for /L %%# in (1,2,!size!) do if "!s:~%size%,1!" == "" set "s= !s! "
set s=!s:~1,%size%!& echo(!s!
set s=Type up the world folder and the map name below.
for /L %%# in (1,2,!size!) do if "!s:~%size%,1!" == "" set "s= !s! "
set s=!s:~1,%size%!& echo(!s!
echo.
set s=Please put it in quotes. The quotes, and the world map file^,
for /L %%# in (1,2,!size!) do if "!s:~%size%,1!" == "" set "s= !s! "
set s=!s:~1,%size%!& echo(!s!
set s=are important to load the episode. For setting save slots^,
for /L %%# in (1,2,!size!) do if "!s:~%size%,1!" == "" set "s= !s! "
set s=!s:~1,%size%!& echo(!s!
set s=and more settings, please use ^"Start^" instead.
for /L %%# in (1,2,!size!) do if "!s:~%size%,1!" == "" set "s= !s! "
set s=!s:~1,%size%!& echo(!s!
echo.
set s=(To go back, type ^"Back", no quotes)
for /L %%# in (1,2,!size!) do if "!s:~%size%,1!" == "" set "s= !s! "
set s=!s:~1,%size%!& echo(!s!
echo.
set game=
set /p game=
if '%game%'=='' goto customsettings7
if '%game%'=='back' goto simplelaunch
if '%game%'=='Back' goto simplelaunch

:customsettings7
set slotnumber=7
set character=1
%focusyesorno%'=='
%console1%'=='
%openglyesorno%'=='

goto loadgame

:customload8
cls

start cmdmp3win.exe bootLauncher_custom.wav
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
set s=You have selected save slot 8.
for /L %%# in (1,2,!size!) do if "!s:~%size%,1!" == "" set "s= !s! "
set s=!s:~1,%size%!& echo(!s!
set s=Type up the world folder and the map name below.
for /L %%# in (1,2,!size!) do if "!s:~%size%,1!" == "" set "s= !s! "
set s=!s:~1,%size%!& echo(!s!
echo.
set s=Please put it in quotes. The quotes, and the world map file^,
for /L %%# in (1,2,!size!) do if "!s:~%size%,1!" == "" set "s= !s! "
set s=!s:~1,%size%!& echo(!s!
set s=are important to load the episode. For setting save slots^,
for /L %%# in (1,2,!size!) do if "!s:~%size%,1!" == "" set "s= !s! "
set s=!s:~1,%size%!& echo(!s!
set s=and more settings, please use ^"Start^" instead.
for /L %%# in (1,2,!size!) do if "!s:~%size%,1!" == "" set "s= !s! "
set s=!s:~1,%size%!& echo(!s!
echo.
set s=(To go back, type ^"Back", no quotes)
for /L %%# in (1,2,!size!) do if "!s:~%size%,1!" == "" set "s= !s! "
set s=!s:~1,%size%!& echo(!s!
echo.
set game=
set /p game=
if '%game%'=='' goto customsettings8
if '%game%'=='back' goto simplelaunch
if '%game%'=='Back' goto simplelaunch

:customsettings8
set slotnumber=8
set character=1
%focusyesorno%'=='
%console1%'=='
%openglyesorno%'=='

goto loadgame

:customload9
cls

start cmdmp3win.exe bootLauncher_custom.wav
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
set s=You have selected save slot 9.
for /L %%# in (1,2,!size!) do if "!s:~%size%,1!" == "" set "s= !s! "
set s=!s:~1,%size%!& echo(!s!
set s=Type up the world folder and the map name below.
for /L %%# in (1,2,!size!) do if "!s:~%size%,1!" == "" set "s= !s! "
set s=!s:~1,%size%!& echo(!s!
echo.
set s=Please put it in quotes. The quotes, and the world map file^,
for /L %%# in (1,2,!size!) do if "!s:~%size%,1!" == "" set "s= !s! "
set s=!s:~1,%size%!& echo(!s!
set s=are important to load the episode. For setting save slots^,
for /L %%# in (1,2,!size!) do if "!s:~%size%,1!" == "" set "s= !s! "
set s=!s:~1,%size%!& echo(!s!
set s=and more settings, please use ^"Start^" instead.
for /L %%# in (1,2,!size!) do if "!s:~%size%,1!" == "" set "s= !s! "
set s=!s:~1,%size%!& echo(!s!
echo.
set s=(To go back, type ^"Back", no quotes)
for /L %%# in (1,2,!size!) do if "!s:~%size%,1!" == "" set "s= !s! "
set s=!s:~1,%size%!& echo(!s!
echo.
set game=
set /p game=
if '%game%'=='' goto customsettings9
if '%game%'=='back' goto simplelaunch
if '%game%'=='Back' goto simplelaunch

:customsettings9
set slotnumber=9
set character=1
%focusyesorno%'=='
%console1%'=='
%openglyesorno%'=='

goto loadgame

:loadgame1

set slotnumber=1
set character=1
set game="Super Mario All-Stars++/__World Map.wld"
%focusyesorno%'=='
%console1%'=='
%openglyesorno%'=='

goto loadgame

:loadgame2

set slotnumber=2
set character=1
set game="Super Mario All-Stars++/__World Map.wld"
%focusyesorno%'=='
%console1%'=='
%openglyesorno%'=='

goto loadgame

:loadgame3

set slotnumber=3
set character=1
set game="Super Mario All-Stars++/__World Map.wld"
%focusyesorno%'=='
%console1%'=='
%openglyesorno%'=='

goto loadgame

:loadgame4

set slotnumber=4
set character=1
set game="Super Mario All-Stars++/__World Map.wld"
%focusyesorno%'=='
%console1%'=='
%openglyesorno%'=='

goto loadgame

:loadgame5

set slotnumber=5
set character=1
set game="Super Mario All-Stars++/__World Map.wld"
%focusyesorno%'=='
%console1%'=='
%openglyesorno%'=='

goto loadgame

:loadgame6

set slotnumber=6
set character=1
set game="Super Mario All-Stars++/__World Map.wld"
%focusyesorno%'=='
%console1%'=='
%openglyesorno%'=='

goto loadgame

:loadgame7

set slotnumber=7
set character=1
set game="Super Mario All-Stars++/__World Map.wld"
%focusyesorno%'=='
%console1%'=='
%openglyesorno%'=='

goto loadgame

:loadgame8

set slotnumber=8
set character=1
set game="Super Mario All-Stars++/__World Map.wld"
%focusyesorno%'=='
%console1%'=='
%openglyesorno%'=='

goto loadgame

:loadgame9

set slotnumber=9
set character=1
set game="Super Mario All-Stars++/__World Map.wld"
%focusyesorno%'=='
%console1%'=='
%openglyesorno%'=='

goto loadgame

:demoload

SET character=1
%focusyesorno%'=='
%console1%'=='
%openglyesorno%'=='

goto loadgamedemo

:setsmas
set game="Super Mario All-Stars++/__World Map.wld"

goto unfocused

:setwsmba
set game="Where SMB Attacks/__World Map.wld"

goto unfocused

:setmchallenge
set game="Mario Challenge/world.wld"

goto unfocused

:setx2demos
set game="Demo Stages/world.wld"

goto unfocused

:setti2
set game="the invasion 2/world.wld"

goto unfocused

:settpc
set game="cliche/world.wld"

goto unfocused

:testlevel

set slotnumber=1
set character=1
set game="SMBX Level Player/SMBX Level Player.wld"
%focusyesorno%'=='
%console1%'=='
%openglyesorno%'=='

goto loadgame

:loadgamedemo

start cmdmp3win.exe bootSound_noTHX.wav
cd..
cd data
cls
echo.
echo ^'^#^#^:^:^:^:^:^:^:'##^:^:^:^:'##^:'##^:^:^: ##^:^:^:^:'###^:^:^:^:'##^:^:^:^:^:^:^:'##^:^:^:^:'##^:^:^:^:'###^:^:^:^:
echo ^#^#^:^:^:^:^:^:^: ^#^#^:^:^:^: ^#^#^: ^#^#^#^:^: ^#^#^:^:^:'^#^# ^#^#^:^:^: ^#^#^:^:^:^:^:^:^: ^#^#^:^:^:^: ^#^#^:^:^:'^#^# ^#^#^:^:^:
echo ^#^#^:^:^:^:^:^:^: ^#^#^:^:^:^: ^#^#^: ^#^#^#^#^: ^#^#^:^:'^#^#^:. ^#^#^:^: ^#^#^:^:^:^:^:^:^: ^#^#^:^:^:^: ^#^#^:^:'^#^#^:. ^#^#^:^:
echo ^#^#^:^:^:^:^:^:^: ^#^#^:^:^:^: ^#^#^: ^#^# ^#^# ^#^#^:'^#^#^:^:^:. ^#^#^: ^#^#^:^:^:^:^:^:^: ^#^#^:^:^:^: ^#^#^:'^#^#^:^:^:. ^#^#^:
echo ^#^#^:^:^:^:^:^:^: ^#^#^:^:^:^: ^#^#^: ^#^#. ^#^#^#^#^: ^#^#^#^#^#^#^#^#^#^: ^#^#^:^:^:^:^:^:^: ^#^#^:^:^:^: ^#^#^: ^#^#^#^#^#^#^#^#^#^:
echo ^#^#^:^:^:^:^:^:^: ^#^#^:^:^:^: ^#^#^: ^#^#^:. ^#^#^#^: ^#^#.... ^#^#^: ^#^#^:^:^:^:^:^:^: ^#^#^:^:^:^: ^#^#^: ^#^#.... ^#^#^:
echo ^#^#^#^#^#^#^#^#^:. ^#^#^#^#^#^#^#^:^: ^#^#^:^:. ^#^#^: ^#^#^:^:^:^: ^#^#^: ^#^#^#^#^#^#^#^#^:. ^#^#^#^#^#^#^#^:^: ^#^#^:^:^:^: ^#^#^:
echo........^:^:^:.......^:^:^:..^:^:^:^:..^:^:..^:^:^:^:^:..^:^:........^:^:^:.......^:^:^:..^:^:^:^:^:..^:^:
echo     '^#^#^#^#^#^#^#^#^:'^#^#^:^:^: ^#^#^:^:'^#^#^#^#^#^#^:^:^:'^#^#^#^#^:'^#^#^:^:^: ^#^#^:'^#^#^#^#^#^#^#^#^:^:^:^:
echo     ^#^#.....^:^: ^#^#^#^:^: ^#^#^:'^#^#... ^#^#^:^:. ^#^#^:^: ^#^#^#^:^: ^#^#^: ^#^#.....^:^:^:^:^:
echo     ^#^#^:^:^:^:^:^:^: ^#^#^#^#^: ^#^#^: ^#^#^:^:^:..^:^:^:^: ^#^#^:^: ^#^#^#^#^: ^#^#^: ^#^#^:^:^:^:^:^:^:^:^:^:
echo     ^#^#^#^#^#^#^:^:^: ^#^# ^#^# ^#^#^: ^#^#^:^:'^#^#^#^#^:^: ^#^#^:^: ^#^# ^#^# ^#^#^: ^#^#^#^#^#^#^:^:^:^:^:^:
echo     ^#^#...^:^:^:^: ^#^#. ^#^#^#^#^: ^#^#^:^:^: ^#^#^:^:^: ^#^#^:^: ^#^#. ^#^#^#^#^: ^#^#...^:^:^:^:^:^:^:
echo     ^#^#^:^:^:^:^:^:^: ^#^#^:. ^#^#^#^: ^#^#^:^:^: ^#^#^:^:^: ^#^#^:^: ^#^#^:. ^#^#^#^: ^#^#^:^:^:^:^:^:^:^:^:^:
echo     ^#^#^#^#^#^#^#^#^: ^#^#^:^:. ^#^#^:. ^#^#^#^#^#^#^:^:^:'^#^#^#^#^: ^#^#^:^:. ^#^#^: ^#^#^#^#^#^#^#^#^:^:^:^:
echo     ........^:^:..^:^:^:^:..^:^:^:......^:^:^:^:....^:^:..^:^:^:^:..^:^:........^:^:^:^:^:
echo.
echo v0.7
echo.
echo After years of mining, disassembly, and hacks, we finally unveil the LunaLua(TM)
echo Engine.
echo Thanks to all those that supported SMBX over the years.
echo.
echo ^"America grew up listening to us. It still does.^" ^- Packard Bell
echo.
echo Test mode activated^^! Nothing will save in this session.
@timeout 0 /nobreak>nul
echo Reading SMBX.exe...
goto loaddirdemo

:loadgame

start cmdmp3win.exe bootSound_noTHX.wav
cd..
cd data
cls
echo.
echo ^'^#^#^:^:^:^:^:^:^:'##^:^:^:^:'##^:'##^:^:^: ##^:^:^:^:'###^:^:^:^:'##^:^:^:^:^:^:^:'##^:^:^:^:'##^:^:^:^:'###^:^:^:^:
echo ^#^#^:^:^:^:^:^:^: ^#^#^:^:^:^: ^#^#^: ^#^#^#^:^: ^#^#^:^:^:'^#^# ^#^#^:^:^: ^#^#^:^:^:^:^:^:^: ^#^#^:^:^:^: ^#^#^:^:^:'^#^# ^#^#^:^:^:
echo ^#^#^:^:^:^:^:^:^: ^#^#^:^:^:^: ^#^#^: ^#^#^#^#^: ^#^#^:^:'^#^#^:. ^#^#^:^: ^#^#^:^:^:^:^:^:^: ^#^#^:^:^:^: ^#^#^:^:'^#^#^:. ^#^#^:^:
echo ^#^#^:^:^:^:^:^:^: ^#^#^:^:^:^: ^#^#^: ^#^# ^#^# ^#^#^:'^#^#^:^:^:. ^#^#^: ^#^#^:^:^:^:^:^:^: ^#^#^:^:^:^: ^#^#^:'^#^#^:^:^:. ^#^#^:
echo ^#^#^:^:^:^:^:^:^: ^#^#^:^:^:^: ^#^#^: ^#^#. ^#^#^#^#^: ^#^#^#^#^#^#^#^#^#^: ^#^#^:^:^:^:^:^:^: ^#^#^:^:^:^: ^#^#^: ^#^#^#^#^#^#^#^#^#^:
echo ^#^#^:^:^:^:^:^:^: ^#^#^:^:^:^: ^#^#^: ^#^#^:. ^#^#^#^: ^#^#.... ^#^#^: ^#^#^:^:^:^:^:^:^: ^#^#^:^:^:^: ^#^#^: ^#^#.... ^#^#^:
echo ^#^#^#^#^#^#^#^#^:. ^#^#^#^#^#^#^#^:^: ^#^#^:^:. ^#^#^: ^#^#^:^:^:^: ^#^#^: ^#^#^#^#^#^#^#^#^:. ^#^#^#^#^#^#^#^:^: ^#^#^:^:^:^: ^#^#^:
echo........^:^:^:.......^:^:^:..^:^:^:^:..^:^:..^:^:^:^:^:..^:^:........^:^:^:.......^:^:^:..^:^:^:^:^:..^:^:
echo     '^#^#^#^#^#^#^#^#^:'^#^#^:^:^: ^#^#^:^:'^#^#^#^#^#^#^:^:^:'^#^#^#^#^:'^#^#^:^:^: ^#^#^:'^#^#^#^#^#^#^#^#^:^:^:^:
echo     ^#^#.....^:^: ^#^#^#^:^: ^#^#^:'^#^#... ^#^#^:^:. ^#^#^:^: ^#^#^#^:^: ^#^#^: ^#^#.....^:^:^:^:^:
echo     ^#^#^:^:^:^:^:^:^: ^#^#^#^#^: ^#^#^: ^#^#^:^:^:..^:^:^:^: ^#^#^:^: ^#^#^#^#^: ^#^#^: ^#^#^:^:^:^:^:^:^:^:^:^:
echo     ^#^#^#^#^#^#^:^:^: ^#^# ^#^# ^#^#^: ^#^#^:^:'^#^#^#^#^:^: ^#^#^:^: ^#^# ^#^# ^#^#^: ^#^#^#^#^#^#^:^:^:^:^:^:
echo     ^#^#...^:^:^:^: ^#^#. ^#^#^#^#^: ^#^#^:^:^: ^#^#^:^:^: ^#^#^:^: ^#^#. ^#^#^#^#^: ^#^#...^:^:^:^:^:^:^:
echo     ^#^#^:^:^:^:^:^:^: ^#^#^:. ^#^#^#^: ^#^#^:^:^: ^#^#^:^:^: ^#^#^:^: ^#^#^:. ^#^#^#^: ^#^#^:^:^:^:^:^:^:^:^:^:
echo     ^#^#^#^#^#^#^#^#^: ^#^#^:^:. ^#^#^:. ^#^#^#^#^#^#^:^:^:'^#^#^#^#^: ^#^#^:^:. ^#^#^: ^#^#^#^#^#^#^#^#^:^:^:^:
echo     ........^:^:..^:^:^:^:..^:^:^:......^:^:^:^:....^:^:..^:^:^:^:..^:^:........^:^:^:^:^:
echo.
echo v0.7
echo.
echo After years of mining, disassembly, and hacks, we finally unveil the LunaLua(TM)
echo Engine.
echo Thanks to all those that supported SMBX over the years.
echo.
echo ^"America grew up listening to us. It still does.^" ^- Packard Bell
echo.
@timeout 0 /nobreak>nul
echo Reading SMBX.exe...
goto loaddir

:restoffakestuff

echo Reading EXE pointer data...
echo sub^_40B9B0                                   .text 0040B9B0 0000001D 00000000 FFFFFFFC R F . . . . .
echo j^_^_^_vbaChkstk                                .text 0040BA60 00000006                   R . . . . . .
echo j^_^_^_vbaExceptHandler                         .text 0040BA66 00000006                   R . . . . . .
echo j^_^_adj^_fdiv^_m32                              .text 0040BA78 00000006 00000000 00000000 R . . . . T .
echo j^_^_adj^_fdiv^_m64                              .text 0040BA84 00000006 00000000 00000000 R . . . . . .
echo j^_^_adj^_fdiv^_r                                .text 0040BA8A 00000006                   R . . . . . .
echo j^_^_adj^_fdivr^_m64                             .text 0040BAA2 00000006 00000000 00000000 R . . . . . .
echo j^_DllFunctionCall                            .text 0040BAF0 00000006 00000000 00000000 R . . . . . .
echo j^_ThunRTMain                                 .text 0040BDD2 00000006                   R . . . . . .
echo DeclareKernel32^_Sleep                        .text 004240B4 00000019                   R . . . . . .
echo BitbltCall                                   .text 004242D0 00000019                   R . . . . T .
echo reading lunalua.dll...
@timeout 0 /nobreak>nul
cd ..
echo Executing hardcoded patches...
echo 93487659 34753978 56493785 69494954 93487659 34753978 56493785 69494954
echo 49674867 48763476 34674589 67306745 49876489 76489765 48974559 35436464
echo 47864587 75649492 49354756 84283424 58385644 97568945 68476458 33534646
echo 34957495 67489756 48765847 68476497 54697549 56456497 56497869 45354646
echo 93487659 34753978 56493785 69494954 93487659 34753978 56493785 69494954
echo 47864587 75649492 49354756 84283424 58385644 97568945 68476458 33534646
@timeout 0 /nobreak>nul
echo Patched^, now executing X2 overdrive^^!
echo Redigiting the engine...
@timeout 0 /nobreak>nul
echo 10 layered EXE .texts modded.
@timeout 0 /nobreak>nul
echo Opening window...
echo Loading graphics^/hardcoded^/hardcoded^-30^4.png...
echo Executing boot session in the engine...
goto fullydone

:loaddir

LunaLoader.exe --loadWorld=%game% --num-players=1 --saveslot=%slotnumber% --p1c=%character% %focusyesorno% %consoleyesorno% %openglyesorno%
goto restoffakestuff

:loaddirdemo

LunaLoader.exe --loadWorld="Super Mario All-Stars++/__World Map.wld" --num-players=1 --p1c=%character% %focusyesorno% %consoleyesorno% %openglyesorno%
goto restoffakestuff

:fullydone
cls
echo WE GAMING, GRAB THE CONTROLLER^^!
echo.
echo INFORMATION ABOUT SUPER MARIO ALL^-STARS^+^+ ^/ WHERE SMB ATTACKS
echo ^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-
echo If anything fails on either episode, contact spencer^.everly^@gmail.com^,
echo or submit a GitHub ticket over at the official page: 
echo https^:^/^/github.com^/SpencerEverly^/smasplusplus^/
echo.
echo If either episode fail on boot, please extract and overwrite the
echo wld file in the 7z file in either world.
echo.
echo If the engine itself has an error, crashes, or any other odd activity
echo occur^, it's out of my jurisdiction. Join https^:^/^/discord.gg^/cgVsmUX
echo and ask the Codehaus team about the issue.
echo.
echo Have fun playing^, and see you next time^^!
echo.
echo This window will automatically exit in 40 seconds. If you want to^,
echo you can screenshot this window before it closes to read the information
echo later. Use the Snipping Tool (Windows search), Lightshot
echo (https^:^/^/lightshot.us), or by just copying the text in this window
echo before it closes to read this message anytime^^!
@timeout 40 /nobreak>nul
exit

:missingaudio
echo You are missing cmdmp3win.exe in the ^"smaslauncher^" folder. The file is
echo important to play the sounds in this program.
echo.
echo Please redownload it from
echo https^:^/^/lawlessguy.wordpress.com^/2015^/06^/27^/update-to-a-command-line-mp3-player-for-windows^/
echo if the file was removed.
echo.
echo Until you place ^"cmdmp3win.exe^" into the specified folder, you cannot continue.
echo.
pause
exit

:missingwav
echo You are missing one or more WAV files in the ^"smaslauncher^" folder. Those files are
echo use to load with cmdmp3win.exe unless you want to remove the cmd stuff pertaining to it.
echo.
echo Please redownload the Super Mario All-Stars^+^+ launcher and see if the
echo issue is fixed. If the issue isn't fixed, email me at spencer.everly^@gmail.com.
echo.
echo Until you place all the WAVs into the specified folder, you cannot continue.
echo.
pause
exit

:wrongdirectory
cls
echo Because you don't have SMBX2, due to complicated reasons
echo the installer will generate a SMBX2 folder when installing.
echo.
echo Please rename the folder where you put ^"smaslauncher^" to
echo SMBX2 and then try again.
echo.
pause
exit

:missingtxt
cls
echo Uh oh. You are missing text files to load SMAS^+^+.
echo
echo Please generate txt files that have the names of the folder and
echo map file (With extension) and then try again.
echo.
pause
exit