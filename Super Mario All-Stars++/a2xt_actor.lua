local animDefaults = API.load("base/animdefaults")

local Actor = API.load("actorclass")

local animatx = API.load("animatx2_xmas2020")
local lunajson = API.load("ext/lunajson")
local rng = API.load("rng")
local pman = API.load("playermanager")

--local costumes = API.load("a2xt_costumes")


local a2xt_actor = {}

CHARACTER_NAME = {
                    [CHARACTER_MARIO] = "Demo",
                    [CHARACTER_LUIGI] = "Iris",
                    [CHARACTER_PEACH] = "Kood",
                    [CHARACTER_TOAD]  = "Raocow",
                    [CHARACTER_LINK]  = "Sheath"
                  }

CHARACTER_CONSTANT = {
                        mario=CHARACTER_MARIO,
                        luigi=CHARACTER_LUIGI,
                        peach=CHARACTER_PEACH,
                        toad=CHARACTER_TOAD,
                        link=CHARACTER_LINK,

                        demo=CHARACTER_MARIO,
                        iris=CHARACTER_LUIGI,
                        kood=CHARACTER_PEACH,
                        raocow=CHARACTER_TOAD,
                        sheath=CHARACTER_LINK
                      }

function a2xt_actor.onInitAPI()
    --registerEvent (a2xt_actor, "onTick")
    registerEvent (a2xt_actor, "onDraw")
end



--*************************************
--** Misc utility functions          **
--*************************************
local function getPlayerSettingsOffsets(characterId,state)
    local xOffsets = {}
    local yOffsets = {}

    local pSettings = PlayerSettings.get(characterId,state)

    local i=1
    for  x=0,9  do
        for  y=0,9  do
            xOffsets[i] = pSettings:getSpriteOffsetX(x,y)
            yOffsets[i] = pSettings:getSpriteOffsetY(x,y)
            i = i+1
        end
    end

    return xOffsets,yOffsets
end

local function getPlayerSettingsSize(characterId,state,ducking)
    local pSettings = PlayerSettings.get(characterId,state)
    
    local h
    if ducking then
        h = pSettings.hitboxDuckHeight
    else
        h = pSettings.hitboxHeight
    end
    
    return pSettings.hitboxWidth, h
end

local function getNPCOffsets(npcId)
    return NPC.config[npcId].gfxoffsetx, NPC.config[npcId].gfxoffsety;
end

local function getIsDucking(state)
    return state == "duck" or state == "holdduck"
end

local function eraseNPC(ref) -- Erases the NPC from existence until the player reloads the level
    if  ref ~= nil  and  ref.ai1 ~= nil  then
        ref:mem(0xDC, FIELD_WORD, 0)  -- don't respawn
        ref:mem(0x12A, FIELD_WORD, 0)  -- set offscreen timer to 0
        ref:mem(0x40, FIELD_BOOL, true) -- hide the NPC
        ref:kill(HARM_TYPE_OFFSCREEN) -- despawn the NPC
    end
end



--*************************************
--** Misc class variables and stuff  **
--*************************************
a2xt_actor.groundY = nil

-- Add named references for the player characters' emotive frames to animDefaults
for  k,v in ipairs{CHARACTER_DEMO, CHARACTER_IRIS, CHARACTER_KOOD, CHARACTER_RAOCOW, CHARACTER_SHEATH}  do
    local s = "upset"
    if v == CHARACTER_SHEATH then
        s = "happy"
    end
    animDefaults[v][2] = table.join(animDefaults[v][2],
        {
            victory={49},
            shocked={47},
            sad={46},
            [s]={48}
        }
    )
end


local function dbg(namespace)
    local t = {}
    for k,v in pairs(namespace) do
        if k~= "json" and k~= "actorArgs" and k~= "sequences" then
            t[k] = v
        end
    end
    Misc.dialog(t)
end


--*************************************
--** Extended Actor method functions **
--*************************************
local extMethods, playerRoutines
do
    extMethods = {

        StopFollowing = function (self)
            if  self._walkRoutine ~= nil and self._walkRoutine.isValid  then
                self._walkRoutine:abort()
            end
        end,

        StopWalking = function(self)
            self:StopFollowing()
            self.speedX = 0
        end,


        --[[ Walk args:
            - target     (obj)      if an object with an x value, the actor will walk to this object
            - targetX    (int)      if specified, the actor will walk to this X position
            - precision  (int)      the minimum distance to the target/targetX that the actor must get before it can stop walking
            - follow     (bool)     if true, the actor will continue to follow the target even after arriving at the precision distance
            - speed      (int)      the walk speed;  if walking to a target, this is treated as math.abs(speed), otherwise this directly sets the actor's speedX
            - accel      (number)   if specified, the actor will accelerate and decelerate at this rate;  otherwise, walking starts and stops instantly
            --- anim       (string)   the animation state to use for the walking until the actor becomes airborn;  if not specified, defaults to actor.moveAnims.walk
        --]]
        Walk = function (self, args)
            local isPlayer = type(self) == "Player"
            local isNpc = self.ai1 ~= nil
            local isActor = not isPlayer  and  not isNpc

            -- If only a number is given, assume it's the speed
            if  type(args) == "number"  then
                args = {speed = args}
            end
            
            self:Unpose()

            -- Cancel any active walk routine and animation freezing
            self:StopWalking()
            if  isActor  then
                self.gfx:unfreeze()
            end

            -- Set the walking animation to the new state
            --self:StartState ("walk")

            -- If a target x is specified, make a dummy target with that x coordinate
            local target = args.target
            if  args.targetX ~= nil  then
                target = target  or  {x=args.targetX}
            end

            -- If there is a specific target to walk to, then keep doing so until the target has been reached
            if  target ~= nil  then
                self._walkRoutine = Routine.run(function(args, target)
                    local precision = args.precision  or  16
                    local follow = args.follow
                    local accel = args.accel
                    local speed = math.abs(args.speed)

                    local offset = self.x - target.x
                    local dist = math.abs(offset)
                    local dirMult = offset/dist

                    while  (dist > precision  or  follow)  do
                        offset = target.x - self.x
                        dist = math.abs(offset)
                        dirMult = offset/dist

                        -- If further than the precision, speed up/move
                        if dist > precision  then
                            if  accel ~= nil  and  isActor  then
                                self.accelX = accel
                                self.frictionX = 0
                            else
                                self.speedX = speed * dirMult
                            end

                            if  math.abs(self.speedX) > speed  then
                                self.speedX = math.max(-speed, math.min(speed, self.speedX))
                            end


                        -- If close enough to the target, slow down/stop
                        else
                            if  accel ~= nil  and  isActor  then
                                self.accelX = 0
                                self.frictionX = accel
                            else
                                self.speedX = 0
                            end
                        end

                        -- Set direction
                        if  self.speedX > 0  then
                            self.direction = DIR_RIGHT
                        end
                        if  self.speedX < 0  then
                            self.direction = DIR_LEFT
                        end

                        -- Yield
                        Routine.skip()
                    end
                    self.speedX = 0
                end, args, target)


            -- If a target or targetX was not specified, just start walking in the appropriate direction
            else
                self.speedX = args.speed
            end
        end,

        --[[ Jump args:
            - strength   (number)   the initial speed of the jump
            - gravity    (number)   if specified, changes the actor's gravity
            - state      (string)   if specified, the state to switch to when performing the jump
        --]]
        Jump = function(self, args)
            self.speedY = -args.strength
            local isPlayer = type(self) == "Player"
            local isNpc = self.ai1 ~= nil
            local isActor = not isPlayer  and  not isNpc

            if  isActor  then
                self.accelY = args.gravity  or  self.defaultGravity

                self:Unpose()
                
                if  args.state  then
                    self:StartState{state=args.state, name=self.name}
                end
            end
        end,

        --[[ Talk args:
            - text           (string)   the line of dialogue to call a message box with
            - calls a2xt_message.showMessageBox and passes in the arguments for this function
        --]]

        Pose = function (self, pose, priority)
            if  priority == nil  then  priority = 2;  end;

            local isPlayer = type(self) == "Player"
            local isNpc = self.ai1 ~= nil
            local isActor = not isPlayer  and  not isNpc

            if  isActor  then
                --*Misc.dialog("POSING: "..pose)
                
                self.cachedPose = pose
                self.cachedQueue = nil
                self.gfx:clearQueue ()
                self.gfx:startState {state=pose, force=true, resetTimer=true, commands=true, source="POSE", name=self.name, priority=priority}
                --self.gfx:freeze()
            end
        end,

        QueuePose = function (self, pose, priority)
            if  priority == nil  then  priority = 2;  end;

            local isPlayer = type(self) == "Player"
            local isNpc = self.ai1 ~= nil
            local isActor = not isPlayer  and  not isNpc

            if  isActor  then
                --*Misc.dialog("POSING: "..pose)
                
                self.cachedPose = nil
                self.cachedQueue = true
                self.gfx:queueState(pose)
                --self.gfx:freeze()
            end
        end,

        Unpose = function (self)
            self.gfx.animPriority = -1
            self.cachedPose = nil
            self.cachedQueue = nil
            
            if self.state == "idle" then
                self.gfx:attemptStates ({"idle", "walk", "run"}, {resetTimer=true, commands=true, name=self.name, source="on Unpose"})
            end
            
        end,

        LookAt = function (self, target)
            local isPlayer = type(self) == "Player"
            local isNpc = self.ai1 ~= nil
            local isActor = not isPlayer  and  not isNpc

            -- If only a number is given, assume it's a coordinate;  otherwise, assume it's an object with an x value
            local destX = target
            if  type(target) ~= "number"  then
                destX = target.x
            end

            -- Error if no valid point to look at, otherwise face that direction
            if  type(destX) ~= "number"  then
                error("attempting to LookAt an object without a valid x coordinate")
            else
                if  self.x > destX  then
                    self.direction = DIR_LEFT
                else
                    self.direction = DIR_RIGHT
                end
            end
        end,

        LookAway = function (self, target)
            self:LookAt(target)
            self.direction = -self.direction
        end,

        LookAtPlayer = function (self)
            self:LookAt(player.x + 0.5*player.width)
        end,

        LookAwayPlayer = function (self)
            self:LookAway(player.x + 0.5*player.width)
        end,


        Flip = function (self)
            if  self.direction == DIR_LEFT  then
                self.direction = DIR_RIGHT
            else
                self.direction = DIR_LEFT
            end
        end,

        Ground = function (self)
            if  self.bounds ~= nil  then
                if  self.stayAboveGround ~= false  then
                    self.y = self.bounds.bottom
                else
                    self.y = math.max(self.y, self.bounds.bottom)
                end
            end
        end,

        Land = function (self, animState)
            if  self.bounds ~= nil  and  self.bounds.bottom ~= nil  then
                self:Ground()
                self.speedY = 0
                self.accelY = 0
    
                if  animState ~= nil  then
                    self:Pose(animState)
                end
            end
        end,


        --[[ commented-out functions
        function Actor:HoldProp(obj)
            
        end

        function Actor:RaiseProp(obj)
            
        end

        function Actor:DestroyHeld()
            
        end

        function Actor:DropHeld()
            
        end
        --]]
    }

    for  k,v in pairs(extMethods)  do
        Actor[k] = v
        Player[k] = v
        NPC[k] = v
    end
