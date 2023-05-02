local npcManager = require("npcManager")
local rng = require("rng")
local ASmovement = require("AI/angrySun")

local angrySun = {}
local npcID = NPC_ID

local angrySunSettings = {
    id = npcID,
    gfxheight = 56,
    gfxwidth = 56,
    width = 32,
    height = 32,
    gfxoffsetx = 0,
    gfxoffsety = 12,
    frames = 2,
    framestyle = 0,
    framespeed = 8,
    speed = 1,
    score = 6,
    
    --Collision-related
    npcblock = false,
    npcblocktop = false,
    playerblock = false,
    playerblocktop = false,

    nohurt=false,
    nogravity = true,
    noblockcollision = true,
    nofireball = true,
    noiceball = true,
    noyoshi= true,
    nowaterphysics = false,
    --Various interactions
    jumphurt = true, --If true, spiny-like
    spinjumpsafe = false, --If true, prevents player hurt when spinjumping
    harmlessgrab = false, --Held NPC hurts other NPCs if false
    harmlessthrown = false, --Thrown NPC hurts other NPCs if false

    lightradius = 160,
    lightbrightness = 1,
    lightoffsetx = 0,
    lightoffsety = 0,
    lightcolor = Color.white,
    
    ishot = true,
    durability = -1,

    --Define custom properties below
    effectID = 752,
    isDefaultActive = true,
}

local configFile = npcManager.setNpcSettings(angrySunSettings)

npcManager.registerDefines(npcID, {NPC.UNHITTABLE})

npcManager.registerHarmTypes(npcID,
    {
        HARM_TYPE_NPC,
    }, 
    {
        [HARM_TYPE_NPC]=configFile.effectID,
    }
);

ASmovement.register(npcID)

--Gotta return the library table!
return angrySun