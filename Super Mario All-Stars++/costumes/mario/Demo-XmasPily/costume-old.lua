local animatx = require("animatx2_xmas2020")
local actorsys = require("a2xt_actor")
local costume = {}
local players = {}
_G["XmasPilyCostumeData"] = players;


local megashroom = require("NPCs/ai/megashroom")
local starman = require("NPCs/ai/starman")

local starmanShader = Misc.multiResolveFile("starman.frag", "shaders\\npc\\starman.frag")


local coyotetime
local ppp
function costume.onInit(playerObj)
    coyotetime = require("coyotetime");
    ppp = require("playerphysicspatch");

    registerEvent(costume, "onStart");
    registerEvent(costume, "onDraw");
    registerEvent(costume, "onInputUpdate");
    registerEvent(costume, "onTickEnd");

    registerEvent(costume, "onPlayerHarm")
    registerEvent(costume, "onPostPlayerHarm")
    registerEvent(costume, "onPlayerLavaBounce")
    registerEvent(costume, "onPlayerLavaDeath")


    player.powerup = 2

    players[playerObj] = {
        hp = 2,
        idleAnimCounter = 0, canIdleAnim = true, fixedDirection = false, posing = false, transformable=false, priorityOverride=nil, swimCounter = 0, megaStartFrame=0, megaEndFrame=0, tailRelease=false, megaShrinking=false, fairyDir=0, fairyDirRounded=0, maxScale=2, 
        width = playerObj.width, height = playerObj.height,
        wingSprite = Sprite{texture=Graphics.sprites.hardcoded["19"].img, frames=4, x=0,y=0, pivot = Sprite.align.CENTER},
        crop = {buffer=Graphics.CaptureBuffer(800,600), bounds={left=0,top=0,right=800,bottom=600}}
    }
end


local sheet = Graphics.loadImageResolved("costumes/mario/Demo-XmasPily/sheet.png")


local function climbSpeedFunc(p,v)
    return math.min(1, math.max(math.abs(p.speedX),math.abs(p.speedY)))
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
        [24] = {state="slide", y=6},
        [25] = {state="climb", speed=climbSpeedFunc},
        [26] = {state="climb", speed=climbSpeedFunc},
        [30] = {state="ride2", y=-4},
        [31] = {state="ride", y=-6},
        [6] = {state="turn"},
        [7] = {state="duck"},
    },

    anybig = {},

    [1] = {
        [4] = {state="turn"}
    },
    [2] = {},
    [3] = {},
    [4] = {},
    [5] = {},
    [6] = {},
    [7] = {}
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
    [1] = {state="twirl", speed=3},
    [4] = {state="twirl", speed=3},
    [5] = {state="twirl", speed=3},
    [11] = {state="twirl", speed=3},
    [12] = {state="twirl", speed=3},
    [41] = {state="twirl", speed=3},

    [499] = {state="twirl", speed=3, scale=function(p,v)
        local startCount = lunatime.tick() - v.megaStartFrame
        local endCount = lunatime.tick() - v.megaEndFrame
        local changeDuration = 48

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

    [2] = {state="startled"},
    [227] = {state="startled"},
    [228] = {state="startled"},

    [3] = {state="twirl", speed=2, z=-70},
    [7] = {state="turnback", speed=2}
}



function costume.onInputUpdate()
    for  p,v in pairs(players)  do

        if  v ~= nil  then

            --[[
            if p:isGroundTouching() and p.forcedState == 0 then

                -- Current frame
                local frame = p:mem(0x114, FIELD_WORD)

                -- Looking up
                if p.speedX == 0 and p.upKeyPressing then

                    -- Standing still
                    if frame == 1 then
                        p:mem(0x114, FIELD_WORD, 32)

                    -- Jumping
                    elseif (frame == 5 and p.powerup == 1) or (frame == 8 and p.powerup ~= 1) then
                        p:mem(0x114, FIELD_WORD, 33)
                    end
                end
            end
            --]]
        end
    end
end
function costume.onTickEnd()
    for  p,v in pairs(players)  do

        if  v ~= nil  then

            --[[
            if p:isGroundTouching() and p.forcedState == 0 then

                -- Current frame
                local frame = p:mem(0x114, FIELD_WORD)

                -- Looking up
                if p.speedX == 0 and p.upKeyPressing then

                    -- Standing still
                    if frame == 1 then
                        p:mem(0x114, FIELD_WORD, 32)

                    -- Jumping
                    elseif (frame == 5 and p.powerup == 1) or (frame == 8 and p.powerup ~= 1) then
                        p:mem(0x114, FIELD_WORD, 33)
                    end
                end
            end
            --]]
        end
    end
