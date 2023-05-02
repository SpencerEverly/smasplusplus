local level_dependencies_normal= require("level_dependencies_normal")

function onEvent(eventName)
    if eventName == "Talk 7.1" then
        Sound.playSFX(39)
    end
    if eventName == "Game end?" then
        Sound.changeMusic("_OST/Where SMB Attacks/game_beat_not.ogg", 0)
    end
    if eventName == "Event 2" then
        Sound.playSFX(4)
    end
end

function onExit()
    for _,p in ipairs(Player.get()) do
        if p:mem(0x15E, FIELD_WORD) == 1 and p.forcedState == FORCEDSTATE_INVISIBLE then --Exit with a win state if warping
            Level.exit(LEVEL_WIN_TYPE_STAR)
        end
    end
end