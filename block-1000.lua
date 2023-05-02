local blockmanager = require("blockmanager")

local blockID = BLOCK_ID

local block = {}


blockmanager.setBlockSettings({
    id = blockID,
    customhurt = true,
    passthrough = true,
})

function block.onCollideBlock(v,n)
    if(n.__type == "NPC") then
        n:kill(HARM_TYPE_NPC)
    end
end

function block.onInitAPI()
    blockmanager.registerEvent(blockID, block, "onCollideBlock")
end

return block