--[[

    Written by MrDoubleA
    Please give credit!
    
    Alternate graphics made by Palutena, permission for use was given by universalidiocy#3253 on Discord, and are from an HTML game called "Super Mario Construct"

    Part of MrDoubleA's NPC Pack

]]

local npcManager = require("npcManager")
local ai = require("boomBoom_ai")
local smasExtraSounds = require("smasExtraSounds")

local boomBoom = {}
local npcID = NPC_ID

local hideID = (npcID+1)
local deathEffectID = (npcID-1)

local boomBoomSettings = {
    id = npcID,
    
    gfxwidth = 64,
    gfxheight = 64,

    gfxoffsetx = 0,
    gfxoffsety = 0,
    
    width = 40,
    height = 40,
    
    frames = 10,
    framestyle = 1,
    framespeed = 4,
    
    speed = 1,
    score = 8,
    
    npcblock = false,
    npcblocktop = false, --Misnomer, affects whether thrown NPCs bounce off the NPC.
    playerblock = false,
    playerblocktop = false, --Also handles other NPCs walking atop this NPC.

    nohurt = false,
    nogravity = true,
    noblockcollision = true,
    nofireball = false,
    noiceball = true,
    noyoshi = true,
    nowaterphysics = false,
    
    jumphurt = false,
    spinjumpsafe = false,
    harmlessgrab = false,
    harmlessthrown = false,

    health = 3,  -- How much health the NPC has.
    hitSFX = smasExtraSounds.sounds[39].sfx, -- The sound effect played when hurting the NPC. Can be nil for none, a number for a vanilla sound, or a sound effect object/string for a custom sound.

    chaseDistance = 1024, -- The maximum distance away from the player that the NPC can be in order to chase the player.

    chaseSpeed = 6,           -- The max speed that the NPC can chase the player at.
    chaseAcceleration = 0.15, -- How fast the NPC accelerates when chasing the player.
    chaseTime = 128,          -- How long the NPC will chase the player before attacking.

    attackPrepareTime = 24, -- How long the NPC will be preparing an attack before executing it.

    hurtTime = 48, -- How long the NPC will do its hurt animation before hiding.

    hideTime = 96,   -- How long the NPC will be hiding for.
    hideID = hideID, -- The ID that the NPC will transform into when hiding. Can also be nil for no transformation.
}

npcManager.setNpcSettings(boomBoomSettings)
npcManager.registerDefines(npcID, {NPC.HITTABLE})
npcManager.registerHarmTypes(npcID,
    {
        HARM_TYPE_JUMP,
        HARM_TYPE_FROMBELOW,
        HARM_TYPE_NPC,
        HARM_TYPE_PROJECTILE_USED,
        HARM_TYPE_LAVA,
        HARM_TYPE_HELD,
        HARM_TYPE_OFFSCREEN,
        HARM_TYPE_SWORD
    }, 
    {
        [HARM_TYPE_JUMP]            = deathEffectID,
        [HARM_TYPE_FROMBELOW]       = deathEffectID,
        [HARM_TYPE_NPC]             = deathEffectID,
        [HARM_TYPE_PROJECTILE_USED] = deathEffectID,
        [HARM_TYPE_LAVA]            = deathEffectID,
        [HARM_TYPE_HELD]            = deathEffectID,
        [HARM_TYPE_TAIL]            = deathEffectID,
        [HARM_TYPE_SPINJUMP]        = deathEffectID,
        [HARM_TYPE_SWORD]           = deathEffectID,
    }
)

ai.registerWinged(npcID)

return boomBoom