local smasenemysystem = {}

local inspect = require("ext/inspect")

function smasenemysystem.onInitAPI()
    registerEvent(smasenemysystem,"onTick")
end

function smasenemysystem.onTick()
    --Disable killing NPCs when throwing them close to walls, making it more like the original Mario games
    if not SaveData.disableX2char then
        for k,v in ipairs(NPC.get()) do
            if v:mem(0x134,FIELD_WORD) >= 5 then --Since NPCs get killed when this is higher than 5...
                v:mem(0x134,FIELD_WORD,0) --Make it 0 to not kill them
                local blockOver = Block.getIntersecting(v.x + (16 * v.direction), v.y, v.x + v.width, v.y + v.height) --We still need to move NPCs to prevent a few glitches though, so do an intersecting on the block...
                --[[if blockOver.x ~= nil then --If this value isn't nil, continue onward...
                    if blockOver.x < v.x and player.direction == -1 then
                        v.x = v.x + 16
                    elseif blockOver.x > v.x and player.direction == 1 then
                        v.x = v.x - 16
                    end
                end]]
            end
        end
    end
end

return smasenemysystem