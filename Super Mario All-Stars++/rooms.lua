--[[
    
    rooms.lua (v1.2.1)
    by MrDoubleA


    Thanks to Enjl#6208 on Discord for a bit of help on making respawning NPCs actually work
    Thanks to Rednaxela#0380 on Discord for providing a handy function for getting the custom music path and help on resetting events
    Thanks to madeline#4345 on Discord, Chipss#9594 on Discord, 55jedat555#7302 on Discord and Wiimeiser on the SMBX Forums for reporting bugs

]]

local rooms = {}

if isOverworld then return end

-- Load a bunch of necessary libraries
local npcEventManager  = require("game/npceventmanager")
local configFileReader = require("configfilereader") -- (used for parsing music.ini files)
local lineguide        = require("lineguide")

local switch           = require("blocks/ai/synced")
local megashroom       = require("mega/megashroom")
local starman          = require("starman/star")
local smashudsystem  = require("smashudsystem")

local time = 0
local lifelost = false

-- Declare constants
rooms.TRANSITION_TYPE_NONE     = 0
rooms.TRANSITION_TYPE_CONSTANT = 1
rooms.TRANSITION_TYPE_SMOOTH   = 2

rooms.RESPAWN_EFFECT_FADE          = 0
rooms.RESPAWN_EFFECT_MOSAIC        = 1
rooms.RESPAWN_EFFECT_DIAMOND       = 2
rooms.RESPAWN_EFFECT_DIAMOND_SWEEP = 3

rooms.CAMERA_STATE_NORMAL     = 0
rooms.CAMERA_STATE_TRANSITION = 1



rooms.rooms = {}

rooms.currentRoomIndex = nil
rooms.enteredRoomPos = nil
rooms.spawnPosition = nil

rooms.hasSavedClasses = false

rooms.cameraInfo = {
    state = rooms.CAMERA_STATE_NORMAL,
    startPos = nil,transitionPos = nil,
}

rooms.respawnTimer = nil
rooms.resetTimer = 0


--[[
    NPCs with special behaviour when respawning. Each should be a table with one or more of these properties.

    despawn        (boolean)   Whether or not this NPC gets killed when resetting.
    respawn        (boolean)   Whether or not this NPC gets created again when respawned.

    onStart        (function)  A function run whenever the level starts, which is slightly before it gets saved. Its first argument is the NPC itself.
    extraSave      (function)  A function run whenever this NPC gets saved. Its first argument is the NPC itself, and its second is the saved fields.
    extraRestore   (function)  A function run whenever this NPC gets restored. Its first argument is the NPC itself, and its second is the saved fields.
]]

