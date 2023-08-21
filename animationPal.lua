--[[

    animationPal.lua
    by MrDoubleA

    Simple, general purpose animation system

]]

local playerManager = require("playerManager")

local animationPal = {}


-- Basic animation object
local animatorArguments = {"perAnimationProperties","perFrameProperties","animationSet","startAnimation"}

do
    local instanceFunctions = {}
    local animatorMT = {}

    local valueAliases = {
        -- The normal names are a bit clunky, but I don't want to rename them for compatiblity reasons, so there's some aliases
        animationName = "currentAnimation",
        speed = "animationSpeed",

        frameIndex = "animationFrameIndex",
        finished = "animationFinished",
        timer = "animationTimer",
        currentFrame = "frame",
    }

    animatorMT.__type = "Animator"
    
    function animatorMT:__index(key)
        if instanceFunctions[key] ~= nil then
            return instanceFunctions[key]
        end

        if valueAliases[key] ~= nil then
            return rawget(self,valueAliases[key])
        end

        return rawget(self,key)
    end

    function animatorMT:__newindex(key,value)
        if valueAliases[key] ~= nil then
            rawset(self,valueAliases[key],value)
            return
        end

        rawset(self,key,value)
    end



    local function convertAnimationProperties(tbl)
        if tbl == nil then
            return {}
        end

        local ret = {}

        for k,v in pairs(tbl) do
            table.insert(ret,{k,v})
        end

        return ret
    end

    local function resetAnimationProperties(propertiesData,properties)
        for _,data in ipairs(propertiesData) do
            properties[data[1]] = data[2]
        end
    end


    -- Updates the animator's frame. Used internally.
    function instanceFunctions:findFrame()
        if self.currentAnimation == nil then
            -- If no animation is set, the frame will not be updated at all
            return
        end

        local animationData = self.animationSet[self.currentAnimation]
        if animationData == nil then
            error("Animation '".. tostring(self.currentAnimation).. "' does not exist.")
            return
        end

        local frameCount = #animationData

        -- Find the index of the frame, considering looping
        self.animationFrameIndex = math.floor(self.animationTimer / (animationData.frameDelay or 1))

        if self.animationFrameIndex >= frameCount then
            if animationData.loopPoint ~= nil then -- "loopPoint" property. controls the index of the frame it goes to after finishing
                local loopingFrames = (frameCount - animationData.loopPoint) + 1
                
                self.animationFrameIndex = ((self.animationFrameIndex - frameCount) % loopingFrames) + animationData.loopPoint - 1
            elseif animationData.loops ~= false then -- "loops" set or nil, just goes to the start (same as "loopPoint" of 1)
                self.animationFrameIndex = self.animationFrameIndex % frameCount
            else -- does not loop, stay on final frame
                self.animationFrameIndex = frameCount - 1
            end

            self.animationFinished = true
        end

        -- Gotta add 1!
        self.animationFrameIndex = self.animationFrameIndex + 1

        -- Finally, set currentFrame
        local rawFrame = animationData[self.animationFrameIndex]
        local frameType = type(rawFrame)

        if frameType == "Vector2" or frameType == "table" then -- already specifies both X and Y
            self.currentFrame = vector(rawFrame[1] or rawFrame.x,rawFrame[2] or rawFrame.y)
        elseif frameType == "number" then -- a single number, so use defaultFrameX/Y
            if animationData.defaultFrameX ~= nil then
                self.currentFrame = vector(animationData.defaultFrameX,rawFrame)
            elseif animationData.defaultFrameY ~= nil then
                self.currentFrame = vector(rawFrame,animationData.defaultFrameY)
            else -- only one axis specified, so act like defaultFrameX of 1
                self.currentFrame = vector(1,rawFrame)
            end
        else -- nil or something, somehow
            self.currentFrame = vector.one2
        end


        -- Handle perAnimationProperties/perFrameProperties
        for _,data in ipairs(self.perAnimationPropertiesData) do
            local value = animationData[data[1]]

            if value ~= nil then
                self.perAnimationProperties[data[1]] = value
            end
        end

        for _,data in ipairs(self.perFramePropertiesData) do
            local valueList = animationData[data[1]]

            if valueList ~= nil then
                local value = valueList[self.animationFrameIndex]

                if value ~= nil then
                    self.perFrameProperties[data[1]] = value
                end
            end
        end
    end


    -- Forcefully sets the animator's current animation. Will reset speed and the animation timer.
    function instanceFunctions:forceSetAnimation(animationName)
        self.currentAnimation = animationName
        self.animationSpeed = 1

        self.animationFrameIndex = 1
        self.animationFinished = false
        self.animationTimer = 0

        resetAnimationProperties(self.perAnimationPropertiesData,self.perAnimationProperties)
        resetAnimationProperties(self.perFramePropertiesData,self.perFrameProperties)

        self:findFrame()
    end

    -- Sets the animator's animation and speed. If it is already in the animation, it will only be restarted if "forceRestart" is true.
    function instanceFunctions:setAnimation(animationName,speed,forceRestart)
        if animationName ~= self.currentAnimation or forceRestart then
            self:forceSetAnimation(animationName)
        end

        self.animationSpeed = speed or 1
    end

    -- Ticks the animator by one frame, updating the timer and animation frame.
    function instanceFunctions:update()
        self:findFrame()
        self.animationTimer = self.animationTimer + self.animationSpeed
    end


    -- Creates a new animator and returns it.
    -- All argumemnts are optional, but you should specify animationSet.
    function animationPal.createAnimator(args)
        local self = setmetatable({},animatorMT)

        self.perAnimationPropertiesData = convertAnimationProperties(args.perAnimationProperties)
        self.perFramePropertiesData = convertAnimationProperties(args.perFrameProperties)

        self.perAnimationProperties = {}
        self.perFrameProperties = {}

        self.animationSet = args.animationSet

        self.startAnimation = args.startAnimation

        self.currentFrame = vector.one2

        self.data = {}

        self:forceSetAnimation(self.startAnimation)

        return self
    end
