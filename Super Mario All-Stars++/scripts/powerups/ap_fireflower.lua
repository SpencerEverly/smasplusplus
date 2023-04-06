local apt = {}

local extrasounds = require("extrasounds")

-- Variable "name" is reserved
-- variable "registerItems" is reserved

apt.spritesheets = {
    Graphics.sprites.mario[3].img, --Mario
    Graphics.sprites.luigi[3].img, --Luigi
    Graphics.sprites.peach[3].img, --Peach
    Graphics.sprites.toad[3].img, --Toad
}
apt.items = {14, 182, 183} -- Items that can be collected
apt.enableCustomShooting = false

--------------------
apt.projectileTimer = 0
apt.projectileTimerMax = {
    30,
    35,
    40,
    25,
    25
}
--------------------

apt.animFrames = {
    11,11,11,11,12,12,12,12,
}

-- Runs when player switches to this powerup. Use for setting stuff like global Defines.
function apt.onEnable()

end

-- Runs when player switches to this powerup. Use for resetting stuff from onEnable.
function apt.onDisable()

end

-- If you wish to have global onTick etc... functions, you can register them with an alias like so:
-- registerEvent(apt, "onTick", "onPersistentTick")

local function canShoot()
    return (
        apt.projectileTimer <= 0 and
        player.forcedState == 0 and
        player:mem(0x40, FIELD_WORD) == 0 and --climbing
        player.mount < 2 and
        player.holdingNPC == nil and
        player.deathTimer == 0 and
        player:mem(0x0C, FIELD_BOOL) == false -- fairy
    )
end

local function ducking()
    return player:mem(0x12E, FIELD_BOOL)
end

-- No need to register. Runs only when powerup is active.
function apt.onTick()
    if not apt.enableCustomShooting then

        apt.projectileTimer = apt.projectileTimer - 1
        
        if not canShoot() then return end

        if player.keys.run == KEYS_PRESSED or player.keys.altRun == KEYS_PRESSED then
            if player.keys.altRun == KEYS_PRESSED and (player.character == 3 or player.character == 4) then
                if not ducking() and player.mount == 0 then
                    local v = NPC.spawn(13, player.x, player.y, player.section)
                    v.ai1 = player.character
                    player:mem(0x154, FIELD_WORD, v.idx+1)
                    player:mem(0x62, FIELD_WORD, 42)
                    --v:mem(0x12C, FIELD_WORD, player.idx)
                    SFX.play(extrasounds.sounds[18].sfx)
                    apt.projectileTimer = apt.projectileTimerMax[player.character]
                end
            else
                local v
                if not ducking() then
                    v = NPC.spawn(13, player.x + 0.5 * player.width + 0.5 * player.width * player.direction, player.y + 16, player.section, false, true)
                    v.speedY = 4
                    if player.keys.up then
                        local speedYMod = player.speedY * 0.1
                        if player.standingNPC then
                            speedYMod = player.standingNPC.speedY * 0.1
                        end
                        v.speedY = -6 + speedYMod
                    end
                    SFX.play(extrasounds.sounds[18].sfx)
                end
                if v then
                    v.ai1 = player.character
                    v.speedX = 5 * player.direction + player.speedX/3.5
                    apt.projectileTimer = apt.projectileTimerMax[player.character]
                end
            end
        end
    end
end

-- No need to register. Runs only when powerup is active.
function apt.onTickEnd()
    if not apt.enableCustomShooting then
        if animFrames[apt.projectileTimerMax[player.character] - apt.projectileTimer] then
            player.frame = apt.animFrames[apt.projectileTimerMax[player.character] - apt.projectileTimer]
        end
    end
end

-- No need to register. Runs only when powerup is active.
function apt.onDraw()

end

return apt