-- Amotherpowerup serves as a wrapper for an endless powerup system.
-- Features:
--- Infinite Powerups!
--- Custom collision for every individual powerup!
--- Unique images for every individual powerup!
--- Events that happen on powerup switch!
--- Define custom powerup tiers!
-- Limitations:
--- Every powerup will behave as if the player is 'big'
--- Only applicable to Mario, Peach, Luigi, Toad. Not Link. Not SMBX2 Characters.

local playerManager = require("playerManager")
local npcManager = require("npcManager")

local ap = {}

SaveData._ap = SaveData._ap or {}

local powerups = {}
local currentPowerup
local itemMap = {}
local tiers = {}
local isPoweringUp = false

powerups[2] = {9, 184, 185}
powerups[3] = {14, 182, 183}
powerups[4] = {34}
powerups[5] = {169}
powerups[6] = {170}
powerups[7] = {264, 277}

local defaultNPCPowerupMap = {
    [9]   = PLAYER_BIG,
    [14]  = PLAYER_FIREFLOWER,
    [34]  = PLAYER_LEAF,
    [169] = PLAYER_TANOOKIE,
    [170] = PLAYER_HAMMER,
    [182] = PLAYER_FIREFLOWER,
    [183] = PLAYER_FIREFLOWER,
    [184] = PLAYER_BIG,
    [185] = PLAYER_BIG,
    [249] = PLAYER_BIG,
    [264] = PLAYER_ICE,
    [277] = PLAYER_ICE,
}

local players = {
    "mario", "luigi", "peach", "toad", "link", "megaman", "wario", "bowser", "klonoa", "ninjabomberman", "rosalina", "snake", "zelda", "ultimaterinka", "unclebroadsword", "samus",
}

local function registerItemsInternal(powerup, ids)
    if type(ids) == "number" then
        ids = {}
    elseif type(ids) ~= "table" then
        powerup.items = {}
        return
    end

    for k,v in ipairs(powerup.items) do
        itemMap[v] = nil
    end

    powerup.items = ids

    for k,v in ipairs(ids) do
        if itemMap[v] ~= nil then
            Misc.warn("Item " .. v .. " could not be registered to Powerup " .. libraryName .. ", because it was already registered to Powerup " .. itemMap[v] .. ".")
            return
        else
            itemMap[v] = libraryName
        end
    end
end


local function loadPowerupAssets(thisPlayer,basePowerup)
    if currentPowerup == nil or thisPlayer.character > 5 then
        return
    end
    
    if SaveData.currentCostume == "N/A" then
        local iniFile = Misc.resolveFile("graphics/"..players[thisPlayer.character].."/"..players[thisPlayer.character].."-"..currentPowerup.name..".ini") or Misc.resolveFile("graphics/"..players[thisPlayer.character].."-"..currentPowerup.name..".ini") or Misc.resolveFile(players[thisPlayer.character] .."-"..currentPowerup.name..".ini")
    else
        local iniFile = Misc.resolveFile("costumes/"..playerManager.getName(thisPlayer.character).."/"..SaveData.currentCostume.."/"..players[thisPlayer.character] .."-"..currentPowerup.name..".ini")
    end
	
    if (iniFile == nil) then
        iniFile = playerManager.getHitboxPath(thisPlayer.character, basePowerup);
    end

    Misc.loadCharacterHitBoxes(thisPlayer.character, basePowerup, iniFile)

    Graphics.sprites[players[thisPlayer.character]][basePowerup].img = currentPowerup.spritesheets[thisPlayer.character]
end

-- registerPowerup registers a new powerup to the system
--- libraryName: string - The name of the library containing powerup information. One library per powerup. Think of it as a require(libraryName) call

-- Returns the library table for the powerup
function ap.registerPowerup(libraryName)
    local entry = require("scripts/powerups/"..libraryName)
    entry.registerItems = registerItemsInternal
    entry.name = libraryName
    entry.items = entry.items or {}
    powerups[libraryName] = entry

    for k,v in ipairs(entry.items) do
        if itemMap[v] ~= nil then
            Misc.warn("Item " .. v .. " could not be registered to Powerup " .. libraryName .. ", because it was already registered to Powerup " .. itemMap[v] .. ".")
            return
        else
            itemMap[v] = libraryName
        end
    end
    return entry
end

-- Replacement powerups
ap.powerReplacements = {}
ap.powerReplacements[2] = ap.registerPowerup("ap_big")

-- registerItemTier registers a new tier chain for items.
-- spawnedItem: number - The item that spawns from a block.
-- chain: table - The list of states ordered by significance. Numbers correspond to vanilla states, strings correspond to the names of anotherpowerup powerups. See demo for more info.
-- if you provide chain as "true", it will accept everything except for small mario
function ap.registerItemTier(spawnedItem, chain)
    if chain ~= true then
        for k,v in ipairs(chain) do
            if ap.powerReplacements[v] then
                chain[k] = ap.powerReplacements[v].name
            end
        end
    end
    tiers[spawnedItem] = chain
end

-- Returns the player's current powerup, accounting for anotherpowerup powerups
function ap.getPowerup()
    if player.powerup == 2 then
        return currentPowerup.name
    else
        return player.powerup
    end
end

function ap.onInitAPI()
    registerEvent(ap, "onPostNPCKill")
    registerEvent(ap, "onTickEnd")
    registerEvent(ap, "onTick")
    registerEvent(ap, "onExit")
    registerEvent(ap, "onDraw")
    registerEvent(ap, "onStart")
end

