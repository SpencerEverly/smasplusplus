
--[[******************************************************************************************
Code created originally by Waddle as an NPC known as "Titan Head", for a submission for the 2021 Diorama Contest, edited by me.
**********************************************************************************************]]

local statue = {}

local npcManager = require("npcManager")
local utils = require("npcs/npcutils")
local colliders = require("Colliders")

local npcID = NPC_ID

npcManager.setNpcSettings({
    id = npcID,
    gfxheight = 64,
    gfxwidth = 32,
    width = 32,
    height = 64,

    frames = 1,
    framestyle = 1,
    speed = 1,
    npcblock = true,
    npcblocktop = true,
    playerblock = true,
    playerblocktop = true,

    nohurt=true,
    nogravity = false,
    noblockcollision = false,
    nofireball = false,
    noiceball = true,
    noyoshi= true,
    nowaterphysics = false,
    jumphurt = false, 
    spinjumpsafe = false, 
    harmlessgrab = false, 
    harmlessthrown = false, 

    grabside=false,
    grabtop=false,
})

function statue.onInitAPI()
    npcManager.registerEvent(npcID, statue, "onTickNPC")
    npcManager.registerEvent(npcID, statue, "onEventNPC")
    npcManager.registerEvent(npcID, statue, "onTickEndNPC")
end

local rooms
pcall(function() rooms = require("rooms") end)

if rooms ~= nil then
    rooms.npcResetProperties[npcID] = {despawn = false, respawn = false}
end


function statue.onTickNPC(v)

    if Defines.levelFreeze then return end
    local data = v.data
    local settings = v.data._settings
    utils.applyLayerMovement(v)
    
    if not data.initialized then
        data.timer = data.timer or 0
        data.laserXY = settings.length / 2
        if v.direction == 1 then
            data.angle = 45
        else
            data.angle = 135
        end
        data.angledVector = vector(data.laserXY,0):rotate(data.angle) + 16
        data.sight = Colliders.Rect(v.x + v.width * 0.5 + 14 * v.direction + data.angledVector.x,
        v.y + v.height * 0.5 - 28 + data.angledVector.y,settings.length,4,data.angle)
        data.hitbox = colliders.Box(v.x, v.y, v.width, v.height - v.height / 1.1)
        
        data.initialized = true
    end
    
    data.sight.x = v.x + v.width * 0.5 * v.direction + data.angledVector.x
    data.sight.y = v.y + v.height * 0.5 - 28 + data.angledVector.y
    
    if Colliders.collide(data.sight,player) then
        local shoot = NPC.spawn(npcID + 1,v.x + v.width * 0.5 + 22 * v.direction,v.y + v.height * 0.5,player.section,false,true)
        shoot.direction = v.direction
        data.timer = 128
    else
        if settings.beam then
            data.timer = data.timer - 1
            if data.timer <= 0 then
                data.sight:Draw(Color.red)
            end
        end
    end
    
    for _,w in ipairs(NPC.get()) do
        if colliders.collide(w, data.hitbox) then
            if not v.collidesBlockBottom then
                w:harm(HARM_TYPE_NPC)
            end
        end
    end
    
    --[[rooms.npcResetProperties = {
    [npcID] = {despawn = false,respawn = false},
    }]]
    
end

function statue.onEventNPC(v, eventName)
    local data = v.data
    if eventName == "Level - Start" and v.id == npcID then
        data.timer = 0
    end
end

function statue.onTickEndNPC(v)

local data = v.data

if not data.initialized then
    data.initialized = true
    data.hitbox = data.hitbox or colliders.Box(v.x, v.y, v.width, v.height)
end
    data.hitbox.x = v.x
    data.hitbox.y = v.y + v.height - data.hitbox.height
end

return statue
