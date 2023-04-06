--NPCManager is required for setting basic NPC properties
local npcManager = require("npcManager")
local npcutils = require("npcs/npcutils")
local rng = require("base/rng")
local colliders = require("colliders")
local timer = require("timer")
local handycam = require("handycam")
local extrasounds = require("extrasounds")

--Create the library table
local sampleNPC = {}
--NPC_ID is dynamic based on the name of the library file
local npcID = NPC_ID

--Defines NPC config for our NPC. You can remove superfluous definitions.
local sampleNPCSettings = {
    id = npcID,
    --Sprite size
    gfxheight = 76,
    gfxwidth = 64,
    --Hitbox size. Bottom-center-bound to sprite size.
    width = 64,
    height = 64,
    --Sprite offset from hitbox for adjusting hitbox anchor on sprite.
    gfxoffsetx = 0,
    gfxoffsety = 2,
    --Frameloop-related
    frames = 7,
    framestyle = 0,
    framespeed = 8, --# frames between frame change
    --Movement speed. Only affects speedX by default.
    speed = 1,
    --Collision-related
    npcblock = false,
    npcblocktop = false, --Misnomer, affects whether thrown NPCs bounce off the NPC.
    playerblock = false,
    playerblocktop = false, --Also handles other NPCs walking atop this NPC.

    nohurt = false,
    nogravity = false,
    noblockcollision = false,
    nofireball = false,
    noiceball = true,
    noyoshi = true,
    nowaterphysics = false,
    --Various interactions
    jumphurt = true, --If true, spiny-like
    spinjumpsafe = false, --If true, prevents player hurt when spinjumping
    harmlessgrab = false, --Held NPC hurts other NPCs if false
    harmlessthrown = false, --Thrown NPC hurts other NPCs if false

    grabside=false,
    grabtop=false,
}

--Applies NPC settings
npcManager.setNpcSettings(sampleNPCSettings)

--Register the vulnerable harm types for this NPC. The first table defines the harm types the NPC should be affected by, while the second maps an effect to each, if desired.
npcManager.registerHarmTypes(npcID,
    {
        --HARM_TYPE_JUMP,
        --HARM_TYPE_FROMBELOW,
        HARM_TYPE_NPC,
        HARM_TYPE_PROJECTILE_USED,
        HARM_TYPE_LAVA,
        HARM_TYPE_HELD,
        HARM_TYPE_TAIL,
        HARM_TYPE_SPINJUMP,
        --HARM_TYPE_OFFSCREEN,
        HARM_TYPE_SWORD
    }, 
    {
        --[HARM_TYPE_JUMP]=10,
        --[HARM_TYPE_FROMBELOW]=10,
        --[HARM_TYPE_NPC]=10,
        --[HARM_TYPE_PROJECTILE_USED]=10,
        [HARM_TYPE_LAVA]={id=13, xoffset=0.5, xoffsetBack = 0, yoffset=1, yoffsetBack = 1.5},
        --[HARM_TYPE_HELD]=10,
        --[HARM_TYPE_TAIL]=10,
        --[HARM_TYPE_SPINJUMP]=10,
        --[HARM_TYPE_OFFSCREEN]=10,
        --[HARM_TYPE_SWORD]=10,
    }
);

--Custom local definitions below

--Walking state
AI_NOTWALKING = 0
AI_WALKING = 1

--Firing state
AI_NOTFIRING = 0
AI_FIRING = 1

--Hammer state
AI_NOTHAMMERFIRE = 0
AI_HAMMERFIRE = 1

--Invincibility state
AI_VULNERABLE = 0
AI_INVULNERABLE = 1
AI_DEAD = 2

--Register events
function sampleNPC.onInitAPI()
    npcManager.registerEvent(npcID, sampleNPC, "onTickNPC")
    npcManager.registerEvent(npcID, sampleNPC, "onTickEndNPC")
    npcManager.registerEvent(npcID, sampleNPC, "onDrawNPC")
    registerEvent(sampleNPC, "onNPCHarm")
end

