local playerManager = require("playerManager")
local extrasounds = require("extrasounds")

local costume = {}

local players = {}

local doPSpeedAnimation = true

local starman = require("starman/star")

local useFallingFrame = false
local usePSpeedFrames = false
local pSpeedTimer = 0
local walkTimer = 0
local kickTimer = 0
local tailTimer = 0 -- For falling slowly with leaf/tanookie suit

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

function costume.onInit(playerObj)
    registerEvent(costume, "onStart")
    registerEvent(costume, "onDraw")
    registerEvent(costume, "onTick")
    registerEvent(costume, "onTickEnd")
    
    extrasounds.sound.sfx[1] = Audio.SfxOpen("costumes/mario/Z-SMW2-AdultMario/player-jump.ogg")
    Audio.sounds[2].sfx  = Audio.SfxOpen("costumes/mario/Z-SMW2-AdultMario/stomped.ogg")
    Audio.sounds[3].sfx  = Audio.SfxOpen("costumes/mario/Z-SMW2-AdultMario/block-hit.ogg")
    Audio.sounds[5].sfx  = Audio.SfxOpen("costumes/mario/Z-SMW2-AdultMario/player-shrink.ogg")
    Audio.sounds[6].sfx  = Audio.SfxOpen("costumes/mario/Z-SMW2-AdultMario/player-grow.ogg")
    extrasounds.sound.sfx[14] = Audio.SfxOpen("costumes/mario/Z-SMW2-AdultMario/coin.ogg")
    extrasounds.sound.sfx[15] = Audio.SfxOpen("costumes/mario/Z-SMW2-AdultMario/1up.ogg")
    Audio.sounds[17].sfx = Audio.SfxOpen("costumes/mario/Z-SMW2-AdultMario/warp.ogg")
    Audio.sounds[20].sfx = Audio.SfxOpen("costumes/mario/Z-SMW2-AdultMario/boss-beat.ogg")
    Audio.sounds[32].sfx = Audio.SfxOpen("costumes/mario/Z-SMW2-AdultMario/pswitch.ogg")
    extrasounds.sound.sfx[33] = Audio.SfxOpen("costumes/mario/Z-SMW2-AdultMario/tail.ogg")
    Audio.sounds[34].sfx = Audio.SfxOpen("costumes/mario/Z-SMW2-AdultMario/racoon.ogg")
    Audio.sounds[46].sfx = Audio.SfxOpen("costumes/mario/Z-SMW2-AdultMario/door.ogg")
    Audio.sounds[50].sfx = Audio.SfxOpen("costumes/mario/Z-SMW2-AdultMario/yoshi-tongue.ogg")
    Audio.sounds[52].sfx = Audio.SfxOpen("costumes/mario/Z-SMW2-AdultMario/got-star.ogg")
    Audio.sounds[55].sfx = Audio.SfxOpen("costumes/mario/Z-SMW2-AdultMario/yoshi-swallow.ogg")
    Audio.sounds[58].sfx = Audio.SfxOpen("costumes/mario/Z-SMW2-AdultMario/smw-checkpoint.ogg")
    extrasounds.sound.sfx[59] = Audio.SfxOpen("costumes/mario/Z-SMW2-AdultMario/dragon-coin.ogg")
    Audio.sounds[72].sfx = Audio.SfxOpen("costumes/mario/Z-SMW2-AdultMario/swim.ogg")
    Audio.sounds[91].sfx = Audio.SfxOpen("costumes/mario/Z-SMW2-AdultMario/bubble.ogg")
    
    if not table.ifind(players,playerObj) then
        table.insert(players,playerObj)
    end
end

