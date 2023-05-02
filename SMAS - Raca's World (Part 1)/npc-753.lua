-- by Marioman2007
-- Heart
-- Adds one the the player's health meter

local npcManager = require("npcManager")
local SmgLifeSystem = require("SmgLifeSystem")

local Heart = {}
local npcID = NPC_ID

local HeartSettings = {
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

    soundEffect = SFX.open(Misc.resolveSoundFile("SFX/smrpg_item_mushroom")), -- The sound effect that will play when the player collects the power-up.
    soundEffectVolume = 0.5, -- Volume of the sound effect played, must be between 0 and 1.
}

npcManager.setNpcSettings(HeartSettings)
npcManager.registerHarmTypes(npcID, {}, {})

function Heart.onTickNPC(v)
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

function Heart.onPostNPCKill(v,reason)
    if v.id ~= npcID then
        return
    end

    if npcManager.collected(v,reason) then
        if not SmgLifeSystem.daredevilActive then
            if (SmgLifeSystem.HealthCounter ~= SmgLifeSystem.MaxHealth) and (SmgLifeSystem.HealthCounter ~= SmgLifeSystem.MainHealth) then
                SmgLifeSystem.addHealth(1, 1)
            elseif (SmgLifeSystem.HealthCounter == SmgLifeSystem.MaxHealth) or (SmgLifeSystem.HealthCounter == SmgLifeSystem.MainHealth) then
                if NPC.config[npcID].CoinsReward > 0 then
                    Misc.coins(NPC.config[npcID].CoinsReward, false)
                end
            end
        end

        Misc.givePoints( 6, v, true)
        SFX.play(NPC.config[npcID].soundEffect, NPC.config[npcID].soundEffectVolume)
    end
end

function Heart.onInitAPI()
    npcManager.registerEvent(npcID, Heart, "onTickNPC")
    registerEvent(Heart, "onPostNPCKill", "onPostNPCKill")
end

return Heart