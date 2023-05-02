--[[

	Written by MrDoubleA
	Please give credit!

    Part of MrDoubleA's NPC Pack

]]

local npcManager = require("npcManager")
local npcutils = require("npcs/npcutils")

local lineguide = require("lineguide")

local swingingPlatform = {}


swingingPlatform.BEHAVIOUR_WEIGHTED     = 0
swingingPlatform.BEHAVIOUR_AUTO         = 1
swingingPlatform.BEHAVIOUR_BACKANDFORTH = 2


swingingPlatform.controllerIDList = {}
swingingPlatform.controllerIDMap  = {}

swingingPlatform.platformIDList = {}
swingingPlatform.platformIDMap  = {}


swingingPlatform.dontUseDontMoveIDMap = table.map{294,600,601,602,603}
swingingPlatform.wigglerIDMap = table.map{446,448}


local function getPlatformID(id,platformID)
    if platformID > 0 then
        return platformID
    else
        return NPC.config[id].defaultPlatformID
    end
end

local function getPlatformPosition(v,data,settings,platformIndex)
    local rotation = math.rad(data.rotation + ((platformIndex - 1) / settings.platformCount)*360)
    
    local x = (v.x + v.width *0.5 + math.sin(rotation)*settings.radius)
    local y = (v.y + v.height*0.5 - math.cos(rotation)*settings.radius)

    return x,y
end


local dontCausePauseForcedStates = table.map{FORCEDSTATE_NONE,FORCEDSTATE_PIPE,FORCEDSTATE_DOOR}

local function rotationIsPaused(v,data,config,settings)
    if swingingPlatform.wigglerIDMap[settings.platformID] then
        -- This platform has wigglers in it, so pause if one's turning angry
        for platformIndex = 1, data.platformCount do
            local platform = data.platforms[platformIndex]

            if platform ~= nil and platform.isValid and swingingPlatform.wigglerIDMap[platform.id] and platform.data._basegame.turningAngry then
                return true
            end
        end
    end


    for _,p in ipairs(Player.get()) do
        if not dontCausePauseForcedStates[p.forcedState] then
            return true
        end
    end

    return false
end


local function handlePlatform(v,data,config,settings, platformIndex)
    local platform = data.platforms[platformIndex]

    if platform == nil then
        return false
    end

    if not platform.isValid then
        return true
    end

    if platform.despawnTimer <= 0 then
        platform:kill(HARM_TYPE_VANISH)
        return true
    else
        platform.despawnTimer = math.max(100,platform.despawnTimer)
    end

    if platform:mem(0x12C,FIELD_WORD) > 0 then
        platform.noblockcollision = false
        return true
    end


    local platformConfig = NPC.config[platform.id]
    local x,y = getPlatformPosition(v,data,settings,platformIndex)

    local actualX = (x - platform.width *0.5)
    local actualY = (y - platform.height*0.5)

    if swingingPlatform.platformIDMap[platform.id] or (platformConfig.playerblocktop or platformConfig.playerblock) then
        platform.speedX = (actualX - platform.x)
        platform.speedY = (actualY - platform.y)

        if platform.id == 263 then
            platform.ai3 = 0
        end
        
        platform.dontMove = false
    else
        platform.x = actualX
        platform.y = actualY

        platform.speedX = 0
        platform.speedY = 0

        platform.spawnX = platform.x
        platform.spawnY = platform.y
        platform.spawnWidth = platform.width
        platform.spawnHeight = platform.height

        platform.dontMove = (not swingingPlatform.dontUseDontMoveIDMap[platform.id])
    end


    local platformLineguideData = platform.data._basegame.lineguide

    if platformLineguideData ~= nil then
        platformLineguideData.attachCooldown = 2
    end


    platform.noblockcollision = true


    return false
end



local function getPriority(v,config,defaultPriority)
    if v:mem(0x12C,FIELD_WORD) > 0 then
        return -30
    elseif config.foreground then
        return -15
    else
        return defaultPriority
    end
end

local function getWeightOnPlatforms(v,data) -- weighted
    local weight = 0

    for i = 1, data.platformCount do
        local platform = data.platforms[i]

        if platform ~= nil and platform.isValid then
            for _,p in ipairs(Player.get()) do
                if p.standingNPC == platform then
                    if platform.x+platform.width*0.5 < v.x+v.width*0.5-2 then
                        weight = weight - 1
                    else
                        weight = weight + 1
                    end
                end
            end
        end
    end

    return weight
end

local function getSideToTiltTo(v,data) -- back & forth
    local weight = 0

    for i = 1, data.platformCount do
        local platform = data.platforms[i]

        if platform ~= nil and platform.isValid then
            if platform.x+platform.width*0.5 < v.x+v.width*0.5-2 then
                weight = weight - 1
            else
                weight = weight + 1
            end
        end
    end

    return weight
end


