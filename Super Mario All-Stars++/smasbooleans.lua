--smasBooleans.lua
--By Spencer Everly
local smasBooleans = {}

--**UPDATER OPTIONS**
--Whenever to skip the updater or not. If you're running a version of SMAS++ which is used for speedrunning purposes, or are using an archiac version and don't need to update it, tick this to true. This won't affect normal installs of SMBX2 users (Or while being on the Moondust Editor), so it doesn't matter if this is on or not.
smasBooleans.skipUpdater = true

--***DON'T SET WHAT IS BELOW UNLESS YOU KNOW WHAT YOU'RE DOING!!!!!!***

--Whenever to target players on the camera.
smasBooleans.targetPlayers = true
--Whenever to override targets on the camera with something else.
smasBooleans.overrideTargets = false
--This is set for the players running around on an intro theme.
smasBooleans.introModeActivated = false
--Whenever to override the music volume, which is set on the pause menu.
smasBooleans.overrideMusicVolume = false
--Whenever to reenable original spring compatibility/other Defines values.
smasBooleans.compatibilityMode13Mode = false
--Whenever to twirl or not, via the Twirl accessibility option.
smasBooleans.cantTwirl = false
--Whenever to toggle the extended inventory on or off if the compatibility option is turned on.
smasBooleans.toggleOffInventory = false
--Alternative way to disable the pause menu if pauseplus can't be required due to stack overflows.
smasBooleans.disablePauseMenu = false
--This is an indicator whenever the P-Switch/Stopwatch is active or not.
smasBooleans.pSwitchActive = false
smasBooleans.stopWatchActive = false
--Music muting booleans, used when muting music via Sound.muteMusic(section)
smasBooleans.musicMuted = false
smasBooleans.musicMutedTemporary = false
--This is set to true when 1.3 Mode multiplayer is on.
smasBooleans.multiplayerActive = false
--This is set when the main menu is active.
smasBooleans.isOnMainMenu = false
--This is set when Classic Battle Mode is active.
smasBooleans.classicBattleModeActive = false
--Whether a specified player has passed through the white sizable in SMB3 1-3. This only works on that level.
smasBooleans.activateWarpWhistleRoomWarp = {}
for i = 1,200 do
    smasBooleans.activateWarpWhistleRoomWarp[i] = false
end
--Whether the timer (At the last 2 digits) is the same or not. This doesn't count 00, but counts 11-99.
smasBooleans.isTimerInDoubleDigits = false
--Whether the player is in a level or not.
smasBooleans.isInLevel = false
--Whether the player is in the Hub or not.
smasBooleans.isInHub = false

return smasBooleans