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
	Audio.sounds[1].sfx  = Audio.SfxOpen("costumes/luigi/3-SMB1-Retro-Modern/player-jump.ogg")
	Audio.sounds[2].sfx  = Audio.SfxOpen("costumes/luigi/3-SMB1-Retro-Modern/stomped.ogg")
	Audio.sounds[3].sfx  = Audio.SfxOpen("costumes/luigi/3-SMB1-Retro-Modern/block-hit.ogg")
	Audio.sounds[4].sfx  = Audio.SfxOpen("costumes/luigi/3-SMB1-Retro-Modern/block-smash.ogg")
	Audio.sounds[5].sfx  = Audio.SfxOpen("costumes/luigi/3-SMB1-Retro-Modern/player-shrink.ogg")
	Audio.sounds[6].sfx  = Audio.SfxOpen("costumes/luigi/3-SMB1-Retro-Modern/player-grow.ogg")
	Audio.sounds[7].sfx  = Audio.SfxOpen("costumes/luigi/3-SMB1-Retro-Modern/mushroom.ogg")
	Audio.sounds[8].sfx  = Audio.SfxOpen("costumes/luigi/3-SMB1-Retro-Modern/player-died.ogg")
	Audio.sounds[9].sfx  = Audio.SfxOpen("costumes/luigi/3-SMB1-Retro-Modern/shell-hit.ogg")
	Audio.sounds[10].sfx = Audio.SfxOpen("costumes/luigi/3-SMB1-Retro-Modern/player-slide.ogg")
	Audio.sounds[11].sfx = Audio.SfxOpen("costumes/luigi/3-SMB1-Retro-Modern/item-dropped.ogg")
	Audio.sounds[12].sfx = Audio.SfxOpen("costumes/luigi/3-SMB1-Retro-Modern/has-item.ogg")
	Audio.sounds[13].sfx = Audio.SfxOpen("costumes/luigi/3-SMB1-Retro-Modern/camera-change.ogg")
	Audio.sounds[14].sfx = Audio.SfxOpen("costumes/luigi/3-SMB1-Retro-Modern/coin.ogg")
	Audio.sounds[15].sfx = Audio.SfxOpen("costumes/luigi/3-SMB1-Retro-Modern/1up.ogg")
	Audio.sounds[16].sfx = Audio.SfxOpen("costumes/luigi/3-SMB1-Retro-Modern/lava.ogg")
	Audio.sounds[17].sfx = Audio.SfxOpen("costumes/luigi/3-SMB1-Retro-Modern/warp.ogg")
	Audio.sounds[18].sfx = Audio.SfxOpen("costumes/luigi/3-SMB1-Retro-Modern/fireball.ogg")
	Audio.sounds[19].sfx = Audio.SfxOpen("costumes/luigi/3-SMB1-Retro-Modern/level-win.ogg")
	Audio.sounds[20].sfx = Audio.SfxOpen("costumes/luigi/3-SMB1-Retro-Modern/boss-beat.ogg")
	Audio.sounds[21].sfx = Audio.SfxOpen("costumes/luigi/3-SMB1-Retro-Modern/dungeon-win.ogg")
	Audio.sounds[22].sfx = Audio.SfxOpen("costumes/luigi/3-SMB1-Retro-Modern/bullet-bill.ogg")
	Audio.sounds[23].sfx = Audio.SfxOpen("costumes/luigi/3-SMB1-Retro-Modern/grab.ogg")
	Audio.sounds[24].sfx = Audio.SfxOpen("costumes/luigi/3-SMB1-Retro-Modern/spring.ogg")
	Audio.sounds[25].sfx = Audio.SfxOpen("costumes/luigi/3-SMB1-Retro-Modern/hammer.ogg")
	Audio.sounds[29].sfx = Audio.SfxOpen("costumes/luigi/3-SMB1-Retro-Modern/do.ogg")
	Audio.sounds[31].sfx = Audio.SfxOpen("costumes/luigi/3-SMB1-Retro-Modern/key.ogg")
	Audio.sounds[32].sfx = Audio.SfxOpen("costumes/luigi/3-SMB1-Retro-Modern/pswitch.ogg")
	Audio.sounds[33].sfx = Audio.SfxOpen("costumes/luigi/3-SMB1-Retro-Modern/tail.ogg")
	Audio.sounds[34].sfx = Audio.SfxOpen("costumes/luigi/3-SMB1-Retro-Modern/racoon.ogg")
	Audio.sounds[35].sfx = Audio.SfxOpen("costumes/luigi/3-SMB1-Retro-Modern/boot.ogg")
	Audio.sounds[36].sfx = Audio.SfxOpen("costumes/luigi/3-SMB1-Retro-Modern/smash.ogg")
	Audio.sounds[37].sfx = Audio.SfxOpen("costumes/luigi/3-SMB1-Retro-Modern/thwomp.ogg")
	Audio.sounds[38].sfx = Audio.SfxOpen("costumes/luigi/3-SMB1-Retro-Modern/birdo-spit.ogg")
	Audio.sounds[39].sfx = Audio.SfxOpen("costumes/luigi/3-SMB1-Retro-Modern/birdo-hit.ogg")
	Audio.sounds[41].sfx = Audio.SfxOpen("costumes/luigi/3-SMB1-Retro-Modern/birdo-beat.ogg")
	Audio.sounds[42].sfx = Audio.SfxOpen("costumes/luigi/3-SMB1-Retro-Modern/npc-fireball.ogg")
	Audio.sounds[43].sfx = Audio.SfxOpen("costumes/luigi/3-SMB1-Retro-Modern/fireworks.ogg")
	Audio.sounds[44].sfx = Audio.SfxOpen("costumes/luigi/3-SMB1-Retro-Modern/bowser-killed.ogg")
	Audio.sounds[46].sfx = Audio.SfxOpen("costumes/luigi/3-SMB1-Retro-Modern/door.ogg")
	Audio.sounds[47].sfx = Audio.SfxOpen("costumes/luigi/3-SMB1-Retro-Modern/message.ogg")
	Audio.sounds[48].sfx = Audio.SfxOpen("costumes/luigi/3-SMB1-Retro-Modern/yoshi.ogg")
	Audio.sounds[49].sfx = Audio.SfxOpen("costumes/luigi/3-SMB1-Retro-Modern/yoshi-hurt.ogg")
	Audio.sounds[50].sfx = Audio.SfxOpen("costumes/luigi/3-SMB1-Retro-Modern/yoshi-tongue.ogg")
	Audio.sounds[51].sfx = Audio.SfxOpen("costumes/luigi/3-SMB1-Retro-Modern/yoshi-egg.ogg")
	Audio.sounds[52].sfx = Audio.SfxOpen("costumes/luigi/3-SMB1-Retro-Modern/got-star.ogg")
	Audio.sounds[54].sfx = Audio.SfxOpen("costumes/luigi/3-SMB1-Retro-Modern/player-died2.ogg")
	Audio.sounds[55].sfx = Audio.SfxOpen("costumes/luigi/3-SMB1-Retro-Modern/yoshi-swallow.ogg")
	Audio.sounds[57].sfx = Audio.SfxOpen("costumes/luigi/3-SMB1-Retro-Modern/dry-bones.ogg")
	Audio.sounds[58].sfx = Audio.SfxOpen("costumes/luigi/3-SMB1-Retro-Modern/smw-checkpoint.ogg")
	Audio.sounds[59].sfx = Audio.SfxOpen("costumes/luigi/3-SMB1-Retro-Modern/dragon-coin.ogg")
	Audio.sounds[61].sfx = Audio.SfxOpen("costumes/luigi/3-SMB1-Retro-Modern/smw-blaarg.ogg")
	Audio.sounds[62].sfx = Audio.SfxOpen("costumes/luigi/3-SMB1-Retro-Modern/wart-bubble.ogg")
	Audio.sounds[63].sfx = Audio.SfxOpen("costumes/luigi/3-SMB1-Retro-Modern/wart-die.ogg")
	Audio.sounds[71].sfx = Audio.SfxOpen("costumes/luigi/3-SMB1-Retro-Modern/climbing.ogg")
	Audio.sounds[72].sfx = Audio.SfxOpen("costumes/luigi/3-SMB1-Retro-Modern/swim.ogg")
	Audio.sounds[73].sfx = Audio.SfxOpen("costumes/luigi/3-SMB1-Retro-Modern/grab2.ogg")
	--Audio.sounds[74].sfx = Audio.SfxOpen("costumes/luigi/3-SMB1-Retro-Modern/saw.ogg")
	Audio.sounds[75].sfx = Audio.SfxOpen("costumes/luigi/3-SMB1-Retro-Modern/smb2-throw.ogg")
	Audio.sounds[76].sfx = Audio.SfxOpen("costumes/luigi/3-SMB1-Retro-Modern/smb2-hit.ogg")
	Audio.sounds[91].sfx = Audio.SfxOpen("costumes/luigi/3-SMB1-Retro-Modern/bubble.ogg")
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
		costume.playerData[p] = nil
	end
end

return costume;