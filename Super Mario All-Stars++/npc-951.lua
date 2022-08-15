--[[

    See yiYoshi.lua for credits

]]

local npcManager = require("npcManager")
local npcutils = require("npcs/npcutils")

local yoshi = require("yiYoshi/yiYoshi")


local star = {}
local npcID = NPC_ID

local starSettings = {
    id = npcID,
    
    gfxwidth = 38,
    gfxheight = 34,

    gfxoffsetx = 0,
    gfxoffsety = 10,
    
    width = 32,
    height = 32,
    
    frames = 6,
    framestyle = 1,
    framespeed = 8,
    
    speed = 1,
    
    npcblock = false,
    npcblocktop = false, --Misnomer, affects whether thrown NPCs bounce off the NPC.
    playerblock = false,
    playerblocktop = false, --Also handles other NPCs walking atop this NPC.

    nohurt = true,
    nogravity = false,
    noblockcollision = false,
    nofireball = true,
    noiceball = true,
    noyoshi = false,
    nowaterphysics = false,
    
    jumphurt = false,
    spinjumpsafe = false,
    harmlessgrab = false,
    harmlessthrown = false,

    ignorethrownnpcs = true,
    luahandlesspeed = true,

    
    isinteractable = true,


    lifetime = 256,
}

npcManager.setNpcSettings(starSettings)
npcManager.registerHarmTypes(npcID,{HARM_TYPE_OFFSCREEN},{})


function star.onInitAPI()
    npcManager.registerEvent(npcID, star, "onTickEndNPC")
    registerEvent(star,"onPostNPCKill")
end


function star.onTickEndNPC(v)
    if Defines.levelFreeze then return end
    
    local data = v.data
    
    if v.despawnTimer <= 0 then
        data.initialized = false
        return
    end


    local config = NPC.config[v.id]

    if not data.initialized then
        data.initialized = true
        data.timer = 0

        data.timeLeft = config.lifetime
    end
    

    if v:mem(0x12C, FIELD_WORD) > 0    --Grabbed
    or v:mem(0x136, FIELD_BOOL)        --Thrown
    or v:mem(0x138, FIELD_WORD) > 0    --Contained within
    then
        v.animationFrame = npcutils.getFrameByFramestyle(v,{frame = 0})
        return
    end


    if v.collidesBlockBottom then
        data.timer = data.timer + 1

        v.speedX = 0

        if data.timer >= 8 and RNG.randomInt(1,8) == 1 or data.timer >= 20 then
            data.timer = 0

            v.speedX = config.speed*RNG.randomInt(1.2,1.6)*v.direction
            v.speedY = -RNG.random(5,8)
        end
    else
        data.timer = 0
    end


    data.timeLeft = data.timeLeft - 1
    if data.timeLeft <= 0 then
        v:kill(HARM_TYPE_VANISH)
    end
    

    if data.timeLeft > 32 or data.timeLeft%2 == 0 then
        -- Find frame
        local frame = 0

        if not v.collidesBlockBottom then
            frame = math.clamp(math.floor(v.speedY*1.25)+1,1,config.frames-1)
        end

        v.animationFrame = npcutils.getFrameByFramestyle(v,{frame = frame})
    else
        v.animationFrame = -999
    end
end


function star.onPostNPCKill(v,reason)
    if v.id == npcID and npcManager.collected(v,reason) ~= nil then
        yoshi.giveStarPoint(1,v.x + v.width*0.5,v.y + v.height*0.5)
    end
end


yoshi.generalSettings.starNPCID = npcID
yoshi.generalSettings.starEffectID = npcID


return star