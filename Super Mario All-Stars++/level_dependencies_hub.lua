local littleDialogue = require("littleDialogue")
local playerManager = require("playerManager")
local inventory = require("customInventory")
local textplus = require("textplus")
local autoscroll = require("autoscroll")
local datetime = require("datetime")
local Routine = require("routine")
--local playersounds = require("playersounds")

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

function dependencies2.onInputUpdate()
	if SaveData.disableX2char == 1 then
		if player.count() == 1 then
			--Nothing
		end
	end
	if SaveData.disableX2char == 1 then
		if Player(2) and Player(2).isValid then
			if player.keys.altRun == KEYS_PRESSED then
				if pausemenu13.paused == false then
					player:teleport(Player(2).x + 32, Player(2).y - 32, bottomCenterAligned)
					SFX.play("_OST/_Sound Effects/player-tp-2player.ogg")
					cooldown = 5
					player:mem(0x172,FIELD_BOOL,false)
				end
				if cooldown <= 0 then
					player:mem(0x172,FIELD_BOOL,true)
				end
			end
		end
	end
	if SaveData.disableX2char == 1 then
		if Player(2) and Player(2).isValid then
			if Player(2).keys.altRun == KEYS_PRESSED then
				if pausemenu13.paused == false then
					Player(2):teleport(player.x - 32, player.y - 32, bottomCenterAligned)
					SFX.play("_OST/_Sound Effects/player-tp-2player.ogg")
					cooldown = 5
					Player(2):mem(0x172,FIELD_BOOL,false)
				end
				if cooldown <= 0 then
					Player(2):mem(0x172,FIELD_BOOL,true)
				end
			end
		end
	end
end

