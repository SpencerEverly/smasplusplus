--[[

	Written by MrDoubleA
	Please give credit!

	Credit to Saturnyoshi for starting to make "newplants" and creating most of the graphics used

	Part of MrDoubleA's NPC Pack

]]

local npcManager = require("npcManager")
local npcutils = require("npcs/npcutils")

local piranhaPlant = {}

piranhaPlant.idMap  = {}
piranhaPlant.idList = {}


local STATE_HIDE  = 0
local STATE_RISE  = 1
local STATE_REST  = 2
local STATE_LOWER = 3

local DIR_UP_LEFT    = DIR_LEFT
local DIR_DOWN_RIGHT = DIR_RIGHT


local function getInfo(v)
	local config = NPC.config[v.id]
	local data = v.data

	local settings = v.data._settings

	local configSettings = settings.config
	if not configSettings.override then
		configSettings = config
	end

	local fireSettings = settings.fire
	if not fireSettings or not fireSettings.override then
		fireSettings = config
	end

	return config,data,settings,configSettings,fireSettings
end
local function getDirectionInfo(v)
	if NPC.config[v.id].isHorizontal then
		return "x","spawnX","width" ,"speedX",  "gfxwidth" ,"sourceX","xOffset"
	else
		return "y","spawnY","height","speedY",  "gfxheight","sourceY","yOffset"
	end
end


local function move(v,distance)
	local config,data,settings,configSettings = getInfo(v)
	local position,spawnPosition,size,speed = getDirectionInfo(v)


	local tip = (v[position]+(v[size]/2))+((v[size]/2)*data.direction)

	tip = tip + (distance*data.direction)

	-- Make sure to keep the position in a valid range
	local upPosition = (data.home+(config[size]*data.direction))
	local downPosition = data.home

	if math.sign(downPosition-tip) == data.direction then
		tip = downPosition
	elseif math.sign(upPosition-tip) == -data.direction and not config.isJumping then
		tip = upPosition
	end


	-- Reapply the position
	if settings.changeSize then
		v[size] = math.min(math.abs(data.home-tip),config[size])
	end

	v[position] = tip-((v[size]/2)*data.direction)-(v[size]/2)
end

local function initialise(v)
	local config,data,settings,configSettings = getInfo(v)
	local position,spawnPosition,size,speed = getDirectionInfo(v)

	if v.spawnId > 0 then
		data.direction = v.spawnDirection
		data.home = (v[spawnPosition]+(v[size]/2))-((v[size]/2)*data.direction)
	else
		data.direction = v.direction
		data.home = v[position]-(v[size]*data.direction)
	end

	if not v.friendly then
		data.state = STATE_RISE
		move(v,-v[size])
	else
		data.state = STATE_REST
	end

	data.timer = 0
	data.animationTimer = 0

	data.jumpSpeed = nil -- Used by jumping piranha plants
end


local function canComeOut(v,direction,isHorizontal)
	local width,height
	if not isHorizontal then
		width,height = 32,300
	else
		width,height = 300,32
	end

	for _,playerObj in ipairs(Player.get()) do
		if  playerObj.deathTimer == 0 and not playerObj:mem(0x13C,FIELD_BOOL) -- If alive
		and (v.x) <= (playerObj.x+playerObj.width +width ) and (v.x+v.width ) >= (playerObj.x-width )
		and (v.y) <= (playerObj.y+playerObj.height+height) and (v.y+v.height) >= (playerObj.y-height)
		then
			return false
		end
	end

	return true
end

local function handleAnimation(v)
	local config,data,settings,configSettings = getInfo(v)

	data.animationTimer = data.animationTimer + 1


	local frame = math.floor(data.animationTimer/config.framespeed)

	if config.isVenusFlyTrap then
		frame = (frame%(config.frames/4))

		-- Face any nearby players
		local playerObj = npcutils.getNearestPlayer(v)

		if playerObj ~= nil then
			local distance = vector(
				(playerObj.x+(playerObj.width /2))-(v.x+(v.width /2)),
				(playerObj.y+(playerObj.height/2))-(v.y+(v.height/2))
			)

			if distance.x > 0 then
				frame = frame+(config.frames/2)
			end
			if distance.y < 0 then
				frame = frame+(config.frames/4)
			end
		end
	else
		frame = (frame%config.frames)
	end

	v.animationFrame = npcutils.getFrameByFramestyle(v,{frame = frame,direction = data.direction})
end
local function doFireSpurt(v,spurtNumber)
	local config,data,settings,configSettings,fireSettings = getInfo(v)
	local position,spawnPosition,size,speed = getDirectionInfo(v)


	if fireSettings.fireID == nil or settings.fireID == 0 then
		return
	end


	for index=-((fireSettings.firePerSpurt-1)/2),((fireSettings.firePerSpurt-1)/2) do
		index = index*2


		local spawnPosition = vector(v.x+(v.width/2),v.y+(v.height/2))
		spawnPosition[position] = spawnPosition[position]+((v[size]/4)*data.direction)


		local totalIndex = ((spurtNumber-1)*math.ceil(fireSettings.firePerSpurt/2))+math.abs(index)
		local angle = (fireSettings.fireAngle*totalIndex)*math.sign(index)

		local speed = vector(0,0)
		speed[position] = (fireSettings.fireSpeed*data.direction)
		speed = speed:rotate(angle)


		local fire = NPC.spawn(fireSettings.fireID,spawnPosition.x,spawnPosition.y,v.section,false,true)

		fire.speedX = speed.x
		fire.speedY = speed.y
	end
