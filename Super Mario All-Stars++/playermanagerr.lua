--playerManagerSMAS.lua
--v1.0.2
--Created by Horikawa Otane, 2016
--Edited by Rednaxela, because why not
--Rocky was here too
--Enjl.
--Spencer Everly.
local playerManagerSMAS = {}

-- Local function definitions
local playerManagerInit
local configCharacter
local loadCharacterAPIs
local prepareCharacterSwaps
local loadCharacterSwaps
local unloadCharacterSwaps
local cleanupCharacter
local initCharacter
local updateCharacterHitbox
local updateCurrentCharacter

-- State variables
local currentCharacterId = {}
local characters = {}
local costumes = {}
local costumeswaps = {}
local characterAssets = {};
local costumeLua = {};
local lastCharacters = {};
characterAssets.graphics = {};
characterAssets.sounds = {};

--local costumeData = Data(Data.DATA_WORLD, "Costumes", true);
SaveData.__costumes = SaveData.__costumes or {}


local blockmanager

if not isOverworld then
    blockmanager = require("blockmanager")
end

local characterColliders = {}
                     
playerManagerSMAS.overworldCharacters = nil;
                     
-----------------------------------------
------ LOCAL FUNCTION DECLERATIONS ------
-----------------------------------------

function playerManagerInit()
    -- Define the characters
    configCharacter{id= 1, name="mario",           base=1, switchBlock=622, filterBlock=626, deathEffect=3}
    configCharacter{id= 2, name="luigi",           base=2, switchBlock=623, filterBlock=627, deathEffect=5}
    configCharacter{id= 3, name="peach",           base=3, switchBlock=624, filterBlock=628, deathEffect=129}
    configCharacter{id= 4, name="toad",            base=4, switchBlock=625, filterBlock=629, deathEffect=130}
    configCharacter{id= 5, name="link",            base=5, switchBlock=631, filterBlock=632, deathEffect=134}
    configCharacter{id= 6, name="megaman",         base=4, switchBlock=639, filterBlock=640, deathEffect=149}
    configCharacter{id= 7, name="wario",           base=1, switchBlock=641, filterBlock=642, deathEffect=150}
    configCharacter{id= 8, name="bowser",          base=2, switchBlock=643, filterBlock=644, deathEffect=151}
    configCharacter{id= 9, name="klonoa",          base=4, switchBlock=645, filterBlock=646, deathEffect=152}
    configCharacter{id=10, name="ninjabomberman",  base=3, switchBlock=647, filterBlock=648, deathEffect=153}
    configCharacter{id=11, name="rosalina",        base=3, switchBlock=649, filterBlock=650, deathEffect=154}
    configCharacter{id=12, name="snake",           base=5, switchBlock=651, filterBlock=652, deathEffect=155}
    configCharacter{id=13, name="zelda",           base=2, switchBlock=653, filterBlock=654, deathEffect=156}
    configCharacter{id=14, name="ultimaterinka",   base=4, switchBlock=655, filterBlock=656, deathEffect=157}
    configCharacter{id=15, name="unclebroadsword", base=1, switchBlock=659, filterBlock=660, deathEffect=159}
    configCharacter{id=16, name="samus",           base=5, switchBlock=663, filterBlock=664, deathEffect=161}
    
    -- Load Character APIs if this is not the overworld
    --if not isOverworld then
    loadCharacterAPIs()
    --end
    
    -- Update hitboxes early if possible
    if (characters[player.character] ~= nil) then
        updateCharacterHitbox(player.character)
    end
    
    initOverworldCharacters();
end

-- Function to declare a character
function configCharacter(params)
    -- A few sanity checks
    if (type(params)~='table') then error("Invalid character parameters") end
    if (type(params.id)~='number') then error("Invalid character.id parameter") end
    if (type(params.name)~='string') then error("Invalid character.name parameter") end
    if (type(params.base)~='number') then error("Invalid character.base parameter") end
    if (params.id <= 5) and (params.id ~= params.base) then error("Default character must have same id as base") end
    if (params.id <= 0) or (params.id > 0x7FFF) then error("Invalid character.id") end
    if (params.base <= 0) or (params.base > 5) then error("Invalid character.base") end
    
    -- Record character settings in a table
    characters[params.id] = params
    
    -- If it's not a built-in character, take further steps
    if (params.id ~= params.base) then
        -- Register character with LunaLua core
        Misc.registerCharacterId(params)
        
        -- Set character id constant
        _G["CHARACTER_" .. string.upper(params.name)] = params.id
        
        --Load character data so it carries between instances
        if(SaveData._basegame ~= nil and SaveData._basegame._characterdata ~= nil and SaveData._basegame._characterdata[tostring(params.id)] ~= nil) then
            local temp = Player.getTemplate(params.id);    
            local dat = SaveData._basegame._characterdata[tostring(params.id)];
            temp.powerup = dat.powerup;
            temp.reservePowerup = dat.reservePowerup;
            temp:mem(0x108, FIELD_WORD, dat["0x108"]);
            temp:mem(0x10A, FIELD_WORD, dat["0x10A"]);
            temp:mem(0x16, FIELD_WORD, dat["0x16"]);
            
            --[[
            for i=0x00,0x182,0x02 do
                temp:mem(i,FIELD_WORD,dat[tostring(i)]);
            end]]
        end
    end
