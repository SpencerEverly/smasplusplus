local smasPWing = {}

local smasHud = require("smasHud")

local pmeter = Graphics.loadImageResolved("graphics/hardcoded/hardcoded-100-4.png")

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

function smasPWing.onInitAPI()
    registerEvent(smasPWing,"onDraw")
end

function smasPWing.onDraw()
    if smasHud.visible.pWing then
        if not SaveData.disableX2char then
            if (player.powerup == 4 or player.powerup == 5) and not Misc.isPaused() then
                if player:mem(0x168, FIELD_FLOAT) >= 0 and (player:mem(0x168, FIELD_FLOAT) <= smasPWing.pSpeedCounters[player.character] * 0.2) then
                    Graphics.drawImageWP(pmeter, 340, 576, 0, 0, 104, 16, -4.1)
                elseif player:mem(0x168, FIELD_FLOAT) >= (smasPWing.pSpeedCounters[player.character] * 0.2) and (player:mem(0x168, FIELD_FLOAT) <= smasPWing.pSpeedCounters[player.character] * 0.4) then
                    Graphics.drawImageWP(pmeter, 340, 576, 0, 16, 104, 16, -4.1)
                elseif player:mem(0x168, FIELD_FLOAT) >= (smasPWing.pSpeedCounters[player.character] * 0.4) and (player:mem(0x168, FIELD_FLOAT) <= smasPWing.pSpeedCounters[player.character] * 0.6) then
                    Graphics.drawImageWP(pmeter, 340, 576, 0, 32, 104, 16, -4.1)
                elseif player:mem(0x168, FIELD_FLOAT) >= (smasPWing.pSpeedCounters[player.character] * 0.6) and (player:mem(0x168, FIELD_FLOAT) <= smasPWing.pSpeedCounters[player.character] * 0.8) then
                    Graphics.drawImageWP(pmeter, 340, 576, 0, 48, 104, 16, -4.1)
                elseif player:mem(0x168, FIELD_FLOAT) >= (smasPWing.pSpeedCounters[player.character] * 0.8) and player:mem(0x168, FIELD_FLOAT) < smasPWing.pSpeedCounters[player.character] then
                    Graphics.drawImageWP(pmeter, 340, 576, 0, 64, 104, 16, -4.1)
                elseif player:mem(0x168, FIELD_FLOAT) == smasPWing.pSpeedCounters[player.character] then
                    Graphics.drawImageWP(pmeter, 340, 576, 0, 80, 104, 16, -4.1)
                    --Graphics.drawImageWP(pmeter, 340, 576, 0, 96, 104, 16, -4.1)
                end
            end
        end
    end
end

return smasPWing