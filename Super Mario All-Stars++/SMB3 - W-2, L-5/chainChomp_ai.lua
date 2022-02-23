--[[

	Written by MrDoubleA
	Please give credit!

	Part of MrDoubleA's NPC Pack

]]

-- Note: these are very janky

local expandedDefines = require("expandeddefines")
local npcManager = require("npcManager")
local colliders = require("colliders")
local imagic = require("imagic")



chainChomp = {}

chainChomp.chompIDs = {}
chainChomp.looseIDs = {}



function chainChomp.registerChomp(id)
    npcManager.registerEvent(id,chainChomp,"onTickEndNPC","onTickEndChomp")
	npcManager.registerEvent(id,chainChomp,"onDrawNPC")
    chainChomp.chompIDs[id] = true
end

function chainChomp.registerLoose(id)
    npcManager.registerEvent(id,chainChomp,"onTickEndNPC","onTickEndLoose")
	npcManager.registerEvent(id,chainChomp,"onDrawNPC")
    chainChomp.looseIDs[id] = true
end



-- Used for drawing chains

local function drawFrame(id,x,y,frame)
	local config = NPC.config[id]
	local priority
	if config.priority then
		priority = -16
	else
		priority = -46
	end
	imagic.Draw{
		texture = Graphics.sprites.npc[id].img,
		x = x,y = y,
		width = config.gfxwidth,height = config.gfxheight,
		sourceWidth = config.gfxwidth,sourceHeight = config.gfxheight,
		sourceX = 0,sourceY = (frame or 0) * config.gfxheight,
		priority = priority,align = imagic.ALIGN_CENTRE,scene = true,
	}
end



-- Logic for the individual chains below

local tempCollider = colliders.Box(0,0,0,0) -- A temporary collider which isn't attached to anything specific, so we don't have to make a new one every frame
local function chainLogic(v,k,c)
	local config = NPC.config[v.id]
	local data = v.data

	if data.lungeTimer and data.lungeTimer > 32 then
		local direction = math.atan2(
			(v:mem(0xB0,FIELD_DFLOAT)+(v:mem(0xB8,FIELD_DFLOAT)/2)) - (v.y+(v.height/2)),
			(v:mem(0xA8,FIELD_DFLOAT)+(v:mem(0xC0,FIELD_DFLOAT)/2)) - (v.x+(v.width /2))
		)
		local distance = math.abs((v.x+(v.width/2))-(v:mem(0xA8,FIELD_DFLOAT)+(v:mem(0xC0,FIELD_DFLOAT)/2))) + math.abs((v.y+(v.height/2))-(v:mem(0xB0,FIELD_DFLOAT)+(v:mem(0xB8,FIELD_DFLOAT)/2)))

		c.x = (v:mem(0xA8,FIELD_DFLOAT)+(v:mem(0xC0,FIELD_DFLOAT)/2)) - (math.cos(direction) * (distance*(k/(config.chains+1))))
		c.y = (v:mem(0xB0,FIELD_DFLOAT)+(v:mem(0xB8,FIELD_DFLOAT)/2)) - (math.sin(direction) * (distance*(k/(config.chains+1))))
	else
		c.speedY = c.speedY + Defines.npc_grav
		c.y = c.y + c.speedY

		c.collider.x = c.x-(config.chainWidth /2)
		c.collider.y = c.y-(config.chainHeight/2)
		if #colliders.getColliding{a = c.collider,b = Block.SOLID,btype = colliders.BLOCK} > 0 then
			c.y = c.y - c.speedY
			c.speedY = 0
		end

        local priorPosition = data.priorPositions[(config.chains-(k-1))*2]
		if priorPosition and math.abs(c.x-priorPosition.x) > ((config.chains-(k-1))*4) then
			if c.x > priorPosition.x then
				c.x = c.x - (((k/(config.chains+1))*1.5)*config.speed)
				if c.x < priorPosition.x then
					c.x = priorPosition.x
				end
			elseif c.x < priorPosition.x then
				c.x = c.x + (((k/(config.chains+1))*1.5)*config.speed)
				if c.x > priorPosition.x then
					c.x = priorPosition.x
				end
			end
        end

		-- Restrict the chain
		local direction = math.atan2(
			(v:mem(0xB0,FIELD_DFLOAT)+(v:mem(0xB8,FIELD_DFLOAT)/2)) - c.y,
			(v:mem(0xA8,FIELD_DFLOAT)+(v:mem(0xC0,FIELD_DFLOAT)/2)) - c.x
		)
		local distance = math.abs(c.x-(v:mem(0xA8,FIELD_DFLOAT)+(v:mem(0xC0,FIELD_DFLOAT)/2))) + math.abs(c.y-(v:mem(0xB0,FIELD_DFLOAT)+(v:mem(0xB8,FIELD_DFLOAT)/2)))

        local maxDistance = ((k/(config.chains+1))*config.maxDistance)
        if distance > maxDistance then
            tempCollider.x = ((v:mem(0xA8,FIELD_DFLOAT)+(v:mem(0xC0,FIELD_DFLOAT)/2)) - (math.cos(direction) * maxDistance)) - (config.chainWidth /2)
            tempCollider.y = ((v:mem(0xB0,FIELD_DFLOAT)+(v:mem(0xB8,FIELD_DFLOAT)/2)) - (math.sin(direction) * maxDistance)) - (config.chainHeight/2)
            tempCollider.width,tempCollider.height = config.chainWidth,config.chainHeight
            if #colliders.getColliding{a = c.collider,b = Block.SOLID,btype = colliders.BLOCK} == 0 then
                c.x = tempCollider.x + (tempCollider.width /2)
                c.y = tempCollider.y + (tempCollider.height/2)
            end
		end
	end
