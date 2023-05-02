local waterplus = {}
local npcManager = require("npcManager")


--Modification of the basegame "waternpcplus" script.
--A small bit of code taken from SetaYoshi's redstone pack in the pondJump function.


local tableinsert = table.insert
local waterIDs = {}
local split = string.split

function waterplus.onInitAPI()
    registerEvent(waterplus, "onStart")
end

--catch late registrations through npc-config
function waterplus.onStart()
    --someone please make an easier way to access a list of these
    for i=1, 1000 do
        if NPC.config[i].iswaternpc then
            tableinsert(waterIDs, i)
        end
    end
    if #waterIDs > 0 then
        registerEvent(waterplus, "onTickEnd")
    end
end

local function stopStart(v)
	local data = v.data
	data.swim = data.swim or 0
	if v.underwater then
		if v.ai5 == 0 then 
            v.ai5 = v.y
        end
		data.swim = data.swim + 1
		if data.swim > 102 then
			v.x = v.spawnX
		end
		if data.swim >= 132 then
			data.swim = 0
		else
			v.spawnX = v.x
		end
		if v.collidesBlockLeft or v.collidesBlockRight then
			v.direction = -v.direction
        end
		v.speedY = v.ai5 - v.y
	else
        v.ai5 = 0
		data.swim = 0
	end
end

local function swimJumpUp(v)
	local data = v.data
	
	--Initialize
	if not data.initialized then
		data.initialized = true
		v.ai4 = -1
	end
	
	data.swim = data.swim or 0
	data.turn = data.turn or 0
	if v.underwater then
		v.x = v.x + 2 * v.direction
		v.ai4 = 0
		if v.ai5 == 0 then 
            v.ai5 = v.y
        end
		if data.swim >= 0 then
			v.noblockcollision = false
		end
		data.swim = data.swim + 1
		
		--Make the NPC jump
		if data.swim >= 240 and data.swim <= 300 then
			v.y = v.y - 8
        elseif data.swim < 0 then
			if v.y >= v.spawnY then
				v.y = v.spawnY - 8
				data.swim = 0
			end
			v.y = v.y + 8
		else
			--Don't move up or down
			v.speedY = v.ai5 - v.y
		end
		if v.collidesBlockLeft or v.collidesBlockRight then
			v.direction = -v.direction
			v.x = v.x + 4 * v.direction
			data.turn = 0
		end
    else
		--Jump high if v.ai4 equals one, and set data.swim to make the npc go down when it lands
		v.noblockcollision = true
		if v.ai4 >= 0 then
			v.ai4 = v.ai4 + 1
		end
		if v.ai4 == 1 then
			data.swim = -500
			v.speedY = -12
		end
		if v.ai4 < 0 then
			v.spawnY = v.y
		end
    end
	
	--Don't move horizontally when data.swim is within certain ranges
	if data.swim < 0 or data.swim >= 224 then
		v.x = v.spawnX
	else
		v.spawnX = v.x
		
		if data.swim >= 0 and data.swim < 224 then
			--Timer for the npc turning
			data.turn = data.turn + 1
			if data.turn % 64 == 0 then
				v.direction = -v.direction
			end
		end
		
	end
end

local function dolphinShort(v)
	local data = v.data
	local settings = v.data._settings
	
	--Initialize
	if not data.initialized then
		data.initialized = true
		v.ai4 = -1
	end
	
	if v.underwater then
		v.ai4 = 0
		v.ai5 = v.ai5 - 1
		if v.ai5 <= 0 then
			v.y = v.y - 5
			if v.ai5 == 0 and settings.turns then
				v.direction = -v.direction
			end
		else
			v.y = v.y + 5
		end
	else
		v.ai5 = 8
		if v.ai4 >= 0 then
			v.ai4 = v.ai4 + 1
		end
		if v.ai4 == 1 then
			v.speedY = -settings.jumpHeight
		end
	end
end

