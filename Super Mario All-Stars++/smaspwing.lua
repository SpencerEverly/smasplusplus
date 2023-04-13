local smasPWing = {}

local smasHud = require("smasHud")
local extrasounds = require("extrasounds")

smasPWing.pMeter = Graphics.loadImageResolved("graphics/hardcoded/hardcoded-100-4.png")
smasPWing.pMeterArrowSizeWidth = 80
smasPWing.pMeterArrowSizeHeight = 16
smasPWing.priority = 5
smasPWing.pSpeedCounters = {
    [CHARACTER_MARIO] = 35,
    [CHARACTER_LUIGI] = 40,
    [CHARACTER_PEACH] = 80,
    [CHARACTER_TOAD] = 60,
    [CHARACTER_LINK] = 10,
    [CHARACTER_MEGAMAN] = 60,
    [CHARACTER_WARIO] = 35,
    [CHARACTER_BOWSER] = 40,
    [CHARACTER_KLONOA] = 60,
    [CHARACTER_NINJABOMBERMAN] = 80,
    [CHARACTER_ROSALINA] = 80,
    [CHARACTER_SNAKE] = 10,
    [CHARACTER_ZELDA] = 40,
    [CHARACTER_ULTIMATERINKA] = 60,
    [CHARACTER_UNCLEBROADSWORD] = 35,
    [CHARACTER_SAMUS] = 10,
}
smasPWing.pSpeedFlyTimers = {
    [CHARACTER_MARIO] = 320,
    [CHARACTER_LUIGI] = 300,
    [CHARACTER_PEACH] = 280,
    [CHARACTER_TOAD] = 320,
    [CHARACTER_LINK] = 320,
    [CHARACTER_MEGAMAN] = 320,
    [CHARACTER_WARIO] = 320,
    [CHARACTER_BOWSER] = 300,
    [CHARACTER_KLONOA] = 320,
    [CHARACTER_NINJABOMBERMAN] = 280,
    [CHARACTER_ROSALINA] = 280,
    [CHARACTER_SNAKE] = 320,
    [CHARACTER_ZELDA] = 300,
    [CHARACTER_ULTIMATERINKA] = 320,
    [CHARACTER_UNCLEBROADSWORD] = 320,
    [CHARACTER_SAMUS] = 320,
}
smasPWing.overridePWingToOutside4And5 = false --Only true if costume data was found pertaining to the P-Wing
smasPWing.leafPowerups = table.map{PLAYER_LEAF,PLAYER_TANOOKIE}

smasPWing.frameSpeed = 5 --For the P-Wing flashing

function smasPWing.onInitAPI()
    registerEvent(smasPWing,"onDraw")
    registerEvent(smasPWing,"onTick")
end

function smasPWing.isFlying(p)
    return p:mem(0x16E, FIELD_BOOL)
end

function smasPWing.runningCounter(plr)
    if smasCharacterCostumes.currentCostume.playersList ~= nil then
        for _,p in ipairs(smasCharacterCostumes.currentCostume.playersList) do
            local data = smasCharacterCostumes.currentCostume.playerData[p]
            if data.pSpeed ~= nil then
                return data.pSpeed
            end
        end
    else
        return plr:mem(0x168, FIELD_FLOAT)
    end
end

function smasPWing.canStartFlying(plr)
    if smasCharacterCostumes.currentCostume.playersList ~= nil then
        for _,p in ipairs(smasCharacterCostumes.currentCostume.playersList) do
            local data = smasCharacterCostumes.currentCostume.playerData[p]
            local atPSpeed = (p.holdingNPC == nil)

            if atPSpeed then
                if smasPWing.leafPowerups[p.powerup] then
                    atPSpeed = p:mem(0x16C,FIELD_BOOL) or p:mem(0x16E,FIELD_BOOL)
                else
                    atPSpeed = (data.pSpeed >= smasPWing.pSpeedCounters[p.character])
                end
            end
            
            return atPSpeed
        end
    else
        return plr:mem(0x16C, FIELD_BOOL)
    end
end

function smasPWing.remainingFlightTimer(p)
    return p:mem(0x170, FIELD_WORD)
end

