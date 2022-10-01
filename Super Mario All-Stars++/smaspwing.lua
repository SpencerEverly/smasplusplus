local smaspwing = {}

local pmeter = Graphics.loadImageResolved("graphics/hardcoded/hardcoded-100-4.png")

smaspwing.pSpeedCountersLessQuarterFull = {
    [CHARACTER_MARIO] = 7,
    [CHARACTER_LUIGI] = 10,
    [CHARACTER_PEACH] = 20,
    [CHARACTER_TOAD] = 15,
    [CHARACTER_LINK] = 2,
}

smaspwing.pSpeedCountersHalf = {
    [CHARACTER_MARIO] = 17,
    [CHARACTER_LUIGI] = 20,
    [CHARACTER_PEACH] = 40,
    [CHARACTER_TOAD] = 30,
    [CHARACTER_LINK] = 5,
}

smaspwing.pSpeedCountersMostQuarterFull = {
    [CHARACTER_MARIO] = 27,
    [CHARACTER_LUIGI] = 30,
    [CHARACTER_PEACH] = 60,
    [CHARACTER_TOAD] = 45,
    [CHARACTER_LINK] = 7,
}

smaspwing.pSpeedCountersMostQuarterFull2 = {
    [CHARACTER_MARIO] = 32,
    [CHARACTER_LUIGI] = 35,
    [CHARACTER_PEACH] = 70,
    [CHARACTER_TOAD] = 52,
    [CHARACTER_LINK] = 8.5,
}

smaspwing.pSpeedCountersFull = {
    [CHARACTER_MARIO] = 35,
    [CHARACTER_LUIGI] = 40,
    [CHARACTER_PEACH] = 80,
    [CHARACTER_TOAD] = 60,
    [CHARACTER_LINK] = 10,
}

function smaspwing.onInitAPI()
    registerEvent(smaspwing,"onDraw")
end

function smaspwing.onDraw()
    if not SaveData.disableX2char and player.character < 6 then
        if (player.powerup == 4 or player.powerup == 5) and not Misc.isPaused() then
            if player:mem(0x168, FIELD_FLOAT) >= 0 and player:mem(0x168, FIELD_FLOAT) <= smaspwing.pSpeedCountersLessQuarterFull[player.character] then
                Graphics.drawImageWP(pmeter, 340, 576, 0, 0, 104, 16, -4.1)
            elseif player:mem(0x168, FIELD_FLOAT) >= smaspwing.pSpeedCountersLessQuarterFull[player.character] and player:mem(0x168, FIELD_FLOAT) <= smaspwing.pSpeedCountersHalf[player.character] then
                Graphics.drawImageWP(pmeter, 340, 576, 0, 16, 104, 16, -4.1)
            elseif player:mem(0x168, FIELD_FLOAT) >= smaspwing.pSpeedCountersHalf[player.character] and player:mem(0x168, FIELD_FLOAT) <= smaspwing.pSpeedCountersMostQuarterFull[player.character] then
                Graphics.drawImageWP(pmeter, 340, 576, 0, 32, 104, 16, -4.1)
            elseif player:mem(0x168, FIELD_FLOAT) >= smaspwing.pSpeedCountersMostQuarterFull[player.character] and player:mem(0x168, FIELD_FLOAT) <= smaspwing.pSpeedCountersMostQuarterFull2[player.character] then
                Graphics.drawImageWP(pmeter, 340, 576, 0, 48, 104, 16, -4.1)
            elseif player:mem(0x168, FIELD_FLOAT) >= smaspwing.pSpeedCountersMostQuarterFull2[player.character] and player:mem(0x168, FIELD_FLOAT) < smaspwing.pSpeedCountersFull[player.character] then
                Graphics.drawImageWP(pmeter, 340, 576, 0, 64, 104, 16, -4.1)
            elseif player:mem(0x168, FIELD_FLOAT) == smaspwing.pSpeedCountersFull[player.character] then
                Graphics.drawImageWP(pmeter, 340, 576, 0, 80, 104, 16, -4.1)
                --Graphics.drawImageWP(pmeter, 340, 576, 0, 96, 104, 16, -4.1)
            end
        end
    end
end

return smaspwing