local function drawHealthBar(v)

    local data = v.data
    local settings = data._settings

    if data.hp == nil then return end

    --Drawing the HP icon
    if data.hpIconSprite == nil then
        local iconImg = Graphics.loadImageResolved("BowserImages/BowserIcon.png")
        data.hpIconSprite = Sprite{texture = iconImg}
    end

    data.hpTimer = (data.hpTimer or 0) + 1/12

    data.hpTimer = math.clamp(data.hpTimer, 0, 9)

    if not data.movingPos then
        data.hpIconSprite.position = vector(800-96, (data.hpTimer-2)*10-6)
    else
        data.hpIconSprite.position = vector(data.hpIconSprite.position.x, data.hpIconSprite.position.y)
    end

    data.hpIconAlpha = data.hpIconAlpha or 1

    if data.invulState == AI_DEAD then
        if settings.hpBehaviourAfterDeath ~= 0 then
            data.movingPos = true
        end

        if settings.hpBehaviourAfterDeath == 1 then
            data.hpIconSprite.position = vector(data.hpIconSprite.position.x, data.hpIconSprite.position.y - 1)
        elseif settings.hpBehaviourAfterDeath == 2 then
            data.hpIconSprite.position = vector(data.hpIconSprite.position.x + 1, data.hpIconSprite.position.y)
        elseif settings.hpBehaviourAfterDeath == 3 then
            data.hpIconAlpha = data.hpIconAlpha - 1/60
        end
    end

    data.hpIconSprite:draw{color = Color.white .. data.hpIconAlpha, priority = -4}

    local maxHP = 100

    local hpBars = math.clamp(data.hp, 0, maxHP)
    local trueHPBars = hpBars
    if hpBars > maxHP/2 then
        trueHPBars = maxHP/2
    end

    local var = hpBars + 1
    
    for i=1,trueHPBars do

        var = var - 1

        local hpImg = Graphics.loadImageResolved("BowserImages/BowserHealth.png")
        local hpImgPlus = Graphics.loadImageResolved("BowserImages/BowserHealth+.png")
        local hpSprite = Sprite{texture = hpImg}

        if var > maxHP/2 then
            hpSprite = Sprite{texture = hpImgPlus}
        end

        hpSprite.position = vector(data.hpIconSprite.position.x - i*9, (data.hpTimer-2)*10 + 1)

        hpSprite:draw{color = Color.white .. data.hpIconAlpha, priority = -4}
    end
end

--this function spawns the fire (pretty self explanatory if you ask me)
local function spawnFire(v)
    local data = v.data
    local settings = data._settings

    local xPos = v.x - 24
    if v.direction == 1 then
        xPos = v.x + v.width - 24
    end

    local fire = NPC.spawn(settings.fireSettings.fireID, xPos, v.y + 10, v:mem(0x146, FIELD_WORD), false)
    local plr = npcutils.getNearestPlayer(v)
    local angle = math.atan2(fire.y - plr.y, fire.x - plr.x)
    fire.direction = v.direction

    fire.speedX = 3 * fire.direction
    fire.speedY = -math.sin(angle) * 3
end

local function setFrameDead(v)
    local data = v.data

    if data.frame < 6 then
        data.frame = 6
    end

    data.frameSpeed = data.frameSpeed + 1

    if data.frameSpeed % 4 == 0 then
        if data.frame == 7 then
            data.frame = 6
        else
            data.frame = 7
        end
    end
    
end

local function setFrame(v)
    local data = v.data
    local settings = data._settings

    data.frame = data.frame or 0
    data.frameSpeed = data.frameSpeed or 0

    if Misc.isPaused() then return end
    if Layer.get("Default").isPaused() then return end
    if data.invulState == AI_DEAD then
        setFrameDead(v)
        return
    end

    data.frameSpeed = data.frameSpeed + 1

    if data.firingState == AI_NOTFIRING then 
        if data.frameSpeed >= 8 then
            data.frameSpeed = 0

            if data.frame < 3 then
                data.frame = data.frame + 1
            elseif data.frame >= 3 then
                data.frame = 0
                data.frameSpeed = 6
            end
        end
    elseif data.firingState == AI_FIRING then
        data.frame = 4
        if data.frameSpeed >= settings.fireSettings.fireSpitTime then
            data.frame = 5
            if not data.alreadySpawned then
                spawnFire(v)
                data.alreadySpawned = true

                SFX.play(extrasounds.sounds[115].sfx)
            end
        end

        if data.frameSpeed == settings.fireSettings.fireSpitTime + 15 then
            data.frameSpeed = 0
            data.firingState = AI_NOTFIRING

            data.alreadySpawned = false
        end
    end
end

local function onlyWalk(plr, isRight)
    plr.keys.up = false
    plr.keys.down = false
    plr.keys.left = not isRight
    plr.keys.right = isRight

    plr.keys.jump = false
    plr.keys.altJump = false
    plr.keys.altRun = false
    plr.keys.run = false
    plr.keys.dropItem = false
    plr.keys.pause = false
end

