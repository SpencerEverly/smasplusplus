local smasenemysystem = {}

local inspect = require("ext/inspect")

function smasenemysystem.onInitAPI()
    registerEvent(smasenemysystem,"onTick")
end

local heldNPC

smasenemysystem.enableWallNPCFix = false --Enable this to prevent killing NPCs when held and let go right smack by a wall.
smasenemysystem.enableTanookiThwompAndDiscKilling = true --Enable this to kill Thwomps and/or Roto-Discs while active as a statue.
smasenemysystem.enableShellCoinGrabbing = true --Enable to let shells collect coins, dragon coins, cherries, etc.

function smasenemysystem.onTick()
    
    
    
    --**WALL NPC FIX**
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
    
    
    --**TANOOKI THWOMP AND DISC KILLING**
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
    
    
    
    
    
    --**SHELL COIN GRABBING**
    if smasenemysystem.enableShellCoinGrabbing then
        if not SaveData.disableX2char then
            --Coins, first thing
            for k,v in ipairs(NPC.get(smastables.allShellNPCIDs)) do --Shells
                for j,l in ipairs(NPC.get(smastables.allCoinNPCIDs)) do --Coins
                    if Colliders.collide(v, l) and v:mem(0x136, FIELD_BOOL) then
                        l.killFlag = HARM_TYPE_VANISH --Kills the coin
                        Effect.spawn(78, l.x, l.y) --Spawns coin sparkle effect
                        Effectx.spawnScoreEffect(1, l.x, l.y) --Spawns 10 score effect
                        SaveData.totalCoinsClassic = SaveData.totalCoinsClassic + 1
                        if extrasounds.enableCoinCollecting then
                            extrasounds.playSFX(14)
                        end
                    end
                end
            end
            --Now we're gonna get rupees
            for k,v in ipairs(NPC.get(smastables.allShellNPCIDs)) do --Shells
                for j,l in ipairs(NPC.get(smastables.allRupeeNPCIDs)) do --Rupees
                    if Colliders.collide(v, l) and v:mem(0x136, FIELD_BOOL) then
                        l.killFlag = HARM_TYPE_VANISH --Kills the rupee
                        Effect.spawn(78, l.x, l.y) --Spawns coin sparkle effect
                        Effectx.spawnScoreEffect(1, l.x, l.y) --Spawns 10 score effect
                        SaveData.totalCoinsClassic = SaveData.totalCoinsClassic + 1
                        if extrasounds.enableRupeeCollecting then
                            extrasounds.playSFX(81)
                        end
                    end
                end
            end
            --And now, Dragon Coins
            for k,v in ipairs(NPC.get(smastables.allShellNPCIDs)) do --Shells
                for j,l in ipairs(NPC.get(smastables.allDragonCoinNPCIDs)) do --Dragon coins
                    if Colliders.collide(v, l) and v:mem(0x136, FIELD_BOOL) then
                        l.killFlag = HARM_TYPE_VANISH --Kills the dragon coin
                        local c = NPC.config[l.id]
                        c.score = c.score + 1 --Replicate basegame point combo
                        if c.score > 14 then
                            c.score = 14
                        end
                        Effect.spawn(78, l.x, l.y) --Spawns coin sparkle effect
                        Effectx.spawnScoreEffect(c.score, l.x, l.y) --Spawns score effect
                        extrasounds.playDragonCoinSFX(l)
                    end
                end
            end
            --And finally, star coins
            for k,v in ipairs(NPC.get(smastables.allShellNPCIDs)) do --Shells
                for j,l in ipairs(NPC.get(smastables.allStarCoinNPCIDs)) do --Star coins
                    if Colliders.collide(v, l) and v:mem(0x136, FIELD_BOOL) then
                        starcoin.collect(l)
                    end
                end
            end
        end
    end
    
    
    
end

return smasenemysystem