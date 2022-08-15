--[[

    See yiYoshi.lua for credits

]]

local npcManager = require("npcManager")
local npcutils = require("npcs/npcutils")

local yoshi = require("yiYoshi/yiYoshi")

local ai = require("yiYoshi/egg_ai")


local egg = {}
local npcID = NPC_ID


local bounceNPCID = nil

local crackEffectID = npcID+1
local fallEffectID = npcID+2


local eggSettings = {
    id = npcID,
    
    gfxwidth = 32,
    gfxheight = 32,

    gfxoffsetx = 0,
    gfxoffsety = 2,
    
    width = 32,
    height = 32,
    
    frames = 2,
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
    
    jumphurt = true,
    spinjumpsafe = false,
    harmlessgrab = false,
    harmlessthrown = false,

    ignorethrownnpcs = true,


    isinteractable = true,


    bounceNPCID = bounceNPCID,

    crackEffectID = crackEffectID,
    fallEffectID = fallEffectID,


    hitFunction = (function(v,hitNPC)
        for i = 1,2 do
            local star = NPC.spawn(yoshi.generalSettings.starNPCID,v.x+v.width*0.5,v.y+v.height*0.5,v.section,false,true)

            star.speedX = 0
            star.speedY = -4
            star.direction = -math.sign(v.speedX)
            star.ai1 = 1
        end
    end),
}

npcManager.setNpcSettings(eggSettings)
npcManager.registerHarmTypes(npcID,
    {
        HARM_TYPE_LAVA,
        HARM_TYPE_OFFSCREEN,
    },
    {
        [HARM_TYPE_JUMP]            = 10,
        [HARM_TYPE_FROMBELOW]       = 10,
        [HARM_TYPE_NPC]             = 10,
        [HARM_TYPE_PROJECTILE_USED] = 10,
        [HARM_TYPE_LAVA]            = {id=13, xoffset=0.5, xoffsetBack = 0, yoffset=1, yoffsetBack = 1.5},
        [HARM_TYPE_HELD]            = 10,
        [HARM_TYPE_TAIL]            = 10,
        [HARM_TYPE_SPINJUMP]        = 10,
        [HARM_TYPE_SWORD]           = 10,
    }
)


ai.registerCollectable(npcID)


return egg