end


function piranhaPlant.registerPlant(id)
	npcManager.registerEvent(id,piranhaPlant,"onTickEndNPC")
	npcManager.registerEvent(id,piranhaPlant,"onDrawNPC")

    piranhaPlant.idMap[id] = true
    table.insert(piranhaPlant.idList,id)
end


function piranhaPlant.onTickEndNPC(v)
	if Defines.levelFreeze then return end

	local config,data,settings,configSettings,fireSettings = getInfo(v)
	local position,spawnPosition,size,speed = getDirectionInfo(v)

	
	if v.despawnTimer <= 0 then
		data.state = nil
		return
	end

	if not data.state then
		initialise(v)
	end

	if v:mem(0x136,FIELD_BOOL) then -- If in a projectile state, PANIC!
		v:kill(HARM_TYPE_NPC)
		return
	elseif v:mem(0x12C,FIELD_WORD) > 0 or v:mem(0x138,FIELD_WORD) > 0 then -- Held or in a forced state
		handleAnimation(v)
		return
	end

	
	if v.layerObj ~= nil and not Layer.isPaused() then
		v.x = v.x + v.layerObj.speedX
		v.y = v.y + v.layerObj.speedY
		data.home = data.home + v.layerObj[speed]
	end

	if data.state == STATE_HIDE then
		data.timer = data.timer + 1

		if data.timer > configSettings.hideTime and (canComeOut(v,data.direction,config.isHorizontal) or configSettings.ignorePlayers) then
			data.state = STATE_RISE
			data.timer = 0
		end
	elseif data.state == STATE_RISE then
		local tip = (v[position]+(v[size]/2))+((v[size]/2)*data.direction)
		local topPosition = data.home+(config[size]*data.direction)

		if tip == topPosition or (data.jumpSpeed and data.jumpSpeed < 0) then
			data.state = STATE_REST
			data.timer = 0

			data.jumpSpeed = nil
		else
			if config.isJumping then
				data.jumpSpeed = (data.jumpSpeed or (configSettings.movementSpeed*4))-(configSettings.movementSpeed*0.055)
				--Misc.dialog((configSettings.movementSpeed*0.59),Defines.npc_grav/3)
			end

			move(v,data.jumpSpeed or configSettings.movementSpeed)
		end
	elseif data.state == STATE_REST then
		if not v.friendly then
			data.timer = data.timer + 1

			if data.timer > configSettings.restTime and not v.friendly then
				data.state = STATE_LOWER
				data.timer = 0
			elseif fireSettings and fireSettings.fireID ~= nil and fireSettings.fireID ~= 0 then
				local totalFireLength = (fireSettings.fireSpurts*fireSettings.fireSpurtDelay)
				local startPoint = math.floor((configSettings.restTime/2)-((fireSettings.fireSpurts*fireSettings.fireSpurtDelay)/2))

				local currentSpurt = ((data.timer-startPoint)/math.max(1,fireSettings.fireSpurtDelay))+1

				if currentSpurt == math.floor(currentSpurt) and currentSpurt >= 1 and currentSpurt <= fireSettings.fireSpurts then
					doFireSpurt(v,currentSpurt)
				end
			end
		end
	elseif data.state == STATE_LOWER then
		local tip = (v[position]+(v[size]/2))+((v[size]/2)*data.direction)

		if tip == data.home then
			data.state = STATE_HIDE
			data.timer = 0

			data.jumpSpeed = nil
		else
			if config.isJumping then
				data.jumpSpeed = math.max(-configSettings.movementSpeed*0.5,(data.jumpSpeed or 0)-(configSettings.movementSpeed*0.0075))
			end

			move(v,data.jumpSpeed or -configSettings.movementSpeed)
		end
	end

	handleAnimation(v)

	--Colliders.Box(v.x,v.y,v.width,v.height):Draw(Color.red.. 0.25)
	--Colliders.Box(v.x,data.home,v.width,16):Draw(Color.purple.. 0.5)
end

function piranhaPlant.onDrawNPC(v)
	if v.despawnTimer <= 0 or v:mem(0x12C,FIELD_WORD) > 0 or v:mem(0x138,FIELD_WORD) > 0 then return end

	local config,data,settings,configSettings = getInfo(v)
	local position,spawnPosition,size,speed, gfxSize,sourcePosition,positionOffset = getDirectionInfo(v)

	if not data.state then
		initialise(v)
	end
	

	-- Determine priority
	local priority = -75
	if config.foreground then
		priority = -15
	end

	-- Determine how much of the image to show
	local graphicsSize,offset,source = config[gfxSize],0,0
	if settings.changeSize then
		local round = math.ceil
		if data.direction == DIR_DOWN_RIGHT then
			round = math.floor
		end

		local tip = (v[position]+(v[size]/2))+((v[size]/2)*data.direction)

		graphicsSize = math.min(math.abs(data.home-tip),graphicsSize)
		offset = round(-graphicsSize+config[size])

		source = offset*((data.direction+1)*0.5)

		if config.isHorizontal then
			offset = (offset/2)
		end
	end
	

	npcutils.drawNPC(v,{[positionOffset] = offset,[size] = graphicsSize,[sourcePosition] = source,priority = priority})
	npcutils.hideNPC(v)
end

return piranhaPlant