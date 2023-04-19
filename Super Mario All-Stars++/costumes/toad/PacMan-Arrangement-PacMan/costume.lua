local smasFunctions = require("smasFunctions")

local costume = {}

costume.loaded = false

local pm = require("playerManager")
local smasExtraSounds = require("smasExtraSounds")
local smasTables = require("smasTables")

function costume.onInit(p)
    registerEvent(costume,"onTick")
    registerEvent(costume,"onDraw")
    registerEvent(costume,"onInputUpdate")
    registerEvent(costume,"onPostNPCKill")
    registerEvent(costume,"onPlayerKill")
    registerEvent(costume,"onPlayerHarm")
    registerEvent(costume,"onKeyboardPress")
    registerEvent(costume,"onControllerButtonPress")
    if not costume.loaded then
        Sound.loadCostumeSounds()
        costume.loaded = true
    end
end

local pacmanpowerup6 = Graphics.loadImageResolved("costumes/toad/PacMan-Arrangement-PacMan/toad-6.png")

local moving = false
local running = false

local teleportmode = false
local timetostopteleport = 130
local pelletnumber = 1

function costume.onDraw()
    if teleportmode then
        
    end
end

function costume.onPlayerHarm(e)
    if teleportmode then
        e.cancelled = true
    end
end

function costume.onPlayerKill(e)
    if teleportmode then
        e.cancelled = true
    end
end

function costume.onTick()
    if not moving then
        player.speedX = 0
    elseif moving then
        if not running then
            if player.keys.left == KEYS_DOWN then
                player.speedX = -4
            end
            if player.keys.right == KEYS_DOWN then
                player.speedX = 4
            end
        elseif running then
            if player.keys.left == KEYS_DOWN then
                player.speedX = -6
            end
            if player.keys.right == KEYS_DOWN then
                player.speedX = 6
            end
        end
    end
    if player.powerup ~= 3 then
        running = false
    end
    if teleportmode then
        timetostopteleport = timetostopteleport - 1
        player.forcedState = FORCEDSTATE_INVISIBLE
        if timetostopteleport >= 5 then
            Graphics.drawImageToSceneWP(pacmanpowerup6, player.x - 36, player.y - 40, 600, 400, 100, 100, 1, -25)
        end
        player:mem(0x140, FIELD_WORD, 20)
        if player.keys.up == KEYS_DOWN then
            player.y = player.y - 4
        end
        if player.keys.down == KEYS_DOWN then
            player.y = player.y + 4
        end
        if player.keys.left == KEYS_DOWN then
            player.x = player.x - 4
        end
        if player.keys.right == KEYS_DOWN then
            player.x = player.x + 4
        end
        if timetostopteleport <= 2 then
            player.forcedState = FORCEDSTATE_NONE
        end
        if timetostopteleport <= 0 then
            timetostopteleport = 0
            teleportmode = false
        end
    end
    if timetostopteleport == 1 then
        Sound.playSFX("toad/PacMan-Arrangement-PacMan/teleport-end.ogg")
    end
    if not teleportmode then
        
    end
    if player:isGroundTouching() and (player.forcedState == FORCEDSTATE_INVISIBLE) == false then
        timetostopteleport = 130
    end
    if player.powerup == 5 then
        Defines.jumpheight = 30
    else
        Defines.jumpheight = 20
    end
end

function costume.onPostNPCKill(npc, harmType)
    local coins = table.map{10,33,88,103,138,251,252,253,258,528}
    if coins[npc.id] and Colliders.collide(player, npc) then
        if pelletnumber == 1 then
            pelletnumber = 2
            smasExtraSounds.sounds[14].sfx = Audio.SfxOpen(Misc.resolveSoundFile("costumes/toad/PacMan-Arrangement-PacMan/pellet-2.ogg"))
        elseif pelletnumber == 2 then
            pelletnumber = 1
            smasExtraSounds.sounds[14].sfx = Audio.SfxOpen(Misc.resolveSoundFile("costumes/toad/PacMan-Arrangement-PacMan/pellet-1.ogg"))
        end
        if player.powerup == 7 then
            SaveData.SMASPlusPlus.hud.coinsClassic = SaveData.SMASPlusPlus.hud.coinsClassic + 1
        end
    end
