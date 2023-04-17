-- ###########################################
-- ##   REQUIRED SETUP FOR EP 3 PLAYABLES   ##
-- ###########################################
local particles = require("particles")

local extrasounds = require("extrasounds")
local RNG = require("rng")

local actorsys = require("a2xt_actor")
local ep3Playables = require("a2xt_ep3playables")

local players = {}
local playerCount = 0

local smasHud = require("smasHud")
local smasFunctions = require("smasFunctions")

-- Library table for the costume, config for default ep3Playables behavior goes here
local costume = {
    baseCharID = CHARACTER_MARIO,
    index = "Demo-XmasPily",
    path = "costumes/mario/Demo-XmasPily",

    powerupParticlesNames = {
        [3] = {"p_fireAura","p_fireEmbers"},
        [4] = {"p_leafAura","p_leafEmbers"},
        [5] = {"p_tanookiAura","p_tanookiEmbers"},
        [6] = {"p_smokeAura","p_smokeEmbers"},
        [7] = {"p_iceAura","p_iceEmbers1","p_iceEmbers2","p_iceEmbers3","p_iceEmbers4"},
        starman = {"p_superAura","p_superEmbers"},
        megashroom = {"p_megaAura", "p_megaEmbers"}
    },

    namespace = ACTOR_XMASPILY,
    keepPowerupOnHit = true,
    scaleDisabled = false
}

costume.loaded = false

costume.playerData = {}
costume.playersList = {}

local animeShader = Shader()
animeShader:compileFromFile(nil, Misc.resolveFile(costume.path .. "/p_anime.frag"))
local animeNoise = Graphics.loadImageResolved(costume.path .. "/perlinNoise.png")
local popTart = Graphics.loadImageResolved(costume.path .. "/poptart.png")


-- #############################
-- ##   PILY-SPECIFIC SETUP   ##
-- #############################

local afterimages = require("afterimages")

local megaWarnings = {
    {
        img = Graphics.loadImageResolved(costume.path .. "/megaWarning_top.png"),
        y = 60,
        speed = 64
    },
    {
        img = Graphics.loadImageResolved(costume.path .. "/megaWarning_bottom.png"),
        y = 540,
        speed = -64
    }
}
local megaWarningAlpha = 0

local textplus = require("textplus")
local soMadFont = textplus.loadFont("littleDialogue/font/a2xtfonts/font_crash.ini")
local soMadCounter = {
    tick = 0,
    step = 0,
    characters = 0
}


-- playerData vars specific to this costume's unique behavior
local extraData = {
    cannonballTimer = 0,
    isCannonball = false,
    didCannonballBounce = false,
    cannonballCachedSpeed = 0,
    cannonballArgs = {},

    cannonballInputBuffer = 0,

    lastSpeedY = 0,
    delayedBounceSpeed = false,

    capeOpen = false,
    capeDirection = 0,
    capeStartTime = 0,
    alreadyCaped = 0,
    maxCapes = {0,0,0,1,2,0,0},

    fireballSpeedMult = 1,
    fireballYet = false,
    fireballTimer = 0,
    cannonballFireballTimer = 0,

    chargeShotTimer = 0,
    chargeShotMax = 90,
    chargeShotMin = -20,

    customSounds = {}
}

local meltMap = {
    [3] = 669,
    [7] = 1151
}

local fireballIDMap = {}
local fireballIDs = {}

local function shootFireball(args)
    local pDat = args.playerData
    local p = pDat.p

    local dir = pDat:GetWalkDir(true)

    if pDat.fixedDirection then
        dir = pDat.pily.capeDirection
    end

    local scaleModifier = 2
    if  pDat.inst ~= nil  then
        scaleModifier = pDat.inst.scale
    end
    scaleModifier = scaleModifier*0.5

    local offset = args.offset  or  vector(0,0)
    local pos = args.position  or  (vector(p.x+0.5*p.width, p.y+p.height) + vector(dir*offset.x, -32 + offset.y)*scaleModifier)

    if  p.mount == MOUNT_CLOWNCAR  then
        pos.y = pos.y-96
    end

    local speed = args.speed  or  vector(6,0)
    local absSpeed = args.absSpeed  or  {}
    local id = args.id  or  13
    -- playSound = true
    local grav = args.gravity
    local bounc = args.maxBounces


    -- All regular fireballs become iceballs when in ice flower state
    if  id == 13  and  pDat.powerup == 7  then
        id = 265
    end


    fireballIDMap[id] = 1
    fireballIDs = table.unmap(fireballIDMap)

    local fireball = NPC.spawn(id, pos.x, pos.y, p.section, false, true)

    if  args.playSound ~= false  then
        if pDat.powerup == 7 then
            SFX.play("costumes/mario/Demo-XmasPily/iceball.ogg")
        elseif pDat.powerup >= 1 and pDat.powerup <= 6 then
            SFX.play("costumes/mario/Demo-XmasPily/fireball.ogg")
        end
    end

    fireball.speedX = (absSpeed.x  or  speed.x*dir) * pDat.pily.fireballSpeedMult
    fireball.speedY = (absSpeed.y  or  speed.y) * pDat.pily.fireballSpeedMult

    fireball.data.xmasPily = {gravity = grav, maxBounces = bounc, buoyant = args.buoyant}
