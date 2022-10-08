local pm = require("playerManager")
local extrasounds = require("extrasounds")
local sprite = require("base/sprite")
local smasfunctions
pcall(function() smasfunctions = require("smasfunctions") end)

local costume = {}

costume.loadedSounds = false

function costume.onInit(p)
    plr = p
    registerEvent(costume,"onInputUpdate")
    registerEvent(costume,"onTick")
    registerEvent(costume,"onPostBlockHit")
    if not costume.loadedSounds then
        Sound.loadCostumeSounds()
        costume.loadedSounds = true
    end
    
    Defines.player_walkspeed = 3.5
    Defines.player_runspeed = 3.5
    Defines.jumpheight = 17
    Defines.jumpheight_bounce = 27
    Defines.projectilespeedx = 7.0
    Defines.player_grav = 0.3
    
    costume.abilitesenabled = true
end

local swimtimer = 11
local rotationjump = 0

local function isSlidingOnIce()
    return (player:mem(0x0A,FIELD_BOOL) and (not player.keys.left and not player.keys.right))
end

-- Detects if the player is on the ground, the redigit way. Sometimes more reliable than just p:isOnGround().
local function isOnGround(p)
    return (
        player.speedY == 0 -- "on a block"
        or player:mem(0x176,FIELD_WORD) ~= 0 -- on an NPC
        or player:mem(0x48,FIELD_WORD) ~= 0 -- on a slope
    )
end

function costume.onTick()
    if SaveData.toggleCostumeAbilities == true then
        local isJumping = player:mem(0x11C, FIELD_WORD) and not isOnGround(p) --Jumping detection
        local isUnderwater = plr:mem(0x36, FIELD_BOOL) --Underwater detection
        if isJumping and plr:mem(0x14, FIELD_WORD) <= 0 and not isUnderwater and not isOnGround(p) then --Checks to see if the player is jumping...
            plr:setFrame(12)
            --local rotationjump = rotationjump % 360
            --player:render{frame = 12, x = player.x - camera.x, y = player.y - camera.y, priority = -25}
        end
        if not isJumping then
            --rotationjump = 0
        end
        local swimframes = {13,14}
        if isUnderwater and player:mem(0x14, FIELD_WORD) <= 0 and not isOnGround(p) then --Swim frames!
            plr:playAnim(swimframes, 8, false, -25)
            Defines.player_walkspeed = 4.5 --This is to make sure the player goes faster underwater
            Defines.player_runspeed = 4.5
        end
        if not isUnderwater then
            --swimtimer = 11
            Defines.player_walkspeed = 3.5
            Defines.player_runspeed = 3.5
        end
        local walkframes = {1,2}
        if plr.speedX ~= 0 and not isSlidingOnIce() then
            local walkSpeed = math.max(0.35,math.abs(plr.speedX)/Defines.player_walkspeed) --Making sure the walk animation is slower
            plr:playAnim(walkframes, 8, false, -25)
        end
        if Level.endState() >= 1 and not Level.endState() == 3 then --If win state, he poses
            plr:setFrame(16)
        end
    end
end

function costume.onPostBlockHit(block, fromUpper)
    local bricks = table.map{4,60,90,186,188,226,293,668} --These are a list of breakable bricks.
    if bricks[block.id] and block.contentID == nil or block.contentID == 0 or block.contentID == 1000 then
        block:remove(true)
    end
end

function costume.onInputUpdate()
    if SaveData.toggleCostumeAbilities == true then
        if player.keys.run == KEYS_DOWN then
            plr:mem(0x168, FIELD_FLOAT, 10)
        else
            plr:mem(0x168, FIELD_FLOAT, 0)
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
    
    Defines.jumpheight = 20
    Defines.player_walkspeed = 3
    Defines.player_runspeed = 6
    Defines.jumpheight_bounce = 32
    Defines.projectilespeedx = 7.1
    Defines.player_grav = 0.4
end

return costume