function dependencies2.onStart()
	if Misc.inEditor() then
		debugbox = require("debugbox")
	end
	if SaveData.disableX2char == 0 then
		pausemenu = require("pausemenu")
		warpTransition = require("warpTransition")
		anotherPowerDownLibrary = require("anotherPowerDownLibrary")
		playerphysicspatch = require("playerphysicspatch")
		kindHurtBlock = require("kindHurtBlock")
		comboSounds = require("comboSounds")
		inventory = require('furyinventory')
		warpTransition.musicFadeOut = false
		warpTransition.levelStartTransition = warpTransition.TRANSITION_IRIS_OUT
		warpTransition.sameSectionTransition = warpTransition.TRANSITION_PAN
		warpTransition.crossSectionTransition = warpTransition.TRANSITION_FADE
		warpTransition.activateOnInstantWarps = false
		warpTransition.TRANSITION_FADE = 1
		warpTransition.TRANSITION_SWIRL = 1
		warpTransition.TRANSITION_IRIS_OUT = 1
		warpTransition.TRANSITION_PAN = 6
		littleDialogue.defaultStyleName = "smw"
		if currentCostume == nil then
			if SaveData.disableX2char == 0 then
				warpTransition.doorclose = ("_OST/_Sound Effects/door-close.ogg")
			end
		end
	end
	if SaveData.disableX2char == 1 then
		Cheats.deregister("dressmeup")
		Cheats.deregister("undress")
		Cheats.deregister("laundryday")
		warpTransition = require("warpTransition")
		warpTransition.musicFadeOut = false
		warpTransition.levelStartTransition = warpTransition.TRANSITION_NONE
		warpTransition.sameSectionTransition = warpTransition.TRANSITION_NONE
		warpTransition.crossSectionTransition = warpTransition.TRANSITION_NONE
		warpTransition.activateOnInstantWarps = false
		pausemenu13 = require("pausemenu13")
		littleDialogue.defaultStyleName = "smbx13og"
		playersounds.playeronesound1  = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/player-jump.ogg")
		playersounds.playeronesound2  = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/stomped.ogg")
		playersounds.playeronesound3  = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/block-hit.ogg")
		playersounds.playeronesound4  = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/block-smash.ogg")
		playersounds.playeronesound5  = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/player-shrink.ogg")
		playersounds.playeronesound6  = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/player-grow.ogg")
		playersounds.playeronesound7  = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/mushroom.ogg")
		playersounds.playeronesound8  = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/player-died.ogg")
		playersounds.playeronesound9  = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/shell-hit.ogg")
		playersounds.playeronesound10 = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/player-slide.ogg")
		playersounds.playeronesound11 = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/item-dropped.ogg")
		playersounds.playeronesound12 = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/has-item.ogg")
		playersounds.playeronesound13 = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/camera-change.ogg")
		playersounds.playeronesound14 = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/coin.ogg")
		playersounds.playeronesound15 = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/1up.ogg")
		playersounds.playeronesound16 = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/lava.ogg")
		playersounds.playeronesound17 = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/warp.ogg")
		playersounds.playeronesound18 = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/fireball.ogg")
		playersounds.playeronesound19 = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/level-win.ogg")
		playersounds.playeronesound20 = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/boss-beat.ogg")
		playersounds.playeronesound21 = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/dungeon-win.ogg")
		playersounds.playeronesound22 = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/bullet-bill.ogg")
		playersounds.playeronesound23 = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/grab.ogg")
		playersounds.playeronesound24 = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/spring.ogg")
		playersounds.playeronesound25 = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/hammer.ogg")
		playersounds.playeronesound29 = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/do.ogg")
		playersounds.playeronesound31 = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/key.ogg")
		playersounds.playeronesound32 = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/pswitch.ogg")
		playersounds.playeronesound33 = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/tail.ogg")
		playersounds.playeronesound34 = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/racoon.ogg")
		playersounds.playeronesound35 = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/boot.ogg")
		playersounds.playeronesound36 = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/smash.ogg")
		playersounds.playeronesound37 = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/thwomp.ogg")
		playersounds.playeronesound42 = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/npc-fireball.ogg")
		playersounds.playeronesound43 = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/fireworks.ogg")
		playersounds.playeronesound44 = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/bowser-killed.ogg")
		playersounds.playeronesound46 = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/door.ogg")
		playersounds.playeronesound48 = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/yoshi.ogg")
		playersounds.playeronesound49 = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/yoshi-hurt.ogg")
		playersounds.playeronesound50 = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/yoshi-tongue.ogg")
		playersounds.playeronesound51 = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/yoshi-egg.ogg")
		playersounds.playeronesound52 = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/got-star.ogg")
		playersounds.playeronesound54 = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/player-died2.ogg")
		playersounds.playeronesound55 = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/yoshi-swallow.ogg")
		playersounds.playeronesound57 = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/dry-bones.ogg")
		playersounds.playeronesound58 = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/smw-checkpoint.ogg")
		playersounds.playeronesound59 = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/dragon-coin.ogg")
		playersounds.playeronesound61 = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/smw-blaarg.ogg")
		playersounds.playeronesound62 = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/wart-bubble.ogg")
		playersounds.playeronesound63 = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/wart-die.ogg")
		playersounds.playeronesound71 = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/climbing.ogg")
		playersounds.playeronesound72 = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/swim.ogg")
		playersounds.playeronesound73 = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/grab2.ogg")
		playersounds.playeronesound75 = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/smb2-throw.ogg")
		playersounds.playeronesound76 = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/smb2-hit.ogg")
		playersounds.playeronesound77 = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/zelda-stab.ogg")
		playersounds.playeronesound78 = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/zelda-hurt.ogg")
		playersounds.playeronesound79 = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/zelda-heart.ogg")
		playersounds.playeronesound80 = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/zelda-died.ogg")
		playersounds.playeronesound81 = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/zelda-rupee.ogg")
		playersounds.playeronesound82 = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/zelda-fire.ogg")
		playersounds.playeronesound83 = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/zelda-item.ogg")
		playersounds.playeronesound84 = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/zelda-key.ogg")
		playersounds.playeronesound85 = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/zelda-shield.ogg")
		playersounds.playeronesound86 = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/zelda-dash.ogg")
		playersounds.playeronesound87 = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/zelda-fairy.ogg")
		playersounds.playeronesound88 = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/zelda-grass.ogg")
		playersounds.playeronesound89 = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/zelda-hit.ogg")
		playersounds.playeronesound90 = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/zelda-sword-beam.ogg")
		playersounds.playeronesound91 = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/bubble.ogg")
		playersounds.playertwosound1  = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/player-jump.ogg")
		playersounds.playertwosound2  = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/stomped.ogg")
		playersounds.playertwosound3  = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/block-hit.ogg")
		playersounds.playertwosound4  = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/block-smash.ogg")
		playersounds.playertwosound5  = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/player-shrink.ogg")
		playersounds.playertwosound6  = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/player-grow.ogg")
		playersounds.playertwosound7  = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/mushroom.ogg")
		playersounds.playertwosound8  = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/player-died.ogg")
		playersounds.playertwosound9  = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/shell-hit.ogg")
		playersounds.playertwosound10 = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/player-slide.ogg")
		playersounds.playertwosound11 = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/item-dropped.ogg")
		playersounds.playertwosound12 = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/has-item.ogg")
		playersounds.playertwosound13 = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/camera-change.ogg")
		playersounds.playertwosound14 = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/coin.ogg")
		playersounds.playertwosound15 = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/1up.ogg")
		playersounds.playertwosound16 = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/lava.ogg")
		playersounds.playertwosound17 = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/warp.ogg")
		playersounds.playertwosound18 = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/fireball.ogg")
		playersounds.playertwosound19 = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/level-win.ogg")
		playersounds.playertwosound20 = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/boss-beat.ogg")
		playersounds.playertwosound21 = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/dungeon-win.ogg")
		playersounds.playertwosound22 = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/bullet-bill.ogg")
		playersounds.playertwosound23 = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/grab.ogg")
		playersounds.playertwosound24 = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/spring.ogg")
		playersounds.playertwosound25 = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/hammer.ogg")
		playersounds.playertwosound29 = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/do.ogg")
		playersounds.playertwosound31 = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/key.ogg")
		playersounds.playertwosound32 = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/pswitch.ogg")
		playersounds.playertwosound33 = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/tail.ogg")
		playersounds.playertwosound34 = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/racoon.ogg")
		playersounds.playertwosound35 = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/boot.ogg")
		playersounds.playertwosound36 = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/smash.ogg")
		playersounds.playertwosound37 = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/thwomp.ogg")
		playersounds.playertwosound42 = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/npc-fireball.ogg")
		playersounds.playertwosound43 = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/fireworks.ogg")
		playersounds.playertwosound44 = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/bowser-killed.ogg")
		playersounds.playertwosound46 = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/door.ogg")
		playersounds.playertwosound48 = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/yoshi.ogg")
		playersounds.playertwosound49 = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/yoshi-hurt.ogg")
		playersounds.playertwosound50 = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/yoshi-tongue.ogg")
		playersounds.playertwosound51 = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/yoshi-egg.ogg")
		playersounds.playertwosound52 = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/got-star.ogg")
		playersounds.playertwosound54 = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/player-died2.ogg")
		playersounds.playertwosound55 = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/yoshi-swallow.ogg")
		playersounds.playertwosound57 = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/dry-bones.ogg")
		playersounds.playertwosound58 = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/smw-checkpoint.ogg")
		playersounds.playertwosound59 = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/dragon-coin.ogg")
		playersounds.playertwosound61 = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/smw-blaarg.ogg")
		playersounds.playertwosound62 = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/wart-bubble.ogg")
		playersounds.playertwosound63 = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/wart-die.ogg")
		playersounds.playertwosound71 = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/climbing.ogg")
		playersounds.playertwosound72 = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/swim.ogg")
		playersounds.playertwosound73 = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/grab2.ogg")
		playersounds.playertwosound75 = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/smb2-throw.ogg")
		playersounds.playertwosound76 = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/smb2-hit.ogg")
		playersounds.playertwosound77 = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/zelda-stab.ogg")
		playersounds.playertwosound78 = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/zelda-hurt.ogg")
		playersounds.playertwosound79 = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/zelda-heart.ogg")
		playersounds.playertwosound80 = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/zelda-died.ogg")
		playersounds.playertwosound81 = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/zelda-rupee.ogg")
		playersounds.playertwosound82 = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/zelda-fire.ogg")
		playersounds.playertwosound83 = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/zelda-item.ogg")
		playersounds.playertwosound84 = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/zelda-key.ogg")
		playersounds.playertwosound85 = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/zelda-shield.ogg")
		playersounds.playertwosound86 = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/zelda-dash.ogg")
		playersounds.playertwosound87 = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/zelda-fairy.ogg")
		playersounds.playertwosound88 = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/zelda-grass.ogg")
		playersounds.playertwosound89 = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/zelda-hit.ogg")
		playersounds.playertwosound90 = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/zelda-sword-beam.ogg")
		playersounds.playertwosound91 = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/bubble.ogg")
	end
