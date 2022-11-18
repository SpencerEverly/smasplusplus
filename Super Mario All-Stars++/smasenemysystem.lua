local smasenemysystem = {}

local inspect = require("ext/inspect")

function smasenemysystem.onInitAPI()
    registerEvent(smasenemysystem,"onTick")
end

local heldNPC

smasenemysystem.enableWallNPCFix = false

function smasenemysystem.onTick()
    if smasenemysystem.enableWallNPCFix then
        if player.holdingNPC ~= nil then
            heldNPC = player.holdingNPC
        end
        --Disable killing NPCs when throwing them close to walls, making it more like the original Mario games
        if not SaveData.disableX2char then
            if heldNPC ~= nil and heldNPC.isValid then
                if heldNPC:mem(0x134,FIELD_WORD) >= 5 then --Since NPCs get killed when this is higher than 5...
                    heldNPC:mem(0x134,FIELD_WORD,0) --Make it 0 to not kill them
                    local blockOver = Block.getIntersecting(heldNPC.x + (16 * heldNPC.direction), heldNPC.y, heldNPC.x + heldNPC.width, heldNPC.y + heldNPC.height) --We still need to move NPCs to prevent a few glitches though, so do an intersecting on the block...
                    if blockOver.x ~= nil then --If this value isn't nil, continue onward...
                        if blockOver.x < heldNPC.x and heldNPC.direction == -1 then
                            heldNPC.speedX = heldNPC.speedX + 3
                        elseif blockOver.x > heldNPC.x and heldNPC.direction == 1 then
                            heldNPC.speedX = heldNPC.speedX - 3
                        end
                    end
                end
            end
        end
    end
end

return smasenemysystem