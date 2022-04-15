--Princess Rinka
--v1.1.0
--Created by Horikawa Otane, 2015 (Edited by Spencer Everly, 2022)
--...Shit. What are you doing here. GO AWAY.

local rng = require("rng")
local colliders = require("colliders")

local costume = {}
GameData.friendlyArea = false

local rinkaCounter = 0
local hasDied = false
local displayText = true
local hasBeenActivated
local nextRinka = 1000

function costume.onInit(p)
	registerEvent(costume, "onTick")
	registerEvent(costume, "onStart")
	costume.abilitiesenabled = true
end

function costume.onCleanup(p)
	costume.abilitiesenabled = false
end

function costume.onTick()
	if costume.abilitiesenabled == true then
		player:mem(0x0A, FIELD_BOOL, true)
		if GameData.friendlyArea == false then
			if player.powerup > 1 then
				player:mem(0x16, FIELD_WORD, 2)
			end
			for _, v in pairs(NPC.get(player.powerup, player.section)) do
				if colliders.collide(player, v) then
					NPC.spawn(211, v.x, v.y, player.section)
				end
			end
			--for _, v in pairs(NPC.get(192, player.section)) do
				--v:kill()
			--end
			--if (player:mem(0x13C, FIELD_DWORD) ~= 0 or player:mem(0x122, FIELD_WORD) == 227 or player:mem(0x122, FIELD_WORD) == 2) and not hasDied then
				--player:kill()
				--hasDied = true
			--end
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

return costume