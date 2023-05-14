--smas2PlayerSystem.lua
--v1.0
--By Spencer Everly

local smas2PlayerSystem = {}

local handycam = require("handycam")
handycam[1].targets = {}

local customCamera = require("customCamera")

local player1Camera = Graphics.CaptureBuffer(800,600)
local player2Camera = Graphics.CaptureBuffer(800,600)
smas2PlayerSystem.player1CameraEdgeX = 0
smas2PlayerSystem.player1CameraEdgeY = 0
smas2PlayerSystem.player2CameraEdgeX = 0
smas2PlayerSystem.player2CameraEdgeY = 0

smas2PlayerSystem.enableSplitScreen = false

local pipecounter1p = 0
local pipecounter2p = 0

function smas2PlayerSystem.onInitAPI()
    registerEvent(smas2PlayerSystem,"onControllerButtonPress")
    registerEvent(smas2PlayerSystem,"onKeyboardPress")
    registerEvent(smas2PlayerSystem,"onStart")
    registerEvent(smas2PlayerSystem,"onDraw")
    registerEvent(smas2PlayerSystem,"onTick")
    registerEvent(smas2PlayerSystem,"onCameraDraw")
end

function smas2PlayerSystem.dropClassicReserve(playerIdx)
    Sound.playSFX(11)
    
    local B = 0
    
    if Player.count() >= 2 then
        if (playerIdx == 1) then
            B = -40
        elseif (playerIdx == 2) then
            B = 40
        end
        
        local ScreenTop = camera.y
        
        if (camera.height > 600) then
            ScreenTop = ScreenTop + camera.height / 2 - 300
        end
        
        local CenterX = camera.x + camera.width / 2
        
        local reserveNPC = NPC.spawn(SaveData.SMASPlusPlus.hud.reserve[Player(playerIdx).idx], camera.x, camera.y, Player(playerIdx).section, false, true)
        reserveNPC.x = CenterX - reserveNPC.width / 2 + B
        reserveNPC.y = ScreenTop + 16 + 12
        reserveNPC.speedX = 0
        reserveNPC.speedY = 0
        reserveNPC:mem(0x138, FIELD_WORD, 2)
    else
        if (playerIdx == 1) then
            B = -40
        elseif (playerIdx == 2) then
            B = 40
        end
        
        local ScreenTop = camera.y
        
        if (camera.height > 600) then
            ScreenTop = ScreenTop + camera.height / 2 - 300
        end
        
        local CenterX = camera.x + camera.width / 2
        
        local reserveNPC = NPC.spawn(SaveData.SMASPlusPlus.hud.reserve[Player(playerIdx).idx], camera.x, camera.y, Player(playerIdx).section, false, true)
        reserveNPC.x = CenterX - reserveNPC.width / 2 + B + 40
        reserveNPC.y = ScreenTop + 16 + 12 - 4
        reserveNPC.speedX = 0
        reserveNPC.speedY = 0
        reserveNPC:mem(0x138, FIELD_WORD, 2)
    end
    
    SaveData.SMASPlusPlus.hud.reserve[Player(playerIdx).idx] = 0
end

function smas2PlayerSystem.onDraw()
    if smasBooleans.targetPlayers then --If targeting players are enabled...
        for i = 1,maxPlayers do --Get all players
            if Player(i).isValid and not table.icontains(customCamera.targets,Player(i)) then
                table.insert(customCamera.targets,Player(i))
            elseif not Player(i).isValid and table.icontains(customCamera.targets,Player(i)) then
                table.remove(customCamera.targets,Player(i))
            end
        end
        --[[if Player.count() == 2 then
            customCamera.targets = {player2}
        end]]
    end
    if not smasBooleans.targetPlayers and not smasBooleans.overrideTargets then
        customCamera.targets = {}
    end
    
    if SaveData.SMASPlusPlus.game.onePointThreeModeActivated then
        if smas2PlayerSystem.enableSplitScreen then
            if Player.count() == 2 then
                Graphics.drawBox{width = 2, height = 600, x = 399, y = 0, color = Color.black, priority = 5}
                
                smas2PlayerSystem.player1CameraEdgeX = Screen.viewPortCoordinateX(player.x - camera.x + 40, player.width)
                smas2PlayerSystem.player1CameraEdgeY = 0
                smas2PlayerSystem.player2CameraEdgeX = Screen.viewPortCoordinateX(player2.x - camera.x, player2.width)
                smas2PlayerSystem.player2CameraEdgeY = 0 --player2.y - camera.y - player2.height
            end
        end
    end
