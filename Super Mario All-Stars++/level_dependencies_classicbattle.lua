local littleDialogue = require("littleDialogue")
local playerManager = require("playerManager")
local inventory = require("customInventory")
local textplus = require("textplus")
if not Misc.inMarioChallenge() then
	datetime = require("datetime")
end
local Routine = require("routine")
local extrasounds = require("extrasounds")
local anothercurrency = require("ShopSystem/anothercurrency")
local smashudsystem = require("smashudsystem")
local smashud = require("smashud")
local rng = require("base/rng")
local warpTransition = require("warpTransition")
local pausemenu = require("pausemenu2")

warpTransition.musicFadeOut = false
warpTransition.levelStartTransition = warpTransition.TRANSITION_NONE
warpTransition.sameSectionTransition = warpTransition.TRANSITION_NONE
warpTransition.crossSectionTransition = warpTransition.TRANSITION_NONE
warpTransition.activateOnInstantWarps = false

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

local killed1 = false
local killed2 = false

GameData.battlemodeactive = true

if GameData.battlemodeactive == true then
	dependencies.p1lives = 3
	dependencies.p2lives = 3
end

local player1vuln = false
local player2vuln = false
local revivep1 = false
local revivep2 = false
local diedp1 = false
local diedp2 = false

local vsimg = Graphics.loadImageResolved("graphics/hardcoded/hardcoded-3.png")
local winsimg = Graphics.loadImageResolved("graphics/hardcoded/hardcoded-5.png")
local marioimg = Graphics.loadImageResolved("graphics/hardcoded/hardcoded-7-1.png")
local luigiimg = Graphics.loadImageResolved("graphics/hardcoded/hardcoded-7-2.png")
local peachimg = Graphics.loadImageResolved("graphics/hardcoded/hardcoded-7-3.png")
local toadimg = Graphics.loadImageResolved("graphics/hardcoded/hardcoded-7-4.png")
local linkimg = Graphics.loadImageResolved("graphics/hardcoded/hardcoded-7-5.png")

local oneupimg = Graphics.loadImageResolved("graphics/hardcoded/hardcoded-33-3.png")
local twoupimg = Graphics.loadImageResolved("graphics/hardcoded/hardcoded-33-7.png")
local timesimg = Graphics.loadImageResolved("graphics/hardcoded/hardcoded-33-1.png")
local numberfont = textplus.loadFont("textplus/font/1.ini")

function dependencies.onInitAPI()
	registerEvent(dependencies, "onStart")
	registerEvent(dependencies, "onLoad")
	registerEvent(dependencies, "onTick")
	registerEvent(dependencies, "onDraw")
	registerEvent(dependencies, "onExit")
	registerEvent(dependencies, "onCameraUpdate")
	registerEvent(dependencies, "onInputUpdate")
	registerEvent(dependencies, "onPlayerHarm")
	registerEvent(dependencies, "onPostPlayerKill")
    registerEvent(dependencies, "onPlayerKill")
end