end

-- Function to load all character APIs
function loadCharacterAPIs()
    local p = "characters/";
    if(isOverworld) then
        p = p.."overworld/";
    end
    for id, params in pairs(characters) do
        -- Load the API and store a reference to it
        if (params.id ~= params.base) and (params.api == nil) then
            if(not isOverworld or Misc.resolveFile(p..params.name..".lua")) then
                params.api = API.load(p .. params.name)
            end
        end
        
        -- Also attempt to load custom NPC graphics overrides
        if (params.swaps == nil) then
            params.swaps = prepareCharacterSwaps(params)
        end
    end
end

function playerManagerSMAS.overrideCharacterLib(id, lib)
    local p = "characters/";
    if(isOverworld) then
        p = p.."overworld/";
    end
    local params = characters[id]
    local loadedTable = package.loaded
    
    clearEvents(params.api)
    
    loadedTable[p..params.name] = lib
    loadedTable[string.lower(p..params.name)] = lib
    loadedTable[string.lower("scripts/"..p..params.name..".lua")] = lib
    
    params.api = lib
    
    return lib
end

--Prepare costume asset swaps for vanilla objects such as NPCs
function prepareCharacterSwaps(params, path)
    local swapTypes = {'npc', 'effect', 'sound'}
    local swapPattern = {npc='^npc%-(%d+)%.png$', effect='^effect%-(%d+)%.png$', sound='^sound%-(%d+)%.ogg$'}
    local swaps = {}
    local characterDir = Misc.resolveDirectory("graphics/characters/" .. params.name)
    local fileList = Misc.listFiles(characterDir)
    for _,v in ipairs(fileList) do
        for _,swapType in ipairs(swapTypes) do
            local swapId = v:lower():match(swapPattern[swapType])
            if swapId ~= nil then
                swapId = tonumber(swapId)
                local fn = characterDir .. "\\" .. v
                local res
                if (swapType == 'sound') then
                    res = Audio.SfxOpen(fn)
                else
                    res = Graphics.loadImage(fn)
                end
                if (res ~= nil) then
                    if (swaps[swapType] == nil) then
                        swaps[swapType] = {}
                    end
                    swaps[swapType][swapId] = res
                end
                break
            end
        end
    end
    return swaps;
end

--Perform costume asset swaps
local defaultCharacterSwaps = {}
local function loadCharacterSwaps(params)
    if(params ~= nil) then
        local swaps = params.swaps;
        if(swaps == nil) then
            swaps = {}
        end
        if (swaps ~= nil) then
            for swapType, items in pairs(swaps) do
                for swapId, swapRes in pairs(items) do
                    
                    if defaultCharacterSwaps[swapType] == nil then
                        defaultCharacterSwaps[swapType] = {}
                    end
                    
                    if (swapType == 'sound') then
                        defaultCharacterSwaps[swapType][swapId] = Audio.sounds[swapId].sfx
                        Audio.sounds[swapId].sfx = swapRes
                    else
                        defaultCharacterSwaps[swapType][swapId] = Graphics.sprites[swapType][swapId].img
                        Graphics.sprites[swapType][swapId].img = swapRes
                    end
                end
            end
        end
    end
end

--Revert costume asset swaps
local function unloadCharacterSwaps()
    for defType, items in pairs(defaultCharacterSwaps) do
        for defId, defRes in pairs(items) do
            if (defType == 'sound') then
                Audio.sounds[defId].sfx = defRes
            else
                Graphics.sprites[defType][defId].img = defRes
            end
        end
    end
    defaultCharacterSwaps = {}
end

local function cleanupCharacter(characterId, player)
    -- Unload character graphics swaps
    unloadCharacterSwaps()
    
    if (characters[characterId] ~= nil) then
        local api = characters[characterId].api
        
        -- Revert old character API tweaks
        if (api ~= nil) and (api.cleanupCharacter ~= nil) then
            api.cleanupCharacter(player)
        end
    end
end

local function initCharacter(characterId, player)
    if (characters[characterId] ~= nil) then
        local api = characters[characterId].api
        
        -- Load character graphics swaps
        loadCharacterSwaps(characters[characterId])
        
        -- Configure character API tweaks
        if (api ~= nil) and (api.initCharacter ~= nil) then
            api.initCharacter(player)
        end
    end
