--smasBlockSystem.lua v1.0
--By Spencer Everly
--Makes the coin hit system more accurate to Mario games, adds the not-known-as-much invisible 1UP block system from SMB1, and some other stuff

local smasBlockSystem = {}

local blockManager = require("blockManager") --Used to detect spinjumping turn block stuff

--How the invisible 1UP block system from SMB1 works (Thanks Kosmic!):
--If you collect the following coin counts in -3 levels (In order from each -3 level):
smasBlockSystem.invisibleCoinsToCollect = {
    [1] = 21,
    [2] = 35,
    [3] = 22,
    [4] = 27,
    [5] = 23,
    [6] = 24,
    [7] = 35,
}
--Then you'll get an invisible 1UP block to collect at your disposal.
--If you don't collect the required coins in those Athletic levels, then you basically don't get the block hittable to collect.
--Depending on if you got the 1UP from 1-1 yet or not and you use the warp zone on 1-2, you can collect the hidden 1UP from 2-1, 3-1, or 4-1 if you haven't collected the one from 1-1.
--That's why on speedruns, the 4-1 block is not hidden, due to speedrunners skipping the 1UP block during their runs.

smasBlockSystem.countDownMarker = 11 --Set this to any number to set the coin block timer when hitting multi-coin blocks.
smasBlockSystem.showInvisible1UPBlock = true --Set it to true to show the invisible 1UP block, from SMB1 -1 levels. Only set to true if certain coin count checks are met.
smasBlockSystem.invisibleCoinsCollected = 0 --This only increments when coins are collected in -3 levels, and will be reset on onExit
smasBlockSystem.debug = false --Activates debug messages shown on the screen
smasBlockSystem.frameRuleCounter = 20 --Adds a frame rule system, similar to SMB1's system
smasBlockSystem.blockListWithCoins = {} --Table for a list of blocks set with more than 1 coin
smasBlockSystem.yoshiNPCs = table.map{1095,1100,1098,1099,1149,1150,1228,1148,1325,1326,1327,1328,1329,1330,1331,1332} --Yoshi NPCs to use, for activating a 1UP instead of getting another Yoshi egg.

smasBlockSystem.enableMultiCoinBlockSystem = true
smasBlockSystem.enableSMB1Invisible1UPSystem = true
smasBlockSystem.enableMultiplayerPowerupBlockSystem = true
smasBlockSystem.enableYoshi1UPBlockSystem = true
smasBlockSystem.enableTurnBlockSpinjumpBlockHits = false

local block90 = {}

if SaveData.SMB1Invisible1UPBlockMet == nil then
    SaveData.SMB1Invisible1UPBlockMet = true --Since we're opening on 1-1, this will need to be set to true
end

local blockCountdown = 0
local activateBlockCountdown = false
local subtractBlockContentID = false

function smasBlockSystem.onInitAPI()
    registerEvent(smasBlockSystem,"onStart")
    registerEvent(smasBlockSystem,"onPostNPCKill")
    registerEvent(smasBlockSystem,"onPostBlockHit")
    registerEvent(smasBlockSystem,"onTick")
    registerEvent(smasBlockSystem,"onDraw")
    registerEvent(smasBlockSystem,"onExit")
    
    blockManager.registerEvent(90, block90, "onCollideBlock")
end

function smasBlockSystem.onStart()
    --Hidden 1UP Block spawner
    if smasBlockSystem.enableSMB1Invisible1UPSystem then
        if table.icontains(smasTables.__smb1Dash1Levels,Level.filename()) then
            if not SaveData.SMB1Invisible1UPBlockMet then --If already collected the block, set the layer with the invisible block to hide it.
                local lifeBlock = Layer.get("Hidden 1UP Block")
                lifeBlock:hide(true)
            else --If true, then show it
                local lifeBlock = Layer.get("Hidden 1UP Block")
                lifeBlock:show(true)
            end
        end
    end
    
    --16 coin block to 10 coin block conversion when on 1.3 Mode
    if SaveData.SMASPlusPlus.game.onePointThreeModeActivated then
        for k,v in ipairs(Block.get()) do
            if v.contentID == 16 then --Set the coin count from each block to 10 if on 1.3 Mode on the start of the level
                v.contentID = 10
            end
        end
    end