end

local function looseChainLogic(v,k,c)
    local config = NPC.config[v.id]
    local data = v.data

    local priorPosition = data.priorPositions[(config.chains-(k-1))*6]
    if priorPosition then
        c.x = priorPosition.x
        c.y = priorPosition.y - (config.chainHeight/2)
    end
end



-- Function to get the nearest player, but only if they're close enough for a lunge

local function nearestPlayer(x,y,minDistance)
	local c,cDX,cDY
	for _,v in ipairs(Player.get()) do
		local vDX,vDY = (v.x+(v.width/2))-x,(v.y+(v.height/2))-y

		if math.abs(vDX) + math.abs(vDY) <= minDistance and (not c or math.abs(vDX) + math.abs(vDY) < math.abs(cDX) + math.abs(cDY)) then
			c = v
			cDX,cDY = (c.x+(c.width / 2))-x,(c.y+(c.height/2))-y
		end
	end
	return c
end



-- Logic for NPCs

function chainChomp.onTickEndChomp(v)
	if Defines.levelFreeze then return end
	
	local data = v.data
	
	if v:mem(0x12A, FIELD_WORD) <= 0 then
		data.chains = nil
		data.lungeTimer = nil
		data.lungeDirection = nil

		data.lungeCount = nil

		data.priorPositions = nil
		return
	end

	local config = NPC.config[v.id]

	if not data.chains then
		data.chains = {}
		for i=1,config.chains do
			table.insert(
				data.chains,
				{
					x = (v.x+(v.width/2)),
					y = (v.y+v.height-(config.chainHeight/2)),
					speedY = 0,
					collider = colliders.Box(0,0,config.chainWidth,config.chainHeight)
				}
			)
		end

		data.priorPositions = {}
	end

	if v:mem(0x12C, FIELD_WORD) > 0    --Grabbed
	or v:mem(0x136, FIELD_BOOL)        --Thrown
	or v:mem(0x138, FIELD_WORD) > 0    --Contained within
	then
		data.chains = nil
		return
	end

	-- Calculate stuff
	local direction = math.atan2(
		(v:mem(0xB0,FIELD_DFLOAT)+(v:mem(0xB8,FIELD_DFLOAT)/2)) - (v.y+(v.height/2)),
		(v:mem(0xA8,FIELD_DFLOAT)+(v:mem(0xC0,FIELD_DFLOAT)/2)) - (v.x+(v.width /2))
	)
	local distanceX = ((v.x+(v.width /2))-(v:mem(0xA8,FIELD_DFLOAT)+(v:mem(0xC0,FIELD_DFLOAT)/2))) -- X distance from spawn
	local distanceY = ((v.y+(v.height/2))-(v:mem(0xB0,FIELD_DFLOAT)+(v:mem(0xB8,FIELD_DFLOAT)/2))) -- Y distance from spawn

	-- Restrict the chomp
	local maxDistance = (config.maxDistance-(math.abs(v.speedX*config.speed)+math.abs(v.speedY)))
	if (math.abs(distanceX) + math.abs(distanceY)) >= maxDistance then
		v.x = ((v:mem(0xA8,FIELD_DFLOAT)+(v:mem(0xC0,FIELD_DFLOAT)/2)) - (math.cos(direction) * maxDistance)) - (v.width /2)
		v.y = ((v:mem(0xB0,FIELD_DFLOAT)+(v:mem(0xB8,FIELD_DFLOAT)/2)) - (math.sin(direction) * maxDistance)) - (v.height/2)
	end

	if data.lungeTimer then
		-- Lunge
		data.lungeTimer = data.lungeTimer + 1

		v.animationFrame = math.floor(data.lungeTimer/(config.framespeed/2)) % config.frames
		if config.framestyle >= 1 and v.direction == DIR_RIGHT then
			v.animationFrame = v.animationFrame + config.frames
		end

		if data.lungeTimer > 128 and config.lungesToEscape and config.escapeID and data.lungeCount >= config.lungesToEscape then
			v:transform(config.escapeID,true,false)

			data.priorPositions = {}
			data.chains = nil
		elseif data.lungeTimer > 128 then
			data.lungeTimer,data.lungeDirection = nil,nil
			v.speedX = 0
			v.speedY = -Defines.npc_grav
		elseif data.lungeTimer > 32 then
			v.speedX = (-math.cos(data.lungeDirection) * 12)
			v.speedY = ((-math.sin(data.lungeDirection) * 12)*config.speed) - Defines.npc_grav
		end
	elseif v.collidesBlockBottom then
		-- Roaming around post

		local lungeTarget = nearestPlayer(v.x+(v.width/2),v.y+(v.height/2),config.lungeDistance)

		if lungeTarget then
			-- Prepare for lunge
			v.speedX = 0
			data.lungeTimer = 0
			data.lungeDirection = math.atan2(
				(v.y+(v.height/2)) - (lungeTarget.y+(lungeTarget.height/2)),
				(v.x+(v.width /2)) - (lungeTarget.x+(lungeTarget.width /2))
			)
			if (v.x+(v.width /2)) > (lungeTarget.x+(lungeTarget.width/2)) then
				v.direction = DIR_LEFT
			else
				v.direction = DIR_RIGHT
			end

			data.priorPositions = {} -- Erase prior positions

			data.lungeCount = (data.lungeCount or 0) + 1
		else
			-- Hop
			if distanceX > config.roamDistance then
				v.direction = DIR_LEFT
			elseif distanceX < -config.roamDistance then
				v.direction = DIR_RIGHT
			end
			v.speedX = 1.5*v.direction
			v.speedY = -3
		end
	end

	-- Remember prior positions, for chain movement
	if not data.lungeTimer or data.lungeTimer <= 32 then
        table.insert(data.priorPositions,1,{x = v.x+(v.width/2),y = v.y+v.height})
        if data.priorPositions[(config.chains*6)+1] then
            table.remove(data.priorPositions,(config.chains*6)+1)
        end
	end

	-- Chain logic
	if data.chains then
		for k,c in ipairs(data.chains) do
			chainLogic(v,k,c)
		end
	end
