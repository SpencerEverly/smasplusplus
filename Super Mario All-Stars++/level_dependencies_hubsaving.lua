function onStart()
-- If SaveGame.currentHub specified an alternate hub level, set that as the hub level path
	if (SaveGame.currentHub = "SMAS - Start.lvlx") then
		mem(0xB25724, FIELD_STRING, SaveGame.currentHub)
		SaveGame.currentHub = "MALC - HUB.lvlx"
	end
end

function onExit()
	if (SaveGame.currentHub = "MALC - HUB.lvlx") then
		mem(0xB25724, FIELD_STRING, SaveGame.currentHub)
		SaveGame.currentHub = "SMAS - Start.lvlx"
	end
end