local Npc = {}

local lineguide = require("lineguide")

Npc.hasSavedClasses = false

Npc.npcResetProperties = {
    -- Monty moles
    [309] = {
        onStart = (function(v)
            local bootmenuData = v.data._bootmenu

            bootmenuData.startedFriendly = v.friendly
        end),
        extraSave = (function(v,fields)
            local bootmenuData = v.data._rooms

            fields.friendly = (bootmenuData and bootmenuData.startedFriendly)
        end),
        extraRestore = (function(v,fields)
            -- Basically just a copy of the normal onStartNPC

            local data = v.data._basegame

            data.wasBuried = 1
            if v.data._settings.startHidden == false then
                data.wasBuried = 0
            else
                data.vanillaFriendly = fields.friendly
                v.friendly = true
                v.noblockcollision = true
            end
            data.timer = 0
            data.direction = v.direction
            data.state = data.wasBuried
        end),
    },

    [469] = {respawn = false}, -- Boo circle boos are set to respawn? for some reason?

    -- Checkpoints
    [192] = {despawn = false,respawn = false},
    [400] = {despawn = false,respawn = false},
    [430] = {despawn = false,respawn = false},
}

Npc.classesToSave = {
    -- Classes that tend to shift around a lot (so therefore deletes everything and spawns new ones when resetting)
    {
        name = "Block",get = Block.get,getByIndex = Block,startFromZero = true,
        saveFields = {
            "layerName","contentID","isHidden","slippery","width","height","id","speedX","speedY","x","y",{0x5A,FIELD_BOOL},{0x5C,FIELD_BOOL},
            {0x0C,FIELD_STRING},{0x10,FIELD_STRING},{0x14,FIELD_STRING}, -- Event names
        },
        extraSave    = (function(v,fields) fields.data = table.deepclone(v.data) end),
        extraRestore = (function(v,fields)
            v:translate(0,0) -- Make sure the block array is sorted correctly
            v.data = table.deepclone(fields.data)
        end),

        remove = (function(v) v:delete() end),
        create = (function(fields) return blockSpawnWithSizeableOrdering(fields.id,fields.x,fields.y) end),
    },
    {
        name = "NPC",get = NPC.get,getByIndex = NPC,startFromZero = false,
        saveFields = {
            --[["x","y",]]"spawnX","spawnY","width","height","spawnWidth","spawnHeight","speedX","speedY","spawnSpeedX","spawnSpeedY",
            "direction","spawnDirection","layerName","id","spawnId","ai1","ai2","ai3","ai4","ai5","spawnAi1","spawnAi2","isHidden","section",
            "msg","attachedLayerName","activateEventName","deathEventName","noMoreObjInLayer","talkEventName","legacyBoss","friendly","dontMove",
            "isGenerator","generatorInterval","generatorTimer","generatorDirection","generatorType", -- Generator related stuff
            "despawnTimer",{0x124,FIELD_BOOL},{0x126,FIELD_BOOL},{0x128,FIELD_BOOL}, -- Despawning related stuff
        },
        --[[extraSave    = (function(v,fields) fields.extraSettings = v.data._settings end),
        extraRestore = (function(v,fields) v.data._settings = fields.extraSettings end),]]
        extraSave    = (function(v,fields)
            fields.extraSettings = table.deepclone(v.data._settings)
            fields.isOrbitingNPC = (v.data._orbits ~= nil and v.data._orbits.orbitCenter == nil)

            local properties = Npc.npcResetProperties[v.id]

            if properties ~= nil and properties.extraSave ~= nil then
                properties.extraSave(v,fields)
            end

            --if v.id == 119 then Misc.dialog(v.despawnTimer,v:mem(0x124,FIELD_BOOL)) end
        end),
        extraRestore = (function(v,fields)
            v.despawnTimer = 5
            v:mem(0x124,FIELD_BOOL,true)
            
            v:mem(0x14C,FIELD_WORD,1)


            --if v.id == 119 then Misc.dialog(v.despawnTimer,v:mem(0x124,FIELD_BOOL),fields.despawnTimer,fields[0x124]) end


            -- Failsafe because the SMW switch platforms use lineguide data, but don't actually check if it exists
            if lineguide.registeredNPCMap[v.id] and not v.data._basegame.lineguide then
                lineguide.onStartNPC(v)
            end

            -- Without these, hammer bros cause errors
            v.ai1,v.ai2 = fields.spawnAi1,fields.spawnAi2
            v.ai3,v.ai4,v.ai5 = 0,0,0

            v.data._settings = table.deepclone(fields.extraSettings)


            local properties = Npc.npcResetProperties[v.id]

            if properties ~= nil and properties.extraRestore ~= nil then
                properties.extraRestore(v,fields)
            end
        end),
        
        remove = (function(v)
            if (NPC.COLLECTIBLE_MAP[v.id] and not Npc.collectiblesRespawn) then return end -- Don't do this for collectibles, if set

            local properties = Npc.npcResetProperties[v.id]

            if properties ~= nil then
                if properties.despawn == false then
                    return
                elseif properties.remove ~= nil then
                    properties.remove(v)
                end
            end

            -- Rather complicated setup to destroy NPCs
            local data = v.data

            if not v.isGenerator then
                -- Trigger some events, just to make sure that everything gets cleaned up properly
                local eventObj = {cancelled = false}
                EventManager.callEvent("onNPCKill",eventObj,v.idx+1,HARM_TYPE_OFFSCREEN)
                
                if eventObj.cancelled then -- Make sure onPostNPCKill always runs
                    EventManager.callEvent("onPostNPCKill",v,HARM_TYPE_OFFSCREEN)
                end
            end

            v.deathEventName = ""
            v.animationFrame = -1000
            v.isGenerator = false

            v.id = 0

            v:kill(HARM_TYPE_OFFSCREEN)
        end),
        create = (function(fields)
            if (NPC.COLLECTIBLE_MAP[fields.id] and not Npc.collectiblesRespawn) then return end -- Don't do this for collectibles, if set
            if fields.spawnId == 0 or fields.layerName == "Spawned NPCs" or fields.isOrbitingNPC then return end -- If set not to respawn or on the spawned NPCs layer, stop
            
            local properties = Npc.npcResetProperties[fields.spawnId]

            if properties ~= nil and properties.respawn == false then return end


            return NPC.spawn(fields.spawnId,fields.spawnX,fields.spawnY,fields.section,true,false)
        end),
    },

    -- Classes that tend to be static (so therefore the old properties are just put back when resetting)
    {
        name = "BGO",get = BGO.get,getByIndex = BGO,startFromZero = true,
        saveFields = {"layerName","isHidden","id","x","y","width","height","speedX","speedY"},
    },
    {
        name = "Liquid",get = Liquid.get,getByIndex = Liquid,startFromZero = false,
        saveFields = {"layerName","isHidden","isQuicksand","x","y","width","height","speedX","speedY"},
    },
    {
        name = "Warp",get = Warp.get,getByIndex = Warp,startFromZero = true,
        saveFields = {
            "layerName","isHidden","locked","allowItems","noYoshi","starsRequired",
            "warpType","levelFilename","warpNumber","toOtherLevel","fromOtherLevel","worldMapX","worldMapY",
            "entranceX","entranceY","entranceWidth","entranceHeight","entranceSpeedX","entranceSpeedY","entranceDirection",
            "exitX","exitY","exitWidth","exitHeight","exitSpeedX","exitSpeedY","exitDirection",
        },
    },

    {
        name = "Layer",get = Layer.get,getByIndex = Layer,startFromZero = false,
        saveFields = {"name","isHidden","speedX","speedY"},
    },
    {
        name = "Section",get = Section.get,getByIndex = Section,startFromZero = true,
        saveFields = {
            "boundary","origBoundary","musicID","musicPath","wrapH","wrapV","hasOffscreenExit","backgroundID","origBackgroundID",
            "noTurnBack","isUnderwater","settings",
        },
    },
}

