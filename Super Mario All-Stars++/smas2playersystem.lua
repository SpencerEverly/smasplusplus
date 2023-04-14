--smas2PlayerSystem.lua
--v1.0
--By Spencer Everly

local smas2PlayerSystem = {}

local handycam = require("handycam")
handycam[1].targets = {}

local player1Camera = Graphics.CaptureBuffer(800,600)
local player2Camera = Graphics.CaptureBuffer(800,600)
smas2PlayerSystem.player1CameraEdgeX = 0
smas2PlayerSystem.player1CameraEdgeY = 0
smas2PlayerSystem.player2CameraEdgeX = 0
smas2PlayerSystem.player2CameraEdgeY = 0

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
        
        local reserveNPC = NPC.spawn(SaveData.reserveBoxItem[Player(playerIdx).idx], camera.x, camera.y, Player(playerIdx).section, false, true)
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
        
        local reserveNPC = NPC.spawn(SaveData.reserveBoxItem[Player(playerIdx).idx], camera.x, camera.y, Player(playerIdx).section, false, true)
        reserveNPC.x = CenterX - reserveNPC.width / 2 + B + 40
        reserveNPC.y = ScreenTop + 16 + 12 - 4
        reserveNPC.speedX = 0
        reserveNPC.speedY = 0
        reserveNPC:mem(0x138, FIELD_WORD, 2)
    end
    
    SaveData.reserveBoxItem[Player(playerIdx).idx] = 0
end

function smas2PlayerSystem.onDraw()
    if smasBooleans.targetPlayers then --If targeting players are enabled...
        for _,p in ipairs(Player.get()) do --Get all players
            if p.isValid and not table.icontains(handycam[1].targets,p) then
                table.insert(handycam[1].targets,p)
            elseif not p.isValid and table.icontains(handycam[1].targets,p) then
                table.remove(handycam[1].targets,p)
            end
        end
    end
    if not smasBooleans.targetPlayers and not smasBooleans.overrideTargets then
        handycam[1].targets = {}
    end
    
    if SaveData.disableX2char then
        
        if Player.count() >= 2 then
            local playerboundaryx = Player(2).x - player.x
            local playerboundaryy = Player(2).y - player.y
            --Kill player2 if far away, out of the camera bounds
            --[[if (player.forcedState == FORCEDSTATE_PIPE) == false or (player.forcedState == FORCEDSTATE_DOOR) == false then
                if playerboundaryx >= 800 and Player(2):mem(0x13C, FIELD_BOOL) == false then
                    Player(2):kill()
                elseif playerboundaryx <= -800 and Player(2):mem(0x13C, FIELD_BOOL) == false then
                    Player(2):kill()
                elseif playerboundaryy >= 1200 and Player(2):mem(0x13C, FIELD_BOOL) == false then
                    Player(2):kill()
                elseif playerboundaryy <= -1200 and Player(2):mem(0x13C, FIELD_BOOL) == false then
                    Player(2):kill()
                end
            end]
        end
        if Player.count() == 2 then
            if player.deathTimer == 0 then
                smas2PlayerSystem.player1CameraEdgeX = Screen.viewPortCoordinateX(player.x - camera.x, player.width)
                smas2PlayerSystem.player1CameraEdgeY = 0
                smas2PlayerSystem.player2CameraEdgeX = Screen.viewPortCoordinateX(player2.x - camera.x, player2.width)
                smas2PlayerSystem.player2CameraEdgeY = 0 --player.y - camera.y - player.height
            end]]
        end
    end
end

function smas2PlayerSystem.onCameraDraw(camIdx)
    --[[if Player.count() == 2 then
        if player.deathTimer == 0 then
            player1Camera:captureAt(-4.9999)
            player2Camera:captureAt(-4.9999)
            Graphics.drawBox{
                texture = player1Camera,
                x = 0,
                y = 0,
                priority = -4.98,
                width = 400,
                height = 600,
                sourceX = smas2PlayerSystem.player1CameraEdgeX,
                sourceY = smas2PlayerSystem.player1CameraEdgeY,
                sourceWidth = 400,
                sourceHeight = 600,
            }
        end
        if player2.deathTimer == 0 then
            Graphics.drawBox{
                texture = player2Camera,
                x = 400,
                y = 0,
                priority = -4.98,
                width = 400,
                height = 600,
                sourceX = smas2PlayerSystem.player2CameraEdgeX,
                sourceY = smas2PlayerSystem.player2CameraEdgeY,
                sourceWidth = 400,
                sourceHeight = 600,
            }
        end
    end]]
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
        if Player.count() == 2 and SaveData.disableX2char then
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
        if SaveData.disableX2char then
            if smasBooleans.isInLevel or smasBooleans.isInHub then
                if p.keys.dropItem == KEYS_PRESSED then
                    smas2PlayerSystem.dropClassicReserve(p.idx)
                end
            end
        end
    end
end



if SaveData.disableX2char then --These will be 1.3 Mode specific
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