local littleDialogue = require("littleDialogue")
local playerManager = require("playerManager")
local inventory = require("customInventory")
local textplus = require("textplus")
local datetime = require("datetime")
local musicalchairs = require("musicalchairs")
local Routine = require("routine")
local extrasounds = require("extrasounds")
local anothercurrency = require("ShopSystem/anothercurrency")
local comboSounds = require("comboSounds")
local pausemenu2 = require("pausemenu2")
local rooms = require("rooms")
local smasdeathsystem = require("smasdeathsystem")

local dying = false;
local deathVisibleCount = 198;
local deathTimer = deathVisibleCount;
local earlyDeathCheck = 3;
local cooldown = 0
local timer_deathTimer;
local deltaTime = Routine.deltaTime
local deathDelay = lunatime.toTicks(1.2)
local deathTimer = deathDelay

local costumes = {}

local dependencies = {}

GameData.battlemodeactive = false

function p1teleportdoor()
	Routine.waitFrames(30)
	player:mem(0x140,FIELD_WORD,100)
	player2:mem(0x140,FIELD_WORD,100)
	Player(2):teleport(Player(1).x - 32, Player(1).y - 32, bottomCenterAligned)
end

function p2teleportdoor()
	Routine.waitFrames(30)
	player:mem(0x140,FIELD_WORD,100)
	player2:mem(0x140,FIELD_WORD,100)
	Player(1):teleport(Player(2).x - 32, Player(2).y - 32, bottomCenterAligned)
end

function dependencies.onInitAPI()
	registerEvent(dependencies, "onStart")
	registerEvent(dependencies, "onLoad")
	registerEvent(dependencies, "onTick")
	registerEvent(dependencies, "onDraw")
	registerEvent(dependencies, "onCameraUpdate")
	registerEvent(dependencies, "onInputUpdate")
end

local smb1buzzyswitch = false

GameData._smb1Levels = {
	"SMB1 - W-1, L-1.lvlx",
	"SMB1 - W-1, L-2.lvlx",
	"SMB1 - W-1, L-3.lvlx",
	"SMB1 - W-1, L-4.lvlx",
	"SMB1 - W-2, L-1.lvlx",
	"SMB1 - W-2, L-2.lvlx",
	"SMB1 - W-2, L-3.lvlx",
	"SMB1 - W-2, L-4.lvlx",
	"SMB1 - W-3, L-1.lvlx",
	"SMB1 - W-3, L-2.lvlx",
	"SMB1 - W-3, L-3.lvlx",
	"SMB1 - W-3, L-4.lvlx",
	"SMB1 - W-4, L-1.lvlx",
	"SMB1 - W-4, L-2.lvlx",
	"SMB1 - W-4, L-3.lvlx",
	"SMB1 - W-4, L-4.lvlx",
	"SMB1 - W-5, L-1.lvlx",
	"SMB1 - W-5, L-2.lvlx",
	"SMB1 - W-5, L-3.lvlx",
	"SMB1 - W-5, L-4.lvlx",
	"SMB1 - W-6, L-1.lvlx",
	"SMB1 - W-6, L-2.lvlx",
	"SMB1 - W-6, L-3.lvlx",
	"SMB1 - W-6, L-4.lvlx",
	"SMB1 - W-7, L-1.lvlx",
	"SMB1 - W-7, L-2.lvlx",
	"SMB1 - W-7, L-3.lvlx",
	"SMB1 - W-7, L-4.lvlx",
	"SMB1 - W-8, L-1.lvlx",
	"SMB1 - W-8, L-2.lvlx",
	"SMB1 - W-8, L-3.lvlx",
	"SMB1 - W-8, L-4.lvlx",
	"SMB1 - W-9, L-1.lvlx",
	"SMB1 - W-9, L-2.lvlx",
	"SMB1 - W-9, L-3.lvlx",
	"SMB1 - W-9, L-4.lvlx"
}

if SaveData.SMB1HardModeActivated == nil then
	SaveData.SMB1HardModeActivated = false
end

