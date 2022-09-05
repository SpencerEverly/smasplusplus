--smaspowerupsystem
--v1.0
--By Spencer Everly
--Not to be confused with anotherPowerup, an really unstable library by Enjl.

local playerManager = require("playerManager")
local npcManager = require("npcManager")
local smaspowerupsystem = {}

if SaveData.disableX2char ~= false then return end

if SaveData.playerPowerup == nil then
    SaveData.playerPowerup = {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1} --We start with all 16 characters with powerup states being 1
end

smaspowerupsystem.powerupActive = false
local newPowerupID = {}
local activeId = player.powerup
local powerups = {}

powerups[2] = {9, 184, 185}
powerups[3] = {14, 182, 183}
powerups[4] = {34}
powerups[5] = {169}
powerups[6] = {170}
powerups[7] = {264, 277}

local defaultPowerupMap = {
    [9]   = PLAYER_BIG,
    [184] = PLAYER_BIG,
    [185] = PLAYER_BIG,
    [249] = PLAYER_BIG,
}

local playerList = {
    "mario", "luigi", "peach", "toad", "link", "megaman", "wario", "bowser", "klonoa", "ninjabomberman", "rosalina", "snake", "zelda", "ultimaterinka", "unclebroadsword", "samus",
}

function smaspowerupsystem.onInitAPI()
    registerEvent(smaspowerupsystem,"onTick")
    registerEvent(smaspowerupsystem,"onDraw")
    registerEvent(smaspowerupsystem,"onPostNPCKill")
    registerEvent(smaspowerupsystem,"onPlayerHarm")
end

function smaspowerupsystem.registerPowerup(powerupLibrary, id)
    local powerupLibrary = require("scripts/powerups/"..powerupLibrary)
    powerupLibrary.name = powerupLibrary
    powerupLibrary.id = id
    
    if powerups[powerupLibrary.id] ~= nil then
        Misc.warn("Powerup ID "..powerupLibrary.id.." cannot be registered, because it is already registered.")
        return
    end
    
    powerups[powerupLibrary.id] = powerupLibrary
    
    return powerupLibrary
end

function smaspowerupsystem.loadPowerupAssets(plr, powerupId, powerupLibrary)
    if not smaspowerupsystem.powerupActive then
        return
    end
    
    if SaveData.currentCostume == "N/A" then
        local iniFile = Misc.resolveFile("graphics/"..players[plr.character].."/"..players[plr.character].."-"..powerupId..".ini") or Misc.resolveFile(players[plr.character].."/"..players[plr.character].."-"..powerupId..".ini") or Misc.resolveFile(players[plr.character].."-"..powerupId..".ini")
    else
        local iniFile = Misc.resolveFile("costumes/"..playerManager.getName(player.character).."/"..player:getCostume().."/"..players[plr.character].."-"..powerupId..".png")
    end
    if (iniFile == nil) then
        iniFile = playerManager.getHitboxPath(plr.character, powerupId)
    end
    
    Misc.loadCharacterHitBoxes(plr.character, powerupId, iniFile)
    
    Graphics.sprites[players[plr.character]][2].img = powerupLibrary.spritesheets[plr.character]
end

function smaspowerupsystem.powerupState()
    if player.powerup == 2 then
        return SaveData.playerPowerup[player.character]
    else
        return player.powerup
    end
end

function smaspowerupsystem.onDraw()
    if player.powerup == 2 then
        SaveData.playerPowerup[player.character] = activeId
    else
        SaveData.playerPowerup[player.character] = player.powerup
    end
    if player.powerup == 1 or player.powerup >= 3 then
        player.powerup = SaveData.playerPowerup[player.character]
    end
end

function onPlayerHarm(event, p)
    if p.powerup > 1 and p.mount == MOUNT_NONE and not p:mem(0x0C, FIELD_BOOL) and not p.hasStarman then
        
    end
end

return smaspowerupsystem