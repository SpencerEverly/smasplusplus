--[[

    See yiYoshi.lua for credits

]]

local npcManager = require("npcManager")
local npcutils = require("npcs/npcutils")


local yoshi

pcall(function() yoshi = require("yiYoshi/yiYoshi") end)


local cloud = {}


cloud.idList = {}
cloud.idMap  = {}

cloud.hiddenMap = {}


function cloud.register(npcID,isHidden)
    npcManager.registerEvent(npcID, cloud, "onTickEndNPC")
    npcManager.registerEvent(npcID, cloud, "onDrawNPC")

    table.insert(cloud.idList,npcID)
    cloud.idMap[npcID] = true

    cloud.hiddenMap[npcID] = isHidden

    if yoshi.generalSettings.popEffectID == nil then
        yoshi.generalSettings.popEffectID = NPC.config[npcID].popEffectID
    end
end


local STATE = {
    STATIONARY = 0,
    HIDDEN = 1,
    HIT = 2,
    GROW = 3,
}


local function releaseContents(v,id)
    if id == 0 then
        if yoshi ~= nil and yoshi.generalSettings.starNPCID ~= nil then
            for i = 1,5 do
                releaseContents(v,yoshi.generalSettings.starNPCID)
            end
        end

        return
    end

    local npc = NPC.spawn(id, v.x + v.width*0.5,v.y + v.height - NPC.config[id].height*0.5, v.section, false,true)

    npc.speedY = -4
end

local function revealNPC(v)
    local config = NPC.config[v.id]
    local data = v.data

    if data.state ~= STATE.HIDDEN then
        return
    end

    data.state = STATE.STATIONARY
    data.timer = 0

    data.flashTimer = 50

    SFX.play(config.revealSound)
end


local function hitNPC(v)
    local data = v.data

    data.state = STATE.HIT
    data.timer = 0

    v.speedY = -5

    v.noblockcollision = false
end


function cloud.onTickEndNPC(v)
    if Defines.levelFreeze then return end
    
    local data = v.data
    
    if v.despawnTimer <= 0 then
        data.initialized = false
        return
    end


    local config = NPC.config[v.id]

    if not data.initialized then
        data.initialized = true

        if cloud.hiddenMap[v.id] then
            data.state = STATE.HIDDEN
        else
            data.state = STATE.STATIONARY
        end
        data.timer = 0

        data.animationTimer = 0
        data.wingFrame = 0

        data.scale = 1

        data.flashTimer = 0

        v.noblockcollision = true
    end


    -- Handle animation
    local editorFrames = (config.frames - config.wingFrames - config.cloudFrames)

    v.animationFrame = (math.floor(data.animationTimer / config.framespeed) % config.cloudFrames) + editorFrames

    if config.wingFrames > 1 then
        data.wingFrame = (math.floor(data.animationTimer / config.wingFramespeed) % (config.wingFrames*2 - 2))
        if data.wingFrame >= config.wingFrames then
            data.wingFrame = config.wingFrames - (data.wingFrame - config.wingFrames) - 2
        end

        data.wingFrame = data.wingFrame + (config.frames - config.cloudFrames - 1)
    else
        data.wingFrame = (config.frames - 1)
    end

    data.animationTimer = data.animationTimer + 1


    data.flashTimer = math.max(0,data.flashTimer - 1)


    if v:mem(0x12C, FIELD_WORD) > 0    --Grabbed
    or v:mem(0x136, FIELD_BOOL)        --Thrown
    or v:mem(0x138, FIELD_WORD) > 0    --Contained within
    then return end


    if data.state == STATE.STATIONARY or data.state == STATE.HIDDEN then
        npcutils.applyLayerMovement(v)
    end


    if data.state == STATE.STATIONARY then
        v.speedY = math.cos(data.timer / 32) * 0.4

        -- Detect being jumped
        for _,p in ipairs(Player.getIntersecting(v.x,v.y,v.x+v.width,v.y+v.height)) do
            if (yoshi == nil or p.character ~= CHARACTER_YOSHI) and (p.y + p.height - p.speedY) <= (v.y - v.speedY) then
                hitNPC(v)

                local e = Effect.spawn(75, v.x + v.width*0.5,v.y)

                e.x = e.x - e.width *0.5
                e.y = e.y - e.height*0.5


                p:mem(0x11C,FIELD_WORD,Defines.jumpheight_bounce)
                p.speedY = -5.7

                SFX.play(2)
            end
        end
    elseif data.state == STATE.HIT then
        if v.underwater then
            v.speedY = math.min(1.6,v.speedY + Defines.npc_grav*0.2)
        else
            v.speedY = math.min(8,v.speedY + Defines.npc_grav)
        end

        if v.collidesBlockBottom then
            data.state = STATE.GROW
            data.timer = 0

            v.speedY = 0

            v.noblockcollision = true
        end
    elseif data.state == STATE.GROW then
        data.scale = math.min(2,data.scale + 0.1)

        if data.timer >= 24 then
            if config.popSound ~= nil then
                SFX.play(config.popSound)
            end

            if config.popEffectID ~= nil then
                Effect.spawn(config.popEffectID,v.x + v.width*0.5,v.y + v.height*0.5)
            end

            releaseContents(v,v.ai1)

            v:kill(HARM_TYPE_VANISH)
        end
    elseif data.state == STATE.HIDDEN then
        for _,p in ipairs(Player.getIntersecting(v.x,v.y,v.x+v.width,v.y+v.height)) do
            if p.forcedState == FORCEDSTATE_NONE and p.deathTimer == 0 and not p:mem(0x13C,FIELD_BOOL) then
                revealNPC(v)
            end
        end
    end

    data.timer = data.timer + 1
