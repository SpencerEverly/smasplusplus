local costume = {}

local pm = require("playerManager")
local extrasounds = require("extrasounds")
local smastables = require("smastables")

function costume.onInit(p)
    registerEvent(costume,"onTick")
    registerEvent(costume,"onDraw")
    registerEvent(costume,"onInputUpdate")
    registerEvent(costume,"onPostNPCKill")
    registerEvent(costume,"onPlayerKill")
    registerEvent(costume,"onPlayerHarm")
    registerEvent(costume,"onKeyboardPress")
    registerEvent(costume,"onControllerButtonPress")
    extrasounds.sound.sfx[1] = Audio.SfxOpen("costumes/toad/PacMan-Arrangement-PacMan/player-jump.ogg")
    Audio.sounds[6].sfx  = Audio.SfxOpen("costumes/toad/PacMan-Arrangement-PacMan/player-grow.ogg")
    extrasounds.sound.sfx[8]  = Audio.SfxOpen("costumes/toad/PacMan-Arrangement-PacMan/player-died.ogg")
    extrasounds.sound.sfx[14] = Audio.SfxOpen(Misc.resolveSoundFile("costumes/toad/PacMan-Arrangement-PacMan/pellet-1.ogg"))
    Audio.sounds[52].sfx  = Audio.SfxOpen("costumes/toad/PacMan-Arrangement-PacMan/got-star.ogg")
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
            extrasounds.sound.sfx[14] = Audio.SfxOpen(Misc.resolveSoundFile("costumes/toad/PacMan-Arrangement-PacMan/pellet-2.ogg"))
        elseif pelletnumber == 2 then
            pelletnumber = 1
            extrasounds.sound.sfx[14] = Audio.SfxOpen(Misc.resolveSoundFile("costumes/toad/PacMan-Arrangement-PacMan/pellet-1.ogg"))
        end
        if player.powerup == 7 then
            SaveData.totalCoinsClassic = SaveData.totalCoinsClassic + 1
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
            if table.icontains(smastables._noLevelPlaces,Level.filename()) == false then
                Sound.playSFX("toad/PacMan-Arrangement-PacMan/dash.ogg")
            end
        end
        --Fireball redo
        if player.powerup == 3 and player.keys.run == KEYS_PRESSED and not player.keys.down == KEYS_DOWN then
            player:mem(0x172, FIELD_BOOL, false)
            local fireballnpc = NPC.spawn(13, player.x, player.y, player.section, false, true)
            if table.icontains(smastables._noLevelPlaces,Level.filename()) == false then
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
            if table.icontains(smastables._noLevelPlaces,Level.filename()) == false then
                Sound.playSFX("toad/PacMan-Arrangement-PacMan/double-jump.ogg")
            end
            player.speedY = -12
        end
        --Iceball redo
        if player.powerup == 7 and player.keys.run == KEYS_PRESSED and not player.keys.down == KEYS_DOWN then
            player:mem(0x172, FIELD_BOOL, false)
            local iceballnpc = NPC.spawn(265, player.x, player.y, player.section, false, true)
            if table.icontains(smastables._noLevelPlaces,Level.filename()) == false then
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
        if table.icontains(smastables._noLevelPlaces,Level.filename()) == false then
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
    if keyCode == smastables.keyboardMap[SaveData.specialkey1stplayer] and not repeated then
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
    extrasounds.sound.sfx[1] = nil    
    Audio.sounds[2].sfx  = nil
    Audio.sounds[3].sfx  = nil
    extrasounds.sound.sfx[4]  = Audio.SfxOpen(Misc.resolveSoundFile("block-smash"))
    Audio.sounds[5].sfx  = nil
    Audio.sounds[6].sfx  = nil
    extrasounds.sound.sfx[7]  = Audio.SfxOpen(Misc.resolveSoundFile("mushroom"))
    extrasounds.sound.sfx[8] = nil
    Audio.sounds[9].sfx  = nil
    extrasounds.sound.sfx[10] = nil
    Audio.sounds[11].sfx = nil
    Audio.sounds[12].sfx = nil
    Audio.sounds[13].sfx = nil
    extrasounds.sound.sfx[14] = Audio.SfxOpen(Misc.resolveSoundFile("coin"))
    extrasounds.sound.sfx[15] = Audio.SfxOpen(Misc.resolveSoundFile("1up"))
    Audio.sounds[16].sfx = nil
    Audio.sounds[17].sfx = nil
    extrasounds.sound.sfx[18] = Audio.SfxOpen(Misc.resolveSoundFile("fireball"))
    Audio.sounds[19].sfx = nil
    Audio.sounds[20].sfx = nil
    Audio.sounds[21].sfx = nil
    Audio.sounds[22].sfx = nil
    Audio.sounds[23].sfx = nil
    Audio.sounds[24].sfx = nil
    Audio.sounds[25].sfx = nil
    Audio.sounds[29].sfx = nil
    Audio.sounds[31].sfx = nil
    Audio.sounds[32].sfx = nil
    extrasounds.sound.sfx[33] = nil
    Audio.sounds[34].sfx = nil
    Audio.sounds[35].sfx = nil
    extrasounds.sound.sfx[36] = nil
    Audio.sounds[37].sfx = nil
    Audio.sounds[38].sfx = nil
    extrasounds.sound.sfx[39] = nil
    Audio.sounds[41].sfx = nil
    extrasounds.sound.sfx[42] = nil
    extrasounds.sound.sfx[43] = Audio.SfxOpen(Misc.resolveSoundFile("fireworks"))
    Audio.sounds[44].sfx = nil
    Audio.sounds[46].sfx = nil
    Audio.sounds[47].sfx = nil
    Audio.sounds[48].sfx = nil
    Audio.sounds[49].sfx = nil
    Audio.sounds[50].sfx = nil
    Audio.sounds[51].sfx = nil
    Audio.sounds[52].sfx = nil
    Audio.sounds[54].sfx = nil
    Audio.sounds[55].sfx = nil
    Audio.sounds[56].sfx = nil
    Audio.sounds[57].sfx = nil
    Audio.sounds[58].sfx = nil
    extrasounds.sound.sfx[59] = Audio.SfxOpen(Misc.resolveSoundFile("dragon-coin"))
    Audio.sounds[61].sfx = nil
    Audio.sounds[62].sfx = nil
    Audio.sounds[63].sfx = nil
    Audio.sounds[71].sfx = nil
    Audio.sounds[72].sfx = nil
    Audio.sounds[73].sfx = nil
    Audio.sounds[75].sfx = nil
    Audio.sounds[76].sfx = nil
    Audio.sounds[77].sfx = nil
    Audio.sounds[78].sfx = nil
    Audio.sounds[79].sfx = nil
    Audio.sounds[80].sfx = nil
    Audio.sounds[81].sfx = nil
    Audio.sounds[82].sfx = nil
    Audio.sounds[91].sfx = nil
    extrasounds.sound.sfx[92] = nil
    extrasounds.sound.sfx[93] = nil
    extrasounds.sound.sfx[94] = nil
    extrasounds.sound.sfx[95] = nil
    extrasounds.sound.sfx[96] = nil
    extrasounds.sound.sfx[97] = nil
    extrasounds.sound.sfx[98] = nil
    extrasounds.sound.sfx[99] = nil
    extrasounds.sound.sfx[100] = nil
    extrasounds.sound.sfx[101] = nil
    extrasounds.sound.sfx[102] = nil
    extrasounds.sound.sfx[103] = nil
    extrasounds.sound.sfx[104] = nil
    extrasounds.sound.sfx[105] = nil
    extrasounds.sound.sfx[106] = nil
    extrasounds.sound.sfx[107] = nil
    extrasounds.sound.sfx[108] = nil
    extrasounds.sound.sfx[109] = nil
    extrasounds.sound.sfx[110] = nil
    extrasounds.sound.sfx[111] = nil
    extrasounds.sound.sfx[112] = nil
    
    Defines.jumpheight = 20
    Defines.player_walkspeed = 3
    Defines.player_runspeed = 6
    Defines.jumpheight_bounce = 32
    Defines.projectilespeedx = 7.1
    Defines.player_grav = 0.4
end

return costume