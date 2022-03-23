local travL = require("travL")
local wandR = require("wandR")
local Routine = require("routine")
local textplus = require("textplus")
local smallScreen = require("smallScreen")
local pausemenu = require("pausemenu")

wandR.speed = 7
travL.showArrows = false

local map3d = require("mapp3d")
map3d.Light.enabled = false

local font1 = textplus.loadFont("littleDialogue/font/10.ini")
local font2 = textplus.loadFont("littleDialogue/font/sonicMania-smallFont.ini")
local hudborder = Graphics.loadImageResolved("hardcoded-33-4-tp.png")
local hudborderwide = Graphics.loadImageResolved("hardcoded-33-4-tp-wide.png")
local times = Graphics.loadImageResolved("hardcoded-33-1.png")
local coinicon = Graphics.loadImageResolved("hardcoded-33-2.png")
local oneupicon = Graphics.loadImageResolved("hardcoded-33-3.png")
local staricon = Graphics.loadImageResolved("hardcoded-33-5.png")

local loadlevelanimation = false
local levelnames = Level.get()
local timer = 100
local cooldown = 0
local progress = 0

local playerSprite

local timer1 = 0
local speed = 0
local numberup = 0
local time = 0

local opacity = timer1/speed
local middle = math.floor(timer1*numberup)

local middle = 0
local transitionTimer = 0
local nochangecharmap = false

function levelload()
	if player.rawKeys.jump == KEYS_PRESSED then
		player.rawKeys.jump = KEYS_UNPRESSED
	end
	nochangecharmap = true
	world.playerWalkingFrame = 1
	SFX.play("level-select2.ogg")
	Audio.MusicVolume(0)
	Misc.pause()
	player:mem(0x17A, FIELD_BOOL, true)
	Routine.waitFrames(20, true)
	loadlevelanimation = true
	Routine.waitFrames(58, true)
	Misc.unpause()
	player:mem(0xFA, FIELD_BOOL, true)
	Routine.waitFrames(1, true)
	loadlevelanimation = nil
	loadlevelanimationin = true
	Audio.MusicVolume(56)
	nochangecharmap = false
	Routine.waitFrames(78, true)
	loadlevelanimationin = nil
end

cameraBoundaries = {}

function onInputUpdate()
	if Misc.isPausedByLua() == false then
		if world.levelTitle and world.levelObj then
			if player.rawKeys.jump == KEYS_PRESSED then
				Routine.run(levelload)
			end
		end
	end
	if nochangecharmap then
		if player.keys.left == KEYS_PRESSED then
			player.keys.left = KEYS_UNPRESSED
		elseif player.keys.right == KEYS_PRESSED then
			player.keys.right = KEYS_UNPRESSED
		end
	end
end

function onStart()
    Misc.saveGame()
	Graphics.activateHud(false)
end

function onPause(evt)
    evt.cancelled = true;
    isPauseMenuOpen = not isPauseMenuOpen
end

walkCycles = {}

walkCycles[CHARACTER_MARIO]           = {[PLAYER_SMALL] = {1,2, framespeed = 8},[PLAYER_BIG] = {1,2,3,2, framespeed = 6}}
walkCycles[CHARACTER_LUIGI]           = walkCycles[CHARACTER_MARIO]
walkCycles[CHARACTER_PEACH]           = {[PLAYER_BIG] = {1,2,3,2, framespeed = 6}}
walkCycles[CHARACTER_TOAD]            = walkCycles[CHARACTER_PEACH]
walkCycles[CHARACTER_LINK]            = {[PLAYER_BIG] = {4,3,2,1, framespeed = 6}}
walkCycles[CHARACTER_MEGAMAN]         = {[PLAYER_BIG] = {2,3,2,4, framespeed = 12}}
walkCycles[CHARACTER_WARIO]           = walkCycles[CHARACTER_MARIO]
walkCycles[CHARACTER_BOWSER]          = walkCycles[CHARACTER_TOAD]
walkCycles[CHARACTER_KLONOA]          = walkCycles[CHARACTER_TOAD]
walkCycles[CHARACTER_NINJABOMBERMAN]  = walkCycles[CHARACTER_PEACH]
walkCycles[CHARACTER_ROSALINA]        = walkCycles[CHARACTER_PEACH]
walkCycles[CHARACTER_SNAKE]           = walkCycles[CHARACTER_LINK]
walkCycles[CHARACTER_ZELDA]           = walkCycles[CHARACTER_LUIGI]
walkCycles[CHARACTER_ULTIMATERINKA]   = walkCycles[CHARACTER_TOAD]
walkCycles[CHARACTER_UNCLEBROADSWORD] = walkCycles[CHARACTER_TOAD]
walkCycles[CHARACTER_SAMUS]           = walkCycles[CHARACTER_LINK]

