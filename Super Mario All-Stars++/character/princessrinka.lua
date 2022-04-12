--"princessRinka".lua
--v1.0.0
--Created by Horikawa Otane, 2015
--...Shit. What are you doing here. GO AWAY.
--Contact me at https://www.youtube.com/subscription_center?add_user=msotane

local rng = require("rng")
local colliders = require("colliders")
--local horikawaTools = require("horikawaTools")

local princessRinka = {}
princessRinka.friendlyArea = true

local rinkaCounter = 0
local hasDied = false
local displayText = true
local hasBeenActivated
local nextRinka = 1000

function princessRinka.onInitAPI()
	registerEvent(princessRinka, "onTick", "onTick", false)
	registerEvent(princessRinka, "onStart", "onStart", false)
end

function princessRinka.onStart()
end

function princessRinka.onTick()
	if player.character == CHARACTER_PRINCESSRINKA then
		for _, v in pairs(Block.getIntersecting(player.x - 32, player.y + player.height, player.x + player.width + 32, player.y + player.height + 2)) do
			v.slippery = true
		end
		if princessRinka.friendlyArea == false then
			if player.powerup > 1 then
				player:mem(0x16, FIELD_WORD, 2)
			end
			for _, v in pairs(NPC.get(player.powerup, player.section)) do
				if colliders.collide(player, v) then
					NPC.spawn(211, v.x, v.y, player.section)
				end
			end
			for _, v in pairs(NPC.get(192, player.section)) do
				v:kill()
			end
			if (player:mem(0x13C, FIELD_DWORD) ~= 0 or player:mem(0x122, FIELD_WORD) == 227 or player:mem(0x122, FIELD_WORD) == 2) and not hasDied then
				player:kill()
				hasDied = true
			end
			rinkaCounter = rinkaCounter + 1
			if rinkaCounter == (nextRinka - 140) then
				displayText = true
			elseif rinkaCounter > (nextRinka - 140) and rinkaCounter < nextRinka then
				if (math.min(rinkaCounter, 25) == 0) then
					displayText = not displayText
				end
				if displayText then
					Text.printWP("RINKA INCOMING", 274, 295,-4)
				end				
			elseif rinkaCounter == nextRinka then
				for i = 0, rng.randomInt(1, 6), 1 do
					local halfW = (player.width * 0.5)
					local halfH = (player.height * 0.5)
					local xDir = (rng.randomInt(0, 1) * 2 - 1)
					local yDir = (rng.randomInt(0, 1) * 2 - 1)
					local xOff = halfW + xDir * (halfW + rng.random(64, 128))
					local yOff = halfH + yDir * (halfH + rng.random(64, 128))
					NPC.spawn(210, player.x + xOff, player.y + yOff, player.section, false, true)
				end
				rinkaCounter = 0
				nextRinka = rng.randomInt(500, 1000)
			end
		end
	end
end

return princessRinka