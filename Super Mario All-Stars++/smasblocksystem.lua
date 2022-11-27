--smasblocksystem.lua v1.0
--By Spencer Everly
--Makes the coin hit system more accurate to Mario games, adds the not-known-as-much invisible 1UP block system from SMB1, and some other stuff

local smasblocksystem = {}

--How the invisible 1UP block system from SMB1 works (Thanks Kosmic!):
--If you collect the following coin counts in -3 levels (In order from each -3 level):
smasblocksystem.invisibleCoinsToCollect = {
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

smasblocksystem.countDownMarker = 11 --Set this to any number to set the coin block timer when hitting multi-coin blocks.
smasblocksystem.showInvisible1UPBlock = true --Set it to true to show the invisible 1UP block, from SMB1 -1 levels. Only set to true if certain coin count checks are met.
smasblocksystem.invisibleCoinsCollected = 0 --This only increments when coins are collected in -3 levels, and will be reset on onExit
smasblocksystem.debug = false --Activates debug messages shown on the screen
smasblocksystem.frameRuleCounter = 20 --Adds a frame rule system, similar to SMB1's system
smasblocksystem.blockListWithCoins = {} --Table for a list of blocks set with more than 1 coin
smasblocksystem.yoshiNPCs = table.map{1095,1100,1098,1099,1149,1150,1228,1148,1325,1326,1327,1328,1329,1330,1331,1332} --Yoshi NPCs to use, for activating a 1UP instead of getting another Yoshi egg.

if SaveData.SMB1Invisible1UPBlockMet == nil then
    SaveData.SMB1Invisible1UPBlockMet = true --Since we're opening on 1-1, this will need to be set to true
end

local blockCountdown = 0
local activateBlockCountdown = false
local subtractBlockContentID = false

function smasblocksystem.onInitAPI()
    registerEvent(smasblocksystem,"onStart")
    registerEvent(smasblocksystem,"onPostNPCKill")
    registerEvent(smasblocksystem,"onPostBlockHit")
    registerEvent(smasblocksystem,"onTick")
    registerEvent(smasblocksystem,"onDraw")
    registerEvent(smasblocksystem,"onExit")
end

function smasblocksystem.onStart()
    --Hidden 1UP Block spawner
    if table.icontains(smastables.__smb1Dash1Levels,Level.filename()) then
        if not SaveData.SMB1Invisible1UPBlockMet then --If already collected the block, set the layer with the invisible block to hide it.
            local lifeBlock = Layer.get("Hidden 1UP Block")
            lifeBlock:hide(true)
        else --If true, then show it
            local lifeBlock = Layer.get("Hidden 1UP Block")
            lifeBlock:show(true)
        end
    end
    
    --16 coin block to 10 coin block conversion when on 1.3 Mode
    if SaveData.disableX2char then
        for k,v in ipairs(Block.get()) do
            if v.contentID == 16 then --Set the coin count from each block to 10 if on 1.3 Mode on the start of the level
                v.contentID = 10
            end
        end
    end
end

function smasblocksystem.onPostBlockHit(block, fromUpper, playerornil)
    --Life detection, for the SMB1 system
    local hidden1UPLayer = Layer.get("Hidden 1UP Block") --The hidden block layer.
    if SaveData.SMB1Invisible1UPBlockMet then
        if table.icontains(smastables.__smb1Dash1Levels,Level.filename()) then --If we're on any -1 level...
            for _,p in ipairs(Player.get()) do --Get all players in case
                if block.layerObj == hidden1UPLayer and block.contentID == 1186 then --If we hit the block layer and the ID is the 1UP itself...
                    SaveData.SMB1Invisible1UPBlockMet = false --Set this to false.
                end
            end
        end
    end
    
    
    
    
    if not SaveData.disableX2char then
        
        
        --Block coin hit detection
        if block.contentID >= 2 and block.contentID <= 99 and block.isValid and not activateBlockCountdown then
            activateBlockCountdown = true
            table.insert(smasblocksystem.blockListWithCoins, block)
            block.data.multiCoinTimer = smasblocksystem.countDownMarker
        elseif block.contentID <= 1 or block.contentID == 1000 or not block.isValid then
            activateBlockCountdown = false
            blockCountdown = 0
            subtractBlockContentID = false
        end
        
        
        --Yoshi egg to 1UP conversion
        if playerornil ~= nil then
            if playerornil.mount == MOUNT_YOSHI and smasblocksystem.yoshiNPCs[block.contentID] then
                block.contentID = 1187
            end
        end
        
        
    end
end

function smasblocksystem.onPostNPCKill(npc, harmType)
    if table.icontains(smastables.__smb1Dash3Levels,Level.filename()) then
        for _,p in ipairs(Player.get()) do
            if npc.id == 88 and Colliders.collide(p, npc) then --SMB1 Coin
                smasblocksystem.invisibleCoinsCollected = smasblocksystem.invisibleCoinsCollected + 1 --Collect one
                local levelIncrementation = table.ifind(smastables.__smb1Dash3LevelsNumbered, Level.filename())
                if smasblocksystem.invisibleCoinsCollected == smasblocksystem.invisibleCoinsToCollect[levelIncrementation] then --If equal to the one found in the table, set the goal-met to true
                    if smasblocksystem.debug then
                        Sound.playSFX(1001) --Debug purposes
                    end
                    SaveData.SMB1Invisible1UPBlockMet = true
                elseif smasblocksystem.invisibleCoinsCollected > smasblocksystem.invisibleCoinsToCollect[levelIncrementation] then --Else if any higher, don't set it
                    SaveData.SMB1Invisible1UPBlockMet = false
                end
            end
        end
    end
end

function smasblocksystem.onTick()
    if smasblocksystem.debug then
        Text.printWP(SaveData.SMB1Invisible1UPBlockMet, 100, 100, 0) --Debug purposes
        Text.printWP(smasblocksystem.frameRuleCounter, 100, 120, 0)
        Text.printWP(smasblocksystem.countDownMarker, 100, 140, 0)
    end
    
    smasblocksystem.frameRuleCounter = smasblocksystem.frameRuleCounter - 1
    if smasblocksystem.frameRuleCounter <= 0 then
        smasblocksystem.frameRuleCounter = 20
    end
    
    
    
    
    --Coin block timer
    if activateBlockCountdown then
        if smasblocksystem.frameRuleCounter == 20 then --If 20, then subtract the marker
            subtractBlockContentID = true
        else --Else just don't
            subtractBlockContentID = false
        end
        if subtractBlockContentID then
            for i=#smasblocksystem.blockListWithCoins, 1, -1 do
                local v = smasblocksystem.blockListWithCoins[i]
                if v.isValid and v.data.multiCoinTimer > 0 then
                    if smasblocksystem.frameRuleCounter == 20 then
                        v.data.multiCoinTimer = v.data.multiCoinTimer - 1
                    end
                else
                    v.contentID = 1 --Set the block to only one coin
                    v.data.multiCoinTimer = 0
                    smasblocksystem.countDownMarker = 11 --Reset the counter
                    table.remove(smasblocksystem.blockListWithCoins, i) --Remove the block from the table
                end
            end
        end
    end
    if not activateBlockCountdown then
        subtractBlockContentID = false
    end
end

return smasblocksystem