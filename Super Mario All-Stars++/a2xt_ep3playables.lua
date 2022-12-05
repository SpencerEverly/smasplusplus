local animatx = require("animatx2")
local particles = require("particles")
local megashroom = require("mega/megashroom")
local starman = require("starman/star")
local spintrail = require ("a2xt_spintrail")

ep3Playables = {}

local powerupShader = Shader();
powerupShader:compileFromFile(nil, Misc.resolveFile("shaders/ep3PlayerAura.frag"))

local starmanShader = Misc.multiResolveFile("starman.frag", "shaders\\npc\\starman.frag")
local blankPlayerSheet = Graphics.loadImageResolved("graphics/blankVanillaPlayerSheet.png")


local characterData = {
    [CHARACTER_MARIO] = {
        name="mario", const=CHARACTER_MARIO,
        deathEffectId=3, runTotal=35
    },
    [CHARACTER_LUIGI] = {
        name="luigi", const=CHARACTER_LUIGI,
        deathEffectId=5
    },
    [CHARACTER_PEACH] = {
        name="peach", const=CHARACTER_PEACH,
        deathEffectId=129
    },
    [CHARACTER_TOAD] = {
        name="toad", const=CHARACTER_TOAD,
        deathEffectId=130
    },
    [CHARACTER_LINK] = {
        name="link", const=CHARACTER_LINK,
        deathEffectId=134
    },
}

local costumeData = {}

local players = {}


function ep3Playables.onInitAPI()
    registerEvent(ep3Playables, "onDraw");
    registerEvent(ep3Playables, "onTickEnd");
    registerEvent(ep3Playables, "onInputUpdate", "onInputUpdate", false);
    registerEvent(ep3Playables, "onPlayerHarm");
    registerEvent(ep3Playables, "onPostPlayerHarm");
    registerEvent(ep3Playables, "onPlayerKill");

    registerEvent(ep3Playables, "onReset");
end



local function blankOutCharacter(charConst)
    --Misc.dialog(charConst)
    local name = characterData[charConst].name
    for  i=1,7  do
        Graphics.sprites[name][i].img = blankPlayerSheet
    end
end
local function unBlankCharacter(charConst)
    local name = characterData[charConst].name
    for  i=1,7  do
        Graphics.sprites[name][i].img = nil
    end
end

local storedPower = {}

