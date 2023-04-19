--[[

    Yoshi's Island Styled Yoshi
    by MrDoubleA

    Yoshi sprites ripped by Inky (https://www.spriters-resource.com/snes/yoshiisland/sheet/4808/)
    Text ripped by Nemica (https://www.spriters-resource.com/snes/yoshiisland/sheet/19542/)
    Overworld sprites by KBM-Quine

]]

local playerManager = require("playermanager")
local npcManager = require("npcManager")

local textplus = require("textplus")

local megashroom,starman,playerstun


if not isOverworld then
    megashroom = require("mega/megashroom")
    starman = require("starman/star")
    playerstun = require("playerstun") -- to handle the sledge bro's stun
end


local smwMap
pcall(function() smwMap = require("smwMap") end)

local isOnSMWMap = (smwMap ~= nil and Level.filename() == smwMap.levelFilename)


local yoshi = {}

_G.CHARACTER_YOSHI = CHARACTER_NINJABOMBERMAN
playerManager.overrideCharacterLib(CHARACTER_YOSHI,yoshi)

local p = player

local data = {}
yoshi.playerData = data


SaveData.yiYoshi = SaveData.yiYoshi or {}
local saveData = SaveData.yiYoshi

GameData.yiYoshi = GameData.yiYoshi or {}
local gameData = GameData.yiYoshi


saveData.currentColour = saveData.currentColour or 0
saveData.savedEggs = saveData.savedEggs or {}

-- for keeping the player's star count from a checkpoint
gameData.savedStarsCount = gameData.savedStarsCount or nil
gameData.savedStarsPath  = gameData.savedStarsPath  or nil


local FULL_PATH_ADDR = 0x00B2C618
local CHECKPOINT_PATH_ADDR = 0x00B250B0

local baseCharacterSpeedModifier = 0.83



local HEALTH_SYSTEM = {
    BABY_MARIO = 0,
    HEARTS = 1,
}


local BABY_STATE
local HURT_STATE
local STAR_COUNTER_STATE

local TONGUE_STATE
local NPC_TONGUE_BEHAVIOUR

local GROUND_POUND_STATE



local initHUD -- save this for later
local summonToadies
local toadiesFormation


local blocksToCheck = {} -- blocks to check to see if stars should be spawned from them

-- Contains how many stars each NPC is worth
local powerupStars = {
    -- mushrooms
    [9]   = 3,
    [184] = 3,
    [185] = 3,
    [249] = 3,
    [250] = 3,
    [462] = 3,
    -- fire flowers
    [14]  = 5,
    [182] = 5,
    [183] = 5,
    -- ice flowers
    [264] = 5,
    [277] = 5,

    [34]  = 5, -- leaf
    [169] = 8, -- tanookie
    [170] = 8, -- hammer
}


yoshi.curveTransitionMin = 0
yoshi.curveTransitionMax = 0

yoshi.curveTransitionShader = "yiYoshi/transition_curves.frag"


yoshi.wipeTransitionProgress = 0

yoshi.wipeTransitionShader = "yiYoshi/transition_wipe.frag"


yoshi.transitionBuffer = Graphics.CaptureBuffer(800,600)


yoshi.forceCameraX = nil
yoshi.forceCameraY = nil


yoshi.highPriorityFadeIn = 0


local function setMaxSpeed()
    Defines.player_walkspeed = yoshi.generalSettings.walkSpeed/baseCharacterSpeedModifier
    Defines.player_runspeed  = yoshi.generalSettings.runSpeed /baseCharacterSpeedModifier
end


local function getPipeDirection()
    local warp = Warp(p:mem(0x15E,FIELD_WORD)-1)

    if p.forcedTimer == 0 then
        return warp.entranceDirection
    else
        return warp.exitDirection
    end
end



local function isOnGroundRedigit()
    return (
        p.speedY == 0
        or p:mem(0x176,FIELD_WORD) ~= 0 -- on an NPC
        or p:mem(0x48,FIELD_WORD) ~= 0 -- on a slope
    )
end


local function canUseCustomStuff()
    return (
        p.forcedState == FORCEDSTATE_NONE
        and p.deathTimer == 0

        and not p:mem(0x0C,FIELD_BOOL) -- fairy
        and not p.climbing
    )
end


local function printFunny(text)
    local maxWidth = yoshi.introSettings.textMaxWidth*1.5

    yoshi.transitionBuffer:clear(-100)

    textplus.print{
        text = text,
        target = yoshi.transitionBuffer,priority = -100,
        font = yoshi.introSettings.textFont,xscale = yoshi.introSettings.textScale,yscale = yoshi.introSettings.textScale,maxWidth = maxWidth,
        x = camera.width*0.5 - maxWidth*0.5 + yoshi.introSettings.textXOffset,
        y = camera.height*0.5 + yoshi.introSettings.textYOffset,
    }
end


-- Health / Baby Mario
local handleHealth
local resetHealthData
local handleHealthOnDraw

do
    BABY_STATE = {
        NORMAL = 0,
        
        YEETED = 1,
        BUBBLE = 2,

        RESCUED = 3,

        KIDNAPPED = 4,
        CARRIED_OFF = 5,

        PASSED = 6,

        YEETED_VIA_CHEAT = 7,
    }

    HURT_STATE = {
        NORMAL = 0,
        HIT_BACK = 1,
        SPIN = 2,
    }

    STAR_COUNTER_STATE = {
        NORMAL = 0,
        DECREASING = 1,
        CHECKPOINT_BONUS = 2,
        LOST_CAUSE = 3,
    }


    yoshi.BABY_STATE = BABY_STATE


    -- Hurt state
    local function canBeInHurtState()
        return (
            p.forcedState == FORCEDSTATE_NONE
            and p.deathTimer == 0

            and (p:mem(0x11C,FIELD_WORD) == 0 or data.hurtState == HURT_STATE.NORMAL)

            and (data.hurtState ~= HURT_STATE.HIT_BACK or not isOnGroundRedigit() and (p:mem(0x34,FIELD_WORD) == 0 or data.hurtTimer < 20))
            and (data.hurtState ~= HURT_STATE.SPIN or data.hurtTimer < 50)

            and p.mount == MOUNT_NONE
        )
    end


    local function handleHurtState()
        if data.hurtState == HURT_STATE.NORMAL then
            return
        end

        if not canBeInHurtState() then
            data.hurtState = HURT_STATE.NORMAL
            data.hurtTimer = 0
            return
        end


        for k,v in pairs(p.keys) do
            if k ~= "pause" and k ~= "dropItem" then
                p.keys[k] = false
            end
        end


        data.hurtTimer = data.hurtTimer + 1

        if data.hurtState == HURT_STATE.SPIN then
            p.speedX = p.speedX * 0.97
        end
    end


    -- Baby stuff
    local function getJumpOntoPosition()
        return (p.x + p.width*0.5 + yoshi.generalSettings.mainOffset.x + yoshi.generalSettings.babyMarioOffset.x*data.megaMushroomScale*p.direction), (p.y + p.height + yoshi.generalSettings.mainOffset.y + yoshi.generalSettings.babyMarioOffset.y*data.megaMushroomScale)
    end


    function yoshi.loseBaby()
        local babyData = data.babyMario

        if yoshi.generalSettings.healthSystem ~= HEALTH_SYSTEM.BABY_MARIO or babyData.state ~= BABY_STATE.NORMAL then
            return
        end

        babyData.state = BABY_STATE.YEETED
        babyData.timer = 0

        babyData.direction = p.direction

        babyData.x = p.x + p.width*0.5 + yoshi.generalSettings.mainOffset.x + (yoshi.generalSettings.babyMarioOffset.x + babyData.x)*p.direction
        babyData.y = p.y + p.height    + yoshi.generalSettings.mainOffset.y + (yoshi.generalSettings.babyMarioOffset.y + babyData.y)

        babyData.speedX = -2*babyData.direction
        babyData.speedY = -7


        data.starCounterState = STAR_COUNTER_STATE.DECREASING
        data.starCounterTimer = 0
    end

    function yoshi.rescueBaby()
        local babyData = data.babyMario

        if yoshi.generalSettings.healthSystem ~= HEALTH_SYSTEM.BABY_MARIO or babyData.state ~= BABY_STATE.BUBBLE then
            return
        end


        babyData.state = BABY_STATE.RESCUED
        babyData.timer = 0


        local goalX,goalY = getJumpOntoPosition()

        if babyData.x ~= goalX then
            local diffX = (goalX - babyData.x)
            local diffY = (goalY - babyData.y)

            babyData.speedX = math.lerp(0,6,math.clamp(math.abs(diffX) / 300,0.01,1)) * math.sign(diffX)

            local t = math.abs(diffX / babyData.speedX)
            babyData.speedY = (diffY / t) - (0.3 * t) / 2

            babyData.hopOnDuration = t
        else -- edge case
            babyData.speedY = -5
            babyData.hopOnDuration = 0
        end


        babyData.direction = -p.direction
        babyData.bubbleFrame = 0

        SFX.play(yoshi.generalSettings.babyPopBubbleSound)


        data.starCounterState = STAR_COUNTER_STATE.NORMAL
        data.starCounterTimer = 0

        Misc.pause(true)
    end


    local function resetBaby()
        data.babyMario.state = BABY_STATE.NORMAL
        data.babyMario.timer = 0

        data.babyMario.x = 0
        data.babyMario.y = 0

        data.babyMario.direction = 0

        data.babyMario.speedX = 0
        data.babyMario.speedY = 0

        data.babyMario.higherPriority = false

        data.babyMario.bubbleFrame = 0

        data.babyMario.hopOnDuration = 0
        data.babyMario.megaMushroomScale = 1

        data.babyMario.collider = Colliders.Box(0,0,0,0)
    end

    local function handleBaby()
        local babyData = data.babyMario
        
        if babyData.state == BABY_STATE.YEETED then
            babyData.speedY = babyData.speedY + 0.2

            if data.babyMario.speedY > 5 then
                babyData.state = BABY_STATE.BUBBLE
                babyData.timer = 0

                babyData.speedX = math.sign(babyData.speedX)*1.5
                babyData.speedY = 1.5


                SFX.play(yoshi.generalSettings.babyCreateBubbleSound)
            end
        elseif babyData.state == BABY_STATE.BUBBLE then
            local collider = Colliders.Box(0,0,64,64)

            babyData.collider.width = 64
            babyData.collider.height = 64

            babyData.collider.x = babyData.x - babyData.collider.width*0.5
            babyData.collider.y = babyData.y - 20 - babyData.collider.height

            local distance = vector(
                (p.x + p.width *0.5) - (babyData.collider.x + babyData.collider.width *0.5),
                (p.y + p.height*0.5) - (babyData.collider.y + babyData.collider.height*0.5)
            )

            local idealSpeed = distance:normalise()*0.75

            if babyData.timer < 128 then
                idealSpeed = -idealSpeed
            end

            local b = p.sectionObj.boundary

            if (babyData.x < b.left+32 and idealSpeed.x <= 0) or (babyData.x > b.right-32 and idealSpeed.x >= 0) then
                idealSpeed.x = -idealSpeed.x*2
            end
            if (babyData.y < b.top+32 and idealSpeed.y <= 0) or (babyData.y > b.bottom-32 and idealSpeed.y >= 0) then
                idealSpeed.y = -idealSpeed.y*2
            end


            local speed = vector(babyData.speedX,babyData.speedY)

            for i=1,2 do
                if speed[i] > idealSpeed[i] then
                    speed[i] = math.max(idealSpeed[i],speed[i] - 0.075)
                elseif speed[i] < idealSpeed[i] then
                    speed[i] = math.min(idealSpeed[i],speed[i] + 0.075)
                end
            end

            babyData.speedX = speed.x
            babyData.speedY = speed.y + math.cos(babyData.timer/64)*0.1


            local bubbleTimer = (babyData.timer-8)

            if bubbleTimer >= 0 then
                babyData.bubbleFrame = math.floor((bubbleTimer/8)%2) + 2
            else
                babyData.bubbleFrame = 1
            end

            
            babyData.timer = babyData.timer + 1


            if p.forcedState == FORCEDSTATE_NONE and p.deathTimer == 0 and babyData.collider:collide(p) then
                yoshi.rescueBaby()
                return
            end
        elseif babyData.state == BABY_STATE.KIDNAPPED then
            -- If all the toadies are still, move on
            local allReady = true

            for _,obj in ipairs(yoshi.toadies) do
                if obj.speedX ~= 0 or obj.speedY ~= 0 then
                    allReady = false
                    break
                end
            end

            if allReady then
                babyData.state = BABY_STATE.CARRIED_OFF
                babyData.timer = 0

                SFX.play(yoshi.generalSettings.babyCarriedOffSound)

                Audio.SeizeStream(-1)
                Audio.MusicPause()
            end


            babyData.speedX = 0
            babyData.speedY = 0
        elseif babyData.state == BABY_STATE.CARRIED_OFF then
            babyData.speedY = babyData.speedY - 0.05

            for _,obj in ipairs(yoshi.toadies) do
                obj.speedY = babyData.speedY
            end

            if babyData.y < camera.y or babyData.timer > 0 then
                babyData.timer = babyData.timer + 1
            end

            if babyData.timer > 8 and p.deathTimer == 0 then
                p:kill()
            end
        elseif babyData.state == BABY_STATE.PASSED then
            local goalX = data.exitWalkToX + yoshi.generalSettings.mainOffset.x + yoshi.generalSettings.babyMarioOffset.x*data.megaMushroomScale*p.direction
            local goalY = p.y + p.height + yoshi.generalSettings.mainOffset.y + yoshi.generalSettings.babyMarioOffset.y*data.megaMushroomScale

            if babyData.timer == 0 then
                local diffX = (goalX - babyData.x)
                local diffY = (goalY - babyData.y)

                babyData.speedX = math.lerp(0,3.5,math.clamp(math.abs(diffX)/300,0.01,1)) * math.sign(diffX)

                local t = math.abs(diffX / babyData.speedX)
                babyData.speedY = (diffY / t) - (0.2 * t) / 2
            end

            babyData.timer = babyData.timer + 1


            babyData.speedY = babyData.speedY + 0.2


            if babyData.x > goalX then -- too far!
                babyData.x = goalX
                babyData.speedX = 0
            end

            if (babyData.y >= goalY and babyData.speedY >= 0) or babyData.speedX < 0 then
                babyData.state = BABY_STATE.NORMAL
                babyData.timer = 0
    
                babyData.x = 0
                babyData.y = 0

                babyData.speedX = 0
                babyData.speedY = 0
    
                babyData.megaMushroomScale = 1

                data.trailFollowsBaby = false

                data.passOnTimer = 1
    
                SFX.play(yoshi.generalSettings.babyRescuedSound)
            end
        elseif babyData.state == BABY_STATE.YEETED_VIA_CHEAT then
            babyData.speedY = babyData.speedY + 0.2

            babyData.timer = babyData.timer + 1

            if babyData.timer == 64 then
                SFX.play(yoshi.generalSettings.babyCrySound)
            elseif babyData.timer >= 160 and p.deathTimer == 0 then
                p:kill()

                -- draw some funnies into the transition buffer
                printFunny("And with that, the Yoshi clan had purposefully failed their most important task.")
            end
        elseif babyData.state ~= BABY_STATE.RESCUED then
            babyData.speedX = 0
            babyData.speedY = 0
        end

        babyData.x = babyData.x + babyData.speedX
        babyData.y = babyData.y + babyData.speedY
    end

    local function handleBabyOnDraw()
        local babyData = data.babyMario

        if babyData.state ~= BABY_STATE.RESCUED then
            return
        end

        p:mem(0x142,FIELD_BOOL,false)


        local goalX,goalY = getJumpOntoPosition()

        babyData.speedY = babyData.speedY + 0.3

        babyData.x = babyData.x + babyData.speedX
        babyData.y = babyData.y + babyData.speedY


        if p.isMega then
            babyData.megaMushroomScale = math.lerp(1,data.megaMushroomScale,babyData.timer/babyData.hopOnDuration)
        end

        babyData.timer = babyData.timer + 1


        if (babyData.timer >= babyData.hopOnDuration and babyData.hopOnDuration > 0) or (babyData.y >= goalY and babyData.speedY >= 0 and babyData.hopOnDuration == 0) then
            babyData.state = BABY_STATE.NORMAL
            babyData.timer = 0

            babyData.x = 0
            babyData.y = 0

            babyData.megaMushroomScale = 1

            SFX.play(yoshi.generalSettings.babyRescuedSound)

            p:mem(0x140,FIELD_WORD,50)

            Misc.unpause()
        end
    end

    
    -- Star counter
    local function handleStarCounter()
        if data.starCounterState == STAR_COUNTER_STATE.DECREASING then
            data.starCounterTimer = data.starCounterTimer + 1

            if data.starCounterTimer >= yoshi.generalSettings.starCounterDecreaseTime then
                data.starCounter = math.max(0,data.starCounter - 1)
                data.starCounterTimer = 0

                if data.starCounter == 0 and data.babyMario.state == BABY_STATE.BUBBLE and #yoshi.toadies == 0 and p.deathTimer == 0 then
                    summonToadies()

                    SFX.play(yoshi.generalSettings.babyKidnappedSound)
                end
            end

            if (data.babyMario.state == BABY_STATE.BUBBLE or data.babyMario.state == BABY_STATE.YEETED) and p.deathTimer == 0 then
                if data.starCounter <= yoshi.generalSettings.starCounterMin then
                    SFX.play{sound = yoshi.generalSettings.starCounterFastBeepingSound,delay = 48}
                elseif data.starCounter <= yoshi.generalSettings.starCounterMin*2 then
                    SFX.play{sound = yoshi.generalSettings.starCounterSlowBeepingSound,delay = 96}
                end
            end
        elseif data.starCounter < yoshi.generalSettings.starCounterMin then
            data.starCounterTimer = data.starCounterTimer + 1

            if data.starCounterTimer >= yoshi.generalSettings.starCounterIncreaseTime then
                data.starCounter = data.starCounter + 1
                data.starCounterTimer = 0

                if data.starCounter >= yoshi.generalSettings.starCounterMin then
                    SFX.play(yoshi.generalSettings.starCounterReplenishedSound)
                end
            end
        end
    end

    local function handleStarCounterOnDraw()
        if data.starCounterState == STAR_COUNTER_STATE.CHECKPOINT_BONUS then
            local interval = (data.starCounterTimer/12)

            if math.floor(interval) == interval then
                if interval >= yoshi.generalSettings.starCounterCheckpointBonus or data.starCounter >= yoshi.generalSettings.starCounterMax then
                    data.starCounterState = STAR_COUNTER_STATE.NORMAL
                    data.starCounterTimer = 0

                    gameData.savedStarsCount = data.starCounter
                    gameData.savedStarsPath = mem(FULL_PATH_ADDR,FIELD_STRING)

                    Misc.unpause()
                else
                    data.starCounter = data.starCounter + 1
                    SFX.play(yoshi.generalSettings.starCounterIncreaseSound)
                end
            end

            data.starCounterTimer = data.starCounterTimer + 1
        end
    end



    -- General stuff
    function resetHealthData()
        data.hurtState = HURT_STATE.NORMAL
        data.hurtTimer = 0

        data.deathTimer = 0


        if data.starCounter == nil then
            if gameData.savedStarsCount == nil or gameData.savedStarsPath == nil or gameData.savedStarsPath ~= mem(FULL_PATH_ADDR,FIELD_STRING)
            or mem(CHECKPOINT_PATH_ADDR,FIELD_STRING) ~= mem(FULL_PATH_ADDR,FIELD_STRING)
            or Misc.inEditor()
            then
                data.starCounter = yoshi.generalSettings.starCounterMin
                gameData.savedStarsCount = nil
                gameData.savedStarsPath = nil
            else
                data.starCounter = gameData.savedStarsCount
            end
        end

        data.starCounterState = STAR_COUNTER_STATE.NORMAL
        data.starCounterTimer = 0


        data.babyMario = data.babyMario or {}

        resetBaby()
    end

    function handleHealth()
        -- Handle being hit
        if p.forcedState == FORCEDSTATE_POWERDOWN_SMALL then
            p.forcedState = FORCEDSTATE_NONE
            p.forcedTimer = 0
            
            if (p:mem(0x148,FIELD_WORD) == 0 or p:mem(0x14C,FIELD_WORD) == 0) and (p:mem(0x146,FIELD_WORD) == 0 or p:mem(0x14A,FIELD_WORD) == 0) then -- not being crushed
                p:mem(0x140,FIELD_WORD,150)

                if canBeInHurtState() then
                    if yoshi.generalSettings.healthSystem ~= HEALTH_SYSTEM.BABY_MARIO or data.babyMario.state == BABY_STATE.NORMAL then
                        data.hurtState = HURT_STATE.HIT_BACK
                        data.hurtTimer = 0

                        p.speedX = -2*p.direction
                        p.speedY = -5
                    else
                        data.hurtState = HURT_STATE.SPIN
                        data.hurtTimer = 0

                        p.speedX = -6*p.direction
                        p.speedY = -3
                    end

                    p:mem(0x11C,FIELD_WORD,0)
                end

                if yoshi.generalSettings.healthSystem == HEALTH_SYSTEM.BABY_MARIO then
                    yoshi.loseBaby()
                else
                    p:mem(0x16,FIELD_WORD,p:mem(0x16,FIELD_WORD)-1)                     
                end
            else
                p:kill()
            end
        end

        handleHurtState()

        if yoshi.generalSettings.healthSystem == HEALTH_SYSTEM.BABY_MARIO then
            p.powerup = PLAYER_BIG
            p:mem(0x16,FIELD_WORD,2)

            handleBaby()
            handleStarCounter()
        else
            if p:mem(0x16,FIELD_WORD) <= 1 then
                p.powerup = PLAYER_SMALL
            else
                p.powerup = PLAYER_BIG
            end
        end

        if p.deathTimer > 0 then
            if data.deathTimer < 380 then
                p.deathTimer = math.min(198,p.deathTimer)
            end

            if data.deathTimer >= 300 then
                yoshi.highPriorityFadeIn = math.max(0,yoshi.highPriorityFadeIn - 0.02)
            elseif data.deathTimer >= 150 then
                yoshi.highPriorityFadeIn = math.min(1,yoshi.highPriorityFadeIn + 0.1)
            end

            if data.deathTimer >= 170 then
                if yoshi.curveTransitionMax < 1 then
                    yoshi.curveTransitionMax = math.min(1,yoshi.curveTransitionMax + 0.025)
                else
                    yoshi.curveTransitionMin = math.min(1,yoshi.curveTransitionMin + 0.035)
                end
            end

            data.deathTimer = data.deathTimer + 1
        else
            data.deathTimer = 0
        end
    end

    function handleHealthOnDraw()
        if yoshi.generalSettings.healthSystem == HEALTH_SYSTEM.BABY_MARIO then
            handleBabyOnDraw()
            handleStarCounterOnDraw()
        end
    end


    function yoshi.setHealthSystem(newSystem,instant)
        local oldSystem = yoshi.generalSettings.healthSystem

        if newSystem == oldSystem then
            return
        end

        if not instant then
            if oldSystem == HEALTH_SYSTEM.BABY_MARIO then
                SFX.play(yoshi.generalSettings.babyPopBubbleSound)

                local x = p.x + p.width*0.5 + (yoshi.generalSettings.babyMarioOffset.x + data.babyMario.x)*p.direction
                local y = p.y + p.height    + (yoshi.generalSettings.babyMarioOffset.y + data.babyMario.y) - 32

                Effect.spawn(yoshi.generalSettings.popEffectID,x,y)
            elseif newSystem == HEALTH_SYSTEM.BABY_MARIO then
                SFX.play(yoshi.generalSettings.starCounterReplenishedSound)
            end
        end

        resetBaby()

        yoshi.generalSettings.healthSystem = newSystem

        initHUD()
    end

    function yoshi.giveStarPoint(amount,x,y)
        SFX.play(yoshi.generalSettings.starCounterIncreaseSound)

        if yoshi.generalSettings.healthSystem ~= HEALTH_SYSTEM.BABY_MARIO then
            return
        end

        amount = amount or 1

        data.starCounter = math.min(yoshi.generalSettings.starCounterMax,data.starCounter + amount)

        -- Spawn effect
        local e = Effect.spawn(yoshi.generalSettings.starEffectID,x or p.x + p.width*0.5,y or p.y + p.height*0.5,amount)

        e.x = e.x - e.width *0.5
        e.y = e.y - e.height*0.5
    end
end


-- Toadies
local handleToadies
local drawToadies

do
    yoshi.toadies = {}

    local toadyCount = 4

    toadiesFormation = {
        vector(-32,-28),vector(32,-28),vector(-16,-12),vector(16,-12),
    }

    function summonToadies()
        for i = 1, toadyCount do
            local obj = {}

            obj.x = data.babyMario.x
            obj.y = math.min(data.babyMario.y-96,camera.y)

            if i <= toadyCount*0.5 then
                obj.x = obj.x - (i - toadyCount*0.5 - 1) * 64
                obj.direction = DIR_RIGHT
            else
                obj.x = obj.x - (i - toadyCount*0.5) * 64
                obj.direction = DIR_LEFT
            end

            --obj.speedX = obj.direction * 4
            obj.speedX = 0
            obj.speedY = 4

            obj.timer = 0

            obj.groupIndex = i

            obj.collider = Colliders.Box(0,0,32,32)

            table.insert(yoshi.toadies,obj)
        end
    end

    function handleToadies()
        local babyData = data.babyMario

        for i = #yoshi.toadies, 1, -1 do
            local obj = yoshi.toadies[i]

            obj.collider.x = obj.x - obj.collider.width*0.5
            obj.collider.y = obj.y - obj.collider.height

            local shouldDelete = false
            local goalX,goalY

            if babyData.state == BABY_STATE.BUBBLE then
                if obj.collider:collide(babyData.collider) then
                    babyData.state = BABY_STATE.KIDNAPPED
                    babyData.timer = 0

                    babyData.bubbleFrame = 0
                    
                    SFX.play(yoshi.generalSettings.babyPopBubbleSound)

                    -- Make all the toadies stop
                    for _,otherObj in ipairs(yoshi.toadies) do
                        otherObj.speedX = 0
                        otherObj.speedY = 0
                    end
                else
                    goalX = babyData.x
                    goalY = babyData.y
                end
            elseif babyData.state == BABY_STATE.KIDNAPPED then
                goalX = babyData.x + toadiesFormation[obj.groupIndex].x
                goalY = babyData.y + toadiesFormation[obj.groupIndex].y

                if math.abs(goalX-obj.x) <= math.abs(obj.speedX*2)+1 then
                    obj.x = goalX
                    obj.speedX = 0

                    goalX = nil

                    obj.direction = math.sign(toadiesFormation[obj.groupIndex].x)
                end

                if math.abs(goalY-obj.y) <= math.abs(obj.speedY*2)+1 then
                    obj.y = goalY
                    obj.speedY = 0

                    goalY = nil
                end
            elseif babyData.state ~= BABY_STATE.CARRIED_OFF then
                obj.speedX = obj.speedX * 0.95
                obj.speedY = obj.speedY - 0.25

                shouldDelete = shouldDelete or (obj.y <= camera.y-64)
            end


            if goalX ~= nil then
                if obj.x > goalX then
                    obj.speedX = math.max(-5,obj.speedX - 0.05)
                elseif obj.x < goalX then
                    obj.speedX = math.min(5,obj.speedX + 0.05)
                end

                if obj.speedX ~= 0 then
                    obj.direction = math.sign(obj.speedX)
                end
            end
            if goalY ~= nil then
                if obj.y > goalY then
                    obj.speedY = math.max(-5,obj.speedY - 0.05)
                elseif obj.y < goalY then
                    obj.speedY = math.min(5,obj.speedY + 0.05)
                end
            end

            obj.x = obj.x + obj.speedX
            obj.y = obj.y + obj.speedY

            obj.timer = obj.timer + 1


            if shouldDelete then
                table.remove(yoshi.toadies,i)
            end
        end
    end

    function drawToadies()
        for _,obj in ipairs(yoshi.toadies) do
            local toadyFrames = yoshi.generalSettings.toadyFrames

            if obj.sprite == nil then
                obj.sprite = Sprite{texture = yoshi.generalSettings.toadyImage,frames = toadyFrames,pivot = Sprite.align.BOTTOM}
            end


            local frame = (math.floor(obj.timer/4) % ((toadyFrames*2) - 2)) + 1
            if frame >= toadyFrames then
                frame = toadyFrames-(frame-toadyFrames)
            end

            obj.sprite.x = obj.x
            obj.sprite.y = obj.y

            obj.sprite.width = obj.sprite.texture.width * -obj.direction
            obj.sprite.texpivot = vector((obj.direction == DIR_LEFT and 0) or 1,0)

            obj.sprite:draw{frame = frame,priority = -4,sceneCoords = true}
        end
    end
end



-- Custom water movement
local handleWaterMovement
local canUseWaterMovement
local resetWaterMovementData

do
    function canUseWaterMovement()
        return (
            (p:mem(0x34,FIELD_WORD) > 0 and p:mem(0x06,FIELD_WORD) == 0)
            and p.mount == MOUNT_NONE
        )
    end


    local function increaseMaxSpeed()
        -- water physics are wack
        Defines.player_walkspeed = 1000
        Defines.player_runspeed = 1000

        data.waterIncreasedMaxSpeed = true
    end

    local function resetMaxSpeed()
        if data.waterIncreasedMaxSpeed then
            setMaxSpeed()
        end
        data.waterIncreasedMaxSpeed = false
    end


    function resetWaterMovementData()
        resetMaxSpeed()
    end


    local function handleMovement(speed,negativeKey,positiveKey)
        local canUseControls = (Level.winState() == 0)

        if p.keys[negativeKey] and canUseControls then
            p[speed] = math.max(-yoshi.waterSettings.maxSpeed,p[speed] - yoshi.waterSettings.acceleration)

            if speed == "speedY" then
                p:mem(0x176,FIELD_WORD,0) -- reset stood on NPC
            end
        elseif p.keys[positiveKey] and canUseControls then
            p[speed] = math.min(yoshi.waterSettings.maxSpeed,p[speed] + yoshi.waterSettings.acceleration)
        elseif p[speed] > 0 then
            p[speed] = math.max(0,p[speed] - yoshi.waterSettings.deceleration)
        elseif p[speed] < 0 then
            p[speed] = math.min(0,p[speed] + yoshi.waterSettings.deceleration)
        end
    end

    function handleWaterMovement()
        if not canUseWaterMovement() then
            resetWaterMovementData()
            return
        end

        p:mem(0x38,FIELD_WORD,2) -- stop stroking



        handleMovement("speedY","up","down")

        if not p:isOnGround() then
            handleMovement("speedX","left","right")
            p.keys.down = false -- disable ducking

            increaseMaxSpeed()
        else
            resetMaxSpeed()
        end

        p.speedY = p.speedY + 0.0001

        --p.keys.left = false
        --p.keys.right = false
    end
end


-- Flutter jump
local handleFlutterJump
local canUseFlutterJump
local resetFlutterJump

do
    function canUseFlutterJump()
        return (
            not isOnGroundRedigit()
            and p:mem(0x34,FIELD_WORD) == 0 -- underwater
            
            and (p.mount ~= MOUNT_BOOT or p.mountColor ~= BOOTCOLOR_BLUE)
            and p.mount ~= MOUNT_CLOWNCAR
            and (p.mount ~= MOUNT_BOOT or p:mem(0x10C,FIELD_WORD) == 0) -- hopping in a boot

            and data.groundPoundState == GROUND_POUND_STATE.INACTIVE
        )
    end

    local function canContinueFlutterJump()
        return (
            not p:mem(0x12E,FIELD_BOOL) -- ducking
            and data.hurtState == HURT_STATE.NORMAL
        )
    end

    local function canJump()
        return (
            isOnGroundRedigit()
            or (p.mount == MOUNT_BOOT and p:mem(0x10C,FIELD_WORD) > 0) -- hopping in a boot
            or player:mem(0x1C, FIELD_WORD, -1)
        )
    end


    local function endFlutter()
        data.flutterTimer = 0
        data.flutterCooldown = yoshi.flutterSettings.cooldownTime

        data.flutterSoundTimer = 0

        data.flutteredThisJump = true
        data.nextFlutterIsLong = false
    end


    function resetFlutterJump()
        data.flutterTimer = 0
        data.flutterCooldown = 0

        data.flutterSoundTimer = 0

        data.flutteredThisJump = false
        data.nextFlutterIsLong = false

        data.oldJumpForce = p:mem(0x11C,FIELD_WORD)
        data.wasOnGround = canJump()
    end


    function handleFlutterJump()
        if not canUseFlutterJump() then
            resetFlutterJump()
            return
        end


        -- Handle the big flutter after stomping on an enemy
        if p:mem(0x11C,FIELD_WORD) > data.oldJumpForce and not data.wasOnGround then
            data.nextFlutterIsLong = true
            data.flutteredThisJump = false
        end

        data.oldJumpForce = p:mem(0x11C,FIELD_WORD)
        data.wasOnGround = canJump()



        if canContinueFlutterJump() and p.speedY > yoshi.flutterSettings.minSpeedYToStart and data.flutterTimer == 0 and data.flutterCooldown == 0 and (not data.flutteredThisJump and p.keys.jump or data.flutteredThisJump and p.keys.jump == KEYS_PRESSED) and Level.winState() == 0 then
            data.flutterTimer = 1
            p.speedY = yoshi.flutterSettings.minSpeedYToStart
            p:mem(0x11C,FIELD_WORD,0)
        end

        if data.flutterTimer > 0 and canContinueFlutterJump() then
            p.speedY = p.speedY - yoshi.flutterSettings.speedYDecrease

            data.flutterTimer = data.flutterTimer + 1

            if (not data.nextFlutterIsLong and data.flutterTimer > yoshi.flutterSettings.activeTime) or (data.nextFlutterIsLong and data.flutterTimer > yoshi.flutterSettings.longActiveTime) or not p.keys.jump or Level.winState() ~= 0 or p:mem(0x11C,FIELD_WORD) > 0 then
                endFlutter()
            end
            
            if (SaveData.SMASPlusPlus.player[1].currentCostume == "SMA3") then
                SFX.play(Misc.resolveSoundFile("costumes/ninjabomberman/SMA3/SFX/flutter.ogg"), 1, 1, 45)
            end


            data.flutterSoundTimer = data.flutterSoundTimer + 1

            if data.flutterSoundTimer >= yoshi.flutterSettings.soundDelay then
                data.flutterSoundTimer = data.flutterSoundTimer % yoshi.flutterSettings.soundDelay
                
                if data.flutterSound ~= nil and data.flutterSound:isPlaying() then
                    data.flutterSound:stop()
                end
                data.flutterSound = SFX.play{sound = yoshi.flutterSettings.sound}
            end
        elseif data.flutterTimer > 0 then
            endFlutter()
        end

        data.flutterCooldown = math.max(0,data.flutterCooldown - 1)
    end
end


-- Tongue
local resetTongueData
local handleTongue
local canUseTongue

local manageTongueNPC

local handleFollowingEggs
local drawFollowingEggs

do
    TONGUE_STATE = {
        INACTIVE = 0,

        EXTEND = 1,
        STAY = 2,
        RETRACT = 3,

        STOPPED_BLOCK = 4,
        STOPPED_NPC = 5,


        CREATING_EGG = 6,
        START_AIM = 7,
        AIMING = 8,
    }

    NPC_TONGUE_BEHAVIOUR = {
        DEFAULT = -1, -- based on noyoshi and other config flags

        EDIBLE = 0,
        PASSES_THROUGH = 1,
        STOP = 2,
        NO_EGG = 3,
        INSTANT_SWALLOW = 4,
        BIG_EGG = 5,
        MELON = 6,
    }




    --[[

        The yoshitonguebehaviour config:
        0: edible, can be turned into egg
        1: tongue goes through
        2: stops tongue
        3: edible, cannot be turned into egg
        4: edible, instantly swallowed
        5: edible, creates big egg
        6: melon
        -1: default to one of the above, based on other settings such as noyoshi

        The yoshitonguetransform config:
        If not zero, the NPC will change its ID to this value when tongued.

        If it's a melon, there's also:
        - yoshimelonid
        - yoshimelonspeedx
        - yoshimelonspeedy
        - yoshimelonsound
        - yoshimeloncooldown
        - yoshimeloncanhold
        - yoshimelonshots

    ]]


    for id = 1, NPC_MAX_ID do
        local config = NPC.config[id]

        config:setDefaultProperty("yoshitonguebehaviour",NPC_TONGUE_BEHAVIOUR.DEFAULT)
        config:setDefaultProperty("yoshitonguetransform",0)
    end


    -- Billy gun but melon
    do
        local billyGunConfig = NPC.config[22]
        
        billyGunConfig:setDefaultProperty("yoshitonguebehaviour",NPC_TONGUE_BEHAVIOUR.MELON)
        billyGunConfig:setDefaultProperty("yoshimelonid",17)
        billyGunConfig:setDefaultProperty("yoshimelonspeedx",8)
        billyGunConfig:setDefaultProperty("yoshimelonshots",-1)
        billyGunConfig:setDefaultProperty("yoshimeloncanhold",true)
        billyGunConfig:setDefaultProperty("yoshimeloncooldown",16)
        billyGunConfig:setDefaultProperty("yoshimelonsound",22)
    end


    local npcTongueBehaviourSpecialCases = {
        [47]  = NPC_TONGUE_BEHAVIOUR.INSTANT_SWALLOW, -- smb3 lakitu
        [74]  = NPC_TONGUE_BEHAVIOUR.BIG_EGG,         -- giant piranha plant
        [91]  = NPC_TONGUE_BEHAVIOUR.PASSES_THROUGH,  -- smb2 grass container
        [159] = NPC_TONGUE_BEHAVIOUR.INSTANT_SWALLOW, -- smb2 diggable sand
        [168] = NPC_TONGUE_BEHAVIOUR.STOP,            -- bully
        [190] = NPC_TONGUE_BEHAVIOUR.PASSES_THROUGH,  -- bone lift
        [194] = NPC_TONGUE_BEHAVIOUR.NO_EGG,          -- rainbow shell
        [207] = NPC_TONGUE_BEHAVIOUR.STOP,            -- spiketop
        [246] = NPC_TONGUE_BEHAVIOUR.PASSES_THROUGH,  -- fireball
        [284] = NPC_TONGUE_BEHAVIOUR.INSTANT_SWALLOW, -- smw lakitu
        [288] = NPC_TONGUE_BEHAVIOUR.NO_EGG,          -- subspace potion
        [350] = NPC_TONGUE_BEHAVIOUR.INSTANT_SWALLOW, -- trouter
        [352] = NPC_TONGUE_BEHAVIOUR.INSTANT_SWALLOW, -- fry guy's little versions
        [358] = NPC_TONGUE_BEHAVIOUR.STOP,            -- smw hopping flame
        [359] = NPC_TONGUE_BEHAVIOUR.PASSES_THROUGH,  -- smw hopping flame's trail
        [379] = NPC_TONGUE_BEHAVIOUR.NO_EGG,          -- green shoe goomba
        [392] = NPC_TONGUE_BEHAVIOUR.NO_EGG,          -- blue show goomba
        [393] = NPC_TONGUE_BEHAVIOUR.NO_EGG,          -- red shoe goomba
        [390] = NPC_TONGUE_BEHAVIOUR.PASSES_THROUGH,  -- fire bro fireball
        [395] = NPC_TONGUE_BEHAVIOUR.INSTANT_SWALLOW, -- rocky wrenches
        [401] = NPC_TONGUE_BEHAVIOUR.INSTANT_SWALLOW, -- foo
        [427] = NPC_TONGUE_BEHAVIOUR.EDIBLE,          -- megan (because megan)
        [428] = NPC_TONGUE_BEHAVIOUR.STOP,            -- king bill
        [429] = NPC_TONGUE_BEHAVIOUR.STOP,            -- king bill
        [446] = NPC_TONGUE_BEHAVIOUR.STOP,            -- wiggler
        [448] = NPC_TONGUE_BEHAVIOUR.STOP,            -- angry wiggler
        [465] = NPC_TONGUE_BEHAVIOUR.PASSES_THROUGH,  -- collectable trigger
        [466] = NPC_TONGUE_BEHAVIOUR.BIG_EGG,         -- sorta big smb goomba
        [492] = NPC_TONGUE_BEHAVIOUR.STOP,            -- graf
        [493] = NPC_TONGUE_BEHAVIOUR.STOP,            -- van de graf
        [509] = NPC_TONGUE_BEHAVIOUR.INSTANT_SWALLOW, -- hanging scuttblebug
        [562] = NPC_TONGUE_BEHAVIOUR.NO_EGG,          -- springhatter
        [563] = NPC_TONGUE_BEHAVIOUR.NO_EGG,          -- spikehatter
        [610] = NPC_TONGUE_BEHAVIOUR.INSTANT_SWALLOW, -- smb lakitu

        -- the npc's that should really have noyoshi but just don't
        [199] = NPC_TONGUE_BEHAVIOUR.STOP,           -- blargg
        [210] = NPC_TONGUE_BEHAVIOUR.PASSES_THROUGH, -- rinkas
        [262] = NPC_TONGUE_BEHAVIOUR.STOP,           -- mouser
        [289] = NPC_TONGUE_BEHAVIOUR.PASSES_THROUGH, -- subspace door
        [344] = NPC_TONGUE_BEHAVIOUR.STOP,           -- snake block (think this'll be fixed later)
        [473] = NPC_TONGUE_BEHAVIOUR.STOP,           -- waddle doo beam (tbf this is actually quite a fun interaction, but it's janky with this yoshi)
        [553] = NPC_TONGUE_BEHAVIOUR.PASSES_THROUGH, -- mutant vine head (think this'll be fixed later)
        [555] = NPC_TONGUE_BEHAVIOUR.PASSES_THROUGH, -- mutant vine head (think this'll be fixed later)
    }
    
    function yoshi.getNPCTongueBehaviour(npc)
        local id = (type(npc) == "number" and npc) or npc.id

        local config = NPC.config[id]
        if config == nil then
            return NPC_TONGUE_BEHAVIOUR.PASSES_THROUGH
        end

        local behaviour = config.yoshitonguebehaviour

        if behaviour ~= NPC_TONGUE_BEHAVIOUR.DEFAULT then
            return behaviour
        end


        if npcTongueBehaviourSpecialCases[id] ~= nil then
            return npcTongueBehaviourSpecialCases[id]
        end


        if config.noyoshi then
            if (not config.nohurt and not config.isinteractable) or config.playerblock then
                return NPC_TONGUE_BEHAVIOUR.STOP
            else
                return NPC_TONGUE_BEHAVIOUR.PASSES_THROUGH
            end
        end

        if config.isshell or (config.grabside and not config.isvegetable) then
            return NPC_TONGUE_BEHAVIOUR.NO_EGG
        end

        if config.iscoin then
            if type(npc) == "NPC" and npc.ai1 > 0 then
                return NPC_TONGUE_BEHAVIOUR.INSTANT_SWALLOW
            else
                return NPC_TONGUE_BEHAVIOUR.PASSES_THROUGH
            end
        end

        if config.isinteractable then
            return NPC_TONGUE_BEHAVIOUR.INSTANT_SWALLOW
        end

        if config.isheavy then
            return NPC_TONGUE_BEHAVIOUR.BIG_EGG
        end

        return NPC_TONGUE_BEHAVIOUR.EDIBLE
    end


    local npcTongueTransformSpecialCases = {
        -- Koopas ---> shells
        [4]   = 5,   -- smb3 green koopa
        [76]  = 5,   -- smb3 green parakoopa
        [6]   = 7,   -- smb3 red koopa
        [161] = 7,   -- smb3 red parakoopa
        [72]  = 73,  -- giant smb3 koopa
        [23]  = 24,  -- smb3 buzzy beetle

        [109] = 113, -- smw green koopa
        [121] = 113, -- smw green parakoopa
        [110] = 114, -- smw red koopa
        [122] = 114, -- smw red parakoopa
        [111] = 115, -- smw blue koopa
        [123] = 115, -- smw blue parakoopa
        [112] = 116, -- smw yellow koopa
        [124] = 116, -- smw yellow parakoopa

        [173] = 172, -- smb green koopa
        [176] = 172, -- smb green parakoopa
        [175] = 174, -- smb red koopa
        [177] = 174, -- smb red koopa

        [578] = 579, -- bombshell koopa

        -- Winged enemies losing their wings
        [244] = 1,   -- smb3 paragoomba
        [3]   = 2,   -- smb3 red paragoomba
        [243] = 242, -- sml2 paragoomba
        [380] = 285, -- winged spiny

        -- Others
        [136] = 137, -- smb3 bob-omb
        [408] = 409, -- smw bob-omb
        [165] = 166, -- galoomba
        [167] = 166, -- paragaloomba
        [371] = 372, -- hiding cobrat
        [373] = 372, -- pipe cobrat

        -- NOTE: podoboo transforms are done via npc-952's file.
    }

    function yoshi.getNPCTongueTransformID(npc)
        local id = (type(npc) == "number" and npc) or npc.id

        local config = NPC.config[id]
        if config == nil then
            return 0
        end

        local transform = config.yoshitonguetransform

        if transform ~= 0 then
            return transform
        end

        if npcTongueTransformSpecialCases[id] ~= nil then
            return npcTongueTransformSpecialCases[id]
        end

        return 0
    end


    local function tongueNPCFilter(v)
        return (
            v.isValid
            and v.despawnTimer > 0
            and not v.isHidden
            and not v.isGenerator
            and (data.tongueNPC == v or (v:mem(0x138,FIELD_WORD) == 0 and not v.friendly))
        )
    end


    local function updateTongueColliders()
        local totalCol = data.tongueTotalCollider
        local tipCol = data.tongueTipCollider
        local tipExtraCol = data.tongueTipExtraCollider

        tipCol.width = yoshi.tongueSettings.hitboxWidth
        tipCol.height = yoshi.tongueSettings.hitboxHeight

        if data.tongueVertical then
            tipCol.x = p.x + p.width*0.5 + yoshi.tongueSettings.verticalOffsetX*p.direction - tipCol.width*0.5
            tipCol.y = p.y + p.height + yoshi.tongueSettings.verticalOffsetY - data.tongueLength

            totalCol.width = yoshi.tongueSettings.hitboxWidth
            totalCol.height = data.tongueLength
            totalCol.x = p.x + p.width*0.5 + yoshi.tongueSettings.verticalOffsetX*p.direction - totalCol.width*0.5
            totalCol.y = p.y + p.height + yoshi.tongueSettings.verticalOffsetY - totalCol.height

            tipExtraCol.x = tipCol.x
            tipExtraCol.y = tipCol.y
            tipExtraCol.width = tipCol.width
            tipExtraCol.height = tipCol.height
        else
            tipCol.x = p.x + p.width*0.5 + (yoshi.tongueSettings.horizontalOffsetX + data.tongueLength)*p.direction
            tipCol.y = p.y + p.height + yoshi.tongueSettings.horizontalOffsetY - tipCol.height*0.5

            totalCol.width = data.tongueLength
            totalCol.height = yoshi.tongueSettings.hitboxHeight
            totalCol.x = p.x + p.width*0.5 + yoshi.tongueSettings.horizontalOffsetX*p.direction
            totalCol.y = p.y + p.height + yoshi.tongueSettings.horizontalOffsetY - totalCol.height*0.5

            if p.direction == DIR_RIGHT then
                tipCol.x = tipCol.x - tipCol.width
            else
                totalCol.x = totalCol.x - totalCol.width
            end

            -- Used for smb2 grass
            tipExtraCol.x = tipCol.x
            tipExtraCol.y = tipCol.y
            tipExtraCol.width = tipCol.width
            tipExtraCol.height = tipCol.height+16
        end

        --totalCol:Draw(Color.purple.. 0.5)
        --tipExtraCol:Draw(Color.green.. 0.5)
        --tipCol:Draw(Color.yellow.. 0.5)
    end


    local function putNPCOnTongue(npc)
        -- Special case for bubbles: pop!
        if npc.id == 283 then
            SFX.play(91)

            if npc.ai1 > 0 then
                npc:transform(npc.ai1)

                local newBehaviour = yoshi.getNPCTongueBehaviour(npc.id)

                if newBehaviour == NPC_TONGUE_BEHAVIOUR.PASSES_THROUGH or newBehaviour == NPC_TONGUE_BEHAVIOUR.STOP then
                    return
                end
            else
                npc:kill(HARM_TYPE_VANISH)
                return
            end
        end

        -- Special case for grass: turn into its contained NPC
        if npc.id == 91 then
            local transformID = npc.ai1
            local newAI1 = 0

            if transformID == 0 or transformID == 147 then -- random vegetable
                transformID = RNG.randomInt(139,146)
            end

            if NPC.config[transformID].isyoshi then -- yoshi turns into egg
                newAI1 = transformID
                transformID = 96
            end

            npc:transform(transformID)

            npc.ai1 = newAI1
        end
        
        -- Special case for keys: set link's "has key" flag
        if npc.id == 31 then
            p:mem(0x12,FIELD_BOOL,true)
        end


        data.tongueNPC = npc

        local transform = yoshi.getNPCTongueTransformID(npc)

        if transform > 0 and transform ~= npc.id then
            npc:transform(transform)
        end

        npc.width = NPC.config[npc.id].width
        npc.height = NPC.config[npc.id].height


        data.melonShotsMade = 0


        -- Special case for waddle doos: remove beam
        if npc.id == 472 then
            local npcData = npc.data._basegame

            for i=#npcData.sparkList, 1, -1 do
                if npcData.sparkList[i].isValid then
                    npcData.sparkList[i]:kill()
                end
            end
            npcData.sparkList = {}

            if npcData.sound and npcData.sound.isValid and npcData.sound:isPlaying() then
                npcData.sound:Stop()
            end
            npcData.sound = nil
        end


        data.tongueNPC:mem(0x138,FIELD_WORD,5)
        data.tongueNPC:mem(0x13C,FIELD_DFLOAT,1)
        data.tongueNPC:mem(0x144,FIELD_WORD,5)


        manageTongueNPC()
    end


    local function doTongueChecks()
        updateTongueColliders()

        -- Check for NPC's
        if (data.tongueState == TONGUE_STATE.EXTEND or data.tongueState == TONGUE_STATE.STAY or data.tongueState == TONGUE_STATE.RETRACT) and (data.tongueNPC == nil or not tongueNPCFilter(data.tongueNPC)) then
            -- Check for Baby Mario
            if yoshi.generalSettings.healthSystem == HEALTH_SYSTEM.BABY_MARIO and data.babyMario.state == BABY_STATE.BUBBLE and data.tongueTipCollider:collide(data.babyMario.collider) then
                yoshi.rescueBaby()

                data.tongueState = TONGUE_STATE.STAY
                data.tongueTimer = 0

                return true
            end

            
            local npcs = Colliders.getColliding{a = data.tongueTipCollider,btype = Colliders.NPC,filter = tongueNPCFilter}

            for _,npc in ipairs(npcs) do
                local behaviour = yoshi.getNPCTongueBehaviour(npc)

                if behaviour == NPC_TONGUE_BEHAVIOUR.STOP then
                    if data.tongueState == TONGUE_STATE.EXTEND then
                        data.tongueState = TONGUE_STATE.STOPPED_NPC
                        data.tongueTimer = 0

                        if data.tongueSound ~= nil and data.tongueSound:isPlaying() then
                            data.tongueSound:stop()
                        end
                        SFX.play(yoshi.tongueSettings.failedSound)

                        return true
                    end
                elseif behaviour ~= NPC_TONGUE_BEHAVIOUR.PASSES_THROUGH then
                    putNPCOnTongue(npc)

                    data.tongueState = TONGUE_STATE.STAY
                    data.tongueTimer = 0

                    return true
                end
            end

            -- Handle the smb2 grass container
            local grass = Colliders.getColliding{a = data.tongueTipExtraCollider,btype = Colliders.NPC,b = 91,filter = tongueNPCFilter}

            for _,npc in ipairs(grass) do
                putNPCOnTongue(npc)

                data.tongueState = TONGUE_STATE.STAY
                data.tongueTimer = 0

                return true
            end
        end

        -- Check for blocks
        if data.tongueState == TONGUE_STATE.EXTEND then
            local blocks = Colliders.getColliding{a = data.tongueTotalCollider,b = Block.SOLID,btype = Colliders.BLOCK}

            for _,block in ipairs(blocks) do
                data.tongueState = TONGUE_STATE.STOPPED_BLOCK
                data.tongueTimer = 0

                return true
            end
        end

        return false
    end


    function yoshi.spitOutNPC()
        if data.tongueNPC == nil or not tongueNPCFilter(data.tongueNPC) then
            return
        end

        manageTongueNPC()


        data.justSpit = true

        data.tongueNPC.x = p.x + p.width *0.5 - data.tongueNPC.width*0.5 + yoshi.tongueSettings.spitOffsetX*p.direction
        data.tongueNPC.y = p.y + p.height - data.tongueNPC.height

        if p:mem(0x12E,FIELD_BOOL) then
            data.tongueNPC.y = data.tongueNPC.y + yoshi.tongueSettings.spitOffsetYDucking
        else
            data.tongueNPC.y = data.tongueNPC.y + yoshi.tongueSettings.spitOffsetY
        end

        
        if p:mem(0x12E,FIELD_BOOL) and isOnGroundRedigit() then
            data.tongueNPC.speedX = 0
            data.tongueNPC.speedY = 0
        else
            if p.keys.up then
                data.tongueNPC.speedX = yoshi.tongueSettings.spitSpeedXVertical*p.direction
                data.tongueNPC.speedY = yoshi.tongueSettings.spitSpeedYVertical
            else
                data.tongueNPC.speedX = yoshi.tongueSettings.spitSpeedXHorizontal*p.direction
                data.tongueNPC.speedY = yoshi.tongueSettings.spitSpeedYHorizontal
            end

            if NPC.config[data.tongueNPC.id].isshell then
                data.tongueNPC.speedX = 7.1 * p.direction
            end

            -- Special case for SMB2 bob-omb: explode!
            if data.tongueNPC.id == 135 then
                data.tongueNPC.ai1 = 530
            end
        end
        
        if data.tongueNPC.id == 159 then
            data.tongueNPC.ai2 = 450
        end
        
        -- Special case for throwable brick: enter thrown state
        if data.tongueNPC.id == 45 then
            data.tongueNPC.ai1 = 1
        end


        data.tongueNPC:mem(0x18,FIELD_FLOAT,0) -- "real" speed x

        data.tongueNPC:mem(0x138,FIELD_WORD,0)
        data.tongueNPC:mem(0x13C,FIELD_DFLOAT,0)
        data.tongueNPC:mem(0x144,FIELD_WORD,0)

        data.tongueNPC.animationFrame = 0
        data.tongueNPC.animationTimer = 0

        data.tongueNPC.friendly = false

        data.tongueNPC = nil
        p:mem(0x12,FIELD_BOOL,false)

        SFX.play(yoshi.tongueSettings.spitSound)
        if (SaveData.SMASPlusPlus.player[1].currentCostume == "SMA3") then
            Sound.playSFX("ninjabomberman/SMA3/SFX/spit-out.ogg")
        end
    end


    function yoshi.swallowNPC()
        if NPC.config[data.tongueNPC.id].isinteractable then -- collect collectable things
            data.tongueNPC:mem(0x138,FIELD_WORD,0)
            data.tongueNPC:mem(0x13C,FIELD_DFLOAT,0)
            data.tongueNPC:mem(0x144,FIELD_WORD,0)

            data.tongueNPC:mem(0x12E,FIELD_WORD,0)
            data.tongueNPC:mem(0x130,FIELD_WORD,0)
            data.tongueNPC:mem(0x136,FIELD_BOOL,false)
        else -- everything else just dies
            data.tongueNPC:kill(HARM_TYPE_VANISH)
        end

        data.justSwallowed = true
        SFX.play(yoshi.tongueSettings.swallowSound)

        data.tongueNPC.friendly = false

        data.tongueNPC = nil
        p:mem(0x12,FIELD_BOOL,false)
    end


    local function doBigEggMobilityEffects()
        p.keys.left = false
        p.keys.right = false
        p.keys.jump = false

        p.speedX = p.speedX * 0.95
    end


    function canUseTongue()
        return (
            yoshi.tongueSettings.enabled
            and data.hurtState == HURT_STATE.NORMAL
            and p.mount == MOUNT_NONE
            and data.groundPoundState == GROUND_POUND_STATE.INACTIVE
        )
    end

    local function canAim()
        return (
            (p:mem(0x34,FIELD_WORD) == 0 or p:mem(0x06,FIELD_WORD) > 0 or isOnGroundRedigit())
            and Level.winState() == 0
        )
    end

    
    local function stopAimSound()
        if data.aimingSound ~= nil and data.aimingSound:isPlaying() then
            data.aimingSound:stop()
        end
        data.aimingSound = nil
    end



    local function handleInactiveTongueState()
        if Level.winState() ~= 0 then
            return
        end


        -- Aiming with eggs
        if p.keys.altJump == KEYS_PRESSED and Level.winState() == 0 and canAim() then
            data.tongueState = TONGUE_STATE.START_AIM
            data.tongueTimer = 0

            data.tongueForceDirectiontion = p.direction

            if data.followingEggs[1] ~= nil then
                SFX.play(yoshi.tongueSettings.startAimSound)
            end

            return
        end
        
        -- Creating eggs
        if p.keys.down and (data.tongueNPC ~= nil and tongueNPCFilter(data.tongueNPC)) then
            local behaviour = yoshi.getNPCTongueBehaviour(data.tongueNPC)

            if behaviour == NPC_TONGUE_BEHAVIOUR.EDIBLE or behaviour == NPC_TONGUE_BEHAVIOUR.BIG_EGG then
                data.tongueState = TONGUE_STATE.CREATING_EGG
                data.tongueTimer = 0
                if (SaveData.SMASPlusPlus.player[1].currentCostume == "SMA3") then
                    Sound.playSFX("ninjabomberman/SMA3/SFX/swallow-sfx.ogg")
                end

                return
            end
        end

        
        -- Tongue
        if data.tongueNPC == nil or not tongueNPCFilter(data.tongueNPC) then
            if p.keys.run == KEYS_PRESSED then
                data.tongueState = TONGUE_STATE.EXTEND
                data.tongueTimer = 0

                data.tongueLength = 0

                data.tongueVertical = (not not p.keys.up)

                data.tongueForceDirectiontion = p.direction

                data.tongueSound = SFX.play(yoshi.tongueSettings.startSound)
            end
            
            return
        end


        -- Melons
        if yoshi.getNPCTongueBehaviour(data.tongueNPC) == NPC_TONGUE_BEHAVIOUR.MELON then
            local config = NPC.config[data.tongueNPC.id]

            if data.melonShotCooldown > 0 then
                if p.keys.left then
                    p.direction = DIR_LEFT
                elseif p.keys.right then
                    p.direction = DIR_RIGHT
                end

                doBigEggMobilityEffects()
                return
            end

            if p.keys.altRun == KEYS_PRESSED or (config.yoshimelonshots > 0 and data.melonShotsMade >= config.yoshimelonshots) then
                yoshi.swallowNPC()
                return
            end


            if p.keys.run and (config.yoshimeloncanhold or p.keys.run == KEYS_PRESSED) and not p:mem(0x12E,FIELD_BOOL) then
                local x = p.x + p.width*0.5 + yoshi.tongueSettings.spitOffsetX*p.direction
                local y = p.y + p.height + yoshi.tongueSettings.spitOffsetY

                local npc = NPC.spawn(config.yoshimelonid,x,y,p.section,false,true)

                npc.direction = p.direction

                npc.speedX = (config.yoshimelonspeedx or 0) * npc.direction
                npc.speedY = (config.yoshimelonspeedy or 0)


                if npc.id == 17 then -- bullet bills, they're slightly weird
                    npc:mem(0x136,FIELD_BOOL,true)
                    npc:mem(0x12E,FIELD_WORD,10000)
                    npc:mem(0x130,FIELD_WORD,p.idx)
                end


                data.melonShotCooldown = config.yoshimeloncooldown or 0
                data.melonShotCanHold = config.yoshimeloncanhold or false

                data.melonShotsMade = data.melonShotsMade + 1

                doBigEggMobilityEffects()

                if config.yoshimelonsound ~= nil then
                    SFX.play(config.yoshimelonsound)
                end

                return
            end

            return
        end


        -- Normal spitting
        if p.keys.run == KEYS_PRESSED then
            yoshi.spitOutNPC()
            return
        end
    end


    function resetTongueData()
        data.tongueState = TONGUE_STATE.INACTIVE
        data.tongueTimer = 0

        data.tongueLength = 0

        data.tongueForceDirectiontion = p.direction

        data.tongueTotalCollider = data.tongueTotalCollider or Colliders.Box(0,0,0,0)
        data.tongueTipCollider = data.tongueTipCollider or Colliders.Box(0,0,0,0)
        data.tongueTipExtraCollider = data.tongueTipExtraCollider or Colliders.Box(0,0,0,0)

        data.melonShotCooldown = 0
        data.melonShotsMade = 0
        data.melonShotCanHold = data.melonShotCanHold or false

        data.justSpit = false
        data.justSwallowed = false
        data.justThrew = false

        --data.tongueNPC = nil

        --data.tongueSound = nil


        data.aimingAngle = 0
        data.aimingDirection = 0
        data.aimingLocked = false

        stopAimSound()

        if data.followingEggs == nil then
            data.followingEggs = {}

            -- Give saved eggs
            if not Misc.inEditor() then
                for _,id in ipairs(saveData.savedEggs) do
                    yoshi.giveEgg(id)
                end
            end
        end

        if data.trail == nil then
            data.trail = {}
            data.trailIsPaused = false
            data.trailUnpausableCount = 0
            data.trailFollowsBaby = false
        end

        if data.aimingWithEgg ~= nil then
            table.insert(data.followingEggs,data.aimingWithEgg)
        end
        data.aimingWithEgg = nil
    end


    function handleTongue()
        manageTongueNPC()

        if not canUseTongue() then
            resetTongueData()
            return
        end


        data.melonShotCooldown = math.max(0,data.melonShotCooldown - 1)


        if data.tongueState == TONGUE_STATE.INACTIVE then
            handleInactiveTongueState()
        elseif data.tongueState == TONGUE_STATE.EXTEND then
            data.tongueLength = math.min(yoshi.tongueSettings.maxLength,data.tongueLength + yoshi.tongueSettings.extendSpeed)

            local changedState = doTongueChecks()

            if not changedState and data.tongueLength >= yoshi.tongueSettings.maxLength then
                data.tongueState = TONGUE_STATE.STAY
                data.tongueTimer = 0
            end
        elseif data.tongueState == TONGUE_STATE.STAY then
            data.tongueTimer = data.tongueTimer + 1

            local changedState = doTongueChecks()

            if not changedState and data.tongueTimer >= yoshi.tongueSettings.stayTime then
                data.tongueState = TONGUE_STATE.RETRACT
                data.tongueTimer = 0
            end
        elseif data.tongueState == TONGUE_STATE.RETRACT then
            data.tongueLength = math.max(0,data.tongueLength - yoshi.tongueSettings.retractSpeed)

            local changedState = doTongueChecks()

            if not changedState and data.tongueLength <= 0 then
                data.tongueState = TONGUE_STATE.INACTIVE
                data.tongueTimer = 0
            end
        elseif data.tongueState == TONGUE_STATE.STOPPED_BLOCK or data.tongueState == TONGUE_STATE.STOPPED_NPC then
            data.tongueTimer = data.tongueTimer + 1

            if data.tongueTimer >= yoshi.tongueSettings.stoppedTime then
                data.tongueState = TONGUE_STATE.RETRACT
                data.tongueTimer = 0
            end

        -- Creating an egg
        elseif data.tongueState == TONGUE_STATE.CREATING_EGG then
            data.tongueTimer = data.tongueTimer + 1

            if isOnGroundRedigit() then
                p.keys.left = false
                p.keys.right = false
                p.speedX = p.speedX * 0.925
            end

            if (data.currentAnimation == "createEgg" and data.animationFinished) or (data.tongueTimer > 1 and data.currentAnimation ~= "createEgg") then
                data.tongueState = TONGUE_STATE.INACTIVE
                data.tongueTimer = 0
            elseif (data.currentAnimation == "createEgg" and data.animationFrameIndex == 8) and (data.tongueNPC ~= nil and tongueNPCFilter(data.tongueNPC)) then
                yoshi.giveEgg(data.tongueNPC)

                SFX.play(yoshi.tongueSettings.createEggSound)

                data.tongueNPC:kill(HARM_TYPE_VANISH)
                data.tongueNPC = nil
                p:mem(0x12,FIELD_BOOL,false)
            end

        -- Aiming
        elseif data.tongueState == TONGUE_STATE.START_AIM then
            data.tongueTimer = data.tongueTimer + 1

            if (data.currentAnimation == "aimingStart" and data.animationFinished) or (data.tongueTimer > 1 and data.currentAnimation ~= "aimingStart") then
                -- Grab an egg
                if data.followingEggs[1] ~= nil then
                    data.aimingWithEgg = data.followingEggs[1]
                    table.remove(data.followingEggs,1)

                    data.aimingWithEgg.x = 0
                    data.aimingWithEgg.y = 0
                    data.aimingWithEgg.delay = 1


                    data.tongueState = TONGUE_STATE.AIMING
                    data.tongueTimer = 0

                    data.aimingAngle = yoshi.tongueSettings.eggAimMaxAngle
                    data.aimingDirection = -1
                    data.aimingLocked = false
                else
                    data.justThrew = true
                    SFX.play(yoshi.tongueSettings.failedThrowSound)

                    data.tongueState = TONGUE_STATE.INACTIVE
                    data.tongueTimer = 0
                end
            end
        elseif data.tongueState == TONGUE_STATE.AIMING then
            if not canAim() then
                resetTongueData()
                return
            end

            data.tongueTimer = data.tongueTimer + 1


            if NPC.config[data.aimingWithEgg.npcID].isBigEgg then
                doBigEggMobilityEffects()
            end


            if p.keys.altJump == KEYS_PRESSED then
                -- Create a thrown egg NPC
                local npcID = yoshi.tongueSettings.thrownEggNPCID
                local npc = NPC.spawn(npcID,p.x + p.width*0.5 + data.aimingWithEgg.x*p.direction,p.y + p.height + data.aimingWithEgg.y,p.section,false,true)

                local speed = vector(1,0):rotate(data.aimingAngle)
                speed.x = speed.x * p.direction

                if not NPC.config[data.aimingWithEgg.npcID].isBigEgg then
                    speed = speed * NPC.config[npcID].speed
                else
                    speed = speed * 6
                end


                npc.speedX = speed.x
                npc.speedY = speed.y
                npc.data.speed = speed

                npc.data.mimicID = data.aimingWithEgg.npcID


                data.aimingWithEgg = nil


                data.tongueState = TONGUE_STATE.INACTIVE
                data.tongueTimer = 0

                data.justThrew = true
                SFX.play(yoshi.tongueSettings.eggThrowSound)
            elseif p.keys.altRun == KEYS_PRESSED then
                data.aimingLocked = (not data.aimingLocked)
            elseif p.keys.run == KEYS_PRESSED then
                table.insert(data.followingEggs,data.aimingWithEgg)
                data.aimingWithEgg = nil

                data.tongueState = TONGUE_STATE.INACTIVE
                data.tongueTimer = 0

                SFX.play(yoshi.tongueSettings.cycleEggsSound)
            elseif not data.aimingLocked then
                data.aimingAngle = data.aimingAngle + data.aimingDirection*yoshi.tongueSettings.eggAimAngleChange

                if data.aimingAngle <= yoshi.tongueSettings.eggAimMinAngle then
                    data.aimingAngle = yoshi.tongueSettings.eggAimMinAngle
                    data.aimingDirection = 1
                elseif data.aimingAngle >= yoshi.tongueSettings.eggAimMaxAngle then
                    data.aimingAngle = yoshi.tongueSettings.eggAimMaxAngle
                    data.aimingDirection = -1
                end
            end
        end


        if data.tongueState ~= TONGUE_STATE.INACTIVE then
            p.keys.down = false
        end

        if data.tongueState == TONGUE_STATE.AIMING then
            if data.aimingSound == nil or not data.aimingSound:isPlaying() then
                data.aimingSound = SFX.play{sound = yoshi.tongueSettings.eggAimSound,volume = 0.35,loops = 0}
            end
        else
            stopAimSound()
        end
    end


    function manageTongueNPC()
        if data.tongueNPC == nil then
            return
        end

        if not tongueNPCFilter(data.tongueNPC) then
            data.tongueNPC = nil
            p:mem(0x12,FIELD_BOOL,false)

            return
        end


        data.tongueNPC.section = p.section

        data.tongueNPC.despawnTimer = 100

        data.tongueNPC:mem(0x12E,FIELD_WORD,20)
        data.tongueNPC:mem(0x130,FIELD_WORD,1)
        data.tongueNPC:mem(0x136,FIELD_BOOL,true)

        if NPC.config[data.tongueNPC.id].isshell or (data.tongueNPC.id == 45 and data.tongueNPC.ai1 == 1) then -- idk man shells are weird
            data.tongueNPC.friendly = true
        end

        if data.tongueLength > 0 then
            updateTongueColliders()

            data.tongueNPC.x = data.tongueTipCollider.x + data.tongueTipCollider.width *0.5 - data.tongueNPC.width *0.5
            data.tongueNPC.y = data.tongueTipCollider.y + data.tongueTipCollider.height*0.5 - data.tongueNPC.height*0.5

            data.tongueNPC:mem(0x138,FIELD_WORD,5)
            data.tongueNPC:mem(0x13C,FIELD_DFLOAT,1)
            data.tongueNPC:mem(0x144,FIELD_WORD,5)
        else
            data.tongueNPC.x = p.x + p.width *0.5 - data.tongueNPC.width *0.5
            data.tongueNPC.y = p.y + p.height*0.5 - data.tongueNPC.height*0.5
            data.tongueNPC.direction = p.direction

            data.tongueNPC.animationFrame = -999
            data.tongueNPC.animationTimer = -999

            if yoshi.getNPCTongueBehaviour(data.tongueNPC) == NPC_TONGUE_BEHAVIOUR.INSTANT_SWALLOW then
                yoshi.swallowNPC()
                return
            end

            -- Special case for keys: check link's "has key" flag, and try to find keyholes
            if data.tongueNPC.id == 31 then
                if not p:mem(0x12,FIELD_BOOL) then
                    data.tongueNPC:kill(HARM_TYPE_VANISH)
                    data.tongueNPC = nil
                    return
                end

                for _,bgo in BGO.iterateIntersecting(p.x,p.y,p.x+p.width,p.y+p.height) do
                    if bgo.id == 35 and not bgo.isHidden then
                        Audio.SeizeStream(-1)
                        Audio.MusicPause()

                        Level.winState(3)
                        SFX.play(31)
                    end
                end
            end

            data.tongueNPC:mem(0x138,FIELD_WORD,6)
            data.tongueNPC:mem(0x13C,FIELD_DFLOAT,1)
            data.tongueNPC:mem(0x144,FIELD_WORD,5)
        end
    end



    function yoshi.giveEgg(id)
        if p.character ~= CHARACTER_YOSHI then
            return
        end


        if type(id) == "NPC" then
            local behaviour = yoshi.getNPCTongueBehaviour(id)

            if behaviour == NPC_TONGUE_BEHAVIOUR.BIG_EGG then
                id = yoshi.tongueSettings.bigEggNPCID
            else
                id = yoshi.tongueSettings.normalEggNPCID
            end
        end


        local egg = {}

        egg.npcID = id

        egg.x = p.x+p.width*0.5
        egg.y = p.y+p.height

        egg.bounceOffset = 0
        egg.bounceSpeed = 0

        egg.delay = 1

        egg.animationTimer = 0

        table.insert(data.followingEggs,egg)


        -- If yoshi has too many eggs, remove the first one
        if #data.followingEggs > yoshi.tongueSettings.maxEggs then
            local poppedIndex = 1
            local popped = data.followingEggs[poppedIndex]

            local effectID = NPC.config[popped.npcID].fallEffectID

            if effectID ~= nil then
                local e = Effect.spawn(effectID,popped.x,popped.y)

                e.x = e.x - e.width*0.5
                e.y = e.y - e.height
            end

            table.remove(data.followingEggs,poppedIndex)
        end
    end
    

    function handleFollowingEggs()
        -- Update the trail
        local followingEggCount = #data.followingEggs
        local trailLength = 0
        
        if followingEggCount > 0 then
            local maxTrailSize = (followingEggCount+1)*yoshi.tongueSettings.eggDelay

            local followX = (data.trailFollowsBaby and data.babyMario.x-data.babyMario.speedX) or p.x+p.width*0.5
            local followY = (data.trailFollowsBaby and data.babyMario.y-data.babyMario.speedY) or p.y+p.height


            local isStill = (data.trail[1] ~= nil and (data.trail[1].x == followX and data.trail[1].y == followY and p.forcedState == FORCEDSTATE_NONE or p.deathTimer > 0 or followingBaby))
            local canPauseWith = ((isOnGroundRedigit() or p.mount == MOUNT_CLOWNCAR) and p.forcedState == FORCEDSTATE_NONE and not data.trailFollowsBaby)

            data.trailIsPaused = (isStill and data.trailUnpausableCount == 0)

            if not data.trailIsPaused then
                table.insert(data.trail,1,{
                    x = followX,y = followY,forcedState = p.forcedState,
                    isGrounded = (isOnGroundRedigit() and p:mem(0x34,FIELD_WORD) == 0 and p.mount ~= MOUNT_CLOWNCAR and not data.trailFollowsBaby),
                    isWalking = (p.speedX ~= 0 and p.forcedState == FORCEDSTATE_NONE and p.deathTimer == 0 and not data.trailFollowsBaby), -- used for bouncing
                    canPauseWith = canPauseWith,
                    visible = (p.forcedState ~= FORCEDSTATE_INVISIBLE or (yoshi.introActive and yoshi.highPriorityFadeIn > 0)),
                })

                if not canPauseWith then
                    data.trailUnpausableCount = data.trailUnpausableCount + 1
                end
            else
                for _,position in ipairs(data.trail) do
                    position.isWalking = false
                end
            end


            trailLength = #data.trail

            -- Delete any old entries that aren't useful anymore
            for i = maxTrailSize+1,trailLength do
                local popped = data.trail[i]

                if popped ~= nil and not popped.canPauseWith then
                    data.trailUnpausableCount = data.trailUnpausableCount - 1
                end

                data.trail[i] = nil
            end

            trailLength = math.min(maxTrailSize,trailLength)
        elseif data.trail[1] ~= nil then
            data.trail = {}
            data.trailUnpausableCount = 0
        end


        for index,egg in ipairs(data.followingEggs) do
            local idealDelay = math.min(trailLength,index*yoshi.tongueSettings.eggDelay)

            if egg.delay > idealDelay then
                egg.delay = math.max(idealDelay,egg.delay - 1)
            elseif egg.delay < idealDelay then
                egg.delay = math.min(idealDelay,egg.delay + 2)
            end

            egg.delay = math.clamp(egg.delay,1,trailLength) -- make sure it's not beyond what there actually is


            egg.position = data.trail[egg.delay]

            egg.x = egg.position.x
            egg.y = egg.position.y

            if egg.position.isGrounded and egg.position.forcedState == FORCEDSTATE_NONE then
                if egg.position.isWalking and egg.bounceOffset >= 0 and not data.trailIsPaused then
                    egg.bounceOffset = 0
                    egg.bounceSpeed = -2
                else
                    egg.bounceSpeed = egg.bounceSpeed + 0.26
                end

                egg.bounceOffset = math.min(0,egg.bounceOffset + egg.bounceSpeed)
            else
                egg.bounceOffset = 0
                egg.bounceSpeed = 0
            end
            
            egg.animationTimer = egg.animationTimer + 1


            -- Special easter egg for rinka blocks: spawn rinkas!
            if egg.npcID == 211 and egg.animationTimer%160 == 0 then
                yoshi.giveEgg(210)
                SFX.play(64)
            end
        end



        if data.aimingWithEgg ~= nil then
            data.aimingWithEgg.x = yoshi.tongueSettings.heldEggOffset.x*p.direction
            data.aimingWithEgg.y = yoshi.tongueSettings.heldEggOffset.y

            data.aimingWithEgg.animationTimer = data.aimingWithEgg.animationTimer + 1
        end
    end


    local function drawEgg(egg)
        local npcConfig = NPC.config[egg.npcID]

        local image = Graphics.sprites.npc[egg.npcID].img

        if npcConfig == nil or image == nil then
            return
        end


        local priority = (yoshi.introActive and 6.3) or (egg.position ~= nil and egg.position.forcedState == FORCEDSTATE_PIPE and -76) or -56

        local gfxwidth  = (npcConfig.gfxwidth  ~= 0 and npcConfig.gfxwidth ) or npcConfig.width
        local gfxheight = (npcConfig.gfxheight ~= 0 and npcConfig.gfxheight) or npcConfig.height

        local x = egg.x - gfxwidth*0.5
        local y = egg.y - gfxheight + egg.bounceOffset

        if egg == data.aimingWithEgg then
            x = p.x+p.width*0.5 + x
            y = p.y+p.height + y - egg.bounceOffset

            priority = -24
        end

        
        local frame = 0
        if npcConfig.frames > 0 then
            frame = math.floor(egg.animationTimer/npcConfig.framespeed) % npcConfig.frames
        end

        Graphics.drawImageToSceneWP(image,x,y,0,frame*gfxheight,gfxwidth,gfxheight,priority)
    end

    function drawFollowingEggs()
        for _,egg in ipairs(data.followingEggs) do
            if egg.position == nil or egg.position.visible then
                drawEgg(egg)
            end
        end


        if data.aimingWithEgg ~= nil then
            drawEgg(data.aimingWithEgg)
        end
    end


    function drawAim()
        if data.tongueState == TONGUE_STATE.AIMING then
            local image = yoshi.tongueSettings.eggAimImage

            local offset = vector(yoshi.tongueSettings.eggAimDistance,0):rotate(data.aimingAngle)
            offset.x = offset.x * p.direction

            local width = image.width
            local height = image.height/2

            local frame = math.floor(lunatime.tick()/4)%2

            Graphics.drawImageToSceneWP(image,p.x + p.width*0.5 + offset.x - width*0.5,p.y + p.height*0.5 + offset.y - height*0.5,0,frame*height,width,height,-4)
        end
    end
end


-- Ground pound
local resetGroundPoundData
local handleGroundPound
local canUseGroundPound

do
    GROUND_POUND_STATE = {
        INACTIVE = 0,
        STAY = 1,
        FALL = 2,
        LANDED = 3,
    }

    function canUseGroundPound()
        return (
            p.mount == MOUNT_NONE
            and p:mem(0x34,FIELD_WORD) == 0
            and data.hurtState == HURT_STATE.NORMAL
            and data.tongueState == TONGUE_STATE.INACTIVE
        )
    end

    local function canStartGroundPound()
        return (
            not isOnGroundRedigit()
            and p:mem(0x11C,FIELD_WORD) == 0
        )
    end


    local function hitStuff()
        local col = Colliders.getSpeedHitbox(p)

        col.height = col.height + 0.1

        -- Hit blocks
        local blocks = Colliders.getColliding{a = col,btype = Colliders.BLOCK}

        for _,block in ipairs(blocks) do
            if block.id == 370 or block.contentID == 0  and not block:mem(0x5A,FIELD_BOOL) and block.id ~= 90 and Block.MEGA_SMASH_MAP[block.id] then
                block:remove(true)
                SFX.play(smasExtraSounds.sounds[4].sfx)
            else
                block:hit(true)
            end
        end

        -- Hit NPC's
        local npcs = Colliders.getColliding{a = col,b = NPC.HITTABLE,btype = Colliders.NPC}

        for _,npc in ipairs(npcs) do
            if npc:mem(0x138,FIELD_WORD) ~= 5 and npc:mem(0x138,FIELD_WORD) ~= 6 then
                if npc.id == 263 then -- ice block
                    npc:harm(HARM_TYPE_FROMBELOW)
                else
                    npc:harm(HARM_TYPE_SPINJUMP)
                end
                if npc.id == 159 then -- smb2 diggable sand
                    npc:harm(HARM_TYPE_FROMBELOW)
                else
                    npc:harm(HARM_TYPE_SPINJUMP)
                end
            end
        end
    end


    function resetGroundPoundData()
        data.groundPoundState = GROUND_POUND_STATE.INACTIVE
        data.groundPoundTimer = 0
    end

    function handleGroundPound()
        if not canUseGroundPound() then
            resetGroundPoundData()
            return
        end

        
        if data.groundPoundState == GROUND_POUND_STATE.INACTIVE then
            if p.keys.down == KEYS_PRESSED and p.speedY >= yoshi.groundPoundSettings.minActivateSpeed and canStartGroundPound() and Level.winState() == 0 then
                data.groundPoundState = GROUND_POUND_STATE.STAY
                data.groundPoundTimer = 0

                p.speedY = 0

                SFX.play(yoshi.groundPoundSettings.startSound)
            end
        elseif data.groundPoundState == GROUND_POUND_STATE.STAY then
            if not canStartGroundPound() or p.speedY < 0 then
                resetGroundPoundData()
                return
            end

            p.speedY = -Defines.player_grav + 0.01

            data.groundPoundTimer = data.groundPoundTimer + 1

            if data.groundPoundTimer >= yoshi.groundPoundSettings.stayTime then
                data.groundPoundState = GROUND_POUND_STATE.FALL
                data.groundPoundTimer = 0
            end
        elseif data.groundPoundState == GROUND_POUND_STATE.FALL then
            if p.speedY < 0 then
                resetGroundPoundData()
                return
            end

            data.groundPoundTimer = data.groundPoundTimer + 1

            if isOnGroundRedigit() then
                data.groundPoundState = GROUND_POUND_STATE.LANDED
                data.groundPoundTimer = 0

                Defines.earthquake = 6

                SFX.play(yoshi.groundPoundSettings.landSound)
            else
                p.speedY = yoshi.groundPoundSettings.fallSpeed

                hitStuff()
            end
        elseif data.groundPoundState == GROUND_POUND_STATE.LANDED then
            data.groundPoundTimer = data.groundPoundTimer + 1

            if (not p.keys.down or Level.winState() ~= 0) and data.groundPoundTimer >= yoshi.groundPoundSettings.minLandedTime then
                data.groundPoundState = GROUND_POUND_STATE.INACTIVE
                data.groundPoundTimer = 0
            else
                hitStuff()
            end
        end


        if data.groundPoundState ~= GROUND_POUND_STATE.INACTIVE then
            p.keys.left = false
            p.keys.right = false
            p.keys.down = false
            p.keys.jump = false

            p.speedX = 0
        end
    end
end



-- Animation
local updateAnimation
local resetAnimationData
local findAnimation
local findBabyAnimation
local findExitPlayerAnimation

local resetObjAnimationProperties,progressObjAnimation

do
    local v2 = vector.v2 -- shortcut

    yoshi.animations = {
        idle = {1, defaultFrameY = 1},
        idleNormal = {1,2,3,4,5,6,7, defaultFrameY = 3,frameDelay = 6,babyOffset = {v2(2,0),v2(4,-2),v2(2,0),v2(0,0),v2(2,0),v2(2,-2),v2(2,0)}},
        idleExtra1 = {1,2,3,4,4,4,4,4,4,4,4,4,4,3,2,1, defaultFrameY = 5,frameDelay = 2}, -- look around
        idleExtra2 = {1,2,3,2,3,2,3,1, defaultFrameY = 7,frameDelay = 8}, -- scratch chin

        lookUp = {1, defaultFrameY = 9},

        walk = {1,2,3,4,5,6,7,8,9,10, defaultFrameY = 11,frameDelay = 1.5,babyOffset = {v2(0,2),v2(0,0),nil,v2(0,2),nil,nil,v2(0,-2),v2(0,-4),v2(0,-2),nil}},
        run = {1,2, defaultFrameY = 13,frameDelay = 2,babyOffset = {v2(0,0),v2(0,-2)}},

        skid = {1,2, defaultFrameY = 15,frameDelay = 6,babyOffset = {v2(2,-6),v2(2,-8)}},

        duck = {1,2,3, defaultFrameY = 17,frameDelay = 1,loops = false,babyOffset = {v2(0,4),v2(0,8)}},
        unduck = {2,1, defaultFrameY = 17,frameDelay = 1,loops = false,babyOffset = {v2(0,8),v2(0,4)}},

        land = {1,1,2,2,1, defaultFrameY = 17,frameDelay = 1,loops = false,babyOffset = {v2(0,4),nil,v2(0,8),nil,v2(0,4)}},

        push = {1,2,3,4,5, defaultFrameY = 60,frameDelay = 6,babyOffset = {v2(6,4),v2(8,6),v2(8,8),v2(6,6),v2(6,2)}},


        jump = {1, defaultFrameY = 19},
        fall = {2,3, defaultFrameY = 19,frameDelay = 6,loops = false},

        bump = {1,2,3,4, defaultFrameY = 32,frameDelay = 2,loops = false},


        waterIdle = {2, defaultFrameY = 21},
        waterMoveStart = {1,2,3, defaultFrameY = 23,frameDelay = 2,loops = false,babyOffset = {v2(0,-2),v2(-2,-4),v2(0,-4)}},
        waterMoveEnd = {3,2,1, defaultFrameY = 23,frameDelay = 2,loops = false,babyOffset = {v2(0,-4),v2(-2,-4),v2(0,-2)}},
        waterMoveLoop = {1,2,3,4, defaultFrameY = 25,frameDelay = 4,babyOffset = v2(0,-4)},


        pipeDown = {1,2,3,4, defaultFrameY = 27,frameDelay = 8,loops = false,babyOffset = {v2(0,4),nil,v2(0,6),v2(2,6)},noMouthNPCChange = true},
        pipeUp = {1,2,3,4,5,6,7,8,9, defaultFrameY = 28,frameDelay = 4,loops = false,babyOffset = {v2(0,4),v2(0,6),v2(0,4),v2(2,4),v2(4,4),v2(2,4),nil,v2(0,4),v2(-2,4)},noMouthNPCChange = true},
        pipeExit = {1, defaultFrameY = 29,babyOffset = v2(14,0)},

        door = {1,2,3,4, defaultFrameY = 31,frameDelay = 2,loops = false,babyOffset = {v2(2,0),v2(6,0),v2(10,0),v2(14,0)},babyHigherPriority = true,noMouthNPCChange = true},


        hitKnockback = {1,2, defaultFrameY = 34,frameDelay = 2,loops = false},
        hitSpin = {1,2,3,4,5,6, defaultFrameY = 36,frameDelay = 8,noMouthNPCChange = true},
        hitFall = {1,2,3,2,3, defaultFrameY = 37, frameDelay = 6,loops = false,babyOffset = {v2(8,0),v2(20,2),v2(20,4),v2(20,2),v2(20,4)}},


        flutter = {1,2,3, defaultFrameY = 39,frameDelay = 2,babyOffset = v2(2,4)},


        tongueHorizontal = {1, defaultFrameY = 41,noMouthNPCChange = true},
        tongueFailedHorizontal = {1,2, defaultFrameY = 41,frameDelay = 2,loops = false,noMouthNPCChange = true},
        tongueUnderwaterHorizontal = {1, defaultFrameY = 44,noMouthNPCChange = true,babyOffset = v2(6,2)},

        tongueVertical = {1, defaultFrameY = 42,noMouthNPCChange = true},
        tongueFailedVertical = {1,2, defaultFrameY = 42,frameDelay = 2,loops = false,noMouthNPCChange = true},
        tongueUnderwaterVertical = {1, defaultFrameY = 45,noMouthNPCChange = true,babyOffset = v2(6,10)},

        spitHorizontal = {4,1,1, defaultFrameY = 41,frameDelay = 3,loops = false,noMouthNPCChange = true},
        spitVertical = {4,1,1, defaultFrameY = 42,frameDelay = 3,loops = false,noMouthNPCChange = true},
        spitUnderwater = {2,1,1, defaultFrameY = 44,frameDelay = 3,loops = false,noMouthNPCChange = true,babyOffset = {v2(0,0),v2(6,10)}},

        swallow = {1,2,3,4,4,5,6,7,8,9, defaultFrameY = 43,frameDelay = 4,loops = false,noMouthNPCChange = true},
        swallowUnderwater = {1,2,2,3, defaultFrameY = 46,frameDelay = 4,loops = false,noMouthNPCChange = true},


        createEgg = {1,2,3,3,4,5,6,7,7,8, defaultFrameY = 47,frameDelay = 3,loops = false,noMouthNPCChange = true,babyOffset = {nil,nil,v2(2,0),nil,nil,v2(0,2),v2(6,-8),v2(12,-6),nil,v2(2,-4)}},

        aimingStart = {1,2,3,3,4, defaultFrameY = 48,frameDelay = 2,loops = false,babyOffset = {v2(2,2),v2(8,0),v2(20,-2),nil,v2(10,0)}},
        aimingIdle = {5, defaultFrameY = 48,babyOffset = v2(12,-12)},
        aimingWalk = {1,2,3,4,5, defaultFrameY = 50,frameDelay = 1.5,babyOffset = v2(12,-12)},
        aimingFlutter = {1,2,3, defaultFrameY = 52,frameDelay = 2,babyOffset = v2(12,-12)},
        aimingSkid = {1,2,3, defaultFrameY = 54,frameDelay = 6,babyOffset = v2(12,-12)},

        throw = {1,1,2,3,4,5,5,5,5,5,5,5,5,5,5,5,5, defaultFrameY = 56,frameDelay = 1,loops = false,babyOffset = v2(0,0)},


        groundPound = {1,2,3,4,5,6,7, defaultFrameY = 58,frameDelay = 3,loops = false},
        groundPoundLand = {8,9, defaultFrameY = 58,frameDelay = 3,loops = false},

        rotate = {1,2,3,4,5,6,7, defaultFrameY = 58,frameDelay = 3},


        cheerGrounded = {1, defaultFrameY = 62,noMouthNPCChange = true},
        cheerAir = {2, defaultFrameY = 62,noMouthNPCChange = true},


        keyTurn = {1,2, defaultFrameY = 63,frameDelay = 4,loops = false,noMouthNPCChange = true},
        keyVictory = {3,4, defaultFrameY = 63,frameDelay = 6,loops = false,noMouthNPCChange = true,babyOffset = v2(0,-4)},
        keySquish = {5,6,7, defaultFrameY = 63,frameDelay = 4,loops = false,noMouthNPCChange = true,babyOffset = {v2(0,-2),v2(0,0)}},

        shot = {1, defaultFrameY = 64,frameDelay = 6,loops = false,noMouthNPCChange = true},
        shotAir = {3, defaultFrameY = 64,frameDelay = 6,loops = false,noMouthNPCChange = true},
        shotCanHold = {1,2, defaultFrameY = 64,frameDelay = 4,noMouthNPCChange = true},
        shotAirCanHold = {3,4, defaultFrameY = 64,frameDelay = 4,noMouthNPCChange = true},
    }

    yoshi.babyAnimations = {
        idle = {1},

        lookUp = {7},

        duck = {2,3, frameDelay = 2,loops = false},
        unduck = {2, frameDelay = 3,loops = false},

        walk = {1,1,1,4, frameDelay = 10},

        woahWeMovingFast = {5,6, frameDelay = 4},

        jump = {5},
        fall = {6},


        yeeted = {8},

        crying = {1,1,1,9,9,9,10,11,10, frameDelay = 8,loopPoint = 4},


        victory = {13},
    }



    function resetObjAnimationProperties(dataTable,frameYOnly)
        dataTable.currentAnimation = "idle"
        dataTable.animationTimer = 0
        dataTable.animationSpeed = 0
        dataTable.animationFrameIndex = 1
        dataTable.animationFinished = false

        if frameYOnly then
            dataTable.currentFrame = 1
        else
            dataTable.currentFrame = vector.one2
        end
    end

    function progressObjAnimation(animationSet,findAnimationFunc,dataTable,frameYOnly)
        local newAnimation,newSpeed,forceRestart = findAnimationFunc()

        if newAnimation ~= dataTable.currentAnimation or forceRestart then
            dataTable.currentAnimation = newAnimation
            dataTable.animationTimer = 0
            dataTable.animationFinished = false
        end

        dataTable.animationSpeed = newSpeed or 1


        -- Update the frame accordingly
        local animationData = animationSet[dataTable.currentAnimation]
        local frameCount = #animationData

        dataTable.animationFrameIndex = math.floor(dataTable.animationTimer/(animationData.frameDelay or 1))

        if dataTable.animationFrameIndex >= frameCount then
            if animationData.loopPoint ~= nil then
                local loopingFrames = (frameCount - animationData.loopPoint) + 1

                dataTable.animationFrameIndex = ((dataTable.animationFrameIndex - frameCount) % loopingFrames) + animationData.loopPoint - 1
            elseif animationData.loops ~= false then
                dataTable.animationFrameIndex = dataTable.animationFrameIndex % frameCount
            else
                dataTable.animationFrameIndex = frameCount - 1
            end

            dataTable.animationFinished = true
        end

        
        dataTable.animationFrameIndex = dataTable.animationFrameIndex + 1

        local frame = animationData[dataTable.animationFrameIndex]

        if frameYOnly then
            dataTable.currentFrame = frame
        else
            if type(frame) == "number" then
                dataTable.currentFrame = vector(frame,animationData.defaultFrameY)
            elseif type(frame) == "Vector2" then
                dataTable.currentFrame = vector(frame.x,frame.y)
            end
        end

        dataTable.animationTimer = dataTable.animationTimer + dataTable.animationSpeed
    end


    local function isOnGroundAnimation()
        return (
            isOnGroundRedigit()
            or (p:mem(0x06,FIELD_WORD) > 0 and p.speedY > 0) -- falling in quicksand
        )
    end

    local function isSlidingOnIce()
        return (
            p:mem(0x0A,FIELD_BOOL) -- slippery
            and (not p.keys.left and not p.keys.right)
        )
    end


    local function findIdleAnimation()
        if p.mount == MOUNT_BOOT then
            return "idle"
        elseif not data.animationFinished and (data.currentAnimation == "idleNormal" or data.currentAnimation:find("^idleExtra%d+$")) then -- if the current animation is an idle one, simply continue it
            return data.currentAnimation
        elseif data.currentAnimation ~= "idleNormal" or RNG.randomInt(1,3) > 1 then -- there's two ways for the "stomp" animation to play: if it's coming in from another animation, or a random chance passes
            return "idleNormal",1,true
        else -- the looking around/chin scratching animation will be played
            return "idleExtra".. RNG.randomInt(1,2)
        end
    end


    function findAnimation()
        if isOverworld or isOnSMWMap then
            if p.mount == MOUNT_BOOT then
                return "idle"
            elseif p.mount == MOUNT_CLOWNCAR then
                return "idleNormal"
            else
                return "walk",0.35
            end
        end

        
        if p.deathTimer > 0 then
            if data.deathTimer < 96 then
                return "hitSpin",2
            else
                return "hitFall"
            end
        end


        if p.forcedState == FORCEDSTATE_INVISIBLE and yoshi.introActive and yoshi.highPriorityFadeIn > 0 then
            -- Intro
            if p.mount ~= MOUNT_NONE then
                return findIdleAnimation()
            elseif p.y+p.height >= yoshi.introJumpY and yoshi.introJumpSpeedY >= 0 then
                if data.currentAnimation == "jump" or data.currentAnimation == "fall" or (data.currentAnimation == "land" and not data.animationFinished) then
                    return "land"
                else
                    return findIdleAnimation()
                end
            elseif yoshi.introJumpSpeedY > 0 then
                return "fall"
            else
                return "jump"
            end
        elseif p.forcedState == FORCEDSTATE_INVISIBLE and data.keyActive then
            -- Key active
            if data.keyTimer >= 540 then
                if data.keySpeedY < 0 and p.mount == MOUNT_NONE then
                    return "jump"
                elseif data.keySpeedY > 0 and p.mount == MOUNT_NONE then
                    return "fall"
                elseif data.keySpeedX ~= 0 and p.mount == MOUNT_NONE then
                    return "walk",math.max(0.2,math.abs(data.keySpeedX)/yoshi.generalSettings.walkSpeed)
                else
                    return "keySquish"
                end
            elseif data.keyTimer >= 480 then
                return "keyVictory"
            elseif data.keyTimer >= 340 then
                return "keyTurn"
            else
                return findIdleAnimation()
            end
        elseif p.forcedState == FORCEDSTATE_PIPE then
            -- Going through a pipe
            local direction = getPipeDirection()

            if direction == 3 and p.forcedTimer == 0 and data.tongueNPC == nil then
                local move = 0
                if data.currentAnimation == "pipeDown" then
                    move = math.max(0,data.animationTimer-18)*0.22*data.animationSpeed
                end

                p.y = p.y - 1 + move

                return "pipeDown"
            elseif direction == 1 and p.forcedTimer == 0 and data.tongueNPC == nil then
                local move = 0
                if data.currentAnimation == "pipeUp" then
                    move = math.max(0,data.animationTimer-20)*0.22*data.animationSpeed
                end                        

                p.y = p.y + 1 - move

                return "pipeUp"
            elseif direction == 3 or direction == 1 then
                return "pipeExit"
            else
                return "walk",0.25
            end
        elseif p.forcedState == FORCEDSTATE_DOOR then
            -- Door / clear pipe
            if data.onTickFrame == 2 or data.onTickFrame == 15 then
                return "rotate"
            else
                return "door"
            end
        elseif p.forcedState ~= FORCEDSTATE_NONE then
            -- Some other forced state
            return "idle"
        end


        -- Being hit
        if data.hurtState == HURT_STATE.HIT_BACK then
            return "hitKnockback"
        elseif data.hurtState == HURT_STATE.SPIN then
            return "hitSpin",math.max(1,math.abs(p.speedX))
        end


        if player.climbing then
            local speed = 0

            if player.keys.left or player.keys.right or player.keys.up or player.keys.down then
                speed = 1
            end

            return "rotate",speed
        end


        -- Creating an egg
        if data.tongueState == TONGUE_STATE.CREATING_EGG then
            return "createEgg"
        end


        -- Ducking
        if p:mem(0x12E,FIELD_BOOL) then
            return "duck"
        end

        if data.currentAnimation == "duck" or (data.currentAnimation == "unduck" and not data.animationFinished) then
            return "unduck"
        end


        -- Mounts
        if p.mount == MOUNT_BOOT then
            if data.flutterTimer > 0 then
                return "flutter"
            else
                return "idle"
            end
        elseif p.mount == MOUNT_CLOWNCAR then
            return findIdleAnimation()
        end


        -- Tongue stuff
        if data.tongueState == TONGUE_STATE.EXTEND or data.tongueLength > 0 then
            p.direction = data.tongueForceDirectiontion

            local name = "tongue"

            if not isOnGroundAnimation() and p:mem(0x34,FIELD_WORD) > 0 and p:mem(0x06,FIELD_WORD) == 0 then -- swimming
                name = name.. "Underwater"
            elseif data.tongueState == TONGUE_STATE.STOPPED_NPC then
                name = name.. "Failed"
            end
            if data.tongueVertical then
                name = name.. "Vertical"
            else
                name = name.. "Horizontal"
            end

            return name
        elseif data.tongueState == TONGUE_STATE.START_AIM then
            p.direction = data.tongueForceDirectiontion

            return "aimingStart"
        elseif data.tongueState == TONGUE_STATE.AIMING then
            p.direction = data.tongueForceDirectiontion

            if playerstun.isStunned(p.idx) then
                return "aimingIdle"
            end


            if isOnGroundAnimation() then
                if (p.speedX < 0 and p.keys.right) or (p.speedX > 0 and p.keys.left) then -- turning
                    return "aimingSkid"
                end

                if p.speedX ~= 0 and not isSlidingOnIce() then
                    return "aimingWalk",math.max(0.2,math.abs(p.speedX)/yoshi.generalSettings.walkSpeed)
                end
            else
                if data.flutterTimer > 0 then
                    return "aimingFlutter"
                end
            end

            return "aimingIdle"
        end


        if data.melonShotCooldown > 0 then
            local animationName = "shot"

            if not isOnGroundAnimation() then
                animationName = animationName.. "Air"
            end

            if data.melonShotCanHold then
                animationName = animationName.. "CanHold"
            end

            return animationName
        end


        if data.justThrew or (data.currentAnimation == "throw" and not data.animationFinished) then
            return "throw"
        end


        if data.justSpit then
            if not isOnGroundAnimation() and p:mem(0x34,FIELD_WORD) > 0 and p:mem(0x06,FIELD_WORD) == 0 then -- swimming
                return "spitUnderwater"
            elseif p.keys.up then
                return "spitVertical"
            else
                return "spitHorizontal"
            end
        elseif data.currentAnimation:find("^spit.+$") and not data.animationFinished then
            return data.currentAnimation
        end


        if data.justSwallowed then
            if not isOnGroundAnimation() and p:mem(0x34,FIELD_WORD) > 0 and p:mem(0x06,FIELD_WORD) == 0 then -- swimming
                return "swallowUnderwater"
            else
                return "swallow"
            end
        elseif data.currentAnimation:find("^swallow.*$") and not data.animationFinished then
            return data.currentAnimation
        end


        -- Stunned by a sledge bro
        if playerstun.isStunned(p.idx) then
            return "idle"
        end


        -- Ground pounding
        if data.groundPoundState == GROUND_POUND_STATE.STAY or data.groundPoundState == GROUND_POUND_STATE.FALL then
            return "groundPound"
        elseif data.groundPoundState == GROUND_POUND_STATE.LANDED then
            return "groundPoundLand"
        end



        if isOnGroundAnimation() then
            -- Landing
            if data.currentAnimation == "jump" or data.currentAnimation == "fall" or (data.currentAnimation == "land" and not data.animationFinished) then
                return "land"
            end



            if (p.speedX < 0 and p.keys.right) or (p.speedX > 0 and p.keys.left) then -- turning
                return "skid"
            end


            if p.speedX ~= 0 and not isSlidingOnIce() then -- walk/run
                if p:mem(0x148,FIELD_WORD) > 0 or p:mem(0x14C,FIELD_WORD) > 0 then -- pushing
                    return "push"
                elseif math.abs(p.speedX) >= yoshi.generalSettings.runSpeed-0.1 then
                    return "run",math.abs(p.speedX)/yoshi.generalSettings.runSpeed
                else
                    return "walk",math.max(0.2,math.abs(p.speedX)/yoshi.generalSettings.walkSpeed)
                end
            else -- idle
                if p.keys.up then
                    return "lookUp"
                else
                    return findIdleAnimation()
                end
            end
        elseif p:mem(0x34,FIELD_WORD) > 0 and p:mem(0x06,FIELD_WORD) == 0 then -- underwater
            if math.abs(p.speedX) > 0.1 or math.abs(p.speedY) > 0.1 then
                if data.currentAnimation == "waterMoveLoop" or (data.currentAnimation == "waterMoveStart" and data.animationFinished) then
                    return "waterMoveLoop"
                else
                    return "waterMoveStart"
                end
            else
                if data.currentAnimation == "waterMoveStart" or data.currentAnimation == "waterMoveLoop" or (data.currentAnimation == "waterMoveEnd" and not data.animationFinished) then
                    return "waterMoveEnd"
                else
                    return "waterIdle"
                end
            end
        else
            if p:mem(0x14A,FIELD_WORD) > 1 or (data.currentAnimation == "bump" and not data.animationFinished) then
                return "bump"
            end

            if data.flutterTimer > 0 then
                return "flutter"
            end

            if p.speedY > 0 then
                return "fall"
            else
                return "jump"
            end
        end

        return "idle"
    end


    function findBabyAnimation()
        if isOverworld or isOnSMWMap then
            return "walk"
        end


        if data.babyMario.state == BABY_STATE.YEETED or data.babyMario.state == BABY_STATE.PASSED or data.babyMario.state == BABY_STATE.YEETED_VIA_CHEAT then
            return "yeeted"
        elseif data.babyMario.state == BABY_STATE.BUBBLE then
            if data.babyMario.currentAnimation == "crying" then
                local animationData = yoshi.babyAnimations["crying"]

                if data.babyMario.currentFrame == 11 and data.babyMario.animationTimer%animationData.frameDelay == 1 then
                    SFX.play(yoshi.generalSettings.babyCrySound)
                end
            end

            return "crying"
        elseif data.babyMario.state == BABY_STATE.KIDNAPPED or data.babyMario.state == BABY_STATE.CARRIED_OFF then
            return "idle"
        end


        local yoshiAnimation = data.currentAnimation

        if p.deathTimer > 0 then
            if yoshiAnimation == "hitFall" and data.animationFinished then
                return "duck"
            else
                return "idle"
            end
        end



        if p.mount == MOUNT_CLOWNCAR then
            return "idle"
        end


        if p.forcedState == FORCEDSTATE_INVISIBLE and yoshi.introActive and yoshi.highPriorityFadeIn > 0 then
            if p.y+p.height >= yoshi.introJumpY and yoshi.introJumpSpeedY >= 0 then
                return "idle"
            elseif yoshi.introJumpSpeedY > 0 then
                return "fall"
            else
                return "jump"
            end
        elseif p.forcedState == FORCEDSTATE_INVISIBLE and data.keyActive then
            if yoshiAnimation == "keyVictory" then
                return "victory"
            end
        end


        if p:mem(0x12E,FIELD_BOOL) then -- duck
            return "duck"
        end

        if data.babyMario.currentAnimation == "duck" or (data.babyMario.currentAnimation == "unduck" and not data.babyMario.animationFinished) then -- unducking
            return "unduck"
        end


        if p.forcedState ~= FORCEDSTATE_NONE then
            return "idle"
        end


        if playerstun.isStunned(p.idx) then
            return "fall"
        end


        if yoshiAnimation == "walk" or yoshiAnimation == "aimingWalk" then
            return "walk"
        elseif yoshiAnimation == "run" then
            return "woahWeMovingFast"
        elseif yoshiAnimation == "lookUp" or yoshiAnimation:find("^tongue.*Vertical$") or yoshiAnimation == "spitVertical" then
            return "lookUp"
        end

        if not isOnGroundAnimation() then
            if p.speedY > 0 then
                return "fall"
            else
                return "jump"
            end
        end

        return "idle"
    end


    function findExitPlayerAnimation()
        if (data.exitPlayer.currentAnimation == "idle" and yoshi.generalSettings.healthSystem == HEALTH_SYSTEM.BABY_MARIO) or (data.exitPlayer.currentAnimation == "throw" and not data.exitPlayer.animationFinished) then
            return "throw"
        elseif data.exitPlayer.grounded or (data.exitPlayer.isInQuicksand and data.exitPlayer.speedY >= 0) then
            return "cheerGrounded"
        else
            return "cheerAir"
        end
    end


    function resetAnimationData()
        resetObjAnimationProperties(data,false)
        resetObjAnimationProperties(data.babyMario,true)
        resetObjAnimationProperties(data.exitPlayer,false)
    end

    function updateAnimation()
        local oldYoshiAnimation = data.currentAnimation

        progressObjAnimation(yoshi.animations,findAnimation,data,false)


        if data.exitPlayer.active then
            progressObjAnimation(yoshi.animations,findExitPlayerAnimation,data.exitPlayer,false)
        end


        local yoshiAnimationData = yoshi.animations[data.currentAnimation]

        if not yoshiAnimationData.noMouthNPCChange and (data.tongueNPC ~= nil and data.tongueNPC.isValid) then
            data.currentFrame.y = data.currentFrame.y + 1
        end


        if yoshi.generalSettings.healthSystem == HEALTH_SYSTEM.BABY_MARIO then
            progressObjAnimation(yoshi.babyAnimations,findBabyAnimation,data.babyMario,true)

            if data.babyMario.state == BABY_STATE.NORMAL then
                local offset = yoshiAnimationData.babyOffset

                if type(offset) == "table" then
                    offset = offset[data.animationFrameIndex]
                end

                if offset ~= nil then
                    data.babyMario.x = offset[1]
                    data.babyMario.y = offset[2]
                elseif oldYoshiAnimation ~= data.currentAnimation then
                    data.babyMario.x = 0
                    data.babyMario.y = 0
                end

                data.babyMario.higherPriority = yoshiAnimationData.babyHigherPriority or false
            end
        end
    end
end


-- Rendering
do
    yoshi.mainShaderPath = "yiYoshi/main.frag"

    yoshi.shaders = {
        [false] = nil, -- no starman
        [true] = nil, -- starman
    }


    local function drawBaby(args,sceneCoords,priority,color,direction,shader,uniforms)
        local babyImage = yoshi.generalSettings.babyMarioImage
        local babyData = data.babyMario
        
        if babyData.sprite == nil then
            babyData.sprite = Sprite{
                texture = babyImage,
                frames = yoshi.generalSettings.babyMarioFrames,
                pivot = Sprite.align.BOTTOM,
            }
        end


        if babyData.state ~= BABY_STATE.NORMAL and babyData.state ~= BABY_STATE.RESCUED and babyData.state ~= BABY_STATE.PASSED then
            priority = -6
        end


        local babyDirection

        if babyData.state == BABY_STATE.NORMAL then
            babyDirection = -direction

            babyData.sprite.transform:setParent(data.sprite.transform,false)
            babyData.sprite.x = (babyData.x + yoshi.generalSettings.babyMarioOffset.x)*direction
            babyData.sprite.y = (babyData.y + yoshi.generalSettings.babyMarioOffset.y)
        else
            babyDirection = babyData.direction

            babyData.sprite.transform:setParent(nil,false)
            babyData.sprite.x = babyData.x
            babyData.sprite.y = babyData.y
        end

        babyData.sprite.scale.x = babyData.megaMushroomScale
        babyData.sprite.scale.y = babyData.megaMushroomScale

        babyData.sprite.width = babyImage.width*-babyDirection
        babyData.sprite.texpivot = vector((babyDirection == DIR_LEFT and 0) or 1,0)

        babyData.sprite:draw{
            color = color,priority = priority,sceneCoords = sceneCoords,
            frame = babyData.currentFrame,
            shader = shader,uniforms = uniforms,
        }

        if babyData.bubbleFrame > 0 then
            local bubbleImage = yoshi.generalSettings.babyBubbleImage

            if babyData.bubbleSprite == nil then
                babyData.bubbleSprite = Sprite{
                    texture = bubbleImage,
                    frames = 3,
                    pivot = Sprite.align.BOTTOM,
                }

                babyData.bubbleSprite.transform:setParent(babyData.sprite.transform)
            end

            babyData.bubbleSprite.x = 0
            babyData.bubbleSprite.y = -20

            babyData.bubbleSprite:draw{
                priority = priority,sceneCoords = sceneCoords,
                frame = babyData.bubbleFrame,
                shader = shader,uniforms = uniforms,
            }
        end
    end


    local function drawTongue(args,sceneCoords,priority,color,direction,shader,uniforms)
        if data.tongueLength <= 0 then
            return
        end


        if data.tongueSprite == nil then
            data.tongueSprite = Sprite{texture = yoshi.tongueSettings.image,frames = vector(2,6),pivot = Sprite.align.CENTRE}
            data.tongueSprite.transform:setParent(data.sprite.transform,false)
        end

        local segmentWidth  = data.tongueSprite.texture.width /2
        local segmentHeight = data.tongueSprite.texture.height/6


        local totalLength = math.max(data.tongueLength,segmentWidth)

        local segments
        if data.tongueVertical then
            segments = math.ceil(totalLength/segmentHeight)
        else
            segments = math.ceil(totalLength/segmentWidth)
        end


        data.tongueSprite.width = segmentWidth*-direction
        data.tongueSprite.texpivot = vector((direction == DIR_LEFT and 0) or 1,0)


        for i = 1, segments do
            local frame = vector.one2

            frame.x = (data.tongueVertical and 2) or 1

            if i == segments then
                frame.y = 1
            else
                if data.tongueState == TONGUE_STATE.STOPPED_BLOCK or data.tongueState == TONGUE_STATE.STOPPED_NPC then
                    frame.y = ((math.floor(data.tongueTimer/3) + i) % 2) + 3

                    if data.tongueTimer >= 3 and data.tongueTimer < yoshi.tongueSettings.stoppedTime-3 then
                        frame.y = frame.y + 2
                    end
                else
                    frame.y = 2
                end
            end

            if data.tongueVertical then
                data.tongueSprite.x = yoshi.tongueSettings.verticalOffsetX*direction
                data.tongueSprite.y = yoshi.tongueSettings.verticalOffsetY - segmentHeight*0.5 - math.min(totalLength,i*segmentHeight)
            else
                data.tongueSprite.x = (yoshi.tongueSettings.horizontalOffsetX - segmentWidth*0.5 + math.min(totalLength,i*segmentWidth))*direction
                data.tongueSprite.y = yoshi.tongueSettings.horizontalOffsetY - segmentHeight
            end

            data.tongueSprite:draw{frame = frame,color = color,priority = priority,sceneCoords = sceneCoords,shader = shader,uniforms = uniforms}

            -- this is needed for it to work properly sometimes. idk why.
            local a = data.tongueSprite.wposition
        end
    end
    

    local invisibleStates = table.map{FORCEDSTATE_INVISIBLE}

    local function canDrawPlayer()
        return (
            (not p:mem(0x142,FIELD_BOOL) or data.hurtState ~= HURT_STATE.NORMAL or p.deathTimer > 0 or p.isMega)
            and not invisibleStates[p.forcedState]
            and not p:mem(0x0C,FIELD_BOOL)
        )
    end

    local function canDrawBaby(showPlayer)
        return (
            yoshi.generalSettings.healthSystem == HEALTH_SYSTEM.BABY_MARIO
            and (data.babyMario.state ~= BABY_STATE.NORMAL or showPlayer)
        )
    end


    function yoshi.render(args)
        args = args or {}


        local image = yoshi.generalSettings.mainImage

        if data.sprite == nil then
            data.sprite = Sprite{
                texture = image,
                frames = vector(image.width/yoshi.generalSettings.frameWidth,image.height/yoshi.generalSettings.frameHeight),
                pivot = Sprite.align.BOTTOM,
            }
        end

        -- Compile main shader if necessary
        if yoshi.shaders[p.hasStarman] == nil then
            yoshi.shaders[p.hasStarman] = Shader()

            yoshi.shaders[p.hasStarman]:compileFromFile(nil, Misc.resolveFile(yoshi.mainShaderPath), {
                PALETTES_COLOURS = yoshi.generalSettings.palettesImage.width,
                HAS_STARMAN = p.hasStarman,
            })
        end



        local mount = (args.mount or p.mount)

        local sceneCoords = (args.sceneCoords ~= false)
        local priority = args.priority or (p.forcedState == FORCEDSTATE_PIPE and -70.01) or (mount == MOUNT_CLOWNCAR and -35.01) or -25.01
        local color = args.color
        local direction = (args.direction or p.direction) * math.sign((type(args.frame) == "number" and args.frame) or p:getFrame())

        local showPlayer = (args.ignorestate or canDrawPlayer())
        local showBaby = (args.drawbaby ~= false and (data.babyMario.state == BABY_STATE.NORMAL or args.isMainRender) and canDrawBaby(showPlayer))

        local shader = yoshi.shaders[p.hasStarman]
        local uniforms = {
            palettesImage = yoshi.generalSettings.palettesImage,
            currentColourY = ((args.yoshicolor or saveData.currentColour)+0.1)/yoshi.generalSettings.palettesImage.height,
            time = lunatime.tick(),
        }


        data.sprite.scale.x = data.megaMushroomScale
        data.sprite.scale.y = data.megaMushroomScale

        data.sprite.x = (args.x or p.x) + yoshi.generalSettings.mainOffset.x*data.sprite.scale.x
        data.sprite.y = (args.y or p.y) + yoshi.generalSettings.mainOffset.y*data.sprite.scale.y

        if mount == MOUNT_CLOWNCAR then
            data.sprite.x = data.sprite.x + p.width*0.5
            data.sprite.y = data.sprite.y + 24
        else
            data.sprite.x = data.sprite.x + p.width*0.5
            data.sprite.y = data.sprite.y + p.height
        end

        data.sprite.x = math.floor(data.sprite.x + 0.5)
        data.sprite.y = math.floor(data.sprite.y + 0.5)
        

        data.sprite.width = yoshi.generalSettings.frameWidth*-direction
        data.sprite.texpivot = vector((direction == DIR_LEFT and 0) or 1,0)


        if showBaby and not data.babyMario.higherPriority then
            drawBaby(args,sceneCoords,priority,color,direction,shader,uniforms)
        end


        if showPlayer then
            local frame = args.frame
            if frame == nil or type(frame) ~= "Vector2" then
                frame = data.currentFrame
            end

            data.sprite:draw{
                color = color,priority = priority,sceneCoords = sceneCoords,
                frame = frame,
                shader = shader,uniforms = uniforms,
            }

            drawTongue(args,sceneCoords,priority,color,direction,shader,uniforms)
        end


        if showBaby and data.babyMario.higherPriority then
            drawBaby(args,sceneCoords,priority,color,direction,shader,uniforms)
        end
    end


    local playerRender = Player.render

    local renderArgs = {
        "frame","direction","powerup","character","drawplayer","mount","mounttype","x","y","ignorestate","priority","mountpriority",
        "sceneCoords","texture","color","shader","uniforms","attributes","mountcolor","mountshader","mountuniforms","mountattributes",
    }

    function Player:render(args)
        if (args.character or self.character) == CHARACTER_YOSHI then
            yoshi.render(args)


            -- Draw mounts
            local clonedArgs = {}

            for _,name in ipairs(renderArgs) do
                clonedArgs[name] = args[name]
            end

            clonedArgs.drawplayer = false

            if type(clonedArgs.frame) == "Vector2" then
                clonedArgs.frame = nil
            end

            playerRender(self,clonedArgs)


            return
        end

        playerRender(self,args)
    end
end


-- HUD stuff
do
    local charToNumberConversion = {["0"] = 0,["1"] = 1,["2"] = 2,["3"] = 3,["4"] = 4,["5"] = 5,["6"] = 6,["7"] = 7,["8"] = 8,["9"] = 9}

    function yoshi.drawStarCounter(playerIdx,camObj,playerObj,priority,isSplit,playerCount)
        if Graphics.isHudActivated() then
            local backImage = yoshi.generalSettings.starCounterBackImage
            local numbersImage = yoshi.generalSettings.starCounterNumbersImage

            local numberHeight = (numbersImage.height/20)

            local baseX = (camObj.width*0.5)
            local baseY = (12 + math.max(backImage.height,numberHeight)*0.5)
            
            Graphics.drawImageWP(backImage,baseX - backImage.width*0.5,baseY - backImage.height*0.5,-1.991)


            local numbersString = tostring(data.starCounter)
            local numbersLength = #numbersString
            
            for i = 1, numbersLength do
                local sourceY = (charToNumberConversion[string.sub(numbersString,i,i)] or 0) * numberHeight
                local width = numbersImage.width

                if numbersLength > 1 then
                    sourceY = sourceY + numbersImage.height*0.5
                    width = width*0.5
                end
                Graphics.drawImageWP(numbersImage,baseX - numbersLength*width*0.5 + (i-1)*width,baseY - numberHeight*0.5,0,sourceY,numbersImage.width,numberHeight,-1.99)
            end
        end
    end


    function initHUD()
        if not isOverworld or not isOnSMWMap then
            Graphics.activateHud(true)
        end
        local type = Graphics.HUD_HEARTS
        local actions

        if yoshi.generalSettings.healthSystem == HEALTH_SYSTEM.BABY_MARIO then
            type = Graphics.HUD_NONE
            actions = yoshi.drawStarCounter
        end

        Graphics.registerCharacterHUD(CHARACTER_YOSHI,type,actions,nil)
    end
end


-- Intro
local startIntro
local handleIntro
local drawIntro

do
    local function getLevelName()
        if gameData.overworldLevelName ~= nil then
            return gameData.overworldLevelName
        end

        local filename = Level.filename()
        local format = Level.format()

        if format == "lvlx" then
            -- Open lvlx header, which could contain a name
            local levelData = FileFormats.openLevelHeader(filename)

            if levelData ~= nil and levelData.levelName ~= "" then
                return levelData.levelName
            end
        end

        return filename:sub(1,#filename - #format - 1)
    end


    function startIntro()
        if not yoshi.introSettings.enabled or p.forcedState ~= FORCEDSTATE_NONE or (Misc.inEditor() and not Misc.GetKeyState(VK_I)) then
            return
        end

        yoshi.curveTransitionMax = 1
        yoshi.curveTransitionMin = 1
        yoshi.highPriorityFadeIn = 0

        yoshi.introText = getLevelName()
        yoshi.introTextLimit = 0
        yoshi.introTextLayout = textplus.layout(yoshi.introText,yoshi.introSettings.textMaxWidth,{font = yoshi.introSettings.textFont,xscale = yoshi.introSettings.textScale,yscale = yoshi.introSettings.textScale})

        yoshi.introActive = true
        yoshi.introTimer = 0

        yoshi.introMusicToRestore = p.sectionObj.musicID
        p.sectionObj.musicID = 0

        p.forcedState = FORCEDSTATE_INVISIBLE
        p.forcedTimer = 0
    end

    function handleIntro()
        if not yoshi.introActive then
            return
        end

        if yoshi.introTimer == 1 then
            Defines.levelFreeze = true
        end

        if yoshi.introTimer == yoshi.introSettings.startDelay then
            yoshi.introJumpX = p.x + p.width*0.5
            yoshi.introJumpY = p.y + p.height

            yoshi.forceCameraX = camera.x
            yoshi.forceCameraY = camera.y

            if p.direction == DIR_LEFT then
                p.x = camera.x + camera.width + 32
            else
                p.x = camera.x - p.width - 32
            end
            p.y = camera.y + camera.height + 32
            

            local diffX = (yoshi.introJumpX - p.x+p.width*0.5)
            local diffY = (yoshi.introJumpY - p.y+p.height)

            yoshi.introJumpSpeedX = math.lerp(0,4,math.clamp(math.abs(diffX)/300,0.01,1)) * math.sign(diffX)

            local t = math.abs(diffX / yoshi.introJumpSpeedX)
            yoshi.introJumpSpeedY = (diffY / t) - (Defines.player_grav * t) / 2

            yoshi.highPriorityFadeIn = 1
            
            SFX.play(yoshi.introSettings.sound)
        elseif yoshi.introTimer > yoshi.introSettings.startDelay then
            yoshi.introJumpSpeedX = yoshi.introJumpSpeedX
            yoshi.introJumpSpeedY = yoshi.introJumpSpeedY + Defines.player_grav

            p.x = p.x + yoshi.introJumpSpeedX
            p.y = p.y + yoshi.introJumpSpeedY

            if p.y+p.height >= yoshi.introJumpY and yoshi.introJumpSpeedY >= 0 then
                p.x = yoshi.introJumpX - p.width*0.5
                p.y = yoshi.introJumpY - p.height
                yoshi.introJumpSpeedX = 0
                yoshi.introJumpSpeedY = 0
            end

            if yoshi.introTimer > yoshi.introSettings.startDelay+32 and yoshi.introTimer%yoshi.introSettings.textCharacterAppearRate == 0 then
                yoshi.introTextLimit = yoshi.introTextLimit + 1
            end
        end

        if yoshi.introTimer > yoshi.introSettings.startDelay+yoshi.introSettings.textAppearDuration then
            if yoshi.curveTransitionMin > 0 then
                yoshi.curveTransitionMin = math.max(0,yoshi.curveTransitionMin - 0.025)

                if yoshi.introMusicToRestore ~= nil then
                    p.sectionObj.musicID = yoshi.introMusicToRestore
                    yoshi.introMusicToRestore = nil
                end
            elseif yoshi.curveTransitionMax > 0 then
                yoshi.curveTransitionMax = math.max(0,yoshi.curveTransitionMax - 0.035)                
            else
                yoshi.introActive = false
                Defines.levelFreeze = false

                p.forcedState = FORCEDSTATE_NONE
                p.forcedTimer = 0

                p.speedX = 0
                p.speedY = 0

                yoshi.highPriorityFadeIn = 0

                yoshi.forceCameraX = nil
                yoshi.forceCameraY = nil

                yoshi.transitionBuffer:clear(6)
            end
        end

        yoshi.introTimer = yoshi.introTimer + 1
    end

    function drawIntro()
        if not yoshi.introActive then
            return
        end

        yoshi.transitionBuffer:clear(-100)

        textplus.render{
            layout = yoshi.introTextLayout,target = yoshi.transitionBuffer,limit = yoshi.introTextLimit,priority = -100,
            x = camera.width*0.5 - yoshi.introSettings.textMaxWidth*0.5 + yoshi.introSettings.textXOffset,
            y = camera.height*0.5 + yoshi.introSettings.textYOffset,
        }
    end
end


-- Exits
local resetExitData
local handleExit
local drawExit

do
    local function blockIsSolidOrSemisolid(block)
        if not Colliders.FILTER_COL_BLOCK_DEF(block) then
            return false
        end

        local blockConfig = block.config[block.id]

        if blockConfig.passthrough or (blockConfig.playerfilter == -1 or blockConfig.playerfilter == p.character) then
            return false
        end

        return true
    end

    local function blockIsSolid(block)
        if not blockIsSolidOrSemisolid(block) then
            return false
        end

        local blockConfig = block.config[block.id]

        if blockConfig.semisolid or blockConfig.sizeable then
            return false
        end

        return true
    end

    
    local function findPlayerNewPosition()
        p.x = yoshi.forceCameraX + camera.width + 16

        local col = Colliders.Box(yoshi.forceCameraX + camera.width - 32,yoshi.forceCameraY,128,camera.height)


        local blocks = Colliders.getColliding{a = col,btype = Colliders.BLOCK,filter = blockIsSolidOrSemisolid}

        local highestBlock
        local highestY

        for _,block in ipairs(blocks) do
            if (highestY == nil or block.y < highestY) and (block.y > yoshi.forceCameraY+p.height and block.y+block.height <= yoshi.forceCameraY+camera.height) then
                -- Check that the player would have room here...
                local safetyCol = Colliders.getHitbox(p)

                safetyCol.x = block.x + block.width*0.5 - safetyCol.width*0.5
                safetyCol.y = block.y - safetyCol.height

                local stoppingBlocks = Colliders.getColliding{a = safetyCol,btype = Colliders.BLOCK,filter = blockIsSolid}

                if #stoppingBlocks == 0 then
                    highestBlock = block
                    highestY = block.y
                end
            end
        end

        if highestY ~= nil then
            p.y = highestY - p.height
        else
            p.y = yoshi.forceCameraY + camera.height + 32
        end
    end


    local function getExitPlayerCollider()
        local col = Colliders.Box(0,0,p.width,p.height)

        col.x = data.exitPlayer.x - col.width*0.5
        col.y = data.exitPlayer.y - col.height

        return col
    end

    local function handleExitPlayerCollision()
        local oldGrounded = data.exitPlayer.grounded
        data.exitPlayer.grounded = false

        local col = getExitPlayerCollider()

        local blocks = Colliders.getColliding{a = col,btype = Colliders.BLOCK,filter = blockIsSolidOrSemisolid}

        for _,block in ipairs(blocks) do
            local blockConfig = Block.config[block.id]

            if data.exitPlayer.y-data.exitPlayer.speedY <= block.y-block.speedY or (blockConfig ~= nil and blockConfig.floorslope ~= 0) then
                if blockConfig.floorslope ~= 0 then
                    -- Calculate the ejection position
                    local blockSide      = (block.x           + block.width*0.5) + (block.width*0.5*blockConfig.floorslope)
                    local fakePlayerSide = (data.exitPlayer.x                  ) - (p.width    *0.5*blockConfig.floorslope)

                    local ejectionPosition = block.y + block.height - math.clamp(((blockSide-fakePlayerSide)*blockConfig.floorslope)/block.width,0,1)*block.height
                    
                    data.exitPlayer.y = ejectionPosition
                else
                    data.exitPlayer.y = block.y
                end

                if not oldGrounded and Block.LAVA_MAP[block.id] then
                    SFX.play(16)
                end

                data.exitPlayer.speedY = 0
                data.exitPlayer.grounded = true
            end
        end
    end

    local function exitPlayerIsInLiquid()
        local isUnderwater = p.sectionObj.isUnderwater
        local isInQuicksand = false

        local col = getExitPlayerCollider()

        for _,liquid in ipairs(Liquid.getIntersecting(col.x,col.y,col.x+col.width,col.y+col.height)) do
            if not liquid.isHidden then
                isUnderwater = isUnderwater or (not liquid.isQuicksand)
                isInQuicksand = isInQuicksand or (liquid.isQuicksand)

                if isUnderwater and isInQuicksand then
                    break
                end
            end
        end

        return isUnderwater,isInQuicksand
    end


    local function babyIsOnScreen()
        local b = camera.bounds

        return (
            data.babyMario.x > b.left
            and data.babyMario.y > b.top
            and data.babyMario.x < b.right
            and data.babyMario.y < b.bottom
        )
    end


    local toWinType = {
        [LEVEL_END_STATE_ROULETTE] = LEVEL_WIN_TYPE_ROULETTE,
        [LEVEL_END_STATE_SMB3ORB]  = LEVEL_WIN_TYPE_SMB3ORB,
        [LEVEL_END_STATE_KEYHOLE]  = LEVEL_WIN_TYPE_KEYHOLE,
        [LEVEL_END_STATE_SMB2ORB]  = LEVEL_WIN_TYPE_SMB2ORB,
        [LEVEL_END_STATE_GAMEEND]  = LEVEL_WIN_TYPE_NONE,
        [LEVEL_END_STATE_STAR]     = LEVEL_WIN_TYPE_STAR,
        [LEVEL_END_STATE_TAPE]     = LEVEL_WIN_TYPE_TAPE,
    }


    function resetExitData()
        data.passOnActive = false
        data.passOnTimer = 0

        data.exitPlayer = data.exitPlayer or {}
        data.exitPlayer.active = false

        data.exitBabyGoalX = nil
        data.exitBabyGoalY = nil

        data.exitScoreMusicObj = nil


        data.keyActive = false
        data.keyTimer = 0

        data.keyHoleSprite = nil
        data.keyHoleScale = 0

        data.keySpeedX = 0
        data.keySpeedY = 0
    end


    local function handlePassOn()
        local shouldActivate = yoshi.customExitSettings.passOnEnabled[Level.winState()]

        if shouldActivate and not data.passOnActive then
            Level.winState(Level.winState()+1000)

            SFX.play(14)

            data.passOnActive = true
            data.passOnTimer = 0


            yoshi.forceCameraX = camera.x
            yoshi.forceCameraY = camera.y


            megashroom.StopMega(p,true)
            starman.stop(p)


            -- Initialise the "fake" player
            data.exitPlayer.x = p.x+p.width*0.5
            data.exitPlayer.y = p.y+p.height
            data.exitPlayer.direction = DIR_RIGHT

            data.exitPlayer.colour = saveData.currentColour

            data.exitPlayer.grounded = false
            data.exitPlayer.speedY = 0
            data.exitPlayer.timer = 0
            data.exitPlayer.isUnderwater,data.exitPlayer.isInQuicksand = exitPlayerIsInLiquid()

            data.exitPlayer.active = true
            
            resetObjAnimationProperties(data.exitPlayer,false)


            -- Handle the baby
            if yoshi.generalSettings.healthSystem == HEALTH_SYSTEM.BABY_MARIO then
                local babyIsOnBack = (data.babyMario.state == BABY_STATE.NORMAL)

                if babyIsOnBack or not babyIsOnScreen() then
                    local xOffset = yoshi.generalSettings.babyMarioOffset.x
                    local yOffset = yoshi.generalSettings.babyMarioOffset.y
                    
                    if babyIsOnBack then
                        xOffset = xOffset + data.babyMario.x
                        yOffset = yOffset + data.babyMario.y
                    end

                    data.babyMario.x = p.x + p.width*0.5 + yoshi.generalSettings.mainOffset.x + xOffset*data.exitPlayer.direction
                    data.babyMario.y = p.y + p.height    + yoshi.generalSettings.mainOffset.y + yOffset
                end

                if babyIsOnBack then
                    data.trailFollowsBaby = true
                else
                    SFX.play(yoshi.generalSettings.babyPopBubbleSound)
                    data.babyMario.bubbleFrame = 0
                end

                data.babyMario.state = BABY_STATE.PASSED
                data.babyMario.timer = 0

                data.babyMario.direction = DIR_RIGHT


                data.starCounterState = STAR_COUNTER_STATE.NORMAL
                data.starCounterTimer = 0
            end


            -- Move the REAL yoshi
            saveData.currentColour = (saveData.currentColour + 1) % yoshi.generalSettings.palettesImage.height

            findPlayerNewPosition()

            p.speedX = 0
            p.speedY = 0

            p.direction = DIR_LEFT


            if data.tongueNPC ~= nil and data.tongueNPC.isValid then
                data.tongueNPC:toCoin()
                data.tongueNPC:kill(HARM_TYPE_VANISH)
            end

            
            resetTongueData()
            resetFlutterJump()
            resetGroundPoundData()
            resetWaterMovementData()

            resetObjAnimationProperties(data,false)


            data.exitWalkToX = yoshi.forceCameraX + camera.width - 128
            data.exitWalkToY = p.y + p.height


            -- Expand boundaries so that the real yoshi can come in
            local b = p.sectionObj.boundary

            b.right = math.max(b.right,p.x+p.width)

            p.sectionObj.boundary = b
        end

        
        if not data.passOnActive then
            return
        end


        for k,v in pairs(p.keys) do
            p.keys[k] = false
        end


        local babyExists = (yoshi.generalSettings.healthSystem == HEALTH_SYSTEM.BABY_MARIO)


        local musicDelay = yoshi.customExitSettings.scoreMusicDelay
        if not babyExists then
            musicDelay = musicDelay + 150
        end


        if data.passOnTimer == musicDelay then
            data.exitScoreMusicObj = SFX.play(yoshi.customExitSettings.scoreMusic)
        end

        if data.passOnTimer >= musicDelay+32 then
            p.keys.right = true

            if p.x >= (yoshi.forceCameraX + camera.width + 16) and p.forcedState == FORCEDSTATE_NONE then
                p.forcedState = FORCEDSTATE_INVISIBLE
                p.forcedTimer = 0
            end

            -- Make the fake yoshi fall
            data.exitPlayer.isUnderwater,data.exitPlayer.isInQuicksand = exitPlayerIsInLiquid()
            
            if data.exitPlayer.isInQuicksand then
                data.exitPlayer.speedY = math.clamp(data.exitPlayer.speedY + Defines.player_grav,-4,0.1)
            elseif data.exitPlayer.isUnderwater then
                data.exitPlayer.speedY = math.min(3,data.exitPlayer.speedY + Defines.player_grav*0.1)
            else
                data.exitPlayer.speedY = math.min(8,data.exitPlayer.speedY + Defines.player_grav)
            end
            data.exitPlayer.y = data.exitPlayer.y + data.exitPlayer.speedY

            handleExitPlayerCollision()

            if data.exitPlayer.grounded or (data.exitPlayer.isInQuicksand and data.exitPlayer.speedY > 0) then
                data.exitPlayer.timer = data.exitPlayer.timer + 1

                if data.exitPlayer.timer >= 16 --[[or (data.exitPlayer.isInQuicksand and data.exitPlayer.timer > 4)]] then
                    if data.exitPlayer.isUnderwater then
                        data.exitPlayer.speedY = -2
                    else
                        data.exitPlayer.speedY = -7
                    end

                    if data.exitPlayer.isInQuicksand then
                        SFX.play(1)
                    end
                    
                    data.exitPlayer.grounded = false
                end
            else
                data.exitPlayer.timer = 0
            end
        else
            local realPlayerWalkDistance = (data.exitWalkToX - p.x+p.width*0.5)

            if math.abs(realPlayerWalkDistance) > 80 and p.speedX <= 0 then
                p.speedX = -yoshi.generalSettings.walkSpeed
                p.direction = DIR_LEFT
            else
                p.speedX = p.speedX * 0.975
            end
        end

        if data.passOnTimer >= musicDelay+128 then
            data.exitScoreMusicObj.volume = math.max(0,data.exitScoreMusicObj.volume - 0.0075)

            if data.exitScoreMusicObj.volume <= 0 then
                data.exitScoreMusicObj:stop()

                Level.exit(toWinType[Level.winState()-1000] or LEVEL_WIN_TYPE_NONE)
                Checkpoint.reset()
            end

            -- Transition
            if yoshi.curveTransitionMax < 1 then
                yoshi.curveTransitionMax = math.min(1,yoshi.curveTransitionMax + 0.025)
            else
                yoshi.curveTransitionMin = math.min(1,yoshi.curveTransitionMin + 0.035)
            end
        end


        if data.passOnTimer > 0 or not babyExists then
            data.passOnTimer = data.passOnTimer + 1
        end
    end


    local function handleKey()
        local shouldActivate = yoshi.customExitSettings.keyEnabked[Level.winState()]

        if shouldActivate and not data.keyActive then
            Level.winState(Level.winState()+1000)

            SFX.play(14)

            megashroom.StopMega(p,true)
            starman.stop(p)


            data.keyActive = true


            yoshi.forceCameraX = camera.x
            yoshi.forceCameraY = camera.y

            yoshi.highPriorityFadeIn = 1
        end

        
        if not data.keyActive then
            return
        end

        
        yoshi.wipeTransitionProgress = math.min(1,yoshi.wipeTransitionProgress + 0.005)

        data.keyTimer = data.keyTimer + 1

        
        if p.forcedState == FORCEDSTATE_NONE then
            player.forcedState = FORCEDSTATE_INVISIBLE
            player.forcedTimer = 0
        end


        if data.keyTimer >= 660 then
            data.exitScoreMusicObj.volume = math.max(0,data.exitScoreMusicObj.volume - 0.01)

            if data.exitScoreMusicObj.volume <= 0 then
                data.exitScoreMusicObj:stop()

                saveData.currentColour = (saveData.currentColour + 1) % yoshi.generalSettings.palettesImage.height

                Level.exit(toWinType[Level.winState()-1000] or LEVEL_WIN_TYPE_NONE)
                Checkpoint.reset()
            end
        elseif data.keyTimer >= 620 then
            if data.keyTimer == 620 then
                yoshi.highPriorityFadeIn = 0
                SFX.play(yoshi.customExitSettings.keyCloseSound)
            end

            data.keyHoleScale = math.max(0,data.keyHoleScale - 0.05)
        elseif data.keyTimer >= 560 then
            local floor = yoshi.forceCameraY + camera.height*0.5 + yoshi.customExitSettings.keyImage.height*0.125 - 2

            if data.keyTimer == 575 and p.mount ~= MOUNT_CLOWNCAR then
                data.keySpeedY = -9
            end

            data.keySpeedX = data.keySpeedX + 0.1
            data.keySpeedY = data.keySpeedY + Defines.player_grav


            p.x = p.x + data.keySpeedX
            p.y = p.y + data.keySpeedY
            p.direction = DIR_RIGHT

            if p.y+p.height >= floor then
                if p.mount == MOUNT_BOOT and data.keySpeedX ~= 0 then
                    data.keySpeedY = -3
                else
                    data.keySpeedY = 0
                end

                p.y = floor - p.height
            end
        elseif data.keyTimer >= 450 then
            if data.keyTimer == 450 then
                data.exitScoreMusicObj = SFX.play(yoshi.customExitSettings.scoreMusic)
                SFX.play(yoshi.customExitSettings.keyOpenSound)
            elseif data.keyTimer == 490 then
                SFX.play(yoshi.customExitSettings.keyVictorySound)
            end

            data.keyHoleScale = math.min(1,data.keyHoleScale + 0.05)
        elseif data.keyTimer >= 220 then
            local idealPosition = vector(p.x + p.width*0.5 - camera.width*0.5,p.y + p.height + 2 - yoshi.customExitSettings.keyImage.height*0.125 - camera.height*0.5)
            local distance = idealPosition - vector(yoshi.forceCameraX,yoshi.forceCameraY)
            local speed = distance:normalise() * 6

            yoshi.forceCameraX = yoshi.forceCameraX + speed.x
            yoshi.forceCameraY = yoshi.forceCameraY + speed.y

            if math.abs(distance.x) <= speed.length and math.abs(distance.y) <= speed.length then
                yoshi.forceCameraX = idealPosition.x
                yoshi.forceCameraY = idealPosition.y
            end
        end
    end


    function handleExit()
        --Graphics.activateHud(false)
        handlePassOn()
        handleKey()
    end

    function drawExit()
        if data.exitPlayer.active then
            p:render{
                x = data.exitPlayer.x - p.width*0.5,y = data.exitPlayer.y - p.height,direction = data.exitPlayer.direction,
                frame = data.exitPlayer.currentFrame,yoshicolor = data.exitPlayer.colour,
                drawbaby = false,ignorestate = true,
            }
        end

        if data.keyHoleScale > 0 then
            if data.keyHoleSprite == nil then
                data.keyHoleSprite = Sprite{texture = yoshi.customExitSettings.keyImage,frames = 2,pivot = Sprite.align.CENTRE}
            end

            data.keyHoleSprite.x = camera.width *0.5  --p.x + p.width*0.5
            data.keyHoleSprite.y = camera.height*0.5 + yoshi.customExitSettings.keyImage.height*0.125 --p.y + p.height + 2

            if p.mount ~= MOUNT_CLOWNCAR then
                data.keyHoleSprite.scale.x = data.keyHoleScale
                data.keyHoleSprite.scale.y = data.keyHoleScale
            else
                data.keyHoleSprite.scale.x = data.keyHoleScale*2
                data.keyHoleSprite.scale.y = data.keyHoleScale*1.5
            end

            data.keyHoleSprite:draw{frame = 1,priority = (data.keyHoleScale < 1 and 6.4) or 6.6}
            data.keyHoleSprite:draw{frame = 2,priority = 6.4,color = Color.white}
            data.keyHoleSprite:draw{frame = 2,priority = 6.6,color = Color.white.. 0.375}
        end
    end
end



local function spawnStarsFromBlocks(block,fromTop,amount)
    local npcID = yoshi.generalSettings.starNPCID
    if npcID == nil then
        return
    end

    local config = NPC.config[npcID]

    local x = block.x + block.width*0.5 - config.width*0.5
    local y = block.y - config.height

    if fromTop then
        y = block.y + block.height
    end


    for i = 1, amount do
        local npc = NPC.spawn(npcID,x,y,nil,false,false)

        if not fromTop then
            npc:mem(0x138,FIELD_WORD,1)

            npc.y = npc.y + npc.height
            npc.height = 0
        else
            npc:mem(0x138,FIELD_WORD,3)

            npc.height = 0
        end

        npc.direction = RNG.irandomEntry{DIR_LEFT,DIR_RIGHT}
    end
end

local function checkBlocks()
    for i = 1, #blocksToCheck do
        local data = blocksToCheck[i]
        local block = data[1]

        if block.isValid then
            local fromTop = data[2]

            for _,npc in NPC.iterateIntersecting(block.x,block.y-1,block.x+block.width,block.y+block.height+1) do
                if powerupStars[npc.id] and npc.despawnTimer > 0 and ((not fromTop and npc:mem(0x138,FIELD_WORD) == 1) or (fromTop and npc:mem(0x138,FIELD_WORD) == 3)) then
                    spawnStarsFromBlocks(block,fromTop,powerupStars[npc.id])
                    npc:kill(HARM_TYPE_VANISH)
                end
            end
        end

        blocksToCheck[i] = nil
    end
end


local function resetData()
    data.sprite = nil
    data.tongueSprite = nil

    resetWaterMovementData()
    resetFlutterJump()
    resetTongueData()
    resetGroundPoundData()

    resetHealthData()

    resetExitData()

    resetAnimationData()


    data.megaMushroomScale = 1
    data.megaMushroomTimer = 0

    data.onTickFrame = p.frame
end


function yoshi.onStart()
    --startIntro() broken for other characters, don't use this
end


function yoshi.onTick()
    if p.character ~= CHARACTER_YOSHI then
        return
    end

    if canUseCustomStuff() then
        handleWaterMovement()
        handleFlutterJump()
        handleTongue()
        handleGroundPound()
    else
        resetGroundPoundData()
        resetWaterMovementData()
        resetFlutterJump()
        resetTongueData()
    end

    handleHealth()

    handleToadies()

    handleFollowingEggs()

    handleExit()


    if p.mount == MOUNT_NONE then
        p:mem(0x120,FIELD_BOOL,false) -- disable spin jumping
    end


    -- Recreate the mega mushroom's growing/shrinking animation
    if p.forcedState == FORCEDSTATE_MEGASHROOM then
        if data.megaMushroomTimer == 0 then
            data.megaMushroomTimer = 95
        end

        if data.megaMushroomTimer > 0 then
            data.megaMushroomTimer = data.megaMushroomTimer - 1
            data.megaMushroomScale = (1-(data.megaMushroomTimer/95))*3 + 1

            if data.megaMushroomTimer == 1 then
                data.megaMushroomTimer = -48
            end
        elseif data.megaMushroomTimer < 0 then
            data.megaMushroomTimer = data.megaMushroomTimer + 1
            data.megaMushroomScale = ((-data.megaMushroomTimer/95))*3 + 1
        end
    elseif p.isMega and data.megaMushroomTimer < 0 then
        data.megaMushroomTimer = -95
        data.megaMushroomScale = 4
    else
        data.megaMushroomTimer = 0
        data.megaMushroomScale = 1
    end


    data.onTickFrame = p.frame
end

function yoshi.onTickEnd()
    if p.character ~= CHARACTER_YOSHI then
        return
    end

    handleIntro()

    updateAnimation()

    data.justSpit = false
    data.justThrew = false
    data.justSwallowed = false

    manageTongueNPC()


    checkBlocks()
end

function yoshi.onDraw()
    if p.character ~= CHARACTER_YOSHI then
        return
    end

    yoshi.render{isMainRender = true}

    -- Make the player image blank
    local image = yoshi.generalSettings.emptyPlayerSheet

    if Graphics.sprites.ninjabomberman[p.powerup].img ~= image then
        Graphics.sprites.ninjabomberman[p.powerup].img = image
    end


    -- Do those transition things
    if yoshi.curveTransitionMax > 0 then
        if type(yoshi.curveTransitionShader) == "string" then
            local obj = Shader()
            obj:compileFromFile(nil,Misc.resolveFile(yoshi.curveTransitionShader))

            yoshi.curveTransitionShader = obj
        end

        Graphics.drawScreen{
            texture = yoshi.transitionBuffer,priority = 0,shader = yoshi.curveTransitionShader,uniforms = {
                transitionMin = yoshi.curveTransitionMin,
                transitionMax = yoshi.curveTransitionMax,
                transitionLoopHeight = 0.25,
            },
        }
    elseif yoshi.wipeTransitionProgress > 0 then
        if type(yoshi.wipeTransitionShader) == "string" then
            local obj = Shader()
            obj:compileFromFile(nil,Misc.resolveFile(yoshi.wipeTransitionShader))

            yoshi.wipeTransitionShader = obj
        end

        Graphics.drawScreen{
            texture = yoshi.transitionBuffer,priority = -1,shader = yoshi.wipeTransitionShader,uniforms = {
                transitionTexture = yoshi.customExitSettings.keyWipeImage,
                progress = yoshi.wipeTransitionProgress,
            },
        }
    end


    if yoshi.highPriorityFadeIn > 0 then
        p:render{color = Color.white.. yoshi.highPriorityFadeIn,priority = -0.5,ignorestate = yoshi.introActive or data.keyActive}
    end

    drawFollowingEggs()
    drawAim()


    drawIntro()
    drawExit()


    handleHealthOnDraw()

    drawToadies()
end


function yoshi.giveCheckpointBonus()
    if p.character ~= CHARACTER_YOSHI then
        return
    end

    if yoshi.generalSettings.healthSystem == HEALTH_SYSTEM.BABY_MARIO and data.starCounterState == STAR_COUNTER_STATE.NORMAL and data.starCounter < yoshi.generalSettings.starCounterMax then
        data.starCounterState = STAR_COUNTER_STATE.CHECKPOINT_BONUS
        data.starCounterTimer = 0

        Misc.pause(true)
    end
end

local function saveEggs()
    saveData.savedEggs = {}

    for _,egg in ipairs(data.followingEggs) do
        table.insert(saveData.savedEggs,egg.npcID)
    end

    if data.aimingWithEgg ~= nil then
        table.insert(saveData.savedEggs,data.aimingWithEgg.npcID)
    end
end


function yoshi.onCheckpoint(cp)
    if p.character ~= CHARACTER_YOSHI then
        return
    end

    yoshi.giveCheckpointBonus()
    saveEggs()
end


local poweringUpStates = table.map{FORCEDSTATE_POWERUP_BIG,FORCEDSTATE_POWERUP_FIRE,FORCEDSTATE_POWERUP_LEAF,FORCEDSTATE_POWERUP_TANOOKI,FORCEDSTATE_POWERUP_HAMMER,FORCEDSTATE_POWERUP_ICE}
function yoshi.onPostNPCKill(npc,reason)
    if p.character ~= CHARACTER_YOSHI then
        return
    end

    if npc.id == 192 and lunatime.tick() > 1 then -- legacy checkpoint
        yoshi.giveCheckpointBonus()
        saveEggs()
    end

    if powerupStars[npc.id] ~= nil and npcManager.collected(npc,reason) ~= nil then
        if yoshi.generalSettings.healthSystem == HEALTH_SYSTEM.BABY_MARIO then
            yoshi.giveStarPoint(powerupStars[npc.id])
        end

        if poweringUpStates[p.forcedState] then
            p.forcedState = FORCEDSTATE_NONE
            p.forcedTimer = 0
        end
    end


    -- megan joke
    if npc.id == 427 and reason ~= HARM_TYPE_VANISH and p.deathTimer == 0 then
        p:kill()

        -- draw some funnies into the transition buffer
        printFunny(RNG.irandomEntry{
            "With this character's death, the thread of the prophecy is severed. Restore a saved game to restore the weave of fate, or persist in the doomed world you have created.",
            "Subject: T. Yoshisaur Munchakoopas\n\nStatus: Evaluation terminated\n\nPostmortem: Failed to properly utilize MEGAN in achievement of goal",
            "Well, it looks like we won't be working together.\nNo regrets, Mr. Munchakoopas.",
            "you have failed her.",
        })
    end
end


function yoshi.onBlockHit(eventObj,block,fromTop,culpritPlayer)
    if p.character ~= CHARACTER_YOSHI then
        return
    end

    local npcID = (block.contentID-1000)

    if yoshi.generalSettings.healthSystem == HEALTH_SYSTEM.BABY_MARIO and npcID > 0 and powerupStars[npcID] then
        table.insert(blocksToCheck,{block,fromTop})
    end
end

function yoshi.onExitLevel(exitType)
    if exitType > 0 then
        saveEggs()
    end
end



function yoshi.onPause(eventObj)
    if p.character == CHARACTER_YOSHI and yoshi.introActive then
        eventObj.cancelled = true
    end
end

function yoshi.onCameraUpdate()
    if p.character == CHARACTER_YOSHI then
        camera.x = yoshi.forceCameraX or camera.x
        camera.y = yoshi.forceCameraY or camera.y
    end
end


function yoshi.onDrawOverworld()
    if p.character ~= CHARACTER_YOSHI then
        return
    end

    updateAnimation()
end

function yoshi.onExitOverworld()
    if isOnSMWMap then
        if smwMap.mainPlayer ~= nil and smwMap.mainPlayer.levelObj ~= nil and smwMap.mainPlayer.levelObj.settings.levelFilename ~= "" then
            gameData.overworldLevelName = smwMap.mainPlayer.levelObj.settings.levelFilename
        else
            gameData.overworldLevelName = nil
        end
    else
        if world.levelObj ~= nil then
            gameData.overworldLevelName = world.levelObj.title -- used for intro's level name
        else
            gameData.overworldLevelName = nil
        end
    end
end




function yoshi.initCharacter()
    setMaxSpeed()
    
    smasExtraSounds.enableSpinjumpingSFX = false
    
    Defines.player_grabSideEnabled = false
    Defines.player_grabTopEnabled = false
    Defines.player_grabShellEnabled = false

    smasExtraSounds.sounds[1].sfx  = yoshi.generalSettings.jumpSound
    Audio.sounds[5].sfx  = yoshi.generalSettings.hurtSound
    smasExtraSounds.sounds[8].sfx  = yoshi.generalSettings.deathSound
    smasExtraSounds.sounds[14].sfx = yoshi.generalSettings.coinSound

    if yoshi.customExitSettings.passOnEnabled[LEVEL_END_STATE_ROULETTE] then
        Audio.sounds[19].sfx = yoshi.customExitSettings.passOnMusic
    end
    --if yoshi.customExitSettings.passOnEnabled[LEVEL_END_STATE_TAPE] then
    --    Audio.sounds[60].sfx = yoshi.customExitSettings.passOnMusic
    --end
    if yoshi.customExitSettings.keyEnabked[LEVEL_END_STATE_SMB3ORB] then
        Audio.sounds[21].sfx = yoshi.customExitSettings.keyMusic
    end
    if yoshi.customExitSettings.keyEnabked[LEVEL_END_STATE_STAR] then
        Audio.sounds[52].sfx = yoshi.customExitSettings.keyMusicStar
    end
    --if yoshi.customExitSettings.keyEnabked[LEVEL_END_STATE_SMB2ORB] then
    --    Audio.sounds[40].sfx = yoshi.customExitSettings.keyMusic
    --end


    data.trail = nil

    resetData()
    initHUD()
end

function yoshi.cleanupCharacter()
    Defines.player_walkspeed = nil
    Defines.player_runspeed = nil

    Defines.player_grabSideEnabled = nil
    Defines.player_grabTopEnabled = nil
    Defines.player_grabShellEnabled = nil

    smasExtraSounds.sounds[1].sfx = nil
    Audio.sounds[5].sfx  = nil
    smasExtraSounds.sounds[8].sfx = nil
    smasExtraSounds.sounds[14].sfx = nil
    Audio.sounds[19].sfx = nil
    Audio.sounds[60].sfx = nil
    Audio.sounds[21].sfx = nil
    Audio.sounds[40].sfx = nil
    
    resetData()

    data.trail = nil
    smasExtraSounds.enableSpinjumpingSFX = true
end


function yoshi.onInitAPI()
    if not isOverworld and not isOnSMWMap then
        registerEvent(yoshi,"onTick")
        registerEvent(yoshi,"onTickEnd")
        registerEvent(yoshi,"onDraw")

        registerEvent(yoshi,"onCheckpoint")
        registerEvent(yoshi,"onPostNPCKill")
        registerEvent(yoshi,"onBlockHit")

        registerEvent(yoshi,"onExitLevel")

        registerEvent(yoshi,"onStart")
        registerEvent(yoshi,"onPause")
        registerEvent(yoshi,"onCameraUpdate","onCameraUpdate",false)
    else
        registerEvent(yoshi,"onDraw","onDrawOverworld")
        registerEvent(yoshi,"onExit","onExitOverworld")
    end
    
    resetData()
end


-- Cheats! because why not
do
    --Cheats.addAlias("itsameklonoa","itsameyoshi")
    --Cheats.addAlias("itsameklonoa","eggthrower")


    Cheats.register("heavyweapons",{
        onActivate = (function()
            if p.character ~= CHARACTER_YOSHI then
                return
            end

            for i = 1, yoshi.tongueSettings.maxEggs do
                yoshi.giveEgg(yoshi.tongueSettings.bigEggNPCID)
            end

            SFX.play(yoshi.generalSettings.babyPopBubbleSound)

            return true
        end),
    })

    Cheats.register("fullarsenal",{
        onActivate = (function()
            if p.character ~= CHARACTER_YOSHI then
                return
            end
            
            for i = 1, yoshi.tongueSettings.maxEggs do
                yoshi.giveEgg(yoshi.tongueSettings.normalEggNPCID)
            end

            SFX.play(yoshi.generalSettings.babyPopBubbleSound)

            return true
        end),
    })

    Cheats.register("popthebaby",{
        onActivate = (function()
            if p.character ~= CHARACTER_YOSHI then
                return
            end
            
            yoshi.setHealthSystem((yoshi.generalSettings.healthSystem+1)%2)

            return true
        end),
    })

    Cheats.register("yeetthechild",{
        onActivate = (function()
            if p.character ~= CHARACTER_YOSHI then
                return
            end
            
            data.babyMario.state = BABY_STATE.YEETED_VIA_CHEAT
            data.babyMario.timer = 0

            data.babyMario.x = p.x + p.width*0.5 + yoshi.generalSettings.babyMarioOffset.x*p.direction
            data.babyMario.y = p.y + p.height    + yoshi.generalSettings.babyMarioOffset.y
            data.babyMario.direction = p.direction

            data.babyMario.speedX = 5 * p.direction
            data.babyMario.speedY = -7

            SFX.play(yoshi.tongueSettings.failedThrowSound)
            data.justThrew = true


            return true
        end),
    })
end




yoshi.generalSettings = {
    -- Can be BABY_MARIO or HEARTS
    healthSystem = HEALTH_SYSTEM.BABY_MARIO,

    walkSpeed = 6,
    runSpeed = 6,


    starCounterMin = 10,
    starCounterMax = 30,
    starCounterCheckpointBonus = 10,

    starCounterDecreaseTime = 42,
    starCounterIncreaseTime = 128,


    -- Assets
    mainImage = Graphics.loadImageResolved("yiYoshi/main.png"),
    
    frameWidth = 100,
    frameHeight = 100,

    mainOffset = vector(0,18),

    palettesImage = Graphics.loadImageResolved("yiYoshi/palettes.png"),

    emptyPlayerSheet = Graphics.loadImageResolved("yiYoshi/emptyPlayerSheet.png"),


    babyMarioImage = Graphics.loadImageResolved("yiYoshi/babyMario.png"),
    babyMarioFrames = 13,
    babyMarioOffset = vector(-14,-12),

    babyBubbleImage = Graphics.loadImageResolved("yiYoshi/baby_bubble.png"),


    jumpSound  = SFX.open(Misc.resolveSoundFile("yiYoshi/jump")),
    hurtSound  = SFX.open(Misc.resolveSoundFile("yoshi-hurt")),
    deathSound = SFX.open(Misc.resolveSoundFile("yiYoshi/death")),
    coinSound  = SFX.open(Misc.resolveSoundFile("yiYoshi/coin")),

    babyCreateBubbleSound = SFX.open(Misc.resolveSoundFile("yiYoshi/baby_bubbleCreated")),
    babyPopBubbleSound    = SFX.open(Misc.resolveSoundFile("yiYoshi/pop")),
    babyCrySound          = SFX.open(Misc.resolveSoundFile("yiYoshi/baby_cry")),
    babyRescuedSound      = SFX.open(Misc.resolveSoundFile("yoshi")),
    babyKidnappedSound    = SFX.open(Misc.resolveSoundFile("yiYoshi/baby_kidnapped")),
    babyCarriedOffSound   = SFX.open(Misc.resolveSoundFile("yiYoshi/baby_carriedOff")),

    starCounterBackImage = Graphics.loadImageResolved("yiYoshi/starCounter_back.png"),
    starCounterNumbersImage = Graphics.loadImageResolved("yiYoshi/starCounter_numbers.png"),

    starCounterReplenishedSound = SFX.open(Misc.resolveSoundFile("yiYoshi/starCounter_replenished")),
    starCounterSlowBeepingSound = SFX.open(Misc.resolveSoundFile("yiYoshi/starCounter_slowBeeping")),
    starCounterFastBeepingSound = SFX.open(Misc.resolveSoundFile("yiYoshi/starCounter_fastBeeping")),
    starCounterIncreaseSound    = SFX.open(Misc.resolveSoundFile("yiYoshi/starCounter_increase")),

    toadyImage = Graphics.loadImageResolved("yiYoshi/toady.png"),
    toadyFrames = 4,
}


yoshi.introSettings = {
    enabled = false,

    textFont = textplus.loadFont("yiYoshi/font.ini"),
    textMaxWidth = 384,
    textScale = 2,

    textCharacterAppearRate = 5,

    textXOffset = 0,
    textYOffset = -160,

    sound = SFX.open(Misc.resolveSoundFile("yiYoshi/intro.ogg")),
    
    startDelay = 8,
    textAppearDuration = 256,
}


yoshi.customExitSettings = {
    passOnEnabled = {
        [LEVEL_END_STATE_ROULETTE] = true,
        [LEVEL_END_STATE_TAPE] = true,
    },
    keyEnabked = {
        [LEVEL_END_STATE_SMB3ORB] = true,
        [LEVEL_END_STATE_STAR] = true,
    },


    keyWipeImage = Graphics.loadImageResolved("yiYoshi/transition_wipe.png"),
    keyImage = Graphics.loadImageResolved("yiYoshi/key.png"),
    

    keyVictorySound = SFX.open(Misc.resolveSoundFile("yoshi")),
    keyOpenSound    = SFX.open(Misc.resolveSoundFile("yiYoshi/reveal")),
    keyCloseSound   = SFX.open(Misc.resolveSoundFile("yiYoshi/exit_keyClose")),

    passOnMusic  = SFX.open(Misc.resolveSoundFile("yiYoshi/exit_start")),
    keyMusic     = SFX.open(Misc.resolveSoundFile("yiYoshi/exit_key")),
    keyMusicStar = SFX.open(Misc.resolveSoundFile("yiYoshi/exit_key_star")),
    scoreMusic   = SFX.open(Misc.resolveSoundFile("yiYoshi/exit_score")),

    scoreMusicDelay = 200,
}


yoshi.waterSettings = {
    acceleration = 0.35,
    deceleration = 0.5,

    maxSpeed = 4,
}

yoshi.flutterSettings = {
    activeTime = 44,
    cooldownTime = 24,

    longActiveTime = 64,

    minSpeedYToStart = 3,

    speedYDecrease = 0.55,

    sound = SFX.open(Misc.resolveSoundFile("yiYoshi/flutter")),
    soundDelay = 6,
}


yoshi.tongueSettings = {
    enabled = true,

    image = Graphics.loadImageResolved("yiYoshi/tongue.png"),

    extendSpeed = 16,
    retractSpeed = 16,
    maxLength = 112,

    stayTime = 3,
    stoppedTime = 26,

    horizontalOffsetX = 22,
    horizontalOffsetY = -22, 
    verticalOffsetX = 12,
    verticalOffsetY = -38,

    hitboxWidth = 16,
    hitboxHeight = 24,

    spitOffsetX = 32,
    spitOffsetY = -32,
    spitOffsetYDucking = -8,

    spitSpeedXHorizontal = 6,
    spitSpeedYHorizontal = -1.3,
    spitSpeedXVertical = 2,
    spitSpeedYVertical = -7,

    

    maxEggs = 6,

    eggDelay = 9,

    heldEggOffset = vector(-16,-16),

    eggAimMinAngle = -90,
    eggAimMaxAngle = 45,
    eggAimAngleChange = 2,

    

    startSound   = SFX.open(Misc.resolveSoundFile("yiYoshi/tongue_start")),
    failedSound  = SFX.open(Misc.resolveSoundFile("yiYoshi/tongue_failed")),
    spitSound    = SFX.open(Misc.resolveSoundFile("birdo-spit")),
    swallowSound = SFX.open(Misc.resolveSoundFile("yoshi-swallow")),

    createEggSound   = SFX.open(Misc.resolveSoundFile("yiYoshi/pop")),
    startAimSound    = SFX.open(Misc.resolveSoundFile("yoshi-tongue")),
    cycleEggsSound   = SFX.open(Misc.resolveSoundFile("swim")),
    eggThrowSound    = SFX.open(Misc.resolveSoundFile("yiYoshi/egg_thrown")),
    failedThrowSound = SFX.open(Misc.resolveSoundFile("yiYoshi/egg_failedThrow")),
    eggAimSound      = SFX.open(Misc.resolveSoundFile("yiYoshi/aim")),

    eggAimImage = Graphics.loadImageResolved("yiYoshi/aim.png"),
    eggAimDistance = 128,
}


yoshi.groundPoundSettings = {
    stayTime = 24,
    minLandedTime = 8,

    fallSpeed = 12,

    minActivateSpeed = -5.5,


    startSound = SFX.open(Misc.resolveSoundFile("yiYoshi/groundPound_start")),
    landSound = SFX.open(Misc.resolveSoundFile("yiYoshi/groundPound_land")),
}


return yoshi