function smasPWing.drawPWingHud()
    if smasHud.visible.pWing then
        local pWingFrame = math.floor((lunatime.tick() / smasPWing.frameSpeed) % 2)
        if not smasPWing.isFlying(player) then
            if smasPWing.runningCounter(player) >= 0 and (smasPWing.runningCounter(player) <= smasPWing.pSpeedCounters[player.character] * 0.2) then
                Graphics.drawImageWP(smasPWing.pMeter, 340, 576, 0, 0, smasPWing.pMeterArrowSizeWidth, smasPWing.pMeterArrowSizeHeight, smasPWing.priority)
            elseif smasPWing.runningCounter(player) >= (smasPWing.pSpeedCounters[player.character] * 0.2) and (smasPWing.runningCounter(player) <= smasPWing.pSpeedCounters[player.character] * 0.4) then
                Graphics.drawImageWP(smasPWing.pMeter, 340, 576, 0, 16, smasPWing.pMeterArrowSizeWidth, smasPWing.pMeterArrowSizeHeight, smasPWing.priority)
            elseif smasPWing.runningCounter(player) >= (smasPWing.pSpeedCounters[player.character] * 0.4) and (smasPWing.runningCounter(player) <= smasPWing.pSpeedCounters[player.character] * 0.6) then
                Graphics.drawImageWP(smasPWing.pMeter, 340, 576, 0, 32, smasPWing.pMeterArrowSizeWidth, smasPWing.pMeterArrowSizeHeight, smasPWing.priority)
            elseif smasPWing.runningCounter(player) >= (smasPWing.pSpeedCounters[player.character] * 0.6) and (smasPWing.runningCounter(player) <= smasPWing.pSpeedCounters[player.character] * 0.8) then
                Graphics.drawImageWP(smasPWing.pMeter, 340, 576, 0, 48, smasPWing.pMeterArrowSizeWidth, smasPWing.pMeterArrowSizeHeight, smasPWing.priority)
            elseif smasPWing.runningCounter(player) >= (smasPWing.pSpeedCounters[player.character] * 0.8) and smasPWing.runningCounter(player) < smasPWing.pSpeedCounters[player.character] then
                Graphics.drawImageWP(smasPWing.pMeter, 340, 576, 0, 64, smasPWing.pMeterArrowSizeWidth, smasPWing.pMeterArrowSizeHeight, smasPWing.priority)
            elseif smasPWing.runningCounter(player) == smasPWing.pSpeedCounters[player.character] then
                Graphics.drawImageWP(smasPWing.pMeter, 340, 576, 0, 80, smasPWing.pMeterArrowSizeWidth, smasPWing.pMeterArrowSizeHeight, smasPWing.priority)
            end
        else
            if (smasPWing.remainingFlightTimer(player) >= 0 and smasPWing.remainingFlightTimer(player) <= smasPWing.pSpeedFlyTimers[player.character] * 0.2) then
                Graphics.drawImageWP(smasPWing.pMeter, 340, 576, 0, 16, smasPWing.pMeterArrowSizeWidth, smasPWing.pMeterArrowSizeHeight, smasPWing.priority)
            elseif (smasPWing.remainingFlightTimer(player) >= smasPWing.pSpeedFlyTimers[player.character] * 0.2) and (smasPWing.remainingFlightTimer(player) <= smasPWing.pSpeedFlyTimers[player.character] * 0.4) then
                Graphics.drawImageWP(smasPWing.pMeter, 340, 576, 0, 32, smasPWing.pMeterArrowSizeWidth, smasPWing.pMeterArrowSizeHeight, smasPWing.priority)
            elseif (smasPWing.remainingFlightTimer(player) >= smasPWing.pSpeedFlyTimers[player.character] * 0.4) and (smasPWing.remainingFlightTimer(player) <= smasPWing.pSpeedFlyTimers[player.character] * 0.6) then
                Graphics.drawImageWP(smasPWing.pMeter, 340, 576, 0, 48, smasPWing.pMeterArrowSizeWidth, smasPWing.pMeterArrowSizeHeight, smasPWing.priority)
            elseif (smasPWing.remainingFlightTimer(player) >= smasPWing.pSpeedFlyTimers[player.character] * 0.6) and (smasPWing.remainingFlightTimer(player) <= smasPWing.pSpeedFlyTimers[player.character] * 0.8) then
                Graphics.drawImageWP(smasPWing.pMeter, 340, 576, 0, 64, smasPWing.pMeterArrowSizeWidth, smasPWing.pMeterArrowSizeHeight, smasPWing.priority)
            elseif (smasPWing.remainingFlightTimer(player) >= smasPWing.pSpeedFlyTimers[player.character] * 0.8) and (smasPWing.remainingFlightTimer(player) <= smasPWing.pSpeedFlyTimers[player.character]) then
                Graphics.drawImageWP(smasPWing.pMeter, 340, 576, 0, 80, smasPWing.pMeterArrowSizeWidth, smasPWing.pMeterArrowSizeHeight, smasPWing.priority)
            end
        end
        if (smasPWing.canStartFlying(player) or smasPWing.isFlying(player)) then
            if pWingFrame == 1 then
                Graphics.drawImageWP(smasPWing.pMeter, 420, 576, 80, 80, 24, 16, smasPWing.priority)
            else
                Graphics.drawImageWP(smasPWing.pMeter, 420, 576, 80, 96, 24, 16, smasPWing.priority)
            end
        else
            Graphics.drawImageWP(smasPWing.pMeter, 420, 576, 80, 96, 24, 16, smasPWing.priority)
        end
    end
end

function smasPWing.onTick()
    if not SaveData.disableX2char then
        if smasCharacterCostumes.currentCostume.playersList ~= nil then
            if smasPWing.canStartFlying(player) and not smasPWing.leafPowerups[player.powerup] then
                if extrasounds.active then
                    if extrasounds.enablePWingSFX then 
                        Sound.playSFX(121, extrasounds.volume, 1, extrasounds.pWingDelay)
                    end
                end
            end
        end
    end
end

function smasPWing.onDraw()
    if not SaveData.disableX2char then
        if smasCharacterCostumes.currentCostume.playersList ~= nil then
            for _,p in ipairs(smasCharacterCostumes.currentCostume.playersList) do
                local data = smasCharacterCostumes.currentCostume.playerData[p]
                if data.pSpeed ~= nil and not Misc.isPaused() and not smasPWing.leafPowerups[player.powerup] then
                    smasPWing.drawPWingHud()
                end
            end
        end
        if smasPWing.leafPowerups[player.powerup] and not Misc.isPaused() then
            smasPWing.drawPWingHud()
        end
    end
end

return smasPWing