local function split (inputstr, sep)
    if sep == nil then
        sep = "%s"
    end
    local t={}
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
        table.insert(t, str)
    end
    return t
end

function sampleNPC.onTickNPC(v)
    --Don't act during time freeze
    if Defines.levelFreeze then return end
    
    local data = v.data
    local settings = data._settings
    
    --If despawned
    if v.despawnTimer <= 0 then
        --Reset our properties, if necessary
        data.initialized = false
        return
    end

    if v.despawnTimer <= 1 then return end

    --Initialize
    if not data.initialized then

        --Initialize necessary data.
        data.initialized = true

        if settings.triggerMFScroll then
            data.customScroll = true
            local section = v.sectionObj

            section.trueBorderRight = section.boundary.right

            local bounds = {left = camera.x, top = camera.y, right = camera.x + camera.width, bottom = camera.y + camera.height}
            section.boundary = bounds
        end

        data.hp = settings.hp
        data.subHP = settings.subHP

        if settings.triggerMusic then

            local filename = Level.filename()
            local tbl = split(filename, ".")
            local extensionNr = #tbl[#tbl]
            local amountToRemoveFromEnd = -(extensionNr+2)

            Audio.MusicChange(v:mem(0x146, FIELD_WORD), Level.filename():sub(1,amountToRemoveFromEnd) .. "/BowserSounds/BowserBattle.spc|0;g=2.3", -1)

            --Audio.MusicVolume(128)

        end

        data.hitBox = colliders.Box(v.x, v.y - 8, v.width, v.height)

        --Movement stuff
        data.movementState = AI_NOTWALKING
        data.movementTimer = 0
        data.movementThreshold = rng.randomInt(0, 60)

        --Jumping stuff
        data.jumpingTimer = 0
        data.jumpingThreshold = rng.randomInt(15, 135)

        --Hammer stuff
        data.hammerState = AI_NOTHAMMERFIRE
        data.hammerTimer = 0
        data.hammerThreshold = rng.randomInt(settings.hammerSettings.hammerDelay, settings.hammerSettings.hammerDelay + 240) + 480

        --Firing stuff
        data.firingState = AI_NOTFIRING
        data.firingTimer = 0
        data.firingThreshold = rng.randomInt(settings.fireSettings.fireDelay, settings.fireSettings.fireDelay + 120)

        --Invincibility stuff
        data.invulState = AI_VULNERABLE
        data.invulTimer = 0

    end

    --Depending on the NPC, these checks must be handled differently
    if v:mem(0x12C, FIELD_WORD) > 0    --Grabbed
    or v:mem(0x136, FIELD_BOOL)        --Thrown
    or v:mem(0x138, FIELD_WORD) > 0    --Contained within
    then
        --Handling
    end

    if data.customScroll then

        local section = v.sectionObj
        local bounds = section.boundary

        if bounds.right < section.trueBorderRight then
            bounds.left = bounds.left + 1
            bounds.right = bounds.right + 1
            section.boundary = bounds
        end
    end

    data.firingTimer = data.firingTimer + 1
    data.movementTimer = data.movementTimer + 1
    data.jumpingTimer = data.jumpingTimer + 1
    data.hammerTimer = data.hammerTimer + 1

    if data.firingState == AI_NOTFIRING then
        if data.firingTimer >= data.firingThreshold then
            data.firingTimer = 0
            data.firingThreshold = rng.randomInt(settings.fireSettings.fireDelay, settings.fireSettings.fireDelay + 120) + settings.fireSettings.fireSpitTime + 30
            data.firingState = AI_FIRING
        end
    end

    if settings.hammerSettings.throwHammer and data.hammerState == AI_NOTHAMMERFIRE then
        if data.hammerTimer >= data.hammerThreshold then
            data.hammerTimer = 0
            data.hammerThreshold = rng.randomInt(settings.hammerSettings.hammerDelay, settings.hammerSettings.hammerDelay + 240)
            data.hammerState = AI_HAMMERFIRE
        end
    end

    if data.movementTimer >= data.movementThreshold then

        data.movementState = rng.randomInt(1)

        data.movementTimer = 0
        data.movementThreshold = rng.randomInt(60, 180)
    end

    if data.jumpingTimer >= data.jumpingThreshold then

        if v.collidesBlockBottom then
            v.speedY = -8
        end

        data.jumpingTimer = 0
        data.jumpingThreshold = rng.randomInt(15, 135) + 120
    end

    if data.invulState ~= AI_DEAD then
        if data.movementState == AI_NOTWALKING then
            v.speedX = 0
        elseif data.movementState == AI_WALKING then
            v.speedX = v.direction * settings.movementSpeed
        end
    end

    if data.invulState ~= AI_DEAD and data.hammerState == AI_HAMMERFIRE then
        
        if data.hammerTimer >= settings.hammerSettings.hammerPrepareTime and data.hammerTimer % settings.hammerSettings.hammerThrowSpeed == 0 then
            local hammer = NPC.spawn(30, v.x + v.width/2 + 24*v.direction - 16, v.y + 32 - 16, v.section)

            local angle = math.rad(rng.randomInt(22, 67))
            hammer.speedY = -math.sin(angle) * (10 - ((data.hammerTimer+1) / (settings.hammerSettings.hammerPrepareTime + 240)))
            hammer.speedX = v.direction * math.cos(angle) * (5 - ((data.hammerTimer+1) / (settings.hammerSettings.hammerPrepareTime + 240)))
            SFX.play(25)
        end

        if data.hammerTimer == settings.hammerSettings.hammerPrepareTime + 240 then
            data.hammerTimer = 0
            data.hammerState = AI_NOTHAMMERFIRE
        end

    end

    if data.invulState == AI_VULNERABLE then
        local plr = npcutils.getNearestPlayer(v)
        if plr.deathTimer == 0 and plr.forcedState == 0 and colliders.bounce(plr, data.hitBox) then
            colliders.bounceResponse(plr)
            data.hp = data.hp - 1
            if data.hp > 0 then
                data.invulState = AI_INVULNERABLE
                data.invulTimer = settings.invulTime
                data.alphaTimer = 8

                SFX.play(extrasounds.sounds[39].sfx)
            else
                data.invulState = AI_DEAD

                SFX.play(41)

                Audio.MusicChange(v:mem(0x146, FIELD_WORD), 0, -1)
            end
        end
    end

    if data.invulState == AI_INVULNERABLE then
        data.invulTimer = data.invulTimer - 1
        if data.invulTimer == 0 then
            data.invulState = AI_VULNERABLE
        end
    end

    if data.invulState == AI_DEAD then
        v.friendly = true
        v.noblockcollision = true

        v.speedX = 0
        v.speedY = -Defines.npc_grav

        data.deathTimer = (data.deathTimer or 0) + 1
        data.lavaMult = data.lavaMult or 1.5

        v:mem(0x12A, FIELD_WORD, 180)

        if timer.isActive() then
            timer.add((data.lastTimerSecond or timer.get()) - timer.get(), true)
        end

        if data.deathTimer == 120 then
            SFX.play{
                sound = "BowserSounds/BowserFalling.ogg"
            }
        elseif data.deathTimer > 120 then
            v.y = v.y + 1*data.lavaMult
        end

        if settings.triggerLevelEnd then
            if data.deathTimer == 360 then
                --These following lines are simulating the player going off-screen

                local section = v.sectionObj
                local bounds = section.boundary
                local fakeBorder = bounds.right
                bounds.right = bounds.right + 64
                section.boundary = bounds

                SFX.play{
                    sound = "BowserSounds/BowserDefeat.ogg"
                }
            elseif data.deathTimer > 360 then
                for _,plr in ipairs(Player.get()) do
                    if plr.section == v.section then

                        local section = v.sectionObj

                        local fakeBorder = section.boundary.right - 64

                        local cam = handycam[_]
                        cam.x = fakeBorder - cam.width/2

                        onlyWalk(plr, true)
                        --This is set just so the player doesn't die when off-screen
                        if plr.x >= section.boundary.right - 64 then
                            if #Block.getIntersecting(plr.x, plr.y + plr.height, plr.x + plr.width, plr.y + plr.height + 32) == 0 then
                                Block.spawn(1006, plr.x, plr.y + plr.height)
                            end
                        end
                    end
                end
            end
        else
            if data.deathTimer >= 360 then v:kill(HARM_TYPE_VANISH) end

        end

        for _,blck in Block.iterateIntersecting(v.x, v.y, v.x + v.width, v.y + v.height) do
            if Block.LAVA_MAP[blck.id] then
                if data.lavaMult == 1.5 then --since this can only happen once when bowsy is dead i thought might as well spawn the sound here
                    SFX.play{
                        sound = "BowserSounds/BowserLava.ogg"
                    }
                end
                data.lavaMult = 0.75
            end
        end

    end

    if timer.isActive() then
        data.lastTimerSecond = timer.get()
    end
