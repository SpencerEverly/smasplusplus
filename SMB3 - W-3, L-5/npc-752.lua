--NPCManager is required for setting basic NPC properties
local npcManager = require("npcManager")
local npcutils = require("npcs/npcutils")
local blockutils = require("blocks/blockutils")
local waterCurrentSettings = require("waterCurrentSettings")

--Create the library table
local sampleNPC = {}
--NPC_ID is dynamic based on the name of the library file
local npcID = NPC_ID

--Defines NPC config for our NPC. You can remove superfluous definitions.
local sampleNPCSettings = {
    id = npcID,
    --Sprite size
    gfxheight = 32,
    gfxwidth = 32,
    --Hitbox size. Bottom-center-bound to sprite size.
    width = 32,
    height = 32,
    --Sprite offset from hitbox for adjusting hitbox anchor on sprite.
    gfxoffsetx = 0,
    gfxoffsety = 0,
    --Frameloop-related
    frames = 1,
    framestyle = 0,
    framespeed = 8, --# frames between frame change
    --Movement speed. Only affects speedX by default.
    speed = 1,
    --Collision-related
    npcblock = false,
    npcblocktop = false, --Misnomer, affects whether thrown NPCs bounce off the NPC.
    playerblock = false,
    playerblocktop = false, --Also handles other NPCs walking atop this NPC.

    nohurt=true,
    nogravity = true,
    noblockcollision = true,
    nofireball = true,
    noiceball = true,
    noyoshi= true,
    nowaterphysics = true,
    --Various interactions
    jumphurt = true, --If true, spiny-like
    spinjumpsafe = false, --If true, prevents player hurt when spinjumping
    harmlessgrab = false, --Held NPC hurts other NPCs if false
    harmlessthrown = false, --Thrown NPC hurts other NPCs if false

    grabside=false,
    grabtop=false,
    ignorethrownnpcs = true,
    notcointransformable = true
}

--Applies NPC settings
npcManager.setNpcSettings(sampleNPCSettings)

--Register the vulnerable harm types for this NPC. The first table defines the harm types the NPC should be affected by, while the second maps an effect to each, if desired.
npcManager.registerHarmTypes(npcID,
    {}, 
    {}
);

--Custom local definitions below

--Register events
function sampleNPC.onInitAPI()
    npcManager.registerEvent(npcID, sampleNPC, "onTickEndNPC")
    npcManager.registerEvent(npcID, sampleNPC, "onDrawNPC")
end

local rnger = RNG.new(os.clock())

local function updateparticles(v,data,sin,cos,settings)
    if not sin then
        local angl = math.rad(settings.angle)
        sin = math.sin(angl)
        cos = math.cos(angl)
    end
    -- local width = settings.width*50
    -- data.particleEffect:setParam("xOffset", -sin * 16 + rnger:random(-width, width)/100 * cos)
    -- data.particleEffect:setParam("yOffset", cos * 16 - rnger:random(-width, width)/100 * sin)
    data.particleEffect:setParam("xOffset", -sin * 16)
    data.particleEffect:setParam("yOffset", cos * 16)
    for _,part in pairs(data.particleEffect.particles) do
        part.sineTimer = (part.sineTimer or rnger:randomInt(0,100)) + 1
        if not part.init then
            local w = settings.width/2
            local r = rnger:random(0, w*2)-w
            part.x = part.x+r*cos
            part.y = part.y+r*sin
            part.init = true
        end
        part.frametimer = part.sineTimer%5
        --part.frame = 1
        part.x = part.x + math.sin(part.sineTimer/10)/2 * cos
        part.y = part.y - math.sin(part.sineTimer/10)/2 * sin
        local tbl = Liquid.getIntersecting(part.x, part.y, part.x + part.width, part.y + part.height)
        local npcSection = Section(v:mem(0x146, FIELD_WORD))
        if not npcSection.isUnderwater and not waterCurrentSettings.showBubblesOutsideWater and #tbl == 0 then
            part.col = Color.white..0
        end
    end
end

local function init(v,data,settings)

    if data.initialized then return end

    if not settings.angle then
        settings.angle = 0
        settings.limit = 5
        settings.width = 32
        settings.power = 0.3
        settings.createBubbles = true
        settings.xMomentum = false
        settings.bubbleSpeed = 0
    end

    data.currentCollider = Colliders.Rect(0, 0, settings.width, settings.limit*32)
    data.blockChecker = Colliders.Box(0, 0, 0, 0)

    data.particleEffect = Particles.Emitter(0, 0, Misc.resolveFile("bubble_particle.ini"))

    if waterCurrentSettings.prewarm then
        data.particleEffect:setPrewarm(settings.limit/settings.power)
    end

    updateparticles(v,data,nil,nil,settings)

    data.initialized = true