function dependencies.onStart()
	if SaveData.ut_enabled == nil then
		SaveData.ut_enabled = SaveData.ut_enabled or 0
	end
	local character = player.character;
	local costumes = playerManager.getCostumes(player.character)
	local currentCostume = player:getCostume()
	
	if player.character == CHARACTER_NINJABOMBERMAN then
		Defines.player_walkspeed = 6
		Defines.player_runspeed = 6
	end
	
	local costumes
	if SaveData.disableX2char == false then
		undertaledepends = require("level_dependencies_undertale")
		warpTransition = require("warpTransition")
		anotherPowerDownLibrary = require("anotherPowerDownLibrary")
		playerphysicspatch = require("playerphysicspatch")
		kindHurtBlock = require("kindHurtBlock")
		furyinventory = require("furyinventory")
		warpTransition.musicFadeOut = false
		warpTransition.levelStartTransition = warpTransition.TRANSITION_FADE
		warpTransition.sameSectionTransition = warpTransition.TRANSITION_PAN
		warpTransition.crossSectionTransition = warpTransition.TRANSITION_FADE
		warpTransition.activateOnInstantWarps = false
		warpTransition.TRANSITION_FADE = 1
		warpTransition.TRANSITION_SWIRL = 1
		warpTransition.TRANSITION_IRIS_OUT = 1
		warpTransition.TRANSITION_PAN = 6
		littleDialogue.defaultStyleName = "smw"
		if currentCostume == nil then
			if SaveData.disableX2char == false then
				warpTransition.doorclose = ("_OST/_Sound Effects/door-close.ogg")
			end
		end
	end
	if SaveData.disableX2char == true then
		Cheats.deregister("dressmeup")
		Cheats.deregister("undress")
		Cheats.deregister("laundryday")
		warpTransition = require("warpTransition")
		warpTransition.musicFadeOut = false
		warpTransition.levelStartTransition = warpTransition.TRANSITION_NONE
		warpTransition.sameSectionTransition = warpTransition.TRANSITION_NONE
		warpTransition.crossSectionTransition = warpTransition.TRANSITION_NONE
		warpTransition.activateOnInstantWarps = false
		littleDialogue.defaultStyleName = "smbx13og"
	end
end

function dependencies.onTick()
	if Player(2) and Player(2).isValid then
		if Player(1).forcedState == FORCEDSTATE_PIPE then
			if Player(1).forcedTimer >= 70 and not Misc.isPaused() then
				player:mem(0x140,FIELD_WORD,100)
				player2:mem(0x140,FIELD_WORD,100)
				Player(2):teleport(player.x - 32, player.y - 32, bottomCenterAligned)
			end
		end
		if Player(2).forcedState == FORCEDSTATE_PIPE then
			if Player(2).forcedTimer >= 70 and not Misc.isPaused() then
				player:mem(0x140,FIELD_WORD,100)
				player2:mem(0x140,FIELD_WORD,100)
				Player(1):teleport(Player(2).x - 32, Player(2).y - 32, bottomCenterAligned)
			end
		end
	end
	if Player(2) and Player(2).isValid then
		if Player(1).forcedState == FORCEDSTATE_DOOR then
			if Player(1).forcedTimer == 1 then
				Routine.run(p1teleportdoor)
			end
		end
		if Player(2).forcedState == FORCEDSTATE_DOOR then
			if Player(2).forcedTimer == 1 then
				Routine.run(p2teleportdoor)
			end
		end
	end
	if player.character == CHARACTER_SNAKE then
		Graphics.activateHud(true)
	end
	if player.character == CHARACTER_NINJABOMBERMAN then
		Graphics.activateHud(true)
	end
	if table.icontains(GameData._smb1Levels,Level.filename()) == true then
		for k,v in NPC.iterate{89,23,27,24,173,175,176,177,172,174,612} do
			if SaveData.SMB1HardModeActivated == true then
				if v.id == 89 or v.id == 27 then
					v:transform(23, true)
				end
			elseif SaveData.SMB1HardModeActivated == false then
				if v.id == 23 or v.id == 24 then
					v:transform(89, true)
				end
			end
		end
		local SMB1HardModeLayer = Layer.get("SMB1 Hard Mode")
		local SMB1EasyModeLayer = Layer.get("SMB1 Easy Mode")
		if SaveData.SMB1HardModeActivated == true then
			SMB1HardModeLayer:show(true)
			SMB1EasyModeLayer:hide(true)
		elseif SaveData.SMB1HardModeActivated == false then
			SMB1HardModeLayer:hide(true)
			SMB1EasyModeLayer:show(true)
		end
	end
end

Cheats.register("fcommandssuck",{ --Reenables F Commands from the beginning of development
	onActivate = (function()
		Defines.player_hasCheated = false
		spartaremix = require("spartaremix")
		malcwarp = require("malcwarp")
		thecostume = require("thecostume")
		exitcommands = require("exitcommands")
		commandlist = require("commandlist")
		return true -- this makes the cheat not toggleable
	end),
	flashPlayer = true,activateSFX = "_OST/_Sound Effects/hits1.ogg",
})

Cheats.register("fuckyou",{ --Renables all F Commands, plus debugbox and spartaremix
	onActivate = (function()
		Defines.player_hasCheated = false
		spartaremix = require("spartaremix")
		malcwarp = require("malcwarp")
		thecostume = require("thecostume")
		exitcommands = require("exitcommands")
		commandlist = require("commandlist")
		debugbox = require("debugbox")
		return true -- this makes the cheat not toggleable
	end),
	flashPlayer = true,activateSFX = 69,
})

return dependencies