Npc.savedClasses = {}

function NPC.harmAll(npc,...) -- npc:harm but it harms all NPCs with a specified HARM_TYPE
    local oldKilled     = npc:mem(0x122,FIELD_WORD)
    local oldProjectile = npc:mem(0x136,FIELD_BOOL)
    local oldHitCount   = npc:mem(0x148,FIELD_FLOAT)
    local oldImmune     = npc:mem(0x156,FIELD_WORD)
    local oldID         = npc.id
    local oldSpeedX     = npc.speedX
    local oldSpeedY     = npc.speedY

    npc:harm(...)

    return (
           oldKilled     ~= npc:mem(0x122,FIELD_WORD)
        or oldProjectile ~= npc:mem(0x136,FIELD_BOOL)
        or oldHitCount   ~= npc:mem(0x148,FIELD_FLOAT)
        or oldImmune     ~= npc:mem(0x156,FIELD_WORD)
        or oldID         ~= npc.id
        or oldSpeedX     ~= npc.speedX
        or oldSpeedY     ~= npc.speedY
    )
end

function NPC.harmSpecified(npcid,...) -- npc:harm but it harms all of a specific NPC and not everything with a specified HARM_TYPE
    if npcid == nil then
        return
    end
    for k,v in ipairs(NPC.get(npcid)) do
        local oldKilled     = v:mem(0x122,FIELD_WORD)
        local oldProjectile = v:mem(0x136,FIELD_BOOL)
        local oldHitCount   = v:mem(0x148,FIELD_FLOAT)
        local oldImmune     = v:mem(0x156,FIELD_WORD)
        local oldID         = v.id
        local oldSpeedX     = v.speedX
        local oldSpeedY     = v.speedY

        v:harm(...)

        return (
               oldKilled     ~= v:mem(0x122,FIELD_WORD)
            or oldProjectile ~= v:mem(0x136,FIELD_BOOL)
            or oldHitCount   ~= v:mem(0x148,FIELD_FLOAT)
            or oldImmune     ~= v:mem(0x156,FIELD_WORD)
            or oldID         ~= v.id
            or oldSpeedX     ~= v.speedX
            or oldSpeedY     ~= v.speedY
        )
    end