end

function chainChomp.onTickEndLoose(v)
	if Defines.levelFreeze then return end
	
	local data = v.data
	
	if v:mem(0x12A, FIELD_WORD) <= 0 then
		data.chains = nil
		data.priorPositions = nil
		return
	end

	local config = NPC.config[v.id]

	if not data.chains then
		data.chains = {}
		for i=1,config.chains do
			table.insert(
				data.chains,
				{
					x = (v.x+(v.width/2)),
					y = (v.y+v.height-(config.chainHeight/2)),
				}
			)
		end

		data.priorPositions = {}
	end

	if v:mem(0x12C, FIELD_WORD) > 0    --Grabbed
	or v:mem(0x136, FIELD_BOOL)        --Thrown
	or v:mem(0x138, FIELD_WORD) > 0    --Contained within
	then
		data.chains = nil
		return
	end

    if v.collidesBlockBottom then
        v.speedX = 4*v.direction
        v.speedY = -(config.jumpHeight or 6)
    end

	-- Remember prior positions, for chain movement
    table.insert(data.priorPositions,1,{x = v.x+(v.width/2),y = v.y+v.height})
    if data.priorPositions[(config.chains*6)+1] then
        table.remove(data.priorPositions,(config.chains*6)+1)
    end

	-- Chain logic
	for k,c in ipairs(data.chains) do
		looseChainLogic(v,k,c)
	end
end

function chainChomp.onDrawNPC(v)
	local data = v.data
	if not data.chains then return end

	local config = NPC.config[v.id]
	local frame
	if config.framestyle == 1 then
		frame = config.frames*2
	elseif config.framestyle == 2 then
		frame = config.frames*4
	else
		frame = config.frames
	end

	for i,c in ipairs(data.chains) do
		drawFrame(v.id,c.x+config.gfxoffsetx,c.y+config.gfxoffsety,frame)
	end
end



return chainChomp