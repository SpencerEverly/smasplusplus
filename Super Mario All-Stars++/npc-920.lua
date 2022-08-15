--[[

    Extended Koopas
    Made by MrDoubleA

    See extendedKoopas.lua for full credits

]]

local npcManager = require("npcManager")
local npcutils = require("npcs/npcutils")

local slidingKoopa = {}
local npcID = NPC_ID


local stompedEffectID = (npcID)
local deathEffectID = (npcID + 1)

local normalID = 119


local slidingKoopaSettings = {
    id = npcID,
    
    gfxwidth = 32,
    gfxheight = 32,

    gfxoffsetx = 0,
    gfxoffsety = 2,
    
    width = 32,
    height = 32,
    
    frames = 1,
    framestyle = 1,
    framespeed = 8,
    
    speed = 1,
    
    npcblock = false,
    npcblocktop = false, --Misnomer, affects whether thrown NPCs bounce off the NPC.
    playerblock = false,
    playerblocktop = false, --Also handles other NPCs walking atop this NPC.

    nohurt = false,
    nogravity = false,
    noblockcollision = false,
    nofireball = false,
    noiceball = false,
    noyoshi = false,
    nowaterphysics = false,
    
    jumphurt = false,
    spinjumpsafe = false,
    harmlessgrab = false,
    harmlessthrown = false,


    luahandlesspeed = true,

    normalID = normalID,


    acceleration = 0.075,
    deceleration = 0.96,
    maxSpeed = 8,
}

npcManager.setNpcSettings(slidingKoopaSettings)
npcManager.registerHarmTypes(npcID,
    {
        HARM_TYPE_JUMP,
        HARM_TYPE_FROMBELOW,
        HARM_TYPE_NPC,
        HARM_TYPE_PROJECTILE_USED,
        HARM_TYPE_LAVA,
        HARM_TYPE_HELD,
        HARM_TYPE_TAIL,
        HARM_TYPE_SPINJUMP,
        HARM_TYPE_OFFSCREEN,
        HARM_TYPE_SWORD,
    },
    {
        [HARM_TYPE_JUMP]            = stompedEffectID,
        [HARM_TYPE_FROMBELOW]       = deathEffectID,
        [HARM_TYPE_NPC]             = deathEffectID,
        [HARM_TYPE_PROJECTILE_USED] = deathEffectID,
        [HARM_TYPE_HELD]            = deathEffectID,
        [HARM_TYPE_TAIL]            = deathEffectID,
        [HARM_TYPE_LAVA]            = {id=13, xoffset=0.5, xoffsetBack = 0, yoffset=1, yoffsetBack = 1.5},
        [HARM_TYPE_SPINJUMP]        = 10,
    }
)

function slidingKoopa.onInitAPI()
    npcManager.registerEvent(npcID, slidingKoopa, "onTickNPC")
end


local colBox = Colliders.Box(0,0,0,0)

local function createDust(v,data,config,direction)
    data.dustTimer = data.dustTimer + 1

    if data.dustTimer%4 == 0 then
        local e = Effect.spawn(74, v.x + v.width*0.5 - v.width*0.25*direction, v.y + v.height)

        e.x = e.x - e.width *0.5
        e.y = e.y - e.height*0.5
    end
end

function slidingKoopa.onTickNPC(v)
    if Defines.levelFreeze then return end
    
    local data = v.data
    
    if v.despawnTimer <= 0 then
        data.initialized = false
        return
    end

    if not data.initialized then
        data.initialized = true

        data.dustTimer = 0
    end

    if v:mem(0x12C, FIELD_WORD) > 0    --Grabbed
    or v:mem(0x136, FIELD_BOOL)        --Thrown
    or v:mem(0x138, FIELD_WORD) > 0    --Contained within
    then return end
    
    
    local config = NPC.config[v.id]


    if v:mem(0x22,FIELD_WORD) > 0 then
        local slope = Block(v:mem(0x22,FIELD_WORD))

        local slopeDirection = Block.config[slope.id].floorslope


        local acceleration = (slope.height / slope.width)*config.acceleration*slopeDirection

        if slopeDirection == -math.sign(v.speedX) then
            acceleration = acceleration * 1.35
        end

        v.speedX = v.speedX + acceleration

        createDust(v,data,config,slopeDirection)


        -- Get yeeted off slopes
        colBox.width = 2
        colBox.height = 48

        colBox.x = v.x + v.width*0.5 + v.width*0.5*math.sign(v.speedX)
        colBox.y = v.y + v.height

        local blocks = Colliders.getColliding{a = colBox,b = Block.SLOPE,btype = Colliders.BLOCK}

        if #blocks == 0 then
            v.speedY = -math.abs(v.speedX) * 1.25
            v:mem(0x22,FIELD_WORD,0)
        end
    elseif v.collidesBlockBottom then
        v.speedX = v.speedX * config.deceleration

        createDust(v,data,config,v.direction)

        if math.abs(v.speedX) < 0.2 then
            v:transform(config.normalID)
        end
    end

    v.speedX = math.clamp(v.speedX, -config.maxSpeed,config.maxSpeed)
end

return slidingKoopa