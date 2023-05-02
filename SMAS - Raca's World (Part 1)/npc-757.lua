-- by Marioman2007
-- Air Mushroom
-- Maximizes the the player's air meter

local npcManager = require("npcManager")
local SmgLifeSystem = require("SmgLifeSystem")

local LifeUpMushroom = {}
local npcID = NPC_ID

local LifeUpMushroomSettings = {
    id = npcID,
    gfxheight = 32,
    gfxwidth = 32,
    width = 32,
    height = 32,
    gfxoffsetx = 0,
    gfxoffsety = 0,
    frames = 1,
    framestyle = 0,
    framespeed = 8,
    speed = 0,
    npcblock = false,
    npcblocktop = false, --Misnomer, affects whether thrown NPCs bounce off the NPC.
    playerblock = false,
    playerblocktop = false, --Also handles other NPCs walking atop this NPC.

    nohurt=true,
    nogravity = false,
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
    isinteractable = true,

    CoinsReward = 10, -- The amount of coins given to the player when the player collects a mushroom when the HP is full

    soundEffect = SFX.open(Misc.resolveSoundFile("SFX/smrpg_item")), -- The sound effect that will play when the player collects the power-up.
    soundEffectVolume = 0.4, -- Volume of "soundEffect"
}

npcManager.setNpcSettings(LifeUpMushroomSettings)
npcManager.registerHarmTypes(npcID, {}, {})

function LifeUpMushroom.onTickNPC(v)
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

function LifeUpMushroom.onPostNPCKill(v,reason)
    if v.id ~= npcID then
        return
    end

    if npcManager.collected(v,reason) then
        if SmgLifeSystem.AirLeft ~= SmgLifeSystem.AirMax then
            SmgLifeSystem.setHealth(SmgLifeSystem.AirMax, 2)
        elseif SmgLifeSystem.AirLeft == SmgLifeSystem.AirMax then
            Misc.coins(NPC.config[npcID].CoinsReward, false)
        end

        Misc.givePoints( 6, v, true)
        SFX.play(NPC.config[npcID].soundEffect, NPC.config[npcID].soundEffectVolume)
    end
end

function LifeUpMushroom.onInitAPI()
    npcManager.registerEvent(npcID, LifeUpMushroom, "onTickNPC")
    registerEvent(LifeUpMushroom, "onPostNPCKill", "onPostNPCKill")
end

return LifeUpMushroom