--[[

    Minecraft Steve Playable
    by MrDoubleA

    See steve.lua for full credits

]]

local npcManager = require("npcManager")
local npcutils = require("npcs/npcutils")

local ai = require("droppedItem_ai")


local droppedItem = {}
local npcID = NPC_ID

local droppedItemSettings = {
    id = npcID,
    
    gfxwidth = 32,
    gfxheight = 32,

    gfxoffsetx = 0,
    gfxoffsety = 0,
    
    width = 32,
    height = 32,
    
    frames = 1,
    framestyle = 0,
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
    noyoshi = true,
    nowaterphysics = false,

    ignorethrownnpcs = true,
    
    jumphurt = true,
    spinjumpsafe = false,
    harmlessgrab = false,
    harmlessthrown = false,
}

npcManager.setNpcSettings(droppedItemSettings)
npcManager.registerHarmTypes(npcID,{HARM_TYPE_OFFSCREEN},{})


ai.register(npcID)


return droppedItem