walkCycles["SMW-MARIO"] = {[PLAYER_SMALL] = {1,2, framespeed = 8},[PLAYER_BIG] = {3,2,1, framespeed = 6}}
walkCycles["SMW-LUIGI"] = walkCycles["SMW-MARIO"]

walkCycles["ACCURATE-SMW-MARIO"] = walkCycles["SMW-MARIO"]
walkCycles["ACCURATE-SMW-LUIGI"] = walkCycles["SMW-MARIO"]
walkCycles["ACCURATE-SMW-TOAD"]  = walkCycles["SMW-MARIO"]

local yoshiAnimationFrames = {
        {bodyFrame = 0,headFrame = 0,headOffsetX = 0 ,headOffsetY = 0,bodyOffsetX = 0,bodyOffsetY = 0,playerOffset = 0},
        {bodyFrame = 1,headFrame = 0,headOffsetX = -1,headOffsetY = 2,bodyOffsetX = 0,bodyOffsetY = 1,playerOffset = 1},
        {bodyFrame = 2,headFrame = 0,headOffsetX = -2,headOffsetY = 4,bodyOffsetX = 0,bodyOffsetY = 2,playerOffset = 2},
        {bodyFrame = 1,headFrame = 0,headOffsetX = -1,headOffsetY = 2,bodyOffsetX = 0,bodyOffsetY = 1,playerOffset = 1},
	}
	
local bootBounceData = {}

function onTick()
	if SaveData.resolution == "widescreen" then
		map3d.CameraSettings.fov = 107.7 - 0.00872665
		map3d.CameraSettings.distance = 32
		map3d.CameraSettings.height = 320
		map3d.CameraSettings.angle = 90
		map3d.CameraSettings.heightAdjust = false
	end
	if SaveData.resolution == "fullscreen" or SaveData.resolution == "ultrawide" or SaveData.resolution == "nes" or SaveData.resolution == "gameboy" or SaveData.resolution == "gba" then
		map3d.CameraSettings.fov = 92.7
		map3d.CameraSettings.distance = 32
		map3d.CameraSettings.height = 320
		map3d.CameraSettings.angle = 90
		map3d.CameraSettings.heightAdjust = false
	end
end