end

local tin = table.insert

local filterIds = {
    626,627,628,629,632,640,642,644,646,648,650,652,654,656,660,664
}

-- Stores boxes for cameras so we don't waste resources creating one for each current
local camboxes = {}

-- Creates a box collider for the camera
local function camtobox(cam)
    camboxes[cam.idx] = Colliders.Box(
        cam.x,
        cam.y,
        cam.width,
        cam.height
    )
end

-- If the cambox doesn't exist, we create one. Else, we update its position. Lastly, return the cambox.
local function getorcreatecambox(cam)
    if not camboxes[cam.idx] then
        camtobox(cam)
    else
        local b = camboxes[cam.idx]
        b.x = cam.x
        b.y = cam.y
        b.width = cam.width
        b.height = cam.height
    end
    return camboxes[cam.idx]
end

local function getcollisionx(v,data,settings,plr,tbl,inactiveFilters,xSpd)

    data.blockChecker.x = plr.x
    data.blockChecker.y = plr.y
    data.blockChecker.width = plr.width
    data.blockChecker.height = plr.height

    local collidingBlocks = Colliders.getColliding {
        a = data.blockChecker,
        b = tbl,
        btype = Colliders.BLOCK
    }

    local colliding = false

    for _,b in pairs(collidingBlocks) do
        local cfg = Block.config[b.id]
        -- Checking if one of the blocks we're about to collide with are inactive filters or have the passthrough config
        if not inactiveFilters[b.id] and not cfg.passthrough and blockutils.hiddenFilter(b) then
            -- Checking if said block is a slope OR if it's a floor slope and the slope's direction is different from the current's direction

            if cfg.ceilingslope ~= 0 and ((cfg.ceilingslope > 0 and xSpd < 0) or (cfg.ceilingslope < 0 and xSpd > 0)) then
                colliding = true
                break
            elseif cfg.floorslope ~= 0 and ((cfg.floorslope < 0 and xSpd < 0) or (cfg.floorslope > 0 and xSpd > 0)) then
                colliding = true
                break
            else
                colliding = true
                break
            end
        end
    end

    -- ah yes, playerblock npcs. how could i forget about them
    local collidingNPCs = Colliders.getColliding {
        a = data.blockChecker,
        btype = Colliders.NPC
    }

    for _,n in pairs(collidingNPCs) do
        local cfg = NPC.config[n.id]
        if cfg.playerblock then colliding = true break end
    end

    return colliding

end