local function initialisePreSpawnStuff(v)
    local config = NPC.config[v.id]
    local data = v.data
    local settings = v.data._settings


    local platformID = getPlatformID(v.id,settings.platformID)
    local platformConfig = NPC.config[platformID]
    
    local platformWidth  = platformConfig.width
    local platformHeight = platformConfig.height

    if swingingPlatform.platformIDMap[platformID] then
        platformWidth = platformWidth * settings.platformWidth
    end


    local width  = (settings.radius*2 + platformWidth )
    local height = (settings.radius*2 + platformHeight)

    data.spawnMinX = v.spawnX + v.spawnWidth *0.5 - width *0.5
    data.spawnMinY = v.spawnY + v.spawnHeight*0.5 - height*0.5
    data.spawnMaxX = v.spawnX + v.spawnWidth *0.5 + width *0.5
    data.spawnMaxY = v.spawnY + v.spawnHeight*0.5 + height*0.5

    -- Set section to allow the controller itself to be out of bounds
    v.section = Section.getIdxFromCoords(data.spawnMinX,data.spawnMinY,data.spawnMaxX - data.spawnMinX,data.spawnMaxY - data.spawnMinY)
end

local function initialise(v)
    local config = NPC.config[v.id]
    local data = v.data
    local settings = v.data._settings


    if data.spawnMinX == nil then
        initialisePreSpawnStuff(v)
    end

    data.initialized = true


    -- Spawn platforms
    local platformID = getPlatformID(v.id,settings.platformID)
    local platformConfig = NPC.config[platformID]

    data.rotation = settings.startingRotation
    data.rotationSpeed = 0

    data.platforms = {}
    data.platformCount = settings.platformCount

    for platformIndex = 1, data.platformCount do
        local x,y = getPlatformPosition(v,data,settings,platformIndex)

        local platform = NPC.spawn(platformID, x,y,v.section, false,true)

        if swingingPlatform.platformIDMap[platformID] then
            platform.width = platform.width * settings.platformWidth
            
            local platformData = platform.data
            platformData.width = settings.platformWidth
        end

        platform.x = (x - platform.width *0.5)
        platform.y = (y - platform.height*0.5)

        platform.direction = v.direction

        data.platforms[platformIndex] = platform
    end
end

local function deinitialise(v)
    local data = v.data

    data.initialized = false

    if data.platforms ~= nil then
        for platformIndex = 1, data.platformCount do
            local platform = data.platforms[platformIndex]

            if platform ~= nil and platform.isValid then
                platform:kill(HARM_TYPE_VANISH)
            end
        end
    end
end


function swingingPlatform.registerController(npcID)
    npcManager.registerEvent(npcID,swingingPlatform,"onTickNPC","onTickController")
    npcManager.registerEvent(npcID,swingingPlatform,"onDrawNPC","onDrawController")
    npcManager.registerEvent(npcID,swingingPlatform,"onCameraDrawNPC","onCameraDrawController")

    lineguide.registerNpcs(npcID)

    table.insert(swingingPlatform.controllerIDList,npcID)
    swingingPlatform.controllerIDMap[npcID] = true
end

function swingingPlatform.registerPlatform(npcID)
    npcManager.registerEvent(npcID,swingingPlatform,"onDrawNPC","onDrawPlatform")

    table.insert(swingingPlatform.platformIDList,npcID)
    swingingPlatform.platformIDMap[npcID] = true
end


function swingingPlatform.onTickController(v)
    if Defines.levelFreeze then return end
	
	local data = v.data
	
	if v.despawnTimer <= 0 then
        if data.initialized then
		    deinitialise(v)
        end

		return
	end

	if not data.initialized then
        initialise(v)
	end


    local config = NPC.config[v.id]
    local settings = v.data._settings

    local lineguideData = v.data._basegame.lineguide


    -- Some other behaviour
    npcutils.applyLayerMovement(v)

    if lineguideData ~= nil then
        if lineguideData.state == lineguide.states.FALLING then
            if v.underwater then
                v.speedY = math.min(1.6, v.speedY + Defines.npc_grav*0.2)
            else
                v.speedY = math.min(8, v.speedY + Defines.npc_grav)
            end
        end

        lineguideData.lineSpeed = settings.lineSpeed
    end


    -- Do rotation behaviour
    if not rotationIsPaused(v,data,config,settings) then
        local behaviour = config.rotationBehaviour

        if behaviour == swingingPlatform.BEHAVIOUR_WEIGHTED or behaviour == swingingPlatform.BEHAVIOUR_BACKANDFORTH then
            local weight
            if behaviour == swingingPlatform.BEHAVIOUR_WEIGHTED then
                weight = getWeightOnPlatforms(v,data)
            else
                weight = getSideToTiltTo(v,data)
            end


            if weight > 0 then
                data.rotationSpeed = math.min(settings.rotationMaxSpeed, data.rotationSpeed + settings.rotationAcceleration)
            elseif weight < 0 then
                data.rotationSpeed = math.max(-settings.rotationMaxSpeed, data.rotationSpeed - settings.rotationAcceleration)
            elseif data.rotationSpeed > 0 then
                data.rotationSpeed = math.max(0, data.rotationSpeed - settings.rotationAcceleration)
            elseif data.rotationSpeed < 0 then
                data.rotationSpeed = math.min(0, data.rotationSpeed + settings.rotationAcceleration)
            end
        elseif behaviour == swingingPlatform.BEHAVIOUR_AUTO then
            data.rotationSpeed = settings.rotationSpeed
        end

        data.rotation = data.rotation + data.rotationSpeed
    end


    for platformIndex = 1, data.platformCount do
        local shouldDelete = handlePlatform(v,data,config,settings, platformIndex)

        if shouldDelete then
            data.platforms[platformIndex] = nil
        end
    end