end

function NPC.saveClass(class) --Saves a specific class. Used for NPCs.
    -- If no class is provided, save all classes
    if class == nil then
        for _,c in ipairs(Npc.classesToSave) do
            NPC.saveClass(c.name)
        end
        return
    end

    -- Convert name to the actual class
    if type(class) ~= "table" then
        for _,c in ipairs(Npc.classesToSave) do
            if c.name == class then
                class = c
                break
            end
        end
    end

    -- Create a table for this class
    Npc.savedClasses[class.name] = {}

    -- Go through all objects in this class
    for _,v in ipairs(class.get()) do
        local fields = {}

        if class.saveFields then
            -- Save fields, if they exist
            for _,w in ipairs(class.saveFields) do
                if type(w) == "table" then -- For memory offsets
                    fields[w[1]] = v:mem(w[1],w[2])
                else
                    fields[w] = v[w]
                end
            end
        end

        if class.extraSave then
            class.extraSave(v,fields)
        end

        table.insert(Npc.savedClasses[class.name],fields)
    end
end

function NPC.restoreClass(class) --Restores a specific class. Used for NPCs.
    -- If no class is provided, restore all classes
    if class == nil then
        for _,c in ipairs(Npc.classesToSave) do
            NPC.restoreClass(c.name)
        end
        return
    end

    if not Npc.savedClasses[class] then return end -- Don't attempt to restore it if it hasn't been saved yet

    -- Convert name to the actual class
    if type(class) ~= "table" then
        for _,c in ipairs(Npc.classesToSave) do
            if c.name == class then
                class = c
                break
            end
        end
    end

    -- Remove all
    if class.remove then
        for _,v in ipairs(class.get()) do
            class.remove(v)
        end
    end

    -- Restore all
    if class.create and class.saveFields or not class.remove and not class.create and class.getByIndex then
        for index,fields in ipairs(Npc.savedClasses[class.name]) do
            local v
            if class.create then
                v = class.create(fields)
            elseif class.getByIndex then
                local idx = index
                if class.startFromZero then
                    idx = idx-1
                end

                v = class.getByIndex(idx)
            end

            if v and (v.isValid ~= false) then
                for _,w in ipairs(class.saveFields) do
                    if type(w) == "table" then -- For memory offsets
                        v:mem(w[1],w[2],fields[w[1]])
                    else
                        v[w] = fields[w]
                    end
                end
                if class.extraRestore then
                    class.extraRestore(v,fields)
                end
            end
        end
    end
end



function Npc.onInitAPI()
    registerEvent(Npc,"onTickEnd")
end

function Npc.onTickEnd()
    -- Save classes (this is done after onStart so custom stuff has already been initiated)
    if not Npc.hasSavedClasses then
        NPC.saveClass()
        Npc.hasSavedClasses = true
    end
end



return Npc