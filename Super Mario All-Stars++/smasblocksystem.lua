--smasblocksystem.lua v1.0
--By Spencer Everly
--Makes the coin hit system more accurate to Mario games, and also adds the not-known-as-much invisible 1UP block system from SMB1

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
--If you don't collect the require coins in those Athletic levels, then you basically don't get the block hittable to collect.
--Warp zones 

smasblocksystem.countDownMarker = 11 --Set this to any number to set the coin block timer when hitting multi-coin blocks.
smasblocksystem.showInvisible1UPBlock = true --Set it to true to show the invisible 1UP block, from SMB1 -1 levels. Only set to true if certain coin count checks are met.
smasblocksystem.invisibleCoinsCollected = 0 --This only increments when coins are collected in -3 levels, and will be reset on onExit
smasblocksystem.debug = false --Activates debug messages shown on the screen
smasblocksystem.frameRuleCounter = 20 --Adds a frame rule system

if SaveData.SMB1Invisible1UPBlockMet == nil then
    SaveData.SMB1Invisible1UPBlockMet = true --Since we're opening on 1-1, this will need to be set to true
end

local blockcountdown = 0
local activateblockcountdown = false
local subtractblockcontentid = false

local blocklistwithcoins = {}

function smasblocksystem.onInitAPI()
    registerEvent(smasblocksystem,"onStart")
    registerEvent(smasblocksystem,"onPostNPCKill")
    registerEvent(smasblocksystem,"onPostBlockHit")
    registerEvent(smasblocksystem,"onTick")
    registerEvent(smasblocksystem,"onDraw")
    registerEvent(smasblocksystem,"onExit")
end

function smasblocksystem.onStart()
    if table.icontains(smastables.__smb1Dash1Levels,Level.filename()) then
        if not SaveData.SMB1Invisible1UPBlockMet then
            local lifeBlock = Layer.get("Hidden 1UP Block")
            lifeBlock:hide(true)
        else
            local lifeBlock = Layer.get("Hidden 1UP Block")
            lifeBlock:show(true)
        end
    end
end

function smasblocksystem.onPostBlockHit(block, fromUpper, playerornil)
    --Life detection, for the SMB1 system
    local hidden1UPLayer = Layer.get("Hidden 1UP Block")
    if SaveData.SMB1Invisible1UPBlockMet then
        if table.icontains(smastables.__smb1Dash1Levels,Level.filename()) then
            for _,p in ipairs(Player.get()) do --Get all players in case
                if block.layerObj == hidden1UPLayer and block.contentID == 1186 then --SMB1 1UP
                    SaveData.SMB1Invisible1UPBlockMet = false --Reset this to false, in case
                end
            end
        end
    end
    
    
    
    
    --Block coin hit detection
    if not SaveData.disableX2char then
        if block.contentID >= 2 and block.contentID <= 99 and block.isValid and not activateblockcountdown then
            activateblockcountdown = true
            table.insert(blocklistwithcoins, block)
        elseif block.contentID <= 1 or block.contentID == 1000 or not block.isValid then
            activateblockcountdown = false
            blockcountdown = 0
            subtractblockcontentid = false
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
    if activateblockcountdown then
        if smasblocksystem.frameRuleCounter == 20 then
            smasblocksystem.countDownMarker = smasblocksystem.countDownMarker - 1
            subtractblockcontentid = true
        else
            subtractblockcontentid = false
        end
        if subtractblockcontentid then
            for i=#blocklistwithcoins, 1, -1 do
                local v = blocklistwithcoins[i]
                if v.isValid and smasblocksystem.countDownMarker > 0 then
                    --v.contentID = v.contentID - 1
                else
                    v.contentID = 1
                    smasblocksystem.countDownMarker = 11
                    table.remove(blocklistwithcoins, i)
                end
            end
        end
    end
    if not activateblockcountdown then
        subtractblockcontentid = false
    end
end

function smasblocksystem.onExit()
    smasblocksystem.invisibleCoinsCollected = 0
end

return smasblocksystem