end


-- Character stuff
do
    local characterData = {}
    local playerData = {}

    local characterFunctionNames = {
        "isInvisibleFunc",
        "getTextureFunc",
        "drawCharacterFunc",
        "findAnimationFunc",
        "preDrawFunc",
        "postDrawFunc",
        "preAnimateFunc",
        "postAnimateFunc",
    }

    
    local emptyImage = Graphics.loadImageResolved("stock-0.png")


    local function setPlayerGraphic(characterID,value)
        local name = playerManager.getName(characterID)
        for powerupID = 1,7 do
            Graphics.sprites[name][powerupID].img = value
        end
    end


    -- Default functions
    local invisibleStates = table.map{FORCEDSTATE_POWERUP_LEAF,FORCEDSTATE_INVISIBLE,FORCEDSTATE_SWALLOWED}

    animationPal.defaultCharacterFuncs = {}

    -- Returns the name of the animation that the player should use.
    -- Optionally, it can return a second argument, which will be a modifier for how fast the animation should run.
    -- Optionally, it can return a third argument, that if true, will force that animation to restart.
    function animationPal.defaultCharacterFuncs.findAnimationFunc(p,animator)
        -- Just returns the animator's start animation by default.
        return animator.startAnimation,1,false
    end

    -- Returns whether the player should be invisible, given the render arguments and the player's state.
    function animationPal.defaultCharacterFuncs.isInvisibleFunc(p,args)
        if args.ignorestate then
            return false
        end

        if invisibleStates[p.forcedState] then -- in a forced state that makes the player invisible
            return true
        end

        if p.deathTimer > 0 or p:mem(0x13C,FIELD_BOOL) then -- dead
            return true
        end

        if p:mem(0x142,FIELD_BOOL) then -- invincibility frames blinking
            return true
        end

        if p:mem(0x0C,FIELD_BOOL) then -- is a fairy
            return true
        end

        if p.mount == MOUNT_BOOT and p:mem(0x12E,FIELD_BOOL) then -- ducking in a boot
            return true
        end

        if p.forcedState == FORCEDSTATE_PIPE and (p.forcedTimer == 1 or p.forcedTimer >= 100) then -- going through a pipe
            return true
        end

        return false
    end

    -- Returns the texture that the player sprite should use.
    function animationPal.defaultCharacterFuncs.getTextureFunc(p,properties)
        local charData = characterData[p.character]
        local image = charData.textures[properties.powerup]

        if image == nil then
            image = Graphics.loadImageResolved(charData.imagePathFormat:format(properties.powerup))
            charData.textures[properties.powerup] = image
        end

        return image
    end


    -- Runs just BEFORE the character is rendered. You can use this to render anything extra that you need.
    -- You can check or set any of the properties passed into the function.
    -- Note that this is run even if the character is invisible, though you can check/set properties.isInvisible.
    function animationPal.defaultCharacterFuncs.preDrawFunc(p,properties)
        -- Does not do anything by default.
    end

    -- Runs just AFTER the character is rendered. You can use this to render anything extra that you need.
    -- You can check any of the properties passed into the function, but setting them will have no effect.
    -- Note that this is run even if the character is invisible, though you can check/set properties.isInvisible.
    function animationPal.defaultCharacterFuncs.postDrawFunc(p,properties)
        -- Does not do anything by default.
    end

    -- Runs just BEFORE the character's animation is updated.
    -- You can use this for any additional checks you need about the character's animation.
    function animationPal.defaultCharacterFuncs.preAnimateFunc(p,animator)
        -- Does not do anything by default.
    end

    -- Runs just AFTER the character's animation is updated.
    -- You can use this for any additional checks you need about the character's animation.
    function animationPal.defaultCharacterFuncs.postAnimateFunc(p,animator)
        -- Does not do anything by default.
    end


    -- Draws the character and handles its properties. This is the core of the rendering system.
    function animationPal.defaultCharacterFuncs.drawCharacterFunc(p,args)
        -- Initialise properties
        local animationData = animationPal.getPlayerData(p.idx)
        local charData = characterData[p.character]

        local properties = {}


        properties.renderArgs = args

        properties.isMainRender = args.isMainRender

        properties.isInvisible = charData.isInvisibleFunc(p,args)


        properties.shader = args.shader
        properties.uniforms = args.uniforms or {}
        properties.attributes = args.attributes or {}

        if p.hasStarman and not args.ignorestate then
            properties.shader,properties.uniforms = animationPal.utils.getStarmanShader()
        end


        properties.x = (args.x or p.x) + p.width*0.5
        properties.y = (args.y or p.y) + p.height

        properties.offsetX = charData.offset.x
        properties.offsetY = charData.offset.y

        properties.direction = args.direction or p.direction
        properties.powerup = args.powerup or p.powerup
        properties.mount = args.mount or p.mount
        properties.mountColor = args.mountColor or p.mountColor

        properties.pivotOffset = vector(charData.pivotOffset.x,charData.pivotOffset.y)
        properties.pivot = vector(0.5,1)

        properties.scale = args.scale or vector(charData.scale.x,charData.scale.y)

        properties.rotation = args.rotation or 0


        if type(args.frame) == "Vector2" then
            properties.frame = args.frame
        elseif type(args.frame) == "table" then
            properties.frame = vector(args.frame[1],args.frame[2])
        else
            properties.frame = animationData.animator.currentFrame
        end


        if args.color ~= nil then
            properties.color = args.color
        elseif Defines.cheat_shadowmario then
            properties.color = Color.black
        else
            properties.color = Color.white
        end

        if args.priority ~= nil then
            properties.priority = args.priority
        elseif args.ignorestate then
            properties.priority = -25
        else
            properties.priority = animationPal.utils.getPlayerPriority(p)

            if properties.isMainRender then
                if properties.mount == MOUNT_YOSHI then
                    properties.priority = properties.priority + 0.01
                else
                    properties.priority = properties.priority - 0.01
                end
            end
        end

        if properties.mount == MOUNT_CLOWNCAR then
            -- Some weird hardcoded nonsense for the clown car...
            properties.y = properties.y - p.height + 18
        elseif properties.mount == MOUNT_YOSHI then
            properties.y = properties.y + p:mem(0x10E,FIELD_WORD)
        end

        
        properties.sceneCoords = (args.sceneCoords ~= false)
        properties.target = args.target


        charData.preDrawFunc(p,properties)


        properties.texture = args.texture or charData.getTextureFunc(p,properties)


        if animationData.sprite == nil or animationData.sprite.texture ~= properties.texture then
            animationData.sprite = Sprite{
                texture = properties.texture,
                frames = vector(properties.texture.width / charData.frameWidth,properties.texture.height / charData.frameHeight),
            }
        end


        if not properties.isInvisible then
            local sprite = animationData.sprite

            sprite.x = math.floor(properties.x + properties.offsetX*properties.direction*charData.imageDirection + properties.pivotOffset.x + 0.5)
            sprite.y = math.floor(properties.y + properties.offsetY + properties.pivotOffset.y + 0.5)

            sprite.scale.x = properties.scale.x*properties.direction*charData.imageDirection
            sprite.scale.y = properties.scale.y

            sprite.rotation = properties.rotation

            sprite.pivot = vector(
                properties.pivot.x + properties.pivotOffset.x/charData.frameWidth,
                properties.pivot.y + properties.pivotOffset.y/charData.frameHeight
            )
            sprite.texpivot = sprite.pivot

            sprite:draw{
                shader = properties.shader,uniforms = properties.uniforms,attributes = properties.attributes,
                priority = properties.priority,sceneCoords = properties.sceneCoords,color = properties.color,
                target = properties.target,
                frame = properties.frame,
            }
        end


        charData.postDrawFunc(p,properties)
    end


    -- Registers a character to use animationPal's custom player graphics system.
    function animationPal.registerCharacter(characterID,args)
        -- Default properties
        args.frameWidth  = args.frameWidth  or 100
        args.frameHeight = args.frameHeight or 100

        args.scale = args.scale or vector(1,1)
        args.offset = args.offset or vector(args.offsetX or 0,args.offsetY or 0)
        args.pivotOffset = args.pivotOffset or vector(args.pivotOffsetX or 0,args.pivotOffsetY or 0)

        args.imageDirection = args.imageDirection or DIR_LEFT

        args.imagePathFormat = args.imagePathFormat or (playerManager.getName(characterID).. "-%s.png")

        args.textures = {}

        -- Default functions
        for _,functionName in ipairs(characterFunctionNames) do
            args[functionName] = args[functionName] or animationPal.defaultCharacterFuncs[functionName]
        end


        characterData[characterID] = args
        setPlayerGraphic(characterID,emptyImage)
    end

    function animationPal.deregisterCharacter(characterID)
        if characterData[characterID] ~= nil then
            characterData[characterID] = nil
            setPlayerGraphic(characterID,nil)
        end
    end


    function animationPal.getCharacterData(characterID)
        return characterData[characterID]
    end

    function animationPal.getPlayerData(idx)
        local p = Player(idx)

        if not characterData[p.character] then
            return nil
        end

        local data = playerData[idx]

        if data == nil or data.characterID ~= p.character then
            data = {}

            data.characterID = p.character

            -- Create animator object
            local animatorArgs = {}

            for _,name in ipairs(animatorArguments) do
                animatorArgs[name] = characterData[p.character][name]
            end

            data.animator = animationPal.createAnimator(animatorArgs)
            data.animator.data.player = p

            data.updateWhilePaused = false

            data.onDrawOriginalFrame = p.frame

            data.sprite = nil

            playerData[idx] = data
        end

        return playerData[idx]
    end


    -- Adds (or replaces) an animation to a character's animation set and updates everything accordingly.
    function animationPal.addAnimation(character,animationName,animation)
        -- Add to character data
        local characterData = characterData[character]

        if characterData == nil then
            error("Character is not registered",2)
        end

        if characterData.animationSet ~= nil then
            characterData.animationSet[animationName] = animation
        end

        -- Add to animator, if it exists
        for _,p in ipairs(Player.get()) do
            local data = playerData[p.idx]

            if data ~= nil and data.characterID == character then
                data.animator.animationSet[animationName] = animation

                if data.animator.currentAnimation == animationName then
                    if animation ~= nil then
                        data.animator:forceSetAnimation(animationName)
                        data.animator.animationSpeed = 0
                    else
                        data.animator:forceSetAnimation(nil)
                    end
                end
            end
        end
    end


    local function updateAnimation(p)
        local charData = characterData[p.character]
        local data = animationPal.getPlayerData(p.idx)

        -- Run the pre-animate function.
        charData.preAnimateFunc(p,data.animator)

        -- Update the character's animation.
        local animationName,animationSpeed,forceRestart = charData.findAnimationFunc(p,data.animator)

        data.animator:setAnimation(animationName,animationSpeed,forceRestart)
        data.animator:update()

        -- Run the post-animate function.
        charData.postAnimateFunc(p,data.animator)
    end


    function animationPal.onTickEnd()
        for _,p in ipairs(Player.get()) do
            local data = animationPal.getPlayerData(p.idx)

            if data ~= nil and not data.updateWhilePaused then
                updateAnimation(p)
            end
        end
    end

    function animationPal.onDraw()
        for _,p in ipairs(Player.get()) do
            local data = animationPal.getPlayerData(p.idx)

            if data ~= nil then
                data.onDrawOriginalFrame = p.frame

                if data.updateWhilePaused then
                    updateAnimation(p)
                end

                local charData = characterData[p.character]

                charData.drawCharacterFunc(p,{isMainRender = true})
            end
        end
    end


    -- Overwrite player:render
    local normalPlayerRender = Player.render

    function Player.render(p,args)
        local data = animationPal.getPlayerData(p.idx)

        if data ~= nil then
            local charData = characterData[p.character]

            charData.drawCharacterFunc(p,args)

            -- Draw mounts
            args.drawplayer = false
            args.frame = nil

            normalPlayerRender(p,args)
        else
            normalPlayerRender(p,args)
        end
    end
