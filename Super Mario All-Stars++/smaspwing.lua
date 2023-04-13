local smasPWing = {}

local smasHud = require("smasHud")

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

smasPWing.frameSpeed = 5 --For the P-Wing flashing

function smasPWing.onInitAPI()
    registerEvent(smasPWing,"onDraw")
end

function smasPWing.onDraw()
    if smasHud.visible.pWing then
        Text.print(player:mem(0x170, FIELD_WORD), 100, 100)
        local pWingFrame = math.floor((lunatime.tick() / smasPWing.frameSpeed) % 2)
        if not SaveData.disableX2char then
            if (player.powerup == 4 or player.powerup == 5) and not Misc.isPaused() then
                if not player:mem(0x16E, FIELD_BOOL) then
                    if player:mem(0x168, FIELD_FLOAT) >= 0 and (player:mem(0x168, FIELD_FLOAT) <= smasPWing.pSpeedCounters[player.character] * 0.2) then
                        Graphics.drawImageWP(smasPWing.pMeter, 340, 576, 0, 0, smasPWing.pMeterArrowSizeWidth, smasPWing.pMeterArrowSizeHeight, smasPWing.priority)
                    elseif player:mem(0x168, FIELD_FLOAT) >= (smasPWing.pSpeedCounters[player.character] * 0.2) and (player:mem(0x168, FIELD_FLOAT) <= smasPWing.pSpeedCounters[player.character] * 0.4) then
                        Graphics.drawImageWP(smasPWing.pMeter, 340, 576, 0, 16, smasPWing.pMeterArrowSizeWidth, smasPWing.pMeterArrowSizeHeight, smasPWing.priority)
                    elseif player:mem(0x168, FIELD_FLOAT) >= (smasPWing.pSpeedCounters[player.character] * 0.4) and (player:mem(0x168, FIELD_FLOAT) <= smasPWing.pSpeedCounters[player.character] * 0.6) then
                        Graphics.drawImageWP(smasPWing.pMeter, 340, 576, 0, 32, smasPWing.pMeterArrowSizeWidth, smasPWing.pMeterArrowSizeHeight, smasPWing.priority)
                    elseif player:mem(0x168, FIELD_FLOAT) >= (smasPWing.pSpeedCounters[player.character] * 0.6) and (player:mem(0x168, FIELD_FLOAT) <= smasPWing.pSpeedCounters[player.character] * 0.8) then
                        Graphics.drawImageWP(smasPWing.pMeter, 340, 576, 0, 48, smasPWing.pMeterArrowSizeWidth, smasPWing.pMeterArrowSizeHeight, smasPWing.priority)
                    elseif player:mem(0x168, FIELD_FLOAT) >= (smasPWing.pSpeedCounters[player.character] * 0.8) and player:mem(0x168, FIELD_FLOAT) < smasPWing.pSpeedCounters[player.character] then
                        Graphics.drawImageWP(smasPWing.pMeter, 340, 576, 0, 64, smasPWing.pMeterArrowSizeWidth, smasPWing.pMeterArrowSizeHeight, smasPWing.priority)
                    elseif player:mem(0x168, FIELD_FLOAT) == smasPWing.pSpeedCounters[player.character] then
                        Graphics.drawImageWP(smasPWing.pMeter, 340, 576, 0, 80, smasPWing.pMeterArrowSizeWidth, smasPWing.pMeterArrowSizeHeight, smasPWing.priority)
                    end
                else
                    if (player:mem(0x170, FIELD_WORD) >= 0 and player:mem(0x170, FIELD_WORD) <= smasPWing.pSpeedFlyTimers[player.character] * 0.2) then
                        Graphics.drawImageWP(smasPWing.pMeter, 340, 576, 0, 16, smasPWing.pMeterArrowSizeWidth, smasPWing.pMeterArrowSizeHeight, smasPWing.priority)
                    elseif (player:mem(0x170, FIELD_WORD) >= smasPWing.pSpeedFlyTimers[player.character] * 0.2) and (player:mem(0x170, FIELD_WORD) <= smasPWing.pSpeedFlyTimers[player.character] * 0.4) then
                        Graphics.drawImageWP(smasPWing.pMeter, 340, 576, 0, 32, smasPWing.pMeterArrowSizeWidth, smasPWing.pMeterArrowSizeHeight, smasPWing.priority)
                    elseif (player:mem(0x170, FIELD_WORD) >= smasPWing.pSpeedFlyTimers[player.character] * 0.4) and (player:mem(0x170, FIELD_WORD) <= smasPWing.pSpeedFlyTimers[player.character] * 0.6) then
                        Graphics.drawImageWP(smasPWing.pMeter, 340, 576, 0, 48, smasPWing.pMeterArrowSizeWidth, smasPWing.pMeterArrowSizeHeight, smasPWing.priority)
                    elseif (player:mem(0x170, FIELD_WORD) >= smasPWing.pSpeedFlyTimers[player.character] * 0.6) and (player:mem(0x170, FIELD_WORD) <= smasPWing.pSpeedFlyTimers[player.character] * 0.8) then
                        Graphics.drawImageWP(smasPWing.pMeter, 340, 576, 0, 64, smasPWing.pMeterArrowSizeWidth, smasPWing.pMeterArrowSizeHeight, smasPWing.priority)
                    elseif (player:mem(0x170, FIELD_WORD) >= smasPWing.pSpeedFlyTimers[player.character] * 0.8) and (player:mem(0x170, FIELD_WORD) <= smasPWing.pSpeedFlyTimers[player.character]) then
                        Graphics.drawImageWP(smasPWing.pMeter, 340, 576, 0, 80, smasPWing.pMeterArrowSizeWidth, smasPWing.pMeterArrowSizeHeight, smasPWing.priority)
                    end
                end
                if player:mem(0x16C, FIELD_BOOL) or player:mem(0x16E, FIELD_BOOL) then
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
    end
end

return smasPWing