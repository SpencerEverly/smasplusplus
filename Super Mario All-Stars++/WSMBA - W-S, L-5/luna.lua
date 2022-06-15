local level_dependencies_normal= require("level_dependencies_normal")

function onExit()
	if player:mem(0x15E, FIELD_WORD) == 2 and player.forcedState == FORCEDSTATE_INVISIBLE then --Exit with a win state if warping
		Level.exit(LEVEL_WIN_TYPE_STAR)
	end
end