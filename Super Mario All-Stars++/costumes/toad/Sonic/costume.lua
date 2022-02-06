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

--function costume.onStart()
  --Audio.playSFX("costumes/mario/1-SMB1-Retro/mario-letsago.ogg")
--if player:mem(0x13e, FIELD_WORD) > 0 then return false end
--if player:mem(0x122, FIELD_WORD) > 0 then return false end
--if player:mem(0x108, FIELD_WORD) > 0 then return false end

--end

function costume.onTickEnd()
	for _,p in ipairs(costume.playersList) do
		local data = costume.playerData[p]
	end
end
	
function costume.onTick() --WIP
	Audio.sounds[1].sfx  = Audio.SfxOpen("costumes/toad/Sonic/player-jump.ogg")
	Audio.sounds[2].sfx  = Audio.SfxOpen("costumes/toad/Sonic/stomped.ogg")
	Audio.sounds[3].sfx  = Audio.SfxOpen("costumes/toad/Sonic/block-hit.ogg")
	Audio.sounds[5].sfx  = Audio.SfxOpen("costumes/toad/Sonic/player-shrink.ogg")
	Audio.sounds[6].sfx  = Audio.SfxOpen("costumes/toad/Sonic/player-grow.ogg")
	Audio.sounds[7].sfx  = Audio.SfxOpen("costumes/toad/Sonic/mushroom.ogg")
	Audio.sounds[8].sfx  = Audio.SfxOpen("costumes/toad/Sonic/player-died.ogg")
	Audio.sounds[9].sfx  = Audio.SfxOpen("costumes/toad/Sonic/shell-hit.ogg")
	Audio.sounds[10].sfx = Audio.SfxOpen("costumes/toad/Sonic/player-slide.ogg")
	Audio.sounds[14].sfx = Audio.SfxOpen("costumes/toad/Sonic/coin.ogg")
	Audio.sounds[15].sfx = Audio.SfxOpen("costumes/toad/Sonic/1up.ogg")
	Audio.sounds[17].sfx = Audio.SfxOpen("costumes/toad/Sonic/warp.ogg")
	Audio.sounds[18].sfx = Audio.SfxOpen("costumes/toad/Sonic/fireball.ogg")
	Audio.sounds[23].sfx = Audio.SfxOpen("costumes/toad/Sonic/grab.ogg")
	Audio.sounds[24].sfx = Audio.SfxOpen("costumes/toad/Sonic/spring.ogg")
	Audio.sounds[29].sfx = Audio.SfxOpen("costumes/toad/Sonic/do.ogg")
	Audio.sounds[31].sfx = Audio.SfxOpen("costumes/toad/Sonic/key.ogg")
	Audio.sounds[32].sfx = Audio.SfxOpen("costumes/toad/Sonic/pswitch.ogg")
	Audio.sounds[33].sfx = Audio.SfxOpen("costumes/toad/Sonic/tail.ogg")
	Audio.sounds[52].sfx = Audio.SfxOpen("costumes/toad/Sonic/got-star.ogg")
	Audio.sounds[54].sfx = Audio.SfxOpen("costumes/toad/Sonic/player-died2.ogg")
	Audio.sounds[58].sfx = Audio.SfxOpen("costumes/toad/Sonic/smw-checkpoint.ogg")
	Audio.sounds[59].sfx = Audio.SfxOpen("costumes/toad/Sonic/dragon-coin.ogg")
	Audio.sounds[71].sfx = Audio.SfxOpen("costumes/toad/Sonic/climbing.ogg")
	Audio.sounds[72].sfx = Audio.SfxOpen("costumes/toad/Sonic/swim.ogg")
	Audio.sounds[73].sfx = Audio.SfxOpen("costumes/toad/Sonic/grab2.ogg")
	Audio.sounds[75].sfx = Audio.SfxOpen("costumes/toad/Sonic/smb2-throw.ogg")
	Audio.sounds[76].sfx = Audio.SfxOpen("costumes/toad/Sonic/smb2-hit.ogg")
	
	--Sonic settings! This is useful for accuracy.
	Defines.player_walkspeed = 9
	Defines.player_runspeed = 9
	Defines.jumpheight = 25
	Defines.jumpheight_bounce = 31
	Defines.projectilespeedx = 12
	Defines.player_grav = 0.5
	--player:mem(0x160,FIELD_WORD,5) --Fireballs are now less delayed!


	--Here's some coin reset stuff for when Sonic gets hurt, cause why not... wip
	--if(not hurt and player:mem(0x122,FIELD_WORD,2) or player:mem(0x122,FIELD_WORD,227) or player:mem(0x122,FIELD_WORD,228)) then
	--	hurt = true
	--	Defines.coinValue = 0
	--end
	
	--Spin dash stuff, will be ommited until it's implemented
	--if(not ducking and player:mem(0x12E,FIELD_BOOL)) then
		--ducking = true
		--