end

local oldHammerConfig = {}

local function initPilyData(pDat)
    if  pDat.pily == nil  then

        -- Data table
        pDat.pily = table.join(extraData, {
            em_charge = particles.Emitter(0,0, Misc.resolveFile(costume.path .. "/p_charge.ini"))
        })
        --pDat.pily.em_charge:Attach(pDat.p, true, true)
        pDat.pily.em_charge.enabled = false


        -- Added methods
        pDat.Stomp = function(self, afterState)
            pDat:Pose("stomp")
            Routine.run(function()
                while (pDat.inst.step <= 4)  do
                    Routine.skip()
                end

                SFX.play("sound/block-hit.ogg")
                Defines.earthquake = 5
                Routine.wait(0.15)

                if  afterState ~= nil  then
                    pDat:Pose(afterState)
                end

                return true
            end)
        end

        pDat.DoChargeShot = function(self, afterState)
            Routine.run(function()
                for i=self.pily.chargeShotMin, self.pily.chargeShotMax do
                    self.pily.chargeShotTimer = i
                    if  self.pily.chargeShotTimer == 0  then
                        SFX.play(costume.path .. "/charge1.ogg")
                    end
        
                    if  self.pily.chargeShotTimer == self.pily.chargeShotMax  then
                        SFX.play(costume.path .. "/charge2.ogg")
                    end
                    Routine.waitFrames(1)
                end

                for i=1, 30 do
                    self.pily.chargeShotTimer = self.pily.chargeShotMax
                    Routine.waitFrames(1)
                end

                shootFireball{
                    playerData=self,
                    offset=vector(16,4), speed=vector(8+math.abs(self.p.speedX),0),
                    id=171,
                    sound = "sound/extended/flame-shield-dash.ogg",
                    gravity=0
                }
                Defines.earthquake = 5
                self.pily.chargeShotTimer = self.pily.chargeShotMin

                return true
            end)
        end
        
        pDat.waitForBounce = function(self)
            while  (not self.pily.didCannonballBounce)  do
                Routine.skip()
            end

            return true
        end

        pDat.performCannonball = function(self, args)
            args = args or {}

            if  args.instant  then
                self.pily.cannonballTimer = 8
            else
                self.pily.cannonballTimer = 1
            end
            self.pily.cannonballArgs = args
        end
        
        pDat.shootFireball = function(self, args)
            self.pily.fireballTimer = 16
        
            
            -- Defaults
            if  args == nil  then
                
                local p = self.p

                -- Set up the fireball args
                args = {offset=vector(16,-4), speed=vector(5,-2), maxBounces=2}
        
                if  self.powerup == 7 then
                    args.buoyant = true
                end
        
                if  self.powerup == 3 then
                    -- Aiming upward
                    if  p.keys.up == KEYS_DOWN and not Misc.isPaused() then
                        args.speed = vector(5,-7)
                    elseif p.keys.down == KEYS_DOWN and not p:isOnGround() and not Misc.isPaused() then
                        args.speed = vector(6,5)
                    else
                        args.gravity = 0.1
                        args.speed = vector(8,-1)
                    end
                else
                    -- Aiming upward
                    if p.keys.up == KEYS_DOWN and not Misc.isPaused() then
                        args.speed = vector(3,-6)
                    end
                end
        
                args.speed.x = args.speed.x + math.abs(p.speedX)
        
        
                -- Ducking
                if  p:mem(0x12E, FIELD_BOOL)  then
                    args.offset.y = 12
                end
            end

            args.playerData = self
            shootFireball(args)
        end
    end
end

local function getInitialPlayerKeys(playerObj)
    local pkeys = {}
    for  k,v in pairs(playerObj.keys)  do
        pkeys[k] = v
    end
    return pkeys
end




-- ####################################################
-- ##   BOILERPLATE CODE/CONFIG FOR EP 3 PLAYABLES   ##
-- ####################################################