end

function dependencies2.onTick()
	if player.character == CHARACTER_SNAKE then
		Graphics.activateHud(true)
	end
	
	local character = player.character;
	local costumes = playerManager.getCostumes(player.character)
	local currentCostume = player:getCostume()
	
	local costumes
	if currentCostume == nil then
		if SaveData.disableX2char == 0 then
			warpTransition.doorclose = ("door-close.ogg")
		end
	end
	if currentCostume == "1-SMB1-RETRO" then
		if SaveData.disableX2char == 0 then
			warpTransition.doorclose = ("costumes/mario/1-SMB1-Retro/door-close.ogg")
		end
	end
	if currentCostume == "2-SMB1-RECOLORED" then
		if SaveData.disableX2char == 0 then
			warpTransition.doorclose = ("costumes/mario/2-SMB1-Recolored/door-close.ogg")
		end
	end
	if currentCostume == "3-SMB1-SMAS" then
		if SaveData.disableX2char == 0 then
			warpTransition.doorclose = ("costumes/mario/3-SMB1-SMAS/door-close.ogg")
		end
	end
	if currentCostume == "4-SMB2-RETRO" then
		if SaveData.disableX2char == 0 then
			warpTransition.doorclose = ("costumes/mario/4-SMB2-Retro/door-close.ogg")
		end
	end
	if currentCostume == "5-SMB2-SMAS" then
		if SaveData.disableX2char == 0 then
			warpTransition.doorclose = ("costumes/mario/5-SMB2-SMAS/door-close.ogg")
		end
	end
	if currentCostume == "6-SMB3-RETRO" then
		if SaveData.disableX2char == 0 then
			warpTransition.doorclose = ("costumes/mario/6-SMB3-Retro/door-close.ogg")
		end
	end
	if currentCostume == "A2XT-DEMO" then
		if SaveData.disableX2char == 0 then
			warpTransition.doorclose = ("costumes/mario/A2XT-Demo/door-close.ogg")
		end
	end
	if currentCostume == "GA-CAILLOU" then
		if SaveData.disableX2char == 0 then
			warpTransition.doorclose = ("door-close.ogg")
		end
	end
	if currentCostume == "JCFOSTERTAKESITTOTHEMOON" then
		if SaveData.disableX2char == 0 then
			warpTransition.doorclose = ("door-close.ogg")
		end
	end
	if currentCostume == "PRINCESSRESCUE" then
		if SaveData.disableX2char == 0 then
			warpTransition.doorclose = ("costumes/mario/PrincessRescue/door-close.ogg")
		end
	end
	if currentCostume == "SP-1-ERICCARTMAN" then
		if SaveData.disableX2char == 0 then
			warpTransition.doorclose = ("door-close.ogg")
		end
	end
	if currentCostume == "SMG4" then
		if SaveData.disableX2char == 0 then
			warpTransition.doorclose = ("door-close.ogg")
		end
	end
	if currentCostume == "SMW-MARIO" then
		if SaveData.disableX2char == 0 then
			warpTransition.doorclose = ("door-close.ogg")
		end
	end
	if currentCostume == "Z-SMW2-ADULTMARIO" then
		if SaveData.disableX2char == 0 then
			warpTransition.doorclose = ("costumes/mario/Z-SMW2-AdultMario/door-close.ogg")
		end
	end
	
	
	if currentCostume == "0-SPENCEREVERLY" then
		if SaveData.disableX2char == 0 then
			warpTransition.doorclose = ("door-close.ogg")
		end
	end
	if currentCostume == "LARRYTHECUCUMBER" then
		if SaveData.disableX2char == 0 then
			warpTransition.doorclose = ("door-close.ogg")
		end
	end
	if currentCostume == "WALUIGI" then
		if SaveData.disableX2char == 0 then
			warpTransition.doorclose = ("costumes/luigi/LarryTheCucumber/door-close.ogg")
		end
	end
	if currentCostume == "A2XT-IRIS" then
		if SaveData.disableX2char == 0 then
			warpTransition.doorclose = ("costumes/mario/A2XT-Demo/door-close.ogg")
		end
	end
	if currentCostume == "UNDERTALE-FRISK" then
		if SaveData.disableX2char == 0 then
			warpTransition.doorclose = ("costumes/luigi/Undertale-Frisk/door-close.ogg")
		end
	end
	if currentCostume == "9-SMB3-MARIOCLOTHES" then
		if SaveData.disableX2char == 0 then
			warpTransition.doorclose = ("door-close.ogg")
		end
	end
	
	
	if currentCostume == "A2XT-KOOD" then
		if SaveData.disableX2char == 0 then
			warpTransition.doorclose = ("costumes/mario/A2XT-Demo/door-close.ogg")
		end
	end
	if currentCostume == "DAISY" then
		if SaveData.disableX2char == 0 then
			warpTransition.doorclose = ("door-close.ogg")
		end
	end
	if currentCostume == "KIRBY-SMB3" then
		if SaveData.disableX2char == 0 then
			warpTransition.doorclose = ("door-close.ogg")
		end
	end
	if currentCostume == "PAULINE" then
		if SaveData.disableX2char == 0 then
			warpTransition.doorclose = ("door-close.ogg")
		end
	end
	
	
	if currentCostume == "SEE-TANGENT" then
		if SaveData.disableX2char == 0 then
			warpTransition.doorclose = ("door-close.ogg")
		end
	end
	if currentCostume == "SONIC" then
		if SaveData.disableX2char == 0 then
			warpTransition.doorclose = ("door-close.ogg")
		end
	end
	if currentCostume == "TOADETTE" then
		if SaveData.disableX2char == 0 then
			warpTransition.doorclose = ("door-close.ogg")
		end
	end
	if currentCostume == "YOSHI-SMB3" then
		if SaveData.disableX2char == 0 then
			warpTransition.doorclose = ("door-close.ogg")
		end
	end
	if currentCostume == "A2XT-RAOCOW" then
		if SaveData.disableX2char == 0 then
			warpTransition.doorclose = ("costumes/mario/A2XT-Demo/door-close.ogg")
		end
	end
	
	
	
	if currentCostume == "A2XT-SHEATH" then
		if SaveData.disableX2char == 0 then
			warpTransition.doorclose = ("costumes/mario/A2XT-Demo/door-close.ogg")
		end
	end
	if currentCostume == "SMB3-BANDANA-DEE" then
		if SaveData.disableX2char == 0 then
			warpTransition.doorclose = ("door-close.ogg")
		end
	end
	if currentCostume == "NESS" then
		if SaveData.disableX2char == 0 then
			warpTransition.doorclose = ("costumes/link/Ness/door-close.ogg")
		end
	end
	if currentCostume == "TAKESHI" then
		if SaveData.disableX2char == 0 then
			warpTransition.doorclose = ("costumes/link/Takeshi/door-close.ogg")
		end
	end
	if currentCostume == "TAKESHI-SNES" then
		if SaveData.disableX2char == 0 then
			warpTransition.doorclose = ("door-close.ogg")
		end
	end
end
	
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