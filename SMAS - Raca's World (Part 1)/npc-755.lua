-- by Marioman2007
-- Starbits

local npcManager = require("npcManager")
local npcutils = require("npcs/npcutils")

local Starbits = {}
local npcID = NPC_ID

local StarbitsSettings = {
    id = npcID,
    gfxheight = 32,
    gfxwidth = 28,
    width = 32,
    height = 32,
    gfxoffsetx = 0,
    gfxoffsety = 0,
    frames = 5,
    framestyle = 0,
    framespeed = 8,
    speed = 0,
    npcblock = false,
    npcblocktop = false, --Misnomer, affects whether thrown NPCs bounce off the NPC.
    playerblock = false,
    playerblocktop = false, --Also handles other NPCs walking atop this NPC.
    
    nohurt=true,
    nogravity = true,
    noblockcollision = false,
    nofireball = true,
    noiceball = true,
    noyoshi= false,
    nowaterphysics = false,
    notcointransformable = true,

    jumphurt = false, --If true, spiny-like
    spinjumpsafe = false, --If true, prevents player hurt when spinjumping
    harmlessgrab = true, --Held NPC hurts other NPCs if false
    harmlessthrown = false, --Thrown NPC hurts other NPCs if false

    grabside=false,
    grabtop=false,
    ignorethrownnpcs = true,
    isinteractable = true,

    soundEffect = SFX.open(Misc.resolveSoundFile("SFX/starbit")), -- The sound effect that will play when the player collects the starbit.
    soundEffectVolume = 0.8, -- Volume of the sound effect played, must be between 0 and 1.
}

npcManager.setNpcSettings(StarbitsSettings)

npcManager.registerHarmTypes(npcID, {}, {})

function Starbits.onTickNPC(v)
    if Defines.levelFreeze then return end
    
    local data = v.data
    
    if v.despawnTimer <= 0 then
        data.initialized = false
        return
    end

    if not data.initialized then
        data.initialized = true
    end
end

function Starbits.onDrawNPC(v)
    local data = v.data
    data.color = data._settings.color or 0

    local Width = NPC.config[v.id].gfxwidth
    local SourceX = data.color * Width

    npcutils.drawNPC(v, {sourceX = SourceX, opacity = 1})
end

function Starbits.onPostNPCKill(v,reason)
    if v.id ~= npcID then
        return
    end

    if npcManager.collected(v,reason) then
        Misc.givePoints( 1, v, true)
        Effect.spawn(78, v.x + (v.width / 2), v.y + (v.height / 2))
        SFX.play(NPC.config[npcID].soundEffect, NPC.config[npcID].soundEffectVolume)
    end
end

function Starbits.onInitAPI()
    npcManager.registerEvent(npcID, Starbits, "onTickNPC")
    npcManager.registerEvent(npcID, Starbits, "onDrawNPC")
    registerEvent(Starbits, "onPostNPCKill", "onPostNPCKill")
end

return Starbits