end

local spawnedIDs = {}

function detectTopEntity(block, fromUpper, playerornil)
    if not fromUpper then
        for k,v in NPC.iterateIntersecting(block.x, block.y - 32, block.x + 32, block.y) do
            if not v.isHidden and not v.isGenerator then
                return v
            end
        end
    end
end

function smasBlockSystem.spawnMultiplayerItem(block, fromUpper, playerornil, contentID, spawnID)
    if block == nil then
        error("Must have a block")
        return
    end
    contentID = contentID or 1
    for _,p in ipairs(Player.get()) do --Get all players in case
        spawnedIDs[_] = NPC.spawn(spawnID, block.x, block.y - 32, playerornil.section, false, true)
        spawnedIDs[_].speedY = RNG.randomInt(-5,-3)
        spawnedIDs[_].direction = RNG.randomInt(-1,1)
        spawnedIDs[_].speedX = 2 * spawnedIDs[_].direction
        if spawnedIDs[_].direction == 0 then
            spawnedIDs[_].direction = 1
        end
    end
    spawnedIDs = {}
end

function smasBlockSystem.sproutMultiplayerBlockItem(playerPowerup, block, fromUpper, playerornil)
    local blockID = block.contentID
    Routine.waitFrames(2, false)
    if playerPowerup == nil then
        playerPowerup = 1
    end
    local npcEntity = detectTopEntity(block, fromUpper, playerornil, npcID)
    
    smasBlockSystem.spawnMultiplayerItem(block, fromUpper, playerornil, blockID, npcEntity.id)
    npcEntity:kill(HARM_TYPE_OFFSCREEN)
end

function block90.onCollideBlock(block, hitter) --SMW BLock
    if smasBlockSystem.enableTurnBlockSpinjumpBlockHits then
        if type(hitter) == "Player" then
            if (hitter.y+hitter.height) <= (block.y+4) then
                if (hitter:mem(0x50, FIELD_BOOL) and block.contentID > 0) then --Is the player spinjumping, and we have a content ID greater than 0?
                    block:hit(true)
                end
            end
        end
    end
end

function smasBlockSystem.onPostBlockHit(block, fromUpper, playerornil)
    if smasBlockSystem.enableSMB1Invisible1UPSystem then
        --Life detection, for the SMB1 system
        local hidden1UPLayer = Layer.get("Hidden 1UP Block") --The hidden block layer.
        if SaveData.SMB1Invisible1UPBlockMet then
            if table.icontains(smasTables.__smb1Dash1Levels,Level.filename()) then --If we're on any -1 level...
                for _,p in ipairs(Player.get()) do --Get all players in case
                    if block.layerObj == hidden1UPLayer and block.contentID == 1186 then --If we hit the block layer and the ID is the 1UP itself...
                        SysManager.sendToConsole("SMB1 1UP block hit. Collect the required coins on a -3 level to reactivate.")
                        SaveData.SMB1Invisible1UPBlockMet = false --Set this to false.
                    end
                end
            end
        end
    end
    
    
    
    
    if not SaveData.SMASPlusPlus.game.onePointThreeModeActivated then
        
        if smasBlockSystem.enableMultiCoinBlockSystem then
            --Block coin hit detection
            if block.contentID >= 2 and block.contentID <= 99 and block.isValid and not activateBlockCountdown then
                SysManager.sendToConsole("Activated multi-coin block system on block "..tostring(block.idx)..".")
                activateBlockCountdown = true
                table.insert(smasBlockSystem.blockListWithCoins, block)
                block.data.multiCoinTimer = smasBlockSystem.countDownMarker
            elseif block.contentID <= 1 or block.contentID == 1000 or not block.isValid then
                activateBlockCountdown = false
                blockCountdown = 0
                subtractBlockContentID = false
            end
        end
        
        
        --Yoshi egg to 1UP conversion
        if smasBlockSystem.enableYoshi1UPBlockSystem then
            if playerornil ~= nil then
                if playerornil.mount == MOUNT_YOSHI and smasBlockSystem.yoshiNPCs[block.contentID] then
                    SysManager.sendToConsole("Yoshi already mounted on Player "..tostring(playerornil.idx)..", changed to 1UP mushroom.")
                    block.contentID = 1187
                end
            end
        end
        
        
    end
    
    if SaveData.SMASPlusPlus.game.onePointThreeModeActivated then
        
        
        --Multi-powerup sprouting on multiplayer (NSMBWii)
        if smasBlockSystem.enableMultiplayerPowerupBlockSystem then
            if playerornil ~= nil and not fromUpper then
                for k,v in ipairs(smasTables.allPowerupNPCIDs) do
                    if Player.count() >= 2 and block.contentID == v + 1000 then
                        Routine.run(smasBlockSystem.sproutMultiplayerBlockItem, playerornil.powerup, block, fromUpper, playerornil)
                    end
                end
            end
        end
        
        
    end
