--[[

    Accurate SMW Mario & Luigi Costume
    by MrDoubleA & DarSonic55

    See _notes.txt for more

]]

local playerManager = require("playerManager")
local smasExtraSounds = require("smasExtraSounds")
local smasFunctions = require("smasFunctions")

local costume = {}

local players = {}

local doPSpeedAnimation = true


local useFallingFrame = false
local usePSpeedFrames = false

local timers = {}

local walkFrames = {}
walkFrames[PLAYER_SMALL] = table.map{1,2,5,6,16,17}
walkFrames[PLAYER_BIG  ] = table.map{1,2,3,8,9,10,16,17,18}

local leafFallingFrames = table.map{3,5,11,29}
local leafPowerups = table.map{4,5}

local neededPSpeed = { -- How long the player has to be running for the p-speed animation to start
    [CHARACTER_MARIO] = 35,
    [CHARACTER_LUIGI] = 40,
}

-- Copied from unclebroadsword.lua by Ohmato/Arabsalmon
local function canDuck(p)
    -- Ignore if not holding down or not small
    if not p.keys.down or (p.powerup ~= PLAYER_SMALL and p:mem(0x154, FIELD_WORD) == 0) then return false end
    
    -- Check if dead
    if p:mem(0x13e, FIELD_WORD) > 0 then return false end
    -- Check if submerged and standing on the ground
    if (p:mem(0x34, FIELD_WORD) ~= 0 or p:mem(0x36, FIELD_WORD) ~= 0)
    and not p:isGroundTouching() then return false end
    -- Check if on a slope and not underwater
    if p:mem(0x48, FIELD_WORD) ~= 0 and p:mem(0x36, FIELD_WORD) == 0 then return false end
    -- Check if sliding, climbing, holding an item, in statue form, or spinjumping
    if p:mem(0x3c, FIELD_WORD) ~= 0
    or p:mem(0x40, FIELD_WORD) ~= 0
    --or p:mem(0x154, FIELD_WORD) > 0
    or p:mem(0x4a, FIELD_WORD) == -1
    or p:mem(0x50, FIELD_WORD) ~= 0 then return false end
    -- Check if pulling an item from the ground
    if p:mem(0x26,FIELD_WORD) > 0 then return false end
    -- Check if on a mount or riding a rainbow shell
    if p.mount > 0 or p:mem(0x44,FIELD_BOOL) then return end
    -- Check if in a forced animation
    if p.forcedState == 1    -- Powering up
    or p.forcedState == 2    -- Powering down
    or p.forcedState == 3    -- Entering pipe
    or p.forcedState == 4    -- Getting fire flower
    or p.forcedState == 7    -- Entering door
    or p.forcedState == 41    -- Getting ice flower
    or p.forcedState == 500 then return false end
    
    return true
end

costume.loaded = false

function costume.onInit(playerObj)
    if not costume.loaded then
        Sound.loadCostumeSounds()
        costume.loaded = true
    end
    
    Graphics.sprites.npc[9].img = Graphics.loadImageResolved("costumes/mario/Modern2/npc-9.png")
    Graphics.sprites.npc[14].img = Graphics.loadImageResolved("costumes/mario/Modern2/npc-14.png")
    Graphics.sprites.npc[34].img = Graphics.loadImageResolved("costumes/mario/Modern2/npc-34.png")
    Graphics.sprites.npc[169].img = Graphics.loadImageResolved("costumes/mario/Modern2/npc-169.png")
    Graphics.sprites.npc[170].img = Graphics.loadImageResolved("costumes/mario/Modern2/npc-170.png")
    Graphics.sprites.npc[183].img = Graphics.loadImageResolved("costumes/mario/Modern2/npc-183.png")
    Graphics.sprites.npc[263].img = Graphics.loadImageResolved("costumes/mario/Modern2/npc-263.png")
    Graphics.sprites.npc[264].img = Graphics.loadImageResolved("costumes/mario/Modern2/npc-264.png")
    Graphics.sprites.npc[265].img = Graphics.loadImageResolved("costumes/mario/Modern2/npc-265.png")
    Graphics.sprites.npc[277].img = Graphics.loadImageResolved("costumes/mario/Modern2/npc-277.png")
    
    smasExtraSounds.enableFireFlowerHitting = true
    
    registerEvent(costume, "onDraw")
    registerEvent(costume, "onTick")
    registerEvent(costume, "onTickEnd")
    
    if not table.ifind(players,playerObj) then
        table.insert(players,playerObj)
    end
    
    timers[playerObj] = {    
                            pSpeedTimer = 0, 
                            walkTimer = 0, 
                            kickTimer = 0, 
                            tailTimer = 0 -- For falling slowly with leaf/tanookie suit
                        }