function rngrunstate()
	exitscreen = true
	Audio.MusicChange(0, 0)
	Routine.wait(0.4)
	Misc.saveGame()
	GameData.battlemodeactive = true
	Level.load(smastables.__classicBattleModeLevels[rng.randomInt(1,#smastables.__classicBattleModeLevels)], nil, nil)
end

function restartmode()
	exitscreen = true
	Audio.MusicChange(0, 0)
	Routine.wait(0.4)
	Misc.saveGame()
	GameData.battlemodeactive = true
	Level.load(Level.filename(), nil, nil)
end

function exitbattlemode()
	Graphics.activateHud(false)
	Defines.player_hasCheated = false
	exitscreen = true
	Audio.MusicChange(0, 0)
	Routine.wait(0.4)
	GameData.battlemodeactive = false
    setBattleLives(0)
	activate1stPlayer()
	Misc.saveGame()
	Level.load("SMAS - Start.lvlx", nil, nil)
end

function battlediedanimation()
    if smashudsystem.activated == true then
		if GameData.bootmenuactive == false or GameData.bootmenuactive == nil then
			if not Misc.inMarioChallenge() then
                if GameData.multiplayeractive == true then
                    if GameData.battlemodeactive == true then --If Classic Battle Mode is active, the animation won't be active, but lives will decrease
                        if killed1 == true then
                            dependencies.p1lives = dependencies.p1lives - 1
                            killed1 = false
                        elseif killed2 == true then
                            dependencies.p2lives = dependencies.p2lives - 1
                            killed2 = false
                        end
                    end
                end
            end
        end
    end
end

function p1teleportdoor()
	Routine.waitFrames(30)
	player:mem(0x140,FIELD_WORD,100)
    if player2OrMoreActive() then
        player2:mem(0x140,FIELD_WORD,100)
        Player(2):teleport(Player(1).x - 32, Player(1).y - 32, bottomCenterAligned)
    end
end

function p2teleportdoor()
	Routine.waitFrames(30)
	player:mem(0x140,FIELD_WORD,100)
    if player2OrMoreActive() then
        player2:mem(0x140,FIELD_WORD,100)
    end
	Player(1):teleport(Player(2).x - 32, Player(2).y - 32, bottomCenterAligned)
end

function classicbattlerevivep1()
	diedp1 = true
	Routine.waitFrames(300, true)
	revivep1 = true
	Routine.wait(0.3, true)
	revivep1 = false
	diedp1 = false
	Player(1):teleport(Player(2).x - 32, Player(2).y - 32, bottomCenterAligned)
	SFX.play(34)
end

function classicbattlerevivep2()
    if player2OrMoreActive() then
        diedp2 = true
        Routine.waitFrames(300, true)
        revivep2 = true
        Routine.wait(0.3, true)
        revivep2 = false
        diedp2 = false
        Player(2):teleport(Player(1).x + 32, Player(1).y + 32, bottomCenterAligned)
        SFX.play(34)
    end
end

function classicbattlep1wins()
	for i = 0,20 do
		local section = Section(i)
		section.music = 0
	end
	player1vuln = true
	Routine.waitFrames(220, true)
	playSound("classicbattle-won.ogg")
	player1won = true
	Routine.wait(4.5, true)
	littleDialogue.create({text = "<setPos 400 32 0.5 -2.5><question MainSelect>", pauses = true, updatesInPause = true})
end

function classicbattlep2wins()
    if player2OrMoreActive() then
        for i = 0,20 do
            local section = Section(i)
            section.music = 0
        end
        player2vuln = true
        Routine.waitFrames(220, true)
        playSound("classicbattle-won.ogg")
        player2won = true
        Routine.wait(4.5, true)
        littleDialogue.create({text = "<setPos 400 32 0.5 -2.5><question MainSelect>", pauses = true, updatesInPause = true})
    end
end

function countdownbegin()
	Routine.wait(0.1)
	Misc.pause()
	characteroneimgshow = true
	playSound("battle-countdown.ogg")
	Routine.wait(1, true)
	vsimgshow = true
	playSound("battle-countdown.ogg")
	Routine.wait(1, true)
	charactertwoimgshow = true
	playSound("battle-countdown.ogg")
	Routine.wait(1, true)
	Misc.unpause()
	characteroneimgshow = false
	charactertwoimgshow = false
	vsimgshow = false
	playSound("battle-start.ogg")
end

function dependencies.onInputUpdate()
	if diedp1 then
		player.upKeyPressing = false
		player.downKeyPressing = false
		player.leftKeyPressing = false
		player.rightKeyPressing = false
		player.altJumpKeyPressing = false
		player.runKeyPressing = false
		player.altRunKeyPressing = false
		player.dropItemKeyPressing = false
		player.jumpKeyPressing = false
		player.pauseKeyPressing = false
	end
	if diedp2 then
        if player2OrMoreActive() then
            player2.upKeyPressing = false
            player2.downKeyPressing = false
            player2.leftKeyPressing = false
            player2.rightKeyPressing = false
            player2.altJumpKeyPressing = false
            player2.runKeyPressing = false
            player2.altRunKeyPressing = false
            player2.dropItemKeyPressing = false
            player2.jumpKeyPressing = false
            player2.pauseKeyPressing = false
        end
	end
	if revivep1 and player2vuln == false then
		player.keys.jump = KEYS_PRESSED
	end
	if revivep2 and player1vuln == false then
        if player2OrMoreActive() then
            player2.keys.jump = KEYS_PRESSED
        end
	end
end

function dependencies.onPostPlayerKill() --onPost is used in case if onPlayerKill wasn't cancelled, to prevent things such as dying on the flagpole animation
	Routine.run(battlediedanimation) --This will run the animation. Without it, the player would just die
end

function dependencies.onDraw()
	if player.deathTimer == 1 then
		--Routine.run(classicbattlerevivep1)
	end
	if player.deathTimer == 1 and dependencies.p1lives < 0 then
		dependencies.p1lives = 0
		Routine.run(classicbattlep2wins)
	end
    if player2OrMoreActive() then
        if player2.deathTimer == 1 then
            --Routine.run(classicbattlerevivep2)
        end
        if player2.deathTimer == 1 and dependencies.p2lives < 0 then
            dependencies.p2lives = 0
            Routine.run(classicbattlep1wins)
        end
    end
	if exitscreen then
		Graphics.drawScreen{color = Color.black, priority = 10}
	end
	if characteroneimgshow then
		if player.character == CHARACTER_MARIO then
			Graphics.drawImageWP(marioimg, 271, 192, -3)
		end
		if player.character == CHARACTER_LUIGI then
			Graphics.drawImageWP(luigiimg, 271, 192, -3)
		end
		if player.character == CHARACTER_PEACH then
			Graphics.drawImageWP(peachimg, 271, 192, -3)
		end
		if player.character == CHARACTER_TOAD then
			Graphics.drawImageWP(toadimg, 271, 192, -3)
		end
		if player.character == CHARACTER_LINK then
			Graphics.drawImageWP(linkimg, 271, 192, -3)
		end
	end
	if vsimgshow then
		Graphics.drawImageWP(vsimg, 383, 196, -3)
	end
	if charactertwoimgshow then
		if player2OrMoreActive() then
			if Player(2).character == CHARACTER_MARIO then
				Graphics.drawImageWP(marioimg, 450, 193, -3)
			end
			if Player(2).character == CHARACTER_LUIGI then
				Graphics.drawImageWP(luigiimg, 450, 193, -3)
			end
			if Player(2).character == CHARACTER_PEACH then
				Graphics.drawImageWP(peachimg, 450, 193, -3)
			end
			if Player(2).character == CHARACTER_TOAD then
				Graphics.drawImageWP(toadimg, 450, 193, -3)
			end
			if Player(2).character == CHARACTER_LINK then
				Graphics.drawImageWP(linkimg, 450, 193, -3)
			end
		end
	end
	if characterwinimgshow then
		if player.character == CHARACTER_MARIO then
			Graphics.drawImageWP(marioimg, 312, 193, -3)
		end
		if player.character == CHARACTER_LUIGI then
			Graphics.drawImageWP(luigiimg, 312, 193, -3)
		end
		if player.character == CHARACTER_PEACH then
			Graphics.drawImageWP(peachimg, 312, 193, -3)
		end
		if player.character == CHARACTER_TOAD then
			Graphics.drawImageWP(toadimg, 312, 193, -3)
		end
		if player.character == CHARACTER_LINK then
			Graphics.drawImageWP(linkimg, 312, 193, -3)
		end
	end
	if winimgshow then
		Graphics.drawImageWP(winsimg, 410, 193, -3)
	end
	Graphics.drawImageWP(twoupimg, 512, 26, -4.5)
	Graphics.drawImageWP(timesimg, 552, 27, -4.5)
	textplus.print{x=574, y=27, text = tostring(dependencies.p2lives), priority=-4.5, color=Color.white, font=numberfont}
	
	Graphics.drawImageWP(oneupimg, 194, 26, -4.5)
	Graphics.drawImageWP(timesimg, 234, 27, -4.5)
	textplus.print{x=256, y=27, text = tostring(dependencies.p1lives), priority=-4.5, color=Color.white, font=numberfont}
	if player1won then
		if player.character == CHARACTER_MARIO then
			Graphics.drawImageWP(marioimg, 312, 193, -3)
		end
		if player.character == CHARACTER_LUIGI then
			Graphics.drawImageWP(luigiimg, 312, 193, -3)
		end
		if player.character == CHARACTER_PEACH then
			Graphics.drawImageWP(peachimg, 312, 193, -3)
		end
		if player.character == CHARACTER_TOAD then
			Graphics.drawImageWP(toadimg, 312, 193, -3)
		end
		if player.character == CHARACTER_LINK then
			Graphics.drawImageWP(linkimg, 312, 193, -3)
		end
		Graphics.drawImageWP(winsimg, 410, 193, -3)
	end
	if player2won then
		if Player(2).character == CHARACTER_MARIO then
			Graphics.drawImageWP(marioimg, 312, 193, -3)
		end
		if Player(2).character == CHARACTER_LUIGI then
			Graphics.drawImageWP(luigiimg, 312, 193, -3)
		end
		if Player(2).character == CHARACTER_PEACH then
			Graphics.drawImageWP(peachimg, 312, 193, -3)
		end
		if Player(2).character == CHARACTER_TOAD then
			Graphics.drawImageWP(toadimg, 312, 193, -3)
		end
		if Player(2).character == CHARACTER_LINK then
			Graphics.drawImageWP(linkimg, 312, 193, -3)
		end
		Graphics.drawImageWP(winsimg, 410, 193, -3)
	end
end

function dependencies.onPlayerHarm(evt)
	if player1vuln == true then
		evt.cancelled = true
	end
	if player2vuln == true then
		evt.cancelled = true
	end
end

function dependencies.onStart()
	GameData.battlemodeactive = true
    player.powerup = 2
    if player2OrMoreActive() then
        player2.powerup = 2
    end
    mem(0x00B2D740, FIELD_BOOL, true) --This enables Battle Mode physics and projectiles
    setBattleLives(99) --To prevent dying and quitting out of the level
	Routine.run(countdownbegin)
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
	Cheats.deregister("dressmeup")
	Cheats.deregister("undress")
	Cheats.deregister("laundryday")
	littleDialogue.defaultStyleName = "smbx13og"
	Audio.sounds[1].sfx  = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/player-jump.ogg")
	Audio.sounds[2].sfx  = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/stomped.ogg")
	Audio.sounds[3].sfx  = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/block-hit.ogg")
	extrasounds.id[4]  = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/1.3Mode/block-smash.ogg"))
	Audio.sounds[5].sfx  = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/player-shrink.ogg")
	Audio.sounds[6].sfx  = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/player-grow.ogg")
	extrasounds.id[7]  = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/1.3Mode/mushroom.ogg"))
	extrasounds.id[8]  = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/player-died.ogg")
	Audio.sounds[9].sfx  = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/shell-hit.ogg")
	Audio.sounds[10].sfx = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/player-slide.ogg")
	Audio.sounds[11].sfx = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/item-dropped.ogg")
	Audio.sounds[12].sfx = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/has-item.ogg")
	Audio.sounds[13].sfx = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/camera-change.ogg")
	extrasounds.id[14] = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/1.3Mode/coin.ogg"))
	extrasounds.id[15] = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/1.3Mode/1up.ogg"))
	Audio.sounds[16].sfx = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/lava.ogg")
	Audio.sounds[17].sfx = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/warp.ogg")
	extrasounds.id[18] = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/1.3Mode/fireball.ogg"))
	Audio.sounds[19].sfx = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/level-win.ogg")
	Audio.sounds[20].sfx = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/boss-beat.ogg")
	Audio.sounds[21].sfx = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/dungeon-win.ogg")
	Audio.sounds[22].sfx = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/bullet-bill.ogg")
	Audio.sounds[23].sfx = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/grab.ogg")
	Audio.sounds[24].sfx = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/spring.ogg")
	Audio.sounds[25].sfx = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/hammer.ogg")
	Audio.sounds[29].sfx = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/do.ogg")
	Audio.sounds[31].sfx = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/key.ogg")
	Audio.sounds[32].sfx = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/pswitch.ogg")
	Audio.sounds[33].sfx = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/tail.ogg")
	Audio.sounds[34].sfx = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/racoon.ogg")
	Audio.sounds[35].sfx = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/boot.ogg")
	Audio.sounds[36].sfx = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/smash.ogg")
	Audio.sounds[37].sfx = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/thwomp.ogg")
	Audio.sounds[42].sfx = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/npc-fireball.ogg")
	extrasounds.id[43] = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/1.3Mode/fireworks.ogg"))
	Audio.sounds[44].sfx = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/bowser-killed.ogg")
	Audio.sounds[46].sfx = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/door.ogg")
	Audio.sounds[48].sfx = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/yoshi.ogg")
	Audio.sounds[49].sfx = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/yoshi-hurt.ogg")
	Audio.sounds[50].sfx = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/yoshi-tongue.ogg")
	Audio.sounds[51].sfx = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/yoshi-egg.ogg")
	Audio.sounds[52].sfx = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/got-star.ogg")
	Audio.sounds[54].sfx = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/player-died2.ogg")
	Audio.sounds[55].sfx = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/yoshi-swallow.ogg")
	Audio.sounds[57].sfx = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/dry-bones.ogg")
	Audio.sounds[58].sfx = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/smw-checkpoint.ogg")
	extrasounds.id[59] = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/1.3Mode/dragon-coin.ogg"))
	Audio.sounds[61].sfx = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/smw-blaarg.ogg")
	Audio.sounds[62].sfx = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/wart-bubble.ogg")
	Audio.sounds[63].sfx = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/wart-die.ogg")
	Audio.sounds[71].sfx = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/climbing.ogg")
	Audio.sounds[72].sfx = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/swim.ogg")
	Audio.sounds[73].sfx = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/grab2.ogg")
	Audio.sounds[75].sfx = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/smb2-throw.ogg")
	Audio.sounds[76].sfx = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/smb2-hit.ogg")
	Audio.sounds[77].sfx = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/zelda-stab.ogg")
	Audio.sounds[78].sfx = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/zelda-hurt.ogg")
	Audio.sounds[79].sfx = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/zelda-heart.ogg")
	Audio.sounds[80].sfx = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/zelda-died.ogg")
	Audio.sounds[81].sfx = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/zelda-rupee.ogg")
	Audio.sounds[82].sfx = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/zelda-fire.ogg")
	Audio.sounds[83].sfx = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/zelda-item.ogg")
	Audio.sounds[84].sfx = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/zelda-key.ogg")
	Audio.sounds[85].sfx = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/zelda-shield.ogg")
	Audio.sounds[86].sfx = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/zelda-dash.ogg")
	Audio.sounds[87].sfx = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/zelda-fairy.ogg")
	Audio.sounds[88].sfx = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/zelda-grass.ogg")
	Audio.sounds[89].sfx = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/zelda-hit.ogg")
	Audio.sounds[90].sfx = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/zelda-sword-beam.ogg")
	Audio.sounds[91].sfx = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/bubble.ogg")
	extrasounds.id[92] = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/1.3Mode/sprout-vine.ogg")) --Vine sprout
	extrasounds.id[93] = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/1.3Mode/iceball.ogg")) --Iceball
	extrasounds.id[94] = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/1.3Mode/yi_freeze.ogg")) --Freeze enemies
	extrasounds.id[95] = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/1.3Mode/yi_icebreak.ogg")) --Enemy ice breaker
	extrasounds.id[96] = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/1.3Mode/2up.ogg")) --2UP
	extrasounds.id[97] = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/1.3Mode/3up.ogg")) --3UP
	extrasounds.id[98] = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/1.3Mode/5up.ogg")) --5UP
	extrasounds.id[99] = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/1.3Mode/dragon-coin.ogg")) --Dragon Coin #2
	extrasounds.id[100] = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/1.3Mode/dragon-coin.ogg")) --Dragon Coin #3
	extrasounds.id[101] = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/1.3Mode/dragon-coin.ogg")) --Dragon Coin #4
	extrasounds.id[102] = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/1.3Mode/dragon-coin.ogg")) --Dragon Coin #5
	extrasounds.id[103] = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/1.3Mode/cherry.ogg")) --Cherry
	extrasounds.id[104] = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/1.3Mode/explode.ogg")) --SMB2 Explosion
	extrasounds.id[105] = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/1.3Mode/hammerthrow.ogg")) --Player hammer throw
	extrasounds.id[106] = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/1.3Mode/combo1.ogg")) --Shell hit 2
	extrasounds.id[107] = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/1.3Mode/combo2.ogg")) --Shell hit 3
	extrasounds.id[108] = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/1.3Mode/combo3.ogg")) --Shell hit 4
	extrasounds.id[109] = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/1.3Mode/combo4.ogg")) --Shell hit 5
	extrasounds.id[110] = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/1.3Mode/combo5.ogg")) --Shell hit 6
	extrasounds.id[111] = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/1.3Mode/combo6.ogg")) --Shell hit 7
	extrasounds.id[112] = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/1.3Mode/combo7.ogg")) --Shell hit 8
end

function dependencies.onTick()
	if(not killed1 and player:mem(0x13E,FIELD_BOOL)) then
		killed1 = true --killed1 detects to see if the 1st player is dead.
	end
	if player2OrMoreActive() then --2nd player compability
		GameData.multiplayeractive = true --This makes sure the death animation doesn't play when on multiplayer
		if GameData.battlemodeactive == true then
			if(not killed2 and Player(2):mem(0x13E,FIELD_BOOL)) then
				killed2 = true --killed2 detects to see if the 2nd player is dead.
			end
		end
	end
    mem(0x00B2D760, FIELD_WORD, -1) --"Mario VS Luigi" Text
    mem(0x00B2D762, FIELD_WORD, -1) --"Wins!" Text
    for index,scoreboard in ipairs(Animation.get(79)) do --Score values!
        if scoreboard.animationFrame == 9 and scoreboard.speedY == -1.94 then --1UP
            dependencies.p1lives = dependencies.p1lives + 1
            dependencies.p2lives = dependencies.p2lives + 1
            Misc.score(10000) --Score values from SMAS++ normal mode will still be applied here.
        end
        if scoreboard.animationFrame == 10 and scoreboard.speedY == -1.94 then --2UP
            dependencies.p1lives = dependencies.p1lives + 2
            dependencies.p2lives = dependencies.p2lives + 2
            Misc.score(20000)
        end
        if scoreboard.animationFrame == 11 and scoreboard.speedY == -1.94 then --3UP
            dependencies.p1lives = dependencies.p1lives + 3
            dependencies.p2lives = dependencies.p2lives + 3
            Misc.score(30000)
        end
        if scoreboard.animationFrame == 12 and scoreboard.speedY == -1.94 then --5UP
            dependencies.p1lives = dependencies.p1lives + 5
            dependencies.p2lives = dependencies.p2lives + 5
            Misc.score(50000)
        end
    end
	smashud.visible.keys = false
	smashud.visible.itembox = true
	smashud.visible.bombs = true
	smashud.visible.coins = false
	smashud.visible.score = false
	smashud.visible.lives = false
	smashud.visible.stars = false
	smashud.visible.starcoins = false
	smashud.visible.timer = false
	if player2OrMoreActive() then
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
	if player2OrMoreActive() then
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
	if table.icontains(smastables.__smb2Levels,Level.filename()) == true then
		if NPC.config[274].score == 11 then
			playSound(147)
			NPC.config[274].score = 6
		end
	elseif Level.filename() then
		if NPC.config[274].score == 11 then
			NPC.config[274].score = 6 --Nothing plays btw, just resets
		end
	end
end

function dependencies.onExit()
    if GameData.battlemodeactive == true then --Reset the lives on Classic Battle Mode back to 5 when exiting...
		dependencies.p1lives = 3
		dependencies.p2lives = 3
	end
    mem(0x00B2D740, FIELD_BOOL, false)
	if killed == true then
		Level.load(Level.filename(), nil, nil)
	end
end

littleDialogue.registerAnswer("MainSelect",{text = "Start a New Stage",chosenFunction = function() Routine.run(rngrunstate) end})
littleDialogue.registerAnswer("MainSelect",{text = "Play this Stage Again",chosenFunction = function() Routine.run(restartmode) end})
littleDialogue.registerAnswer("MainSelect",{text = "Exit Battle Mode",chosenFunction = function() Routine.run(exitbattlemode) end})

return dependencies