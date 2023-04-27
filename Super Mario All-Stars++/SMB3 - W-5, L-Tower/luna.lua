local level_dependencies_normal= require("level_dependencies_normal")

function onExit()
    for _,p in ipairs(Player.get()) do
        if p:mem(0x15E, FIELD_WORD) == 6 and p.forcedState == FORCEDSTATE_INVISIBLE then --Exit with a win state if warping
            Level.exit(LEVEL_WIN_TYPE_STAR)
        end
    end
end