end

function playerManagerSMAS.resolveIni(file, path)
    if(path == nil) then
        path = "";
    else
        path = path.."\\";
    end
    
    local iniFilePath = Misc.resolveFile(path..file) or getSMBXPath().."\\config\\character_defaults\\" .. file
    if (iniFilePath == nil) then
        Misc.warn("Cannot find: " .. iniFileName)
    end
    return iniFilePath;
end

function updateCharacterHitbox(characterId, path)
    -- Set hitboxes
    if(path == nil) then
        path = "";
    else
        path = path.."\\";
    end
    local baseId = characters[characterId].base;
    for i = 1, 7, 1 do
    
        local iniFilePath = playerManagerSMAS.getHitboxPath(characterId, i);
        if (iniFilePath == nil) then
            Misc.warn("Cannot find: " .. iniFileName)
        else
            Misc.loadCharacterHitBoxes(baseId, i, iniFilePath)
        end
    end
    
    for _,p in ipairs(Player.get()) do
        if(p.character == characterId) then
            local ps = PlayerSettings.get(characters[characterId].base, p.powerup);
            local lastw,lasth = p.width, p.height;
            if(p:mem(0x108,FIELD_WORD) == 1) then
                p.height = 54;
            else
                p.height = ps.hitboxHeight;
            end
            p.width = ps.hitboxWidth;
            
            p.x = p.x-(p.width-lastw)*0.5;
            p.y = p.y-(p.height-lasth);
        end
    end
end

function playerManagerSMAS.getHitboxPath(characterId, power)
        local path = nil;
        if(costumes[characterId] ~= nil) then
            path = "costumes\\"..characters[characterId].name.."\\"..costumes[characterId];
        end
        
        return playerManagerSMAS.resolveIni("characters/"..characters[characterId].name .. "-" .. power .. ".ini", path);
end

function playerManagerSMAS.winStateCheck()
    if Level.winState() ~= 0 or player:mem(0x13E,FIELD_WORD) > 0 then
        player.leftKeyPressing = false
        player.rightKeyPressing = false
        player.upKeyPressing = false
        player.downKeyPressing = false
        player.jumpKeyPressing = false
        player.altJumpKeyPressing = false
        player.runKeyPressing = false
        player.altRunKeyPressing = false
        player.pauseKeyPressing = false
        player.dropItemKeyPressing = false
    end
end

local function updatePlayerCharacter(p)
    local newCharacterId = p.character
    
    if (currentCharacterId[p] ~= newCharacterId) and (characters[newCharacterId] ~= nil) then
        local characterName = characters[newCharacterId].name
        local baseId = characters[newCharacterId].base
        
        -- Revert old character API adjustments
        cleanupCharacter(currentCharacterId[p], p)
        
        local path = nil;
        if(costumes[newCharacterId] ~= nil) then
            path = "costumes\\"..characterName.."\\"..costumes[newCharacterId];
        end
        
        -- Set hitboxes
        updateCharacterHitbox(newCharacterId)
        
        -- Init new character API adjustments
        initCharacter(newCharacterId, p)
        
        -- Set new character id marker
        currentCharacterId[p] = newCharacterId
    end
end

-- Function to update things based on current character
local function updateCurrentCharacter()
    for _,v in ipairs(Player.get()) do
        updatePlayerCharacter(v);
    end
end

local function getUID(assetlist)
    local i = #assetlist + 1;
    while(assetlist[i] ~= nil) do
        i = i+1;
    end
    return i;
end

--Register a graphic as being replaceable by costumes
function playerManagerSMAS.registerGraphic(characterID, key, filename)
    if(characterAssets.graphics[characterID] == nil) then
        characterAssets.graphics[characterID] = {__default = {}}
    end
    if(filename == nil) then
        filename = key;
        key = getUID(characterAssets.graphics[characterID].__default);
    end
    characterAssets.graphics[characterID].__default[key] = {path = filename, file = Graphics.loadImageResolved("characters/"..characters[characterID].name.."/"..filename)};
    return key;
end

--Register a sound as being replaceable by costumes
function playerManagerSMAS.registerSound(characterID, key, filename)
    if(characterAssets.sounds[characterID] == nil) then
        characterAssets.sounds[characterID] = {__default = {}}
    end    
    if(filename == nil) then
        filename = key;
        key = getUID(characterAssets.sounds[characterID].__default);
    end
    characterAssets.sounds[characterID].__default[key] = {path = filename, file = Misc.multiResolveFile(filename, "sound\\character\\"..filename)};
    return key;
end

