--[[

    Minecraft Steve Playable
    by MrDoubleA

    See steve.lua for full credits

]]

local npcManager = require("npcManager")
local npcutils = require("npcs/npcutils")

local lib3d = require("lib3d")
local steve = require("steve")


local droppedItem = {}


steve.droppedItem = droppedItem -- make this library accessible to the main one, since loading it from there would cause a stack overflow


droppedItem.npcPowerupMap = {
    [9]   = PLAYER_BIG,
    [14]  = PLAYER_FIREFLOWER,
    [34]  = PLAYER_LEAF,
    [169] = PLAYER_TANOOKIE,
    [170] = PLAYER_HAMMER,
    [182] = PLAYER_FIREFLOWER,
    [183] = PLAYER_FIREFLOWER,
    [184] = PLAYER_BIG,
    [185] = PLAYER_BIG,
    [249] = PLAYER_BIG,
    [264] = PLAYER_ICE,
    [277] = PLAYER_ICE,
    --[462] = PLAYER_BIG,
}


droppedItem.meshes = {}
droppedItem.camera = nil


droppedItem.idList = {}
droppedItem.idMap  = {}

function droppedItem.register(npcID)
    npcManager.registerEvent(npcID, droppedItem, "onTickNPC")
    npcManager.registerEvent(npcID, droppedItem, "onDrawNPC")

    table.insert(droppedItem.idList,npcID)
    droppedItem.idMap[npcID] = true
end



local function initialiseNPC(v,data)
    if data.itemData == nil then
        data.itemData = {type = "block",count = 1,blockID = v.ai2}
    end

    if (data.mesh == nil or not data.mesh.isValid) then
        local mesh,material = steve.createItemMesh(data.itemData.type,true)

        data.mesh = mesh

        table.insert(droppedItem.meshes,{v,mesh})


        if droppedItem.camera == nil then
            droppedItem.camera = lib3d.Camera{renderscale = 1,projection = lib3d.projection.ORTHO}
            droppedItem.camera.transform.position.z = -droppedItem.camera.flength
        end
    end


    if data.initialised then return end


    if data.itemData.type == "block" then
        data.collectCooldown = 32
    else
        data.collectCooldown = 0
    end

    data.rotation = 0

    data.sineTimer = 0
    data.yOffset = 0


    data.initialised = true
end

local function collectNPC(v,data)
    local successful = true

    if data.itemData.type == "block" then
        successful = steve.collectItem(data.itemData)
    elseif data.itemData.type == "powerup" then
        steve.upgradeTools(data.itemData.powerupID)
    end


    if successful then
        SFX.play(RNG.irandomEntry(droppedItem.collectionSounds))
        v:kill(HARM_TYPE_VANISH)
    end
end


function droppedItem.onTickNPC(v)
    if Defines.levelFreeze then return end
    
    local data = v.data
    
    if v.despawnTimer <= 0 then
        data.initialised = false
        return
    end

    initialiseNPC(v,data)
    
    -- Collecting
    if data.collectCooldown == 0 and (player.character == CHARACTER_STEVE and player.deathTimer == 0) and player.holdingNPC ~= v and Colliders.collide(v,player) then
        collectNPC(v,data)
    end

    data.collectCooldown = math.max(0,data.collectCooldown-1)


    if v.collidesBlockBottom then
        v.speedX = 0
    end

    if v:mem(0x120,FIELD_BOOL) and (v.collidesBlockLeft or v.collidesBlockRight) then
        v.speedX = 0
    end
    v:mem(0x120,FIELD_BOOL,false)



    data.rotation = data.rotation + 1
    if data.itemData.type == "block" then
        data.rotation = ((data.rotation-45)%90)+45
    end
    
    data.sineTimer = data.sineTimer + 1
    data.yOffset = (math.cos(data.sineTimer/32)*6)-6
end

function droppedItem.onDrawNPC(v)
    if v.despawnTimer <= 0 or v.isHidden then return end

    local data = v.data

    initialiseNPC(v,data)
end


function droppedItem.onTickPowerup(v)
    if player.character == CHARACTER_STEVE then
        local powerupID = droppedItem.npcPowerupMap[v.id]
        local oldY,oldHeight = v.y,v.height

        v:transform(droppedItem.idList[1],true)

        
        local data = v.data

        data.itemData = {type = "powerup",count = 1,powerupID = powerupID}


        if v:mem(0x138,FIELD_WORD) == 1 then -- Coming out of the top of a block
            -- Restore old height
            v.y,v.height = oldY,oldHeight
        elseif powerupID == PLAYER_LEAF and v.speedY == -6 then -- A leaf coming out of the top of a block
            -- Come out normally instead of coming out like a leaf
            v.y = v.y + 32
            v.height = 0
            v.speedY = 0

            v:mem(0x138,FIELD_WORD,1)
            v:mem(0x13A,FIELD_WORD,0)
        end
    end
end


function droppedItem.onInitAPI()
    registerEvent(droppedItem,"onStart")
    registerEvent(droppedItem,"onCameraDraw")
end

function droppedItem.onCameraDraw()
    if droppedItem.camera == nil or droppedItem.meshes[1] == nil then
        return
    end


    -- Prepare all the meshes
    for i = #droppedItem.meshes, 1, -1 do
        local obj = droppedItem.meshes[i]
        local v = obj[1]
        local mesh = obj[2]

        if (not v.isValid or v.isHidden or v.despawnTimer <= 0 or not droppedItem.idMap[v.id]) or not mesh.isValid then
            if mesh.isValid then
                mesh:destroy()
            end

            table.remove(droppedItem.meshes,i)
        else
            local data = v.data

            mesh.transform.position = vector(v.x+(v.width/2),v.y+(v.height/2)+data.yOffset,0)
            mesh.transform.rotation = vector.quat(0,data.rotation,0)

            steve.setupItemMesh(mesh,data.itemData,false)
        end
    end

    -- Draw the scene
    droppedItem.camera.transform.position.x = camera.x+(camera.width *0.5)
    droppedItem.camera.transform.position.y = camera.y+(camera.height*0.5)

    droppedItem.camera:draw()
    Graphics.drawScreen{texture = droppedItem.camera.target,priority = -75}

    -- Make all the meshes inactive again
    for _,obj in ipairs(droppedItem.meshes) do
        obj[2].active = false
    end
end



function droppedItem.onStart()
    for _,id in ipairs(NPC.POWERUP) do
        local powerupID = droppedItem.npcPowerupMap[id]

        if powerupID ~= nil then
            npcManager.registerEvent(id, droppedItem, "onTickNPC", "onTickPowerup")
            npcManager.registerEvent(id, droppedItem, "onTickEndNPC", "onTickPowerup")
            npcManager.registerEvent(id, droppedItem, "onDrawNPC", "onTickPowerup")
        end
    end
end



droppedItem.collectionSounds = {
    SFX.open(Misc.resolveSoundFile("steve/pop_1")),
    SFX.open(Misc.resolveSoundFile("steve/pop_2")),
    SFX.open(Misc.resolveSoundFile("steve/pop_3")),
}


return droppedItem