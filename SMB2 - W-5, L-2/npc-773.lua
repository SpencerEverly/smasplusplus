local npcManager = require("npcManager")
local npc = {}
local id = NPC_ID

npcManager.setNpcSettings({
    id = id,
    
    width = 338,
    gfxwidth = 338,
    height = 420,
    gfxheight = 420,
    
    jumphurt = true,
    nohurt = true,
    
    frames = 1,
    
    nogravity = true,
    noblockcollision = true,
    
    wheelheight = 248,
    
    speed = 1.25,
    platformId = id + 1,
    
    noiceball = true,
    noyoshi = true,
})

function npc.onInitAPI()
    npcManager.registerEvent(id, npc, 'onCameraDrawNPC')
    npcManager.registerEvent(id, npc, 'onTickEndNPC')
end

local wheel = Graphics.loadImageResolved('npc-' .. id .. '-wheel.png')
local npcutils = require("npcs/npcutils")

function npc.onCameraDrawNPC(v)
    if v.despawnTimer <= 0 then
        return
    end
    
    local config = NPC.config[id]
    local data = v.data._basegame
    
    if not data.init then return end
        
    npcutils.drawNPC(v, {
        priority = -47,
        frame = 0,
    })
    
    Graphics.drawBox{
        texture = wheel,
        
        x = v.x + v.width / 2 - 8,
        y = v.y + v.height / 2 - ((v.height - v.width) / 2),
        
        sourceHeight = config.wheelheight,
        
        sceneCoords = true,
        priority = -46,
        rotation = data.rot,
        centered = true,
    }
end

local orbits = require 'orbits'

local function init(v, data)
    local config = NPC.config[id]
    
    if not data.init then
        data.platforms = {}
        
        data.orbit = orbits.new{
            x = v.x + v.width / 2,
            y = v.y + v.height / 2 - 32,
            
            section = v.section,
            id = config.platformId,
            number = 4,
            radius = v.width / 3,
            
            rotationSpeed = config.speed / 4 * 0.97,
        }
        
        local rotationSpeed = data.orbit.rotationSpeed;

        if math.abs(rotationSpeed) > 0 then
            rotationSpeed = rotationSpeed*2*math.pi/lunatime.toTicks(1);
        end
        
        data.rot = rotationSpeed
        
        data.init = true
    end
end

function npc.onTickEndNPC(v)
    local data = v.data._basegame
    init(v, data)
    
    local config = NPC.config[id]
    local time = lunatime.tick() / (v.width / 2) * (config.speed * 2)
    
    local rotationSpeed = data.orbit.rotationSpeed;

    if math.abs(rotationSpeed) > 0 then
        rotationSpeed = rotationSpeed*2*math.pi/lunatime.toTicks(1);
    end
    
    data.rot = data.rot + math.deg(rotationSpeed)
                
    for k,n in ipairs(data.orbit.orbitingNPCs) do
        n.ai2 = (k - 1) % 4
    end
        
    if not v.friendly then
        v.friendly = true
    end
    
    v.animationFrame = -1
end

return npc