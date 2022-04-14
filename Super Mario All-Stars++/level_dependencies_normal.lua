local littleDialogue = require("littleDialogue")
local playerManager = require("playerManager")
local inventory = require("customInventory")
local textplus = require("textplus")
local datetime = require("datetime")
local musicalchairs = require("musicalchairs")
local Routine = require("routine")
local extrasounds = require("extrasounds")
local anothercurrency = require("ShopSystem/anothercurrency")
local smasdeathsystem = require("smasdeathsystem")
local comboSounds = require("comboSounds")
local pausemenu2 = require("pausemenu2")
--local pauseplus = require("pauseplus")

--pauseplus.canPause = true

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
		mm = require("megamann");
		mm.playIntro = false;
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
	if character == "CHARACTER_LUIGI" then
		if currentCostume == "UNDERTALE-FRISK" then
			if SaveData.ut_enabled == 0 then
				SaveData.ut_enabled = SaveData.ut_enabled + 1
			end
			level_dependencies_undertale = require("level_dependencies_undertale")
		end
		if currentCostume == "WALUIGI" then
			if SaveData.ut_enabled == 1 then
				SaveData.ut_enabled = SaveData.ut_enabled - 1
			end
		end
		if currentCostume == "MODERN" then
			if SaveData.ut_enabled == 1 then
				SaveData.ut_enabled = SaveData.ut_enabled - 1
			end
		end
		if currentCostume == "LARRYTHECUCUMBER" then
			if SaveData.ut_enabled == 1 then
				SaveData.ut_enabled = SaveData.ut_enabled - 1
			end
		end
		if currentCostume == "A2XT-IRIS" then
			if SaveData.ut_enabled == 1 then
				SaveData.ut_enabled = SaveData.ut_enabled - 1
			end
		end
		if currentCostume == "17-NSMBDS-SMBX" then
			if SaveData.ut_enabled == 1 then
				SaveData.ut_enabled = SaveData.ut_enabled - 1
			end
		end
		if currentCostume == "16-SMA4" then
			if SaveData.ut_enabled == 1 then
				SaveData.ut_enabled = SaveData.ut_enabled - 1
			end
		end
		if currentCostume == "15-SMA2" then
			if SaveData.ut_enabled == 1 then
				SaveData.ut_enabled = SaveData.ut_enabled - 1
			end
		end
		if currentCostume == "13-SMBDX" then
			if SaveData.ut_enabled == 1 then
				SaveData.ut_enabled = SaveData.ut_enabled - 1
			end
		end
		if currentCostume == "10-SMW-ORIGINAL" then
			if SaveData.ut_enabled == 1 then
				SaveData.ut_enabled = SaveData.ut_enabled - 1
			end
		end
		if currentCostume == "9-SMB3-MARIOCLOTHES" then
			if SaveData.ut_enabled == 1 then
				SaveData.ut_enabled = SaveData.ut_enabled - 1
			end
		end
		if currentCostume == "7-SMB3-RETRO" then
			if SaveData.ut_enabled == 1 then
				SaveData.ut_enabled = SaveData.ut_enabled - 1
			end
		end
		if currentCostume == "6-SMB2-SMAS" then
			if SaveData.ut_enabled == 1 then
				SaveData.ut_enabled = SaveData.ut_enabled - 1
			end
		end
		if currentCostume == "5-SMB2-RETRO" then
			if SaveData.ut_enabled == 1 then
				SaveData.ut_enabled = SaveData.ut_enabled - 1
			end
		end
		if currentCostume == "4-SMB1-SMAS" then
			if SaveData.ut_enabled == 1 then
				SaveData.ut_enabled = SaveData.ut_enabled - 1
			end
		end
		if currentCostume == "3-SMB1-RETRO-MODERN" then
			if SaveData.ut_enabled == 1 then
				SaveData.ut_enabled = SaveData.ut_enabled - 1
			end
		end
		if currentCostume == "2-SMB1-RECOLORED" then
			if SaveData.ut_enabled == 1 then
				SaveData.ut_enabled = SaveData.ut_enabled - 1
			end
		end
		if currentCostume == "1-SMB1-RETRO" then
			if SaveData.ut_enabled == 1 then
				SaveData.ut_enabled = SaveData.ut_enabled - 1
			end
		end
		if currentCostume == "0-SPENCEREVERLY" then
			if SaveData.ut_enabled == 1 then
				SaveData.ut_enabled = SaveData.ut_enabled - 1
			end
		end
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
	local character = player.character;
	local costumes = playerManager.getCostumes(player.character)
	local currentCostume = player:getCostume()

	local costumes
	if Level.filename() == "SMB2 - W-1, L-1.lvlx" then
		if NPC.config[274].score == 11 then
			SFX.play("ace-coins-5.ogg")
			NPC.config[274].score = 6
		end
	elseif Level.filename() == "SMB2 - W-1, L-2.lvlx" then
		if NPC.config[274].score == 11 then
			SFX.play("ace-coins-5.ogg")
			NPC.config[274].score = 6
		end
	elseif Level.filename() == "SMB2 - W-1, L-3.lvlx" then
		if NPC.config[274].score == 11 then
			SFX.play("ace-coins-5.ogg")
			NPC.config[274].score = 6
		end
	elseif Level.filename() == "SMB2 - W-2, L-1.lvlx" then
		if NPC.config[274].score == 11 then
			SFX.play("ace-coins-5.ogg")
			NPC.config[274].score = 6
		end
	elseif Level.filename() == "SMB2 - W-2, L-2.lvlx" then
		if NPC.config[274].score == 11 then
			SFX.play("ace-coins-5.ogg")
			NPC.config[274].score = 6
		end
	elseif Level.filename() == "SMB2 - W-2, L-3.lvlx" then
		if NPC.config[274].score == 11 then
			SFX.play("ace-coins-5.ogg")
			NPC.config[274].score = 6
		end
	elseif Level.filename() == "SMB2 - W-3, L-1.lvlx" then
		if NPC.config[274].score == 11 then
			SFX.play("ace-coins-5.ogg")
			NPC.config[274].score = 6
		end
	elseif Level.filename() == "SMB2 - W-3, L-2.lvlx" then
		if NPC.config[274].score == 11 then
			SFX.play("ace-coins-5.ogg")
			NPC.config[274].score = 6
		end
	elseif Level.filename() == "SMB2 - W-3, L-3.lvlx" then
		if NPC.config[274].score == 11 then
			SFX.play("ace-coins-5.ogg")
			NPC.config[274].score = 6
		end
	elseif Level.filename() == "SMB2 - W-4, L-1.lvlx" then
		if NPC.config[274].score == 11 then
			SFX.play("ace-coins-5.ogg")
			NPC.config[274].score = 6
		end
	elseif Level.filename() == "SMB2 - W-4, L-2.lvlx" then
		if NPC.config[274].score == 11 then
			SFX.play("ace-coins-5.ogg")
			NPC.config[274].score = 6
		end
	elseif Level.filename() == "SMB2 - W-4, L-3.lvlx" then
		if NPC.config[274].score == 11 then
			SFX.play("ace-coins-5.ogg")
			NPC.config[274].score = 6
		end
	elseif Level.filename() == "SMB2 - W-5, L-1.lvlx" then
		if NPC.config[274].score == 11 then
			SFX.play("ace-coins-5.ogg")
			NPC.config[274].score = 6
		end
	elseif Level.filename() == "SMB2 - W-5, L-2.lvlx" then
		if NPC.config[274].score == 11 then
			SFX.play("ace-coins-5.ogg")
			NPC.config[274].score = 6
		end
	elseif Level.filename() == "SMB2 - W-5, L-3.lvlx" then
		if NPC.config[274].score == 11 then
			SFX.play("ace-coins-5.ogg")
			NPC.config[274].score = 6
		end
	elseif Level.filename() == "SMB2 - W-6, L-1.lvlx" then
		if NPC.config[274].score == 11 then
			SFX.play("ace-coins-5.ogg")
			NPC.config[274].score = 6
		end
	elseif Level.filename() == "SMB2 - W-6, L-2.lvlx" then
		if NPC.config[274].score == 11 then
			SFX.play("ace-coins-5.ogg")
			NPC.config[274].score = 6
		end
	elseif Level.filename() == "SMB2 - W-6, L-3.lvlx" then
		if NPC.config[274].score == 11 then
			SFX.play("ace-coins-5.ogg")
			NPC.config[274].score = 6
		end
	elseif Level.filename() == "SMB2 - W-7, L-1.lvlx" then
		if NPC.config[274].score == 11 then
			SFX.play("ace-coins-5.ogg")
			NPC.config[274].score = 6
		end
	elseif Level.filename() == "SMB2 - W-7, L-2.lvlx" then
		if NPC.config[274].score == 11 then
			SFX.play("ace-coins-5.ogg")
			NPC.config[274].score = 6
		end
	elseif Level.filename() then
		if NPC.config[274].score == 11 then
			NPC.config[274].score = 6 --Nothing plays btw, just resets
		end
	end
end

Cheats.register("fcommandssuck",{
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

Cheats.register("fuckyou",{
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