-- CUSTOM INPUT, ANIMATION, AND POST-DRAW BEHAVIOR
local inputEvent = function(playerData, p)

    if player.character ~= 1 then return end

    if player.deathTimer > 0 then
        return
    end

    -- Initialize costume-specific data
    initPilyData(playerData)
    local pilyData = playerData.pily


    -- Checks
    local isGrounded = p:isGroundTouching()
    local isHoldingFlight = not p:mem(0x174, FIELD_BOOL)
    local isDucking = p:mem(0x12E, FIELD_BOOL)
    local isUnderwater = p:mem(0x34, FIELD_WORD) == 2
    local isCarrying = (p.holdingNPC ~= nil and p.holdingNPC ~= 0)
    local isSpinjumping = p:mem(0x50, FIELD_BOOL)
    local isRainbowRiding = p:mem(0x44, FIELD_BOOL)
    local isClimbing = p:isClimbing()
    local canFly = p:mem(0x16E, FIELD_BOOL)
    local isFlying = p:mem(0x16E, FIELD_BOOL) and isHoldingFlight
    local isStatue = p:mem(0x4A, FIELD_BOOL)
    local isFairy = p:mem(0x0C,FIELD_BOOL)

    local initPKeys = getInitialPlayerKeys(p)


    -- CHARGE ATTACK
    local chargeMin = pilyData.chargeShotMin
    local chargeMax = pilyData.chargeShotMax

    if playerData.powerup == 6 and (not isFairy) and not Misc.isPaused() then
        Text.print(tostring(pilyData.chargeShotTimer),100,100)
        -- Hold the charge
        if (p.keys.run == KEYS_PRESSED or p.keys.run == KEYS_DOWN or p.forcedState == 2 or (pilyData.chargeShotTimer > chargeMin)) then
            pilyData.chargeShotTimer = math.min(chargeMax+1, pilyData.chargeShotTimer+1)

            if pilyData.chargeShotTimer == 0 then
                SFX.play(costume.path.."/charge1.ogg")
            end

            if pilyData.chargeShotTimer == chargeMax then
                SFX.play(costume.path.."/charge2.ogg")
            end

        -- Start the charge
        elseif p.keys.run == KEYS_PRESSED and pilyData.chargeShotTimer == chargeMin then
            pilyData.chargeShotTimer = pilyData.chargeShotTimer+1
        -- Release the charge
        else
            if pilyData.chargeShotTimer >= chargeMax and (p.forcedState == 0) and not Misc.isPaused() then
                shootFireball{
                    playerData=playerData,
                    offset=vector(16,4), speed=vector(8+math.abs(p.speedX),0),
                    id=171,
                    sound = "sound/extended/flame-shield-dash.ogg",
                    gravity=0
                }
                Defines.earthquake = 5
            end
            pilyData.chargeShotTimer = chargeMin
        end

    else
        pilyData.chargeShotTimer = chargeMin
    end



    -- TANOOKI STATUE
    if   playerData.powerup == 5
    and  p.forcedState == 0
    and  p.mount == 0
    and  not p.isMega
    and  not p.isFairy
    then
        --Text.print("Mem 0x4C: "..tostring(p:mem(0x4C, FIELD_WORD)), 3, 20, 400)
        --Text.print("Mem 0x4E: "..tostring(p:mem(0x4E, FIELD_WORD)), 3, 20, 420)


        -- While in statue mode
        if   p:mem(0x4A, FIELD_BOOL)  then

            -- Hold to extend the statue time
            if   p.keys.altRun == KEYS_DOWN
            and  p:mem(0x4E, FIELD_WORD) > 0
            then
                p:mem(0x4C, FIELD_WORD, 15)
            end

            -- Hopping
            if  isGrounded  then
                local speedAdd = 0

                if  p.rawKeys.left == KEYS_DOWN  then
                    p.speedY = -2
                    speedAdd = speedAdd-0.5
                end
                if  p.rawKeys.right == KEYS_DOWN  then
                    p.speedY = -2
                    speedAdd = speedAdd+0.5
                end
                if  speedAdd ~= 0  then
                    p.speedX = speedAdd
                end
            end

        -- Start statue
        elseif   p.keys.altRun == KEYS_PRESSED  
        and  p:mem(0x4C, FIELD_WORD) == 0
        then
            p.forcedState = FORCEDSTATE_TANOOKI_POOF
        end
    end


    -- FIREBALLS
    pilyData.fireballTimer = math.max(0, pilyData.fireballTimer-1)
    local playerFireballs = NPC.get(13, p.section)
    local pFireballCount = #playerFireballs

    for  k,v in ipairs(playerFireballs)  do
        if  v.despawnTimer < 150  then
            pFireballCount = pFireballCount-1
        end
    end
    
    if  p.keys.run == KEYS_UNPRESSED  or  p.keys.run == KEYS_UP and not Misc.isPaused() then
        pilyData.fireballYet = true
    end

    if  p.keys.run == KEYS_PRESSED
    and  not isClimbing
    and  p.forcedState == 0
    and  p.mount == MOUNT_NONE
    and  (not isFairy)
    and  pFireballCount < 3
    and  pilyData.fireballYet
    and  pilyData.fireballTimer == 0
    then
        playerData:shootFireball()
    end


    -- CAPE
    if   (playerData.powerup == 4  or  playerData.powerup == 5)
    and  not isClimbing
    and  not isSpinjumping
    and  p.mount == 0
    and  not isUnderwater  then
        
        playerData.fixedDirection = pilyData.capeOpen  and  not isGrounded
        if  not isGrounded  then

            if  pilyData.capeOpen  then
                local capeTime = lunatime.time() - pilyData.capeStartTime

                p.direction = pilyData.capeDirection

                local forwardSpeedMult = 5
                if      p.direction == DIR_RIGHT  and  p.keys.right == KEYS_DOWN
                or      p.direction == DIR_LEFT  and  p.keys.left == KEYS_DOWN  then
                    forwardSpeedMult = 6
                elseif  p.direction == DIR_LEFT  and  p.keys.right == KEYS_DOWN
                or      p.direction == DIR_RIGHT  and  p.keys.left == KEYS_DOWN  then
                    forwardSpeedMult = 4
                end

                p.speedX = math.lerp(p.speedX, p.direction*forwardSpeedMult, 0.5)
                Defines.player_grav = 0.2
                Defines.gravity = capeTime*8
                if  p.keys.jump ~= KEYS_DOWN  or  capeTime > 1  then
                    pilyData.capeOpen = false
                end
            
            else
                Defines.player_grav = 0.4
                Defines.gravity = 12
            end

            if p.keys.jump == KEYS_PRESSED and p.forcedState == 0 and (not p.isMega) and (not isFairy) and (not isStatue) and  (pilyData.alreadyCaped < pilyData.maxCapes[playerData.powerup])  then
                pilyData.capeOpen = true
                pilyData.alreadyCaped = pilyData.alreadyCaped + 1
                -- we only have 1 and 2 right now
                local idx = math.min(pilyData.alreadyCaped, 2)
                SFX.play(Misc.resolveSoundFile("costumes/mario/Demo-XmasPily/extended/cape-swoop".. idx ..".ogg"))
                pilyData.capeDirection = p.direction
                pilyData.capeStartTime = lunatime.time()
                p.speedY = math.max(math.min(p.speedY, 0) -5, -10)
            end

        else
            pilyData.capeOpen = false
            pilyData.alreadyCaped = 0
        end
    
    else
        playerData.fixedDirection = false
        Defines.player_grav = 0.4
        Defines.gravity = 12
        pilyData.capeOpen = false
        pilyData.alreadyCaped = 0
    end


    -- CANNONBALL MOVE
    if  p.mount == MOUNT_NONE  and  isGrounded  then
        p.keys.altJump = KEYS_UP
    end


    -- Fix for bouncing off NPCs
    if  pilyData.delayedBounceSpeed  then
        pilyData.delayedBounceSpeed = false
        p.speedY = -10
    end

    if p.speedY < 0 and pilyData.lastSpeedY > 0 and p:mem(0x11C, FIELD_WORD) > 0 then
        pilyData.didCannonballBounce = true
        EventManager.callEvent("onPilyBounce")
    end

    -- Cancel the cannonball move
    if  isClimbing
    or  isFairy
    or  isStatue
    or  (p.forcedState == 3 or p.forcedState == 6 or p.forcedState == 7 or p.forcedState == 8 or p.forcedState == 9 or p.forcedState == 10 or p.forcedState == 499 or p.forcedState == 500)
    or  p.mount ~= MOUNT_NONE
    or  isUnderwater  then
        pilyData.isCannonball = false
        pilyData.didCannonballBounce = false
        pilyData.cannonballTimer = 0

        -- Regular jump when pressing altJump
        if  (initPKeys.altJump)  then
            if not initPKeys.jump then
                p.keys.jump = KEYS_PRESSED
            end
            if  p.mount == MOUNT_NONE  then
                p.keys.altJump = KEYS_UP
            end
        end

    -- Can only start the cannonball move in the air
    elseif 
    not isGrounded
    then

        -- Hold spinjump while in cannonball mode
        if  pilyData.isCannonball  then
            p.keys.altJump = KEYS_DOWN
            p:mem(0x50, FIELD_BOOL, true)

            -- Screw attack
            if playerData.powerup == 6 then
                p:mem(0x140, FIELD_WORD, math.max(1, p:mem(0x140, FIELD_WORD)))
                p:mem(0x142, FIELD_BOOL, true)
                for k,v in ipairs(Colliders.getColliding{
                    a = p,
                    b = NPC.HITTABLE,
                    btype = Colliders.NPC,
                    filter = function(other)
                        return not (other.isHidden or other.isGenerator or other.friendly or other:mem(0x138, FIELD_WORD) > 0 or other.despawnTimer <= 0)
                    end
                }) do
                    v:harm(8)
                end
            end
        end

        -- Count up until the dive
        if  (not pilyData.isCannonball  and  pilyData.cannonballTimer > 0)  then
            pilyData.cannonballTimer = pilyData.cannonballTimer+1
            p.speedX = 0.85*p.speedX
            p.speedY = 0.0001

            if p:isOnGround() then
                isSpinjumping = false
                pilyData.didCannonballBounce = false
                pilyData.isCannonball = false
                pilyData.cannonballTimer = 0
            else
                -- Locked into performing it
                if  pilyData.cannonballTimer >= 8  then
                    pilyData.cannonballTimer = 0
    
                    if  playerData.powerup == 6  then
                        Sound.playSFX("sound/character/ur_claw.ogg")
                    elseif  playerData.powerup == 3  then
                        Sound.playSFX("sound/extended/flame-shield-dash.ogg")
                    else
                        Sound.playSFX("sound/boot.ogg")
                    end
                    p:mem(0x50, FIELD_BOOL, true)
                    isSpinjumping = true
                    p.speedY = pilyData.cannonballArgs.speedY  or  8
                    p.speedX = pilyData.cannonballArgs.speedX  or  pilyData.cannonballCachedSpeed
    
                    pilyData.cannonballCachedSpeed = 0
                    pilyData.isCannonball = true
                end

            end
        else
            pilyData.cannonballTimer = 0
        end


        -- Start upon pressing altJump
        if  p.rawKeys.altJump == KEYS_PRESSED
        and  not Misc.isPaused()
        and  not isCarrying
        and  p.forcedState == 0
        and  pilyData.cannonballTimer == 0
        then
            pilyData.cannonballInputBuffer = 15
        end
        
        if   pilyData.cannonballInputBuffer > 0
        and  not pilyData.isCannonball
        then
            pilyData.cannonballInputBuffer = 0
            pilyData.cannonballTimer = 1
            pilyData.cannonballCachedSpeed = p.speedX
            pilyData.capeOpen = false
            p:mem(0x11C,FIELD_WORD,0)
        end

        if isSpinjumping then
            p.direction = playerData:GetWalkDir(true)
        end

    
        -- End the cannonball move at the peak of the bounce
        if  pilyData.didCannonballBounce  and  p.speedY > -1  and  p.speedY < 0  then
            p:mem(0x50, FIELD_BOOL, false)
            playerData.fixedDirection = false
            playerData.inst.xScale = p.direction
            isSpinjumping = false
            pilyData.didCannonballBounce = false
            pilyData.isCannonball = false
            pilyData.cannonballTimer = 0
            pilyData.cannonballArgs = {}
        end


    -- Cannonball bounce impact
    elseif  pilyData.isCannonball  then
        if  p.standingNPC ~= nil  then
            
            p.y = p.y-1
            p.keys.jump = KEYS_DOWN
            pilyData.delayedBounceSpeed = true
        else
            p.speedY = -10
        end
        SFX.play{sound=(pilyData.customSounds.bounce  or  "costumes/mario/Demo-XmasPily/extended/bubble-shield-jump.ogg"), volume=0.5}

        p.speedY = -p.speedY
        local reduceSpeedY = false
        for k,v in Block.iterateIntersecting(p.x - p.speedX, p.y + p.speedY, p.x + p.width + p.speedX, p.y + p.height + p.speedY) do
            if not (v.isHidden or v:mem(0x5A, FIELD_BOOL)) then
                if Colliders.speedCollide(p, v) then
                    if (v.id == 90 or v.id == 4 or v.id == 60 or v.id == 188 or v.id == 226 or v.id == 526) and v.contentID == 0 then
                        v:remove(true)
                    else
                        v:hit()
                    end

                    if v.id == 742 or v.id == 743 then
                        reduceSpeedY = true
                    end
                end
            end
        end
        if reduceSpeedY then
            p.speedY = p.speedY * 0.2
        end
        p.speedY = -p.speedY

        -- Spawn fireballs
        if  (playerData.powerup == 3  or  playerData.powerup == 7)  then  

            -- Melt blocks of opposite element
            local isMeltingBlocks, meltBlockCount, meltBlockList = playerData:GetTouchingBlocks(meltMap[playerData.powerup])
            if  isMeltingBlocks  then
                isMeltingBlocks = false
                for  k,v in ipairs(meltBlockList)  do
                    if (not v.isHidden) and v:mem(0x5A, FIELD_BOOL) == false then
                        isMeltingBlocks = true
                        shootFireball{playerData=playerData, position=vector(v.x+16,v.y+16), speed=vector(0,0), maxBounces=1}
                    end
                end
            end

            -- Spawn fireballs
            if   not pilyData.didCannonballBounce
            and  not isMeltingBlocks
            and  not p.isMega
            then
                local isBuoyant = false
                if playerData.powerup == 7 then
                    isBuoyant = true
                end
                
                if  pilyData.cannonballFireballTimer == 0  then
                    pilyData.cannonballFireballTimer = 40
                    shootFireball{playerData=playerData, absSpeed=vector( 2 + p.speedX, -10), maxBounces=2, buoyant=isBuoyant}
                    shootFireball{playerData=playerData, absSpeed=vector(-2 + p.speedX, -10), maxBounces=2, buoyant=isBuoyant}
                    shootFireball{playerData=playerData, absSpeed=vector( 4 + p.speedX,  -6), maxBounces=2, buoyant=isBuoyant}
                    shootFireball{playerData=playerData, absSpeed=vector(-4 + p.speedX,  -6), maxBounces=2, buoyant=isBuoyant}
                end
            end
        end


        --if  playerData.powerup == 3  then
        --    SFX.play("sound/extended/flame-shield.ogg")
        --else
        --end
        pilyData.didCannonballBounce = true
        EventManager.callEvent("onPilyBounce")
        
    -- Regular jump
    else
        if  initPKeys.altJump  then
            if (initPKeys.jump) then
                p.keys.altJump = KEYS_UNPRESSED
            end
            p.keys.jump = initPKeys.altJump
        end
    end

    pilyData.cannonballFireballTimer = math.max(pilyData.cannonballFireballTimer-1, 0)
    --Text.print(tostring(pilyData.cannonballFireballTimer), 3, 20,20)




    -- Fireball NPCs behavior
    if (not Defines.levelFreeze) and (not Misc.isPaused()) then
        for  _,v in NPC.iterate(fireballIDs)  do
            local pFBDat = v.data.xmasPily  or  {}

            if pFBDat.gravity == nil then
                pFBDat.gravity = Defines.npc_grav
            end

            v.ai1 = 3
            v.ai2 = 0

            local internalGravityMultiplier = 1
            local ownGravityMultiplier = 1
            if (v.id == 13 or v.id == 265) and v.ai1 == 3 then
                internalGravityMultiplier = 0.9 -- fireballs travel at this multiplier
                ownGravityMultiplier = 0.9
            end

            if v:mem(0x1C, FIELD_WORD) == 2 then
                internalGravityMultiplier = internalGravityMultiplier * 0.2 -- yup, water
                if not pFBDat.buoyant then
                    ownGravityMultiplier = ownGravityMultiplier * 0.2 -- yup, water
                else
                    ownGravityMultiplier = ownGravityMultiplier * -0.1 -- yup, water
                end
            end

            v.speedY = v.speedY - (Defines.npc_grav * internalGravityMultiplier) + pFBDat.gravity * ownGravityMultiplier

            pFBDat.bounces = pFBDat.bounces  or  0
            if  v.collidesBlockBottom or v.collidesBlockLeft or v.collidesBlockRight or v.collidesBlockUp  then
                pFBDat.bounces = pFBDat.bounces+1
                v.speedX = v.speedX * 0.4
                v.speedY = v.speedY * 0.4
            end

            if  pFBDat.maxBounces ~= nil  and  pFBDat.bounces == pFBDat.maxBounces  then
                v:kill()
            end

            -- Stop hammer charge shots from existing too far offscreen  
            if   v.id == 171  
            and  (v.x > camera.x+896  or  v.x+v.width+64 < camera.x-96)
            then
                v:kill()
            end
        end
    end

    pilyData.lastSpeedY = p.speedY
    pilyData.cannonballInputBuffer = pilyData.cannonballInputBuffer - 1
