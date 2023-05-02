--[[

    Written by MrDoubleA
    Please give credit!
    
    Alternate graphics made by Palutena, permission for use was given by universalidiocy#3253 on Discord, and are from an HTML game called "Super Mario Construct"

    Part of MrDoubleA's NPC Pack

]]

local npcManager = require("npcManager")
local ai = require("boomBoom_ai")

local boomBoom = {}
local npcID = NPC_ID

local deathEffectID = (npcID-2)

local boomBoomSettings = {
    id = npcID,
    
    gfxwidth = 64,
    gfxheight = 64,

    gfxoffsetx = 0,
    gfxoffsety = 0,
    
    width = 40,
    height = 40,
    
    frames = 1,
    framestyle = 1,
    framespeed = 4,
    
    speed = 1,
    score = 8,
    
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
    
    jumphurt = true,
    spinjumpsafe = true,
    harmlessgrab = false,
    harmlessthrown = false,
}

npcManager.setNpcSettings(boomBoomSettings)
npcManager.registerDefines(npcID, {NPC.HITTABLE})
npcManager.registerHarmTypes(npcID,
    {
        HARM_TYPE_LAVA,
        HARM_TYPE_HELD,
        HARM_TYPE_OFFSCREEN,
    }, 
    {
        [HARM_TYPE_LAVA] = deathEffectID,
        [HARM_TYPE_HELD] = deathEffectID,
    }
)

ai.registerHiding(npcID)

return boomBoom