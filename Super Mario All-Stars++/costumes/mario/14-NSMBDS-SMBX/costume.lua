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
	Audio.sounds[1].sfx  = Audio.SfxOpen("costumes/mario/14-NSMBDS-SMBX/player-jump.ogg")
	Audio.sounds[2].sfx  = Audio.SfxOpen("costumes/mario/14-NSMBDS-SMBX/stomped.ogg")
	Audio.sounds[3].sfx  = Audio.SfxOpen("costumes/mario/14-NSMBDS-SMBX/block-hit.ogg")
	Audio.sounds[4].sfx  = Audio.SfxOpen("costumes/mario/14-NSMBDS-SMBX/block-smash.ogg")
	Audio.sounds[5].sfx  = Audio.SfxOpen("costumes/mario/14-NSMBDS-SMBX/player-shrink.ogg")
	Audio.sounds[6].sfx  = Audio.SfxOpen("costumes/mario/14-NSMBDS-SMBX/player-grow.ogg")
	Audio.sounds[7].sfx  = Audio.SfxOpen("costumes/mario/14-NSMBDS-SMBX/mushroom.ogg")
	Audio.sounds[8].sfx  = Audio.SfxOpen("costumes/mario/14-NSMBDS-SMBX/player-died.ogg")
	Audio.sounds[9].sfx  = Audio.SfxOpen("costumes/mario/14-NSMBDS-SMBX/shell-hit.ogg")
	Audio.sounds[10].sfx = Audio.SfxOpen("costumes/mario/14-NSMBDS-SMBX/player-slide.ogg")
	Audio.sounds[11].sfx = Audio.SfxOpen("costumes/mario/14-NSMBDS-SMBX/item-dropped.ogg")
	Audio.sounds[12].sfx = Audio.SfxOpen("costumes/mario/14-NSMBDS-SMBX/has-item.ogg")
	Audio.sounds[13].sfx = Audio.SfxOpen("costumes/mario/14-NSMBDS-SMBX/camera-change.ogg")
	Audio.sounds[14].sfx = Audio.SfxOpen("costumes/mario/14-NSMBDS-SMBX/coin.ogg")
	Audio.sounds[15].sfx = Audio.SfxOpen("costumes/mario/14-NSMBDS-SMBX/1up.ogg")
	--Audio.sounds[16].sfx = Audio.SfxOpen("costumes/mario/14-NSMBDS-SMBX/lava.ogg")
	Audio.sounds[17].sfx = Audio.SfxOpen("costumes/mario/14-NSMBDS-SMBX/warp.ogg")
	Audio.sounds[18].sfx = Audio.SfxOpen("costumes/mario/14-NSMBDS-SMBX/fireball.ogg")
	Audio.sounds[19].sfx = Audio.SfxOpen("costumes/mario/14-NSMBDS-SMBX/level-win.ogg")
	Audio.sounds[20].sfx = Audio.SfxOpen("costumes/mario/14-NSMBDS-SMBX/boss-beat.ogg")
	Audio.sounds[21].sfx = Audio.SfxOpen("costumes/mario/14-NSMBDS-SMBX/dungeon-win.ogg")
	Audio.sounds[22].sfx = Audio.SfxOpen("costumes/mario/14-NSMBDS-SMBX/bullet-bill.ogg")
	Audio.sounds[23].sfx = Audio.SfxOpen("costumes/mario/14-NSMBDS-SMBX/grab.ogg")
	Audio.sounds[24].sfx = Audio.SfxOpen("costumes/mario/14-NSMBDS-SMBX/spring.ogg")
	Audio.sounds[25].sfx = Audio.SfxOpen("costumes/mario/14-NSMBDS-SMBX/hammer.ogg")
	--Audio.sounds[29].sfx = Audio.SfxOpen("costumes/mario/14-NSMBDS-SMBX/do.ogg")
	Audio.sounds[31].sfx = Audio.SfxOpen("costumes/mario/14-NSMBDS-SMBX/key.ogg")
	--Audio.sounds[32].sfx = Audio.SfxOpen("costumes/mario/14-NSMBDS-SMBX/pswitch.ogg")
	Audio.sounds[33].sfx = Audio.SfxOpen("costumes/mario/14-NSMBDS-SMBX/tail.ogg")
	Audio.sounds[34].sfx = Audio.SfxOpen("costumes/mario/14-NSMBDS-SMBX/racoon.ogg")
	Audio.sounds[35].sfx = Audio.SfxOpen("costumes/mario/14-NSMBDS-SMBX/boot.ogg")
	--Audio.sounds[36].sfx = Audio.SfxOpen("costumes/mario/14-NSMBDS-SMBX/smash.ogg")
	--Audio.sounds[37].sfx = Audio.SfxOpen("costumes/mario/14-NSMBDS-SMBX/thwomp.ogg")
	--Audio.sounds[42].sfx = Audio.SfxOpen("costumes/mario/14-NSMBDS-SMBX/npc-fireball.ogg")
	--Audio.sounds[43].sfx = Audio.SfxOpen("costumes/mario/14-NSMBDS-SMBX/fireworks.ogg")
	--Audio.sounds[44].sfx = Audio.SfxOpen("costumes/mario/14-NSMBDS-SMBX/bowser-killed.ogg")
	Audio.sounds[46].sfx = Audio.SfxOpen("costumes/mario/14-NSMBDS-SMBX/door.ogg")
	--Audio.sounds[48].sfx = Audio.SfxOpen("costumes/mario/14-NSMBDS-SMBX/yoshi.ogg")
	--Audio.sounds[49].sfx = Audio.SfxOpen("costumes/mario/14-NSMBDS-SMBX/yoshi-hurt.ogg")
	--Audio.sounds[50].sfx = Audio.SfxOpen("costumes/mario/14-NSMBDS-SMBX/yoshi-tongue.ogg")
	--Audio.sounds[51].sfx = Audio.SfxOpen("costumes/mario/14-NSMBDS-SMBX/yoshi-egg.ogg")
	Audio.sounds[52].sfx = Audio.SfxOpen("costumes/mario/14-NSMBDS-SMBX/star-get.ogg")
	Audio.sounds[54].sfx = Audio.SfxOpen("costumes/mario/14-NSMBDS-SMBX/player-died2.ogg")
	--Audio.sounds[55].sfx = Audio.SfxOpen("costumes/mario/14-NSMBDS-SMBX/yoshi-swallow.ogg")
	Audio.sounds[57].sfx = Audio.SfxOpen("costumes/mario/14-NSMBDS-SMBX/dry-bones.ogg")
	Audio.sounds[58].sfx = Audio.SfxOpen("costumes/mario/14-NSMBDS-SMBX/smw-checkpoint.ogg")
	Audio.sounds[59].sfx = Audio.SfxOpen("costumes/mario/14-NSMBDS-SMBX/dragon-coin.ogg")
	--Audio.sounds[61].sfx = Audio.SfxOpen("costumes/mario/14-NSMBDS-SMBX/smw-blaarg.ogg")
	--Audio.sounds[62].sfx = Audio.SfxOpen("costumes/mario/14-NSMBDS-SMBX/wart-bubble.ogg")
	--Audio.sounds[63].sfx = Audio.SfxOpen("costumes/mario/14-NSMBDS-SMBX/wart-die.ogg")
	Audio.sounds[71].sfx = Audio.SfxOpen("costumes/mario/14-NSMBDS-SMBX/climbing.ogg")
	Audio.sounds[72].sfx = Audio.SfxOpen("costumes/mario/14-NSMBDS-SMBX/swim.ogg")
	Audio.sounds[73].sfx = Audio.SfxOpen("costumes/mario/14-NSMBDS-SMBX/grab2.ogg")
	Audio.sounds[74].sfx = Audio.SfxOpen("costumes/mario/14-NSMBDS-SMBX/saw.ogg")
	--Audio.sounds[75].sfx = Audio.SfxOpen("costumes/mario/14-NSMBDS-SMBX/smb2-throw.ogg")
	--Audio.sounds[76].sfx = Audio.SfxOpen("costumes/mario/14-NSMBDS-SMBX/smb2-hit.ogg")
	--Audio.sounds[91].sfx = Audio.SfxOpen("costumes/mario/14-NSMBDS-SMBX/bubble.ogg")
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
		Audio.sounds[42].sfx = nil
		Audio.sounds[43].sfx = nil
		Audio.sounds[44].sfx = nil
		Audio.sounds[46].sfx = nil
		Audio.sounds[48].sfx = nil
		Audio.sounds[49].sfx = nil
		Audio.sounds[50].sfx = nil
		Audio.sounds[51].sfx = nil
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