function ep3Playables.register(playerObj, costumeTable, extraInputFunct, extraAnimFunct, extraDrawFunct)
    --Misc.dialog("Registering a costume for "..characterInfo.name)

    local pathPrefix = costumeTable.path

    -- Set the player object's powerup state to 2 for the HP system override
    playerObj.powerup = 2

    -- Initialize costume data
    local costDat = costumeData[costumeTable.index]  or  costumeTable
    if  costumeData[costDat.index] == nil  then
        
        costDat = costumeTable
        costumeData[costDat.index] = costumeTable
        
        -- AnimSet
        costDat.set = costDat.namespace.actorArgs.animSet

        -- Palette info
        costDat.paletteTexture = Graphics.loadImageResolved(pathPrefix .. "/palettes.png")
        costDat.paletteDimensions = vector(costDat.paletteTexture.width, costDat.paletteTexture.height)
    end
    
    -- Get the base character data
    local charDat = characterData[costumeTable.baseCharID]

    -- Death effect image caching
    costDat.deathEffectId = charDat.deathEffectId -- copying the index here because laziness
    costDat.deathEffectImage = Graphics.loadImageResolved(costDat.path.."/effect-"..tostring(charDat.deathEffectId)..".png")

    -- Set up the Player object's data table
    local pDat = {
        p = playerObj,

        hp = 2,
        powerup = storedPower[playerObj] or 2,
        lastPowerup = 0,
        lastPower = 2,
        reserveItem = 0,

        -- Adjacent blocks collider
        blockCheckBox = Colliders.Box(0,0,1,1),

        -- Powerup state rendering
        paletteOffset = nil,
        powerupEmitters = {},
        powerupTextures = {},

        costume = costDat,
        idleAnimCounter=0, canIdleAnim=true, 
        fixedDirection=false, posing=false, transformable=false, 
        priorityOverride = nil, 
        scaleOverride = nil,
        paletteOverride = nil,
        emitterOverride = nil,
        emitterOffsetOverride = nil,
        groundedOverride = nil,
        tailRelease = false, 
        swimCounter = 0,
        kickTimer = 0,
        spinStartDir = playerObj.direction,

        lastWalkInput = playerObj.direction,

        -- Megashroom
        megaStartFrame=0, megaEndFrame=0, megaShrinking=false,
        maxScale=2,
        width = playerObj.width, height = playerObj.height,

        -- Rendering
        wingSprite = Sprite{texture=Graphics.sprites.hardcoded["19"].img, frames=4, x=0,y=0, pivot = Sprite.align.CENTER},
        crop = {buffer=Graphics.CaptureBuffer(800,600), bounds={left=0,top=0,right=800,bottom=600}},
        postProcessBuffer = Graphics.CaptureBuffer(800,600),
        visible = true,

        -- Custom behavior
        inputEvent = extraInputFunct,
        animEvent = extraAnimFunct,
        drawEndEvent = extraDrawFunct
    }

    playerObj.getA2xtData = function()
        if pDat.costume then
            return pDat
        end
    end

    -- Load the aura emitters and textures
    for  _,i in ipairs{1,2,3,4,5,6,7,"starman","megashroom"}  do

        -- Emitters
        local emPathList = costumeTable.powerupParticlesNames[i]

        if  emPathList ~= nil  then
            local emList = {}
            local resolved

            for  _,v in ipairs(emPathList)  do
                resolved = Misc.resolveFile(pathPrefix .. "/" .. v ..".ini")

                local em = particles.Emitter(0,0, resolved)
                em:Attach(playerObj)
                em.enabled = false
                table.insert(emList, em)
            end

           pDat.powerupEmitters[i] = emList
        end
    end


    pDat.Pose = function (self, state, priority)
        self.posing = true
        self.inst:startState {state=state, priority=priority  or  3, commands=true}
    end
    pDat.Unpose = function (self)
        self.posing = false
        self.idleAnimCounter = 0
        self.inst:startState {state=idle, priority=999, commands=true}
        self.inst.animPriority = -1
    end

    --[[ Talk args:
        - text           (string)   the line of dialogue to call a message box with
        - calls a2xt_message.showMessageBox and passes in the arguments for this function
    --]]
    pDat.Talk = function (self, args)
        local n = table.clone(args)
        n.target = self.p
        --return message.showMessageBox (n)
    end

    pDat.Emote = function (self, icon)
        if  icon == nil  then
            icon = "blank"
        end
        --emote[icon](self.p, self.costume.namespace.talkOffsetY)
    end

    pDat.LookAt = function(self, target)

        -- If only a number is given, assume it's a coordinate;  otherwise, assume it's an object with an x value
        local destX = target
        if  type(target) ~= "number"  then
            destX = target.x
        end

        -- Error if no valid point to look at, otherwise face that direction
        if  type(destX) ~= "number"  then
            error("attempting to LookAt an object without a valid x coordinate")
        else
            if  self.p.x > destX  then
                self.p.direction = DIR_LEFT
            elseif  self.p.x < destX  then
                self.p.direction = DIR_RIGHT
            end
        end
    end

    pDat.GetWalkDir = function(self, counterSpinjump)
        local dir
        local spinjumpCheck = false

        if  (self.p.keys.left == KEYS_DOWN  and  self.p.keys.right == KEYS_DOWN)
        or  self.p.keys.left == KEYS_UP  and  self.p.keys.right == KEYS_UP  then
            spinjumpCheck = true

        elseif  self.p.keys.left == KEYS_DOWN  then
            dir = -1
        
        elseif  self.p.keys.right == KEYS_DOWN  then
            dir = 1
        
        elseif  self.p.speedX ~= 0  then
            dir = math.sign(self.p.speedX)
        
        else
            spinjumpCheck = true
        end

        if  spinjumpCheck  then
            if  counterSpinjump and self.p:mem(0x50, FIELD_BOOL)  then
                dir = self.lastWalkInput
            else
                dir = self.p.direction
            end
        end


        return dir
    end

    pDat.RefreshBlockCheckHitbox = function(self)
        self.blockCheckBox.width = self.p.width+2
        self.blockCheckBox.height = self.p.height+2
        self.blockCheckBox.x = self.p.x-1
        self.blockCheckBox.y = self.p.y-1
    end
    pDat.GetTouchingBlocks = function(self, ids)
        self:RefreshBlockCheckHitbox()
        return Colliders.collideBlock(self.blockCheckBox, ids, self.p.section)
    end

    pDat.CenterEmitter = function(self, em, offset)
        offset = offset  or  vector.zero2

        local p = self.p
        em.x = p.x+0.5*p.width + offset.x
        em.y = p.y+0.5*p.height + offset.y

        -- Adjustments if in clown car
        if  p.mount == MOUNT_CLOWNCAR  then
            em.y = em.y - 72
        end
    end

    players[playerObj] = pDat

    -- Blank the character
    if  not isOverworld  then
        blankOutCharacter(costDat.baseCharID)
    end

    return pDat
end

function ep3Playables.cleanup(p, characterInfo, costume)
    --Misc.dialog("Cleaning up a costume for "..characterInfo.name)

    -- Unlink objects, then remove the player data from the table
    local pDat = players[p]
    if  pDat ~= nil  then
        pDat.inst = nil
        pDat.costume = nil
        storedPower[p] = pDat.powerup
        players[p] = nil
    end
end


