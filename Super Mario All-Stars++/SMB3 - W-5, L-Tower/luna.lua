local level_dependencies_normal= require("level_dependencies_normal")

local inventory = require("customInventory")

function onExit()
    for _,p in ipairs(Player.get()) do
        if p:mem(0x15E, FIELD_WORD) == 6 and p.forcedState == FORCEDSTATE_INVISIBLE then --Exit with a win state if warping
            --SaveData.smwMap.playerX = -191712 --Map not made yet, will be used when it does get made
            --SaveData.smwMap.playerY = -199168
            Level.exit(LEVEL_WIN_TYPE_STAR)
        end
    end
end