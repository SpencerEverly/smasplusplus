local smwMap = require("smwMap")
local inventory = require("customInventory")
local littleDialogue = require("littleDialogue")
local pausemenu = require("pausemenu2")
local playerManager = require("playermanager")
if not Misc.inMarioChallenge() then
    datetime = require("datetime")
end
local debugbox = require("debugbox")

function onStart()
    GameData.friendlyArea = true
    if SaveData.introselect == nil then
        SaveData.introselect = SaveData.introselect or 1
    end
    if SaveData.firstBootCompleted == nil then
        SaveData.firstBootCompleted = false
    end
    Misc.saveGame()
end

local mapimage

function onDraw()
    --Costume map images
    if SaveData.currentCostume ~= "N/A" then
        pcall (function() mapimage = (Graphics.loadImageResolved("costumes/"..playerManager.getName(player.character).."/"..player:getCostume().."/player-"..playerManager.getName(player.character)..".png")) end)
        if mapimage then
            smwMap.playerSettings.images[player.character] = mapimage
        elseif mapimage == nil then
            smwMap.playerSettings.images[player.character] = Graphics.loadImageResolved("smwMap/player-mario.png")
        end
    end
    
    
    
    --Disable drop item key
    player.keys.dropItem = false
    if Player.count() >= 2 then
        player2.keys.dropItem = false
    end
    
    --Text.print(smwMap.unlockingCurrentPath, 100, 100)
    
    --Path unlockers
    if smwMap.unlockingCurrentPath == "toSMB31-Toad1Path1" then
        smwMap.unlockPath("toSMB31-4")
    end
    if smwMap.unlockingCurrentPath == "toSMB31-Bonus1" then
        smwMap.unlockPath("toSMB31-Fortress1")
    end
    if smwMap.unlockingCurrentPath == "toSMB3W-3Path1" then
        smwMap.unlockPath("toSMB33-ToadHouse1")
        smwMap.unlockPath("toSMB33-3")
    end
    if smwMap.unlockingCurrentPath == "toSMB3W-3Path2" then
        smwMap.unlockPath("toSMB33-4")
        smwMap.unlockPath("toSMB33-5")
    end
    if smwMap.unlockingCurrentPath == "toSMB33-Bonus1" then
        smwMap.unlockPath("toSMB33-8")
    end
    if smwMap.unlockingCurrentPath == "toSMB3W-4Path1" then
        smwMap.unlockPath("toSMB3W-4ToadHouse1")
        smwMap.unlockPath("toSMB34-3")
    end
    if smwMap.unlockingCurrentPath == "toSMB3W-4Path2" then
        smwMap.unlockPath("toSMB34-6")
        smwMap.unlockPath("toSMB34-5")
    end
    if smwMap.unlockingCurrentPath == "toSMB35-TowerPath2" then
        smwMap.unlockPath("toSMB35-TowerPath1")
        smwMap.unlockPath("toSMB35-Tower")
    end
    if smwMap.unlockingCurrentPath == "toSMB3W-5Path3" then
        smwMap.unlockPath("toSMB35-TowerPath1")
        smwMap.unlockPath("toSMB35-Tower")
    end
    if smwMap.unlockingCurrentPath == "toSMB3W-7Path1" then
        smwMap.unlockPath("toSMB37-4")
        smwMap.unlockPath("toSMB37-5")
    end
end