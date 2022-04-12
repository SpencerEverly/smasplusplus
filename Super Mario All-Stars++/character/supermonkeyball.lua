local masterX
local masterY

local supermonkeyball = {}

local function moveStuff(direction)
	local offset = 4
	for _, v in pairs(NPC.get()) do
		if direction == 1 then
			v.x = v.x - offset
		elseif direction == 2 then
			v.x = v.x + offset
		elseif direction == 3 then
			v.y = v.y - offset
		elseif direction == 4 then
			v.y = v.y + offset
		end
	end
	for _, v in pairs(BGO.get()) do
		if direction == 1 then
			v.x = v.x - offset
		elseif direction == 2 then
			v.x = v.x + offset
		elseif direction == 3 then
			v.y = v.y - offset
		elseif direction == 4 then
			v.y = v.y + offset
		end
	end

	for _, v in pairs(Block.get()) do
		if direction == 1 then
			if #Block.getIntersecting(player.x + player.width + offset + 1, player.y, player.x + player.width + offset + 2, player.y + player.height) == 0 then
				v.x = v.x - offset
			end
		elseif direction == 2 then
			if #Block.getIntersecting(player.x - offset - 1, player.y, player.x - offset - 2, player.y + player.height) == 0 then
				v.x = v.x + offset
			end
		elseif direction == 3 then
			if #Block.getIntersecting(player.x, player.y + player.height + offset + 1, player.x + player.width, player.y + player.height + offset + 2) == 0 then
				v.y = v.y - offset
			end
		elseif direction == 4 then
			if #Block.getIntersecting(player.x, player.y - offset - 1, player.x + player.width, player.y - offset - 2) == 0 then
				v.y = v.y + offset
			end
		end
	end
	for _, v in pairs(Warp.get()) do
		if direction == 1 then
			v.x = v.x - offset
			v.exitX = v.exitX - offset
			v.entranceX = v.entranceX - offset
		elseif direction == 2 then
			v.x = v.x + offset
			v.exitX = v.exitX + offset
			v.entranceX = v.entranceX + offset
		elseif direction == 3 then
			v.y = v.y - offset
			v.exitY = v.exitY - offset
			v.entranceY = v.entranceY - offset
		elseif direction == 4 then
			v.y = v.y + offset
			v.exitY = v.exitY + offset
			v.entranceY = v.entranceY + offset
		end
	end
end

function supermonkeyball.onInitAPI()
	registerEvent(supermonkeyball, "onInputUpdate", "onInputUpdate", false)
	registerEvent(supermonkeyball, "onLoop", "onLoop", false)
	registerEvent(supermonkeyball, "onLoadSection", "onLoadSection", false)
	registerEvent(supermonkeyball, "onStart", "onStart", false)
end

function supermonkeyball.onInputUpdate()
	if player.leftKeyPressing then
		moveStuff(1)
	end
	if player.rightKeyPressing then
		moveStuff(2)
	end
	if player.upKeyPressing then
		moveStuff(3)
	end
	if player.downKeyPressing then
		moveStuff(4)
	end
end

function supermonkeyball.onLoop()
	Defines.gravity = 0
	player.x = masterX
	player.y = masterY
end

function supermonkeyball.onLoadSection()
	masterX = player.x
	masterY = player.y
end

function supermonkeyball.onStart()
	masterX = player.x
	masterY = player.y
end

return supermonkeyball