end



function costume.onDraw()
    for _,v in ipairs(NPC.get(171)) do
        v.width = 24
    end

    for  p,v in pairs(players)  do
        if  v.inst == nil  then
            v.inst = ACTOR_XMASPILY.actorArgs.animSet:Instance{x=0,y=0, xScale=1, scale=2, state="idle", yAlign=animatx.ALIGN.BOTTOM, image=sheet, sceneCoords=false, visible=true}
            v.spinStartDir = p.direction

            v.Pose = function (self, state, priority)
                self.posing = true
                self.inst:startState {state=state, priority=priority  or  3, commands=true}
            end
            v.Unpose = function (self)
                self.posing = false
                self.idleAnimCounter = 0
                self.inst:startState {state=idle, priority=999, commands=true}
                self.inst.animPriority = -1
            end
        end

        local inst = v.inst
        local screen = p.screen

        inst.z = v.priorityOverride  or  -25

        if  not v.fixedDirection  then
            inst.xScale = -p.direction
        end
        inst.image = sheet
        inst.speed = 1

        if  not v.transformable  then
            inst.x = screen.left + 0.5*p.width
            inst.y = screen.bottom
            inst.angle = 0
            inst.scale = 2
        end

        if  p.isMega  then
            v.maxScale = math.max(v.maxScale, 2*(p.width/v.width))
            if  v.megaStartFrame < lunatime.tick() - 5  then
                inst.scale = 2*(p.width/v.width)
            end
        else
            v.megaStartFrame = lunatime.tick()
        end

        local isHoldingFlight = not p:mem(0x174, FIELD_BOOL)
        local isDucking = p:mem(0x12E, FIELD_BOOL)
        local isSpinjumping = p:mem(0x50, FIELD_BOOL)
        local isFlying = p:mem(0x16E, FIELD_BOOL)  and  isHoldingFlight
        local isStatue = p:mem(0x4A, FIELD_BOOL)
        local isFairy = p:mem(0x0C,FIELD_BOOL)
        local yoshiBodyFrame = p:mem(0x7A, FIELD_WORD)+1
        local isGliding = isHoldingFlight  and  (p.frame == 3  or  p.frame == 5  or  p.frame == 11)
        if  not isSpinjumping  then
            v.spinStartDir = -p.direction
        end

        inst.visible = (p.forcedState ~= 8  and  not p:mem(0x142, FIELD_BOOL)  and  not p:mem(0x0C, FIELD_BOOL)  and  p.deathTimer <= 0)  or  p.forcedState == 499  or  p.isMega  or  isFairy


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

        if  p.speedX ~= 0  or  not p:isGroundTouching()  or  stateInfo ~= nil  then
            v.idleAnimCounter = 0
        else
            v.idleAnimCounter = v.idleAnimCounter + 1
        end


        -- Clear the queue when it isn't needed
        if  not isFlying  and  not isGliding  then
            inst:clearQueue()
        end


        -- Yoshi adjustments
        if  p.mount == MOUNT_YOSHI  then
            inst.y = inst.y + yoshiFrameBobMap[yoshiBodyFrame]
        end


        -- Apply frame-specific or forced animation states
        if  stateInfo ~= nil  then
            inst:startState {state=stateInfo.state, commands=true}

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
                    inst:startState {state="idle", commands=true}
                    if  p.powerup == PLAYER_SMALL  then
                        inst.y = inst.y-16
                    end
                end
            end


        -- Tail spin animation
        elseif  p:mem(0x164, FIELD_WORD) > 0  then
            inst.speed = 4
            local args = {state="tailswipe", commands=true}

            if  player.keys.run == KEYS_PRESSED  and  v.tailRelease == true  then
                v.tailRelease = false
                args.force = true
            end
            if  player.keys.run == KEYS_UNPRESSED  then
                v.tailRelease = true
            end

            inst:startState (args)

        -- Water animations
        elseif  p:mem(0x36, FIELD_BOOL)  then
            --Text.print(p:mem(0x36, FIELD_WORD), 20,20)
            if  p:mem(0x38, FIELD_WORD) > 0  then
                v.swimCounter = 30
            end

            if  v.swimCounter > 0  then
                inst.speed=1.5
                inst:startState {state="swim", commands=true}
                inst.y = inst.y + 5*inst.scale
            elseif  p.speedY <= 0  then
                inst:startState {state="swim2", commands=true}
                inst.y = inst.y + 5*inst.scale
            else
                inst:startState {state="fall", commands=true}
            end


        -- Air animations
        elseif  not p:isGroundTouching()  then

            -- Flying/gliding
            if  isFlying  or  isGliding  then
                inst.speed = 3
                inst:startState {state="glide", commands=true}
            elseif  inst.state == "glide"  and  #inst.queue == 0  then
                inst.speed = 3
                inst:queueState ("fall")

            elseif  isSpinjumping  then
                inst:startState {state="cannonball", commands=true}
                inst.xScale = v.spinStartDir
                inst.speed = 2

            elseif  p.speedY > 0  then
                inst:startState {state="fall", commands=true}
                inst.speed = 1.5
            else
                inst:startState {state="jump", commands=true}
            end


        -- Ground animations
        else
            if  p.speedX ~= 0  then
                local spX = math.abs(p.speedX)
                inst.speed = spX/3

                if  p.keys.run == true  and  spX > 2   then
                    inst:startState {state="run", commands=true}
                else
                    inst:startState {state="walk", commands=true}
                    inst.speed = 2*spX/3
                end
            else
                if  v.posing == false  and  v.canIdleAnim == true  and  v.idleAnimCounter > 130  then
                    inst:startState {state="happy", commands=true}
                else
                    inst:startState {state="idle", commands=true}
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
            end

        -- Riding in a vehicle
        elseif  player.mount == MOUNT_BOOT  then
            cbounds.bottom = screen.bottom - 30
        
        elseif  player.mount == MOUNT_CLOWNCAR  then
            cbounds.bottom = screen.top
        end

        local x1 = cbounds.left
        local y1 = cbounds.top
        local x2 = cbounds.right
        local y2 = cbounds.bottom

        local w = x2-x1
        local h = y2-y1

        local drawArgs = {target=v.crop.buffer}
        if  p.hasStarman  then
            if(type(starmanShader) == "string") then
                local s = Shader();
                s:compileFromFile(nil, starmanShader);
                starmanShader = s;
            end

            drawArgs.shader = starmanShader
            drawArgs.uniforms = {time = lunatime.tick()*2}
        end

        v.crop.buffer:clear(100)
        v.inst:update(drawArgs)

        -- Fix Yoshi wings
        if  p:mem(0x66, FIELD_BOOL)  and  p.mount ~= MOUNT_NONE  then
            v.wingSprite.x = screen.left + 0.5*p.width - 12*p.direction
            v.wingSprite.y = screen.bottom - 30 + yoshiWingMap[yoshiBodyFrame]
            v.wingSprite:draw{
                frame = p:mem(0x6A, FIELD_WORD)+1,
                sceneCoords = false,
                priority = -25,
                target = v.crop.buffer
            }
        end

        --Text.print(tostring(p.forcedState),20,20)
        --Text.print(tostring(p.forcedTimer),20,40)

        -- Debugging
        --[[
            Graphics.drawScreen{priority=inst.z, texture=v.crop.buffer, color=Color(1,1,1,0.25)}
            Graphics.drawBox{
                x = x1, y = y1,
                width = w,
                height = h,

                sourceX = x1, sourceY = y1,
                sourceWidth = w, sourceHeight = h,

                priority=0, color=Color(1,1,1,0.25),
                sceneCoords=false
            }
        --]]



        ---[[
        Graphics.drawBox{
            x = x1, y = y1,
            width = w,
            height = h,

            sourceX = x1, sourceY = y1,
            sourceWidth = w, sourceHeight = h,

            priority=inst.z, texture=v.crop.buffer, --color=Color(1,1,1,0.25)
            sceneCoords=false
        }
        --]]
    end

    --[[
    for _,v in ipairs(Animation.get(3)) do
        v.width = 32;
        v.height = 48;
    end
    --]]
end


function costume.onCleanup(playerObj)
    players[playerObj] = nil
end



return costume;