end

function smas2PlayerSystem.getPlayerPriority(p)
    if p.forcedState == FORCEDSTATE_PIPE then
        return -70
    else
        return -25
    end
end

function smas2PlayerSystem.getPlayerMountPriority(p)
    if p.mount == MOUNT_CLOWNCAR then
        return -35
    else
        return -24.5
    end
end

function smas2PlayerSystem.onCameraDraw(camIdx)
    if smas2PlayerSystem.enableSplitScreen then
        if Player.count() == 2 then
            camera.x = math.clamp(player.x - 190, player.sectionObj.boundary.left, player.sectionObj.boundary.right - (camera.width / 2))
            
            player1Camera:captureAt(-0.0003)
            
            player1Camera:clear(-96)
            
            Graphics.drawBox{
                texture = player1Camera,
                x = 0,
                y = 0,
                priority = 0.0002,
                width = 400,
                height = 600,
                sourceWidth = 400,
                sourceHeight = 600,
            }
            
            player2Camera:clear(-100)
            
            customCamera.drawScene{
                target = player2Camera, useScreen = true, drawBackgroundToScreen = false, maxPriority = -0.0002,
                scale = customCamera.currentZoom, rotation = customCamera.currentRotation,
                x = math.clamp(player2.x - 400, player2.sectionObj.boundary.left - (camera.width / 3.8), player2.sectionObj.boundary.right - (camera.width / 1.31)),
                y = math.clamp(player2.y - camera.height * 0.5, player2.sectionObj.boundary.bottom, player2.sectionObj.boundary.top),
                width = 400, zoomHeight = 600,
            }
            
            Graphics.drawBox{
                texture = player2Camera,
                priority = -0.0001,
                x = 190,
                y = 0,
                width = 800,
                height = 600,
                sourceX = 0,
                sourceY = 0,
            }
            
            --[[if player.deathTimer == 0 then
                
                Graphics.drawBox{
                    texture = player1Camera,
                    x = 0,
                    y = 0,
                    priority = 0.0002,
                    width = 400,
                    height = 600,
                    sourceX = smas2PlayerSystem.player1CameraEdgeX,
                    sourceY = smas2PlayerSystem.player1CameraEdgeY,
                    sourceWidth = 400,
                    sourceHeight = 600,
                }
            end
            if player2.deathTimer == 0 then
                player2Camera:captureAt(0)
                customCamera.drawScene{
                    target = player2Camera, useScreen = true, drawBackgroundToScreen = false,
                    scale = customCamera.currentZoom, rotation = customCamera.currentRotation,
                    x = camera.x + 400, y = camera.y, width = 400, zoomHeight = 600,
                }
            end]]
        end
    end
end

function smas2PlayerSystem.onTick()
    for _,p in ipairs(Player.get()) do --Make sure all players are counted if i.e. using supermario128...
        if mem(0x00B2C5AC,FIELD_FLOAT) == 0 then --If 0, do these things...
            if(not killed and p:mem(0x13E,FIELD_BOOL)) then --Checks to see if the player actually died...
                killed = true --If so, this is true.
                mem(0x00B2C5AC,FIELD_FLOAT, 1) --Increase the life to 1 to prevent being kicked to the broken SMBX launcher after dying
            end
            if Player.count() >= 2 then --Player(2) compability! This one is a bit of a mess, but I tried
                if(not killed2 and p.deathTimer >= 1 and p:mem(0x13C, FIELD_BOOL)) then --Because 0X13E doesn't check in multiplayer, use the death timer instead.
                    killed2 = true --This one has a different variable set for player2
                    mem(0x00B2C5AC,FIELD_FLOAT, 1) --Also same as above
                    if p.deathTimer >= 199 then --If player2's death timer is almost 200, do a failsafe and load the level again, when setting the legacy lives to 1
                        Level.load(Level.filename())
                    end
                end
            end
        end
        if Player.count() == 2 and SaveData.SMASPlusPlus.game.onePointThreeModeActivated then
            if SMBX_VERSION ~= VER_SEE_MOD then
                if Player(1).forcedState == FORCEDSTATE_PIPE then
                    if Player(1).forcedTimer >= 70 and not Misc.isPaused() then
                        player:mem(0x140,FIELD_WORD,100)
                        Player(2):mem(0x140,FIELD_WORD,100)
                        Player(2):teleport(player.x - 32, player.y - 32, bottomCenterAligned)
                    end
                end
                if Player(2).forcedState == FORCEDSTATE_PIPE then
                    if Player(2).forcedTimer >= 70 and not Misc.isPaused() then
                        player:mem(0x140,FIELD_WORD,100)
                        Player(2):mem(0x140,FIELD_WORD,100)
                        Player(1):teleport(Player(2).x - 32, Player(2).y - 32, bottomCenterAligned)
                    end
                end
                if Player(1).forcedState == FORCEDSTATE_DOOR then
                    if Player(1).forcedTimer == 1 then
                        Routine.run(smas2PlayerSystem.doorTeleportP2toP1)
                    end
                end
                if Player(2).forcedState == FORCEDSTATE_DOOR then
                    if Player(2).forcedTimer == 1 then
                        Routine.run(smas2PlayerSystem.doorTeleportP1toP2)
                    end
                end
            end
        end
        if SaveData.SMASPlusPlus.game.onePointThreeModeActivated then
            if smasBooleans.isInLevel or smasBooleans.isInHub then
                if p.keys.dropItem == KEYS_PRESSED then
                    smas2PlayerSystem.dropClassicReserve(p.idx)
                end
            end
        end
    end