end

function costume.onInputUpdate()
    if not Misc.isPaused() then
        --Normal movement
        if player.keys.left == KEYS_DOWN then
            moving = true
        elseif player.keys.right == KEYS_DOWN then
            moving = true
        elseif player.keys.left == KEYS_UP then
            moving = false
        elseif player.keys.right == KEYS_UP then
            moving = false
        end
        --Fire flower dash movement
        if player.powerup == 3 and player.keys.run == KEYS_DOWN then
            running = true
        elseif player.powerup == 3 and player.keys.run == KEYS_UP then
            running = false
        end
        --Dash SFX
        if player.powerup == 3 and player.keys.run == KEYS_PRESSED and moving and player:isOnGround() then
            if table.icontains(smasTables._noLevelPlaces,Level.filename()) == false then
                Sound.playSFX("toad/PacMan-Arrangement-PacMan/dash.ogg")
            end
        end
        --Fireball redo
        if player.powerup == 3 and player.keys.run == KEYS_PRESSED and not player.keys.down == KEYS_DOWN then
            player:mem(0x172, FIELD_BOOL, false)
            local fireballnpc = NPC.spawn(13, player.x, player.y, player.section, false, true)
            if table.icontains(smasTables._noLevelPlaces,Level.filename()) == false then
                Sound.playSFX(18)
            end
            if player.direction == 1 then
                fireballnpc.speedX = 10
                fireballnpc.speedY = -4
            elseif player.direction == -1 then
                fireballnpc.speedX = -10
                fireballnpc.speedY = -4
            end
        end
        --Higher jump
        if player.powerup == 4 and player.keys.jump == KEYS_PRESSED and player:mem(0x00, FIELD_BOOL) == true then
            player:mem(0x00, FIELD_BOOL, false)
            if table.icontains(smasTables._noLevelPlaces,Level.filename()) == false then
                Sound.playSFX("toad/PacMan-Arrangement-PacMan/double-jump.ogg")
            end
            player.speedY = -12
        end
        --Iceball redo
        if player.powerup == 7 and player.keys.run == KEYS_PRESSED and not player.keys.down == KEYS_DOWN then
            player:mem(0x172, FIELD_BOOL, false)
            local iceballnpc = NPC.spawn(265, player.x, player.y, player.section, false, true)
            if table.icontains(smasTables._noLevelPlaces,Level.filename()) == false then
                Sound.playSFX(93)
            end
            if player.direction == 1 then
                iceballnpc.speedX = 10
                iceballnpc.speedY = -4
            elseif player.direction == -1 then
                iceballnpc.speedX = -10
                iceballnpc.speedY = -4
            end
        end
    end
end

function teleportingability()
    --Teleport (Only active for 2 seconds)
    if player.powerup == 6 then
        if table.icontains(smasTables._noLevelPlaces,Level.filename()) == false then
            if timetostopteleport >= 1 then
                Sound.playSFX("toad/PacMan-Arrangement-PacMan/teleport-start.ogg")
                teleportmode = true
            end
        end
    end
    if player.powerup == 6 and not teleportmode then
        player:mem(0x172, FIELD_BOOL, false)
    end
end

function costume.onKeyboardPress(keyCode, repeated)
    if keyCode == smasTables.keyboardMap[SaveData.specialkey1stplayer] and not repeated then
        if not teleportmode then
            teleportingability()
        end
    end
end

function costume.onControllerButtonPress(button, playerIdx)
    if playerIdx == 1 then
        if button == SaveData.specialbutton1stplayer then
            if not teleportmode then
                teleportingability()
            end
        end
    end
end

function costume.onCleanup(p)
    Sound.cleanupCostumeSounds()
    
    Defines.jumpheight = 20
    Defines.player_walkspeed = 3
    Defines.player_runspeed = 6
    Defines.jumpheight_bounce = 32
    Defines.projectilespeedx = 7.1
    Defines.player_grav = 0.4
end

Misc.storeLatestCostumeData(costume)

return costume