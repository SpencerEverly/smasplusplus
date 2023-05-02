local npc = {}
local birdos = require 'birdos'
local id = NPC_ID

local settings = {
    id = id,
    shoot = 3,
    
    eggId = 803,
    eggSfx = 16,
    effect = 754,
}

birdos.register(settings)

return npc