function costume.onStart()
    
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
        local settings = PlayerSettings.get(playerManager.getBaseID(p.character),p.powerup)

        if p.forcedState == 0 and p.deathTimer == 0 and not p:mem(0x13C,FIELD_BOOL) then
            if p:isGroundTouching() or p:mem(0x40,FIELD_WORD) > 0 then
                useFallingFrame = false
            end

            -- P-Speed logic
            if not leafPowerups[p.powerup] and p:mem(0x34,FIELD_WORD) == 0 then
                if p:isGroundTouching() and math.abs(p.speedX) >= Defines.player_runspeed then
                    pSpeedTimer = math.min((neededPSpeed[p.character] or math.huge),pSpeedTimer + 1)
                elseif p:isGroundTouching() then
                    pSpeedTimer = math.max(0,pSpeedTimer - 0.3)
                end
            end

            if doPSpeedAnimation and doPSpeedAnimation and pSpeedTimer >= (neededPSpeed[p.character] or math.huge) then
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
                tailTimer = (tailTimer+1)%15

                if tailTimer < 5 then
                    p.frame = 11
                elseif tailTimer < 10 then
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
                kickTimer = -1
            elseif kickTimer < 0 then
                if not p:mem(0x12E,FIELD_BOOL) then
                    local e = Effect.spawn(75,0,0)

                    e.x = (p.x+(p.width/2)+((p.width/2)*p.direction)-(e.width/2))
                    e.y = (p.y+(p.height/2)-(e.height/2))
                end

                kickTimer = 16 -- Start kick animation if the player isn't holding an item, but was on the last frame
            elseif kickTimer > 0 then
                kickTimer = kickTimer - 1
            end
            if kickTimer > 0 and not p:mem(0x12E,FIELD_BOOL) then
                p.frame = 34
            end
        else
            pSpeedTimer = 0
            kickTimer = 0
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
                    walkTimer = (walkTimer+1)%(frames*frameTime)
                else
                    walkTimer = (walkTimer+math.max(1,math.abs(p.speedX)))%(frames*frameTime)
                end

                local frameOffset = 1
                if p:mem(0x154,FIELD_WORD) > 0 then
                    if p.powerup == PLAYER_SMALL then
                        frameOffset = 5
                    else
                        frameOffset = 8
                    end
                elseif p:mem(0x16C,FIELD_BOOL) or (doPSpeedAnimation and pSpeedTimer >= (neededPSpeed[p.character] or math.huge)) then
                    frameOffset = 16
                end

                p.frame = (((frames*frameTime)-math.floor(walkTimer)-1)/frameTime)+frameOffset
            else
                walkTimer = 0
            end
        end
    end
end

function costume.onDraw()
    for _,v in ipairs(Animation.get(3)) do
        v.width = 32;
        v.height = 48;
    end
    for _,v in ipairs(Animation.get(5)) do
        v.width = 32;
        v.height = 54;
    end
end

function costume.onCleanup(playerObj)
    extrasounds.sound.sfx[1] = nil    
    Audio.sounds[2].sfx  = nil
    Audio.sounds[3].sfx  = nil
    Audio.sounds[4].sfx  = nil
    Audio.sounds[5].sfx  = nil
    Audio.sounds[6].sfx  = nil
    Audio.sounds[7].sfx  = nil
    extrasounds.sound.sfx[8] = nil
    Audio.sounds[9].sfx  = nil
    extrasounds.sound.sfx[10] = nil
    Audio.sounds[11].sfx = nil
    Audio.sounds[12].sfx = nil
    Audio.sounds[13].sfx = nil
    extrasounds.sound.sfx[14] = nil
    extrasounds.sound.sfx[15] = nil
    Audio.sounds[16].sfx = nil
    Audio.sounds[17].sfx = nil
    extrasounds.sound.sfx[18] = nil
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
    extrasounds.sound.sfx[43] = nil
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
    Audio.sounds[59].sfx = nil
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
    extrasounds.sound.sfx92 = Audio.SfxOpen(Misc.resolveSoundFile("sound/sprout-vine.ogg"))
    extrasounds.sound.sfx93 = Audio.SfxOpen(Misc.resolveSoundFile("sound/iceball.ogg"))
    extrasounds.sound.sfx94 = Audio.SfxOpen(Misc.resolveSoundFile("sound/yi-freeze.ogg"))
    extrasounds.sound.sfx95 = Audio.SfxOpen(Misc.resolveSoundFile("sound/yi-icebreak.ogg"))
    extrasounds.sound.sfx96 = Audio.SfxOpen(Misc.resolveSoundFile("sound/2up.ogg"))
    extrasounds.sound.sfx97 = Audio.SfxOpen(Misc.resolveSoundFile("sound/3up.ogg"))
    extrasounds.sound.sfx98 = Audio.SfxOpen(Misc.resolveSoundFile("sound/5up.ogg"))
    extrasounds.sound.sfx99 = Audio.SfxOpen(Misc.resolveSoundFile("sound/dragon-coin-get2.ogg"))
    extrasounds.sound.sfx100 = Audio.SfxOpen(Misc.resolveSoundFile("sound/dragon-coin-get3.ogg"))
    extrasounds.sound.sfx101 = Audio.SfxOpen(Misc.resolveSoundFile("sound/dragon-coin-get4.ogg"))
    extrasounds.sound.sfx102 = Audio.SfxOpen(Misc.resolveSoundFile("sound/dragon-coin-get5.ogg"))
    extrasounds.sound.sfx103 = Audio.SfxOpen(Misc.resolveSoundFile("sound/cherry.ogg"))
    local spot = table.ifind(players,playerObj)

    if spot then
        table.remove(players,spot)
    end
end

return costume;