end

local animEvent = function(playerData, p, inst)

    if player.character ~= 1 then return end

    -- Initialize costume-specific data
    initPilyData(playerData)
    local pilyData = playerData.pily
    

    -- Checks
    local isSpinjumping = p:mem(0x50, FIELD_BOOL)


    -- Disable defaults if any of the below conditions are true
    local disableDefault = true

    -- Cape
    if  pilyData.capeOpen == true and p.forcedState == 0 and not p:mem(0x4A, FIELD_BOOL) then
        inst:startState {state="glidestart", commands=true}
    elseif  pilyData.alreadyCaped > 0 and p.forcedState == 0 and not p:mem(0x4A, FIELD_BOOL) then
        inst:startState {state="glidedrop", commands=true}
    
    -- Cannonball
    elseif  pilyData.cannonballTimer > 0  and  not isSpinjumping  then
        inst:startState {state="chargespinjump", commands=true}



    -- Do the default animation behavior
    else
        disableDefault = false
    end


    -- Statue cooldown indicator
    local isStatue = p:mem(0x4A, FIELD_BOOL)
    local statueCooldown = p:mem(0x4C, FIELD_WORD)
    if  statueCooldown ~= 0  and  not isStatue  then
        local statueCooldownPercent = math.clamp(math.invlerp(0,90,statueCooldown),0,1)
        
        Graphics.drawImageToSceneWP(
            popTart,
            p.x + 0.5*p.width - 8,
            p.y - 24 + 20*statueCooldownPercent,
            0,
            20*statueCooldownPercent,
            16,
            20*(1-statueCooldownPercent),
            0.75,
            inst.z+0.02
        )
    end


    -- PARTICLES
    local em_charge = playerData.pily.em_charge
    em_charge.enabled = (player.deathTimer == 0 and playerData.powerup == 6  and  pilyData.chargeShotTimer >= 0  and  pilyData.chargeShotTimer < pilyData.chargeShotMax)
    playerData:CenterEmitter(em_charge)

    em_charge:draw{priority=inst.z+0.01, nocull=true}
    
    
    if p.deathTimer >= 0 then
        onehp = false
        twohp = false
        threehp = false
    end
    if playerData.hp == 1 then
        onehp = true
        twohp = false
        threehp = false
    end
    if playerData.hp == 2 then
        onehp = false
        twohp = true
        threehp = false
    end
    if playerData.hp == 3 then
        onehp = false
        twohp = false
        threehp = true
    end

    -- PALETTE ANIMATION
    playerData.paletteOffset = nil
    
    local chargeMax = pilyData.chargeShotMax
    local isCharging = pilyData.chargeShotTimer >= 0
    local fullyCharged = pilyData.chargeShotTimer >= chargeMax
    
    local flashOn = false

    if  (playerData.powerup == 6  and  isCharging)  or  p.isMega  then
        flashOn = math.floor(10*lunatime.time()) % 2 == 0
    elseif  playerData.hp == 1  then
        flashOn = math.floor((lunatime.time()*40)) % 20 >= 18
    end
    
    -- Low HP
    if  playerData.hp == 1  then
        if  flashOn  then
            playerData.paletteOffset = 10
        end
    end

    -- Charge attack flashing

    if   playerData.powerup == 6  
    and  (isCharging  or  pilyData.isCannonball)
    then
        if  (flashOn  and  not fullyCharged)
        or  (not flashOn  and  fullyCharged)
        or  (flashOn and pilyData.isCannonball)  then
            playerData.paletteOffset = 8
        end

        if  (flashOn  and  fullyCharged)  then
            playerData.paletteOffset = 9
        end
    end

    -- Megashroom
    if  p.isMega  and  (not playerData.megaShrinking  or  flashOn)  then
        playerData.paletteOffset = 11
    end


    --Text.print(inst.state, 3, 20,120)
    --Text.print(inst.step, 3, 20,140)
    --Text.print(inst.frame, 3, 20,160)
    
    return disableDefault
