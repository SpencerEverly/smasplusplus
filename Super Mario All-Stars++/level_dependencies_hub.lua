local littleDialogue = require("littleDialogue")
local playerManager = require("playerManager")
local inventory = require("customInventory")
local textplus = require("textplus")
local autoscroll = require("autoscroll")
local datetime = require("datetime")
local Routine = require("routine")
local extrasounds = require("extrasounds")
local warpTransition = require("warpTransition")
local anothercurrency = require("ShopSystem/anothercurrency")
local smasdeathsystem = require("smasdeathsystem")
local pausemenu2 = require("pausemenu2")
--local pauseplus = require("pauseplus")

--pauseplus.canPause = true

local costumes = {}

local dying = false;
local deathVisibleCount = 100;
local deathTimer = deathVisibleCount;
local earlyDeathCheck = 3;

local timer_deathTimer;
local deltaTime = Routine.deltaTime

local nbm = require("Characters/ninjabomberman");
nbm.usesavestate = false;
nbm.deathDelay = deathVisibleCount;
	
local mm = require("Characters/megaman");
mm.playIntro = false;

local dependencies2 = {}

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

function dependencies2.onInitAPI()
	registerEvent(dependencies2, "onStart")
	registerEvent(dependencies2, "onTick")
	registerEvent(dependencies2, "onDraw")
	registerEvent(dependencies2, "onCameraUpdate")
	registerEvent(dependencies2, "onInputUpdate")
end

function dependencies2.onCameraUpdate(c, camIdx)
	if player.count(2) then
		if c == 1 then
			camera.renderX, camera.rendery = 0, 0
			camera.width, camera.height = 800, 600
		else
			camera2.renderX  = 800
		end
		local screenType = mem(0x00B25130,FIELD_WORD)

		if camera2.isSplit or screenType == 6 then -- split screen or supermario2 is active
			return camIdx
		elseif screenType == 5 then -- dynamic screen
			if Player(1):mem(0x13C,FIELD_BOOL) then -- player 1 is dead
				return 2
			elseif Player(2):mem(0x13C,FIELD_BOOL) then -- player 2 is dead
				return 1
			else
				return 0
			end
		elseif screenType == 2 or screenType == 3 or screenType == 7 then -- follows all players
			return 0
		else
			return 1
		end
	end
end

function dependencies2.onStart()
	if Misc.inEditor() then
		debugbox = require("debugbox")
	end
	if SaveData.disableX2char == false then
		anotherPowerDownLibrary = require("anotherPowerDownLibrary")
		playerphysicspatch = require("playerphysicspatch")
		kindHurtBlock = require("kindHurtBlock")
		comboSounds = require("comboSounds")
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
		warpTransition.musicFadeOut = false
		warpTransition.levelStartTransition = warpTransition.TRANSITION_NONE
		warpTransition.sameSectionTransition = warpTransition.TRANSITION_NONE
		warpTransition.crossSectionTransition = warpTransition.TRANSITION_NONE
		warpTransition.activateOnInstantWarps = false
		littleDialogue.defaultStyleName = "smbx13og"
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

