-- by Marioman2007
-- Lumas

local npcManager = require("npcManager")
local npcutils = require("npcs/npcutils")
local particles = require("particles")

local Lumas = {}
local npcID = NPC_ID

local LumasSettings = {
    id = npcID,
    gfxheight = 32,
    gfxwidth = 30,
    width = 32,
    height = 32,
    gfxoffsetx = 0,
    gfxoffsety = 0,
    frames = 2,
    framestyle = 1,
    framespeed = 8,
    speed = 0,

    npcblock = false,
    npcblocktop = false, --Misnomer, affects whether thrown NPCs bounce off the NPC.
    playerblock = false,
    playerblocktop = false, --Also handles other NPCs walking atop this NPC.
    
    nohurt=true,
    nogravity = true,
    noblockcollision = true,
    nofireball = true,
    noiceball = true,
    noyoshi= true,
    nowaterphysics = false,
    notcointransformable = true,

    jumphurt = true, --If true, spiny-like
    spinjumpsafe = false, --If true, prevents player hurt when spinjumping
    harmlessgrab = false, --Held NPC hurts other NPCs if false
    harmlessthrown = true, --Thrown NPC hurts other NPCs if false

    grabside=false,
    grabtop=false,
    ignorethrownnpcs = true,
}

npcManager.setNpcSettings(LumasSettings)

npcManager.registerHarmTypes(npcID, {}, {})

function Lumas.onTickNPC(v)
    if Defines.levelFreeze then return end
    
    local data = v.data

    if v.despawnTimer <= 0 then
        data.initialized = false
        data.timer = nil
        return
    end

    if not data.initialized then
        data.initialized = true
        data.Emmiter = particles.Emitter(0, 0, Misc.resolveFile("p_sparkle.ini"))
    end
    
    if not data.timer then
        data.timer = 0
    end

    npcutils.applyLayerMovement(v)

    data.timer = data.timer + 1
    
    v.speedY = math.sin(data.timer * 0.05) * 0.6
end

function Lumas.onDrawNPC(v)
    local data = v.data
    data.color = data._settings.color or 0

    data.Emmiter:Attach(v)
    data.Emmiter:Draw(-44)

    local Width = NPC.config[v.id].gfxwidth
    local SourceX = data.color * Width

    npcutils.drawNPC(v, {sourceX = SourceX, opacity = 1})
    npcutils.hideNPC(v)
end

function Lumas.onInitAPI()
    npcManager.registerEvent(npcID, Lumas, "onTickNPC")
    npcManager.registerEvent(npcID, Lumas, "onDrawNPC")
end

return Lumas