end



if SaveData.SMASPlusPlus.game.onePointThreeModeActivated then --These will be 1.3 Mode specific
    function smas2PlayerSystem.doorTeleportP1toP2()
        Routine.waitFrames(30)
        player:mem(0x140,FIELD_WORD,100)
        Player(2):mem(0x140,FIELD_WORD,100)
        if Player.count() >= 2 then
            Player(1):teleport(Player(2).x - 32, Player(2).y - 32, bottomCenterAligned)
        end
    end
    
    function smas2PlayerSystem.doorTeleportP2toP1()
        Routine.waitFrames(30)
        player:mem(0x140,FIELD_WORD,100)
        if Player.count() >= 2 then
            Player(2):mem(0x140,FIELD_WORD,100)
            Player(2):teleport(Player(1).x - 32, Player(1).y - 32, bottomCenterAligned)
        end
    end
    
    function smas2PlayerSystem.teleport2PlayerModeController(button, playerIdx) --Using the Special button to teleport within each other, same goes for the other two below except for keyboards
        if Player.count() == 2 then
            if playerIdx == 1 then
                if not Misc.isPaused() then
                    if button == SaveData.specialbutton1stplayer then
                        player:teleport(player2.x + 32, player2.y - 32, bottomCenterAligned)
                        Sound.playSFX("player-tp-2player.ogg")
                    end
                end
            end
            if playerIdx == 2 then
                if not Misc.isPaused() then
                    if button == SaveData.specialbutton2ndplayer then
                        player2:teleport(player.x - 32, player.y - 32, bottomCenterAligned)
                        Sound.playSFX("player-tp-2player.ogg")
                    end
                end
            end
        end
    end

    function smas2PlayerSystem.teleport2PlayerMode1P() --1st Player teleport, uses the keyboard key instead
        if Player.count() == 2 then
            if not Misc.isPaused() then
                player:teleport(player2.x + 32, player2.y - 32, bottomCenterAligned)
                Sound.playSFX("player-tp-2player.ogg")
            end
        end
    end

    function smas2PlayerSystem.teleport2PlayerMode2P()--2nd Player teleport, uses the keyboard key instead
        if Player.count() == 2 then
            if not Misc.isPaused() then
                player2:teleport(player.x - 32, player.y - 32, bottomCenterAligned)
                Sound.playSFX("player-tp-2player.ogg")
            end
        end
    end



    function smas2PlayerSystem.onKeyboardPress(keyCode, repeated) --Now for the keyboard press detection code...
        if Player.count() == 2 then
            if not Misc.isPaused() then
                if keyCode == smasTables.keyboardMap[SaveData.specialkey1stplayer] and not repeated then
                    smas2PlayerSystem.teleport2PlayerMode1P()
                elseif keyCode == smasTables.keyboardMap[SaveData.specialkey2ndplayer] and not repeated then
                    smas2PlayerSystem.teleport2PlayerMode2P()
                end
            end
        end
    end



    function smas2PlayerSystem.onControllerButtonPress(button, playerIdx) --...along with the controller press detection code
        if Player.count() == 2 then
            smas2PlayerSystem.teleport2PlayerModeController(button, playerIdx)
        end
    end
end



return smas2PlayerSystem