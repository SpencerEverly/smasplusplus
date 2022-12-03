local pm = require("playerManager")
local extrasounds = require("extrasounds")
_G.smasfunctions = require("smasfunctions")

local costume = {}

costume.loadedSounds = false

local jumphighertimer = 0
local jumphigherframeactive = false

-- Detects if the player is on the ground, the redigit way. Sometimes more reliable than just p:isOnGround().
local function isOnGround(p)
    return (
        player.speedY == 0 -- "on a block"
        or player:mem(0x176,FIELD_WORD) ~= 0 -- on an NPC
        or player:mem(0x48,FIELD_WORD) ~= 0 -- on a slope
    )
end

function isPlayerDucking(p) --Returns if the player is ducking.
    return (
        p.forcedState == FORCEDSTATE_NONE
        and p.deathTimer == 0 and not p:mem(0x13C,FIELD_BOOL) -- not dead
        and p.mount == MOUNT_NONE
        and not p.climbing
        and not p:mem(0x0C,FIELD_BOOL) -- fairy
        and not p:mem(0x3C,FIELD_BOOL) -- sliding
        and not p:mem(0x44,FIELD_BOOL) -- surfing on a rainbow shell
        and not p:mem(0x4A,FIELD_BOOL) -- statue
        and not p:mem(0x50,FIELD_BOOL) -- spin jumping
        and p:mem(0x26,FIELD_WORD) == 0 -- picking up something from the top
        and (p:mem(0x34,FIELD_WORD) == 0 or isOnGround(p)) -- underwater or on ground

        and (
            p:mem(0x48,FIELD_WORD) == 0 -- not on a slope (ducking on a slope is weird due to sliding)
            or (p.holdingNPC ~= nil) -- holding an NPC
            or p:mem(0x34,FIELD_WORD) > 0 -- underwater
        )
    )
end

function isJumping(p)
    return (p:mem(0x11E, FIELD_BOOL) and p.keys.jump == KEYS_PRESSED)
end

function costume.onInit(p)
    registerEvent(costume,"onTick")
    if not costume.loadedSounds then
        Sound.loadCostumeSounds()
        costume.loadedSounds = true
    end
end

function costume.onTick()
    for _,p in ipairs(Player.get()) do
        if p.keys.down == KEYS_DOWN then
            if isPlayerDucking(p) then
                if p.powerup == 1 then
                    p:setFrame(8 * player.direction)
                end
                jumphighertimer = jumphighertimer + 1
                if jumphighertimer == 120 then
                    if table.icontains(smastables._noLevelPlaces,Level.filename()) == false then
                        Sound.playSFX(117)
                    end
                end
                if isJumping(p) and jumphighertimer >= 120 then
                    if p.powerup == 1 then
                        p:setFrame(3 * player.direction)
                    else
                        p:setFrame(4 * player.direction)
                    end
                    p.speedY = -16
                    jumphigherframeactive = true
                    jumphighertimer = 0
                end
            end
        end
        if not isPlayerDucking(p) then
            jumphighertimer = 0
        end
        if jumphigherframeactive then
            p.keys.down = false
            if p.speedY < 0 or not p.climbing then
                if p.powerup == 1 then
                    p:setFrame(3 * player.direction)
                else
                    p:setFrame(4 * player.direction)
                end
            end
            if p.speedY > 0 or p.climbing then
                jumphigherframeactive = false
            end
        end
    end
end

function costume.onCleanup(p)
    for i = 1,91 do
        Audio.sounds[i].sfx = nil
    end
    for i = 1,165 do
        extrasounds.sound.sfx[i] = nil
    end
end

return costume