-- Forced/frame state-specific functions
local function climbSpeedFunc(p,v)
    return math.min(1, math.max(math.abs(p.speedX),math.abs(p.speedY)))
end

local function getWarpInfo(p)
    local warpUsed = Warp.get()[p:mem(0x15E, FIELD_WORD)]
    local wdir = nil
    if  warpUsed.warpType == 1  then
            wdir = warpUsed.exitDirection
        if  p.forcedTimer == 0  then
            wdir = warpUsed.entranceDirection
        end
    end

    return {obj=warpUsed, type=warpUsed.warpType, dir=wdir}
end

local function warpStateFunc(p,v)
    local state = "twirl"
    local isCarrying = (p.holdingNPC ~= nil  and  p.holdingNPC ~= 0)
    
    local info = getWarpInfo(p)
    v.swimCounter = 0
    v.idleAnimCounter = 0
    v.kickTimer = 0

    if  info.type == 1  then
        if  info.dir == 2  or  info.dir==4  then  --left or right
            if  isCarrying  then
                state = "walk"--"walk_hold"
            else
                state = "walk"
            end
        elseif  isCarrying  then
            state = "front"
        end
    end

    return state;
end

local function warpZFunc(p,v)
    local z = -70
    local isCarrying = (p.holdingNPC ~= nil  and  p.holdingNPC ~= 0)
    local info = getWarpInfo(p)

    if  isCarrying  and  info.type == 1  and  (info.dir == 1  or  info.dir == 3)  then
        z = -71
    end
    return z;
end

local function warpSpeedFunc(p,v)
    local speed = 2
    local isCarrying = (p.holdingNPC ~= nil  and  p.holdingNPC ~= 0)
    local info = getWarpInfo(p)

    if  isCarrying  and  info.type == 1  then
        speed = 1
    end

    if  p.powerup == 1  and  info.type == 1  then
        speed = 1
    end
    return speed;
end

local stateMapProps = {
    addScaled = {"x", "y"},
    add = {},
    set = {"speed", "z", "scale"}
}

local frameStateMap = {
    all = {
        [0] = {state="statue"},
        [22] = {state="pluck"},
        [23] = {state="pluck"},
        [24] = {state="slide"},
        [25] = {state="climb", speed=climbSpeedFunc},
        [26] = {state="climb", speed=climbSpeedFunc},
        [30] = {state="ride2", y=-4}, -- x=-3, y=-8 proper offesets, but only when facing right
        [31] = {state="ride", y=-6} -- x=-2, y=-8 proper offesets, but only when facing right
    },

    anybig = {
        [6] = {state="skid"},
        [7] = {state="duck"},
    },

    [1] = {
        [4] = {state="skid"}
    },
    [2] = {},
    [3] = {
        [11] = {state="throw"},
        [12] = {state="throw"},
    },
    [4] = {},
    [5] = {},
    [6] = {
        [11] = {state="throw"},
        [12] = {state="throw"},
    },
    [7] = {
        [11] = {state="throw"},
        [12] = {state="throw"},
    }
}

local yoshiFrameBobMap = {
    0,1,2,0,6,6,6,
    0,1,2,0,6,6,6
}
local yoshiWingMap = {
    0,0,0,0,8,8,8,
    0,0,0,0,8,8,8
}


local forcedStateMap = {
    
    -- Power up to big
    [1] = {state="twirl", speed=3},
    
    -- Power up to
    [4] = {state="twirl", speed=3}, --fire
    [5] = {state="twirl", speed=3}, --leaf
    [11] = {state="twirl", speed=3}, --tanooki
    [12] = {state="twirl", speed=3}, --hammer
    [41] = {state="twirl", speed=3}, --ice
    
    -- Power down to small
    [2] = {state="hurt", speed=2
        --[[
        x=function(p,v)
            if  v.lastPowerup > 2  then
                return -2
            else
                return 0
            end
        end,
        y=function(p,v)
            Text.print(v.lastPowerup, 20,20)
            if  v.lastPowerup > 2  then
                return 20
            else
                return 0
            end
        end
        --]]
    },
    
    -- Power down from fire/ice to big (only applies to peach/toad/link but still gonna include them for the heck of it)
    [227] = {state="hurt", speed=2},
    [228] = {state="hurt", speed=2},


    -- Megashroom
    [499] = {state="mega", speed=3, scale=function(p,v)
        local startCount = lunatime.tick() - v.megaStartFrame
        local endCount = lunatime.tick() - v.megaEndFrame
        local changeDuration = 95

        if  startCount < changeDuration+8  then
            v.megaShrinking = false
            return math.lerp(2,v.maxScale, math.min(startCount,changeDuration)/changeDuration)
        else
            if  v.megaShrinking == false  then
                v.megaShrinking = true
                v.megaEndFrame = lunatime.tick()
            end
            return math.lerp(v.maxScale,2, math.min(endCount,changeDuration)/changeDuration)
        end
    end},

    -- Warps
    [3] = {state=warpStateFunc, speed=warpSpeedFunc, z=warpZFunc},
    [7] = {state="turnback", speed=2}
}



