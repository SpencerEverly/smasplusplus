local smasenemysystem = {}

local inspect = require("ext/inspect")

function smasenemysystem.onInitAPI()
    registerEvent(smasenemysystem,"onTick")
end

local heldNPC

smasenemysystem.enableWallNPCFix = false
smasenemysystem.enableTanookiThwompAndDiscKilling = true

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
                    for k,v in ipairs(Block.getIntersecting(heldNPC.x + (16 * heldNPC.direction), heldNPC.y, heldNPC.x + heldNPC.width, heldNPC.y + heldNPC.height)) do --We still need to move NPCs to prevent a few glitches though, so do an intersecting on the block...
                        if v.x ~= nil then --If this value isn't nil, continue onward...
                            if v.x < heldNPC.x and heldNPC.direction == -1 then
                                heldNPC.speedX = heldNPC.speedX + 3
                            elseif v.x > heldNPC.x and heldNPC.direction == 1 then
                                heldNPC.speedX = heldNPC.speedX - 3
                            end
                        end
                    end
                end
            end
        end
    end
    if smasenemysystem.enableTanookiThwompAndDiscKilling then
        if not SaveData.disableX2char then
            for _,p in ipairs(Player.get()) do
                if p.powerup == 5 and p:mem(0x4A, FIELD_BOOL) then
                    for k,v in ipairs(NPC.getIntersecting(p.x, p.y, p.x + p.width, p.y + p.height - 20)) do
                        if v.id == 259 then
                            v:kill(HARM_TYPE_VANISH)
                            Effect.spawn(10, v.x, v.y)
                            Sound.playSFX(2)
                            p.speedY = -1
                        end
                    end
                    --smastables.allThwompNPCIDs[v.id] support coming later
                end
            end
        end
    end
end

return smasenemysystem