local function dolphinLong(v)
	local data = v.data
	local settings = v.data._settings
	
	--Initialize
	if not data.initialized then
		data.initialized = true
		v.ai4 = -1
	end
	
	v.x = v.x + 2 * v.direction
	
	if v.underwater then
		v.ai4 = 0
		v.ai5 = v.ai5 - 1
		if v.ai5 <= 0 then
			v.y = v.y - 5
			if v.ai5 == 0 and settings.turns then
				v.direction = -v.direction
			end
		else
			v.y = v.y + 5
		end
	else
		v.ai5 = 8
		if v.ai4 >= 0 then
			v.ai4 = v.ai4 + 1
		end
		if v.ai4 == 1 then
			v.speedY = -settings.jumpHeight
		end
	end
end

local function bassChase(v)

	local data = v.data
	local plr = Player.getNearest(v.x + v.width/2, v.y + v.height)
	local jumpbox = Colliders.Box(v.x - (v.width * 2), v.y - (v.height) - 96, v.width * 4, 204)
	v.noblockcollision = true
	
	--If despawned
	if v.despawnTimer <= 0 then
		data.initialized = false
		data.timer = 40
		return
	end

	if v.ai5 == 0 then 
		v.ai5 = v.y
    end

	--Initialize
	if not data.initialized then
		data.initialized = true
		data.timer = data.timer or 0
		data.reduceSpeed = data.reduceSpeed or 3
		v.ai4  = -1
	end
	
	if v.underwater then
	
		--Cause the cheep cheep to jump
		if Colliders.collide(plr, jumpbox) and data.timer == 0 then
			data.timer = 1
		end
		
		--Set this timer to 0 when underwater, count up when not in water
		v.ai4 = 0
		
		--Count the timer up when at -32, this is so there can be a delay before it jumps back up.
		if data.timer < 0 and data.timer >= -32 then
			data.timer = data.timer + 1
		end
		
		--Follow player
		if data.timer <= 0 and data.timer >= -32 then
			--Don't move up or down
			v.speedY = v.ai5 - v.y
		elseif data.timer == 1 then
			v.speedY = -7.4
		elseif data.timer < 0 then
			if v.y >= v.spawnY then
				v.y = v.spawnY
				data.timer = -32
				v.y = v.y - 8
			end
			v.y = v.y + 8
		end
	else
		if v.ai4 >= 0 then
			v.ai4 = v.ai4 + 1
		end
		if v.ai4 == 1 then
			v.speedY = -3.5
		end
		if data.timer > 0 then
			data.timer = -500
		end
		if v.ai4 < 0 then
			v.spawnY = v.y
		end
	end
	
	if data.timer == 0 then
		if plr.x < v.x - 280 then
			if data.reduceSpeed >= -3 and data.reduceSpeed <= 3 then
				if v.direction == DIR_LEFT then
					data.reduceSpeed = data.reduceSpeed + 0.25
				else
					data.reduceSpeed = data.reduceSpeed - 0.25
				end
			end
		elseif plr.x > v.x + 280 then
			if data.reduceSpeed >= -3 and data.reduceSpeed <= 3 then
				if v.direction == DIR_LEFT then
					data.reduceSpeed = data.reduceSpeed - 0.25
				else
					data.reduceSpeed = data.reduceSpeed + 0.25
				end
			end
		else
			data.reduceSpeed = 3
		end
		v.x = v.x + data.reduceSpeed * v.direction
		if data.reduceSpeed == 0 then
			v.direction = -v.direction
		end
	elseif data.timer < 0 or data.timer > 0 then
		v.x = v.x + 3 * v.direction
	end
end