rooms.npcResetProperties = {
    -- Monty moles
    [309] = {
        onStart = (function(v)
            local roomsData = v.data._rooms

            roomsData.startedFriendly = v.friendly
        end),
        extraSave = (function(v,fields)
            local roomsData = v.data._rooms

            fields.friendly = (roomsData and roomsData.startedFriendly)
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


local currentlyPlayingMusic
local hasPausedMusic
local raisingMusicVolume

local vanillaMusicPaths = {}
local possibleMusicIniPaths = {getSMBXPath(),Misc.episodePath(),Misc.levelPath()}

local colBox = Colliders.Box(0,0,0,0)

-- Memory offsets because me no like big number (:
local PSWITCH_TIMER_ADDR   = 0x00B2C62C
local STOPWATCH_TIMER_ADDR = 0x00B2C62E

local CONVEYER_DIRECTION = 0x00B2C66C -- I believe this is the first documentation for this address lol

local GM_SIZABLE_LIST_ADDR = mem(0xB2BED8, FIELD_DWORD)
local GM_SIZABLE_COUNT_ADDR = 0xB2BEE4

local function tableMultiInsert(tbl,tbl2)
    for _,v in ipairs(tbl2) do
        table.insert(tbl,v)
    end
    return tbl
end

local function boundCamToRoom(room)
    return math.clamp(camera.x,room.collider.x,room.collider.x+room.collider.width-camera.width),math.clamp(camera.y,room.collider.y,room.collider.y+room.collider.height-camera.height)
end


local NEW_EVENT = mem(0xB2D6E8,FIELD_DWORD)
local NEW_EVENT_DELAY = mem(0xB2D704,FIELD_DWORD)
local NEW_EVENT_NUM = 0xB2D710

local EVENTS_ADDR = mem(0x00B2C6CC,FIELD_DWORD)
local EVENTS_STRUCT_SIZE = 0x588

local MAX_EVENTS = 255

local function resetEvents()
    -- Reset event timers (huge thanks to Rednaxela for helping on this!)
    mem(NEW_EVENT_NUM,FIELD_WORD,0)

    -- Trigger autostart events
    for idx=0,MAX_EVENTS-1 do
        local name = mem(EVENTS_ADDR+(idx*EVENTS_STRUCT_SIZE)+0x04,FIELD_STRING)

        if #name == 0 then
            break
        end


        local isAutoStart = mem(EVENTS_ADDR+(idx*EVENTS_STRUCT_SIZE)+0x586,FIELD_BOOL)

        if name == "Level - Start" or isAutoStart then -- If it set to autostart or is the level start event, trigger
            triggerEvent(name)
        end
    end
end

local function blockSpawnWithSizeableOrdering(id,x,y)
    local v = Block.spawn(math.max(1,id),x,y)

    if id <= 0 then -- Account for block ID of 0
        v.id = id
        v.width = 32
        v.height = 32
    end


    if Block.config[v.id] and Block.config[v.id].sizeable then -- If this block is a sizeable
        -- Block.spawn puts sizeables at the very top of the block array, so we need some additional sorting
        local sizeableCount = mem(GM_SIZABLE_COUNT_ADDR,FIELD_WORD)

        for idx=0,sizeableCount-2 do -- Go through the sizeable array
            local w = Block(mem(GM_SIZABLE_LIST_ADDR+(idx*0x02),FIELD_WORD)) -- Get the block itself

            if w and w.isValid and w.y > v.y then -- If this block is lower than the spawned block
                for idx2=sizeableCount-1,idx+1,-1 do -- Move everything up one index
                    mem(GM_SIZABLE_LIST_ADDR+(idx2*0x02),FIELD_WORD,mem(GM_SIZABLE_LIST_ADDR+((idx2-1)*0x02),FIELD_WORD))
                end

                mem(GM_SIZABLE_LIST_ADDR+(idx*0x02),FIELD_WORD,v.idx) -- Insert this block into the sizeable array

                break
            end
        end
    end

    return v
end



local function updateSpawnPosition()
    rooms.spawnPosition = rooms.spawnPosition or {}

    rooms.spawnPosition.x = player.x+(player.width/2)
    rooms.spawnPosition.y = player.y+(player.height )
    rooms.spawnPosition.section = player.section

    rooms.spawnPosition.direction = player.direction

    rooms.spawnPosition.checkpoint = nil
end


local buffer = Graphics.CaptureBuffer(800,600)

local mosaicShader = Shader()
mosaicShader:compileFromFile(nil,Misc.multiResolveFile("fuzzy_pixel.frag","shaders/npc/fuzzy_pixel.frag"))

function rooms.mosaicEffect(level,priority)
    buffer:captureAt(priority or 0)

    Graphics.drawScreen{
        texture = buffer,
        shader = mosaicShader,
        priority = priority or 0,
        uniforms = {pxSize = {camera.width/level,camera.height/level}}
    }
end

-- rooms.warpToRoom(room,respawnPointIndex)
-- OR
-- rooms.warpToRoom(room,respawnPointX,respawnPointY)

function rooms.warpToRoom(room,x,y)
    if type(room) == "number" then
        room = rooms.rooms[room]
    end
    if not room then error("Invalid room to warp to.") end

    local foundCount = 0
    local c

    for _,v in ipairs(BGO.getIntersecting(room.collider.x,room.collider.y,room.collider.x+room.collider.width,room.collider.y+room.collider.height)) do
        if rooms.respawnBGODirections[v.id] then
            if not y then
                foundCount = foundCount + 1

                if foundCount == x then
                    c = v
                    break
                end
            elseif not c or (math.abs(x-(v.x+(v.width/2)))+math.abs(y-(v.y+(v.width/2)))) < (math.abs(x-(c.x+(c.width/2)))+math.abs(y-(c.y+(c.width/2)))) then
                c = v
            end
        end
    end

    if c then
        player.x = (c.x+(c.width/2))-(player.width/2)
        player.y = (c.y+c.height-player.height)

        player.direction = rooms.respawnBGODirections[c.id]
        player.section = room.section
    else
        error("Failed to find valid respawn point.")
    end
end


--[[

    So, in case you want to make your own thing to go into this table for whatever reason, here's a little bit of documentation on what each field does.

    name          (string)    How it's internally referred as in the "savedClasses" table, and how you refer to it when using rooms.restoreClass.
    get           (function)  A function which should return a table of all the objects in the class, like, say, NPC.get().
    getByIndex    (function)  A function which should return an object of the class at the index of the first argument, like, say, NPC(index).
    
    saveFields    (table)     A list of fields to be saved and restored. Can either be a string (with the field's name) or a table (of a memory offset and memory type).
    extraSave     (function)  A function which is run after saving all fields. The first argument is the object, and the second argument is the table of fields already saved.
    extraRestore  (function)  A function which is run after restoring all fields. The first argument is the object, and the second argument is the table of fields already saved.
    
    remove        (function)  A function which should remove the object in the first argument.
    create        (function)  A function which should create an object based on the fields in the first argument.

    startFromZero (boolean)   Whether or not the array returned by getByIndex starts from zero.

]]
rooms.classesToSave = {
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

            local properties = rooms.npcResetProperties[v.id]

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


            local properties = rooms.npcResetProperties[v.id]

            if properties ~= nil and properties.extraRestore ~= nil then
                properties.extraRestore(v,fields)
            end
        end),
        
        remove = (function(v)
            if (NPC.COLLECTIBLE_MAP[v.id] and not rooms.collectiblesRespawn) then return end -- Don't do this for collectibles, if set

            local properties = rooms.npcResetProperties[v.id]

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
            if (NPC.COLLECTIBLE_MAP[fields.id] and not rooms.collectiblesRespawn) then return end -- Don't do this for collectibles, if set
            if fields.spawnId == 0 or fields.layerName == "Spawned NPCs" or fields.isOrbitingNPC then return end -- If set not to respawn or on the spawned NPCs layer, stop
            
            local properties = rooms.npcResetProperties[fields.spawnId]

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

rooms.savedClasses = {}


function rooms.saveClass(class)
    -- If no class is provided, save all classes
    if class == nil then
        for _,c in ipairs(rooms.classesToSave) do
            rooms.saveClass(c.name)
        end
        return
    end

    -- Convert name to the actual class
    if type(class) ~= "table" then
        for _,c in ipairs(rooms.classesToSave) do
            if c.name == class then
                class = c
                break
            end
        end
    end

    -- Create a table for this class
    rooms.savedClasses[class.name] = {}

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

        table.insert(rooms.savedClasses[class.name],fields)
    end
end

function rooms.restoreClass(class)
    -- If no class is provided, restore all classes
    if class == nil then
        for _,c in ipairs(rooms.classesToSave) do
            rooms.restoreClass(c.name)
        end
        return
    end

    if not rooms.savedClasses[class] then return end -- Don't attempt to restore it if it hasn't been saved yet

    -- Convert name to the actual class
    if type(class) ~= "table" then
        for _,c in ipairs(rooms.classesToSave) do
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
        for index,fields in ipairs(rooms.savedClasses[class.name]) do
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

function rooms.reset(fromRespawn)
    EventManager.callEvent("onBeforeReset",not not fromRespawn)

    -- Reset p-switch
    if rooms.blocksReset and mem(PSWITCH_TIMER_ADDR,FIELD_DWORD) > 0 then
        Misc.doPSwitch(false)
    elseif rooms.blocksReset then
        Misc.doPSwitchRaw(false)
    end

    -- Reset stopwatch
    mem(STOPWATCH_TIMER_ADDR,FIELD_WORD,0)
    Defines.levelFreeze = false

    mem(CONVEYER_DIRECTION,FIELD_WORD,1) -- Reset the direction of conveyer belts

    NPC.config[274].score = 6 -- Reset dragon coin score (why did you do it this way, redigit)


    
    -- Reset timed events and re-trigger autostart ones
    resetEvents()

    -- Reset the classes (may be worth removing the blocksReset option?)
    rooms.restoreClass("NPC")
    rooms.restoreClass("BGO")

    rooms.restoreClass("Liquid")
    rooms.restoreClass("Warp")

    rooms.restoreClass("Layer")
    rooms.restoreClass("Section")

    if rooms.blocksReset then
        rooms.restoreClass("Block")
    end

    player:mem(0xB8,FIELD_WORD,0) -- Yoshi NPC

    -- Remove effects
    for _,v in ipairs(Effect.get()) do
        v.x,v.y,v.speedX,v.speedY,v.timer = 0,0,0,0,0

        if v.kill then
            v:kill()
        end
    end

    if switch.state then switch.toggle() end -- Reset synced switches

    if fromRespawn then -- Things which shouldn't reset on room transition
        -- Reset star coins
        if rooms.starCoinsReset then
            local starCoinData = SaveData._basegame.starcoin[Level.filename()] or {}

            for k,v in ipairs(starCoinData) do
                if v == 3 then
                    starCoinData[k] = 0
                end
            end
        end

        -- Reset timer
        if Timer and Level.settings.timer and Level.settings.timer.enable then
            Timer.activate(Level.settings.timer.time)
        end

        -- Reset mega mushroom and starman
        megashroom.StopMega(w,false)
        starman.stop(w)
    end

    EventManager.callEvent("onReset",not not fromRespawn)
end

function rooms.onInitAPI()
    registerEvent(rooms,"onTick")
    registerEvent(rooms,"onTickEnd")

    registerEvent(rooms,"onStart")
    registerEvent(rooms,"onCameraUpdate")

    registerEvent(rooms,"onDraw")
    registerEvent(rooms,"onInputUpdate")

    registerEvent(rooms,"onDraw","updateEventManager",true)

    registerEvent(rooms,"onCheckpoint")
end

function rooms.onCheckpoint(v,p)
    if rooms.spawnPosition then
        rooms.spawnPosition.checkpoint = v
    end
end

function rooms.onStart()
    -- Convert quicksand to rooms
    for _,v in ipairs(Liquid.get()) do
        if v.layerName == (rooms.roomLayerName or "Rooms") then
            local room = {}

            room.collider = Colliders.Box(v.x,v.y,v.width,v.height)

            if room.collider.height == 608 then
                -- Make it smaller to fit the size of the screen in case it's 608 pixels tall.
                room.collider.y = room.collider.y + 8
                room.collider.height = 600
            end

            if room.collider:collide(player) and not rooms.currentRoomIndex then
                rooms.currentRoomIndex = #rooms.rooms+1
                rooms.enteredRoomPos = {player.x+(player.width/2),player.y+(player.height/2)}

                EventManager.callEvent("onRoomEnter",rooms.currentRoomIndex)
            end

            room.section = Section.getIdxFromCoords(room.collider)
            

            table.insert(rooms.rooms,room)
        end
    end

    -- Hide the rooms layer
    local l = Layer.get(rooms.roomLayerName or "Rooms")
    if l then
        l:hide(false)
    end



    if rooms.quickRespawn then
        -- If quick respawn is active, replace death sound effect
        if not rooms.deathSoundEffect then
            Audio.sounds[8].muted = true
        elseif type(rooms.deathSoundEffect) == "number" then
            extrasounds.sound.sfx[8] = Audio.sounds[rooms.deathSoundEffect].sfx
        elseif type(rooms.deathSoundEffect) == "string" then
            extrasounds.sound.sfx[8] = SFX.open(Misc.resolveSoundFile(rooms.deathSoundEffect))
        else
            extrasounds.sound.sfx[8] = rooms.deathSoundEffect
        end

        if not rooms.dontPlayMusicThroughLua then
            --Audio.SeizeStream(-1)
        end


        -- Extra stuff
        for _,v in ipairs(NPC.get()) do
            v.data._rooms = v.data._rooms or {}
            local roomsData = v.data._rooms

            local properties = rooms.npcResetProperties[v.id]

            if properties ~= nil and properties.onStart ~= nil then
                properties.onStart(v)
            end
        end
    end

    -- Get music paths for vanilla music
    for k,v in ipairs(possibleMusicIniPaths) do
        if io.exists(v.. "\\music.ini") then -- If there's a music.ini file here
            for _,w in ipairs(configFileReader.parseWithHeaders(v.. "\\music.ini",{})) do -- Go through each entry
                if w._header and w.file then -- If this entry is actually valid
                    local filename = w.file
                    local metadataStart = filename:find("|") -- Get where the metadata (used by spc's and whatnot) starts, if it exists

                    if metadataStart then
                        filename = filename:sub(1,metadataStart-1) -- Cut out the metadeta
                    end

                    if io.exists(v.. "\\".. filename) then
                        vanillaMusicPaths[w._header] = v.. "\\".. w.file -- Insert it into the table for music paths
                    end
                end
            end
        end
    end
    

    updateSpawnPosition()
end

function rooms.onTick()
    local collided

    local currentRoom = rooms.rooms[rooms.currentRoomIndex]

    if currentRoom == nil or not currentRoom.collider:collide(player) then -- If the player is still in the current room, don't bother searching
        -- Search for a room
        for index,room in ipairs(rooms.rooms) do
            if room.section == player.section and room.collider:collide(player) then
                if collided == nil then
                    collided = index
                else
                    collided = nil
                    break
                end
            end
        end
    end


    if collided ~= nil and collided ~= rooms.currentRoomIndex then
        if rooms.resetOnEnteringRoom then
            rooms.reset(false)
        end

        if rooms.transitionType ~= rooms.TRANSITION_TYPE_NONE and not rooms.respawnTimer and (not rooms.rooms[rooms.currentRoomIndex] or rooms.rooms[collided].section == rooms.rooms[rooms.currentRoomIndex].section) then
            rooms.cameraInfo.state = rooms.CAMERA_STATE_TRANSITION

            if rooms.rooms[rooms.currentRoomIndex] then
                rooms.cameraInfo.startPos = {boundCamToRoom(rooms.rooms[rooms.currentRoomIndex])}
                rooms.cameraInfo.transitionPos = {boundCamToRoom(rooms.rooms[rooms.currentRoomIndex])}
            else
                rooms.cameraInfo.startPos = {camera.x,camera.y}
                rooms.cameraInfo.transitionPos = {camera.x,camera.y}
            end

            if rooms.jumpUpOnTransition then
                colBox.x = rooms.rooms[collided].collider.x
                colBox.y = rooms.rooms[collided].collider.y+rooms.rooms[collided].collider.height-24
                colBox.width = rooms.rooms[collided].collider.width
                colBox.height = 24

                if colBox:collide(player) then
                    player:mem(0x176,FIELD_WORD,0) -- Reset standing NPC
                    player:mem(0x11C,FIELD_WORD,0) -- Reset jump force

                    player.speedY = -10
                end
            end

            Misc.pause()
        else
            EventManager.callEvent("onRoomEnter",collided)
        end

        rooms.currentRoomIndex = collided
        rooms.enteredRoomPos = {player.x+(player.width/2),player.y+(player.height/2)}
    end

    if rooms.quickRespawn then
        if rooms.checkpointOnEnterSection and rooms.spawnPosition and rooms.spawnPosition.section ~= player.section and (player.forcedState == 0 and player.deathTimer == 0 and not player:mem(0x13C,FIELD_BOOL)) then
            updateSpawnPosition()
        end

        if player.deathTimer > 0 and not rooms.respawnTimer then
            if rooms.deathEarthquake > 0 then
                Defines.earthquake = rooms.deathEarthquake
            end

            rooms.respawnTimer = 0

            Level.winState(0)

            if rooms.pauseOnRespawn then
                Misc.pause()
            end
        end
    end
    if lifelost == true then
        SaveData.totalLives = SaveData.totalLives - 1
        if SaveData.totalLives < 0 then
            SaveData.totalLives = 5
        end
        lifelost = false
    end
end

function rooms.onTickEnd()
    -- Save classes (this is done after onStart so custom stuff has already been initiated)
    if not rooms.hasSavedClasses then
        rooms.saveClass()
        rooms.hasSavedClasses = true
    end
end

local finished = false

function rooms.onDraw()
    if rooms.quickRespawn and not rooms.dontPlayMusicThroughLua then
        local newMusic

        if mem(STOPWATCH_TIMER_ADDR,FIELD_WORD) > 0 then -- Stopwatch music
            newMusic = vanillaMusicPaths["special-music-2"]
        elseif mem(PSWITCH_TIMER_ADDR,FIELD_WORD) > 0 then -- P-switch music
            newMusic = vanillaMusicPaths["special-music-1"]
        elseif player.sectionObj.musicID == 24 then -- Custom music
            newMusic = Misc.episodePath().. player.sectionObj.musicPath
        elseif player.sectionObj.musicID > 0 then -- Vanilla music
            newMusic = vanillaMusicPaths["level-music-".. tostring(player.sectionObj.musicID)]
        end
        
        if player.deathTimer == 1 then
            if newMusic ~= currentlyPlayingMusic or (Audio.MusicIsPlaying() == not newMusic) then
                if newMusic ~= nil then
                    Audio.MusicOpen(newMusic)
                    Audio.MusicPlay()
                else
                    Audio.MusicResume()
                end

                currentlyPlayingMusic = newMusic
            end
        end

        if Level.winState() == 0 and not player.hasStarman and not player.isMega then
            if hasPausedMusic then
                Audio.MusicResume()
                Audio.MusicVolume(0)

                raisingMusicVolume = true
                hasPausedMusic = false
            end

            if raisingMusicVolume then
                Audio.MusicVolume(math.min(64,Audio.MusicVolume() + 1))

                raisingMusicVolume = (Audio.MusicVolume() < 64)
            end
        elseif not Audio.MusicIsPaused() then
            Audio.MusicPause()
            hasPausedMusic = true
        end
    end

    if rooms.respawnTimer then
        local canReset = false
        finished = false

        local out = (rooms.resetTimer-rooms.respawnBlankTime)

        if rooms.respawnEffect == rooms.RESPAWN_EFFECT_FADE or rooms.respawnEffect == rooms.RESPAWN_EFFECT_MOSAIC then
            local o,m

            if rooms.respawnEffect == rooms.RESPAWN_EFFECT_FADE then
                if out > 0 then
                    o = (1-(out/16))
                else
                    o = (rooms.respawnTimer/16)
                end
            elseif rooms.respawnEffect == rooms.RESPAWN_EFFECT_MOSAIC then
                if out > 0 then
                    o = (1-(out/32))
                    m = (48-(out*2))
                else
                    o = (rooms.respawnTimer/32)
                    m = (rooms.respawnTimer*1.75)
                end
            end

            if o and o > 0 then
                Graphics.drawBox{
                    x = 0,y = 0,width = camera.width,height = camera.height,
                    color = Color.black.. o,priority = 5,
                }
            end
            if m and m > 1 then
                rooms.mosaicEffect(m,-54)
            end

            if o >= 1 then
                canReset = true
            elseif o <= 0 and out > 0 then
                finished = true
            end
        elseif rooms.respawnEffect == rooms.RESPAWN_EFFECT_DIAMOND then
            local s

            if out > 0 then
                s = (math.max(camera.width,camera.height)-(out*24))
            else
                s = (rooms.respawnTimer*24)
            end

            if s and s > 0 then
                Graphics.glDraw{
                    vertexCoords = {
                        (camera.width/2)  ,(camera.height/2)-s,
                        (camera.width/2)+s,(camera.height/2)  ,
                        (camera.width/2)  ,(camera.height/2)+s,
                        (camera.width/2)-s,(camera.height/2)  ,
                        (camera.width/2)  ,(camera.height/2)-s,
                    },
                    color = Color.black,primitive = Graphics.GL_TRIANGLE_STRIP,priority = 5,
                }
            end

            if s >= math.max(camera.width,camera.height) then
                canReset = true
            elseif s <= 0 and out > 0 then
                finished = true
            end
        elseif rooms.respawnEffect == rooms.RESPAWN_EFFECT_DIAMOND_SWEEP then
            local width,height = 20,20

            local horCount = math.ceil(camera.width /width )
            local verCount = math.ceil(camera.height/height)

            local doneAll,renderedNone = true,true

            local vertexCoords = {}

            for x=0,horCount-1 do
                for y=0,verCount-1 do
                    local xPosition = (camera.width /2)-((horCount*width )/2)+(x*width )+(width /2)
                    local yPosition = (camera.height/2)-((verCount*height)/2)+(y*height)+(height/2)

                    local currentWidth,currentHeight
                    if out > 0 then
                        currentWidth  = math.max(0,(width *2)-(((out*48)-((x+y)*12))/horCount))
                        currentHeight = math.max(0,(height*2)-(((out*48)-((x+y)*12))/verCount))
                    else
                        currentWidth  = math.clamp((((rooms.respawnTimer*48)-((x+y)*12))/horCount),0,width *2)
                        currentHeight = math.clamp((((rooms.respawnTimer*48)-((x+y)*12))/verCount),0,height*2)
                    end

                    if currentWidth > 0 and currentHeight > 0 then
                        tableMultiInsert(vertexCoords,{
                            xPosition-(currentWidth/2),yPosition                  ,
                            xPosition                 ,yPosition-(currentHeight/2),
                            xPosition+(currentWidth/2),yPosition                  ,
                            xPosition-(currentWidth/2),yPosition                  ,
                            xPosition                 ,yPosition+(currentHeight/2),
                            xPosition+(currentWidth/2),yPosition                  ,
                        })

                        renderedNone = false
                    end

                    if currentWidth < width*2 or currentHeight < height*2 then
                        doneAll = false
                    end
                end
            end

            Graphics.glDraw{vertexCoords = vertexCoords,color = Color.black,priority = 5}

            if out > 0 and renderedNone then
                finished = true
            elseif doneAll then
                canReset = true
            end
        end

        rooms.respawnTimer = rooms.respawnTimer + 1

        if canReset or rooms.resetTimer > 0 then
            rooms.resetTimer = (rooms.resetTimer or 0) + 1
        end

        if rooms.resetTimer == math.floor(rooms.respawnBlankTime/2)-1 then
            EventManager.callEvent("onRespawnReset") -- (onRespawnReset is now "deprecated")
        elseif rooms.resetTimer == math.floor(rooms.respawnBlankTime/2) then
            -- Reset player
            if rooms.rooms[rooms.currentRoomIndex] and not rooms.neverUseRespawnBGOs then
                rooms.warpToRoom(rooms.currentRoomIndex,rooms.enteredRoomPos[1],rooms.enteredRoomPos[2])
            elseif rooms.spawnPosition then
                local cp = rooms.spawnPosition.checkpoint

                if cp then
                    player.x = ((cp.x   )-(player.width/2))
                    player.y = ((cp.y+32)-(player.height ))
                    player.section = cp.section
                else
                    player.x = (rooms.spawnPosition.x-(player.width/2))
                    player.y = (rooms.spawnPosition.y-(player.height ))
                    player.section = rooms.spawnPosition.section
                end

                player.direction = rooms.spawnPosition.direction
            else
                error("Failed to find valid respawn point.")
            end

            player.speedX,player.speedY = 0,0

            player:mem(0x2C,FIELD_DFLOAT,0) -- Climbing NPC
            player:mem(0x40,FIELD_WORD,0)   -- Climbing state
            player:mem(0x154,FIELD_WORD,0)  -- Held NPC
            player:mem(0x176,FIELD_WORD,0)  -- Stood on NPC

            player:mem(0x11E,FIELD_BOOL,false) -- Can jump
            player:mem(0x120,FIELD_BOOL,false) -- Can spin jump

            player:mem(0x50,FIELD_BOOL,false) -- Spinjumping flag
            player:mem(0x11C,FIELD_WORD,0)    -- Jump force
            player:mem(0x140,FIELD_WORD,0)    -- Invincibility frames

            player:mem(0x146,FIELD_WORD,0) -- Bottom collision state
            player:mem(0x148,FIELD_WORD,0) -- Left collision state
            player:mem(0x14A,FIELD_WORD,0) -- Top collision state
            player:mem(0x14C,FIELD_WORD,0) -- Right collision state
            player:mem(0x14E,FIELD_WORD,0) -- Layer push state

            player.deathTimer = 0
            player.forcedState = 0

            player.frame = 1

            -- Reset everything else
            rooms.reset(true)
        end

        -- Stop the death timer from progressing further
        if player.deathTimer > 0 then
            player.deathTimer = 1
            lifelost = true
        end
    end
end

function rooms.onInputUpdate() -- Unpausing should be done from onInputUpdate, apparently, so here we are.
    if rooms.respawnTimer then
        if finished then
            finished = false
    
            player.deathTimer = 0
    
            rooms.respawnTimer = nil
            rooms.resetTimer = 0
    
            if rooms.pauseOnRespawn then
                Misc.unpause()
            end
        elseif rooms.resetTimer > 0 and rooms.resetTimer == math.floor(rooms.respawnBlankTime/2)-2 and rooms.pauseOnRespawn then
            Misc.unpause()
        elseif rooms.resetTimer > 0 and rooms.resetTimer == math.floor(rooms.respawnBlankTime/2)+1 and rooms.pauseOnRespawn then
            Misc.pause()
        end
    end
end

function rooms.onCameraUpdate()
    local currentRoom = rooms.rooms[rooms.currentRoomIndex]

    if currentRoom then
        if rooms.cameraInfo.state == rooms.CAMERA_STATE_NORMAL then
            camera.x,camera.y = boundCamToRoom(currentRoom)
        elseif rooms.cameraInfo.state == rooms.CAMERA_STATE_TRANSITION then
            local goal = {boundCamToRoom(currentRoom)}

            if rooms.transitionType == rooms.TRANSITION_TYPE_CONSTANT or rooms.transitionType == rooms.TRANSITION_TYPE_SMOOTH then
                for i=1,2 do
                    local speed
                    if rooms.transitionType == rooms.TRANSITION_TYPE_CONSTANT then
                        speed = ((goal[i]-rooms.cameraInfo.startPos[i])*rooms.transitionSpeeds[rooms.transitionType])
                    elseif rooms.transitionType == rooms.TRANSITION_TYPE_SMOOTH then
                        speed = ((goal[i]-rooms.cameraInfo.transitionPos[i])*rooms.transitionSpeeds[rooms.transitionType])
                    end

                    if rooms.cameraInfo.transitionPos[i] > goal[i] then
                        rooms.cameraInfo.transitionPos[i] = math.max(goal[i],rooms.cameraInfo.transitionPos[i]+speed)
                    elseif rooms.cameraInfo.transitionPos[i] < goal[i] then
                        rooms.cameraInfo.transitionPos[i] = math.min(goal[i],rooms.cameraInfo.transitionPos[i]+speed)
                    end
                end
            end

            camera.x,camera.y = rooms.cameraInfo.transitionPos[1],rooms.cameraInfo.transitionPos[2]

            if (math.abs(goal[1]-rooms.cameraInfo.transitionPos[1])+math.abs(goal[2]-rooms.cameraInfo.transitionPos[2])) < 2 then
                rooms.cameraInfo.state = rooms.CAMERA_STATE_NORMAL

                rooms.cameraInfo.startPos,rooms.cameraInfo.transitionPos = nil,nil

                Misc.unpause()

                EventManager.callEvent("onRoomEnter",rooms.currentRoomIndex)
            end
        end
    end
end

function rooms.updateEventManager()
    -- Fix to make onDrawNPC run properly during the room transition
    npcEventManager.update()
end



---- SETTINGS BEYOND HERE ----

-- Quick respawn related stuff --

-- Quick respawn, like in Celeste.
rooms.quickRespawn = false
-- Whether or not collectibles (coins, mushrooms, 1-ups, etc) respawn after dying (only affects quick respawn).
rooms.collectiblesRespawn = false
-- Whether or not blocks reset themselves and the p-switch effect resets after dying (only affects quick respawn).
rooms.blocksReset = false
-- Whether or not non-saved star coins will reset after dying (only affects quick respawn).
rooms.starCoinsReset = false
-- Whether or not to create a pseudo "checkpoint" on entering a different section.
rooms.checkpointOnEnterSection = false
-- Whether or not everything is reset on entering a room.
rooms.resetOnEnteringRoom = false

-- Sound effect to be played upon death. Set to nil for none, a number for a vanilla sound effect (see https://wohlsoft.ru/pgewiki/SFX_list_(SMBX64) for a list of IDs) or a string for a file.
rooms.deathSoundEffect = 54
-- How big the "earthquake" effect is upon death. Set to 0 for none.
rooms.deathEarthquake = 0
-- Whether or not the game is paused during the respawn transition.
rooms.pauseOnRespawn = true

-- The type of effect during the quick respawn transition. It can be "rooms.RESPAWN_EFFECT_FADE", "rooms.RESPAWN_EFFECT_MOSAIC", "rooms.RESPAWN_EFFECT_DIAMOND" or "rooms.RESPAWN_EFFECT_DIAMOND_SWEEP".
rooms.respawnEffect = rooms.RESPAWN_EFFECT_MOSAIC
-- How long the screen is "blank" during the respawn transition. Should be at least 6 to work properly.
rooms.respawnBlankTime = 16

-- When using quick respawn, music will be played via lua. However, this can cause problems with other music played through lua, so you can enable this option to disable the automatic music playing.
rooms.dontPlayMusicThroughLua = false

-- When enabled, the respawn BGOs inside a room won't be used.
rooms.neverUseRespawnBGOs = false
-- The direction that the player will face upon respawning on the BGO.
--rooms.respawnBGODirections = {[851] = DIR_RIGHT,[852] = DIR_LEFT}


-- Room transition related stuff --

-- The type of effect used to transition between rooms. It can be "rooms.TRANSITION_TYPE_NONE", "rooms.TRANSITION_TYPE_CONSTANT" or "rooms.TRANSITION_TYPE_SMOOTH".
rooms.transitionType = rooms.TRANSITION_TYPE_CONSTANT
-- The speed of each room transition effect.
rooms.transitionSpeeds = {
    [rooms.TRANSITION_TYPE_CONSTANT] = 0.012,
    [rooms.TRANSITION_TYPE_SMOOTH]   = 0.005,
}
-- Whether or not to give the player upwards force when entering a room from the bottom.
rooms.jumpUpOnTransition = true


-- The name of the layer which rooms should be placed on.
rooms.roomLayerName = "Rooms"


return rooms