end



--************************************************
--** Character-specific actor events and fields **
--************************************************
local extData
do
    local vhair = require("actors/verlethair")

    extData = {
        Tam = {
            Key = {
                set = animatx.Set {
                    rows = 4,
                    columns = 2,
                    yAlign = animatx.ALIGN.BOTTOM,
                    sheet = Graphics.loadImage(Misc.resolveFile("graphics/actors/anmx_tam_key.png")),
                    sequences = {
                        normal = "1,2,3,4",
                        tilted = "5,6,7,8"
                    }
                },
                speed = 1
            }
        },
        Pumpernickel = {
            Pupil={
                target = nil,
                lastPosition = vector.v2(0,0),
                eyeCenter = vector.v2(0,0),
                frame = 1,
                clampDistance = true
            },
            SlowTurn = function(self, direction)
                Routine.run(function()
                    if  direction == nil  then
                        direction = self.direction*-1
                    end
                    if  self.direction ~= direction  then
                        self:Pose("turn")
                        Routine.wait(0.125)
                        self.direction = direction
                        self:Pose("idle")
                    end
                end)
            end
        },
        Brisket = {
            Hair = {
                texture = Graphics.loadImage(Misc.resolveFile("graphics/actors/anmx_brisket_hair.png")),
                objects = {},
                attachPoints = {vector.v2(0,0), vector.v2(0,0)},
                z = {},
                anchors = {}
            },
            Leap = function(self, args)
                Routine.run(function()
                    self:Pose("squish")
                    Routine.wait(0.25)

                    self:Jump(args)
                    Routine.waitFrames(2)
                    while not ACTOR_BRISKET.contactDown do
                        Routine.skip()
                    end

                    if  args.quake ~= nil  then
                        Defines.earthquake = args.quake
                    end
                    Routine.signal("brisketDoneLeaping")
                end)
            end,
            SlowTurn = function(self, direction)
                Routine.run(function()
                    if  direction == nil  then
                        direction = self.direction*-1
                    end
                    if  self.direction ~= direction  then
                        self:Pose("turnIn")
                        while  (self.gfx.frame ~= 18)  do
                            Routine.skip()
                        end

                        self.direction = direction
                        self:Pose("turnOut")
                        while  (self.gfx.frame ~= 1)  do
                            Routine.skip()
                        end

                        Routine.signal("brisketDoneTurning")
                    end
                end)
            end
        }
    }


    -- TAM
    extData.Tam.Key.gfx = extData.Tam.Key.set:Instance{x=0,y=0, xScale=1, scale=2, state="normal", sceneCoords=true, visible=false}

    extData.Tam.onGfxEnd = function(self)
        local keyGfx = ACTOR_TAM.Key.gfx

        if  keyGfx ~= nil  then

            keyGfx.visible = self.gfx.visible
            keyGfx.scale = self.gfx.scale
            keyGfx.xScale = self.gfx.xScale
            keyGfx.yScale = self.gfx.yScale
            keyGfx.yAlign = self.gfx.yAlign

            keyGfx.x = self.gfx.x
            keyGfx.y = self.gfx.y
            keyGfx.z = self.gfx.z-0.01

            if  self.gfx.state == "scared"  then
                keyGfx:startState {state="tilted", force=false}
            else
                keyGfx:startState {state="normal", force=false}
            end

            keyGfx:update()
        end
    end


    -- PUMPERNICKEL
    extData.Pumpernickel.Pupil.sprite = Sprite.box {x=0,y=0, width=16,height=16, frames=4, texture=Graphics.loadImage(Misc.resolveFile("graphics/actors/pump_pupil.png")), pivot=Sprite.align.CENTER}
    extData.Pumpernickel.onGfxEnd = function(self)

        -- Layers
        local layers = ACTOR_PUMPERNICKEL.Layers

        if  layers == nil  then
            ACTOR_PUMPERNICKEL.Layers = {}
            for  k,v in ipairs{"aa","eyeball"}  do
                local newGfx = self.gfx.set:Instance{x=0,y=0, xScale=1, scale=2, state="idle", image=Graphics.loadImage(Misc.resolveFile("graphics/actors/anmx_pump_"..v..".png")), sceneCoords=true, visible=false}
                table.insert(ACTOR_PUMPERNICKEL.Layers, newGfx)
            end
            layers = ACTOR_PUMPERNICKEL.Layers
        end

        for  k,v in ipairs(layers)  do

            v.visible = self.gfx.visible
            v.scale = self.gfx.scale
            v.xScale = self.gfx.xScale
            v.yScale = self.gfx.yScale
            v.yAlign = self.gfx.yAlign
            v.frame = self.gfx.frame

            v.x = self.gfx.x
            v.y = self.gfx.y
            v.z = self.gfx.z - 0.02*k

            v:render()
        end

        
        -- Pupil
        if  ACTOR_PUMPERNICKEL.Pupil ~= nil  then
            local pupil = ACTOR_PUMPERNICKEL.Pupil

            if  pupil.target ~= nil  then
                pupil.lastPosition.x = pupil.target.x
                pupil.lastPosition.y = pupil.target.y
            end

            pupil.eyeCenter.x = self.xMid
            pupil.eyeCenter.y = self.yMid - 11 * self.gfx.yScaleTotal
            
            if  self.gfx.frame ~= 1  and  self.gfx.frame ~= 10  then
                pupil.eyeCenter.x = pupil.eyeCenter.x - 8 * self.gfx.xScaleTotal
            end
            if  self.gfx.frame == 3  or  self.gfx.frame == 4  or  self.gfx.frame == 12  or  self.gfx.frame == 13  then
                pupil.eyeCenter.y = pupil.eyeCenter.y - 1 * self.gfx.yScaleTotal
            end
            
            local target = pupil.target  or  pupil.lastPosition
            local targetDistance = vector.v2(target.x-pupil.eyeCenter.x, target.y-pupil.eyeCenter.y)
            local targetDirection = targetDistance:normalize()

            local clampedLength = targetDistance.length
            if  pupil.clampDistance  then
                clampedLength = math.min(clampedLength,400)
            end
            
            local xMult,yMult = 4,3
            if  self.gfx.frame == 1  or  self.gfx.frame == 10  then
                xMult = 10
            end
            
            local eyeOffset = targetDirection * (clampedLength / 400)
            eyeOffset.x = eyeOffset.x * xMult * math.abs(self.gfx.xScaleTotal)
            eyeOffset.y = eyeOffset.y * yMult * math.abs(self.gfx.yScaleTotal)
            
            local pupilPos = pupil.eyeCenter + eyeOffset
            
            if  self.gfx.frame <= 15  and  self.gfx.visible  then
                pupil.sprite.x = pupilPos.x
                pupil.sprite.y = pupilPos.y
                pupil.width = 16*self.gfx.xScaleTotal
                pupil.height = 16*self.gfx.yScaleTotal
                pupil.sprite:draw{sceneCoords=true, frame=pupil.frame, priority=self.gfx.z-0.01}
            end
        end
    end


    -- BRISKET
    extData.Brisket._refreshAttachPoints = function(self)
        local gfx = self.gfx
        local Hair = ACTOR_BRISKET.Hair

        if  gfx ~= nil  and  gfx.visible  then

            -- Determine attach points and z values depending on animation frame
            local mid = vector.v2(self.xMid, self.yMid)
            local mirroredOffset = vector.v2(14, 18)
            local forwardOffsetX = 0
            local z1 = -0.1
            local z2 = 0.1

            if  gfx.frame == 9  or  gfx.frame == 10  then
                forwardOffsetX = -1
            end
            if  gfx.frame >= 12  and  gfx.frame <= 14  then
                mirroredOffset.y = 16
                forwardOffsetX = -2
            end
            if  gfx.frame >= 15  and  gfx.frame <= 17  then
                forwardOffsetX = -2
                mirroredOffset.y = 15
            end
            if  gfx.frame == 18  then
                mirroredOffset.x = 20
                mirroredOffset.y = 15
                z2 = -0.1
            end

            Hair.attachPoints[1] = mid + vector.v2(-gfx.xScaleTotal*(mirroredOffset.x + forwardOffsetX), gfx.yScaleTotal*mirroredOffset.y-4)
            Hair.attachPoints[2] = mid + vector.v2(gfx.xScaleTotal*(mirroredOffset.x + forwardOffsetX), gfx.yScaleTotal*mirroredOffset.y-4)
            Hair.z[1] = self.z + z1
            Hair.z[2] = self.z + z2

        else
            for  i=1,2  do
                Hair.attachPoints[i] = vector.v2(0,0)
                Hair.z[i] = 0
            end
        end
    end

    extData.Brisket.onTick = function(self)

        -- Refresh the attach points and update the strands
        if  #ACTOR_BRISKET.Hair.objects > 0  then
            ACTOR_BRISKET:_refreshAttachPoints()

            for  i=1,2  do
                ACTOR_BRISKET.Hair.objects[i]:update()
            end
        end
    end

    extData.Brisket.onGfxEnd = function(self)
        local gfx = self.gfx
        local Hair = ACTOR_BRISKET.Hair

        if  gfx ~= nil  and  gfx.visible  then

            -- Refresh the attach points
            ACTOR_BRISKET:_refreshAttachPoints()

            -- Get the ground Y
            local groundYVal = a2xt_actor.groundY
            if  self.bounds ~= nil  and  self.bounds.bottom ~= nil  then
                groundYVal = self.bounds.bottom
            end


            for  i=1,2  do
                local obj = Hair.objects[i]
                
                -- Initialize the hair objects if they don't exist
                if  obj == nil  then

                    -- Create
                    Hair.objects[i] = vhair.Hair(Hair.attachPoints[i], vector.v2((-2*i)+3,-1), Hair.texture, groundYVal-8)
                    obj = Hair.objects[i]

                    -- Prewarm
                    --for  k=1,100  do
                    --    obj:update()
                    --end
                end

                -- Update attach points
                obj.x = Hair.attachPoints[i].x
                obj.y = Hair.attachPoints[i].y

                -- Draw
                obj:draw(Hair.z[i])
            end


        -- Wipe the hair objects when invisible or the Actor isn't active
        else
            Hair.objects[1] = nil
            Hair.objects[2] = nil
        end
    end
