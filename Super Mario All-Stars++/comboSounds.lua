--comboSounds by MrDoubleA (ATWE)
--Modded by Spencer Everly for SMAS++

local npcManager = require("npcManager")
local extrasounds = require("extrasounds")

local comboSounds = {}

local SCORE_ADDR = 0x00B2C8E4
local LIVES_ADDR = 0x00B2C5AC

comboSounds.kick1 = extrasounds.id106
comboSounds.kick2 = extrasounds.id107
comboSounds.kick3 = extrasounds.id108
comboSounds.kick4 = extrasounds.id109
comboSounds.kick5 = extrasounds.id110
comboSounds.kick6 = extrasounds.id111
comboSounds.kick7 = extrasounds.id112
comboSounds.kick8 = extrasounds.id113

comboSounds.sounds = {
    9,
	extrasounds.id106, --Combo sounds 1-7, found under extrasounds
    extrasounds.id107,
    extrasounds.id108,
    extrasounds.id109,
    extrasounds.id110,
    extrasounds.id111,
    extrasounds.id112,
	extrasounds.id112, --And then the same shell sound for rest of the hits
}



comboSounds.exclusionNPCs = table.map{13,263,265}


local comboScores = {
    [100] = 1,
    [200] = 2,
    [400] = 3,
    [800] = 4,
    [1000] = 5,
    [2000] = 6,
    [4000] = 7,
    [8000] = 8,
	[0] = 9, --1UP sound
}


local function getScore()
    return Misc.score() + mem(SCORE_ADDR,FIELD_DWORD)
end


local function getCombo(oldScore,oldLives)
    local scoreDifference = (getScore() - oldScore)
    
    return comboScores[scoreDifference] or 0
end


local harmTypesWithoutComboSounds = table.map{HARM_TYPE_PROJECTILE_USED,HARM_TYPE_LAVA,HARM_TYPE_SPINJUMP,HARM_TYPE_VANISH,HARM_TYPE_SWORD}

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