local function pondJump(v)

	--Set some things
	local data = v.data
	local settings = v.data._settings
	data.speedList = data._settings.moveNumbers or "0"
	v.noblockcollision = true
	
	--Set up a table based on what's in the lineEdit
	if data.speedList ~= "" and data.speedList ~= "0" then
		data.speedList = split(data.speedList, ",")
		for i = 1, #data.speedList do
			data.speedList[i] = tonumber(data.speedList[i])
		end
	else
		error("Please input at least one number in the 'Move Distance Per Jump' field.")
	end
	
	data.moveSpeed = data.moveSpeed or 1
	
	--If despawned
	if v.despawnTimer <= 0 then
		data.initialized = false
		data.waitTimer = -1
		data.countDelay = 0
		data.maximum = false
		return
	end

	--Initialize
	if not data.initialized then
		data.initialized = true
		data.waitTimer = data.waitTimer or -1
		--A dumb fix to an issue where it doesnt start at the right number in the extra settings table
		data.countDelay = data.countDelay or -1
		data.maximum = data.maximum or false
	end
	
	if v.underwater then
		if v.ai4 == 0 then
			if data.waitTimer <= 0 then
				v.spawnX = v.x
				v.spawnY = v.y
			end
			
			--Don't move at all
			if v.ai5 == 0 then 
				v.ai5 = v.y
			end
			v.y = v.spawnY + 16
			v.x = v.spawnX
			
			--Make invisible
			v.animationFrame = -1
			
			v.friendly = true
			data.waitTimer = data.waitTimer + 1
			if data.waitTimer >= 64 then
				v.ai4 = 1
			end
		else
			v.ai4 = v.ai4 + 1
			
			if #data.speedList == 1 and data.countDelay > -1 then
				data.countDelay = 1
			end
			
			if v.ai4 == 2 then
				if data.moveSpeed >= #data.speedList and data.countDelay > 0 then
					v.direction = -v.direction
					data.maximum = true
					data.countDelay = -1
				elseif data.moveSpeed <= 1 and data.countDelay > 0 then
					v.direction = -v.direction
					data.maximum = false
					data.countDelay = -1
				end
				
				data.countDelay = data.countDelay + 1
				
				--Begin to count up or down if data.count is set to true
				if data.countDelay > 0 then
					if not data.maximum then
						data.moveSpeed = data.moveSpeed + 1
					else
						data.moveSpeed = data.moveSpeed - 1
					end
				end
			elseif v.ai4 > 2 then
				--Start moving and become visible/able to kill
				v.friendly = false
				v.speedY = -8
				v.x = v.x + data.speedList[data.moveSpeed] * v.direction
			end
		end
	else
		--Keep moving at a speed when out of water
		data.count = true
		v.ai4 = 0
		if data.waitTimer >= 0 then
			data.waitTimer = 0
			v.x = v.x + data.speedList[data.moveSpeed] * v.direction
		end
	end
end

local function floppy(v)
	local data = v.data
	local testblocks = Block.SOLID.. Block.PLAYER
	local sideBox = Colliders.Box(v.x, v.y, 128, v.height)
	local bottomBox = Colliders.Box(v.x, v.y + 8, v.width / 2, v.height)
	
	--Hitbox to detect ground
	if v.direction == DIR_RIGHT then
		sideBox.x = v.x
	else
		sideBox.x = v.x - 112
	end
	
	if v.underwater then
		v.ai4 = 0
		v.x = v.x + 2 * v.direction
		--Dont move up and down
		if v.ai5 == 0 then 
            v.ai5 = v.y
        end
		v.speedY = v.ai5 - v.y
		
		for k,block in ipairs(
			Colliders.getColliding{
			a = testblocks,
			b = sideBox,
			btype = Colliders.BLOCK
		}) do
			v.speedY = -7.5
		end
		
		--Turn at walls
		if v.collidesBlockLeft or v.collidesBlockRight then
			v.direction = -v.direction
			v.x = v.x + 4 * v.direction
			data.turn = 0
		end
	else
        v.ai5 = 0
		
		--Flop around when touching the ground out of water and slow down a bit
		for k,block in ipairs(
			Colliders.getColliding{
			a = testblocks,
			b = bottomBox,
			btype = Colliders.BLOCK
		}) do
			v.ai4 = 1
			v.speedY = -4
		end
		
		if v.ai4 == 0 then
			v.x = v.x + 2 * v.direction
		else
			v.x = v.x + v.direction
		end
	end
end

local exfuncs = {
	[8] = stopStart,
	[9] = swimJumpUp,
	[10] = dolphinShort,
	[11] = dolphinLong,
	[12] = bassChase,
	[13] = pondJump,
	[14] = floppy,
}

function waterplus.onTickEnd(v)
    for k,v in ipairs(NPC.get(waterIDs, Section.getActiveIndices())) do --npcmanager pls
        if Defines.levelFreeze then return end
        if v:mem(0x12A, FIELD_WORD) > 0 and v:mem(0x138, FIELD_WORD) == 0 and v:mem(0x136, FIELD_BOOL) == false and exfuncs[v.ai1] ~= nil then
            exfuncs[v.ai1](v)
        end
    end
end

return waterplus