local npcManager = require("npcManager")
local npc = {}
local id = NPC_ID

npcManager.setNpcSettings({
    id = id,
    
    frames = 8,
    framespeed = 4,
    framestyle = 1,
    
    jumphurt = true,
    nohurt = true,
    nogravity = true,
    noblockcollision = true,
    
    noiceball = true,
    noyoshi = true,
    notcointransformable = true,
})

function npc.onTickEndNPC(v)
    local data = v.data._basegame
    local config = NPC.config[id]
    
    local speed = v.ai2
    local time = math.floor(lunatime.tick() / (config.framespeed)) * (speed / 4)
    local frames = config.frames
    
    if v.ai1 == 0 then
        data.block = Block.spawn(1007, v.x, v.y)
        
        v.ai1 = 1
    end
    
    if data.block then
        data.block.extraSpeedX = (speed + v.speedX) * v.direction
        data.block.isHidden = (v.isHidden or v.friendly)
        data.block:translate(v.speedX, v.speedY)
    end
    
    v.animationFrame = (math.abs(time) % frames)
    
    if config.framestyle > 0 then
        v.animationFrame = (v.direction == 1 and v.animationFrame + config.frames) or v.animationFrame
    end
end

function npc.onInitAPI()
    npcManager.registerEvent(id, npc, 'onTickEndNPC')
end

return npc