end

local vertsScreen = {0,0,800,0,800,600,0,600}
local texScreen = {0,0,1,0,1,1,0,1}

local drawEndEvent = function(playerData, p)

    if player.character ~= 1 then return end
    initPilyData(playerData)

    -- Afterimages for charge attack and starman
    if not Misc.isPaused() and ((playerData.powerup == 6  and  playerData.pily.chargeShotTimer >= playerData.pily.chargeShotMax)
    or  p.hasStarman)  then

        afterimages.addAfterImage{
            x = RNG.random(-16,16),
            y = RNG.random(-16,16),
            texture = playerData.postProcessBuffer,
            width=800, height=600,
            texOffsetX=0, texOffsetY=0,
            sceneCoords=false,
            lifetime=12,
            color=Color(0.5,0.25,0.25,0.01),
            priority=playerData.inst.z-0.00001
        }

        afterimages.addAfterImage{
            x = RNG.random(-8,8),
            y = RNG.random(-8,8),
            texture = playerData.postProcessBuffer,
            width=800, height=600,
            texOffsetX=0, texOffsetY=0,
            sceneCoords=false,
            lifetime=12,
            color=Color(0.5,0.25,0.25,0.01),
            priority=playerData.inst.z-0.00001
        }

        afterimages.addAfterImage{
            x = RNG.random(-4,4),
            y = RNG.random(-4,4),
            texture = playerData.postProcessBuffer,
            width=800, height=600,
            texOffsetX=0, texOffsetY=0,
            sceneCoords=false,
            lifetime=12,
            color=Color(0.5,0.25,0.25,0.01),
            priority=playerData.inst.z-0.00001
        }
    end

    -- WARNING !! MEGASHROOM
    if  p.isMega  and  not playerData.megaShrinking  then
        megaWarningAlpha = math.min(megaWarningAlpha+0.05, 1)
    else
        megaWarningAlpha = math.max(megaWarningAlpha-0.05, 0)
    end


    -- starman
    if p.hasStarman then
        
        -- ANIME MODE
        Graphics.glDraw{
            shader = animeShader,
            texture = animeNoise,
            vertexCoords = vertsScreen,
            textureCoords = texScreen,
            primitive = Graphics.GL_TRIANGLE_FAN,
            priority = 4,
            uniforms = {
                iTime = lunatime.time()
            }
        }

        -- SO MAD text
        soMadCounter.tick = (soMadCounter.tick+1) % 45
        if  soMadCounter.tick == 0  then
            soMadCounter.step = (soMadCounter.step+1) % 12

            -- skip the space
            if  soMadCounter.step == 2  then
                soMadCounter.step = soMadCounter.step+1
            end

            soMadCounter.characters = 7
            if  soMadCounter.step < 7  then
                soMadCounter.characters = soMadCounter.step

            elseif  soMadCounter.step > 8  and  soMadCounter.step%2 == 1  then
                soMadCounter.characters = 0
            end
        end

        if  soMadCounter.tick >= 8  then
            textplus.print{
                x=400, y=160,
                xscale=2,
                yscale=2,
                text = "<color 0xC63838FF>SO MAD!</color>",
                font = soMadFont,
                pivot = vector(0.5,0.1),
                limit = soMadCounter.characters
            }
        end
    end
    
    for  _,v in ipairs(megaWarnings)  do
        for  i=-1,1  do
            local args = {
                texture = v.img,
                
                x = i*v.img.width + (lunatime.time()*v.speed)%v.img.width,
                y = v.y,
                width = v.img.width, height = v.img.height,

                color = Color.black .. megaWarningAlpha,
                priority = 6
            }

            Graphics.drawBox(args)
            
            args.color = Color.white .. megaWarningAlpha
            args.x = args.x-2
            args.y = args.y-2
            Graphics.drawBox(args)
        end
    end