end

function sampleNPC.onTickEndNPC(v)
    --Don't act during time freeze
    if Defines.levelFreeze then return end

    local data = v.data
    local settings = data._settings

    --If despawned
    if v.despawnTimer <= 1 then
        return
    end

    data.hitBox.x = v.x + 4
    data.hitBox.y = v.y - 8

    data.deathTimer = data.deathTimer or 0

    if data.invulState == AI_DEAD and settings.triggerLevelEnd and data.deathTimer > 360 then
        for _,plr in ipairs(Player.get()) do
            if plr.section == v.section then

                onlyWalk(plr, true)
            end
        end
    end

    if settings.triggerLevelEnd and data.invulState == AI_DEAD and data.deathTimer > 360 then
        for _,plr in ipairs(Player.get()) do
            if plr.section == v.section then

                local section = v.sectionObj

                local fakeBorder = section.boundary.right - 64

                local cam = handycam[_]
                cam.x = fakeBorder - cam.width/2
            end
        end
    end

    if data.invulState == AI_DEAD and settings.triggerLevelEnd then

        if data.deathTimer == 360 + settings.endLevelThemeDuration + 120 then
            mem(0x00B2C5D4,FIELD_WORD,settings.winState)
            Level.load("map.lvlx")

            Checkpoint.reset()
        end
    end

    setFrame(v)
