local yoshi = require("yiYoshi/yiYoshi")
local map3d = require("mapp3d")

local textplus = require("textplus")
local playerManager = require("playermanager")
local pressedKeys = {};
function playerManager.onInputUpdate()
    --Set up the world map to support changing to all characters via the pause menu
    if(isOverworld) then
        if Misc.isPaused() then
            if(not player.rightKeyPressing) then
                pressedKeys.right = false;
            end
            if(not player.leftKeyPressing) then
                pressedKeys.left = false;
            end
        end
            
        --Adjust character if necessary
        if(charoffset ~= nil) then
            if characterindex == 0 or playerManager.overworldCharacters[characterindex] ~= player.character then
                characterindex = 0
                for k,v in ipairs(playerManager.overworldCharacters) do
                    if v == player.character then
                        characterindex = k
                        break
                    end
                end
            end
        
            local index

            if characterindex > 0 then
                characterindex = ((characterindex-1+charoffset)%#playerManager.overworldCharacters) + 1
            else
                characterindex = 1
            end
            index = playerManager.overworldCharacters[characterindex]
            
            if index == nil then
                index = 1
                characterindex = 0
            end
            
            player:transform(index)
            updateCharacterHitbox(player.character)
            local ps = PlayerSettings.get(characters[player.character].base, player.powerup)
            if player:mem(0x108,FIELD_WORD) == 1 then
                player.height = 54
            else
                player.height = ps.hitboxHeight
            end
            player.width = ps.hitboxWidth
            Audio.playSFX(26)
        end
            
        --world:mem(0x112,FIELD_WORD,player.character)
        --Disable vanilla character switch (can we do this better?)
        if Misc.isPaused() then
            player.rightKeyPressing = false;
            player.leftKeyPressing = false;
        end
    end
end
local lib3d = require("lib3d")
local travL = require("travL")
local wandR = require("wandRr")
local Routine = require("routine")
local smoothWorld = require("smoothWorld")
local repl = require("repll")
--local pausemenu = require("pausemenu2")
local pauseplus = require("pauseplus")

pauseplus.priority = 8

map3d.BGPlane.tile = 394
map3d.Light.enabled = false

local font1 = textplus.loadFont("littleDialogue/font/10.ini")
local font2 = textplus.loadFont("littleDialogue/font/sonicMania-smallFont.ini")
local hudborder = Graphics.loadImageResolved("graphics/hardcoded/hardcoded-33-4-tp-solidcoloronly.png")
local hudborderwide = Graphics.loadImageResolved("graphics/hardcoded/hardcoded-33-4-tp-wide.png")
local hudborderultrawide = Graphics.loadImageResolved("graphics/hardcoded/hardcoded-33-4-tp-ultrawide.png")
local hudbordernes = Graphics.loadImageResolved("graphics/hardcoded/hardcoded-33-4-tp-nes.png")
local hudbordergb = Graphics.loadImageResolved("graphics/hardcoded/hardcoded-33-4-tp-gb.png")
local hudbordergba = Graphics.loadImageResolved("graphics/hardcoded/hardcoded-33-4-tp-gba.png")
local hudborderiphoneone = Graphics.loadImageResolved("graphics/hardcoded/hardcoded-33-4-tp-iphone1st.png")
local hudborderthreeds = Graphics.loadImageResolved("graphics/hardcoded/hardcoded-33-4-tp-3ds.png")

local wideborder = Graphics.loadImageResolved("graphics/resolutionborders/widescreen.png")
local ultrawideborder = Graphics.loadImageResolved("graphics/resolutionborders/ultrawide.png")
local nesborder = Graphics.loadImageResolved("graphics/resolutionborders/nes.png")
local gbborder = Graphics.loadImageResolved("graphics/resolutionborders/gb.png")
local gbaborder = Graphics.loadImageResolved("graphics/resolutionborders/gba.png")
local iphoneoneborder = Graphics.loadImageResolved("graphics/resolutionborders/iphone1st.png")
local threedsborder = Graphics.loadImageResolved("graphics/resolutionborders/3ds.png")

local times = Graphics.loadImageResolved("graphics/hardcoded/hardcoded-33-1.png")
local coinicon = Graphics.loadImageResolved("graphics/hardcoded/hardcoded-33-2.png")
local oneupicon = Graphics.loadImageResolved("graphics/hardcoded/hardcoded-33-3.png")
local staricon = Graphics.loadImageResolved("graphics/hardcoded/hardcoded-33-5.png")

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
    Sound.playSFX("levelload.ogg")
    smasbooleans.musicMuted = true
    Audio.MusicVolume(0)
    Misc.pause()
    player:mem(0x17A, FIELD_BOOL, true)
    Routine.waitFrames(20, true)
    loadlevelanimation = true
    Routine.waitFrames(58, true)
    Misc.unpause()
    player:mem(0xFA, FIELD_BOOL, true)
    Routine.waitFrames(1, true)
    smasbooleans.musicMuted = false
    loadlevelanimation = nil
    loadlevelanimationin = true
    Audio.MusicVolume(65)
    nochangecharmap = false
    Routine.waitFrames(78, true)
    loadlevelanimationin = nil
end

function onInputUpdate()
    if Misc.isPausedByLua() == false then
        if world.levelTitle and world.levelObj then
            if player.rawKeys.jump == KEYS_PRESSED then
                if player.keys.left == KEYS_PRESSED then
                    player.keys.left = KEYS_UNPRESSED
                elseif player.keys.right == KEYS_PRESSED then
                    player.keys.right = KEYS_UNPRESSED
                end
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
    if not smasbooleans.musicMuted then
        Audio.MusicVolume(65)
    end
    if smasbooleans.musicMuted then
        Audio.MusicVolume(0)
    end
    Graphics.activateHud(false)
    if Misc.resolveFile("worlds/Super Mario All-Stars++/exeextracted.txt") == nil then
        --Nothing
    end
    if Misc.resolveFile("worlds/Super Mario All-Stars++/exeextracted.txt") == true then
        Misc.showRichDialog("EXE Extraction installination detected!", "Hello!\n\nAre you are trying to play the game on a public computer from a EXE Extraction install?\n\nIf so, things may be unstable with the episode running everything this\nway. Please use the official installination on your own\ncomputer to make the game work as intended.\n\nThank you!", true)
    end
    Audio.MusicVolume(nil)
    --mem(0xB25728, FIELD_BOOL, true) -- Sets the episode back to world map type. Without it, the intro will still play everytime you try to exit the level, rendering SMAS++ unusable
    if SaveData.disableX2char == false then
        --inventory = require("customInventory")
    end
    if SaveData.disableX2char == true then
        
    end
end

function onTick()
    Defines.player_hasCheated = false
    
    if SaveData.disableX2char == false then
        playerManager.overworldCharacters = {CHARACTER_MARIO, CHARACTER_LUIGI, CHARACTER_PEACH, CHARACTER_TOAD, CHARACTER_LINK, CHARACTER_MEGAMAN, CHARACTER_WARIO, CHARACTER_BOWSER, CHARACTER_YOSHI, CHARACTER_NINJABOMBERMAN, CHARACTER_ROSALINA, CHARACTER_SNAKE, CHARACTER_ZELDA, CHARACTER_ULTIMATERINKA, CHARACTER_UNCLEBROADSWORD, CHARACTER_SAMUS}
    end
    if SaveData.disableX2char == true then
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
    if SMBX_VERSION <= VER_BETA4_PATCH_4_1 then
        Graphics.sprites.player[10].img = Graphics.loadImageResolved("graphics/smbx2og/player/player-10.png")
        Graphics.sprites.player[14].img = Graphics.loadImageResolved("graphics/smbx2og/player/player-14.png")
    end
    if SaveData.resolution == "fullscreen" then
        if SaveData.disableX2char == true then
            map3d.CameraSettings.fov = 92.7 - 0.00872665
            map3d.CameraSettings.distance = 32
            map3d.CameraSettings.height = 320
            map3d.CameraSettings.angle = 90
            map3d.CameraSettings.heightAdjust = false
        end
        if SaveData.disableX2char == false then
            map3d.CameraSettings.fov = 60
            map3d.CameraSettings.distance = 300
            map3d.CameraSettings.height = 300
            map3d.CameraSettings.angle = 50
            map3d.CameraSettings.heightAdjust = true
        end
    end
    if SaveData.resolution == "widescreen" then
        if SaveData.disableX2char == true then
            map3d.CameraSettings.fov = 107.7 - 0.00872665
            map3d.CameraSettings.distance = 32
            map3d.CameraSettings.height = 320
            map3d.CameraSettings.angle = 90
            map3d.CameraSettings.heightAdjust = false
        end
        if SaveData.disableX2char == false then
            map3d.CameraSettings.fov = 75
            map3d.CameraSettings.distance = 300
            map3d.CameraSettings.height = 300
            map3d.CameraSettings.angle = 50
            map3d.CameraSettings.heightAdjust = true
        end
    end
    if SaveData.resolution == "ultrawide" then
        if SaveData.disableX2char == true then
            map3d.CameraSettings.fov = 122.7 - 0.00872665
            map3d.CameraSettings.distance = 32
            map3d.CameraSettings.height = 320
            map3d.CameraSettings.angle = 90
            map3d.CameraSettings.heightAdjust = false
        end
        if SaveData.disableX2char == false then
            map3d.CameraSettings.fov = 85
            map3d.CameraSettings.distance = 300
            map3d.CameraSettings.height = 300
            map3d.CameraSettings.angle = 50
            map3d.CameraSettings.heightAdjust = true
        end
    end
    if SaveData.resolution == "nes" then
        if SaveData.disableX2char == true then
            map3d.CameraSettings.fov = 107.7 - 0.00872665
            map3d.CameraSettings.distance = 32
            map3d.CameraSettings.height = 320
            map3d.CameraSettings.angle = 90
            map3d.CameraSettings.heightAdjust = false
        end
        if SaveData.disableX2char == false then
            map3d.CameraSettings.fov = 75
            map3d.CameraSettings.distance = 300
            map3d.CameraSettings.height = 300
            map3d.CameraSettings.angle = 50
            map3d.CameraSettings.heightAdjust = true
        end
    end
    if SaveData.resolution == "gameboy" then
        if SaveData.disableX2char == true then
            map3d.CameraSettings.fov = 142.7 - 0.00872665
            map3d.CameraSettings.distance = 52
            map3d.CameraSettings.height = 320
            map3d.CameraSettings.angle = 90
            map3d.CameraSettings.heightAdjust = false
        end
        if SaveData.disableX2char == false then
            map3d.CameraSettings.fov = 110
            map3d.CameraSettings.distance = 300
            map3d.CameraSettings.height = 300
            map3d.CameraSettings.angle = 50
            map3d.CameraSettings.heightAdjust = true
        end
    end
    if SaveData.resolution == "gba" then
        if SaveData.disableX2char == true then
            map3d.CameraSettings.fov = 117.7 - 0.00872665
            map3d.CameraSettings.distance = 46
            map3d.CameraSettings.height = 320
            map3d.CameraSettings.angle = 90
            map3d.CameraSettings.heightAdjust = false
        end
        if SaveData.disableX2char == false then
            map3d.CameraSettings.fov = 85
            map3d.CameraSettings.distance = 300
            map3d.CameraSettings.height = 300
            map3d.CameraSettings.angle = 50
            map3d.CameraSettings.heightAdjust = true
        end
    end
    if SaveData.resolution == "iphone1st" then
        if SaveData.disableX2char == true then
            map3d.CameraSettings.fov = 137.7 - 0.00872665
            map3d.CameraSettings.distance = 46
            map3d.CameraSettings.height = 320
            map3d.CameraSettings.angle = 90
            map3d.CameraSettings.heightAdjust = false
        end
        if SaveData.disableX2char == false then
            map3d.CameraSettings.fov = 105
            map3d.CameraSettings.distance = 300
            map3d.CameraSettings.height = 300
            map3d.CameraSettings.angle = 50
            map3d.CameraSettings.heightAdjust = true
        end
    end
    if SaveData.resolution == "3ds" then
        if SaveData.disableX2char == true then
            map3d.CameraSettings.fov = 123.7 - 0.00872665
            map3d.CameraSettings.distance = -69
            map3d.CameraSettings.height = 320
            map3d.CameraSettings.angle = 90
            map3d.CameraSettings.heightAdjust = false
        end
        if SaveData.disableX2char == false then
            map3d.CameraSettings.fov = 85
            map3d.CameraSettings.distance = 300
            map3d.CameraSettings.height = 450
            map3d.CameraSettings.angle = 50
            map3d.CameraSettings.heightAdjust = true
        end
    end
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
            
            if SaveData.resolution == "fullscreen" then
                p.direction = DIR_LEFT

                player:render{
                    x = 575,y = 25,
                    ignorestate = true,sceneCoords = false,priority = 2,color = (Defines.cheat_shadowmario and Color.black) or Color.white,
                    frame = frame,
                }


                if idx < Player.count() then
                    xPosition = 485 + 65
                end
                if Player.count() == 2 then
                    p2 = player2 or Player(2)
                    p2:render{
                        x = 510,y = 20,
                        ignorestate = true,sceneCoords = false,priority = 2,color = (Defines.cheat_shadowmario and Color.black) or Color.white,
                        frame = frame,
                    }
                end
            end
            if SaveData.resolution == "widescreen" then
                p.direction = DIR_LEFT

                player:render{
                    x = 525,y = 108,
                    ignorestate = true,sceneCoords = false,priority = 2,color = (Defines.cheat_shadowmario and Color.black) or Color.white,
                    frame = frame,
                }


                if idx < Player.count() then
                    xPosition = 485 + 65
                end
                if Player.count() == 2 then
                    p2 = player2 or Player(2)
                    p2:render{
                        x = 460,y = 108,
                        ignorestate = true,sceneCoords = false,priority = 2,color = (Defines.cheat_shadowmario and Color.black) or Color.white,
                        frame = frame,
                    }
                end
            end
            if SaveData.resolution == "ultrawide" then
                p.direction = DIR_LEFT

                player:render{
                    x = 615,y = 258,
                    ignorestate = true,sceneCoords = false,priority = 2,color = (Defines.cheat_shadowmario and Color.black) or Color.white,
                    frame = frame,
                }


                if idx < Player.count() then
                    xPosition = 485 + 65
                end
                if Player.count() == 2 then
                    p2 = player2 or Player(2)
                    p2:render{
                        x = 170,y = 258,
                        ignorestate = true,sceneCoords = false,priority = 2,color = (Defines.cheat_shadowmario and Color.black) or Color.white,
                        frame = frame,
                    }
                end
            end
            if SaveData.resolution == "nes" then
                p.direction = DIR_LEFT

                player:render{
                    x = 505,y = 115,
                    ignorestate = true,sceneCoords = false,priority = 2,color = (Defines.cheat_shadowmario and Color.black) or Color.white,
                    frame = frame,
                }


                if idx < Player.count() then
                    xPosition = 485 + 65
                end
                if Player.count() == 2 then
                    p2 = player2 or Player(2)
                    p2:render{
                        x = 440,y = 115,
                        ignorestate = true,sceneCoords = false,priority = 2,color = (Defines.cheat_shadowmario and Color.black) or Color.white,
                        frame = frame,
                    }
                end
            end
        end
    end
    if SaveData.resolution == "fullscreen" then
    
        Graphics.drawImageWP(hudborder, 0, 0, 1)
        
        if SaveData.disableX2char == true then
            Graphics.drawImageWP(oneupicon, 70, 558, 2)
            Graphics.drawImageWP(times, 105, 560, 2)
            textplus.print{x=124, y=558, text = tostring(mem(0x00B2C5AC,FIELD_FLOAT)), priority=2, color=Color.white, font=font2, xscale=1.5, yscale=1.5}
        end
        
        Graphics.drawImageWP(coinicon, 160, 558, 2)
        Graphics.drawImageWP(times, 178, 560, 2)
        textplus.print{x=197, y=558, text = tostring(mem(0x00B2C5A8,FIELD_WORD)), priority=2, color=Color.white, font=font2, xscale=1.5, yscale=1.5}
        Graphics.drawImageWP(staricon, 236, 558, 2)
        Graphics.drawImageWP(times, 254, 560, 2)
        textplus.print{x=272, y=558, text = tostring(mem(0x00B251E0, FIELD_WORD)), priority=2, color=Color.white, font=font2, xscale=1.5, yscale=1.5}
        Graphics.drawImageWP(coinicon, 326, 554, 3)
        Graphics.drawImageWP(coinicon, 330, 558, 2)
        Graphics.drawImageWP(times, 348, 560, 2)
        textplus.print{x=367, y=558, text = ""..SaveData.totalcoins.."", priority=2, color=Color.white, font=font2, xscale=1.5, yscale=1.5}
        textplus.print{x=64, y=70, text = "Selected level/warp:", priority=2, color=Color.yellow, font=font2, xscale=1.5, yscale=1.5}
        
        
        
        if world.levelTitle then
            textplus.print{x=64, y=111, text = world.levelTitle, priority=2, color=Color.yellow, font=font1} --Level title
        end
        
        
        if world.levelObj then
            textplus.print{x=64, y=92, text = world.levelObj.filename, priority=2, color=Color.yellow, font=font2} --Filename
            --textplus.print{x=260, y=75, text = "(Starting at warp "..world.levelObj.levelWarpNumber..")", priority=2, color=Color.yellow, font=font2}
        end
        
        
        if world.levelObj == nil then
            textplus.print{x=64, y=92, text = "N/A", priority=2, color=Color.yellow, font=font2}
        end
        
        
        
        Graphics.drawBox{x=695, y=552, width=100, height=20, color=Color.black..0.2, priority=3} --What's the day, sir?!
        textplus.print{x=700, y=557, text = "Date - ", priority=3, color=Color.white}
        textplus.print{x=733, y=557, text = os.date("%a"), priority=3, color=Color.white}
        textplus.print{x=754, y=557, text = os.date("%x"), priority=3, color=Color.white}
        
        
        Graphics.drawBox{x=719, y=575, width=76, height=20, color=Color.black..0.2, priority=3} --What time is it...!?
        textplus.print{x=724, y=580, text = "Time - ", priority=3, color=Color.white}
        textplus.print{x=755, y=580, text = os.date("%I"), priority=3, color=Color.white}
        textplus.print{x=765, y=580, text = ":", priority=3, color=Color.white}
        textplus.print{x=768, y=580, text = os.date("%M"), priority=3, color=Color.white}
        textplus.print{x=780, y=580, text = os.date("%p"), priority=3, color=Color.white}
    end
    if SaveData.resolution == "widescreen" then
        Graphics.drawImageWP(hudborderwide, 0, 0, 1)
        Graphics.drawImageWP(wideborder, 0, 0, 6)
        
        if SaveData.disableX2char == true then
            Graphics.drawImageWP(oneupicon, 70, 500, 2)
            Graphics.drawImageWP(times, 105, 502, 2)
            textplus.print{x=124, y=500, text = tostring(mem(0x00B2C5AC,FIELD_FLOAT)), priority=2, color=Color.white, font=font2, xscale=1.5, yscale=1.5}
        end
        Graphics.drawImageWP(coinicon, 160, 500, 2)
        Graphics.drawImageWP(times, 178, 502, 2)
        textplus.print{x=197, y=500, text = tostring(mem(0x00B2C5A8,FIELD_WORD)), priority=2, color=Color.white, font=font2, xscale=1.5, yscale=1.5}
        Graphics.drawImageWP(staricon, 236, 500, 2)
        Graphics.drawImageWP(times, 254, 502, 2)
        textplus.print{x=272, y=500, text = tostring(mem(0x00B251E0, FIELD_WORD)), priority=2, color=Color.white, font=font2, xscale=1.5, yscale=1.5}
        Graphics.drawImageWP(coinicon, 326, 496, 3)
        Graphics.drawImageWP(coinicon, 330, 500, 2)
        Graphics.drawImageWP(times, 348, 502, 2)
        textplus.print{x=367, y=500, text = ""..SaveData.totalcoins.."", priority=2, color=Color.white, font=font2, xscale=1.5, yscale=1.5}
        textplus.print{x=150, y=124, text = "Selected level/warp:", priority=2, color=Color.yellow, font=font2, xscale=1.5, yscale=1.5}
        if world.levelTitle then
            textplus.print{x=150, y=159, text = world.levelTitle, priority=2, color=Color.yellow, font=font1, xscale=0.8, yscale=0.8} --Level title
        end
        if world.levelObj then
            textplus.print{x=150, y=145, text = world.levelObj.filename, priority=2, color=Color.yellow, font=font2, xscale=0.8, yscale=0.8} --Filename
            --textplus.print{x=260, y=75, text = "(Starting at warp "..world.levelObj.levelWarpNumber..")", priority=2, color=Color.yellow, font=font2}
        end
        if world.levelObj == nil then
            textplus.print{x=150, y=145, text = "N/A", priority=2, color=Color.yellow, font=font2, xscale=0.8, yscale=0.8}
        end
        Graphics.drawBox{x=719, y=495, width=76, height=20, color=Color.black..0.2, priority=3}
        textplus.print{x=724, y=500, text = "Time - ", priority=3, color=Color.white} --What time is it...!?
        textplus.print{x=755, y=500, text = os.date("%I"), priority=3, color=Color.white}
        textplus.print{x=765, y=500, text = ":", priority=3, color=Color.white}
        textplus.print{x=768, y=500, text = os.date("%M"), priority=3, color=Color.white}
        textplus.print{x=780, y=500, text = os.date("%p"), priority=3, color=Color.white}
        Graphics.drawBox{x=695, y=472, width=100, height=20, color=Color.black..0.2, priority=3}
        textplus.print{x=700, y=477, text = "Date - ", priority=3, color=Color.white} --What's the day, sir?!
        textplus.print{x=733, y=477, text = os.date("%a"), priority=3, color=Color.white}
        textplus.print{x=752, y=477, text = os.date("%x"), priority=3, color=Color.white}
    end
    if SaveData.resolution == "ultrawide" then
        Graphics.drawImageWP(hudborderultrawide, 0, 0, 1)
        Graphics.drawImageWP(ultrawideborder, 0, 0, 6)
        
        if SaveData.disableX2char == true then
            Graphics.drawImageWP(oneupicon, 70, 440, 2)
            Graphics.drawImageWP(times, 105, 442, 2)
            textplus.print{x=124, y=440, text = tostring(mem(0x00B2C5AC,FIELD_FLOAT)), priority=2, color=Color.white, font=font2, xscale=1.5, yscale=1.5}
        end
        Graphics.drawImageWP(coinicon, 160, 440, 2)
        Graphics.drawImageWP(times, 178, 442, 2)
        textplus.print{x=197, y=440, text = tostring(mem(0x00B2C5A8,FIELD_WORD)), priority=2, color=Color.white, font=font2, xscale=1.5, yscale=1.5}
        Graphics.drawImageWP(staricon, 236, 440, 2)
        Graphics.drawImageWP(times, 254, 442, 2)
        textplus.print{x=272, y=440, text = tostring(mem(0x00B251E0, FIELD_WORD)), priority=2, color=Color.white, font=font2, xscale=1.5, yscale=1.5}
        Graphics.drawImageWP(coinicon, 326, 436, 3)
        Graphics.drawImageWP(coinicon, 330, 440, 2)
        Graphics.drawImageWP(times, 348, 442, 2)
        textplus.print{x=367, y=440, text = ""..SaveData.totalcoins.."", priority=2, color=Color.white, font=font2, xscale=1.5, yscale=1.5}
        textplus.print{x=212, y=164, text = "Selected level/warp:", priority=2, color=Color.yellow, font=font2, xscale=1, yscale=1}
        if world.levelTitle then
            textplus.print{x=212, y=189, text = world.levelTitle, priority=2, color=Color.yellow, font=font1, xscale=0.6, yscale=0.6} --Level title
        end
        if world.levelObj then
            textplus.print{x=212, y=178, text = world.levelObj.filename, priority=2, color=Color.yellow, font=font2, xscale=0.6, yscale=0.6} --Filename
            --textplus.print{x=260, y=75, text = "(Starting at warp "..world.levelObj.levelWarpNumber..")", priority=2, color=Color.yellow, font=font2}
        end
        if world.levelObj == nil then
            textplus.print{x=212, y=178, text = "N/A", priority=2, color=Color.yellow, font=font2, xscale=0.6, yscale=0.6}
        end
        Graphics.drawBox{x=695, y=422, width=100, height=20, color=Color.black..0.2, priority=3} --What's the day, sir?!
        textplus.print{x=700, y=427, text = "Date - ", priority=3, color=Color.white} 
        textplus.print{x=733, y=427, text = os.date("%a"), priority=3, color=Color.white}
        textplus.print{x=752, y=427, text = os.date("%x"), priority=3, color=Color.white}
        Graphics.drawBox{x=719, y=445, width=76, height=20, color=Color.black..0.2, priority=3} --What time is it...!?
        textplus.print{x=724, y=450, text = "Time - ", priority=3, color=Color.white}
        textplus.print{x=755, y=450, text = os.date("%I"), priority=3, color=Color.white}
        textplus.print{x=765, y=450, text = ":", priority=3, color=Color.white}
        textplus.print{x=768, y=450, text = os.date("%M"), priority=3, color=Color.white}
        textplus.print{x=780, y=450, text = os.date("%p"), priority=3, color=Color.white}
    end
    if SaveData.resolution == "nes" then
        Graphics.drawImageWP(hudbordernes, 0, 0, 1)
        if SaveData.borderEnabled == true then
            Graphics.drawImageWP(nesborder, 0, 0, 6)
        end
        
        if SaveData.disableX2char == true then
            Graphics.drawImageWP(oneupicon, 155, 500, 2)
            Graphics.drawImageWP(times, 190, 502, 2)
            textplus.print{x=209, y=500, text = tostring(mem(0x00B2C5AC,FIELD_FLOAT)), priority=2, color=Color.white, font=font2, xscale=1.5, yscale=1.5}
        end
        Graphics.drawImageWP(coinicon, 245, 500, 2)
        Graphics.drawImageWP(times, 263, 502, 2)
        textplus.print{x=282, y=500, text = tostring(mem(0x00B2C5A8,FIELD_WORD)), priority=2, color=Color.white, font=font2, xscale=1.5, yscale=1.5}
        Graphics.drawImageWP(staricon, 321, 500, 2)
        Graphics.drawImageWP(times, 339, 502, 2)
        textplus.print{x=357, y=500, text = tostring(mem(0x00B251E0, FIELD_WORD)), priority=2, color=Color.white, font=font2, xscale=1.5, yscale=1.5}
        Graphics.drawImageWP(coinicon, 411, 496, 3)
        Graphics.drawImageWP(coinicon, 415, 500, 2)
        Graphics.drawImageWP(times, 433, 502, 2)
        textplus.print{x=452, y=500, text = ""..SaveData.totalcoins.."", priority=2, color=Color.white, font=font2, xscale=1.5, yscale=1.5}
        
        
        textplus.print{x=185, y=140, text = "Selected level/warp:", priority=2, color=Color.yellow, font=font2, xscale=1.5, yscale=1.5}
        
        
        
        if world.levelObj then
            textplus.print{x=185, y=161, text = world.levelObj.filename, priority=2, color=Color.yellow, font=font2, xscale=0.8, yscale=0.8} --Filename
            --textplus.print{x=260, y=75, text = "(Starting at warp "..world.levelObj.levelWarpNumber..")", priority=2, color=Color.yellow, font=font2}
        end
        if world.levelObj == nil then
            textplus.print{x=185, y=161, text = "N/A", priority=2, color=Color.yellow, font=font2, xscale=0.8, yscale=0.8}
        end
        
        
        
        if world.levelTitle then
            textplus.print{x=185, y=175, text = world.levelTitle, priority=2, color=Color.yellow, font=font1, xscale=0.8, yscale=0.8} --Level title
        end
        
        Graphics.drawBox{x=545, y=472, width=100, height=20, color=Color.black..0.2, priority=3} --What's the day, sir?!
        textplus.print{x=550, y=477, text = "Date - ", priority=3, color=Color.white}
        textplus.print{x=583, y=477, text = os.date("%a"), priority=3, color=Color.white}
        textplus.print{x=602, y=477, text = os.date("%x"), priority=3, color=Color.white}
        Graphics.drawBox{x=569, y=495, width=76, height=20, color=Color.black..0.2, priority=3} --What time is it...!?
        textplus.print{x=574, y=500, text = "Time - ", priority=3, color=Color.white}
        textplus.print{x=605, y=500, text = os.date("%I"), priority=3, color=Color.white}
        textplus.print{x=615, y=500, text = ":", priority=3, color=Color.white}
        textplus.print{x=618, y=500, text = os.date("%M"), priority=3, color=Color.white}
        textplus.print{x=630, y=500, text = os.date("%p"), priority=3, color=Color.white}
    end
    
    if SaveData.resolution == "gameboy" then
        Graphics.drawImageWP(hudbordergb, 0, 0, 1)
        if SaveData.borderEnabled == true then
            Graphics.drawImageWP(gbborder, 0, 0, 6)
        end
        
        if SaveData.disableX2char == true then
            Graphics.drawImageWP(oneupicon, 250, 400, 0, 0, 16, 8, 2)
            Graphics.drawImageWP(times, 270, 401, 0, 0, 6, 6, 2)
            textplus.print{x=279, y=403, text = tostring(mem(0x00B2C5AC,FIELD_FLOAT)), priority=2, color=Color.white, font=font2, xscale=0.4, yscale=0.4}
        end
        Graphics.drawImageWP(coinicon, 292, 400, 0, 0, 7, 7, 2)
        Graphics.drawImageWP(times, 303, 401, 0, 0, 6, 6, 2)
        textplus.print{x=313, y=403, text = tostring(mem(0x00B2C5A8,FIELD_WORD)), priority=2, color=Color.white, font=font2, xscale=0.4, yscale=0.4}
        Graphics.drawImageWP(staricon, 323, 400, 0, 0, 7, 7, 2)
        Graphics.drawImageWP(times, 334, 401, 0, 0, 6, 6, 2)
        textplus.print{x=344, y=403, text = tostring(mem(0x00B251E0, FIELD_WORD)), priority=2, color=Color.white, font=font2, xscale=0.4, yscale=0.4}
        Graphics.drawImageWP(coinicon, 364, 396, 0, 0, 6, 6, 3)
        Graphics.drawImageWP(coinicon, 368, 400, 0, 0, 6, 6, 2)
        Graphics.drawImageWP(times, 379, 401, 0, 0, 6, 6, 2)
        textplus.print{x=389, y=403, text = ""..SaveData.totalcoins.."", priority=2, color=Color.white, font=font2, xscale=0.4, yscale=0.4}
        
        
        
        textplus.print{x=266, y=209, text = "Selected level/warp:", priority=2, color=Color.yellow, font=font2, xscale=0.4, yscale=0.4}
        
        
        
        if world.levelObj then
            textplus.print{x=266, y=216, text = world.levelObj.filename, priority=2, color=Color.yellow, font=font2, xscale=0.2, yscale=0.2} --Filename
            --textplus.print{x=260, y=75, text = "(Starting at warp "..world.levelObj.levelWarpNumber..")", priority=2, color=Color.yellow, font=font2}
        end
        if world.levelObj == nil then
            textplus.print{x=266, y=216, text = "N/A", priority=2, color=Color.yellow, font=font2, xscale=0.2, yscale=0.2}
        end
        
        
        
        if world.levelTitle then
            textplus.print{x=266, y=222, text = world.levelTitle, priority=2, color=Color.yellow, font=font1, xscale=0.4, yscale=0.4} --Level title
        end
        
        Graphics.drawBox{x=524, y=395, width=33, height=7, color=Color.black..0.2, priority=3} --What's the day, sir?!
        textplus.print{x=525, y=397, text = "Date - ", priority=3, color=Color.white, xscale=0.4, yscale=0.4}
        textplus.print{x=534, y=397, text = os.date("%a"), priority=3, color=Color.white, xscale=0.4, yscale=0.4}
        textplus.print{x=541, y=397, text = os.date("%x"), priority=3, color=Color.white, xscale=0.4, yscale=0.4}
        Graphics.drawBox{x=532, y=404, width=25, height=7, color=Color.black..0.2, priority=3} --What time is it...!?
        textplus.print{x=533, y=406, text = "Time - ", priority=3, color=Color.white, xscale=0.4, yscale=0.4}
        textplus.print{x=540, y=406, text = os.date("%I"), priority=3, color=Color.white, xscale=0.4, yscale=0.4}
        textplus.print{x=543, y=406, text = ":", priority=3, color=Color.white, xscale=0.4, yscale=0.4}
        textplus.print{x=546, y=406, text = os.date("%M"), priority=3, color=Color.white, xscale=0.4, yscale=0.4}
        textplus.print{x=550, y=406, text = os.date("%p"), priority=3, color=Color.white, xscale=0.4, yscale=0.4}
    end
    
    if SaveData.resolution == "gba" then
        Graphics.drawImageWP(hudbordergba, 0, 0, 1)
        if SaveData.borderEnabled == true then
            Graphics.drawImageWP(gbaborder, 0, 0, 6)
        end
        
        if SaveData.disableX2char == true then
            Graphics.drawImageWP(oneupicon, 165, 440, 2)
            Graphics.drawImageWP(times, 200, 442, 2)
            textplus.print{x=220, y=445, text = tostring(mem(0x00B2C5AC,FIELD_FLOAT)), priority=2, color=Color.white, font=font2, xscale=1, yscale=1}
        end
        Graphics.drawImageWP(coinicon, 245, 440, 2)
        Graphics.drawImageWP(times, 264, 442, 2)
        textplus.print{x=284, y=445, text = tostring(mem(0x00B2C5A8,FIELD_WORD)), priority=2, color=Color.white, font=font2, xscale=1, yscale=1}
        Graphics.drawImageWP(staricon, 310, 440, 2)
        Graphics.drawImageWP(times, 334, 442, 2)
        textplus.print{x=354, y=445, text = tostring(mem(0x00B251E0, FIELD_WORD)), priority=2, color=Color.white, font=font2, xscale=1, yscale=1}
        Graphics.drawImageWP(coinicon, 388, 436, 3)
        Graphics.drawImageWP(coinicon, 392, 440, 2)
        Graphics.drawImageWP(times, 410, 442, 2)
        textplus.print{x=430, y=445, text = ""..SaveData.totalcoins.."", priority=2, color=Color.white, font=font2, xscale=1, yscale=1}
        
        
        
        textplus.print{x=224, y=175, text = "Selected level/warp:", priority=2, color=Color.yellow, font=font2, xscale=0.7, yscale=0.7}
        
        
        
        if world.levelObj then
            textplus.print{x=224, y=187, text = world.levelObj.filename, priority=2, color=Color.yellow, font=font2, xscale=0.65, yscale=0.65} --Filename
            --textplus.print{x=260, y=75, text = "(Starting at warp "..world.levelObj.levelWarpNumber..")", priority=2, color=Color.yellow, font=font2}
        end
        if world.levelObj == nil then
            textplus.print{x=224, y=187, text = "N/A", priority=2, color=Color.yellow, font=font2, xscale=0.7, yscale=0.7}
        end
        
        
        
        if world.levelTitle then
            textplus.print{x=224, y=200, text = world.levelTitle, priority=2, color=Color.yellow, font=font1, xscale=0.5, yscale=0.5} --Level title
        end
        
        
        
        Graphics.drawBox{x=555, y=425, width=80, height=15, color=Color.black..0.2, priority=3} --What's the day, sir?!
        textplus.print{x=560, y=429, text = "Date - ", priority=3, color=Color.white, xscale=0.8, yscale=0.8}
        textplus.print{x=585, y=429, text = os.date("%a"), priority=3, color=Color.white, xscale=0.8, yscale=0.8}
        textplus.print{x=600, y=429, text = os.date("%x"), priority=3, color=Color.white, xscale=0.8, yscale=0.8}
        Graphics.drawBox{x=570, y=442, width=65, height=15, color=Color.black..0.2, priority=3} --What time is it...!?
        textplus.print{x=575, y=447, text = "Time - ", priority=3, color=Color.white, xscale=0.8, yscale=0.8}
        textplus.print{x=600, y=447, text = os.date("%I"), priority=3, color=Color.white, xscale=0.8, yscale=0.8}
        textplus.print{x=606, y=447, text = ":", priority=3, color=Color.white, xscale=0.8, yscale=0.8}
        textplus.print{x=613, y=447, text = os.date("%M"), priority=3, color=Color.white, xscale=0.8, yscale=0.8}
        textplus.print{x=624, y=447, text = os.date("%p"), priority=3, color=Color.white, xscale=0.8, yscale=0.8}
    end
    if SaveData.resolution == "iphone1st" then
        Graphics.drawImageWP(hudborderiphoneone, 0, 0, 1)
        if SaveData.borderEnabled == true then
            Graphics.drawImageWP(iphoneoneborder, 0, 0, 6)
        end
        
        if SaveData.disableX2char == true then
            Graphics.drawImageWP(oneupicon, 360, 430, 2)
            Graphics.drawImageWP(times, 395, 432, 2)
            textplus.print{x=414, y=430, text = tostring(mem(0x00B2C5AC,FIELD_FLOAT)), priority=2, color=Color.white, font=font2, xscale=1.5, yscale=1.5}
        end
        Graphics.drawImageWP(coinicon, 280, 460, 2)
        Graphics.drawImageWP(times, 298, 462, 2)
        textplus.print{x=317, y=460, text = tostring(mem(0x00B2C5A8,FIELD_WORD)), priority=2, color=Color.white, font=font2, xscale=1.5, yscale=1.5}
        Graphics.drawImageWP(staricon, 346, 460, 2)
        Graphics.drawImageWP(times, 364, 462, 2)
        textplus.print{x=382, y=460, text = tostring(mem(0x00B251E0, FIELD_WORD)), priority=2, color=Color.white, font=font2, xscale=1.5, yscale=1.5}
        Graphics.drawImageWP(coinicon, 426, 456, 3)
        Graphics.drawImageWP(coinicon, 430, 460, 2)
        Graphics.drawImageWP(times, 448, 462, 2)
        textplus.print{x=467, y=460, text = ""..SaveData.totalcoins.."", priority=2, color=Color.white, font=font2, xscale=1.5, yscale=1.5}
        textplus.print{x=295, y=222, text = "Selected level/warp:", priority=2, color=Color.yellow, font=font2, xscale=1, yscale=1}
        if world.levelTitle then
            textplus.print{x=295, y=245, text = world.levelTitle, priority=2, color=Color.yellow, font=font1, xscale=0.35, yscale=0.35} --Level title
        end
        if world.levelObj then
            textplus.print{x=295, y=235, text = world.levelObj.filename, priority=2, color=Color.yellow, font=font2, xscale=0.6, yscale=0.6} --Filename
            --textplus.print{x=260, y=75, text = "(Starting at warp "..world.levelObj.levelWarpNumber..")", priority=2, color=Color.yellow, font=font2}
        end
        if world.levelObj == nil then
            textplus.print{x=295, y=235, text = "N/A", priority=2, color=Color.yellow, font=font2, xscale=0.6, yscale=0.6}
        end
        Graphics.drawBox{x=10, y=552, width=100, height=20, color=Color.black..0.2, priority=3} --What's the day, sir?!
        textplus.print{x=15, y=557, text = "Date - ", priority=3, color=Color.white}
        textplus.print{x=48, y=557, text = os.date("%a"), priority=3, color=Color.white}
        textplus.print{x=69, y=557, text = os.date("%x"), priority=3, color=Color.white}
        
        
        Graphics.drawBox{x=10, y=575, width=76, height=20, color=Color.black..0.2, priority=3} --What time is it...!?
        textplus.print{x=15, y=580, text = "Time - ", priority=3, color=Color.white}
        textplus.print{x=46, y=580, text = os.date("%I"), priority=3, color=Color.white}
        textplus.print{x=56, y=580, text = ":", priority=3, color=Color.white}
        textplus.print{x=59, y=580, text = os.date("%M"), priority=3, color=Color.white}
        textplus.print{x=71, y=580, text = os.date("%p"), priority=3, color=Color.white}
    end
    
    if SaveData.resolution == "3ds" then
        Graphics.drawImageWP(hudborderthreeds, 0, 0, 1)
        if SaveData.borderEnabled == true then
            Graphics.drawImageWP(threedsborder, 0, 0, 6)
        end
        
        if SaveData.disableX2char == true then
            Graphics.drawImageWP(oneupicon, 165, 510, 2)
            Graphics.drawImageWP(times, 200, 512, 2)
            textplus.print{x=220, y=515, text = tostring(mem(0x00B2C5AC,FIELD_FLOAT)), priority=2, color=Color.white, font=font2, xscale=1, yscale=1}
        end
        Graphics.drawImageWP(coinicon, 245, 510, 2)
        Graphics.drawImageWP(times, 264, 512, 2)
        textplus.print{x=284, y=515, text = tostring(mem(0x00B2C5A8,FIELD_WORD)), priority=2, color=Color.white, font=font2, xscale=1, yscale=1}
        Graphics.drawImageWP(staricon, 310, 510, 2)
        Graphics.drawImageWP(times, 334, 512, 2)
        textplus.print{x=354, y=515, text = tostring(mem(0x00B251E0, FIELD_WORD)), priority=2, color=Color.white, font=font2, xscale=1, yscale=1}
        Graphics.drawImageWP(coinicon, 388, 516, 3)
        Graphics.drawImageWP(coinicon, 392, 510, 2)
        Graphics.drawImageWP(times, 410, 512, 2)
        textplus.print{x=430, y=515, text = ""..SaveData.totalcoins.."", priority=2, color=Color.white, font=font2, xscale=1, yscale=1}
        
        
        
        textplus.print{x=208, y=235, text = "Selected level/warp:", priority=2, color=Color.yellow, font=font2, xscale=0.7, yscale=0.7}
        
        
        
        if world.levelObj then
            textplus.print{x=208, y=247, text = world.levelObj.filename, priority=2, color=Color.yellow, font=font2, xscale=0.65, yscale=0.65} --Filename
            --textplus.print{x=260, y=75, text = "(Starting at warp "..world.levelObj.levelWarpNumber..")", priority=2, color=Color.yellow, font=font2}
        end
        if world.levelObj == nil then
            textplus.print{x=208, y=247, text = "N/A", priority=2, color=Color.yellow, font=font2, xscale=0.7, yscale=0.7}
        end
        
        
        
        if world.levelTitle then
            textplus.print{x=208, y=260, text = world.levelTitle, priority=2, color=Color.yellow, font=font1, xscale=0.5, yscale=0.5} --Level title
        end
        
        
        
        Graphics.drawBox{x=595, y=505, width=80, height=15, color=Color.black..0.2, priority=3} --What's the day, sir?!
        textplus.print{x=600, y=509, text = "Date - ", priority=3, color=Color.white, xscale=0.8, yscale=0.8}
        textplus.print{x=625, y=509, text = os.date("%a"), priority=3, color=Color.white, xscale=0.8, yscale=0.8}
        textplus.print{x=640, y=509, text = os.date("%x"), priority=3, color=Color.white, xscale=0.8, yscale=0.8}
        Graphics.drawBox{x=610, y=522, width=65, height=15, color=Color.black..0.2, priority=3} --What time is it...!?
        textplus.print{x=615, y=527, text = "Time - ", priority=3, color=Color.white, xscale=0.8, yscale=0.8}
        textplus.print{x=640, y=527, text = os.date("%I"), priority=3, color=Color.white, xscale=0.8, yscale=0.8}
        textplus.print{x=646, y=527, text = ":", priority=3, color=Color.white, xscale=0.8, yscale=0.8}
        textplus.print{x=653, y=527, text = os.date("%M"), priority=3, color=Color.white, xscale=0.8, yscale=0.8}
        textplus.print{x=664, y=527, text = os.date("%p"), priority=3, color=Color.white, xscale=0.8, yscale=0.8}
    end
    
    if loadlevelanimation then
        time = time + 1
        Graphics.drawScreen{color = Color.black..math.max(0,time/32),priority = 4}
    end
    if loadlevelanimationin then
        time = 2 - 1
        Graphics.drawScreen{color = Color.black..math.min(1,time/28),priority = 4}
    end
end

--Some cheats will break playing this game. Demo 2 will start having these cheats that could break any point of the game disabled. Most things, like the framerate, chracter stuff, most other cheats that won't break the game in normal cases, and until the release, imtiredofallthiswalking, will be kept in. To see a list of disabled cheats for levels, check out the luna.lua in the root of the episode.

--travR and wandR break when this code is being used.
Cheats.deregister("illparkwhereiwant") --Allows the player to move anywhere. travR and wandR will let the player move, but the player will keep going regardless of stopping... that's why it's disabled.