end



--****************************
--** Namespace pseudoclass  **
--****************************
local Namespace = {}   -- class object
local NamespaceMT = {} -- instance metatable
local ObjectCacheMT = {}


do  -- Metamethods
    function ObjectCacheMT.__index (self, key)
        if      (key == "currentType")  then
        
            local current = rawget(self, "current")
            return type(current);
            
        elseif  (key == "previousType")  then
        
            local previous = rawget(self, "previous")
            return type(previous);

        else
            return rawget(self, key)
        end
    end

    function ObjectCacheMT.__newindex (self,key,val)
        if      (key == "currentType"  or  key == "previousType")  then
            error(key.." is a read-only property of the Namespace object cache.");

        else
            rawset(self, key, val)
        end
    end


    function NamespaceMT.__index (self, key)
        if      (key == "_type"  or  key == "__type")  then
            return "Actor Namespace"

        -- Initialize the current section as the player's section
        elseif  (key == "currentSection")  then
            self[key] = player.section;
            return  player.section;

        elseif  self.objects.current ~= nil  and  self.objects.current[key] ~= nil  then
            local curr = self.objects.current
            return curr[key]

        else
            return Namespace[key]
        end
    end

    function NamespaceMT.__newindex (self,key,val)

        if  self.objects.current ~= nil  and  self.objects.current[key] ~= nil  then
            self.objects.current[key] = val

        else
            rawset(self, key, val)
        end
    end

    function NamespaceMT.__call (tbl, args)
        -- No args?  NOOOOOOoooOOoooOOOO PROBLEM!
        if  args == nil  then
            args = {}
        end

        -- If the current object isn't set, here's one last attempt
        local current = tbl.objects.current
        local currentType = tbl.objects.currentType
        local currentAdd = {x=0,y=0}
        --local source = currentType

        if  currentType == "nil"  then
            if  player.character == tbl.playable.id  then
                --source = "LAST-MINUTE PLAYER"
                current = tbl:BecomePlayer ()
                currentType = tbl.objects.currentType

            -- If an NPC of the player exists, try an NPC
            elseif  tbl:GetNPC()  then
                --source = "LAST-MINUTE NPC"
                current = tbl:BecomeNPC ()
                currentType = tbl.objects.currentType
            end

            -- Last resort, make a temp table
            if  current == nil  then
                --source = "NOTHING"
                current = {x=-999999, y=-999999, direction=DIR_RIGHT}
                currentType = "nil"
            end
        end

        -- Preserve position when switching to an actor from a player or npc
        if  currentType == "Player"  or  currentType == "NPC"  then
            currentAdd.x = current.width*0.5
            currentAdd.y = current.height
        end

        -- If changing from an NPC, cache its properties and then WIPE IT FROM THE TIMESTREAM!!!!
        if  currentType == "NPC"  then
            tbl:CacheNPCProps(current);
            eraseNPC(current);
        end

        --*Misc.dialog("INITIALIZING "..tbl.name.." FROM "..source..", DIR="..tostring(current.direction))
        --*Misc.dialog(args)


        -- Generate the Actor object
        if  tbl.objects.actor == nil  then
            local newBounds = {}
            newBounds.top = player.sectionObj.boundary.top-1000
            newBounds.left = player.sectionObj.boundary.left-1000
            newBounds.right = player.sectionObj.boundary.right+1000
            newBounds.bottom = a2xt_actor.groundY  or  player.sectionObj.boundary.bottom-100

            local specialDefs = {
                                 x      = args.x      or  current.x + currentAdd.x,
                                 y      = args.y      or  current.y + currentAdd.y,
                                 z      = args.z      or  -25.01,
                                 state  = args.state  or  "walk",
                                 direction = args.direction  or  current.direction,
                                 bounds = newBounds,
                                 sceneCoords = true
                                 --debug = true
                                }

            local allArgs = table.join (tbl.actorArgs, specialDefs)
            tbl.objects.actor = Actor(allArgs)
            tbl.objects.actor.autoAnimSpeed = true --Hack, but it works
        end


        -- Apply any named arguments that were passed in
        local usableArgs = {"x","y","z","direction","speedX","speedY","bounds"}
        --local actorVals = {}
        for  _,v in ipairs (usableArgs)  do
            tbl.objects.actor[v] = args[v]  or  tbl.objects.actor[v]
            --actorVals[v] = tbl.objects.actor[v]
        end
        --actorVals.name = tbl.name
        --*Misc.dialog(actorVals)

        tbl.objects.actor.state = args.state  or  tbl.objects.actor.state
        tbl.objects.actor.gfx.visible = true


        -- Namespace reference
        tbl.objects.actor._namespace = tbl

        -- Default gravity
        if  tbl.playable.id ~= nil  then
            tbl.objects.actor.defaultGravity = Defines.player_grav

        elseif  tbl.npcId ~= nil  then
            tbl.objects.actor.defaultGravity = Defines.npc_grav
        end



        -- Finally, make the new Actor the Namespace's current object
        tbl.objects.current = tbl.objects.actor
        tbl.currentSection = player.section
    end