local reserveHPIDs = {
    [9] = true,
    [184] = true,
    [185] = true,
    [250] = true
}
local forcedStatePowerups = {
    [1] = 2, --big
    [2] = 1, --small
    [4] = 3, --fire
    [5] = 4, --leaf
    [11] = 5, --tanooki
    [12] = 6, --hammer
    [41] = 7, --ice
    [227] = 2, -- big when using kood/raocow/sheath
    [228] = 2 -- big when using kood/raocow/sheath
}


function ep3Playables.onTickEnd()
    for  p,pDat in pairs(players)  do
        
        -- Override reserve system
        if  reserveHPIDs[p.reservePowerup]  and  pDat.hp < 3  then
            p.reservePowerup = 0
            pDat.hp = math.min(3, pDat.hp + 1)
        end

        if  p.reservePowerup > 0  then
            pDat.reserveItem = p.reservePowerup
            p.reservePowerup = 0
        end

        -- Override HP/powerup system
        if  p.forcedState == 0  then
            if  p.powerup > 2  then
                pDat.powerup = p.powerup
            end

            p.powerup = 2
        
        else
            local newPowerup = forcedStatePowerups[p.forcedState]
            if pDat.costume.keepPowerupOnHit and p.forcedState == 2 then
                newPowerup = pDat.powerup
            end
            pDat.powerup = newPowerup  or  pDat.powerup
        end

        -- Refresh block check hitbox
        pDat:RefreshBlockCheckHitbox()

        -- Keep track of the last horizontal arrow key pressed
        local hInput = 0
        if  p.keys.left == KEYS_DOWN  then
            hInput = hInput-1
        end
        if  p.keys.right == KEYS_DOWN  then
            hInput = hInput+1
        end
        if  hInput ~= 0  then
            pDat.lastWalkInput = hInput
        end

        -- Death effects
        for  k,v in ipairs(Effect.get(pDat.costume.deathEffectId))  do
            v.width = pDat.costume.deathEffectImage.width
            v.height = pDat.costume.deathEffectImage.height
        end
    end
    
    -- for  _,v in ipairs(NPC.get())  do
    --     local isProjectile = v:mem(0x136, FIELD_BOOL)
    --     local culprit = v:mem(0x132, FIELD_WORD)
    --     local culpritObj = Player.get()[culprit]

    --     if  NPC.config[v.id].isshell  or  v.id == 45  or  v.id == 263  then
    --         v.data.ep3Playables = v.data.ep3Playables  or  {playerKicked = false}
    --         local data = v.data.ep3Playables
            
    --         if  isProjectile  then
    --             if  culprit ~= nil  and  culprit ~= 0  and  not data.playerKicked  then
    --                 data.playerKicked = true
                    
    --                 local plTable = players[culpritObj] 
    --                 if  plTable ~= nil  then
    --                     plTable.kickTimer = 10
    --                 end
    --             end
    --         else
    --             data.playerKicked = false
    --         end
    --     end
    -- end
end

function ep3Playables.onPlayerHarm(eventToken, harmedPlayer)
    if  harmedPlayer.hasStarman  then
        eventToken.cancelled = true
        return
    end

    local pDat = players[harmedPlayer]

    if  pDat ~= nil  then
        if   pDat:GetTouchingBlocks(1151)
        and  pDat.powerup == 7  then
            eventToken.cancelled = true
        end
    end
end
function ep3Playables.onPostPlayerHarm(harmedPlayer)
    local pDat = players[harmedPlayer]

    if  pDat ~= nil  then
        pDat.hp = pDat.hp - 1
        if (not pDat.costume.keepPowerupOnHit) then
            pDat.powerup = 2
        end

        
        -- Almost dead warning
        if  pDat.hp == 1  then

            
        -- Dead
        elseif  pDat.hp <= 0  then
            harmedPlayer:kill()
        end
    end
end


function ep3Playables.onInputUpdate()

    for  p,v in pairs(players)  do

        -- Per-costume input behavior
        if  v.inputEvent ~= nil  then
            v:inputEvent(p)
        end
    end
end

