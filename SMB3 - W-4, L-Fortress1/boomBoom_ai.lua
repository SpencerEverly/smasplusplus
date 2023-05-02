--[[

    Written by MrDoubleA
    Please give credit!
    
    Alternate graphics made by Palutena, permission for use was given by universalidiocy#3253 on Discord, and are from an HTML game called "Super Mario Construct"

    Part of MrDoubleA's NPC Pack

]]

local npcManager = require("npcManager")
local npcutils = require("npcs/npcutils")
local smasExtraSounds = require("smasExtraSounds")

local effectconfig = require("game/effectconfig")

local boomBoom = {}

-- Create maps and lists for IDs
boomBoom.idMap = {}
boomBoom.idList = {}

boomBoom.chasingIDMap = {}
boomBoom.chasingIDList = {}

boomBoom.wingedIDMap = {}
boomBoom.wingedIDList = {}

boomBoom.hidingIDMap = {}
boomBoom.hidingIDList = {}

-- State constants
local STATE_CHASE  = 0
local STATE_ATTACK = 1
local STATE_HURT   = 2
local STATE_HIDE   = 3

local colBox = Colliders.Box(0,0,0,0) -- General purpose colliders box

local function solidNPCFilter(v) -- Filter for Colliders.getColliding to only return NPCs that are solid to NPCs
    return (not v.isGenerator and not v.isHidden and not v.friendly and (NPC.config[v.id] and NPC.config[v.id].npcblock))
end

local function transform(v,id) -- Function to transform NPC but take collision into account and preserve data
    if v.id == id then return end -- If the old ID and new ID are the same, there's no need to change ID

    local oldConfig = NPC.config[v.id]
    local newConfig = NPC.config[id]

    if oldConfig.noblockcollision and not newConfig.noblockcollision then -- If the new NPC has collision but the old one does not, do a collision check
        colBox.x = v.x+(v.width/2)-(NPC.config[id].width/2)
        colBox.y = v.y+v.height-newConfig.height
        colBox.width,colBox.height = newConfig.width,newConfig.height

        if #Colliders.getColliding{a = colBox,b = Block.SOLID.. Block.PLAYER,btype = Colliders.BLOCK} > 0 -- Account for blocks
        or #Colliders.getColliding{a = colBox,btype = Colliders.NPC,filter = solidNPCFilter}          > 0 -- Account for NPCs
        then
            return
        end
    end

    local oldData = v.data

    v:transform(id)

    v.data = oldData
end

local function getConfig(v)
    local data = v.data

    if boomBoom.hidingIDMap[v.id] and data.originalID then
        return NPC.config[data.originalID]
    else
        return NPC.config[v.id]
    end
end

local function getAnimationFrame(v)
    local f = v.animationFrame

    local config = getConfig(v)
    local data = v.data

    if not boomBoom.hidingIDMap[v.id] then
        local frameMultiplier
        if boomBoom.chasingIDMap[v.id] then
            frameMultiplier = config.frames/14
        elseif boomBoom.wingedIDMap[v.id] then
            frameMultiplier = config.frames/10
        end

        if data.state == STATE_HURT then
            f = (config.frames)-(2*frameMultiplier)+(math.floor(data.animationTimer/config.framespeed)%(2*frameMultiplier))
        elseif data.state == STATE_HIDE then
            if data.timer < (config.hideTime/12) then
                f = (config.frames)-(4*frameMultiplier)+(math.floor(data.timer/(config.hideTime/12))%(2*frameMultiplier))
            elseif data.timer > (config.hideTime-(config.hideTime/12)) then
                f = (config.frames)-(4*frameMultiplier)+(math.floor(data.timer-((config.hideTime-(config.hideTime/12)))/(config.hideTime/12))%(1*frameMultiplier))
            else
                f = (config.frames)-(3*frameMultiplier)+(math.floor(data.timer/(config.hideTime/12))%(1*frameMultiplier))
            end
        elseif not v.collidesBlockBottom and not config.nogravity then
            f = (config.frames)-(5*frameMultiplier)+(math.floor(data.animationTimer/config.framespeed)%(1*frameMultiplier))
        elseif data.state == STATE_ATTACK and boomBoom.chasingIDMap[v.id] then
            f = (config.frames)-(6*frameMultiplier)+(math.floor(data.animationTimer/config.framespeed)%(1*frameMultiplier))
        elseif data.state == STATE_ATTACK and boomBoom.wingedIDMap[v.id] then
            f = (math.floor(data.animationTimer/(config.framespeed/2))%(config.frames-(4*frameMultiplier)))
        else
            f = (math.floor(data.animationTimer/config.framespeed)%(config.frames-(4*frameMultiplier)))
        end
    end

    return npcutils.getFrameByFramestyle(v,{frame = f,direction = data.direction})
end

-- Death effect logic
function effectconfig.onTick.TICK_CUSTOMBOOMBOOM(v)
    if v.timer == v.lifetime-40 then
        v.speedX = 1.5*v.direction
        v.speedY = -7

        v.gravity = 0.35
    end
end