end


local lowPriorityStates = table.map{1,3,4}

function cloud.onDrawNPC(v)
    if v.isHidden or v.despawnTimer <= 0 or v.animationFrame < 0 then return end

    local config = NPC.config[v.id]
    local data = v.data


    if data.state == STATE.HIDDEN or (data.flashTimer ~= nil and data.flashTimer%2 == 1) then
        npcutils.hideNPC(v)
        return
    end
    

    if data.sprite == nil then
        data.sprite = Sprite{texture = Graphics.sprites.npc[v.id].img,frames = npcutils.getTotalFramesByFramestyle(v),pivot = Sprite.align.CENTRE}
    end


    local priority
    if v:mem(0x12C,FIELD_WORD) > 0 then
        priority = -30
    elseif lowPriorityStates[v:mem(0x138,FIELD_WORD)] then
        priority = -75
    elseif config.foreground then
        priority = -15
    else
        priority = -45
    end


    data.sprite.x = v.x + v.width*0.5 + config.gfxoffsetx
    data.sprite.y = v.y + v.height - config.gfxheight*0.5 + config.gfxoffsety

    data.sprite.scale.x = data.scale or 1
    data.sprite.scale.y = data.scale or 1

    data.sprite:draw{frame = v.animationFrame+1,priority = priority,sceneCoords = true}

    if data.state == STATE.STATIONARY then
        data.sprite:draw{frame = data.wingFrame+1,priority = priority,sceneCoords = true}
    end


    npcutils.hideNPC(v)
end


function cloud.onNPCHarm(eventObj,v,reason,culprit)
    if not cloud.idMap[v.id] or reason == HARM_TYPE_OFFSCREEN then return end

    local data = v.data

    if data.flashTimer > 0 then
        eventObj.cancelled = true
        return
    end

    if data.state == STATE.STATIONARY then
        hitNPC(v)

        SFX.play(9)

        eventObj.cancelled = true
    else
        revealNPC(v)
        eventObj.cancelled = true
    end
end


function cloud.onInitAPI()
    registerEvent(cloud,"onNPCHarm")
end


return cloud