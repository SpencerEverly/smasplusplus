local steve = require("steve")
local textplus = require("textplus")
local playerManager = require("playermanager")
local yoshi = require("yiYoshi/yiYoshi")
local lib3d = require("lib3d")
local travL = require("travL")
local wandR = require("wandRr")
local jukebox = require("jukebox-v11")
local pause_music = require("map_music")
local Routine = require("routine")

local font1 = textplus.loadFont("littleDialogue/font/10.ini")
local font2 = textplus.loadFont("littleDialogue/font/sonicMania-smallFont.ini")
local hudborder = Graphics.loadImage("hardcoded-33-4-tp.png")
local times = Graphics.loadImage("hardcoded-33-1.png")
local coinicon = Graphics.loadImage("hardcoded-33-2.png")
local oneupicon = Graphics.loadImage("hardcoded-33-3.png")
local staricon = Graphics.loadImage("hardcoded-33-5.png")

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

local map3d = require("mapp3d")
map3d.CameraSettings.fov = 60
map3d.CameraSettings.height = 320;
map3d.BGPlane.tile = 394
map3d.Light.enabled = false
--map3d.Heightmap.texture = Graphics.loadImage("heightmap.png");
--map3d.Heightmap.position = vector.v2(6496, 0)

local middle = 0
local transitionTimer = 0

function levelload()
	if player.rawKeys.jump == KEYS_PRESSED then
		player.rawKeys.jump = KEYS_UNPRESSED
	end
	world.playerWalkingFrame = 1
	SFX.play("_OST/_Sound Effects/levelload.ogg")
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
	Routine.waitFrames(78, true)
	loadlevelanimationin = nil
end

function onInputUpdate()
	if Misc.isPausedByLua() == false then
		if world.levelTitle and world.levelObj then
			if player.rawKeys.jump == KEYS_PRESSED then
				Routine.run(levelload)
				if player.keys.left == KEYS_PRESSED then
					player.keys.left = KEYS_UNPRESSED
				elseif player.keys.right == KEYS_PRESSED then
					player.keys.right = KEYS_UNPRESSED
				end
			end
		end
	end
end

function onStart()
	Graphics.activateHud(false)
	if Misc.resolveFile("worlds/Super Mario All-Stars++/exeextracted.txt") == nil then
		--Nothing
	end
	if Misc.resolveFile("worlds/Super Mario All-Stars++/exeextracted.txt") == true then
		Misc.showRichDialog("EXE Extraction installination detected!", "Hello!\n\nAre you are trying to play the game on a public computer from a EXE Extraction install?\n\nIf so, things may be unstable with the episode running everything this\nway. Please use the official installination on your own\ncomputer to make the game work as intended.\n\nThank you!", true)
	end
	Audio.MusicVolume(nil)
	mem(0xB25728, FIELD_BOOL, false) -- Sets the episode back to world map type. Without it, the intro will still play everytime you try to exit the level, rendering SMAS++ unusable
	if SaveData.disableX2char == 0 then
		inventory = require("customInventory")
		smoothWorld = require("smoothWorld")
		pausemenu = require("pausemenu_map")
	end
	if SaveData.disableX2char == 1 then
		pausemenu13 = require("pausemenu13map")
	end
end

function onTick()
	Defines.player_hasCheated = false
	
	if SaveData.disableX2char == 0 then
		playerManager.overworldCharacters = {CHARACTER_MARIO, CHARACTER_LUIGI, CHARACTER_PEACH, CHARACTER_TOAD, CHARACTER_LINK, CHARACTER_MEGAMAN, CHARACTER_WARIO, CHARACTER_BOWSER, CHARACTER_YOSHI, CHARACTER_NINJABOMBERMAN, CHARACTER_ROSALINA, CHARACTER_SNAKE, CHARACTER_ZELDA, CHARACTER_ULTIMATERINKA, CHARACTER_UNCLEBROADSWORD, CHARACTER_SAMUS}
	end
	if SaveData.disableX2char == 1 then
		playerManager.overworldCharacters = {CHARACTER_MARIO, CHARACTER_LUIGI, CHARACTER_PEACH, CHARACTER_TOAD, CHARACTER_LINK}
	end
end

function onPause(evt) --Because there's a new pause menu, the og pause menu has to be disabled
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

function onDraw()
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
	Graphics.drawImageWP(coinicon, 326, 554, 4)
	Graphics.drawImageWP(coinicon, 330, 558, 5)
	Graphics.drawImageWP(times, 348, 560, 5)
	textplus.print{x=367, y=558, text = ""..SaveData.totalcoins.."", priority=5, color=Color.white, font=font2, xscale=1.5, yscale=1.5}
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
	Graphics.drawBox{x=719, y=575, width=76, height=20, color=Color.black..0.2, priority=8}
	textplus.print{x=724, y=580, text = "Time - ", priority=8, color=Color.white} --What time is it...!?
	textplus.print{x=755, y=580, text = os.date("%I"), priority=8, color=Color.white}
	textplus.print{x=765, y=580, text = ":", priority=8, color=Color.white}
	textplus.print{x=768, y=580, text = os.date("%M"), priority=8, color=Color.white}
	textplus.print{x=780, y=580, text = os.date("%p"), priority=8, color=Color.white}
	Graphics.drawBox{x=695, y=552, width=100, height=20, color=Color.black..0.2, priority=8}
	textplus.print{x=700, y=557, text = "Date - ", priority=8, color=Color.white} --What's the day, sir?!
	textplus.print{x=733, y=557, text = os.date("%a"), priority=8, color=Color.white}
	textplus.print{x=752, y=557, text = os.date("%x"), priority=8, color=Color.white}
	
	local customtileone = Graphics.loadImage("customtile401.png")
	Graphics.drawImageToSceneWP(customtileone, -3328, -1824, 4)
	
	if loadlevelanimation then
		time = time + 1
		Graphics.drawScreen{color = Color.black..math.max(0,time/32),priority = 10}
	end
	if loadlevelanimationin then
		time = 2 - 1
		Graphics.drawScreen{color = Color.black..math.min(1,time/28),priority = 10}
	end
end

--Some cheats will break playing this game. Demo 2 will start having these cheats that could break any point of the game disabled. Most things, like the framerate, chracter stuff, most other cheats that won't break the game in normal cases, and until the release, imtiredofallthiswalking, will be kept in. To see a list of disabled cheats for levels, check out the luna.lua in the root of the episode.

--travR and wandR break when this code is being used.
Cheats.deregister("illparkwhereiwant") --Allows the player to move anywhere. travR and wandR will let the player move, but the player will keep going regardless of stopping... that's why it's disabled.