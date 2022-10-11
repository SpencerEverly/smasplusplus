local pm = require("playerManager")
local extrasounds = require("extrasounds")
local rng = require("base/rng")
local smasfunctions
pcall(function() smasfunctions = require("smasfunctions") end)

local costume = {}

costume.loadedSounds = false

local eventsRegistered = false
local plr
local jumpingactive = false
local cooldown = 0
local timer = 50
local timer2 = 5
local p = player
local hasJumped = false

local leafPowerups = table.map{PLAYER_LEAF,PLAYER_TANOOKI}

function costume.onInit(p)
    plr = p
    registerEvent(costume,"onStart")
    registerEvent(costume,"onDraw")
    registerEvent(costume,"onPlayerHarm")
    registerEvent(costume,"onPlayerKill")
    registerEvent(costume,"onPostNPCKill")
    registerEvent(costume,"onTick")
    registerEvent(costume,"onTickEnd")
    registerEvent(costume,"onCleanup")
    registerEvent(costume,"onInputUpdate")
    local icantswim = require("icantswim")
    icantswim.splashSound = Audio.SfxOpen("costumes/mario/SpongeBobSquarePants/spongebob-splash.ogg")
    if not costume.loadedSounds then
        Sound.loadCostumeSounds()
        costume.loadedSounds = true
    end
    
    flybeginsound = Audio.SfxOpen(Misc.resolveSoundFile("costumes/mario/SpongeBobSquarePants/spongebob-flyingdown.ogg"))
    
    Graphics.sprites.hardcoded["33-2"].img = Graphics.loadImageResolved("costumes/mario/SpongeBobSquarePants/hardcoded-33-2.png")
    Graphics.sprites.hardcoded["33-5"].img = Graphics.loadImageResolved("costumes/mario/SpongeBobSquarePants/hardcoded-33-5.png")
    
    Graphics.sprites.npc[10].img = Graphics.loadImageResolved("costumes/mario/SpongeBobSquarePants/npc-10.png")
    Graphics.sprites.npc[33].img = Graphics.loadImageResolved("costumes/mario/SpongeBobSquarePants/npc-33.png")
    Graphics.sprites.npc[88].img = Graphics.loadImageResolved("costumes/mario/SpongeBobSquarePants/npc-88.png")
    Graphics.sprites.npc[999].img = Graphics.loadImageResolved("costumes/mario/SpongeBobSquarePants/npc-97.png")
    Graphics.sprites.npc[1000].img = Graphics.loadImageResolved("costumes/mario/SpongeBobSquarePants/npc-97.png")
    Graphics.sprites.npc[103].img = Graphics.loadImageResolved("costumes/mario/SpongeBobSquarePants/npc-103.png")
    Graphics.sprites.npc[258].img = Graphics.loadImageResolved("costumes/mario/SpongeBobSquarePants/npc-258.png")
    
    Defines.jumpheight = 14
    Defines.player_walkspeed = 2.7
    Defines.player_runspeed = 4.5
    Defines.jumpheight_bounce = 32
    Defines.projectilespeedx = 7.1
    Defines.player_grav = 0.4
    
    costume.abilitesenabled = true
    costume.useFallingFrame = false
end

local function isOnGround(p)
    return (
        p.speedY == 0 -- "on a block"
        or p:mem(0x176,FIELD_WORD) ~= 0 -- on an NPC
        or p:mem(0x48,FIELD_WORD) ~= 0 -- on a slope
    )
end

local atPSpeed = p:mem(0x16C,FIELD_BOOL) or p:mem(0x16E,FIELD_BOOL)

local function isSlowFalling(p)
    return (leafPowerups[p.powerup] and p.speedY > 0 and (p.keys.jump or p.keys.altJump))
end

local function canFall(p)
    return (
        p.forcedState == FORCEDSTATE_NONE
        and p.deathTimer == 0 and not p:mem(0x13C,FIELD_BOOL) -- not dead
        and not isOnGround(p)
        and p.mount == MOUNT_NONE
        and not p.climbing
        and not p:mem(0x0C,FIELD_BOOL) -- fairy
        and not p:mem(0x3C,FIELD_BOOL) -- sliding
        and not p:mem(0x44,FIELD_BOOL) -- surfing on a rainbow shell
        and not p:mem(0x4A,FIELD_BOOL) -- statue
        and p:mem(0x34,FIELD_WORD) == 0 -- underwater
    )