end


function swingingPlatform.onDrawController(v)
    if v.despawnTimer <= 0 or v.isHidden then return end


    local config = NPC.config[v.id]
    local data = v.data
    local settings = v.data._settings

    local lineguideData = v.data._basegame.lineguide


    if not data.initialized then
        initialise(v)
    end


    local image = Graphics.sprites.npc[v.id].img

    local jointLimit = math.ceil(settings.radius / math.min(config.gfxwidth,config.gfxheight))
    local sourceY = (v.animationFrame * config.gfxheight)

    local priority

    if lineguideData == nil or lineguideData.state == lineguide.states.NORMAL then
        priority = getPriority(v,config,-55) - 0.01
    else
        priority = getPriority(v,config,-45) - 0.01
    end

    for platformIndex = 1, data.platformCount do
        local platform = data.platforms[platformIndex]
        local platformX,platformY

        if platform ~= nil and platform.isValid then
            platformX = platform.x + platform.width *0.5
            platformY = platform.y + platform.height*0.5
        else
            platformX,platformY = getPlatformPosition(v,data,settings,platformIndex)
        end
        
        local jointStart = 1
        if platformIndex == 1 and settings.displayCentreJoint then
            jointStart = 0
        end


        for i = jointStart, jointLimit do
            local x = math.floor(math.lerp(v.x + v.width *0.5,platformX, i / jointLimit) - config.gfxwidth *0.5 + 0.5)
            local y = math.floor(math.lerp(v.y + v.height*0.5,platformY, i / jointLimit) - config.gfxheight*0.5 + 0.5)

            Graphics.drawImageToSceneWP(image,x,y,0,sourceY,config.gfxwidth,config.gfxheight,priority)
        end
    end

    npcutils.hideNPC(v)
end

function swingingPlatform.onCameraDrawController(v,camIdx)
    -- The spawning ranging is a bit bigger, so handle all that
    if v.isHidden then
        return
    end


    local data = v.data

	if data.spawnMinX == nil then
        initialisePreSpawnStuff(v)
	end


	local c = Camera(camIdx)

	if c.x+c.width > data.spawnMinX and c.y+c.height > data.spawnMinY and data.spawnMaxX > c.x and data.spawnMaxY > c.y then
		-- On camera, so activate (based on this  https://github.com/smbx/smbx-legacy-source/blob/master/modGraphics.bas#L517)
		local resetOffset = (0x126 + (camIdx - 1)*2)

		if v:mem(resetOffset, FIELD_BOOL) or v:mem(0x124,FIELD_BOOL) then
			if not v:mem(0x124,FIELD_BOOL) then
				v:mem(0x14C,FIELD_WORD,camIdx)
			end

			v.despawnTimer = 180
			v:mem(0x124,FIELD_BOOL,true)

            if not data.initialized then
                initialise(v)
            end
		end

		v:mem(0x126,FIELD_BOOL,false)
		v:mem(0x128,FIELD_BOOL,false)
	end
end


function swingingPlatform.onDrawPlatform(v)
    if v.despawnTimer <= 0 or v.isHidden then return end

    local config = NPC.config[v.id]
    local data = v.data


    local unitWidth = (config.gfxwidth / 3)

    local totalWidth = ((data.width or 1) * unitWidth)

    local unitCount = math.max(2, math.ceil(totalWidth / unitWidth))

    local actualUnitWidth = math.min(totalWidth*0.5,unitWidth)

    local image = Graphics.sprites.npc[v.id].img
    local priority = getPriority(v,config,-45)


    for i = 1, unitCount do
        local x = v.x + v.width*0.5 - totalWidth*0.5 + config.gfxoffsetx
        local y = v.y + v.height - config.gfxheight + config.gfxoffsety
        local sourceX = 0
        local sourceY = (v.animationFrame * config.gfxheight)

        if i == unitCount then
            x = x + totalWidth - actualUnitWidth
            sourceX = config.gfxwidth - actualUnitWidth
        elseif i > 1 then
            x = x + (i-1)*actualUnitWidth
            sourceX = unitWidth
        end

        Graphics.drawImageToSceneWP(image,math.floor(x+0.5),math.floor(y+0.5),sourceX,sourceY,actualUnitWidth,config.gfxheight,priority)
    end

    npcutils.hideNPC(v)
end


return swingingPlatform