end

function sampleNPC.onDrawNPC(v)
    if Defines.levelFreeze then return end

    --just making sure the npc is right
    if v.id ~= npcID then return end

    local data = v.data
    local settings = data._settings

    local lastDir = v.direction
    if data.invulState ~= AI_DEAD then
        npcutils.faceNearestPlayer(v)
    end

    if v.direction == lastDir then
        data.directionChangeTimer = 30
    else
        v.direction = lastDir
        data.directionChangeTimer = data.directionChangeTimer - 1
        if data.directionChangeTimer <= 0 then
            v.direction = -lastDir
        end
    end

    data.sprite = data.sprite or Sprite{texture = Graphics.sprites.npc[v.id].img, frames = 7, align = Sprite.align.CENTER}
    data.fakeHammer = data.fakeHammer or Sprite{texture = Graphics.sprites.npc[30].img, frames = 4, align = Sprite.align.CENTER}

    data.sprite.scale = {-v.direction, 1}

    data.sprite.position = vector(v.x + v.width/2, v.y + v.height/2 - 4)
    data.fakeHammer.position = vector(v.x + v.width/2 + 24*v.direction, v.y + 32)

    local alpha = 1

    if data.invulState == AI_INVULNERABLE then
        data.alphaTimer = (data.alphaTimer or 0) + 1
        alpha = 0.5 + math.sin(data.alphaTimer/6)*0.5
    end

    if v:mem(0x12A, FIELD_WORD) > 170 then
        data.sprite:draw{frame = data.frame, priority = -45, sceneCoords = true, color = Color.white .. alpha}
        if data.invulState ~= AI_DEAD and data.hammerState == AI_HAMMERFIRE then
            data.fakeHammer:draw{frame = 1, priority = -46, sceneCoords = true}
        end
    end

    if not settings.disableHP then
        drawHealthBar(v)
    end

    npcutils.hideNPC(v)
end

function sampleNPC.onNPCHarm(eventToken, v, harmType, culpritOrNil)
    if v.id ~= npcID or harmType == HARM_TYPE_LAVA or harmType == HARM_TYPE_JUMP then return end
    eventToken.cancelled = true

    local data = v.data
    local settings = data._settings

    if data.invulState ~= AI_VULNERABLE then return end

    local culpritType = type(culpritOrNil)

    --just a safe check to make sure the culprit returns NPC or something
    if culpritType == table then culpritType = culpritOrNil.__type end

    if culpritType == "NPC" then
        if culpritOrNil.id == 13 then
            if data.subHP > 1 then
                SFX.play(9)
            end
            culpritOrNil:kill()
        elseif culpritOrNil.id == 171 then
            if data.subHP > 1 then
                SFX.play(9)
            end
        end
    end

    data.subHP = data.subHP - 1
    if data.subHP <= 0 then
        data.subHP = settings.subHP
        data.hp = data.hp - 1
        if data.hp > 0 then
            data.invulState = AI_INVULNERABLE
            data.invulTimer = settings.invulTime
            data.alphaTimer = 8

            SFX.play(extrasounds.sounds[39].sfx)
        else
            data.invulState = AI_DEAD

            SFX.play{
                sound = "BowserSounds/BowserDefeatStun.wav"
            }

            Audio.MusicChange(v:mem(0x146, FIELD_WORD), 0, -1)
        end
    end

end

--Gotta return the library table!
return sampleNPC