function sampleNPC.onTickEndNPC(v)
    -- Don't act during time freeze
    if Defines.levelFreeze then return end
    local data = v.data
    local settings = data._settings

    if v.despawnTimer <= 0 and not waterCurrentSettings.activateDespawnedNPCs then return end

    init(v,data,settings)

    npcutils.applyLayerMovement(v)

    local angl = math.rad(settings.angle)

    local sin = math.sin(angl)
    local cos = math.cos(angl)

    data.currentCollider.y = v.y + v.height/2 - cos * settings.limit*16 + cos*16
    data.currentCollider.x = v.x + v.width/2 + sin * settings.limit*16 - sin*16
    data.currentCollider.rotation = settings.angle

    -- Uncomment these lines if you want the water current that pushes you and the block checker to be visible. Only recommended for debugging purposes.
    -- data.currentCollider:Draw(Color.blue..0.5)
    -- data.blockChecker:Draw(Color.red..0.5)

    local t = (settings.limit+4)*32
    for idx,plr in ipairs(Player.getIntersecting(v.x - t, v.y - t, v.x + v.width + t, v.y + v.height + t)) do

        -- This is simply an integration with my metal mario thingy. If you wanna use it, here is the download link: https://www.supermariobrosx.org/forums/viewtopic.php?f=101&t=26228
        -- haha shamelss plug
        if plr.isMetal and not waterCurrentSettings.affectMetal then return end

        if v.layerObj.isHidden then return end

        if not waterCurrentSettings.affectOutsideWater and not plr:mem(0x36, FIELD_BOOL) then return end

        if waterCurrentSettings.allowShadowMarioThroughCurrent and Defines.cheat_shadowmario then return end -- If player with shadowstar cheat then go through

        if Colliders.collide(data.currentCollider, plr) and plr.forcedState == 0 and plr:mem(0x26, FIELD_WORD) == 0 then

            -- Collision time!

            -- For those curious, the reason I use speedY (and thus vanilla collision) for the vertical movement but manually move the player for the horizontal collision,
            -- horizontal speed is capped while holding the run button which happens a lot while playing a mario game, thus capping the water current's speed.
            -- This is the sole reason. Literally No Other Reason besides this

            local tbl = Block.SOLID .. Block.PLAYERSOLID .. Block.PLAYER
            local inactiveFilters = {}

            for _,p in pairs(Player.get()) do
                inactiveFilters[filterIds[p.character]] = true
            end

            -- Manually adding some blocks
            tin(tbl, 1272)
            tin(tbl, 1277)
            tin(tbl, 1273)
            tin(tbl, 1278)

            -- If the angle is exactly 0 or 180, we do not have to do any horizontal collision.
            if settings.angle ~= 0 and settings.angle ~= 180 then

                local xSpd = sin*settings.power

                if not settings.xMomentum then
                    local steps = math.ceil(math.abs(xSpd))

                    for i=1,steps do
                        plr.x = plr.x + xSpd/steps
                        if getcollisionx(v,data,settings,plr,tbl,inactiveFilters,xSpd) then
                            plr.x = plr.x - xSpd/steps
                            break
                        end
                    end
                else
                    plr.speedX = plr.speedX + xSpd
                end

            end

            if settings.angle ~= 90 and settings.angle ~= 270 then

                data.blockChecker.y = plr.y - 2
                data.blockChecker.x = plr.x
                data.blockChecker.width = 8
                data.blockChecker.height = 2

                collidingBlocks = Colliders.getColliding {
                    a = data.blockChecker,
                    b = tbl,
                    btype = Colliders.BLOCK
                }

                local colliding = false

                for _,b in pairs(collidingBlocks) do
                    local cfg = Block.config[b.id]

                    -- Checking if one of the blocks we're about to collide with are inactive filters or have the passthrough config
                    if not inactiveFilters[b.id] and not cfg.passthrough then
                        colliding = true
                        break
                    end

                end

                -- ah yes, playerblock npcs. how could i forget about them
                local collidingNPCs = Colliders.getColliding {
                    a = data.blockChecker,
                    btype = Colliders.NPC
                }


                for _,n in pairs(collidingNPCs) do
                    local cfg = NPC.config[n.id]
                    if cfg.playerblock then colliding = true break end
                end

                -- If we're not, uh, colliding with anything
                -- the reason i did this is because mario gets stuck on the ceiling if he's pushed upwards . for.   some reason.
                -- yea i dont know either tbh
                if not colliding then
                    plr.speedY = plr.speedY - cos*settings.power
                end

            end

        end

    end

end

function sampleNPC.onDrawNPC(v)
    --Don't act during time freeze
    if Defines.levelFreeze then return end

    local data = v.data
    local settings = data._settings

    init(v,data,settings)

    if not settings.createBubbles then return end

    data.timer = (data.timer or 0) + 1

    local angl = math.rad(settings.angle)

    local sin = math.sin(angl)
    local cos = math.cos(angl)

    local spd = settings.bubbleSpeed

    if settings.bubbleSpeed == 0 then
        spd = settings.power
    end

    data.particleEffect:setParam("speedY", -(spd * 64.1 * cos))
    data.particleEffect:setParam("speedX", spd * 64.1 * sin)

    local width = settings.width*50
    data.particleEffect:setParam("xOffset", -sin * 16 + math.random(-width, width)/100 * cos)
    data.particleEffect:setParam("yOffset", cos * 16 - math.random(-width, width)/100 * sin)

    data.particleEffect:setParam("rate", spd*9)

    data.particleEffect.enabled = not v.layerObj.isHidden

    data.particleEffect.x = v.x + v.width/2
    data.particleEffect.y = v.y + v.height/2 + 4

    local lifetime = settings.limit/spd/2
    data.particleEffect:setParam("lifetime", lifetime)

    if not Misc.isPaused() and not Misc.isPausedByLua() then updateparticles(v,data,sin,cos,settings) end

    local inCam = false

    if waterCurrentSettings.neverCull then inCam = true
    else
        -- we have no reason to run this code if it's never culled
        for _,c in pairs(Camera.get()) do
            local t = Colliders.getColliding{
                a = data.currentCollider,
                b = getorcreatecambox(c)
            }
            if t then
                inCam = true
                break
            end
        end
    end

    data.particleEffect:Draw(-20, inCam)

end

--Gotta return the library table!
return sampleNPC