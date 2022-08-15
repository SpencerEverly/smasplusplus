--[[

    extraNPCProperties.lua (v1.0.1)
    by MrDoubleA

]]

local extraNPCProperties = {}


local SPAWNING_BEHAVIOUR = {
    DEFAULT = 0,
    DONT_DESPAWN = 1,
    SPAWNED_IF_IN_SECTION = 2,
}

local INVINCIBLE_TO = {
    NOTHING = 0,
    EVERYTHING = 1,
    PLAYER = 2,
    NPCS = 3,
}

local TURN_AROUND_BEHAVIOUR = {
    DEFAULT = 0,
    NEVER = 1,
    ONLY_AT_WALLS = 2,
}


local defaultPropertiesMap = {
    spawningBehaviour = SPAWNING_BEHAVIOUR.DEFAULT,
    invincibleTo = INVINCIBLE_TO.NOTHING,
    turnAroundBehaviour = TURN_AROUND_BEHAVIOUR.DEFAULT,
    noblockcollision = false,
    tags = "",

    maxGeneratedNPCs = 0,
}

local propertiesList = table.unmap(defaultPropertiesMap)


extraNPCProperties.relevantNPCs = {}

local activeSectionMap = {}
local taggedMap = {}



function extraNPCProperties.getWithTag(tag)
    local npcs = taggedMap[tag]

    if npcs == nil then
        return {}
    end

    -- Remove any invalid ones before returning
    for i = #npcs, 1, -1 do
        if not npcs[i].isValid then
            table.remove(npcs,i)
        end
    end

    return npcs
end


local function getData(v)
    local data,settings = v.data.extraNPCProperties,v.data._settings._global

    if data == nil then
        data = {}

        -- Parse tags
        data.tagsList = {}

        for _,tag in ipairs(settings.tags:split(",")) do
            -- Remove spaces around
            tag = tag:match("%s*(.+)%s*")
            
            if tag ~= nil then
                table.insert(data.tagsList,tag)

                taggedMap[tag] = taggedMap[tag] or {}
                table.insert(taggedMap[tag],v)
            end
        end

        -- Initialise
        data.generatedNPCs = {}

        data.forceDirection = v.spawnDirection


        v.data.extraNPCProperties = data
    end

    return data,settings
end

extraNPCProperties.getData = getData


function extraNPCProperties.onInitAPI()
    registerEvent(extraNPCProperties,"onStart","onStart",false)
    registerEvent(extraNPCProperties,"onTick")

    registerEvent(extraNPCProperties,"onNPCHarm")

    registerEvent(extraNPCProperties,"onNPCGenerated")


    registerEvent(extraNPCProperties,"onReset","onStart",false)
end


local function isRelevant(v)
    local settings = v.data._settings._global

    for _,name in ipairs(propertiesList) do
        if settings[name] ~= nil and settings[name] ~= defaultPropertiesMap[name] then
            return true
        end
    end

    return false
end


local function addToRelevant(v)
    local data,settings = getData(v)

    table.insert(extraNPCProperties.relevantNPCs,v)
end


local function doSectionFix(v)
    -- Check the section, because redigit's own logic suuucks

    -- Actually in the bounds (yes, redigit messed even this check up!)
    local sectionObj = Section.getFromCoords(v)

    if sectionObj ~= nil then
        v.section = sectionObj.idx
        return
    end

    -- If that fails, find the closest section centre
    local closestSection = 0
    local closestDistance = math.huge

    for _,sectionObj in ipairs(Section.get()) do
        local b = sectionObj.boundary

        local sectionX = (b.right + b.left) * 0.5
        local sectionY = (b.bottom + b.top) * 0.5

        local xDistance = (sectionX - (v.x + v.width *0.5))
        local yDistance = (sectionY - (v.y + v.height*0.5))
        local totalDistance = math.sqrt(xDistance*xDistance + yDistance*yDistance)

        if totalDistance < closestDistance then
            closestSection = sectionObj.idx
            closestDistance = totalDistance
        end
    end

    v.section = closestSection
end



function extraNPCProperties.onStart()
    for _,v in NPC.iterate() do
        if isRelevant(v) then
            addToRelevant(v)
        end

        doSectionFix(v)
    end
end


local function perNPCLogic(v)
    local data,settings = getData(v)

    -- Handle spawning behaviour
    if activeSectionMap[v.section] and settings.spawningBehaviour ~= SPAWNING_BEHAVIOUR.DEFAULT then
        if settings.spawningBehaviour == SPAWNING_BEHAVIOUR.SPAWNED_IF_IN_SECTION or (v.despawnTimer > 0 and settings.spawningBehaviour == SPAWNING_BEHAVIOUR.DONT_DESPAWN) then
            v.despawnTimer = math.max(10,v.despawnTimer)
            v:mem(0x124,FIELD_BOOL,true)
        end
    end

    if v.isGenerator then
        -- Handle max generated NPC's
        if settings.maxGeneratedNPCs > 0 and data.generatedNPCs[1] ~= nil then
            local generatedNPCsCount = 0

            local i = 1
            while (true) do
                local npc = data.generatedNPCs[i]
                if npc == nil then
                    break
                end

                if npc.isValid then
                    generatedNPCsCount = generatedNPCsCount + 1
                    i = i + 1
                else
                    table.remove(data.generatedNPCs,i)
                end
            end

            if generatedNPCsCount >= settings.maxGeneratedNPCs then
                v.generatorTimer = 0
                v:mem(0x74,FIELD_BOOL,false)
            end
        end

        return
    end

    v.noblockcollision = v.noblockcollision or settings.noblockcollision

    if v.despawnTimer <= 0 then
        data.forceDirection = v.spawnDirection
        return
    end

    -- Handle no bouncing
    if settings.turnAroundBehaviour ~= TURN_AROUND_BEHAVIOUR.DEFAULT then
        if settings.turnAroundBehaviour == TURN_AROUND_BEHAVIOUR.ONLY_AT_WALLS and v:mem(0x120,FIELD_BOOL) and (v.collidesBlockLeft or v.collidesBlockRight) then
            data.forceDirection = -data.forceDirection
        end

        v.direction = data.forceDirection
    end
end



function extraNPCProperties.onTick()
    activeSectionMap = table.map(Section.getActiveIndices())

    local i = 1
    while (true) do
        local v = extraNPCProperties.relevantNPCs[i]
        if v == nil then
            break
        end

        if v.isValid then
            perNPCLogic(v)
            i = i + 1
        else
            table.remove(extraNPCProperties.relevantNPCs,i)
        end
    end
end


function extraNPCProperties.onNPCHarm(eventObj,v,reason,culprit)
    local data,settings = getData(v)

    if settings.invincibleTo == INVINCIBLE_TO.EVERYTHING
    or (type(culprit) == "Player" and settings.invincibleTo == INVINCIBLE_TO.PLAYER)
    or (type(culrpit) == "NPC"    and settings.invincibleTo == INVINCIBLE_TO.NPCS  )
    then
        eventObj.cancelled = true
    end
end

function extraNPCProperties.onNPCGenerated(generator,generatedNPC)
    if isRelevant(generator) then
        local data,settings = getData(generator)

        if settings.maxGeneratedNPCs > 0 then
            table.insert(data.generatedNPCs,generatedNPC)
        end
    end

    if isRelevant(generatedNPC) then
        addToRelevant(generatedNPC)
    end
end


return extraNPCProperties