local smasEnemySystem = {}

local inspect = require("ext/inspect")

function smasEnemySystem.onInitAPI()
    registerEvent(smasEnemySystem,"onTick")
end

local heldNPC

smasEnemySystem.enableWallNPCFix = false --Enable this to prevent killing NPCs when held and let go right smack by a wall.
smasEnemySystem.enableTanookiThwompAndDiscKilling = true --Enable this to kill Thwomps and/or Roto-Discs while active as a statue.
smasEnemySystem.enableShellCoinGrabbing = true --Enable to let shells collect coins, dragon coins, cherries, etc.
smasEnemySystem.enableTurtleTipping = true --Enable this to activate the famous Infinite 1UP trick, from SMB1 and onwards

smasEnemySystem.shellTipPointIndicator = 1

function smasEnemySystem.onTick()
    
    
    
    --**WALL NPC FIX**
    if smasEnemySystem.enableWallNPCFix then
        if player.holdingNPC ~= nil then
            heldNPC = player.holdingNPC
        end
        --Disable killing NPCs when throwing them close to walls, making it more like the original Mario games
        if not SaveData.SMASPlusPlus.game.onePointThreeModeActivated then
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
    if smasEnemySystem.enableTanookiThwompAndDiscKilling then
        if not SaveData.SMASPlusPlus.game.onePointThreeModeActivated then
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
                    --smasTables.allThwompNPCIDs[v.id] support coming later
                end
            end
        end
    end
    
    
    
    
    
    --**SHELL COIN GRABBING**
    if smasEnemySystem.enableShellCoinGrabbing then
        if not SaveData.SMASPlusPlus.game.onePointThreeModeActivated then
            --Coins, first thing
            for k,v in ipairs(NPC.get(smasTables.allKoopaShellNPCIDs)) do --Shells
                for j,l in ipairs(NPC.get(smasTables.allCoinNPCIDs)) do --Coins
                    if Colliders.collide(v, l) and v:mem(0x136, FIELD_BOOL) then
                        l.killFlag = HARM_TYPE_VANISH --Kills the coin
                        Effect.spawn(78, l.x, l.y) --Spawns coin sparkle effect
                        Effectx.spawnScoreEffect(1, l.x, l.y) --Spawns 10 score effect
                        SaveData.SMASPlusPlus.hud.coinsClassic = SaveData.SMASPlusPlus.hud.coinsClassic + 1
                        if smasExtraSounds.enableCoinCollecting then
                            smasExtraSounds.playSFX(14)
                        end
                    end
                end
            end
            --Now we're gonna get rupees
            for k,v in ipairs(NPC.get(smasTables.allKoopaShellNPCIDs)) do --Shells
                for j,l in ipairs(NPC.get(smasTables.allRupeeNPCIDs)) do --Rupees
                    if Colliders.collide(v, l) and v:mem(0x136, FIELD_BOOL) then
                        l.killFlag = HARM_TYPE_VANISH --Kills the rupee
                        Effect.spawn(78, l.x, l.y) --Spawns coin sparkle effect
                        Effectx.spawnScoreEffect(1, l.x, l.y) --Spawns 10 score effect
                        SaveData.SMASPlusPlus.hud.coinsClassic = SaveData.SMASPlusPlus.hud.coinsClassic + 1
                        if smasExtraSounds.enableRupeeCollecting then
                            smasExtraSounds.playSFX(81)
                        end
                    end
                end
            end
            --And now, Dragon Coins
            for k,v in ipairs(NPC.get(smasTables.allKoopaShellNPCIDs)) do --Shells
                for j,l in ipairs(NPC.get(smasTables.allDragonCoinNPCIDs)) do --Dragon coins
                    if Colliders.collide(v, l) and v:mem(0x136, FIELD_BOOL) then
                        l.killFlag = HARM_TYPE_VANISH --Kills the dragon coin
                        local c = NPC.config[l.id]
                        c.score = c.score + 1 --Replicate basegame point combo
                        if c.score > 14 then
                            c.score = 14
                        end
                        Effect.spawn(78, l.x, l.y) --Spawns coin sparkle effect
                        Effectx.spawnScoreEffect(c.score, l.x, l.y) --Spawns score effect
                        smasExtraSounds.playDragonCoinSFX(l)
                    end
                end
            end
            --And finally, star coins
            for k,v in ipairs(NPC.get(smasTables.allKoopaShellNPCIDs)) do --Shells
                for j,l in ipairs(NPC.get(smasTables.allStarCoinNPCIDs)) do --Star coins
                    if Colliders.collide(v, l) and v:mem(0x136, FIELD_BOOL) then
                        starcoin.collect(l)
                    end
                end
            end
        end
    end
    
    
    
    if smasEnemySystem.enableTurtleTipping then
        if not SaveData.SMASPlusPlus.game.onePointThreeModeActivated then
            for k,v in ipairs(NPC.get(smasTables.allKoopaShellNPCIDs)) do --Shells
                for j,l in ipairs(Block.get(Block.SOLID)) do
                    if Collisionz.IsPlayerCloseToShell(player, v, 16) and Collisionz.CheckCollisionBlock(v, l) and Collisionz.CanMoveShell(player, v) and v:mem(0x136, FIELD_BOOL) then
                        v:mem(0x136, FIELD_BOOL, false)
                        v.speedX = 0
                    end
                    if Collisionz.CheckCollisionBlock(player, v) and Collisionz.FindCollision(player, v) == Collisionz.CollisionSpot.COLLISION_TOP then
                        player.speedY = -2
                        if player.keys.jump then
                            player:mem(0x11C, FIELD_WORD, Defines.jumpheight_bounce)
                        end
                        if not Playur.isOnGround(player) then
                            smasEnemySystem.shellTipPointIndicator = smasEnemySystem.shellTipPointIndicator + 1
                            if smasEnemySystem.shellTipPointIndicator >= SCORE_2UP then
                                smasEnemySystem.shellTipPointIndicator = SCORE_1UP
                            end
                        else
                            smasEnemySystem.shellTipPointIndicator = 1
                        end
                        Effectx.spawnScoreEffect(smasEnemySystem.shellTipPointIndicator, v.x, v.y)
                    end
                end
            end
            if Playur.isOnGround(player) then
                smasEnemySystem.shellTipPointIndicator = 1
            end
        end
    end
    
    
    
end

return smasEnemySystem