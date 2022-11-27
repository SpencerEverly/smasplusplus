--smas2playersystem.lua
--v1.0
--By Spencer Everly

local smas2playersystem = {}

local customCamera = require("customCamera")

local pipecounter1p = 0
local pipecounter2p = 0

function smas2playersystem.onInitAPI()
    registerEvent(smas2playersystem,"onControllerButtonPress")
    registerEvent(smas2playersystem,"onKeyboardPress")
    registerEvent(smas2playersystem,"onStart")
    registerEvent(smas2playersystem,"onDraw")
    registerEvent(smas2playersystem,"onTick")
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
            end]]
        end
    end
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
    end
end



if SaveData.disableX2char then --These will be 1.3 Mode specific
    function smas2playersystem.teleport2PlayerModeController(button, playerIdx) --Using the Special button to teleport within each other, same goes for the other two below except for keyboards
        if Player.count() >= 2 then
            if playerIdx == 1 then
                if not Misc.isPaused() then
                    player:teleport(player2.x + 32, player2.y - 32, bottomCenterAligned)
                    Sound.playSFX("player-tp-2player.ogg")
                end
            end
            if playerIdx == 2 then
                if not Misc.isPaused() then
                    player2:teleport(player.x - 32, player.y - 32, bottomCenterAligned)
                    Sound.playSFX("player-tp-2player.ogg")
                end
            end
        end
    end

    function smas2playersystem.teleport2PlayerMode1P() --1st Player teleport, uses the keyboard key instead
        if Player.count() >= 2 then
            if not Misc.isPaused() then
                player:teleport(player2.x + 32, player2.y - 32, bottomCenterAligned)
                Sound.playSFX("player-tp-2player.ogg")
            end
        end
    end

    function smas2playersystem.teleport2PlayerMode2P()--2nd Player teleport, uses the keyboard key instead
        if Player.count() >= 2 then
            if not Misc.isPaused() then
                player2:teleport(player.x - 32, player.y - 32, bottomCenterAligned)
                Sound.playSFX("player-tp-2player.ogg")
            end
        end
    end



    function smas2playersystem.onKeyboardPress(keyCode, repeated) --Now for the keyboard press detection code...
        if Player.count() >= 2 then
            if keyCode == smastables.keyboardMap[SaveData.specialkey1stplayer] and not repeated then
                smas2playersystem.teleport2PlayerMode1P()
            elseif keyCode == smastables.keyboardMap[SaveData.specialkey2ndplayer] and not repeated then
                smas2playersystem.teleport2PlayerMode2P()
            end
        end
    end



    function smas2playersystem.onControllerButtonPress(button, playerIdx) --...along with the controller press detection code
        if Player.count() >= 2 then
            smas2playersystem.teleport2PlayerModeController(button, playerIdx)
        end
    end
end



return smas2playersystem