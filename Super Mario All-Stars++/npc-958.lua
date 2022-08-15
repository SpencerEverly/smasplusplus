--[[

    See yiYoshi.lua for credits

]]

local npcManager = require("npcManager")
local npcutils = require("npcs/npcutils")

local ai = require("yiYoshi/cloud_ai")


local cloud = {}
local npcID = NPC_ID


local popEffectID = (npcID+2)


local cloudSettings = {
    id = npcID,
    
    gfxwidth = 96,
    gfxheight = 64,

    gfxoffsetx = 0,
    gfxoffsety = 14,
    
    width = 32,
    height = 32,
    
    frames = 8,
    framestyle = 0,
    framespeed = 8,
    
    speed = 1,
    
    npcblock = false,
    npcblocktop = false, --Misnomer, affects whether thrown NPCs bounce off the NPC.
    playerblock = false,
    playerblocktop = false, --Also handles other NPCs walking atop this NPC.

    nohurt = true,
    nogravity = true,
    noblockcollision = false,
    nofireball = true,
    noiceball = true,
    noyoshi = true,
    nowaterphysics = true,
    
    jumphurt = true,
    spinjumpsafe = false,
    harmlessgrab = true,
    harmlessthrown = true,

    ignorethrownnpcs = true,


    cloudFrames = 3,
    wingFrames = 4,

    wingFramespeed = 4,


    popSound = SFX.open(Misc.resolveSoundFile("yiYoshi/pop")),
    popEffectID = popEffectID,
}

npcManager.setNpcSettings(cloudSettings)
npcManager.registerHarmTypes(npcID,
    {
        HARM_TYPE_NPC,
        HARM_TYPE_TAIL,
        HARM_TYPE_OFFSCREEN,
        HARM_TYPE_SWORD
    },
    {}
)


ai.register(npcID,false)


return cloud