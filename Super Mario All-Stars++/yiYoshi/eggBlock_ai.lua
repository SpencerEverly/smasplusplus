--[[

	See yiYoshi.lua for credits

]]

local blockManager = require("blockManager")
local blockutils = require("blocks/blockutils")

local yoshi = require("yiYoshi/yiYoshi")
local eggAI = require("yiYoshi/egg_ai")

local eggBlock = {}


eggBlock.sharedSettings = {
    bumpable = true,

    bumpTime = 16,
    bumpAngle = 25,
    bumpXOffset = 12,
    bumpYOffset = -28,

    releaseSound = 41,
    releaseSpeedX = 1.5,
    releaseSpeedY = -4,
    releaseNoCollisionTime = 4,

    defaultContentID = 0,
}


eggBlock.idList = {}
eggBlock.idMap  = {}

function eggBlock.register(blockID)
	blockManager.registerEvent(blockID,eggBlock,"onTickBlock")
    blockManager.registerEvent(blockID,eggBlock,"onCameraDrawBlock")

    table.insert(eggBlock.idList,blockID)
    eggBlock.idMap[blockID] = true
end


eggBlock.noCollisionNPCs = {}


local function initialise(v,data)
    data.bumpTimer = 0
    data.bumpHorizontalDirection = 0
    data.bumpVerticalDirection = 0

    data.hitCount = 0

    data.initialized = true

    blockutils.storeContainedNPC(v)
end


local function getPlayerEggCount()
    local count = 0

    if player.character == CHARACTER_YOSHI then
        count = count + #yoshi.playerData.followingEggs

        if yoshi.playerData.aimingWithEgg ~= nil then
            count = count + 1
        end
    end

    for _,npc in NPC.iterate(eggAI.collectableIDList,Section.getActiveIndices()) do
        if npc.despawnTimer > 0 then
            count = count + 1
        end
    end

    return count
end

local function getContent(v,data,config)
    local npcID = v.data._basegame.content or 0

    if npcID == 0 then
        npcID = config.defaultContentID
    elseif npcID > 1000 then
        npcID = npcID - 1000
    else
        if data.hitCount < npcID then
            npcID = 10
        else
            npcID = 0
        end
    end

    if eggAI.collectableIDMap[npcID] then
        if getPlayerEggCount() >= yoshi.tongueSettings.maxEggs then
            npcID = 0
        end
    end

    return npcID
end


function eggBlock.onTickBlock(v)
	local data = v.data
	
    if not data.initialized then
        initialise(v,data)
    end
    
    if data.bumpTimer > 0 then
        local config = Block.config[v.id]

        data.bumpTimer = data.bumpTimer + 1

        local npcID = getContent(v,data,config)

        if data.bumpTimer == (config.bumpTime * 0.5) and npcID > 0 then
            local x = v.x + v.width*0.5 + config.bumpXOffset*data.bumpHorizontalDirection
            local y = v.y + v.height*0.5 + config.bumpYOffset*data.bumpVerticalDirection

            local npc = NPC.spawn(npcID,x,y,blockutils.getBlockSection(v),false,true)

            npc.speedX = config.releaseSpeedX * data.bumpHorizontalDirection
            npc.speedY = config.releaseSpeedY * data.bumpVerticalDirection

            if config.releaseNoCollisionTime > 0 then
                npc.noblockcollision = true
                table.insert(eggBlock.noCollisionNPCs,{npc,config.releaseNoCollisionTime})
            end

            if NPC.config[npcID].iscoin then
                npc.ai1 = 1
            end

            data.hitCount = data.hitCount + 1

            SFX.play(config.releaseSound)
        end

        if data.bumpTimer > config.bumpTime then
            data.bumpTimer = 0
        end
    end
end


function eggBlock.onCameraDrawBlock(v,camIdx)
    if not blockutils.visible(Camera(camIdx),v.x,v.y,v.width,v.height) or not blockutils.hiddenFilter(v) then return end

    local config = Block.config[v.id]
    local data = v.data

    if data.sprite == nil then
        data.sprite = Sprite{texture = Graphics.sprites.block[v.id].img,frames = config.frames,pivot = Sprite.align.CENTRE}
    end

    local frame = math.floor((lunatime.drawtick() / config.framespeed) % config.frames) + 1
    local priority = -64
    
    data.sprite.x = v.x + v.width*0.5
    data.sprite.y = v.y + v.height*0.5

    if data.bumpTimer > 0 then
        local progress = (data.bumpTimer / config.bumpTime) * 2
        if progress >= 1 then
            progress = 1 - (progress - 1)
        end


        data.sprite.x = data.sprite.x + (config.bumpXOffset * progress * data.bumpHorizontalDirection)
        data.sprite.y = data.sprite.y + (config.bumpYOffset * progress * data.bumpVerticalDirection)

        data.sprite.rotation = (config.bumpAngle * progress * data.bumpHorizontalDirection * data.bumpVerticalDirection)

        priority = -10
    else
        data.sprite.rotation = 0
    end

    data.sprite:draw{frame = frame,priority = priority,sceneCoords = true}
end


function eggBlock.onPostBlockHit(v,fromTop,playerObj)
    if not eggBlock.idMap[v.id] then return end
    
    local data = v.data

    if not data.initialized then
        initialise(v,data)
    end

    if data.bumpTimer > 0 then
        return
    end

    if playerObj ~= nil then
        data.bumpHorizontalDirection = math.sign((v.x + v.width*0.5) - (playerObj.x + playerObj.width*0.5))
    else
        data.bumpHorizontalDirection = 1
    end

    data.bumpVerticalDirection = (fromTop and -1) or 1

    data.bumpTimer = 1
end


function eggBlock.onDraw()
    for _,id in ipairs(eggBlock.idList) do
        blockutils.setBlockFrame(id,-1000)
    end
end


function eggBlock.onTick()
    -- Update NPC's that temporarily have no collision
    for i = #eggBlock.noCollisionNPCs, 1, -1 do
        local data = eggBlock.noCollisionNPCs[i]
        local npc = data[1]
        local timer = data[2]

        if npc.isValid and timer > 0 then
            data[2] = timer - 1
        else
            if npc.isValid then
                npc.noblockcollision = false
            end

            table.remove(eggBlock.noCollisionNPCs,i)
        end
    end
end


function eggBlock.onInitAPI()
    registerEvent(eggBlock,"onPostBlockHit")
    registerEvent(eggBlock,"onTick")
    registerEvent(eggBlock,"onDraw")
end


return eggBlock