function ep3Playables.onDraw()

    local k = 1
    for  p,v in pairs(players)  do
        
        -- Character and costume check
        local charDat = characterData[v.costume.baseCharID]
        local costDat = v.costume
        if p.character == v.costume.baseCharID then-- Initialize the instance
            if  v.inst == nil  then
                if costDat.scaleDisabled then
                    v.inst = costDat.set:Instance{x=0,y=0, xScale=1, scale=1, state="idle", yAlign=animatx.ALIGN.BOTTOM, sceneCoords=false, visible=true}
                else
                    v.inst = costDat.set:Instance{x=0,y=0, xScale=1, scale=2, state="idle", yAlign=animatx.ALIGN.BOTTOM, sceneCoords=false, visible=true}
                end
            end
    
            local inst = v.inst
            local screen = p.screen
            
            inst.z = v.priorityOverride  or  -25
    
            if  not v.fixedDirection  then
                inst.xScale = -p.direction
            end
    
            if  not v.posing  then
                inst.speed = 1
            end
    
            if  not v.transformable  then
                inst.x = screen.left + 0.5*p.width
                inst.y = screen.bottom + 2
                inst.angle = 0
                if costDat.scaleDisabled then
                    inst.scale = v.scaleOverride or 1
                else
                    inst.scale = v.scaleOverride or 2
                end
                if  p.forcedState ~= 2  then
                    v.lastPowerup = p.powerup
                end
            end
    
            if  p.isMega  then
                v.maxScale = math.max(v.maxScale, 2*(p.width/v.width))
                if  v.megaStartFrame < lunatime.tick() - 5  then
                    if costDat.scaleDisabled then
                        inst.scale = 1*(p.width/v.width)
                    else
                        inst.scale = 2*(p.width/v.width)
                    end
                end
            else
                v.megaStartFrame = lunatime.tick()
            end
    
            local isGrounded = p:isGroundTouching()  or  v.groundedOverride
            local isHoldingFlight = not p:mem(0x174, FIELD_BOOL)
            local isCarrying = (p.holdingNPC ~= nil  and  p.holdingNPC ~= 0)
            local isDucking = p:mem(0x12E, FIELD_BOOL)
            local isSpinjumping = p:mem(0x50, FIELD_BOOL)
            local isRainbowRiding = p:mem(0x44, FIELD_BOOL) 
            local isPSpeed = (p:mem(0x168, FIELD_FLOAT) >= charDat.runTotal)--math.abs(p.speedX) >= Defines.player_runspeed
            local canFly = p:mem(0x16E, FIELD_BOOL)
            local isFlying = p:mem(0x16E, FIELD_BOOL)  and  isHoldingFlight
            local isStatue = p:mem(0x4A, FIELD_BOOL)
            local isFairy = p:mem(0x0C,FIELD_BOOL)
            local yoshiBodyFrame = p:mem(0x7A, FIELD_WORD)+1
            local isGliding = isHoldingFlight  and  (p.powerup == 4  or  p.powerup == 5)  and  (p.frame == 3  or  p.frame == 5  or  p.frame == 11)
            if  not isSpinjumping then
                v.spinStartDir = -p.direction
            end
    
            inst.visible = ((p.forcedState ~= 8
                             and  not p:mem(0x142, FIELD_BOOL) -- not blinking
                             --and  not p:mem(0x0C, FIELD_BOOL)  -- not fairy
                             and  p.deathTimer <= 0)
                        or   p.forcedState == 499
                        or   p.isMega)
                        and  v.visible
    
            spintrail.visible = v.visible
    
    
            -- get frame-specific or forced state-specific animation info
            local stateInfo
    
            if  frameStateMap.all[p.frame] ~= nil  then
                stateInfo = frameStateMap.all[p.frame]
    
            elseif  frameStateMap.anybig[p.frame] ~= nil  and  p.powerup > 1  then
                stateInfo = frameStateMap.anybig[p.frame]
    
            elseif  frameStateMap[p.powerup][p.frame] ~= nil  then
                stateInfo = frameStateMap[p.powerup][p.frame]
    
            elseif  p.forcedState > 0  and  forcedStateMap[p.forcedState] ~= nil  then
                stateInfo = forcedStateMap[p.forcedState]
            end
    
    
            -- Animation counters
            v.swimCounter = math.max(0, v.swimCounter - 1)
    
            if  p.speedX ~= 0  or  not isGrounded  or  stateInfo ~= nil  then
                v.idleAnimCounter = 0
            else
                v.idleAnimCounter = v.idleAnimCounter + 1
            end
            
            --P-Speed Run. recycles the raccoon/tanooki run count address while it's not being used.
            if (p.powerup ~= 4 or p.powerup ~= 5) and p:mem(0x36, FIELD_WORD) == 0 and p:mem(0x06, FIELD_WORD) == 0 and p.mount == MOUNT_NONE then
                if  isGrounded  and  math.abs(p.speedX) >= Defines.player_runspeed  then
                    p:mem(0x168, FIELD_FLOAT, p:mem(0x168, FIELD_FLOAT) + 1)
                    if p:mem(0x168, FIELD_FLOAT) >= charDat.runTotal then
                        p:mem(0x168, FIELD_FLOAT, charDat.runTotal)
                    end
                else
                    if not (math.abs(p.speedX) >= Defines.player_runspeed) then
                        p:mem(0x168, FIELD_FLOAT, p:mem(0x168, FIELD_FLOAT) - 0.3)
                    end
                    if p:mem(0x168, FIELD_FLOAT) < 0 then  p:mem(0x168, FIELD_FLOAT, 0) end
                end
            end
    
            -- Clear the queue when it isn't needed
            if  not isFlying  and  not isGliding  then
                inst:clearQueue()
            end
    
    
            -- Yoshi adjustments
            if  p.mount == MOUNT_YOSHI  then
                inst.y = inst.y + yoshiFrameBobMap[yoshiBodyFrame]
            end
    
            -- Clown car adjustments
            if  p.mount == MOUNT_CLOWNCAR  then
                inst.z = -35
            end
    
    
            -- Per-costume animation behavior
            local usingSpecificAnimBehavior
            if  v.animEvent ~= nil  then
                usingSpecificAnimBehavior = v:animEvent(p, inst)
            end
    
    
            -- Non-costume-specific animation
            if  not usingSpecificAnimBehavior  then
            
                -- Apply frame-specific or forced animation states
                if  stateInfo ~= nil  then
    
                    local stVal = stateInfo.state
                    if  type(stateInfo.state) == "function"  then
                        stVal = stateInfo.state(p,v)
                    end
                    inst:startState {state=stVal, commands=true}
    
                    for  _,v2 in ipairs(stateMapProps.add)  do
                        if  type(stateInfo[v2]) == "function"  then
                            inst[v2] = inst[v2] + stateInfo[v2](p,v)
                        else
                            inst[v2] = inst[v2] + (stateInfo[v2]  or  0)
                        end
                    end
                    for  _,v2 in ipairs(stateMapProps.addScaled)  do
                        if  type(stateInfo[v2]) == "function"  then
                            inst[v2] = inst[v2] + stateInfo[v2](p,v)
                        else
                            inst[v2] = inst[v2] + (stateInfo[v2]  or  0)*inst.scale
                        end
                    end
                    for  _,v2 in ipairs(stateMapProps.set)  do
                        if  type(stateInfo[v2]) == "function"  then
                            inst[v2] = stateInfo[v2](p,v)
                        else
                            inst[v2] = (stateInfo[v2]  or  inst[v2])
                        end
                    end
    
    
                -- Fairy handling
                elseif  isFairy  then
                    local degrees = v.fairyDir
                    local roundedDegrees = v.fairyDirRounded
                    if  math.abs(p.speedX) >= 1  or  math.abs(p.speedY) >= 1  then
                        local dirVector = vector(p.speedX,p.speedY)
                        degrees = math.deg(math.atan2(dirVector.y,dirVector.x))
                        roundedDegrees = math.ceil((degrees/45) - 0.5) * 45
                        v.fairyDir = degrees
                        v.fairyDirRounded = roundedDegrees
                    end
    
                    --Text.print(tostring(degrees),20,20)
                    --Text.print(tostring(roundedDegrees),20,40)
    
                    if  degrees < 0  then
                        degrees = degrees+360
                        roundedDegrees = roundedDegrees+360
                    end
    
                    --Text.print(tostring(degrees),20,80)
                    --Text.print(tostring(roundedDegrees),20,100)
    
                    inst.xScale = 1
                    inst:startState {state="rocket-"..tostring(math.abs(roundedDegrees)), commands=true}
                    inst.y = inst.y+32
    
                    if  roundedDegrees == 135  then
                        degrees = degrees-45
                    end
                    if  roundedDegrees == 90  and  degrees > 90  then
                        inst.x = inst.x + 4*math.invlerp(90,135,degrees)
                    end
                    inst.angle = math.rad(degrees-roundedDegrees)
    
    
    
                -- Non-yoshi mount animations
                elseif  p.mount ~= MOUNT_NONE  then
    
                    if  p.mount == MOUNT_CLOWNCAR  then
                        inst.y = screen.top + 24
                    end
                    if  p.mount ~= MOUNT_YOSHI  then
                        if  isDucking  then
                            inst:startState {state="duck", commands=true}
                        else
                            if  isCarrying  then
                                inst:startState {state="idle_hold", commands=true}
                            elseif  v.idleAnimCounter > 64  and  v.canIdleAnim  then
                                inst:startState {state="fidget", commands=true}
                            else
                                inst:startState {state="idle", commands=true}
                            end
    
                            if  p.powerup == PLAYER_SMALL  then
                                inst.y = inst.y-16
                            end
                        end
                    end
    
                -- Shell-kicking
                elseif  v.kickTimer > 0  and  not isCarrying  then
                    v.kickTimer = v.kickTimer-1
                    --Text.print(v.kickTimer, 20, 20)
                    inst:startState {state="idle", commands=true}
    
                -- Tail spin animation
                elseif  p:mem(0x164, FIELD_WORD) > 0  then
                    inst.speed = 2
                    local args = {state="tailswipe", commands=true}
    
                    if  isSpinjumping  then
                        args.state = "twirl"
                        inst.xScale = v.spinStartDir
                        inst.speed = 3
                    end
                    if  p.keys.run == KEYS_PRESSED  and  v.tailRelease == true  then
                        v.tailRelease = false
                        args.force = true
                    end
                    if  p.keys.run == KEYS_UNPRESSED  then
                        v.tailRelease = true
                    end
    
                    inst:startState (args)
    
                -- Water animations
                elseif  p:mem(0x36, FIELD_BOOL)  and  not isCarrying  and  not isGrounded  then
                    --Text.print(p:mem(0x36, FIELD_WORD), 20,20)
                    if  p:mem(0x38, FIELD_WORD) > 0  then
                        v.swimCounter = 30
                    end
    
                    if  v.swimCounter > 0  then
                        --inst.speed=1.5
                        inst:startState {state="swim", commands=true}
                        inst.y = inst.y + 2*inst.scale
                    else
                        inst:startState {state="swim2", commands=true}
                        inst.y = inst.y + 2*inst.scale
                    end
    
    
                -- Air animations
                elseif  not isGrounded  then
    
                    -- Flying/gliding
                    if  isFlying  then
                        inst.speed = 2
                        inst:startState {state="fly", commands=true}
    
                    elseif  isGliding  then
                        inst.speed = 2
                        inst:startState {state="glide", commands=true}
    
                    elseif  isSpinjumping then
                        inst:startState {state="spinjump", commands=true}
                        inst.xScale = v.spinStartDir
                        inst.speed = 3
    
                    elseif  p.speedY > 0 and not canFly then
                        inst:startState {state="fall", commands=true}
                        inst.speed = 4
                    elseif not canFly then
                        inst:startState {state="jump", commands=true}
                        inst.speed = 4
                    end
    
    
    
                -- Ground animations
                elseif  not v.posing  then
    
                    if  p.speedX ~= 0 then
                        local spX = math.abs(p.speedX)
                        inst.speed = spX/3
                        local stateName
    
                        if  (p.keys.run == true  and  spX > 3)
                        or  (p.isMega  and  spX > 2)
                        then
                            stateName = "run"
                        elseif  v.groundedOverride  or  (p.speedX == 0.2*p.direction  and  p.speedY == 0)  then
                            if  v.idleAnimCounter > 64  and  v.canIdleAnim  then
                                stateName = "fidget"
                            else
                                stateName = "idle"
                            end
                        else
                            stateName = "walk"
                            inst.speed = 2*spX/3
                        end
                        
                        inst:startState {state=stateName, commands=true}
    
                    else
                        -- Shell surfing
                        if isRainbowRiding then
                            inst:startState {state="twirl", commands=true}
                            inst.xScale = p.standingNPC.direction
                            inst.speed = 2
                        elseif  p.keys.up == KEYS_DOWN  then
                            inst:startState {state="lookup", commands=true}
                        else
                            inst:startState {state="idle", commands=true}
                        end
                    end
                end
            end
    
    
            -- Cropping and rendering
            local cbounds = v.crop.bounds
            cbounds.left = 0
            cbounds.right = 800
            cbounds.top = 0
            cbounds.bottom = 600
    
            if  p.forcedState == 3  then
                local warpUsed = Warp.get()[p:mem(0x15E, FIELD_WORD)]
                if  warpUsed.warpType == 1  then
    
                    -- Get entrance/exit bounds
                    local wdir = warpUsed.exitDirection
                    local wx1 = warpUsed.exitX
                    local wy1 = warpUsed.exitY
                    local ww = warpUsed.exitWidth
                    local wh = warpUsed.exitHeight
                    if  p.forcedTimer == 0  then
                        wdir = warpUsed.entranceDirection
                        wx1 = warpUsed.entranceX
                        wy1 = warpUsed.entranceY
                        ww = warpUsed.entranceWidth
                        wh = warpUsed.entranceHeight
                    end
                    wx1 = wx1-camera.x
                    wy1 = wy1-camera.y
    
                    local wx2 = wx1+ww
                    local wy2 = wy1+wh
    
    
                    -- Crop based on warp bounds
                    if      wdir == 1  then  --up
                        cbounds.top = wy1
                    elseif  wdir == 2  then  --left
                        cbounds.left = wx1
                    elseif  wdir == 3  then  --down
                        cbounds.bottom = wy2
                    else                     --right
                        cbounds.right = wx2
                    end
    
                    -- Reset kick timer
                    v.kickTimer = 0
                end
    
            -- Riding in a vehicle
            elseif  p.mount == MOUNT_BOOT  then
                cbounds.bottom = screen.bottom - 30
            
            elseif  p.mount == MOUNT_CLOWNCAR  then
                cbounds.bottom = screen.top
            end
    
            local x1 = cbounds.left
            local y1 = cbounds.top
            local x2 = cbounds.right
            local y2 = cbounds.bottom
    
            local w = x2-x1
            local h = y2-y1
    
    
            -- If the player has starman invincibility, apply that shader...
            local drawArgs = {target=v.crop.buffer}
            if  p.hasStarman  then
                if(type(starmanShader) == "string") then
                    local s = Shader();
                    s:compileFromFile(nil, starmanShader);
                    starmanShader = s;
                end
    
                drawArgs.shader = starmanShader
                drawArgs.uniforms = {time = lunatime.tick()*2}
            
            -- ...otherwise, use the aura shader 
            else
                drawArgs.shader = powerupShader
                drawArgs.uniforms = {
                    iPalette = costDat.paletteTexture,
                    iPaletteDimensions = costDat.paletteDimensions,
                    iPaletteOffsetX = v.paletteOverride  or  v.paletteOffset  or  v.powerup
                }
            end
    
    
            -- Draw the player to the crop buffer
            v.crop.buffer:clear(100)
            drawArgs.z = -150
            inst:update(drawArgs)
    
            -- Fix Yoshi wings
            if  p:mem(0x66, FIELD_BOOL)  and  p.mount ~= MOUNT_NONE  then
                v.wingSprite.x = screen.left + 0.5*p.width - 12*p.direction + 16
                v.wingSprite.y = screen.bottom - 30 + yoshiWingMap[yoshiBodyFrame] - 24
                v.wingSprite:draw{
                    frame = p:mem(0x6A, FIELD_WORD)+1,
                    sceneCoords = false,
                    priority = -drawArgs.z,
                    target = v.crop.buffer
                }
            end
    
            -- Debugging
            --[[
                Graphics.drawScreen{priority=inst.z, texture=v.crop.buffer, color=Color(1,1,1,0.25)}
                Graphics.drawBox{
                    x=screen.left, y=screen.top,  --x = x1, y = y1,
                    width = screen.right-screen.left, --width = w,
                    height = screen.bottom-screen.top, --height = h,
    
                    sourceX = x1, sourceY = y1,
                    sourceWidth = w, sourceHeight = h,
    
                    priority=0, color=Color(1,1,1,0.25),
                    sceneCoords=false
                }
            --]]
    
    
            -- Draw the crop buffer to the post-process buffer
            v.postProcessBuffer:clear(100)
            Graphics.drawBox{
                x = x1, y = y1,
                width = w,
                height = h,
    
                sourceX = x1, sourceY = y1,
                sourceWidth = w, sourceHeight = h,
    
                priority=-140, texture=v.crop.buffer,
                target=v.postProcessBuffer,
                sceneCoords=false
            }
    
    
            -- Draw end event
            if  v.drawEndEvent ~= nil  then
                v:drawEndEvent(p)
            end
    
    
            -- Draw the post-process buffer
            Graphics.drawBox{
                x=camera.x, y=camera.y,
                width=800, height=600,
                
                sourceX=0, sourceY=0,
                sourceWidth=800, sourceHeight=600,
                sceneCoords = true,
    
                texture=v.postProcessBuffer,
                priority=inst.z,
            }
    
    
            -- Draw the powerup aura emitters
            for  _,i in ipairs{1,2,3,4,5,6,7,"starman","megashroom"}  do
                local emList = v.powerupEmitters[i]
                if  emList ~= nil  then
                    for  _,em in ipairs(emList)  do
                        
                        -- Toggle based on state
                        if  type(i) == "number"  then
                            em.enabled = (type(v.emitterOverride) == "number"  and  v.emitterOverride == i)             or  v.powerup == i
    
                        elseif  i == "starman"  then
                            em.enabled = (type(v.emitterOverride) == "string"  and  v.emitterOverride == "starman")     or  p.hasStarman
                        
                        elseif  i == "megashroom"  then
                            em.enabled = (type(v.emitterOverride) == "string"  and  v.emitterOverride == "megashroom")  or  (p.isMega  and  not v.megaShrinking)
                        end
    
    
                        -- Toggle off if dead or invisible
                        em.enabled = em.enabled  and  p.deathTimer <= 0  and  v.visible  and  p.forcedState ~= FORCEDSTATE_INVISIBLE
    
                        -- Position and priority
                        local priority = inst.z-0.01
                        v:CenterEmitter(em, v.emitterOffsetOverride)
    
                        -- Do the thing
                        em:draw{priority=priority, nocull=true}
                    end
                end
            end
                
    
    
            -- Debug draw counts
            --Text.print(tostring(k) .. ": " .. costDat.name,20,20*k)
            k = k+1
    
            -- Check if the player has died yet
            --Text.print(tostring(v.alreadyDied), 20,20)
        end
            
    end
end



--##########################
--#  HARM AND DEATH STUFF  #
--##########################


-- rooms.lua resets
function ep3Playables.onReset(fromRespawn)
    if  fromRespawn  then
        for  p,pDat in pairs(players)  do
            pDat.hp = 2
            pDat.powerup = 2
        end
    end
end




-- Expose and return
_G["Ep3PlayablesData"] = _G["Ep3PlayablesData"]  or  players;

return ep3Playables;