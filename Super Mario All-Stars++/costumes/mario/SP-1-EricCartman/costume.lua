local pm = require("playerManager")

local costume = {}

costume.playersList = {}
costume.playerData = {}

local eventsRegistered = false

function costume.onInit(p)
	-- If events have not been registered yet, do so
	if not eventsRegistered then
		registerEvent(costume,"onStart")
		registerEvent(costume,"onTick")
		registerEvent(costume,"onTickEnd")
		registerEvent(costume,"onCleanup")
		registerEvent(costume,"onInputUpdate")

		eventsRegistered = true
		
		-- Add this player to the list
	if costume.playerData[p] == nil then
		costume.playerData[p] = {
			currentAnimation = "",
		}
		
		table.insert(costume.playersList,p)
		end
	end
end

function costume.onTickEnd()
	for _,p in ipairs(costume.playersList) do
		local data = costume.playerData[p]
	end
end
	
function costume.onTick() --WIP
	--Audio.sounds[1].sfx  = Audio.SfxOpen("costumes/mario/SP-1-EricCartman/player-jump.ogg")
	Audio.sounds[5].sfx  = Audio.SfxOpen("costumes/mario/SP-1-EricCartman/player-shrink.ogg")
	Audio.sounds[6].sfx  = Audio.SfxOpen("costumes/mario/SP-1-EricCartman/player-grow.ogg")
	Audio.sounds[8].sfx  = Audio.SfxOpen("costumes/mario/SP-1-EricCartman/player-died.ogg")
	Audio.sounds[15].sfx = Audio.SfxOpen("costumes/mario/SP-1-EricCartman/1up.ogg")
	Audio.sounds[31].sfx = Audio.SfxOpen("costumes/mario/SP-1-EricCartman/key.ogg")
	Audio.sounds[34].sfx = Audio.SfxOpen("costumes/mario/SP-1-EricCartman/racoon.ogg")
	--Audio.sounds[48].sfx = Audio.SfxOpen("costumes/mario/SP-1-EricCartman/yoshi.ogg")
	Audio.sounds[49].sfx = Audio.SfxOpen("costumes/mario/SP-1-EricCartman/yoshi-hurt.ogg")
	Audio.sounds[52].sfx = Audio.SfxOpen("costumes/mario/SP-1-EricCartman/got-star.ogg")
	
	Defines.player_walkspeed = 2
	Defines.player_runspeed = 5
	Defines.jumpheight = 17
	Defines.jumpheight_bounce = 22
end

function costume.onCleanup(p)
	-- Remove the player from the list
	if costume.playerData[p] ~= nil then
		Audio.sounds[1].sfx  = nil
		Audio.sounds[5].sfx  = nil
		Audio.sounds[6].sfx  = nil
		Audio.sounds[8].sfx  = nil
		Audio.sounds[15].sfx = nil
		Audio.sounds[31].sfx = nil
		Audio.sounds[34].sfx = nil
		Audio.sounds[52].sfx = nil
		Defines.jumpheight = 20
		Defines.player_walkspeed = 3
		Defines.player_runspeed = 6
		Defines.jumpheight_bounce = 32
		Defines.player_grav = 0.4
		costume.playerData[p] = nil
	end
end

return costume;