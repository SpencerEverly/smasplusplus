local playerManager = require("playerManager")
local smasExtraSounds = require("smasExtraSounds")
local smasHud = require("smasHud")
local smasFunctions = require("smasFunctions")

local costume = {}

costume.loaded = false

local plr

function costume.onInit(p)
    plr = p
    registerEvent(costume,"onTick")
    registerEvent(costume,"onDraw")
    registerEvent(costume,"onPlayerHarm")
    registerEvent(costume,"onPostPlayerHarm")
    registerEvent(costume,"onPostNPCKill")
    registerEvent(costume,"onPlayerKill")
    if not costume.loaded then
        Sound.loadCostumeSounds()
        costume.loaded = true
    end
    smasCharacterHealthSystem.enabled = true
end

local timeddelay = 0

function costume.onDraw()
    if SaveData.toggleCostumeAbilities then
        if Level.endState() == 0 and (not GameData.winStateActive or GameData.winStateActive == nil) then
            if Timer.getValue() == 100 then
                timeddelay = timeddelay + 1
                if timeddelay == 1 then
                    Sound.playSFX("mario/10-HotelMario/hm-gottabequick")
                end
            else
                timeddelay = 0
            end
        end
    end
end

function costume.onCleanup(p)
    Sound.cleanupCostumeSounds()
    smasCharacterHealthSystem.enabled = false
end

Misc.storeLatestCostumeData(costume)

return costume