end


local hammerConfig = {
    width=44,
    height=44,
    gfxwidth=80,
    gfxheight=52,
    frames=4,
    framestyle=1,
    framespeed=4
}


-- ################
-- ##   EVENTS   ##
-- ################

local coyotetime
local ppp
local lastCt
local spintrail

function costume.onInit(playerObj)
    if not costume.loaded then
        Sound.loadCostumeSounds()
        costume.loaded = true
    end
    coyotetime = require("coyotetime");
    ppp = require("playerphysicspatch");
    spintrail = require("a2xt_spintrail")
    spintrail.colorOverride[CHARACTER_MARIO] = Color.white
    spintrail.setParam("colTime", "{0,0.1,0.4,1},{0xFFFF00, 0xFFDD00, 0xFF2244, 0xDD2266}")
    spintrail.setParam("lifetime", "0.4")
    spintrail.setParam("width", "24")
    spintrail.setParam("xOffset", "-8:8")
    spintrail.setParam("yOffset", "-8:8")
    spintrail.setParam("rate", "100")

    local config = NPC.config[171]
    for  k,v in pairs(hammerConfig)  do
        oldHammerConfig[k] = config[k]
        config[k] = v
    end

    -- Fix town Demo NPCs not appearing
    --[[
    for  _,v in ipairs(NPC.get(980))  do
        if  v.data.xmasPilyCostume == nil  then
            v.data.xmasPilyCostume = {
                fixedCostume = v.data.fixedCostume
            }
            v.data.fixedCostume = "Demo-Centered"
        end
    end
    --]]


    lastCt = coyotetime.onJump
    coyotetime.onJump = function(p, isSpinJumping)
        -- fix spinjumping
        if p.getA2xtData and p.getA2xtData() then
            p:mem(0x11E, FIELD_BOOL, true)
            p:mem(0x120, FIELD_BOOL, false)
        end
    end

    players[playerObj] = ep3Playables.register(playerObj, costume, inputEvent, animEvent, drawEndEvent);

    registerEvent(costume, "onPostNPCKill");
    registerEvent(costume, "onTick");
    registerEvent(costume, "onTickEnd");
    registerEvent(costume, "onDraw");
    playerCount = playerCount+1
