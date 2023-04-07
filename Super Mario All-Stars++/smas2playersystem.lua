--smas2playersystem.lua
--v1.0
--By Spencer Everly

local smas2playersystem = {}

local customCamera = require("customCamera")
local handycam = require("handycam")

local player1Camera = Graphics.CaptureBuffer(800,600)
local player2Camera = Graphics.CaptureBuffer(800,600)
smas2playersystem.player1CameraEdgeX = 0
smas2playersystem.player1CameraEdgeY = 0
smas2playersystem.player2CameraEdgeX = 0
smas2playersystem.player2CameraEdgeY = 0

local pipecounter1p = 0
local pipecounter2p = 0

function smas2playersystem.onInitAPI()
    registerEvent(smas2playersystem,"onControllerButtonPress")
    registerEvent(smas2playersystem,"onKeyboardPress")
    registerEvent(smas2playersystem,"onStart")
    registerEvent(smas2playersystem,"onDraw")
    registerEvent(smas2playersystem,"onTick")
    registerEvent(smas2playersystem,"onCameraDraw")
end

function smas2playersystem.onStart()
    if smasbooleans.targetPlayers then --If targeting players are enabled...
        for _,p in ipairs(Player.get()) do --Get all players
            if p.isValid and not table.icontains(customCamera.targets,p) then
                table.insert(customCamera.targets,p)
            elseif not p.isValid and table.icontains(customCamera.targets,p) then
                table.remove(customCamera.targets,p)
            end
        end
    end
end

function smas2playersystem.onDraw()
    if smasbooleans.targetPlayers then --If targeting players are enabled...
        for _,p in ipairs(Player.get()) do --Get all players
            if p.isValid and not table.icontains(customCamera.targets,p) then
                table.insert(customCamera.targets,p)
            elseif not p.isValid and table.icontains(customCamera.targets,p) then
                table.remove(customCamera.targets,p)
            end
        end
    end
    if not smasbooleans.targetPlayers and not smasbooleans.overrideTargets then
        customCamera.targets = {}
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
                smas2playersystem.player1CameraEdgeX = Screen.viewPortCoordinateX(player.x - camera.x, player.width)
                smas2playersystem.player1CameraEdgeY = 0
                smas2playersystem.player2CameraEdgeX = Screen.viewPortCoordinateX(player2.x - camera.x, player2.width)
                smas2playersystem.player2CameraEdgeY = 0 --player.y - camera.y - player.height
            end]]
        end
    end
end

function smas2playersystem.onCameraDraw(camIdx)
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
                sourceX = smas2playersystem.player1CameraEdgeX,
                sourceY = smas2playersystem.player1CameraEdgeY,
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
                sourceX = smas2playersystem.player2CameraEdgeX,
                sourceY = smas2playersystem.player2CameraEdgeY,
                sourceWidth = 400,
                sourceHeight = 600,
            }
        end
    end]]
end

function smas2playersystem.onTick()
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
                        Routine.run(smas2playersystem.doorTeleportP2toP1)
                    end
                end
                if Player(2).forcedState == FORCEDSTATE_DOOR then
                    if Player(2).forcedTimer == 1 then
                        Routine.run(smas2playersystem.doorTeleportP1toP2)
                    end
                end
            end
        end
    end
end



if SaveData.disableX2char then --These will be 1.3 Mode specific
    function smas2playersystem.doorTeleportP1toP2()
        Routine.waitFrames(30)
        player:mem(0x140,FIELD_WORD,100)
        Player(2):mem(0x140,FIELD_WORD,100)
        if Player.count() >= 2 then
            Player(1):teleport(Player(2).x - 32, Player(2).y - 32, bottomCenterAligned)
        end
    end
    
    function smas2playersystem.doorTeleportP2toP1()
        Routine.waitFrames(30)
        player:mem(0x140,FIELD_WORD,100)
        if Player.count() >= 2 then
            Player(2):mem(0x140,FIELD_WORD,100)
            Player(2):teleport(Player(1).x - 32, Player(1).y - 32, bottomCenterAligned)
        end
    end
    
    function smas2playersystem.teleport2PlayerModeController(button, playerIdx) --Using the Special button to teleport within each other, same goes for the other two below except for keyboards
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

    function smas2playersystem.teleport2PlayerMode1P() --1st Player teleport, uses the keyboard key instead
        if Player.count() == 2 then
            if not Misc.isPaused() then
                player:teleport(player2.x + 32, player2.y - 32, bottomCenterAligned)
                Sound.playSFX("player-tp-2player.ogg")
            end
        end
    end

    function smas2playersystem.teleport2PlayerMode2P()--2nd Player teleport, uses the keyboard key instead
        if Player.count() == 2 then
            if not Misc.isPaused() then
                player2:teleport(player.x - 32, player.y - 32, bottomCenterAligned)
                Sound.playSFX("player-tp-2player.ogg")
            end
        end
    end



    function smas2playersystem.onKeyboardPress(keyCode, repeated) --Now for the keyboard press detection code...
        if Player.count() == 2 then
            if not Misc.isPaused() then
                if keyCode == smastables.keyboardMap[SaveData.specialkey1stplayer] and not repeated then
                    smas2playersystem.teleport2PlayerMode1P()
                elseif keyCode == smastables.keyboardMap[SaveData.specialkey2ndplayer] and not repeated then
                    smas2playersystem.teleport2PlayerMode2P()
                end
            end
        end
    end



    function smas2playersystem.onControllerButtonPress(button, playerIdx) --...along with the controller press detection code
        if Player.count() == 2 then
            smas2playersystem.teleport2PlayerModeController(button, playerIdx)
        end
    end
end



return smas2playersystem