function boomBoom.registerChasing(id) -- Registers a chasing boom boom
    npcManager.registerEvent(id,boomBoom,"onTickEndNPC")

    -- Register it into the ID lists
    boomBoom.idMap[id] = true
    table.insert(boomBoom.idList,id)

    boomBoom.chasingIDMap[id] = true
    table.insert(boomBoom.chasingIDList,id)
end

function boomBoom.registerWinged(id) -- Registers a winged boom boom
    npcManager.registerEvent(id,boomBoom,"onTickEndNPC")

    -- Register it into the ID lists
    boomBoom.idMap[id] = true
    table.insert(boomBoom.idList,id)

    boomBoom.wingedIDMap[id] = true
    table.insert(boomBoom.wingedIDList,id)
end

function boomBoom.registerHiding(id) -- Registers a hiding boom boom
    npcManager.registerEvent(id,boomBoom,"onTickEndNPC")

    -- Register it into the ID lists
    boomBoom.idMap[id] = true
    table.insert(boomBoom.idList,id)

    boomBoom.hidingIDMap[id] = true
    table.insert(boomBoom.hidingIDList,id)
end


function boomBoom.onInitAPI()
    registerEvent(boomBoom,"onNPCHarm")
end

function boomBoom.onNPCHarm(eventObj,v,reason,culprit)
    if not boomBoom.idMap[v.id] or reason == HARM_TYPE_OFFSCREEN then return end

    local config = getConfig(v)
    local data = v.data

    if not data.state then return end
    

    if data.state == STATE_HIDE and (reason == HARM_TYPE_JUMP or reason == HARM_TYPE_SPINJUMP) then -- In the case that something goes wrong
        if culprit and culprit.__type == "Player" and (not NPC.config[config.hideID].spinjumpsafe or not culprit:mem(0x50,FIELD_BOOL)) then
            culprit:harm()
        end

        eventObj.cancelled = true
    elseif v:mem(0x156,FIELD_WORD) > 0 then -- Invincibility time
        eventObj.cancelled = true
    else
        local fromFireball = (culprit and culprit.__type == "NPC" and culprit.id == 13 )
        local fromHammer   = (culprit and culprit.__type == "NPC" and culprit.id == 171)

        if fromHammer then
            data.health = 0
        elseif fromFireball then
            data.health = math.max(0,data.health - 0.25)
        else
            data.health = math.max(0,data.health - 1)
        end

        if data.health > 0 then
            if not fromFireball then
                if data.originalID then
                    transform(v,data.originalID)
                end

                data.state = STATE_HURT
                data.timer = 0

                -- Invincibility time
                if boomBoom.chasingIDMap[data.originalID] then
                    v:mem(0x156,FIELD_WORD,(config.hurtTime+config.hideTime))
                elseif boomBoom.wingedIDMap[data.originalID] then
                    v:mem(0x156,FIELD_WORD,(config.hurtTime+config.hideTime+32))
                end
            end

            eventObj.cancelled = true
        end

        -- Play hit sound effect
        if config.hitSFX and not fromFireball then
            SFX.play(config.hitSFX)
        end
    end

    -- Cause the player to bounce away after being stomped on
    if culprit and culprit.__type == "Player" and data.health > 0 and (reason == HARM_TYPE_JUMP or reason == HARM_TYPE_SPINJUMP) then
        culprit.speedX = math.sign((culprit.x+(culprit.width/2))-(v.x+(v.width/2)))*2.5
    end
end

