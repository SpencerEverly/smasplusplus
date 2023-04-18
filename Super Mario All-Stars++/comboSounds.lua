--comboSounds by MrDoubleA (ATWE)
--Modded by Spencer Everly for SMAS++

local npcManager = require("npcManager")
local smasExtraSounds = require("smasExtraSounds")

local comboSounds = {}

local SCORE_ADDR = 0x00B2C8E4
local LIVES_ADDR = 0x00B2C5AC

comboSounds.kick1 = smasExtraSounds.sounds[106].sfx
comboSounds.kick2 = smasExtraSounds.sounds[107].sfx
comboSounds.kick3 = smasExtraSounds.sounds[108].sfx
comboSounds.kick4 = smasExtraSounds.sounds[109].sfx
comboSounds.kick5 = smasExtraSounds.sounds[110].sfx
comboSounds.kick6 = smasExtraSounds.sounds[111].sfx
comboSounds.kick7 = smasExtraSounds.sounds[112].sfx

comboSounds.sounds = {
    9,
    9,
    smasExtraSounds.sounds[106].sfx, --Combo sounds 1-7, found under smasExtraSounds
    smasExtraSounds.sounds[107].sfx,
    smasExtraSounds.sounds[108].sfx,
    smasExtraSounds.sounds[109].sfx,
    smasExtraSounds.sounds[110].sfx,
    smasExtraSounds.sounds[111].sfx,
    smasExtraSounds.sounds[112].sfx,
    smasExtraSounds.sounds[112].sfx,
}



comboSounds.exclusionNPCs = table.map{13,263,265}


local comboScores = {
    [10] = 1,
    [100] = 2,
    [200] = 3,
    [400] = 4,
    [800] = 5,
    [1000] = 6,
    [2000] = 7,
    [4000] = 8,
    [8000] = 9,
    [0] = 10,
}


local function getScore()
    return Misc.score() + mem(SCORE_ADDR,FIELD_DWORD)
end


local function getCombo(oldScore,oldLives)
    local scoreDifference = (getScore() - oldScore)
    
    return comboScores[scoreDifference] or 0
end


local harmTypesWithoutComboSounds = table.map{HARM_TYPE_JUMP,HARM_TYPE_PROJECTILE_USED,HARM_TYPE_LAVA,HARM_TYPE_SPINJUMP,HARM_TYPE_VANISH,HARM_TYPE_SWORD}

local hurtSounds = {2,9}

local mutedSoundTimer = 0

function comboSounds.onPostNPCHarm(v,reason,culprit)
    if harmTypesWithoutComboSounds[reason] or comboSounds.exclusionNPCs[v.id] then
        return
    end

    
    if mutedSoundTimer == 0 then
        for _,soundID in ipairs(hurtSounds) do
            Audio.sounds[soundID].muted = true
        end 
    end

    mutedSoundTimer = 2


    v.data.comboSoundsData = v.data.comboSoundsData or {}
    local data = v.data.comboSoundsData

    data.harmTime = lunatime.tick()
    data.harmReason = reason

    -- Used for calculating the combo later
    data.oldScore = getScore()
    data.oldLives = mem(LIVES_ADDR,FIELD_FLOAT)
end

function comboSounds.onNPCKill(eventObj,v,reason)
    local data = v.data.comboSoundsData

    if data ~= nil and (data.harmTime == lunatime.tick() or data.harmTime == lunatime.tick()-1) and data.harmReason == reason then
        local sound = comboSounds.sounds[getCombo(data.oldScore,data.oldLives)]

        if sound ~= nil then
            SFX.play(sound)
        end
    end
end


function comboSounds.onTickEnd()
    if mutedSoundTimer > 0 then
        mutedSoundTimer = mutedSoundTimer - 1
        
        if mutedSoundTimer == 0 then
            for _,soundID in ipairs(hurtSounds) do
                Audio.sounds[soundID].muted = false
            end
        end
    end
end


function comboSounds.onInitAPI()
    registerEvent(comboSounds,"onPostNPCHarm")
    registerEvent(comboSounds,"onNPCKill")
    registerEvent(comboSounds,"onTickEnd")
end


return comboSounds