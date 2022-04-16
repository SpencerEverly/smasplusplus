--Costume music change v3.0
function changeMusic(character, costume)
	Audio.MusicChange(player.section, -- derive new music based on char and costume
end

local lastCharacter
local lastCostume

function onStart()
	lastCharacter = player.character
	lastCostume = player:getCostume()
end

function onLoadSection()
	changeMusic(lastCharacter, lastCostume)
end

function onTick()
	local newCharacter, newCostume = player.character, player:getCostume()
	if lastCharacter ~= newCharacter or lastCostume ~= newCostume then
		changeMusic(newCharacter, newCostume)
	end
	
	lastCharacter = newCharacter
	lastCostume = newCostume 
end

--Moving images on a loop
local x = 0
function onDraw()
	x = x + 1
	Graphics.drawImage(MYIMG, x, 0)
end