function boomBoom.onTickEndNPC(v)
    if Defines.levelFreeze then return end
    
    local config = getConfig(v)
    local data = v.data
    
    if v.despawnTimer <= 0 then
        data.state = nil
        return
    end

    if not data.state then
        data.state = STATE_CHASE
        data.timer = 0

        data.health = config.health

        data.originalID = v.id

        data.direction = v.direction
        data.animationTimer = 0

        -- Used for dive attack
        data.diveStartPosition = nil
        data.divePlayerPosition = nil

        if boomBoom.hidingIDMap[v.id] then -- Hiding Boom Boom warning
            Misc.warn("Cannot directly place an NPC of ID ".. v.id.. " into levels")
            v:kill(HARM_TYPE_OFFSCREEN)

            return
        end
    end

    v.despawnTimer = 180
    
    data.animationTimer = data.animationTimer + 1

    if v:mem(0x12C, FIELD_WORD) > 0    --Grabbed
    or v:mem(0x136, FIELD_BOOL)        --Thrown
    or v:mem(0x138, FIELD_WORD) > 0    --Contained within
    then
        if data.originalID then
            transform(v,data.originalID)
        end

        data.direction = v.direction

        v.animationFrame = getAnimationFrame(v)

        if v:mem(0x138, FIELD_WORD) == 0 then -- Grabbed
            data.state = STATE_HURT
            data.timer = math.huge
        else
            data.state = STATE_CHASE
            data.timer = 0
        end

        return
    end
    
    -- Logic
    local n = Player.getNearest(v.x+(v.width/2),v.y+(v.height/2))
    local distanceFromPlayerX,distanceFromPlayerY,distanceFromPlayer = math.huge,math.huge,math.huge

    if n then
        distanceFromPlayerX = (n.x+(n.width /2))-(v.x+(v.width /2))
        distanceFromPlayerY = (n.y+(n.height/2))-(v.y+(v.height/2))
        distanceFromPlayer  = math.abs(distanceFromPlayerX)+math.abs(distanceFromPlayerY)
    end

    data.timer = data.timer + 1

    if data.state == STATE_CHASE then
        if distanceFromPlayer < config.chaseDistance then
            v.speedX = math.clamp(v.speedX + (config.chaseAcceleration*math.sign(distanceFromPlayerX)),-config.chaseSpeed,config.chaseSpeed)
            data.direction = math.sign(distanceFromPlayerX)

            if boomBoom.chasingIDMap[data.originalID] then
                if data.timer > config.chaseTime then
                    if distanceFromPlayerX < (config.chaseDistance/4) then
                        data.state = STATE_ATTACK
                        v.speedX = 0
                    end
    
                    data.timer = 0
                end
            elseif boomBoom.wingedIDMap[data.originalID] then
                if n then
                    local goalY = math.max((n.y+(n.height/2))-400,Section(v.section).boundary.top+96)
                    local distance = goalY-(v.y+(v.height/2))

                    if (math.abs(distance) < (v.height*1.5) and data.timer <= 1) or (math.abs(distance) < (v.height*3) and data.timer > 1) then
                        if data.timer > config.chaseTime then
                            data.state = STATE_ATTACK
                            data.timer = 0

                            v.speedX,v.speedY = 0,0
                        else
                            v.speedY = math.cos(data.timer/12)
                        end
                    else
                        v.speedY = math.clamp(v.speedY + (config.chaseAcceleration*math.sign(distance)),-config.chaseSpeed,config.chaseSpeed)

                        data.timer = 0
                    end
                end
            end
        else -- Reduce speed (maybe a better way to do this?)
            if v.speedX > 0 then
                v.speedX = math.max(0,v.speedX - config.chaseAcceleration)
            elseif v.speedX < 0 then
                v.speedX = math.min(0,v.speedX + config.chaseAcceleration)
            end

            if v.speedY > 0 then
                v.speedY = math.max(0,v.speedY - config.chaseAcceleration)
            elseif v.speedY < 0 then
                v.speedY = math.min(0,v.speedY + config.chaseAcceleration)
            end
        end
    elseif data.state == STATE_ATTACK then
        if v.speedX ~= 0 then
            data.direction = math.sign(v.speedX)
        end

        if boomBoom.chasingIDMap[data.originalID] then
            if v.collidesBlockBottom or config.nogravity then
                if data.timer > config.attackPrepareTime+1 then
                    data.state = STATE_CHASE
                    data.timer = 0

                    v.speedX = 0
                elseif data.timer > config.attackPrepareTime then
                    v.speedX = 4*data.direction
                    v.speedY = -8
                end
            end
        elseif boomBoom.wingedIDMap[data.originalID] then
            if not n then
                data.state = STATE_CHASE
                data.timer = 0
            elseif data.timer > config.attackPrepareTime then
                local distance = ((data.divePlayerPosition.y-data.diveStartPosition.y)/36)
                local timer = data.timer-config.attackPrepareTime

                v.speedX = ((data.diveStartPosition.x+((data.divePlayerPosition.x-data.diveStartPosition.x)*2))-data.diveStartPosition.x)/128
                v.speedY = math.cos((timer*(math.pi*2))/256)*distance
    
                if v.y+(v.height/2) < data.diveStartPosition.y+(v.height*2) and v.speedY < 0 -- Finished attack
                or not Section(v.section).wrapH and (v.x+(v.width/2) < Section(v.section).boundary.left or v.x+(v.width/2) > Section(v.section).boundary.right) -- Out of section bounds
                then
                    data.state = STATE_CHASE
                    data.timer = 0

                    v.speedX,v.speedY = 0,0
                end
            else
                data.diveStartPosition  = vector(v.x+(v.width/2),v.y+(v.height/2))
                data.divePlayerPosition = vector(n.x+(n.width/2),n.y+(n.height/2))
            end
        end
    elseif data.state == STATE_HURT then
        v.speedX = 0
    
        if config.nogravity then
            v.speedY = 0
        elseif v.underwater and not config.nowaterphysics then
            v.speedY = -(Defines.npc_grav/5)
        else
            v.speedY = -(Defines.npc_grav)
        end

        if data.timer > config.hurtTime then
            data.state = STATE_HIDE
            data.timer = 0
        end
    elseif data.state == STATE_HIDE then
        if data.timer > config.hideTime then
            data.state = STATE_CHASE
            data.timer = 0
        elseif data.timer > (config.hideTime-(config.hideTime/12)) and data.originalID then
            transform(v,data.originalID)
        elseif data.timer > (config.hideTime/12) and config.hideID then
            v.direction = data.direction

            transform(v,config.hideID)
        end
    end

    if v.dontMove then
        data.direction = v.direction
    end

    v.animationFrame = getAnimationFrame(v)
end

return boomBoom