end

local heartfull2 = Graphics.loadImageResolved("costumes/mario/Demo-XmasPily/hp_carrot.png")
local heartempty2 = Graphics.loadImageResolved("costumes/mario/Demo-XmasPily/hp_carrot_empty.png")

function costume.onDraw()
    if Graphics.isHudActivated() then
        if smasHud.visible.customItemBox then
            if onehp then
                Graphics.drawImageWP(heartfull2, 357, 80, 5)
                Graphics.drawImageWP(heartempty2, 388, 80, 5)
                Graphics.drawImageWP(heartempty2, 421, 80, 5)
            end
            if twohp then
                Graphics.drawImageWP(heartfull2, 357, 80, 5)
                Graphics.drawImageWP(heartfull2,  388, 80, 5)
                Graphics.drawImageWP(heartempty2, 421, 80, 5)
            end
            if threehp then
                Graphics.drawImageWP(heartfull2, 357, 80, 5)
                Graphics.drawImageWP(heartfull2, 388, 80, 5)
                Graphics.drawImageWP(heartfull2, 421, 80, 5)
            end
        end
    end
end

local jumprng

function costume.onTick()
    for _,p in ipairs(costume.playersList) do
        local data = costume.playerData[playerObj]
    end
end

function costume.onTickEnd()
    jumprng = RNG.randomInt(1,6)
    extrasounds.sounds[1].sfx = Audio.SfxOpen("costumes/mario/Demo-XmasPily/jumps/jump-"..jumprng..".ogg")