end

function costume.onStart()
    if SaveData.toggleCostumeAbilities == true then
        --Audio.playSFX("costumes/mario/SpongeBobSquarePants/start-level.ogg")
    end
end

function costume.onPostNPCKill(npc, harmType)
    if SaveData.toggleCostumeAbilities == true then
        local items = table.map{9,184,185,249,14,182,183,34,169,170,277,264,996,994}
        local rngkey = rng.randomInt(1,12)
        if items[npc.id] and Colliders.collide(plr, npc) then
            SFX.play("costumes/mario/SpongeBobSquarePants/spongebob-grow"..rngkey..".ogg", 1, 1, 80)
        end
    end
end

function costume.onTickEnd()
    if SaveData.toggleCostumeAbilities == true then
        if canFall(p) then
            costume.useFallingFrame = player.speedY > 0
        else
            costume.useFallingFrame = false
        end
    end
end

local function isSlidingOnIce(plr)
    return (plr:mem(0x0A,FIELD_BOOL) and (not plr.keys.left and not plr.keys.right))
end

function costume.onTick(repeated)
    if SaveData.toggleCostumeAbilities == true then
        if player.speedX ~= 0 and not isSlidingOnIce(plr) then
            --if player.frame == 3 or player.frame == 9 then
                --SFX.play("costumes/SpongeBobSquarePants/spongebob-footsteps.ogg", 0.4, 1, 40)
            --end
        end
        if leafPowerups[p.powerup] then
            if p.holdingNPC == nil then
                if isSlowFalling(p) then
                    plr:setFrame(27)
                    timer2 = timer2 - 1
                    if timer2 == 4 then
                        if table.icontains(smastables._noLevelPlaces,Level.filename()) == false then
                            SFX.play(flybeginsound, 1, 1, 10)
                        end
                    elseif timer2 <= 3 then
                        if table.icontains(smastables._noLevelPlaces,Level.filename()) == false then
                            if flybeginsound.playing then
                                flybeginsound:stop()
                            end
                        end
                    end
                end
            end
            if player:isGroundTouching() == true or player:isClimbing() == true then
                timer2 = 5
            end
        end
        if player:isOnGround() or player:isClimbing() then --Checks to see if the player is on the ground, is climbing, is not underwater (smasfunctions), the death timer is at least 0, the end state is none, or the mount is a clown car
            hasJumped = false
        elseif (not hasJumped) and player.keys.jump == KEYS_PRESSED and player.deathTimer == 0 and Level.endState() == 0 and player.mount == 0 and not Playur.underwater(player) then
            hasJumped = true
            player:mem(0x11C, FIELD_WORD, 16)
            if table.icontains(smastables._noLevelPlaces,Level.filename()) == false then
                Sound.playSFX("mario/SpongeBobSquarePants/player-jump-twice.ogg")
            end
        end
    end
end

function costume.onPlayerHarm()
    
end

function costume.onPlayerKill()
    local rngkey = rng.randomInt(1,7)
    Sound.playSFX("mario/SpongeBobSquarePants/spongebob-dead"..rngkey..".ogg")
end

function costume.onCleanup(p)
    for i = 1,91 do
        Audio.sounds[i].sfx = nil
    end
    for i = 1,165 do
        extrasounds.sound.sfx[i] = nil
    end
    
    Graphics.sprites.hardcoded["33-2"].img = nil
    Graphics.sprites.hardcoded["33-5"].img = nil
    
    Graphics.sprites.npc[10].img = nil
    Graphics.sprites.npc[33].img = nil
    Graphics.sprites.npc[88].img = nil
    Graphics.sprites.npc[97].img = nil
    Graphics.sprites.npc[103].img = nil
    Graphics.sprites.npc[258].img = nil
        
    Defines.jumpheight = 20
    Defines.player_walkspeed = 3
    Defines.player_runspeed = 6
    Defines.jumpheight_bounce = 32
    Defines.projectilespeedx = 7.1
    Defines.player_grav = 0.4
    
    costume.abilitesenabled = false
end

return costume