end

function smasBlockSystem.onPostNPCKill(npc, harmType)
    if smasBlockSystem.enableSMB1Invisible1UPSystem then
        if table.icontains(smasTables.__smb1Dash3Levels,Level.filename()) then
            for _,p in ipairs(Player.get()) do
                if npc.id == 88 and Colliders.collide(p, npc) then --SMB1 Coin
                    smasBlockSystem.invisibleCoinsCollected = smasBlockSystem.invisibleCoinsCollected + 1 --Collect one
                    local levelIncrementation = table.ifind(smasTables.__smb1Dash3LevelsNumbered, Level.filename())
                    if smasBlockSystem.invisibleCoinsCollected == smasBlockSystem.invisibleCoinsToCollect[levelIncrementation] then --If equal to the one found in the table, set the goal-met to true
                        if smasBlockSystem.debug then
                            Sound.playSFX(1001) --Debug purposes
                        end
                        SysManager.sendToConsole("SMB1 -3 coin requirement matches. 1UP blocks will now show on -1 levels.")
                        SaveData.SMB1Invisible1UPBlockMet = true
                    elseif smasBlockSystem.invisibleCoinsCollected > smasBlockSystem.invisibleCoinsToCollect[levelIncrementation] then --Else if any higher, don't set it
                        if smasBlockSystem.debug then
                            Sound.playSFX(152) --Debug purposes
                        end
                        SysManager.sendToConsole("SMB1 -3 coin requirement is over the amount set. 1UP blocks will not show on -1 levels.")
                        SaveData.SMB1Invisible1UPBlockMet = false
                    end
                end
            end
        end
    end
end

function smasBlockSystem.onTick()
    if smasBlockSystem.debug then
        Text.printWP(SaveData.SMB1Invisible1UPBlockMet, 100, 100, 0) --Debug purposes
        Text.printWP(smasBlockSystem.frameRuleCounter, 100, 120, 0)
        Text.printWP(smasBlockSystem.countDownMarker, 100, 140, 0)
    end
    
    smasBlockSystem.frameRuleCounter = smasBlockSystem.frameRuleCounter - 0.923076923077 --This is 60 FPS, since SMBX is 65 FPS
    if smasBlockSystem.frameRuleCounter <= 0 then
        smasBlockSystem.frameRuleCounter = 20
    end
    
    
    
    
    --Coin block timer
    if smasBlockSystem.enableMultiCoinBlockSystem then
        if activateBlockCountdown then
            if smasBlockSystem.frameRuleCounter == 20 then --If 20, then subtract the marker
                subtractBlockContentID = true
            else --Else just don't
                subtractBlockContentID = false
            end
            if subtractBlockContentID then
                for i=#smasBlockSystem.blockListWithCoins, 1, -1 do
                    local v = smasBlockSystem.blockListWithCoins[i]
                    if v.isValid and v.data.multiCoinTimer > 0 then
                        if smasBlockSystem.frameRuleCounter == 20 then
                            v.data.multiCoinTimer = v.data.multiCoinTimer - 1
                        end
                    else
                        v.contentID = 1 --Set the block to only one coin
                        v.data.multiCoinTimer = 0
                        smasBlockSystem.countDownMarker = 11 --Reset the counter
                        table.remove(smasBlockSystem.blockListWithCoins, i) --Remove the block from the table
                    end
                end
            end
        end
        if not activateBlockCountdown then
            subtractBlockContentID = false
        end
    end
end

return smasBlockSystem