function onDraw()
	if SaveData.resolution == "widescreen" then
		Graphics.drawImageWP(hudborderwide, 0, 0, 3)
		if SaveData.letterbox == false then
			smallScreen.scaleY = 1.33
		elseif SaveData.letterbox == true then
			smallScreen.scaleY = 1
		end
		Graphics.drawImageWP(oneupicon, 70, 500, 5)
		Graphics.drawImageWP(times, 105, 502, 5)
		textplus.print{x=124, y=500, text = tostring(mem(0x00B2C5AC, FIELD_FLOAT)), priority=5, color=Color.white, font=font2, xscale=1.5, yscale=1.5}
		Graphics.drawImageWP(coinicon, 160, 500, 5)
		Graphics.drawImageWP(times, 178, 502, 5)
		textplus.print{x=197, y=500, text = tostring(mem(0x00B2C5A8, FIELD_WORD)), priority=5, color=Color.white, font=font2, xscale=1.5, yscale=1.5}
		Graphics.drawImageWP(staricon, 236, 500, 5)
		Graphics.drawImageWP(times, 254, 502, 5)
		textplus.print{x=272, y=500, text = tostring(mem(0x00B251E0, FIELD_WORD)), priority=5, color=Color.white, font=font2, xscale=1.5, yscale=1.5}
		textplus.print{x=150, y=124, text = "Selected level/warp:", priority=5, color=Color.yellow, font=font2, xscale=1.5, yscale=1.5}
		if world.levelTitle then
			textplus.print{x=150, y=159, text = world.levelTitle, priority=5, color=Color.yellow, font=font1, xscale=0.8, yscale=0.8} --Level title
		end
		if world.levelObj then
			textplus.print{x=150, y=145, text = world.levelObj.filename, priority=5, color=Color.yellow, font=font2, xscale=0.8, yscale=0.8} --Filename
			--textplus.print{x=260, y=75, text = "(Starting at warp "..world.levelObj.levelWarpNumber..")", priority=5, color=Color.yellow, font=font2}
		end
		if world.levelObj == nil then
			textplus.print{x=150, y=145, text = "N/A", priority=5, color=Color.yellow, font=font2, xscale=0.8, yscale=0.8}
		end
	end
	if SaveData.resolution == "fullscreen" or SaveData.resolution == "ultrawide" or SaveData.resolution == "nes" or SaveData.resolution == "gameboy" or SaveData.resolution == "gba" then
		for idx,p in ipairs(Player.get()) do
			local animation = walkCycles[p:getCostume()] or walkCycles[p.character]

			if animation ~= nil then
				local frame

				local x = 500
				local y = 10 - p.height

				if p.mount == MOUNT_BOOT then -- bouncing along in a boot
					bootBounceData[idx] = bootBounceData[idx] or {speed = 0,offset = 0}
					local bounceData = bootBounceData[idx]
							
					if not Misc.isPaused() then
						bounceData.speed = bounceData.speed + Defines.player_grav
						bounceData.offset = bounceData.offset + bounceData.speed

						if bounceData.offset >= 0 then
							bounceData.speed = -3.4
							bounceData.offset = 0
						end
					end

					y = y + bounceData.offset

					frame = 1
				elseif p.mount == MOUNT_CLOWNCAR then -- don't think this is even possible? but eh it's here
					frame = 1
				elseif p.mount == MOUNT_YOSHI then -- riding yoshi, yoshi's animation is a complete mess
					frame = 30

					local yoshiAnimationData = yoshiAnimationFrames[(math.floor(lunatime.tick() / 8) % #yoshiAnimationFrames) + 1]

					local xOffset = 4
					local yOffset = (72 - p.height)

					p:mem(0x72,FIELD_WORD,yoshiAnimationData.headFrame + 5)
					p:mem(0x7A,FIELD_WORD,yoshiAnimationData.bodyFrame + 7)

					p:mem(0x6E,FIELD_WORD,20 - xOffset + yoshiAnimationData.headOffsetX)
					p:mem(0x70,FIELD_WORD,10 - yOffset + yoshiAnimationData.headOffsetY)

					p:mem(0x76,FIELD_WORD,0  - xOffset + yoshiAnimationData.bodyOffsetX)
					p:mem(0x78,FIELD_WORD,42 - yOffset + yoshiAnimationData.bodyOffsetY)

					p:mem(0x10E,FIELD_WORD,yoshiAnimationData.playerOffset - yOffset)
				else -- just good ol' walking
					local walkCycle = animation[p.powerup] or animation[PLAYER_BIG]

					frame = walkCycle[(math.floor(lunatime.tick() / walkCycle.framespeed) % #walkCycle) + 1]
				end

				p.direction = DIR_LEFT

				player:render{
					x = 575,y = 25,
					ignorestate = true,sceneCoords = false,priority = 6,color = (Defines.cheat_shadowmario and Color.black) or Color.white,
					frame = frame,
				}


				if idx < Player.count() then
					xPosition = 485 + 65
				end
				if Player.count() == 2 then
					p2 = player2 or Player(2)
					p2:render{
						x = 510,y = 20,
						ignorestate = true,sceneCoords = false,priority = 6,color = (Defines.cheat_shadowmario and Color.black) or Color.white,
						frame = frame,
					}
				end
			end
		end
		Graphics.drawImageWP(hudborder, 0, 0, 3)
		Graphics.drawImageWP(oneupicon, 70, 558, 5)
		Graphics.drawImageWP(times, 105, 560, 5)
		textplus.print{x=124, y=558, text = tostring(mem(0x00B2C5AC, FIELD_FLOAT)), priority=5, color=Color.white, font=font2, xscale=1.5, yscale=1.5}
		Graphics.drawImageWP(coinicon, 160, 558, 5)
		Graphics.drawImageWP(times, 178, 560, 5)
		textplus.print{x=197, y=558, text = tostring(mem(0x00B2C5A8, FIELD_WORD)), priority=5, color=Color.white, font=font2, xscale=1.5, yscale=1.5}
		Graphics.drawImageWP(staricon, 236, 558, 5)
		Graphics.drawImageWP(times, 254, 560, 5)
		textplus.print{x=272, y=558, text = tostring(mem(0x00B251E0, FIELD_WORD)), priority=5, color=Color.white, font=font2, xscale=1.5, yscale=1.5}
		textplus.print{x=64, y=70, text = "Selected level/warp:", priority=5, color=Color.yellow, font=font2, xscale=1.5, yscale=1.5}
		if world.levelTitle then
			textplus.print{x=64, y=111, text = world.levelTitle, priority=5, color=Color.yellow, font=font1} --Level title
		end
		if world.levelObj then
			textplus.print{x=64, y=92, text = world.levelObj.filename, priority=5, color=Color.yellow, font=font2} --Filename
			--textplus.print{x=260, y=75, text = "(Starting at warp "..world.levelObj.levelWarpNumber..")", priority=5, color=Color.yellow, font=font2}
		end
		if world.levelObj == nil then
			textplus.print{x=64, y=92, text = "N/A", priority=5, color=Color.yellow, font=font2}
		end
	end
	
	if loadlevelanimation then
		time = time + 1
		Graphics.drawScreen{color = Color.black..math.max(0,time/32),priority = 10}
	end
	if loadlevelanimationin then
		time = 2 - 1
		Graphics.drawScreen{color = Color.black..math.min(1,time/28),priority = 10}
	end
end

local playerManager = require("playerManager")
playerManager.overworldCharacters = {CHARACTER_MARIO, CHARACTER_LUIGI, CHARACTER_PEACH, CHARACTER_TOAD, CHARACTER_LINK}