end

do  -- Non-meta methods

    -- WRAPPER FUNCTIONS FOR THE EXTRA OBJECT METHODS (so you can call e.g. Namespace:Jump(...) instead of having to do Namespace.objects.current:Jump(...))
    for  k,v in pairs (extMethods)  do
        Namespace[k] = function(self, ...)
            local obj = self.objects.current
            --*Misc.dialog("CALLING "..k.." for "..tostring(obj))
            if  obj ~= nil  then
                return obj[k](obj, ...)
            end
        end
    end


    -- DEFINE NAMESPACE METHODS
    -- Type-switching
    function Namespace:ToActor (target, keepPlayerObj) -- Makes the Namespace's Actor object usurp/become/replace its current object (or optionally, a specific object passed in), initializing the Actor object if necessary
        self.keepPlayerObj = keepPlayerObj
        
        -- Force object management event to refresh the section ID cache and clear the current object if it's been abandoned
        self:_ManageObjects()
        local sameSection = self.currentSection == player.section
        local bounds

        -- Apply any cached previous .current if inside the same section as before
        if  sameSection  then
            self:Restore()

        -- If _not_ in the same section, the actor's bounds are gonna need to be reset
        else
            bounds = {
                top = player.sectionObj.boundary.top-1000,
                left = player.sectionObj.boundary.left-1000,
                right = player.sectionObj.boundary.right+1000,
                bottom = a2xt_actor.groundY  or  player.sectionObj.boundary.bottom-100
            }
        end

        -- The optional argument takes priority, that fella's got a VIP pass!
        if  target ~= nil  then
            self.objects.current = target
        end


        -- Now let's finally set up our shorthand references
        local current = self.objects.current
        local currentType = self.objects.currentType
        local actor = self.objects.actor

        --Misc.dialog{self.name.." SECTION COMPARE:", self.currentSection, player.section, "CURRENT OBJECT TYPE:", currentType}


        -- Only bother with the rest if the current object is not already the Actor
        -- (thanks to the _ManageObjects() call we can safely assume an Actor left in another section is no longer the current object!)
        if  current ~= actor  or  currentType ~= "Actor object"  then

            -- We only pass in arguments to the Actor initialization if there's a host;  by default, assume no valid host exists
            local argCall = false

            -- If there is still a cached current object reference by this point (the player or an NPC), it automatically becomes the host
            if  currentType ~= "nil"  then
                --Misc.dialog{self.name.." USING CURRENT "..currentType}
                argCall = true

            -- Otherwise, if the player isn't already hidden and is the correct character, use them
            elseif  player.character == self.playable.id  and  player:mem(0x122, FIELD_WORD) <= 0  then
                --Misc.dialog{self.name.." BECOMING THE ACTIVE PLAYER"}
                self:BecomePlayer ()
                argCall = true

            -- Failing that, see if we can find a suitable NPC
            else
                --Misc.dialog{self.name.." LOOKING FOR NPC"}
                self:BecomeNPC (target)
                argCall = (self.objects.currentType == "NPC")
            end


            -- Refresh our shorthands
            current = self.objects.current
            currentType = self.objects.currentType



            -- Get the fixed sheets for the characters
            self.playable.fixedSheets = nil
            self.playable.fixedCostume = nil

            if  currentType == "NPC"  then
                if  current.data._forceUpdateHitbox ~= nil  then
                    --Misc.dialog("after BecomeNPC call")
                    current.data._forceUpdateHitbox(current, current.data._c)
                end
                if  current.data.sprite ~= nil  then
                    self.playable.fixedSheets = current.data.sprite
                    self.playable.fixedCostume = current.data.costume
                end
            end


            -- If a valid host has been determined, LET THE POSSESSION BEGIN
            if  argCall  and  current ~= nil  then
                
                local x,y,w,h = current.x,current.y,current.width,current.height
                x,y,w,h = math.floor(x+0.5),math.floor(y+0.5),math.floor(w+0.5),math.floor(h+0.5)

                self {x=x+0.5*w, y=y+h, direction=current.direction, speedX=current.speedX, speedY=current.speedY, bounds=bounds}


            -- If there's no host then f**k the ghost rules we'll just manifest ourselves into existence out of SHEER FORCE OF WILL
            else
                self ()
            end

            --*Misc.dialog {self.name, "REFERENCED NPC EXISTS:", npc ~= nil, "VISIBLE:", self.objects.actor.gfx.visible, "X", self.objects.actor.x, "Y", self.objects.actor.y, "W", self.objects.actor.width, "BOUNDS:", self.objects.actor.bounds}
        end

        return self.objects.current;
    end

    function Namespace:SetPlayerPowerup () -- Sets the powerup of the respective player.character to 2, allowing for powerups to be consistent without jank when necessary
        if  self.playable.id ~= nil then
            if self.playable.id == player.character then
                player.powerup = 2
            end
            Player.getTemplate(self.playable.id).powerup = 2
        end
    end

    function Namespace:BecomePlayer () -- Changes the current object into the player, changing player.character accordingly

        -- Shorthand refs
        local current = self.objects.current
        local currentType = self.objects.currentType
        local actor = self.objects.actor

        -- If not already the player and can become them
        if  self.playable.id ~= nil  and  currentType ~= "Player"  then

            -- If the current object exists, place the player there
            if  currentType ~= "nil"  then

                -- Oh, wait, if it's an NPC we should cache its' properties first!
                local npcToKill
                if  currentType == "NPC"  then
                    self:CacheNPCProps(current)
                    npcToKill = current
                end

                -- Okay, _now_ place the player there
                player.x = current.x
                player.y = current.y
                if  current == actor  then
                    player.x = current.left
                    player.y = current.bottom - player.height
                end
                player.speedX = current.speedX
                player.speedY = current.speedY
                player.direction = current.direction

                -- If current was an NPC, erase it
                eraseNPC(npcToKill)
            end

            -- Restore the player from their hidden state
            if  player:mem(0x122, FIELD_WORD) ~= 0  then
                player:mem(0x122, FIELD_WORD, 0)
            end

            -- Transform the player into this character
            player:transform(self.playable.id)

            -- Assign the player to the current object reference
            self.objects.current = player
        end

        self:_ManageObjects()
        return self.objects.current
    end

    function Namespace:BecomeNPC (target) -- Changes the current object into an NPC;  if there is no current object and a target isn't specified, hijacks an existing one if possible

        -- Force object management event to refresh the section ID cache and clear the current object if it's been abandoned
        self:_ManageObjects()
        local sameSection = self.currentSection == player.section


        -- Shorthand references
        local current = self.objects.current
        local currentType = self.objects.currentType
        local actor = self.objects.actor


        -- If not an NPC and can possess one
        if  currentType ~= "NPC"  and  self.npcId ~= nil  then

            -- If the optional argument is not an npc reference, assume it's new NPC properties and have them override the cached ones
            -- (thanks to the _ManageObjects call, we can assume any abandoned host NPCs have already been recreated and the cached properties wiped accordingly!)
            if  target ~= nil  and  target.ai1 == nil  then
                target.section = target.section  or  player.section
                self.npcProps = target
            end

            -- If the current object exists and is in the current section, place a new/recreated NPC at its position
            if  current ~= nil  and  sameSection  then
                local spawnX,spawnY = current.x,current.y
                if  currentType == "Actor object"  then
                    spawnX = current.left
                    spawnY = current.top -- current.collision.bottom - NPC.config[self.npcId].height
                end

                -- Attempt to remake a cached NPC (or spawn a new one with the passed-in property table) 
                local remade,section = self:RecreateNPC()

                -- If the cached NPC was remade, use it...
                local pnpcRef 
                if  remade ~= nil  and  section == player.section  then
                    pnpcRef = remade;
                    pnpcRef.x = spawnX + (current.width - pnpcRef.width)*0.5;
                    pnpcRef.y = spawnY + current.height - pnpcRef.height;
                    --Misc.dialog{self.name.." RECREATING HIJACKED NPC"}

                -- ...otherwise, spawn a new, blank-slate NPC
                else
                    pnpcRef = NPC.spawn(self.npcId, spawnX, spawnY, player.section, true)
                    pnpcRef.x = spawnX + (current.width - pnpcRef.width)*0.5;
                    pnpcRef.y = spawnY + current.height - pnpcRef.height
                    --Misc.dialog{self.name.." SPAWNING NEW NPC", "REMADE"..tostring(remade ~= nil), "SECTIONS", section, player.section}
                end
                pnpcRef.direction = current.direction;

                -- Set the reference
                self.objects.current = pnpcRef;


            -- Otherwise, try to hijack an existing NPC in the section
            else
                --Misc.dialog{self.name.." HIJACKING NPC FROM SECTION"}

                -- Only pass in target if it's an npc reference
                local specificTarget
                if  target ~= nil  and  target.ai1 ~= nil  then
                    specificTarget = target
                end

                self:HijackNPC (specificTarget)
            end
        else
            --Misc.dialog("FAILED TO BECOME AN NPC. npcId: "..tostring(self.npcId)..", current is NPC:"..tostring(current == npc))
        end

        self:_ManageObjects()
        return self.objects.current
    end

    function Namespace:PlayerReplaceNPC (target) -- If a valid NPC exists (or is provided), have the player become this character and replace the NPC

        -- If the current object is an NPC
        if  self.objects.currentType == "NPC"  then
            self:BecomePlayer()

        -- Otherwise, try to hijack an NPC
        else
            local succeeded,_ = self:HijackNPC()
            if  succeeded  then
                self:BecomePlayer()
            end
        end
    end


    -- Removal and restoration of the current object
    function Namespace:Remove () -- caches the reference to the current object, then removes it
        self.objects.previous = self.objects.current
        if  player.character ~= self.playable.id  then
            self.objects.current = nil
        end
    end

    function Namespace:Restore () -- restores the current object if it was removed
        if  self.objects.previous ~= nil  then
            self.objects.current = self.objects.previous
            self.objects.previous = nil

            if  self.objects.current.gfx ~= nil  then
                self.objects.current.gfx.visible = true
            end
        end
    end


    -- NPC detection/management
    function Namespace:GetNPC () -- check for a valid NPC and returns: whether it was found (bool), npc reference (or nil)
        if  self.npcId ~= nil  then
            local available = NPC.get(self.npcId, player.section)
            --Misc.dialog("NPCS FOUND:",#available)
            if  #available > 0  then
                return true, available[1]
            end
        end
        return false, nil
    end

    function Namespace:HijackNPC (target) -- attempts to make a valid NPC in the section (or a specific npc reference passed in) the current object;  like GetNPC, returns whether successful (bool), the npc reference (or nil)
        --*Misc.dialog{"BEFORE:", self.objects}

        if  target ~= nil  and  target.ai1 ~= nil  and  target.id == self.npcId  then
            self.objects.current = target
            return true,target;
        else
            local succeeded,selected = self:GetNPC()
            if  succeeded  then
                self.objects.current = selected
            end
            return succeeded,selected;
        end
    end

    function Namespace:SetCachedMemory (address, value) -- sets the corresponding cached NPC memory
        if  self.npcProps == nil  then
            return;
        end

        self.npcProps.mem[address][2] = value
    end
    function Namespace:GetCachedMemory (address) -- returns the corresponding cached NPC memory
        if  self.npcProps == nil  then
            return nil;
        end

        return self.npcProps.mem[address][2]
    end

    function Namespace:CacheNPCProps (ref) -- caches the information of the given NPC so it can be recreated if necessary

        --Misc.dialog(self.name.." CACHING NPC PROPS")

        -- Create an NPC property table
        local props = {
            vars = {},
            mem = {},
            section = nil
        }

        -- Variables and memory offsets to cache
        local varList = {"x","y","msg","attachedLayerName","activateEventName","deathEventName","noMoreObjInLayer","talkEventName","layerName","layerObj","attachedLayerObj","ai1","ai2","ai3","ai4","ai5","drawOnlyMask","invincibleToSword","legacyBoss","friendly","dontMove","data"}
        local offsetList = {
            [0xA8] = FIELD_DFLOAT, -- Spawn X
            [0xB0] = FIELD_DFLOAT, -- Spawn Y
            [0xB8] = FIELD_DFLOAT, -- Spawn Height
            [0xC0] = FIELD_DFLOAT, -- Spawn Width

            [0xD8] = FIELD_FLOAT,  -- Spawn Direction
            [0xDC] = FIELD_WORD,   -- Respawn ID
            [0xE2] = FIELD_WORD,   -- Sprite GFX index/Identity
            [0x146] = FIELD_WORD,  -- Current section this NPC is on
        }

        -- Copy the variables
        for  _,v in ipairs(varList)  do
            props.vars[v] = ref[v]
        end

        -- Copy the memory addresses
        for  k,t in pairs(offsetList)  do
            props.mem[k] = {t, ref:mem(k,t)} -- {type, value}
        end

        -- Copy the section ID for convenience
        if  props.mem[0x146] ~= nil  then
            props.section = props.mem[0x146][2]
        else
            props.section = player.section
        end

        -- Cache the table
        self.npcProps = props
    end

    function Namespace:RecreateNPC () -- if an NPC was replaced and cached, recreate it and return the npc reference
        if  self.npcProps ~= nil  then

            -- Shorthand ref
            local props = self.npcProps

            -- Spawn the NPC
            --Misc.dialog("MEMORY:", props.mem, "SECTION:", props.section, "SPAWN:", props.mem[0xE2], props.mem[0xA8], props.mem[0xB0], props.section  or  props.mem[0x146])
            local sectionId = props.section  or  props.mem[0x146][2]

            if  sectionId ~= nil  then
                local pnpcRef = NPC.spawn(props.mem[0xE2][2], props.mem[0xA8][2], props.mem[0xB0][2], sectionId, false)


                -- Apply the cached NPC properties to the newly-spawned NPC
                for  k,v in pairs(props.vars)  do
                    pnpcRef[k] = v
                end
                for  k,v in pairs(props.mem)  do
                    pnpcRef:mem(k, v[1], v[2])
                end

                -- Clear the cache
                self.npcProps = nil

                --Misc.dialog("SUCCESSFULLY RECREATED")

                -- Return the remade NPC and the section it's in
                return pnpcRef, sectionId

            else
                --Misc.dialog("COULD NOT RECREATE, NIL SECTION")
            end

        else
            --Misc.dialog("COULD NOT RECREATE, NIL PROPERTIES")
        end

        -- No NPC cached, return nil
        return nil, -1
    end


    -- Sequence-related methods
    function Namespace:GetSequence (seqName) -- given the string, returns the corresponding sequence and where it's stored
        local seqProcs = self.sequences.processed
        local obj = self.objects.actor

        local returnedPath
        if  obj.direction == DIR_LEFT  or  obj.direction == DIR_RIGHT  then
            if  seqProcs[obj.direction][seqName] ~= nil  then
                returnedPath = seqProcs[obj.direction]
            else
                returnedPath = seqProcs.default
            end
        else
            if  seqProcs[DIR_LEFT][seqName] ~= nil  then
                returnedPath = seqProcs[DIR_LEFT]
            elseif  seqProcs[DIR_RIGHT][seqName] ~= nil  then
                returnedPath = seqProcs[DIR_RIGHT]
            else
                returnedPath = seqProcs.default
            end
        end

        local returnedSequence = returnedPath[seqName]

        return  returnedSequence, returnedPath
    end

    function Namespace:ReplaceSequence (seqStr1, seqStr2) -- replaces the sequence named seqStr1 with the sequence named seqStr2
        local _,path1 = self:GetSequence(seqStr1)
        local seq2 = self:GetSequence(seqStr2)
        path1[seqStr1] = seq2
    end
end

do  -- Events for overriding object behavior, gfx, etc
    function Namespace:_ManageObjects ()  --hides/deletes/restores objects when they're not in use

        -- Shorthand references
        local current = self.objects.current
        local currentType = self.objects.currentType
        local actor = self.objects.actor


        -- If the current object is the player and the section changes, update the section ID cache accordingly
        if  currentType == "Player"  then
            self.currentSection = player.section
        end

        -- If the current object has been left behind in another section, consider it abandoned and wipe the current object reference
        if  currentType ~= "nil"  and  self.currentSection ~= player.section  then
            --Misc.dialog(self.name.." HAS ABANDONED OBJECT OF TYPE "..currentType.." IN SECTION "..tostring(self.currentSection), "PLAYER SECTION:", player.section)
            self.objects.current = nil
            self.gfxType = nil            
            self.x = nil
            self.y = nil

            -- Update the shorthand refs accordingly
            current = self.objects.current
            currentType = self.objects.currentType
        end

        -- If an NPC was replaced in a different section from the player's current section, recreate it
        if  self.npcProps ~= nil  and  self.npcProps.section ~= player.section  then
            --Misc.dialog("RECREATING ABANDONED "..self.name.." NPC FROM CACHED PROPS; ", self.npcProps.section, player.section,")")
            self:RecreateNPC()
        end


        -- Hide the player if they're that character and move them to the current object's position
        if  currentType ~= "nil"  and  currentType ~= "Player"  and  player.character == self.playable.id  and  self.keepPlayerObj ~= true  then
            if player:mem(0x122, FIELD_WORD) ~= 8 and (player.powerup ~= 2 or player.mount ~= 0) then
                Effect.spawn(10, player.x + player.width*0.5 - 16, player.y + player.height*0.5 - 16)
                Effect.spawn(63, player.x + player.width*0.5, player.y + player.height*0.5)
            end
            player:mem(0x122, FIELD_WORD, 8)

            if  current ~= nil  then
                player.x = current.x
                player.y = current.y

                if  currentType == "Actor object"  then
                    player.x = current.left
                    player.y = current.top
                end
            end
        end


        -- delete the Actor object if it's not the current object
        if  currentType ~= "Actor object"  and  actor ~= nil  then
            self.objects.actor = nil
            --actor.gfx.visible = false
            
            if (player.powerup ~= 2 or player.mount ~= 0) then
                Effect.spawn(10, player.x + player.width*0.5 - 16, player.y + player.height*0.5 - 16)
                Effect.spawn(63, player.x + player.width*0.5, player.y + player.height*0.5)
            end
            
        end

        -- Update the current section if there is no longer a current object
        if  self.objects.currentType == "nil"  then
            self.currentSection = nil
        end
    end

    function Namespace:_Hitbox ()       --applies bounding box overrides to the Actor object
        if  self.objects.actor ~= nil  then

            local obj = self.objects.actor

            -- Apply width and height
            if  self.playable.id ~= nil  then
                local ducking = false
                if self.gfx ~= nil then
                    ducking = getIsDucking(self.gfx.state)
                end
                obj.width, obj.height = getPlayerSettingsSize (self.playable.id, 2, ducking)
                obj.collider.width, obj.collider.height = obj.width, obj.height
                obj.xOffsetGfx, obj.yOffsetGfx = -obj.width*0.5, -obj.height

            elseif  self.gfxType == "npc"  then
                obj.width, obj.height = NPC.config[self.npcId].width, NPC.config[self.npcId].height
                obj.collider.width, obj.collider.height = obj.width, obj.height
                obj.xOffsetGfx, obj.yOffsetGfx = getNPCOffsets (self.npcId)
            end
        end
    end

    function Namespace:_Physics ()      --applies physics overrides to the Actor object
        if  self.objects.actor ~= nil  then

            local obj = self.objects.actor


            -- Default gravity
            if  self.playable.id ~= nil  then
                obj.defaultGravity = Defines.player_grav

            else --if  self.npcId ~= nil  then
                obj.defaultGravity = Defines.npc_grav
            end


            -- Apply gravity based on type
            if  obj.contactDown  then
                if  obj.speedY >= 0  then
                    obj.accelY = 0
                    obj.maxSpeedY = 0
                end

                if  self.stayAboveGround ~= false  then
                    obj.y = math.min(obj.y, obj.bounds.bottom)
                end

            elseif  self.hasGravity  and  (--[[obj.accelY == 0  or--]]  obj.maxSpeedY == 0)  then
                if obj.maxSpeedY == 0 then
                    obj.maxSpeedY = Defines.gravity
                end

                -- Set accel to default gravity
                if  obj.accelY == 0  and  obj.defaultGravity ~= nil  then
                    obj.accelY = obj.defaultGravity
                end
            elseif not self.hasGravity then
                obj.maxSpeedY = math.huge
            end
        end
    end

    function Namespace:_Animation ()    --applies animation behavior overrides to the Actor object
        if  self.objects.actor ~= nil  then

            -- Apply directional sequences
            local seqProcs = self.sequences.processed
            local seqStrs = self.sequences.strings
            local obj = self.objects.actor
            local gfx = obj.gfx
            local set = gfx.set
            if  obj.direction == DIR_LEFT  or  obj.direction == DIR_RIGHT  then
                for  k3,_ in pairs(set.sequences)  do

                    --*Misc.dialog(self.name, k3, " ", seqProcs[DIR_LEFT][k3], " ", seqProcs[DIR_RIGHT][k3], " ", seqProcs.default[k3], "_")

                    if  seqProcs[obj.direction][k3] ~= nil  then
                        set.sequences[k3] = seqProcs[obj.direction][k3]
                        obj.directionMirror = false
                        gfx:applyStepFrame ()

                    else
                        set.sequences[k3] = seqProcs.default[k3]
                        obj.directionMirror = true
                        gfx:applyStepFrame ()
                    end
                end
            end


            --*Misc.dialog(set.sequences)



            -- Apply SpriteOverride sheet and offsets
            ---[[
            if  self.gfxType == "playable"  then
                local targetCostume = (self.playable.fixedCostume)

                if  self.playable.costume ~= targetCostume  then
                    self.playable.costume = targetCostume

                    pman.refreshHitbox(self.playable.id)
                    set.sheet = (self.playable.fixedSheets  or  Graphics.sprites[self.playable.name])[2].img
                    set.xOffsets, set.yOffsets = getPlayerSettingsOffsets (self.playable.id, 2)
                    obj.width, obj.height = getPlayerSettingsSize (self.playable.id, 2, getIsDucking(gfx.state))
                    obj.xOffsetGfx, obj.yOffsetGfx = -obj.width*0.5, -obj.height
                end

            elseif  self.gfxType == "npc"  then
                set.sheet = Graphics.sprites.npc[self.npcId].img
                set.xOffsetGfx, set.yOffsetGfx = getNPCOffsets (self.npcId)
            end
            --]]
        end
    end
end



--******************************************************
--** Load all the actor JSON files and use them to    **
--**  make dedicated namespaces for those characters  **
--******************************************************

do
    local function makeNamespace (filename)
        -- Get the namespace name
        local name = string.sub(filename, 0, -6);

        -- Get JSON info
        local f = io.open(Misc.resolveFile("actors/"..filename)  or  Misc.resolveFile("../actors/"..filename), "r");
        local content = f:read("*all");
        f:close();

        local ljson = lunajson.decode(content);
        ljson.general = ljson.general      or  {}

        ljson.gfx = ljson.gfx              or  {}
        ljson.gfx.npcStartLeft = ljson.gfx.npcStartLeft  or  1
        ljson.gfx.npcStartRight = ljson.gfx.npcStartRight  or  1

        ljson.sequences = ljson.sequences  or  {}


        -- Set up the Namespace instance
        local inst = {
            json = ljson,

            objects = {
                current = nil,
                previous = nil,
                actor = nil
            },

            playable = {
                name = nil,
                id = nil,
                costume = nil
            },

            hasGravity = (ljson.general.nogravity == nil),

            npcId = nil,

            gfxType = nil,
            
            talkOffsetY = ljson.general.talkOffsetY  or  0,

            actorArgs = {
                name=name,
                animSet = nil,
                width = ljson.general.width,
                height = ljson.general.height,
                scale = ljson.general.scale  or  2,
                xScale = ljson.general.xScale  or  1,
                yScale = ljson.general.yScale  or  1,
                state = "walk",
                autoAnimSpeed = true,
                defaultGravity = nil,
                xAlignGfx = animatx.ALIGN.MID,
                yAlignGfx = animatx.ALIGN.BOTTOM,
                xAlign = animatx.ALIGN.MID,
                yAlign = animatx.ALIGN.BOTTOM,
                xOffsetGfx = ljson.general.gfxoffsetx,
                yOffsetGfx = ljson.general.gfxoffsety,
                xOffsetBox = 0,
                yOffsetBox = 0,
                stateDefs = {}
            },

            sequences = {
                processed = {
                    [DIR_LEFT] = {},
                    [DIR_RIGHT] = {},
                    default = {}
                },
                strings = table.clone(ljson.sequences)
            }
        }
        local seqStrs = inst.sequences.strings
        local seqProcs = inst.sequences.processed
        local aArgs = inst.actorArgs
        for  _,v2 in ipairs {"npc","left","right","default"}  do
            seqStrs[v2] = seqStrs[v2]  or  {}
        end


        -- Cache asset IDs and gfx type
        inst.playable.name = ljson.general.player
        inst.playable.id = CHARACTER_CONSTANT[ljson.general.player]
        inst.npcId = ljson.general.npc
        inst.gfxType = ljson.gfx.type


        -- If the Actor uses a playable's or NPC's sheets, automate the properties from animDefaults and NPC.config, respectively
        local setProps = table.clone(ljson.gfx)

        if  inst.gfxType == "playable"  then
            for  k2,v2 in pairs(animDefaults[inst.playable.id][2])  do

                -- construct sequence strings
                local seqStringL,seqStringR = tostring(-v2[1]),tostring(v2[1])

                for i2=2,#v2  do
                    seqStringL = seqStringL .. "," .. tostring(-v2[i2])
                    seqStringR = seqStringR .. "," .. tostring(v2[i2])
                end
                seqStrs.left[k2] = seqStringL
                seqStrs.right[k2] = seqStringR
            end

            setProps.rows = 10
            setProps.columns = 10
            setProps.isPlayerSheet = true
            setProps.sheet = Graphics.sprites[inst.playable.name][2].img
            setProps.xOffsets, setProps.yOffsets = getPlayerSettingsOffsets(inst.playable.id,2)
            --setProps.sheet = Graphics.loadImage(Misc.resolveFile("../graphics/mario/mario-2.png"))

            aArgs.width, aArgs.height = getPlayerSettingsSize(inst.playable.id,2)
            aArgs.xOffsetGfx, aArgs.yOffsetGfx = -aArgs.width*0.5, -aArgs.height
            aArgs.xAlignGfx = animatx.ALIGN.LEFT
            aArgs.yAlignGfx = animatx.ALIGN.TOP
            aArgs.scale = 1

        elseif  inst.gfxType == "npc"  then
            local config = NPC.config[inst.npcId]
            setProps.rows = config.frames * (config.framestyle+1)
            setProps.columns = 1
            setProps.sheet = Graphics.sprites.npc[inst.npcId].img
            aArgs.xOffsetGfx, aArgs.yOffsetGfx = getNPCOffsets(inst.npcId)
            
            --TEMP FIX for "sheet cannot be nil" bug
            if(setProps.sheet == nil) then
                setProps.sheet = Graphics.loadImage(Misc.resolveFile("npc-980.png") or Misc.resolveFile("graphics/npc/npc-980.png"))
            end
            
            aArgs.scale = 1

        else
            if  inst.npcId ~= nil  then
                aArgs.width = aArgs.width  or  (NPC.config[inst.npcId].width)
                aArgs.height = aArgs.height  or  (NPC.config[inst.npcId].height)
                
                local ofx,ofy = getNPCOffsets(inst.npcId)
                aArgs.xOffsetGfx = aArgs.xOffsetGfx or ofx
                aArgs.yOffsetGfx = aArgs.yOffsetGfx or ofy
                --*Misc.dialog(name, aArgs.width, aArgs.height)
            end
            
        end
            
        aArgs.xOffsetGfx = aArgs.xOffsetGfx or 0
        aArgs.yOffsetGfx = aArgs.yOffsetGfx or 0

        setProps.scale = aArgs.scale


        -- Create a table with _all_ the unique animstate keys.  _All of them_.
        local allKeys = table.join(seqStrs.npc      or  {},
                                   seqStrs.left     or  {},
                                   seqStrs.right    or  {},
                                   seqStrs.default  or  {})


        -- Process EVERY SEQUENCE and create the ActorState definitions
        local seqProps = {isPlayerSheet=(ljson.general.player ~= nil), useOldIndexing=false, rows=ljson.gfx.rows}
        for  k2,v2 in pairs (allKeys)  do

            -- Sequences
            if  seqStrs.npc[k2] ~= nil  then
                seqProcs[DIR_LEFT][k2] = animatx.Sequence (table.join(seqProps, {str=seqStrs.npc[k2], frameOffset=ljson.gfx.npcStartLeft-1}))
                seqProcs[DIR_RIGHT][k2] = animatx.Sequence (table.join(seqProps, {str=seqStrs.npc[k2], frameOffset=ljson.gfx.npcStartRight-1}))

            elseif  seqStrs.left[k2] ~= nil  or  seqStrs.right[k2] ~= nil  then
                seqProcs[DIR_LEFT][k2] = animatx.Sequence (table.join(seqProps, {str=seqStrs.left[k2], frameOffset=ljson.gfx.npcStartLeft-1}))
                seqProcs[DIR_RIGHT][k2] = animatx.Sequence (table.join(seqProps, {str=seqStrs.right[k2], frameOffset=ljson.gfx.npcStartRight-1}))
            end

            seqProcs.default[k2] = animatx.Sequence (table.join(seqProps, {str=seqStrs.default[k2]}))
        end


        -- Define states
        aArgs.stateDefs = {
            walk = {
                onTick = function(self, actor)

                    -- Clear the cached pose
                    actor.cachedPose = nil
                    actor.cachedQueue = nil

                    -- Set the direction
                    if  actor.speedX ~= 0  then
                        actor.direction = actor.speedXSign
                    end

                    -- Set the animation state
                    if  math.abs(actor.speedX) >= 4  then
                        actor.gfx:attemptStates ({"run", "walk", "idle"}, {resetTimer=true, commands=true, name=actor.name, source="onTick of "..actor.state})

                    elseif  math.abs(actor.speedX) >= 0.25  then
                        actor.gfx:attemptStates ({"walk", "run", "idle"}, {resetTimer=true, commands=true, name=actor.name, source="onTick of "..actor.state})

                    else
                        actor.gfx:attemptStates ({"idle", "walk", "run"}, {resetTimer=true, commands=true, name=actor.name, source="onTick of "..actor.state})
                    end
                    
                    ---[[
                    if  actor.autoAnimSpeed  then
                        actor.gfx.speed = 1
                        if  actor.gfx.state == "walk"  or  actor.gfx.state == "run"  then
                            actor.gfx.speed = math.abs(actor.speedX/2)
                        end
                    end
                    --]]



                    -- Switch to standing
                    if  actor.speedX == 0  then
                        actor:StartState("idle")
                    end
                end
            },
            idle = {
                onStart = function(self, actor)
                    -- Set the animation state and speed
                    if  actor.autoAnimSpeed  then
                        actor.gfx.speed = 1
                    end

                    local t;
                    if  (actor.cachedPose ~= nil)  then
                        t = {actor.cachedPose, "idle", "walk", "run"};
                    
                    elseif  (actor.cachedQueue ~= nil)  then

                    else
                        t = {"idle", "walk", "run"};
                    end

                    if  t ~= nil  then
                        actor.gfx:attemptStates (t, {resetTimer=true, commands=true, name=actor.name, source="onStart of "..actor.state})
                    end
                end,
                onTick = function(self, actor)

                    -- Change queued poses mode to pose mode
                    if  actor.cachedQueue ~= nil  and  #actor.gfx.queue == 0  then
                        actor.cachedQueue = nil
                        actor.cachedPose = actor.gfx.state
                        t = {actor.cachedPose, "idle", "walk", "run"}
                    end

                    -- Debug
                    --[[
                    Text.print(tostring(#actor.gfx.queue), 4, 20,120)

                    Text.print(tostring(actor.gfx.state), 4, 20,140)
                    for  k,v in ipairs(actor.gfx.queue)  do
                        Text.print(v, 4, 20,140+(20*k))
                    end
                    --]]

                    
                    -- Switch to walking
                    if  actor.speedX ~= 0  then
                        actor:StartState("walk")
                    end

                    -- Switch to airborn
                    if  not actor.contactDown  then
                        actor:StartState("air")
                    end
                end
            },
            air = {
                data = {spdYCache = 0},
                onTick = function(self, actor)
                    local lastSpd = self.data.spdYCache
                    self.data.spdYCache = actor.speedY

                -- Set the animation state
                    if  actor.speedY >= 0  and  lastSpd < 0  then 
                        actor.gfx:attemptStates ({"fall", "jump", "idle"}, {resetTimer=true, commands=true, name=actor.name, source="onTick of "..actor.state})

                    elseif  actor.speedY < 0  and  lastSpd >= 0  then
                        actor.gfx:attemptStates ({"jump", "fall", "idle"}, {resetTimer=true, commands=true, name=actor.name, source="onTick of "..actor.state})
                    end

                    -- Switch to grounded
                    if  actor.speedY == 0  and  actor.y >= actor.bounds.bottom  then
                        actor:StartState("idle")
                    end
                end
            }
        }


        -- Define the animation set from the animset and sequences sections of the ini
        setProps.sequences = table.clone(allKeys)
        aArgs.animSet = animatx.Set (setProps)

        -- Store the name because it turns out I actually need it after all
        inst.name = name


        --*Misc.dialog{NAME=name, L_SEQS=inst.sequences.processed[DIR_LEFT]}
        --*Misc.dialog{NAME=name, R_SEQS=inst.sequences.processed[DIR_RIGHT]}


        -- Include any defined character-specific extra data
        local extDataEvents = {onStart=1,onTick=1,onPhysicsEnd=1,onGfxEnd=1}
        if  extData[name] ~= nil  then
            for  k,v in pairs (extData[name])  do
                if  extDataEvents[k]~=nil  then
                    aArgs[k] = v
                else
                    inst[k] = v
                end
            end
        end


        -- Set the metatables and make this thing a dedicated namespace
        setmetatable(inst.objects, ObjectCacheMT)
        setmetatable(inst, NamespaceMT)
        a2xt_actor[name] = inst
        _G["ACTOR_"..string.upper(name)] = a2xt_actor[name]
        table.insert(a2xt_actor.presetNames, name)
    end


    -- Loop through the json files and generate the namespaces from them
    a2xt_actor.presetNames = {}
    for k,v in ipairs (table.append (Misc.listLocalFiles("../actors"), Misc.listLocalFiles("actors")))  do

        -- Replace with more performant extension filtering
        if  v ~= "Example.txt"  and  v~= "verlethair.lua"  and  v~= "verletrope.lua"  then
            makeNamespace(v)
        end
    end
end




--*************************************
--** Preset lists                    **
--*************************************
a2xt_actor.krew = {ACTOR_DEMO, ACTOR_IRIS, ACTOR_KOOD, ACTOR_RAOCOW, ACTOR_SHEATH}
a2xt_actor.uncles = {ACTOR_BROADSWORD, ACTOR_ASBESTOS, ACTOR_DENMARK, ACTOR_REWIND, ACTOR_PUMPERNICKEL}


--*************************************
--** Library functions               **
--*************************************

-- Use ACTOR_NAME constants for the chars lists
function a2xt_actor.ToActors(chars) 
    for  _,v in ipairs (chars)  do
        v:ToActor()
    end
end
function a2xt_actor.KrewToActors()
    a2xt_actor.ToActors(a2xt_actor.krew)
end
function a2xt_actor.UnclesToActors()
    a2xt_actor.ToActors(a2xt_actor.uncles)
end

function a2xt_actor.ToNPCs(chars) 
    for  _,v in ipairs (chars)  do
        v:BecomeNPC()
    end
end
function a2xt_actor.KrewToNPCs()
    a2xt_actor.ToNPCs(a2xt_actor.krew)
end
function a2xt_actor.UnclesToNPCs()
    a2xt_actor.ToNPCs(a2xt_actor.uncles)
end


function a2xt_actor.Remove(chars) 
    for  _,v in ipairs (chars)  do
        v:Remove()
    end
end

function a2xt_actor.RemoveKrew()
    a2xt_actor.Remove(a2xt_actor.krew)
end

function a2xt_actor.Restore(chars)
    for  _,v in ipairs (chars)  do
        v:Restore()
    end
end

function a2xt_actor.RestoreKrew()
    a2xt_actor.Restore(a2xt_actor.krew)
end


local playerkeys = { [1]="Demo", [2]="Iris", [3]="Kood", [4]="Raocow", [5]="Sheath", [15]="Broadsword" }
function a2xt_actor.HidePlayer()
    local preset = playerkeys[player.character]
    if  preset ~= nil  then
        a2xt_actor[preset]:_ManageObjects()
        player:mem(0x122, FIELD_WORD, 8)
    end
end


function a2xt_actor.MovePlayerToNPC(target)
    if target == nil then
        local d = math.huge
        for _,v in ipairs(NPC.get(krewCharToNPC(player.character))) do
            local dist = vector((v.x + v.width*0.5) - (player.x + player.width*0.5), (v.y + v.height*0.5) - (player.y + player.height*0.5)).sqrlength
            if dist < d then
                target = v
                d = dist
            end
        end
    end
    
    if target ~= nil then
        player.x = target.x + (target.width - player.width)*0.5
        player.y = target.y + target.height - player.height
        player.direction = target.direction
    end
end


--*************************************
--** Library events                  **
--*************************************

function a2xt_actor.onTick ()
    -- LOOP THROUGH ALL NAMESPACES
    for  k,v in ipairs(a2xt_actor.presetNames)  do
        local namespace = a2xt_actor[v]
        local actorObj = namespace.objects.actor
        local currentObj = namespace.objects.current

        if  actorObj ~= nil  then
            if(namespace and (namespace.isValid or namespace.isValid == nil)) then
                namespace:_ManageObjects ()
                namespace:_Hitbox ()
                namespace:_Physics ()
                namespace:_Animation ()
            end
            if currentObj == actorObj  then
                actorObj:update()
            end
        end
    end
end

function a2xt_actor.onDraw ()

    if not Misc.isPaused() then
        a2xt_actor.onTick()
    end

    local i = 1
    for  k,v in ipairs(a2xt_actor.presetNames)  do
        local namespace = a2xt_actor[v]
        local actorObj = namespace.objects.actor

        if  namespace.objects.current ~= nil  then
            --Text.print(tostring(namespace.name) .. " object: " .. namespace.objects.currentType .. " section: " .. tostring(namespace.currentSection), 10, 20+20*i)
            i = i+1
        end

        if  actorObj ~= nil  then
            actorObj:draw()
        end
    end
end

--**************************************
--** ffs rocky internalize metatables **
--**************************************
local readOnly = {krew=1,uncles=1,Player=1}

local a2xt_actorMT = {
    __index = function(obj, key)
        if  key == "Player"  then
            return obj[CHARACTER_NAME[player.character]]
        else
            return rawget (obj, key)
        end
    end,

    __newindex = function(obj, key, val)
        if      (readOnly[key])  then
            error(key.." is a read-only property of the A2XT Actor system.");
        else
            rawset (obj, key, val)
        end
    end
}
setmetatable(a2xt_actor, a2xt_actorMT)
_G["ACTOR_PLAYER"] = a2xt_actor.Player


return a2xt_actor