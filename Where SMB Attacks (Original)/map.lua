local playerManager = require("playerManager")
playerManager.overworldCharacters = {CHARACTER_MARIO, CHARACTER_LUIGI, CHARACTER_PEACH, CHARACTER_TOAD, CHARACTER_LINK}

function onStart()
	Audio.MusicVolume(nil)
	mem(0xB25728, FIELD_BOOL, false) -- Sets the episode back to world map type. Without it, the START level will still play everytime you try to exit the level.
end