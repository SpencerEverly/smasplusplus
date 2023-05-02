
--[[******************************************************************************************
Code created originally by Waddle as an NPC known as "Titan Head", for a submission for the 2021 Diorama Contest, edited by me.
**********************************************************************************************]]

local e = {}

local npcManager = require("npcManager")
local npcID = NPC_ID

local config = {
    id = npcID,  
    width = 14, 
    framespeed = 8,
    height = 20,
    gfxwidth = 14,
    gfxheight = 20,
    frames = 4,
    framestyle = 1,
    nogravity = true,
    jumphurt = true,
    noyoshi = true,
    noiceball = true,
    spinjumpsafe = false,
    noblockcollision = true,
    ignorethrownnpcs = true,
}
npcManager.setNpcSettings(config)

npcManager.registerHarmTypes(npcID,
{ HARM_TYPE_OFFSCREEN, }, { [HARM_TYPE_OFFSCREEN]=10, } );

function e.onInitAPI()
    npcManager.registerEvent(npcID, e, "onTickEndNPC")
end

function e.onTickEndNPC(v)
    if Defines.levelFreeze then return end
    
    local data = v.data
    v.animationFrame = NPC.config[npcID].frames
    
    if v.despawnTimer <= 0 then
        data.initialized = false
        return
    end
    if not data.initialized then
        data.initialized = true
    end
    
        v.speedX = 8 * v.direction
        v.speedY = 20
    
    if v.direction == DIR_LEFT then
        v.animationFrame = math.floor(lunatime.tick() / 4) % 3
    elseif v.direction == DIR_RIGHT then
        v.animationFrame = (math.floor(lunatime.tick() / 4) % 3) + 4
    end

    for _,w in ipairs (Block.getIntersecting(v.x - 8,v.y - 8,v.x + 16, v.y + 16)) do
        if w.isHidden or w.layerObj.isHidden or w.layerName == "Destroyed Blocks" or w:mem(0x5A, FIELD_WORD) == -1 then
        else
            v:kill(HARM_TYPE_OFFSCREEN)
            SFX.play(3)
        end
    end
    
end

return e