end

function costume.onCleanup(playerObj, p)
    onehp = false
    twohp = false
    threehp = false
    Sound.cleanupCostumeSounds()
    players[playerObj] = nil
    spintrail.colorOverride[CHARACTER_MARIO] = nil
    spintrail.resetParam("colTime")
    spintrail.resetParam("lifetime")
    spintrail.resetParam("width")
    spintrail.resetParam("xOffset")
    spintrail.resetParam("yOffset")
    spintrail.resetParam("rate")
    ep3Playables.cleanup(playerObj, costume, costumeTable, extraInputFunct, extraAnimFunct, extraDrawFunct, 
    inputEvent, animEvent, drawEndEvent);
    playerCount = playerCount-1
    coyotetime.onJump = lastCt
    players[playerObj] = nil
    for _,p in ipairs(costume.playersList) do
        ep3Playables.cleanup(playerObj, characterInfo, costume)
    end
    local config = NPC.config[171]
    
    local spot = table.ifind(costume.playersList,playerObj)

    if spot ~= nil then
        table.remove(costume.playersList,spot)
    end

    if ep3Playables == true then return end
    for  k,v in pairs(oldHammerConfig)  do
        config[k] = v
    end
    
    

    -- Clean up town Demo NPCs not appearing
    --[[
    for  _,v in ipairs(NPC.get(980))  do
        if  v.data.xmasPilyCostume ~= nil  then
            v.data.fixedCostume = v.data.xmasPilyCostume.fixedCostume
            --v.data._settings.isClone = true
        end
        v.data.xmasPilyCostume = nil
    end
    --]]

    if  playerCount == 0  then
        unregisterEvent(costume, "onPostNPCKill");
        --unregisterEvent(costume, "onInputUpdate");
    end
    
end




function costume.onPostNPCKill(killedNPC,harmType)
    if player.character ~= 1 then return end
    if   harmType == HARM_TYPE_SPINJUMP  then
        for  p,v in pairs(players)  do
            if   p:mem(0x50, FIELD_BOOL) -- is spinjumping?
            and  v.pily.isCannonball
            then
                v.pily.didCannonballBounce = true
                p.speedY = -10
            end
        end
    end
end



Misc.storeLatestCostumeData(costume)

return costume;