end

function costume.onCleanup(p)
	-- Remove the player from the list
	if costume.playerData[p] ~= nil then
		Audio.sounds[1].sfx  = nil
		Audio.sounds[2].sfx  = nil
		Audio.sounds[3].sfx  = nil
		Audio.sounds[4].sfx  = nil
		Audio.sounds[5].sfx  = nil
		Audio.sounds[6].sfx  = nil
		Audio.sounds[7].sfx  = nil
		Audio.sounds[8].sfx  = nil
		Audio.sounds[9].sfx  = nil
		Audio.sounds[10].sfx = nil
		Audio.sounds[11].sfx = nil
		Audio.sounds[12].sfx = nil
		Audio.sounds[13].sfx = nil
		Audio.sounds[14].sfx = nil
		Audio.sounds[15].sfx = nil
		Audio.sounds[16].sfx = nil
		Audio.sounds[17].sfx = nil
		Audio.sounds[18].sfx = nil
		Audio.sounds[19].sfx = nil
		Audio.sounds[20].sfx = nil
		Audio.sounds[21].sfx = nil
		Audio.sounds[22].sfx = nil
		Audio.sounds[23].sfx = nil
		Audio.sounds[24].sfx = nil
		Audio.sounds[25].sfx = nil
		Audio.sounds[29].sfx = nil
		Audio.sounds[31].sfx = nil
		Audio.sounds[32].sfx = nil
		Audio.sounds[33].sfx = nil
		Audio.sounds[34].sfx = nil
		Audio.sounds[35].sfx = nil
		Audio.sounds[36].sfx = nil
		Audio.sounds[37].sfx = nil
		Audio.sounds[38].sfx = nil
		Audio.sounds[39].sfx = nil
		Audio.sounds[41].sfx = nil
		Audio.sounds[42].sfx = nil
		Audio.sounds[43].sfx = nil
		Audio.sounds[44].sfx = nil
		Audio.sounds[46].sfx = nil
		Audio.sounds[47].sfx = nil
		Audio.sounds[48].sfx = nil
		Audio.sounds[49].sfx = nil
		Audio.sounds[50].sfx = nil
		Audio.sounds[51].sfx = nil
		Audio.sounds[52].sfx = nil
		Audio.sounds[54].sfx = nil
		Audio.sounds[55].sfx = nil
		Audio.sounds[56].sfx = nil
		Audio.sounds[57].sfx = nil
		Audio.sounds[58].sfx = nil
		Audio.sounds[59].sfx = nil
		Audio.sounds[61].sfx = nil
		Audio.sounds[62].sfx = nil
		Audio.sounds[63].sfx = nil
		Audio.sounds[71].sfx = nil
		Audio.sounds[72].sfx = nil
		Audio.sounds[73].sfx = nil
		--Audio.sounds[74].sfx = nil
		Audio.sounds[75].sfx = nil
		Audio.sounds[76].sfx = nil
		Audio.sounds[77].sfx = nil
		Audio.sounds[78].sfx = nil
		Audio.sounds[79].sfx = nil
		Audio.sounds[80].sfx = nil
		Audio.sounds[81].sfx = nil
		Audio.sounds[82].sfx = nil
		Audio.sounds[91].sfx = nil
		
		Defines.jumpheight = 20
		Defines.player_walkspeed = 3
		Defines.player_runspeed = 6
		Defines.jumpheight_bounce = 32
		Defines.projectilespeedx = 7.1
		Defines.player_grav = 0.4
		
		costume.playerData[p] = nil
	end
end

return costume;