end

function costume.onTick()
    for _,p in ipairs(players) do
        if canDuck(p) and p:isGroundTouching() then
            if p.keys.left == KEYS_PRESSED then
                p.direction = DIR_LEFT
            elseif p.keys.right == KEYS_PRESSED then
                p.direction = DIR_RIGHT
            end

            p:mem(0x12C,FIELD_BOOL,true)
            p:mem(0x12E,FIELD_BOOL,true)

            p.keys.left = KEYS_UP
            p.keys.right = KEYS_UP
        end
    end
end

function costume.onTickEnd()
    for _,p in ipairs(players) do
        if timers[p] then
            local settings = PlayerSettings.get(playerManager.getBaseID(p.character),p.powerup)

            if p.forcedState == 0 and p.deathTimer == 0 and not p:mem(0x13C,FIELD_BOOL) then
                if p:isGroundTouching() or p:mem(0x40,FIELD_WORD) > 0 then
                    useFallingFrame = false
                end

                -- P-Speed logic
                if not leafPowerups[p.powerup] and p:mem(0x34,FIELD_WORD) == 0 then
                    if p:isGroundTouching() and math.abs(p.speedX) >= Defines.player_runspeed then
                        timers[p].pSpeedTimer = math.min((neededPSpeed[p.character] or math.huge),timers[p].pSpeedTimer + 1)
                    elseif p:isGroundTouching() then
                        timers[p].pSpeedTimer = math.max(0,timers[p].pSpeedTimer - 0.3)
                    end
                end

                if doPSpeedAnimation and doPSpeedAnimation and timers[p].pSpeedTimer >= (neededPSpeed[p.character] or math.huge) then
                    if p.powerup == PLAYER_SMALL                                 and (p.frame == 3 or p.frame == 7)
                    or p.powerup ~= PLAYER_SMALL and not leafPowerups[p.powerup] and (p.frame == 4 or p.frame == 5)
                    then
                        p.frame = 19
                    end
                end


                if canDuck(p) then
                    if p:mem(0x154, FIELD_WORD) > 0 then
                        p.frame = 36

                        if p.direction == DIR_RIGHT then
                            p.holdingNPC.x = (p.x+settings.grabOffsetX)
                        else
                            p.holdingNPC.x = (p.x+p.width-settings.grabOffsetX-p.holdingNPC.width)
                        end
                        p.holdingNPC.y = (p.y+p.height-p.holdingNPC.height)
                    else
                        p.frame = 35
                    end

                    p:mem(0x12C,FIELD_BOOL,true)
                    p:mem(0x12E,FIELD_BOOL,true)
                elseif p:isGroundTouching() then
                    if p.speedX == 0 then
                        if p.keys.up and not p:mem(0x44,FIELD_BOOL) and p.mount == 0 then
                            if p.frame == 1 then
                                p.frame = 32
                            elseif (p.frame == 5 and p.powerup == 1) or (p.frame == 8 and p.powerup ~= 1) then
                                p.frame = 33
                            end
                        end
                    end
                elseif leafPowerups[p.powerup] and leafFallingFrames[p.frame] and (p.keys.jump or p.keys.altJump) then -- gotta love redigit
                    timers[p].tailTimer = (timers[p].tailTimer+1)%15

                    if timers[p].tailTimer < 5 then
                        p.frame = 11
                    elseif timers[p].tailTimer < 10 then
                        p.frame = 29
                    else
                        p.frame = 5
                    end
                else
                    if p.speedY > 0 or p.mount > 0 then
                        useFallingFrame = true
                    end

                    if useFallingFrame and (p.powerup == PLAYER_SMALL and p.frame == 3) then
                        p.frame = 7
                    elseif useFallingFrame and (p.powerup ~= PLAYER_SMALL and p.frame == 4) then
                        p.frame = 5
                    end
                end

                if p:mem(0x154,FIELD_WORD) > 0 then
                    timers[p].kickTimer = -1
                elseif timers[p].kickTimer < 0 then
                    if not p:mem(0x12E,FIELD_BOOL) then
                        local e = Effect.spawn(75,0,0)

                        e.x = (p.x+(p.width/2)+((p.width/2)*p.direction)-(e.width/2))
                        e.y = (p.y+(p.height/2)-(e.height/2))
                    end

                    timers[p].kickTimer = 16 -- Start kick animation if the player isn't holding an item, but was on the last frame
                elseif timers[p].kickTimer > 0 then
                    timers[p].kickTimer = timers[p].kickTimer - 1
                end
                if timers[p].kickTimer > 0 and not p:mem(0x12E,FIELD_BOOL) then
                    p.frame = 34
                end
            else
                timers[p].pSpeedTimer = 0
                timers[p].kickTimer = 0
            end

            if p.deathTimer == 0 and not p:mem(0x13C,FIELD_BOOL) then
                -- Change walk animation to be more like SMW
                local nearbyWarp = Warp(p:mem(0x15E,FIELD_WORD)-1)

                if  p.mount == 0
                and (p.forcedState == 0 and p.speedX ~= 0 and not p:mem(0x50,FIELD_BOOL) and (walkFrames[p.powerup] or walkFrames[PLAYER_BIG])[p.frame] and (p:mem(0x154,FIELD_WORD) == 0 or p:isGroundTouching())
                or   p.forcedState == 3 and (nearbyWarp and nearbyWarp.isValid and (nearbyWarp:mem(0x80,FIELD_WORD) == 2 or nearbyWarp:mem(0x80,FIELD_WORD) == 4))
                ) then
                    local frames = 3
                    local frameTime = 15

                    if p.powerup == PLAYER_SMALL then
                        frames = 2
                    end

                    if p.forcedState == 3 then
                        timers[p].walkTimer = (timers[p].walkTimer+1)%(frames*frameTime)
                    else
                        timers[p].walkTimer = (timers[p].walkTimer+math.max(1,math.abs(p.speedX)))%(frames*frameTime)
                    end

                    local frameOffset = 1
                    if p:mem(0x154,FIELD_WORD) > 0 then
                        if p.powerup == PLAYER_SMALL then
                            frameOffset = 5
                        else
                            frameOffset = 8
                        end
                    elseif p:mem(0x16C,FIELD_BOOL) or (doPSpeedAnimation and timers[p].pSpeedTimer >= (neededPSpeed[p.character] or math.huge)) then
                        frameOffset = 16
                    end

                    p.frame = (((frames*frameTime)-math.floor(timers[p].walkTimer)-1)/frameTime)+frameOffset
                else
                    timers[p].walkTimer = 0
                end
            end
        end
    end
end

function costume.onDraw()
    for _,v in ipairs(Animation.get(3)) do
        v.width = 32;
        v.height = 48;
    end
end

function costume.onCleanup(playerObj)
    Sound.cleanupCostumeSounds()
    
    Graphics.sprites.npc[9].img = nil
    Graphics.sprites.npc[14].img = nil
    Graphics.sprites.npc[34].img = nil
    Graphics.sprites.npc[169].img = nil
    Graphics.sprites.npc[170].img = nil
    Graphics.sprites.npc[183].img = nil
    Graphics.sprites.npc[263].img = nil
    Graphics.sprites.npc[264].img = nil
    Graphics.sprites.npc[265].img = nil
    Graphics.sprites.npc[277].img = nil
    
    smasExtraSounds.enableFireFlowerHitting = false
    
    local spot = table.ifind(players,playerObj)

    timers[playerObj] = nil
    
    if spot then
        table.remove(players,spot)
    end
end

Misc.storeLatestCostumeData(costume)

return costume;