end


-- Utility stuff (all for player stuff)
animationPal.utils = {}

do
    -- Returns the starman shader, and also uniforms for it.
    local starmanShader = Misc.multiResolveFile("starman.frag", "shaders\\npc\\starman.frag")

    function animationPal.utils.getStarmanShader()
        if type(starmanShader) == "string" then
            local sh = Shader()
            sh:compileFromFile(nil,starmanShader)

            starmanShader = sh
        end

        return starmanShader,{time = lunatime.tick()*2}
    end


    -- Returns a player's priority, taking the pipe forced state and the clown car into account.
    function animationPal.utils.getPlayerPriority(p)
        if p.forcedState == FORCEDSTATE_PIPE then
            return -70
        elseif p.mount == MOUNT_CLOWNCAR then
            return -35
        else
            return -25
        end
    end


    -- Returns if the player's animation acts if they're on the ground. Counts not only actually being on the ground, but also sinking in quicksand.
    function animationPal.utils.isOnGroundAnimation(p)
        return (
            p.speedY == 0
            or p:mem(0x48,FIELD_WORD)  ~= 0 -- on a slope
            or p:mem(0x176,FIELD_WORD) ~= 0 -- on a NPC/moving block

            -- Stuff that isn't actually on the ground
            or (p:mem(0x06,FIELD_WORD) > 0 and p.speedY > 0) -- sinking in quicksand
        )
    end

    
    -- Returns if the player is skidding
    function animationPal.utils.isSkidding(p)
        return (p.speedX > 0 and p.keys.left) or (p.speedX < 0 and p.keys.right)
    end


    -- Returns if the player is sliding on ice
    function animationPal.utils.isSlidingOnIce(p)
        return (p:mem(0x0A,FIELD_BOOL) and not p.keys.left and not p.keys.right)
    end


    -- Returns the direction of the pipe that the player is currently using
    function animationPal.utils.getPipeDirection(p)
        if p.forcedState ~= FORCEDSTATE_PIPE or p.forcedTimer >= 100 then
            return 0
        end

        local warp = Warp(p:mem(0x15E,FIELD_WORD) - 1)
        
        if p.forcedTimer <= 1 then -- entering
            return warp.entranceDirection
        else -- exiting
            return warp.exitDirection
        end
    end


    -- When climbing, returns the speed that the player is moving at, relative to what they are climbing on.
    function animationPal.utils.getClimbingSpeed(p)
        if not p.climbing then
            return 0,0
        end

        -- On an NPC
        local npc = p.climbingNPC

        if npc ~= nil then
            return (p.speedX - npc.speedX),(p.speedY - npc.speedY)
        end

        -- On a BGO (not applicable currently, will be in the future)
        local bgo = p.climbingBGO

        if bgo ~= nil then
            return (p.speedX - bgo.speedX),(p.speedY - bgo.speedY)
        end

        return p.speedX,p.speedY
    end
end


function animationPal.onInitAPI()
    registerEvent(animationPal,"onTickEnd","onTickEnd",false)
    registerEvent(animationPal,"onDraw","onDraw",false)
end


return animationPal