function ap.onTick()
    if currentPowerup and player.forcedState == 0 and ap.getPowerup() ~= currentPowerup.name then
        currentPowerup.onDisable()
        currentPowerup = nil
        SaveData._ap.cp = nil
    end
    if currentPowerup then
        if player.mount < 2 then
            if player.character ~= CHARACTER_LINK then
                player:mem(0x160, FIELD_WORD, 3) -- Disable the normal projectile timer. Powerups need to implement their own.
            else                
                player:mem(0x162, FIELD_WORD, 29) -- Disable the link projectile timer. Powerups need to implement their own.
            end
        end
        currentPowerup.onTick()
    end
end

local testMenuWasActive = false

function ap.onDraw()
    if currentPowerup and player.forcedState == 0 and ap.getPowerup() ~= currentPowerup.name then
        currentPowerup.onDisable()
        currentPowerup = nil
        SaveData._ap.cp = nil
    end
    if currentPowerup then
        currentPowerup.onDraw()
    end
    
    -- Handle test mode menu, and reload hitboxes after a bit
    if lunatime.tick() == 1 then
        loadPowerupAssets(player,player.powerup)
    end
end

function ap.onTickEnd()
    for k,v in ipairs(NPC.get(table.unmap(itemMap))) do -- Thankfully this is more performant these days I guess!
        if not v.data._anotherpowerup and v.despawnTimer > 0 then
            v.data._anotherpowerup = true
            local spawn = v:mem(0x138, FIELD_WORD)
            if spawn == 1 or spawn == 3 or spawn == 4 then
                local currentTier
                local list
                if tiers[v.id] ~= nil and tiers[v.id] ~= true then
                    if type(ap.getPowerup()) == "number" then
                        list = powerups[ap.getPowerup()]
                    else
                        list = currentPowerup.items
                    end
                    if list ~= nil then
                        for k,v in ipairs(tiers[v.id]) do
                            currentTier = 0
                            for _,n in ipairs(list) do
                                if n == v then
                                    currentTier = k
                                    break
                                end
                            end
                            if currentTier ~= 0 then break end
                        end
                    else
                        if tiers[v.id] then
                            currentTier = 0
                        end
                    end

                    if currentTier and currentTier < #tiers[v.id] then
                        local nextTier = tiers[v.id][currentTier + 1]
                        v.id = powerups[itemMap[nextTier]].items[1]
                    end
                else
                    if player.powerup == 1 then
                        v.id = 9
                    end
                    return
                end
            end
        end
    end

    if currentPowerup and player.forcedState == 0 and ap.getPowerup() ~= currentPowerup.name then
        currentPowerup.onDisable()
        currentPowerup = nil
        SaveData._ap.cp = nil
    end
    if currentPowerup then
        currentPowerup.onTickEnd()
    end

    if isPoweringUp then
        if not (player.forcedState ~= 0 or (currentPowerup and ap.getPowerup() ~= currentPowerup.name)) then
            player.powerup = isPoweringUp
            isPoweringUp = false
        end
    end
end

function ap.setPlayerPowerup(appower, silent, reservePowerup, thisPlayer)
    thisPlayer = thisPlayer or player
    local nextPower = 2

    if currentPowerup and appower.name ~= currentPowerup.name then
        currentPowerup.onDisable()
    end

    if not silent then
        if currentPowerup and appower.name == currentPowerup.name then
            if appower.apSounds ~= nil and appower.apSounds.reserve ~= nil then
                SFX.play(appower.apSounds.reserve)
            end

            if player.forcedState == 3 or player.forcedState == 41 then
                thisPlayer:mem(0x122, FIELD_WORD, 0)
                thisPlayer:mem(0x124, FIELD_WORD, 0)
            end
            return
        else
            if appower.apSounds ~= nil and appower.apSounds.upgrade ~= nil then
                SFX.play(appower.apSounds.upgrade)
            end

            if nextPower == 2 then
                thisPlayer:mem(0x122, FIELD_WORD, 4)
            else
                thisPlayer:mem(0x122, FIELD_WORD, 41)
            end
            thisPlayer:mem(0x124, FIELD_WORD, 100)
            
            --Audio.sounds[7].sfx = nil
        end
    
        isPoweringUp = nextPower
    else
        thisPlayer.powerup = nextPower
    end

    currentPowerup = appower
    SaveData._ap.cp = appower.name
    
    --thisPlayer.forcedState = 0
    --if thisPlayer.character > 5 then
        --error("Character IDs above 5 are unsupported.")
        --return
    --end

    loadPowerupAssets(thisPlayer,nextPower)

    currentPowerup.onEnable()
end

function ap.onStart()
    if Misc.inEditor() then
        SaveData._ap.cp = nil
        SaveData._ap.lastPowerupItem = nil

        currentPowerup = nil

        return
    end
    
    if SaveData._ap.cp then
        ap.setPlayerPowerup(powerups[SaveData._ap.cp], true)
    end
end

function ap.onPostNPCKill(v, r)
    if isPoweringUp then return end

    local p = npcManager.collected(v, r)

    if not p then
        return
    end

    local defaultPowerupID = defaultNPCPowerupMap[v.id]
    local apPowerupName = itemMap[v.id]

    if defaultPowerupID or apPowerupName then
        if p.character >= 3 and p.character <= 5 and not defaultPowerupID then
            p:mem(0x16, FIELD_WORD, p:mem(0x16, FIELD_WORD) + 1)
        end

        if SaveData._ap.lastPowerupItem then
            player.reservePowerup = SaveData._ap.lastPowerupItem
        end

        SaveData._ap.lastPowerupItem = v.id
    end

    if apPowerupName then
        ap.setPlayerPowerup(powerups[apPowerupName], false, v.id, p)
        v:kill(9)
    end
end

return ap