function dependencies2.onTick()
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
	
	local character = player.character;
	local costumes = playerManager.getCostumes(player.character)
	local currentCostume = player:getCostume()
	
	local costumes
	if currentCostume == nil then
		if SaveData.disableX2char == false then
			warpTransition.doorclose = ("door-close.ogg")
		end
	end
	if currentCostume == "1-SMB1-RETRO" then
		if SaveData.disableX2char == false then
			warpTransition.doorclose = ("costumes/mario/1-SMB1-Retro/door-close.ogg")
		end
	end
	if currentCostume == "2-SMB1-RECOLORED" then
		if SaveData.disableX2char == false then
			warpTransition.doorclose = ("costumes/mario/2-SMB1-Recolored/door-close.ogg")
		end
	end
	if currentCostume == "3-SMB1-SMAS" then
		if SaveData.disableX2char == false then
			warpTransition.doorclose = ("costumes/mario/3-SMB1-SMAS/door-close.ogg")
		end
	end
	if currentCostume == "4-SMB2-RETRO" then
		if SaveData.disableX2char == false then
			warpTransition.doorclose = ("costumes/mario/4-SMB2-Retro/door-close.ogg")
		end
	end
	if currentCostume == "5-SMB2-SMAS" then
		if SaveData.disableX2char == false then
			warpTransition.doorclose = ("costumes/mario/5-SMB2-SMAS/door-close.ogg")
		end
	end
	if currentCostume == "6-SMB3-RETRO" then
		if SaveData.disableX2char == false then
			warpTransition.doorclose = ("costumes/mario/6-SMB3-Retro/door-close.ogg")
		end
	end
	if currentCostume == "A2XT-DEMO" then
		if SaveData.disableX2char == false then
			warpTransition.doorclose = ("costumes/mario/A2XT-Demo/door-close.ogg")
		end
	end
	if currentCostume == "GA-CAILLOU" then
		if SaveData.disableX2char == false then
			warpTransition.doorclose = ("door-close.ogg")
		end
	end
	if currentCostume == "JCFOSTERTAKESITTOTHEMOON" then
		if SaveData.disableX2char == false then
			warpTransition.doorclose = ("door-close.ogg")
		end
	end
	if currentCostume == "PRINCESSRESCUE" then
		if SaveData.disableX2char == false then
			warpTransition.doorclose = ("costumes/mario/PrincessRescue/door-close.ogg")
		end
	end
	if currentCostume == "SP-1-ERICCARTMAN" then
		if SaveData.disableX2char == false then
			warpTransition.doorclose = ("door-close.ogg")
		end
	end
	if currentCostume == "SMG4" then
		if SaveData.disableX2char == false then
			warpTransition.doorclose = ("door-close.ogg")
		end
	end
	if currentCostume == "SMW-MARIO" then
		if SaveData.disableX2char == false then
			warpTransition.doorclose = ("door-close.ogg")
		end
	end
	if currentCostume == "Z-SMW2-ADULTMARIO" then
		if SaveData.disableX2char == false then
			warpTransition.doorclose = ("costumes/mario/Z-SMW2-AdultMario/door-close.ogg")
		end
	end
	
	
	if currentCostume == "0-SPENCEREVERLY" then
		if SaveData.disableX2char == false then
			warpTransition.doorclose = ("door-close.ogg")
		end
	end
	if currentCostume == "LARRYTHECUCUMBER" then
		if SaveData.disableX2char == false then
			warpTransition.doorclose = ("door-close.ogg")
		end
	end
	if currentCostume == "WALUIGI" then
		if SaveData.disableX2char == false then
			warpTransition.doorclose = ("costumes/luigi/LarryTheCucumber/door-close.ogg")
		end
	end
	if currentCostume == "A2XT-IRIS" then
		if SaveData.disableX2char == false then
			warpTransition.doorclose = ("costumes/mario/A2XT-Demo/door-close.ogg")
		end
	end
	if currentCostume == "UNDERTALE-FRISK" then
		if SaveData.disableX2char == false then
			warpTransition.doorclose = ("costumes/luigi/Undertale-Frisk/door-close.ogg")
		end
	end
	if currentCostume == "9-SMB3-MARIOCLOTHES" then
		if SaveData.disableX2char == false then
			warpTransition.doorclose = ("door-close.ogg")
		end
	end
	
	
	if currentCostume == "A2XT-KOOD" then
		if SaveData.disableX2char == false then
			warpTransition.doorclose = ("costumes/mario/A2XT-Demo/door-close.ogg")
		end
	end
	if currentCostume == "DAISY" then
		if SaveData.disableX2char == false then
			warpTransition.doorclose = ("door-close.ogg")
		end
	end
	if currentCostume == "KIRBY-SMB3" then
		if SaveData.disableX2char == false then
			warpTransition.doorclose = ("door-close.ogg")
		end
	end
	if currentCostume == "PAULINE" then
		if SaveData.disableX2char == false then
			warpTransition.doorclose = ("door-close.ogg")
		end
	end
	
	
	if currentCostume == "SEE-TANGENT" then
		if SaveData.disableX2char == false then
			warpTransition.doorclose = ("door-close.ogg")
		end
	end
	if currentCostume == "SONIC" then
		if SaveData.disableX2char == false then
			warpTransition.doorclose = ("door-close.ogg")
		end
	end
	if currentCostume == "TOADETTE" then
		if SaveData.disableX2char == false then
			warpTransition.doorclose = ("door-close.ogg")
		end
	end
	if currentCostume == "YOSHI-SMB3" then
		if SaveData.disableX2char == false then
			warpTransition.doorclose = ("door-close.ogg")
		end
	end
	if currentCostume == "A2XT-RAOCOW" then
		if SaveData.disableX2char == false then
			warpTransition.doorclose = ("costumes/mario/A2XT-Demo/door-close.ogg")
		end
	end
	
	
	
	if currentCostume == "A2XT-SHEATH" then
		if SaveData.disableX2char == false then
			warpTransition.doorclose = ("costumes/mario/A2XT-Demo/door-close.ogg")
		end
	end
	if currentCostume == "SMB3-BANDANA-DEE" then
		if SaveData.disableX2char == false then
			warpTransition.doorclose = ("door-close.ogg")
		end
	end
	if currentCostume == "NESS" then
		if SaveData.disableX2char == false then
			warpTransition.doorclose = ("costumes/link/Ness/door-close.ogg")
		end
	end
	if currentCostume == "TAKESHI" then
		if SaveData.disableX2char == false then
			warpTransition.doorclose = ("costumes/link/Takeshi/door-close.ogg")
		end
	end
	if currentCostume == "TAKESHI-SNES" then
		if SaveData.disableX2char == false then
			warpTransition.doorclose = ("door-close.ogg")
		end
	end
end

Cheats.register("fcommandssuck",{
	onActivate = (function()
		Defines.player_hasCheated = false
		spartaremix = require("spartaremix")
		malcwarp = require("malcwarp_hub")
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
		malcwarp = require("malcwarp_hub")
		thecostume = require("thecostume")
		exitcommands = require("exitcommands")
		commandlist = require("commandlist")
		debugbox = require("debugbox")
		return true -- this makes the cheat not toggleable
	end),
	flashPlayer = true,activateSFX = 69,
})
	
return dependencies2

--function onStart()
-- If SaveGame.currentHub specified an alternate hub level, set that as the hub level path
--	if (SaveGame.currentHub = "SMAS - Start.lvlx") then
--		mem(0xB25724, FIELD_STRING, SaveGame.currentHub)
--		SaveGame.currentHub = "MALC - HUB.lvlx"
--	end
--end

--function onExit()
-- If SaveGame.currentHub specified an alternate hub level, set that as the hub level path
--	if (SaveGame.currentHub = "MALC - HUB.lvlx") then
--		mem(0xB25724, FIELD_STRING, SaveGame.currentHub)
--		SaveGame.currentHub = "SMAS - Start.lvlx"
--	end
--end