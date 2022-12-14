local woodBlock = {}

local blockManager = require("blockManager")
local blockID = BLOCK_ID

function woodBlock.onInitAPI()
    blockManager.registerEvent(blockID, woodBlock, "onTickEndBlock")
end

function woodBlock.onTickEndBlock(v)
    -- Don't run code for invisible entities
	if v.isHidden or v:mem(0x5A, FIELD_BOOL) then return end
	
	local data = v.data
    
    if v.contentID > 0 then
        for _,p in ipairs(Player.get()) do
            if v:collidesWith(p) == 4 then
                p.speedX = -1
            elseif v:collidesWith(p) == 2 then
                p.speedX = 1
            end
            if (v:collidesWith(p) == 2 or v:collidesWith(p) == 3 or v:collidesWith(p) == 4) then
                v:hit()
                v:transform(1)
            end
        end
    end
end

return woodBlock