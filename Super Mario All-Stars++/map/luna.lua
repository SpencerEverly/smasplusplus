local smwMap = require("smwMap")
local inventory = require("customInventory")
local littleDialogue = require("littleDialogue")
local pausemenu = require("pausemenu2")
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
	if SaveData.utencounter == nil then
		SaveData.utencounter = 0
	end
	if SaveData.utpoiton == nil then
		SaveData.utpoiton = 1
	end 
	if SaveData.uthealfood == nil then
		SaveData.uthealfood = 1
	end
	if SaveData.utxp == nil then
		SaveData.utxp = 0
	end
	Misc.saveGame()
end