--Get a costume replaceable asset
local function getAsset(assetlist,characterID,key)
    if assetlist[characterID] == nil or
       assetlist[characterID][costumes[characterID]] == nil or
       assetlist[characterID][costumes[characterID]][key] == nil or
       assetlist[characterID][costumes[characterID]][key].file == nil then
        if(assetlist[characterID] == nil or assetlist[characterID].__default[key] == nil) then
            return nil;
        else
            return assetlist[characterID].__default[key].file;
        end
    else
            return assetlist[characterID][costumes[characterID]][key].file;
    end
end

--Get a costume replaceable graphic
function playerManagerSMAS.getGraphic(characterID, key)
    return getAsset(characterAssets.graphics,characterID,key)
end

--Get a costume replaceable sound
function playerManagerSMAS.getSound(characterID, key)    
    return getAsset(characterAssets.sounds,characterID,key)
end

local function listDirs(path)
    if(path == nil) then
        return {};
    end
    return Misc.listDirectories(path) or {};
end

local icontains = table.icontains;

--Load the character roster that is switchable on the world map
function initOverworldCharacters()
    if(playerManagerSMAS.overworldCharacters == nil) then
        playerManagerSMAS.overworldCharacters = {}
        
        --Read from world file to fill in vanilla character filters.
        if(isOverworld) then
            local wldPath = nil;
            for _,v in ipairs(Misc.listLocalFiles("")) do
                --TODO: add "x?" before the $ when wldx files are supported.
                if(v:match("^.*%.wld$")) then
                    wldPath = v;
                    break;
                end
            end
            if(wldPath ~= nil) then
                
                wldPath = Misc.episodePath()..wldPath;
                local headerData = FileFormats.openWorldHeader(wldPath)
                if(headerData.meta and headerData.meta.isValid) then 
                    --TODO: read from disableCharacters table properly (this just restricts to the main 5 (minus any filtered) if the header table has any restricted)
                    if #headerData.disableCharacters > 0 then
                        for i=1,5 do
                            if not headerData.disableCharacters[i] then
                                table.insert(playerManagerSMAS.overworldCharacters, i);
                            end
                        end
                        
                        if #playerManagerSMAS.overworldCharacters == 5 then
                            playerManagerSMAS.overworldCharacters = {}
                        end
                    end
                --[[ --old wld only system
                    local mainFive = {true,true,true,true,true};
                    local i = 0;
                    local count = 5;
                    wldPath = Misc.episodePath()..wldPath;
                    if fileExists(wldPath) then --Fix for a weird editor bug
                    for line in io.lines(wldPath) do
                        if(i == 0 and tonumber(line) < 55) then --File format doesn't support character filters
                            break;
                        elseif(i > 1 and i < 7) then
                            mainFive[i-1] = (line ~= "#TRUE#");
                            if(not mainFive[i-1]) then
                                count = count - 1;
                            end
                        elseif(i >= 7) then
                            break;
                        end
                        i = i + 1;
                    end
                    if(count < 5) then
                        for k,v in ipairs(mainFive) do
                            if(v) then
                                table.insert(playerManagerSMAS.overworldCharacters, k);
                            end
                        end
                    end
                ]]
                end
            end
        end
        
        if(#playerManagerSMAS.overworldCharacters == 0) then
            for k,v in pairs(characters) do
                if(k ~= CHARACTER_ULTIMATERINKA --[[and k~= CHARACTER_PRINCESSRINKA]]) then --Exclude certain rinka-based characters
                    table.insert(playerManagerSMAS.overworldCharacters, k);
                end
            end
        end
    end
end

local function resolveCostumeFile(characterID, costumeName, filename)
    return Misc.multiResolveFile(costumeName.."\\"..filename, "costumes\\"..characters[characterID].name.."\\"..costumeName.."\\"..filename);
end

--Empty out swaps made by the current costume that are not directly related to the character (NPCs and such)
local function cleanupCostumeResidue(characterID)    
    if(costumeswaps[characterID] ~= nil and costumeswaps[characterID].residual ~= nil) then
        for swapType, items in pairs(costumeswaps[characterID].residual) do
            for swapId, swapRes in pairs(items) do
                if (swapType == 'sound') then
                    Audio.sounds[swapId].sfx = swapRes
                else
                    Graphics.sprites[swapType][swapId].img = swapRes
                end
            end
        end
    end
    costumeswaps[characterID] = nil;
end

--Load costume.lua file
--TODO: Fix this so it hot-loads and unloads correctly
local function loadCostumeLua(path, plr)
    local luafile = nil;
    local func, err = loadfile(path)
    if(func)then
        luafile = func()
        if(type(luafile) ~= "table")then
            error("Costume Lua file \""..path.."\" did not return the table (got "..type(luafile)..")", 2)
        end
    else
        if(not err:find("such file"))then
            error(err,2)
        end
    end
            
    if(not luafile) then error("Costume Lua file failed to load correctly: \""..path.."\"",2) end
   
    if(luafile.onInit ~= nil and type(luafile.onInit) == "function")then
        luafile.onInit(plr);
    end
    return luafile;
end

--Make sure costume lua is correct
local function updateCostumeLua(index, costumeName)
    if(isOverworld) then
        return;
    end
    local plr = Player(index);
    if(plr == nil) then
        return;
    end
    if(costumeLua[index] ~= nil) then
        local sharedCostume = false;
        for k,v in pairs(costumeLua) do
            if(k ~= index and v == costumeLua[index]) then --Another player is using the costume, so don't clean it update
                sharedCostume = true;
                break;
            end
        end
        
        if(costumeLua[index].onCleanup ~= nil and type(costumeLua[index].onCleanup) == "function") then
            costumeLua[index].onCleanup(plr);
        end
        
        if(not sharedCostume) then
            clearEvents(costumeLua[index]);
        end
    end
    local pth = nil;
    if(costumeName ~= nil) then
        pth = resolveCostumeFile(plr.character, costumeName, "costume.lua");
        if(pth ~= nil) then
            costumeLua[index] = loadCostumeLua(pth, plr);
        else
            costumeLua[index] = {};
        end
    else
        costumeLua[index] = {};
    end
end

--Make sure the current costume asset swaps are correct
local function updateCostumeSwaps(plr)
        if(plr == nil) then
            return;
        end
        if(costumeswaps[plr.character] ~= nil) then
            for swapType, items in pairs(costumeswaps[plr.character].swaps) do
                for swapId, swapRes in pairs(items) do
                    if(costumeswaps[plr.character].residual[swapType] == nil) then
                        costumeswaps[plr.character].residual[swapType] = {}
                    end
                    if (swapType == 'sound') then
                        costumeswaps[plr.character].residual[swapType][swapId] = Audio.sounds[swapId].sfx;
                        Audio.sounds[swapId].sfx = swapRes
                    else
                        costumeswaps[plr.character].residual[swapType][swapId] = Graphics.sprites[swapType][swapId].img;
                        Graphics.sprites[swapType][swapId].img = swapRes
                    end
                end
            end
        end
end

--Warning: could mess up things if used on characters that are not currently in use. Use with caution.
function playerManagerSMAS.refreshHitbox(characterID)
    updateCharacterHitbox(characterID);
end

do
    local objs = {};
          objs.switchBlock = "block";
          objs.filterBlock = "block";
          objs.deathEffect = "effect";
          
    local objlist = {"switchBlock", "filterBlock", "deathEffect"}
    
    local assetTypes = {"graphics", "sounds"}
          
    function playerManagerSMAS.setCostume(characterID, costumeName, volatile)
        
        local savedata = volatile ~= true;
        --Quick exit if the costume we're changing to is the current costume.
        if((costumeName ~= nil and costumes[characterID] == costumeName:upper()) or (costumeName == nil and costumes[characterID] == nil)) then
            if(savedata) then
                if(SaveData.__costumes[tostring(characterID)] ~= costumeName) then
                    if(costumeName == nil) then
                        costumeName = "";
                    end
                    SaveData.__costumes[tostring(characterID)] = costumeName;
                end
            end
            return;
        end

        local shouldCallChangeEvent = false;
        
        --Clean up any swaps not directly associated with the character (such as NPCs)
        cleanupCostumeResidue(characterID);
        
        --We're reverting to default costume
        if(costumeName == nil or costumeName == "" or not icontains(playerManagerSMAS.getCostumes(characterID), costumeName:upper())) then 
        
            --If we want to save costume data, write it now
            if(savedata) then
                SaveData.__costumes[tostring(characterID)] = nil;
            end
            
            --Revert costume tag and see if we should call the change event
            shouldCallChangeEvent = costumes[characterID] ~= nil;
            costumes[characterID] = nil;
            
            --Load hitboxes
            if(characterID == player.character) then
                updateCharacterHitbox(characterID);
            end
            
            --Revert sprite sheets
            for i = 1, 7 do
                Graphics.sprites[characters[characterID].name][i].img = nil;
            end
            
            --Revert filter blocks and death effects
            for _,index in ipairs(objlist) do
                local objType = objs[index];
                if(characters[characterID][index] ~= nil) then
                    Graphics.sprites[objType][characters[characterID][index]].img = nil;
                end
            end
            
            --Revert overworld sprites
            Graphics.sprites.player[characterID].img = nil;
            
        else
            --Make costume names case insensitive
            costumeName = costumeName:upper();
            
            --If we want to save costume data, write it now
            if(savedata) then
                SaveData.__costumes[tostring(characterID)] = costumeName;
            end
            
            --Revert costume tag and see if we should call the change event
            shouldCallChangeEvent = costumes[characterID] ~= costumeName;
            costumes[characterID] = costumeName;
            
            --Load hitboxes
            for _,p in ipairs(Player.get()) do
                if(characterID == p.character) then
                    updateCharacterHitbox(characterID);
                    break
                end
            end
            
            --Load costume sprites - if we didn't find any, revert to default
            for i = 1, 7 do
                local filename = characters[characterID].name.."-"..i..".png";
                local path = resolveCostumeFile(characterID, costumeName, filename);
                if(path ~= nil) then
                    Graphics.sprites[characters[characterID].name][i].img = Graphics.loadImage(path);
                else
                    Graphics.sprites[characters[characterID].name][i].img = nil;
                end
            end
            
            --Load filter blocks and death effects - if we didn't find any, revert to default
            for _,index in ipairs(objlist) do
                local objType = objs[index];
                if(characters[characterID][index] ~= nil) then
                    local filename = objType.."-"..characters[characterID][index]..".png";
                    local path = resolveCostumeFile(characterID, costumeName, filename);
                    if(path ~= nil) then
                        Graphics.sprites[objType][characters[characterID][index]].img = Graphics.loadImage(path);
                    else
                        Graphics.sprites[objType][characters[characterID][index]].img = nil;
                    end
                end
            end
            
            --Create a list of other sprites to swap out
            if(costumeswaps[characterID] == nil) then
                costumeswaps[characterID] = {};
                costumeswaps[characterID].residual = {};
                costumeswaps[characterID].swaps = prepareCharacterSwaps({}, Misc.resolveDirectory("costumes\\"..characters[characterID].name.."\\"..costumeName));
            end
            
            --Perform the sprite swaps if we find a player using this costume
            for i=1,Player.count() do
                local plr = Player(i);
                if(plr ~= nil) then
                    if(characterID == plr.character) then
                        updateCostumeSwaps(plr);
                        break;
                    end
                end
            end
            
            --Prepare and perform asset swaps for non-vanilla assets (graphics and sounds)
            for _,assetType in ipairs(assetTypes) do
                local assets = characterAssets[assetType];
                if(assets[characterID] == nil) then
                    assets[characterID] = {__default = {}};
                end
                if(assets[characterID][costumeName] == nil) then
                    assets[characterID][costumeName] = {}
                    for k,v in pairs(assets[characterID].__default) do
                        local f = resolveCostumeFile(characterID,costumeName,v.path);
                        if(f ~= nil) then
                            if(assetType ~= "sounds") then
                                f = Graphics.loadImage(f);
                            end
                        else
                            f = assets[characterID].__default[k].file;
                        end
                        assets[characterID][costumeName][k] = {path = v.path, file = f};
                    end
                end
            end
            
            --Load overworld sprites
            local owpath = resolveCostumeFile(characterID,costumeName,"player-"..characterID..".png");
            if(owpath == nil) then
                Graphics.sprites.player[characterID].img = nil;
            else
                Graphics.sprites.player[characterID].img = Graphics.loadImage(owpath);
            end
        end
        --End of costume switch
        
        --If we did actually change the costume, then update the Lua if necessary, and call the onCostumeChange event
        if(shouldCallChangeEvent) then
            for k,v in ipairs(Player.get()) do
                if(v.character == characterID) then
                    updateCostumeLua(k, costumeName);
                end
            end
            
            playerManagerSMAS.onCostumeChange(characterID, costumes[characterID]);
        end
    end
end

function playerManagerSMAS.getCostumeImage(pl,power)
    local filename = characters[pl].name.."-"..power..".png";
    local costume = playerManagerSMAS.getCostume(pl);
    local path = resolveCostumeFile(pl, costume or "", filename);
    if(path ~= nil) then
        return Graphics.loadImage(path);
    else
        return nil;
    end
end

function playerManagerSMAS.getCharacters()
    local charTbl = {}
    
    for  k,v in pairs(characters)  do
        charTbl[v.id] = {}
        charTbl[v.id].name = v.name
        charTbl[v.id].switchBlock = v.switchBlock
        charTbl[v.id].filterBlock = v.filterBlock
        charTbl[v.id].base = v.base
        charTbl[v.id].deathEffect = v.deathEffect
    end
    
    return charTbl
end

function playerManagerSMAS.getName(characterID)
    return characters[characterID].name
end

function playerManagerSMAS.getBaseID(characterID)
    return characters[characterID].base
end

function playerManagerSMAS.getCostumes(characterID)
    local lists = {listDirs(Misc.resolveDirectory("costumes\\"..characters[characterID].name)), listDirs(getSMBXPath().."\\costumes\\"..characters[characterID].name)}
    local t = {}
    for _,list in ipairs(lists) do
        for _,v in ipairs(list) do
            v = v:upper();
            if(not icontains(t,v)) then
                table.insert(t,v);
            end
        end
    end
    return t;
end

function playerManagerSMAS.getCostumeFromData(characterID)
    local c = SaveData.__costumes[tostring(characterID)];
    if (c == "") then
        c = nil;
    end
    return c;
end

function playerManagerSMAS.getCostume(characterID)
    return costumes[characterID];
end

--[[
local function vanillaCostumeInit()

    for k,v in pairs(SaveData.__costumes) do
        if(tonumber(k) ~= nil and tonumber(k) < 6 and characters[tonumber(k)] ~= nil) then
            playerManagerSMAS.setCostume(tonumber(k),(v:match'^()%s*$' and '' or v:match'^%s*(.*%S)'))
        end
    end
end

local function newCostumeInit()

    for k,v in pairs(SaveData.__costumes) do
        if(tonumber(k) ~= nil and tonumber(k) >= 6 and characters[tonumber(k)] ~= nil) then
            playerManagerSMAS.setCostume(tonumber(k),(v:match'^()%s*$' and '' or v:match'^%s*(.*%S)'))
        end
    end
end
]]

local function costumeInit()
    for k,v in pairs(SaveData.__costumes) do
        k = tonumber(k);
        if(k ~= nil and characters[k] ~= nil) then
            playerManagerSMAS.setCostume(k,(v:match'^()%s*$' and '' or v:match'^%s*(.*%S)'))
        end
    end
end

local colliderMT = {};
function colliderMT.__index(tbl, k)
    if(k == "active") then
        return rawget(tbl,"active");
    else 
        return rawget(tbl,"collider")[k];
    end
end
function colliderMT.__newindex(tbl, k, v)
    if(k == "active") then
        rawset(tbl,"active",v);
    else 
        rawget(tbl,"collider")[k] = v;
    end
end

function playerManagerSMAS.registerCollider(character, index, name, collider)
    if(collider == nil) then return nil end;
    if(characterColliders[character] == nil) then
        characterColliders[character] = {};
    end
    if(characterColliders[character][index] == nil) then
        characterColliders[character][index] = {};
    end
    characterColliders[character][index][name] = {active = false, collider = collider};
    setmetatable(characterColliders[character][index][name], colliderMT);
    return characterColliders[character][index][name];
end

function playerManagerSMAS.getCollider(character, index, name)
    if(characterColliders[character] and characterColliders[character][index] and characterColliders[character][index][name] and characterColliders[character][index][name].active) then
        return characterColliders[character][index][name].collider;
    else
        return nil;
    end
end

---------------------------
---- CLASS  EXPANSIONS ----
---------------------------

function Player:getCollider(name)
    for k,v in ipairs(Player.get()) do
        if(self == v) then
            return playerManagerSMAS.getCollider(self.character,k,name);
        end
    end
    return nil;
end

function Player.getCostume(character)
    if(type(character) ~= "number" and character.__type == "Player") then
        character = character.character;
    end
    return playerManagerSMAS.getCostume(character);
end

function Player.setCostume(character, costumeName, volatile)
    if(type(character) ~= "number" and character.__type == "Player") then
        character = character.character;
    end
    playerManagerSMAS.setCostume(character, costumeName, volatile)
end

---------------------------
------ API CALLBACKS ------
---------------------------
function playerManagerSMAS.onInitAPI()
    registerEvent(playerManagerSMAS, "onStart", "onStart", false)
    registerEvent(playerManagerSMAS, "onLoop", "onLoop", false)
    registerEvent(playerManagerSMAS, "onTick", "onTick", false)
    
    if not isOverworld then
        registerEvent(playerManagerSMAS, "onTickEnd", "onTickEnd", false)
    end
    registerEvent(playerManagerSMAS, "onDraw", "onDraw", false)
    registerEvent(playerManagerSMAS, "onInputUpdate", "onInputUpdate", false)
    registerEvent(playerManagerSMAS, "onExit", "onExit", true)
    registerEvent(playerManagerSMAS, "onSaveGame")
    
    registerCustomEvent(playerManagerSMAS, "onCostumeChange");
    
    --vanillaCostumeInit();
    -- Try to load hitboxes early if we can
    playerManagerInit()
    costumeInit();
    
    --newCostumeInit();
    
    --Reset costume array so we can run the change again to ensure everything is ready.
    costumes = {};
end

function playerManagerSMAS.onStart()
    -- Also load hitboxes in onStart
    updateCurrentCharacter()
    
    for k,v in ipairs(Player.get()) do
        lastCharacters[k] = v.character;
    end
    --Make sure things like blocks are correctly changed too.
    costumeInit();
end

function playerManagerSMAS.onTick()
    -- Also load hitboxes in onStart
    updateCurrentCharacter()
    
    for k,v in ipairs(Player.get()) do
        if(lastCharacters[k] == nil) then
            lastCharacters[k] = v.character;
        elseif(v.character ~= lastCharacters[k]) then
            updateCostumeLua(k, costumes[v.character]);
            updateCostumeSwaps(v, costumes[v.character]);
            lastCharacters[k] = v.character;
        end
    end
end

function playerManagerSMAS.onTickEnd()
    for _,p in ipairs(Player.get()) do
        for k,v in Block.iterateIntersecting(p.x - 2, p.y - 2, p.x + p.width + 2, p.y + p.height + 2) do
            if(v.isValid and v:collidesWith(p) ~= 0) then
                if Block.COLLIDABLE_MAP[v.id] and (not v.isHidden) and (not v:mem(0x5A, FIELD_BOOL)) then
                    blockmanager.callExternalEvent("onCollide", v, p);
                end
            end
        end
    end
end

local pressedKeys = {};
local characterindex = 0

function playerManagerSMAS.onInputUpdate()
    --Set up the world map to support changing to all characters via the pause menu
    if(isOverworld) then
        if(not player.rightKeyPressing) then
            pressedKeys.right = false;
        end
        if(not player.leftKeyPressing) then
            pressedKeys.left = false;
        end

        --If game is paused
        if(mem(0x00B250E2, FIELD_BOOL)) then
            local charoffset;
            
            --Add or subtract from character index
            if(player.keys.right and not pressedKeys.right) then
                pressedKeys.right = true;
                charoffset = 1;
            elseif(player.keys.left and not pressedKeys.left) then
                pressedKeys.left = true;
                charoffset = -1;
            end
            
            --Adjust character if necessary
            if(charoffset ~= nil) then
                if characterindex == 0 or playerManagerSMAS.overworldCharacters[characterindex] ~= player.character then
                    characterindex = 0
                    for k,v in ipairs(playerManagerSMAS.overworldCharacters) do
                        if v == player.character then
                            characterindex = k
                            break
                        end
                    end
                end
            
                local index

                if characterindex > 0 then
                    characterindex = ((characterindex-1+charoffset)%#playerManagerSMAS.overworldCharacters) + 1
                else
                    characterindex = 1
                end
                index = playerManagerSMAS.overworldCharacters[characterindex]
                
                if index == nil then
                    index = 1
                    characterindex = 0
                end
                
                player:transform(index)
                updateCharacterHitbox(player.character)
                local ps = PlayerSettings.get(characters[player.character].base, player.powerup)
                if player:mem(0x108,FIELD_WORD) == 1 then
                    player.height = 54
                else
                    player.height = ps.hitboxHeight
                end
                player.width = ps.hitboxWidth
                Audio.playSFX(26)
            end
            
            --world:mem(0x112,FIELD_WORD,player.character)
            --Disable vanilla character switch (can we do this better?)
            player.rightKeyPressing = false;
            player.leftKeyPressing = false;
        end
    end
end

function playerManagerSMAS.onLoop()
    -- Also at this point too just in case
    updateCurrentCharacter()
end

function playerManagerSMAS.onDraw()
    -- Just in case to avoid a rendering glitch
    updateCurrentCharacter()
end

--Saves character data so it carries between lua instances
local function saveCharData(pids)
    if(SaveData._basegame == nil) then
        SaveData._basegame = {};
    end
    if(SaveData._basegame._characterdata == nil) then
        SaveData._basegame._characterdata = {};
    end
    
    for  k,v in pairs(characters)  do
        if(v.id > 5) then
            local temp;
            if(pids[v.id]) then
                temp = pids[v.id];
            else
                temp = Player.getTemplate(v.id);
            end
            if(SaveData._basegame._characterdata[tostring(v.id)] == nil) then
                SaveData._basegame._characterdata[tostring(v.id)] = {};
            end
            
            local dat = SaveData._basegame._characterdata[tostring(v.id)];
            dat.powerup = temp.powerup;
            dat.reservePowerup = temp.reservePowerup;
            dat["0x108"] = temp:mem(0x108, FIELD_WORD);
            dat["0x10A"] = temp:mem(0x10A, FIELD_WORD);
            dat["0x16"] = temp:mem(0x16, FIELD_WORD);
            
            --[[
            for i=0x00,0x182,0x02 do
                SaveData._basegame._characterdata[tostring(v.id)][tostring(i)] = temp:mem(i,FIELD_WORD);
            end]]
        end
    end
end

--Just ensure we save the powerup states and such of new characters
function playerManagerSMAS.onSaveGame()
    local pids = {};
    for _,v in ipairs(Player.get()) do    
        if(pids[v.character] == nil) then
            pids[v.character] = v;
        end
    end
    
    saveCharData(pids);
end

function playerManagerSMAS.onExit()
    local pids = {};
    for _,v in ipairs(Player.get()) do
        cleanupCharacter(currentCharacterId[v], v)
        if(pids[v.character] == nil) then
            pids[v.character] = v;
        end
    end
    
    saveCharData(pids);
end

return playerManagerSMAS