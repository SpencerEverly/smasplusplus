--smasbooleans.lua
--By Spencer Everly
local smasbooleans = {}

--**UPDATER OPTIONS**
--Whenever to skip the updater or not. If you're running a version of SMAS++ which is used for speedrunning purposes, or are using an archiac version and don't need to update it, tick this to true. This won't affect normal installs of SMBX2 users (Or while being on the Moondust Editor), so it doesn't matter if this is on or not.
smasbooleans.skipUpdater = true

--***DON'T SET WHAT IS BELOW UNLESS YOU KNOW WHAT YOU'RE DOING!!!!!!***

--Whenever to target players on the camera.
smasbooleans.targetPlayers = true
--Whenever to override targets on the camera with something else.
smasbooleans.overrideTargets = false
--This is set for the players running around on an intro theme.
smasbooleans.introModeActivated = false
--Whenever to override the music volume, which is set on the pause menu.
smasbooleans.overrideMusicVolume = false
--Whenever to reenable original spring compatibility/other Defines values.
smasbooleans.compatibilityMode13Mode = false
--Whenever to twirl or not, via the Twirl accessibility option.
smasbooleans.cantTwirl = false
--Whenever to toggle the extended inventory on or off if the compatibility option is turned on.
smasbooleans.toggleOffInventory = false
--Alternative way to disable the pause menu if pauseplus can't be required due to stack overflows.
smasbooleans.disablePauseMenu = false
--This is an indicator whenever the P-Switch is active or not.
smasbooleans.pSwitchActive = false
--Music muting booleans, used when muting music via Sound.muteMusic(section)
smasbooleans.musicMuted = false
smasbooleans.musicMutedTemporary = false
--This is set to true when 1.3 Mode multiplayer is on.
smasbooleans.multiplayerActive = false

return smasbooleans