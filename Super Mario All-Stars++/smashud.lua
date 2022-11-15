-------------------smashud-------------------
-------Created by Hoeloe and Enjl  - 2017--------
--SMBX HUD Defaults & Override System Library----
--------------For Super Mario Bros X-------------
----------------------v1.1-----------------------
-------Edited for SMAS++ by Spencer Everly-------
local smashud = {}
local pm
local starcoin
local timer

local hasDied = false

local textplus = require("textplus")
local tplusnumberfont = textplus.loadFont("littleDialogue/font/1.ini")

local textCache = {}
local textCacheLifetime = 640
local textCacheList = {}

local smashudsprites = {}

if SaveData.allLifeCrownsAchieved == nil then
    SaveData.allLifeCrownsAchieved = false
end

local function ConvertSprite(img)
    if type(img) == "table" and img.img then
        return img.img
    else
        return img
    end
end

local spritesMT = {}
function spritesMT.__index(tbl, key)
    return ConvertSprite(smashudsprites[key])
end
function spritesMT.__newindex(tbl, key, val)
    smashudsprites[key] = val
end
function spritesMT.__pairs(tbl)
  local function iter(tbl, k)
    local v
    k, v = next(tbl, k)
    if nil~=v then return k, ConvertSprite(v) end
  end
  return iter, smashudsprites, nil
end
smashud.sprites = setmetatable({}, spritesMT)

local reserveBox2P = {}
reserveBox2P[1] = Graphics.sprites.hardcoded["48-1"]
reserveBox2P[2] = Graphics.sprites.hardcoded["48-2"]

smashudsprites.reserveBox = Graphics.sprites.hardcoded["48-0"]


smashudsprites.coins = Graphics.sprites.hardcoded["33-2"]


smashudsprites.cross = Graphics.sprites.hardcoded["33-1"]

smashudsprites.stars = Graphics.sprites.hardcoded["33-5"]


smashudsprites.lives = Graphics.loadImageResolved("graphics/hardcoded/hardcoded-100-2.png")
smashudsprites.livesClassic = Graphics.sprites.hardcoded["33-3"]
smashudsprites.lives2 = Graphics.sprites.hardcoded["33-7"]
smashudsprites.deathcount = Graphics.loadImageResolved("graphics/hardcoded/hardcoded-100-3.png")
--2nd one exclusive to battle mode?

smashudsprites.heartEmpty = Graphics.sprites.hardcoded["36-2"]
smashudsprites.heartFull = Graphics.sprites.hardcoded["36-1"]


smashudsprites.keys = Graphics.sprites.hardcoded["33-0"]
smashudsprites.bombs = Graphics.sprites.hardcoded["33-8"]

smashudsprites.overworldBox = Graphics.sprites.hardcoded["33-4"]

smashudsprites.arrowUp = Graphics.sprites.hardcoded["34-1"]
smashudsprites.arrowDown = Graphics.sprites.hardcoded["34-2"]

smashudsprites.starcoinUncollected = Graphics.sprites.hardcoded["51-0"]
smashudsprites.starcoinCollected = Graphics.sprites.hardcoded["51-1"]

smashudsprites.timer = Graphics.sprites.hardcoded["52"]

local SpriteDefaults = {}
for k,v in pairs(smashudsprites) do
    SpriteDefaults[k] = v
end


smashud.visible = {}
smashud.visible.keys = true
smashud.visible.itembox = true
smashud.visible.bombs = true
smashud.visible.coins = true
smashud.visible.score = true
if SaveData.enableLives then
    smashud.visible.lives = true
else
    smashud.visible.lives = false
end
if SaveData.disableX2char == false then
    smashud.visible.deathcount = true
else
    smashud.visible.deathcount = false
end
smashud.visible.stars = true
smashud.visible.starcoins = true
smashud.visible.timer = true
smashud.visible.levelname = true
smashud.visible.overworldPlayer = true

smashud.visible.customitembox = true
smashud.visible.pWing = true

smashud.priority = -4.2

smashud.ALIGN_LEFT = 0
smashud.ALIGN_RIGHT = 1
smashud.ALIGN_MID = 0.5

smashud.offsets = {}

--TODO: Replace this with object-level offsets with named fields and alignments
if SaveData.disableX2char == true then
    smashud.offsets.keys =         {x = 64,     y = 26, align = smashud.ALIGN_LEFT};
    smashud.offsets.itembox =     {x = 0,     y = 16, item = {x = 28, y = 28, align = smashud.ALIGN_MID}, align = smashud.ALIGN_MID};
    smashud.offsets.hearts =     {x = 5,     y = 16, align = smashud.ALIGN_MID};
    smashud.offsets.score =     {x = 170,     y = 47, align = smashud.ALIGN_RIGHT};

    smashud.offsets.bombs =     {x = 0,     y = 52, cross = {x = 24, y = 1}, value = {x = 45, y = 1, align = smashud.ALIGN_LEFT}, align = smashud.ALIGN_MID};
    smashud.offsets.coins =     {x = 88,     y = 26, cross = {x = 24, y = 1}, value = {x = 82, y = 1, align = smashud.ALIGN_RIGHT}, align = smashud.ALIGN_LEFT};
    smashud.offsets.lives =     {x = -166,     y = 26, cross = {x = 40, y = 1}, value = {x = 62, y = 1, align = smashud.ALIGN_LEFT}, align = smashud.ALIGN_LEFT};
    smashud.offsets.deathcount = {x = -56, y = 26, cross = {x = 40, y = 1}, value = {x = 62, y = 1, align = smashud.ALIGN_LEFT}, align = smashud.ALIGN_LEFT};
    smashud.offsets.stars =     {x = -150,     y = 46, cross = {x = 24, y = 1}, value = {x = 45, y = 1, align = smashud.ALIGN_LEFT}, align = smashud.ALIGN_LEFT};
    smashud.offsets.starcoins = {x = -384, y = 27, cross = {x = 24, y = 0},    value = {x = 45, y = 0, align = smashud.ALIGN_LEFT}, grid = {x = 0, y = 40, width = 5, height = 3, offset = 0, table = {}, align = smashud.ALIGN_LEFT},    align = smashud.ALIGN_LEFT}
    smashud.offsets.timer = {x = 264, y = 25, cross = {x = 24, y = 2},    value = {x = 106, y = 2, align = smashud.ALIGN_RIGHT}, align = smashud.ALIGN_LEFT}

    smashud.overworld = {offsets = {}};
    smashud.overworld.offsets.lives =         {x = -272,     y = 110, cross = {x = 40, y = 2}, p2Offset = {x = 48, y = 0}, value = {x = 62, y = 2, align = smashud.ALIGN_LEFT}, align = smashud.ALIGN_LEFT};
    smashud.overworld.offsets.coins =         {x = -256,     y = 88, cross = {x = 24, y = 2}, p2Offset = {x = 48, y = 0}, value = {x = 46, y = 2, align = smashud.ALIGN_LEFT}, align = smashud.ALIGN_LEFT};
    smashud.overworld.offsets.stars =         {x = -256,     y = 66, cross = {x = 24, y = 2}, p2Offset = {x = 48, y = 0}, value = {x = 46, y = 2, align = smashud.ALIGN_LEFT}, align = smashud.ALIGN_LEFT};
    smashud.overworld.offsets.levelname =     {x = -156,     y = 109, p2Offset = {x = 48, y = 0}, align = smashud.ALIGN_LEFT};
    smashud.overworld.offsets.player =        {x = -308, y = 124}
    smashud.overworld.offsets.player2 =        {x = -308+48, y = 124}
end

if SaveData.disableX2char == false then
    smashud.offsets.keys =         {x = -268,     y = 26, align = smashud.ALIGN_LEFT};
    smashud.offsets.itembox =     {x = 0,     y = 16, item = {x = 28, y = 28, align = smashud.ALIGN_MID}, align = smashud.ALIGN_MID};
    smashud.offsets.hearts =     {x = 5,     y = 16, align = smashud.ALIGN_MID};
    smashud.offsets.score =     {x = 370,     y = 27, align = smashud.ALIGN_RIGHT};

    smashud.offsets.bombs =     {x = 0,     y = 52, cross = {x = 24, y = 1}, value = {x = 45, y = 1, align = smashud.ALIGN_LEFT}, align = smashud.ALIGN_MID};
    smashud.offsets.coins =     {x = -368,     y = 26, cross = {x = 24, y = 1}, value = {x = 46, y = 1, align = smashud.ALIGN_LEFT}, align = smashud.ALIGN_LEFT};
    smashud.offsets.lives =     {x = -160,     y = 40, cross = {x = 42, y = 1}, value = {x = 88, y = 1, align = smashud.ALIGN_MID}, align = smashud.ALIGN_MID};
    smashud.offsets.deathcount = {x = 102, y = 40, cross = {x = 25, y = 1}, value = {x = 78, y = 1, align = smashud.ALIGN_MID}, align = smashud.ALIGN_LEFT};
    smashud.offsets.stars =     {x = -368,     y = 48, cross = {x = 24, y = 1}, value = {x = 45, y = 1, align = smashud.ALIGN_LEFT}, align = smashud.ALIGN_LEFT};
    smashud.offsets.starcoins = {x = -384, y = 27, cross = {x = 24, y = 0},    value = {x = 45, y = 0, align = smashud.ALIGN_LEFT}, grid = {x = 0, y = 40, width = 5, height = 3, offset = 0, table = {}, align = smashud.ALIGN_LEFT},    align = smashud.ALIGN_LEFT}
    smashud.offsets.timer = {x = 264, y = 47, cross = {x = 24, y = 2},    value = {x = 106, y = 2, align = smashud.ALIGN_RIGHT}, align = smashud.ALIGN_LEFT}

    smashud.overworld = {offsets = {}};
    smashud.overworld.offsets.lives =         {x = -272,     y = 110, cross = {x = 40, y = 2}, p2Offset = {x = 48, y = 0}, value = {x = 62, y = 2, align = smashud.ALIGN_LEFT}, align = smashud.ALIGN_LEFT};
    smashud.overworld.offsets.coins =         {x = -256,     y = 88, cross = {x = 24, y = 2}, p2Offset = {x = 48, y = 0}, value = {x = 46, y = 2, align = smashud.ALIGN_LEFT}, align = smashud.ALIGN_LEFT};
    smashud.overworld.offsets.stars =         {x = -256,     y = 66, cross = {x = 24, y = 2}, p2Offset = {x = 48, y = 0}, value = {x = 46, y = 2, align = smashud.ALIGN_LEFT}, align = smashud.ALIGN_LEFT};
    smashud.overworld.offsets.levelname =     {x = -156,     y = 109, p2Offset = {x = 48, y = 0}, align = smashud.ALIGN_LEFT};
    smashud.overworld.offsets.player =        {x = -308, y = 124}
    smashud.overworld.offsets.player2 =        {x = -308+48, y = 124}
end

if SaveData.disableX2char == nil then
    smashud.offsets.keys =         {x = -268,     y = 26, align = smashud.ALIGN_LEFT};
    smashud.offsets.itembox =     {x = 0,     y = 16, item = {x = 28, y = 28, align = smashud.ALIGN_MID}, align = smashud.ALIGN_MID};
    smashud.offsets.hearts =     {x = 5,     y = 16, align = smashud.ALIGN_MID};
    smashud.offsets.score =     {x = 370,     y = 27, align = smashud.ALIGN_RIGHT};

    smashud.offsets.bombs =     {x = 0,     y = 52, cross = {x = 24, y = 1}, value = {x = 45, y = 1, align = smashud.ALIGN_LEFT}, align = smashud.ALIGN_MID};
    smashud.offsets.coins =     {x = -368,     y = 26, cross = {x = 24, y = 1}, value = {x = 46, y = 1, align = smashud.ALIGN_LEFT}, align = smashud.ALIGN_LEFT};
    smashud.offsets.lives =     {x = -102,     y = 40, cross = {x = 42, y = 1}, value = {x = 88, y = 1, align = smashud.ALIGN_MID}, align = smashud.ALIGN_RIGHT};
    smashud.offsets.deathcount = {x = 102, y = 40, cross = {x = 25, y = 1}, value = {x = 78, y = 1, align = smashud.ALIGN_MID}, align = smashud.ALIGN_LEFT};
    smashud.offsets.stars =     {x = -368,     y = 48, cross = {x = 24, y = 1}, value = {x = 45, y = 1, align = smashud.ALIGN_LEFT}, align = smashud.ALIGN_LEFT};
    smashud.offsets.starcoins = {x = -384, y = 27, cross = {x = 24, y = 0},    value = {x = 45, y = 0, align = smashud.ALIGN_LEFT}, grid = {x = 0, y = 40, width = 5, height = 3, offset = 0, table = {}, align = smashud.ALIGN_LEFT},    align = smashud.ALIGN_LEFT}
    smashud.offsets.timer = {x = 264, y = 47, cross = {x = 24, y = 2},    value = {x = 106, y = 2, align = smashud.ALIGN_RIGHT}, align = smashud.ALIGN_LEFT}

    smashud.overworld = {offsets = {}};
    smashud.overworld.offsets.lives =         {x = -272,     y = 110, cross = {x = 40, y = 2}, p2Offset = {x = 48, y = 0}, value = {x = 62, y = 2, align = smashud.ALIGN_LEFT}, align = smashud.ALIGN_LEFT};
    smashud.overworld.offsets.coins =         {x = -256,     y = 88, cross = {x = 24, y = 2}, p2Offset = {x = 48, y = 0}, value = {x = 46, y = 2, align = smashud.ALIGN_LEFT}, align = smashud.ALIGN_LEFT};
    smashud.overworld.offsets.stars =         {x = -256,     y = 66, cross = {x = 24, y = 2}, p2Offset = {x = 48, y = 0}, value = {x = 46, y = 2, align = smashud.ALIGN_LEFT}, align = smashud.ALIGN_LEFT};
    smashud.overworld.offsets.levelname =     {x = -156,     y = 109, p2Offset = {x = 48, y = 0}, align = smashud.ALIGN_LEFT};
    smashud.overworld.offsets.player =        {x = -308, y = 124}
    smashud.overworld.offsets.player2 =        {x = -308+48, y = 124}
end

Graphics.HUD_NONE = 0;
Graphics.HUD_HEARTS = 1;
Graphics.HUD_ITEMBOX = 2;

smashud.multiplayerOffsets = {[Graphics.HUD_NONE] = 0, [Graphics.HUD_ITEMBOX] = 40, [Graphics.HUD_HEARTS] = 57}

local isActive = true

local activeCameras = nil
local activePlayers = nil

local oldActivate = Graphics.activateHud

function smashud.onInitAPI()
    registerEvent(smashud, "onExitLevel", "onExitLevel", false)
    --TODO: Change onHUDDraw to "true" when onHUDUpdate is implemented
    registerEvent(smashud, "onHUDDraw", "onHUDDraw", false)
    registerEvent(smashud, "onDraw", "onDraw", false)
    registerEvent(smashud, "onTick", "onTick", false)
    
    if(oldActivate) then
        oldActivate(false)
    end

    SaveData._basegame = SaveData._basegame or {}

    if SaveData._basegame.hud == nil then
        SaveData._basegame.hud = {}
        SaveData._basegame.hud.score = 0
        SaveData._basegame.starcoin = {}
    end
    mem(0x00B2C8E4, FIELD_DWORD, 0)
    pm = require("playerManager")
    if not isOverworld then
        starcoin = require("npcs/ai/starcoin")
        timer = require("timer-mod")
    end
end

function Graphics.activateHud(setActive)
    if type(setActive) == "boolean" then
        isActive = setActive
    elseif setActive == nil then
        isActive = not isActive
    else
        error("No matching overload found. Candidates: Graphics.activateHud(bool setActive), Graphics.activateHud()", 2)
    end
end

function Graphics.isHudActivated()
    return isActive
end

_G["hud"] = Graphics.activateHud

local function drawCounterValue(value, x, y, priority)
    local v = tostring(value)
    if textCache[v] == nil then
        textCache[v] = {[1] = textplus.layout(v, nil, {font = tplusnumberfont, plaintext = true}), [2] = textCacheLifetime}
        table.insert(textCacheList, v)
    end
    
    textplus.render{
                    layout = textCache[v][1], 
                    x = x,    
                    y = y,
                    priority = priority
                   }
    textCache[v][2] = textCacheLifetime
end

local function renderHUD(camIndex, priority, isSplit)
    if(mem(0x00B2C89C, FIELD_DWORD) ~= -1 and mem(0x00B2C620, FIELD_WORD) ~= -1 and mem(0x00B2C89C, FIELD_WORD) ~= -1) then
        Graphics.drawVanillaHUD(camIndex, priority, isSplit);
    end
end

local function renderOWHUD(priority)
    Graphics.drawVanillaOverworldHUD(priority);
end

local currentRenderFunc = renderHUD;
local currentOWRenderFunc = renderOWHUD;

function Graphics.overrideHUD(f)
    currentRenderFunc = f or renderHUD;
end

function Graphics.overrideOverworldHUD(f)
    currentOWRenderFunc = f or renderOWHUD;
end

local function drawLinkStuff(playerIdx, camObj, playerObj, priority, isSplit, playerCount)
    local offset = Graphics.getHUDOffset(playerIdx, isSplit);

    local keyOffset = 0
    if(playerIdx == 1 and not isSplit and playerCount > 1) then
        keyOffset = -132
    end

    if smashud.visible.keys then
        smashud.drawKey(offset + keyOffset, camObj, playerObj, priority)
    end
    if smashud.visible.bombs then
        smashud.drawBombs(offset, camObj, playerObj, priority)
    end
end

local charHUDActions =
{
    [CHARACTER_MARIO] = {type = Graphics.HUD_ITEMBOX},
    [CHARACTER_LUIGI] = {type = Graphics.HUD_ITEMBOX},
    [CHARACTER_TOAD] = {type = Graphics.HUD_HEARTS},
    [CHARACTER_PEACH] = {type = Graphics.HUD_HEARTS},
    [CHARACTER_LINK] = {type = Graphics.HUD_HEARTS, actions = drawLinkStuff, sprites = { coins = Graphics.sprites.hardcoded["33-6"] }}
}

function Graphics.registerCharacterHUD(characterID, hudType, actions, sprites)
    charHUDActions[characterID] = {type = hudType, actions = actions, sprites = sprites};
    if(hudType == Graphics.HUD_ITEMBOX) then
        if(sprites == nil or sprites.reserveBox2P == nil) then
            reserveBox2P[characterID] = reserveBox2P[1];
        else
            reserveBox2P[characterID] = sprites.reserveBox2P;
        end
    end
end

local customHUDElements = {}

function Graphics.addHUDElement(elementFunction)
    table.insert(customHUDElements, elementFunction)
end

function Graphics.getHUDType(characterID)
    local c = charHUDActions[characterID];
    if(c) then
        return c.type;
    else
        return Graphics.HUD_NONE;
    end
end

function Graphics.getHUDActions(characterID)
    local c = charHUDActions[characterID];
    if(c) then
        return c.actions;
    else
        return nil;
    end
end

function Graphics.getHUDOffset(playerIdx, isSplit)
    if (#activePlayers > 1 and not isSplit) then
        local offset = smashud.multiplayerOffsets[Graphics.getHUDType(activePlayers[playerIdx].character)];
        if(playerIdx == 1) then
            offset = -offset;
        end
        return offset;
    else
        return 0;
    end
end

function Graphics.drawVanillaHUD(camIndex, priority, isSplit)
    local thisPlayer = activePlayers[camIndex]
    local thisCam = activeCameras[camIndex]

    local splitOffset = {0,0}

    if #activePlayers > 1 and not isSplit then
        splitOffset[1] = -smashud.multiplayerOffsets[Graphics.getHUDType(activePlayers[1].character)]
        if Player.count() >= 2 then
            splitOffset[2] = smashud.multiplayerOffsets[Graphics.getHUDType(activePlayers[2].character)]
            for i=1, 2 do
                local acts = Graphics.getHUDActions(activePlayers[i].character)
                if(acts) then
                    acts(i, thisCam, activePlayers[i], priority, isSplit, #activePlayers);
                end
            end
        end
    else
        local acts = Graphics.getHUDActions(thisPlayer.character);
        if(acts) then
            acts(camIdx, thisCam, thisPlayer, priority, isSplit, #activePlayers);
        end
    end

    if smashud.visible.itembox then
        smashud.countItemboxes(splitOffset, camIndex, #activePlayers > 1, isSplit, priority)
    end
    if smashud.visible.lives then
        smashud.drawLives(splitOffset[1], thisCam, thisPlayer, priority)
    end
    if smashud.visible.deathcount then
        smashud.drawDeathCount(splitOffset[1], thisCam, thisPlayer, priority)
    end
    if smashud.visible.score then
        smashud.drawScore(splitOffset[2], thisCam, priority)
    end
    if smashud.visible.coins then
        smashud.drawCoins(splitOffset[2], thisCam, thisPlayer, priority)
    end
    if smashud.visible.stars then
        smashud.drawStars(splitOffset[1], thisCam, thisPlayer, priority)
    end
    if smashud.visible.starcoins then
        if isSplit and (activeCameras[camIndex].width < 800) then
            smashud.drawStarcoins(220, thisCam, thisPlayer, priority)
        else
            smashud.drawStarcoins(0, thisCam, thisPlayer, priority)
        end
    end
    if smashud.visible.timer and timer.isActive() then
        if isSplit and (activeCameras[camIndex].width < 800) then
            smashud.drawTimer(-200, thisCam, thisPlayer, priority)
        else
            smashud.drawTimer(0, thisCam, thisPlayer, priority)
        end
    end
end

do

    function Graphics.drawVanillaOverworldHUD(priority)
        local state = Graphics.getOverworldHudState();
        if(state == WHUD_ALL or state == WHUD_ONLY_OVERLAY) then
            smashud.drawOverworldBox(priority);
        end

        if(state == WHUD_ALL) then
            if smashud.visible.lives then
                smashud.drawDeathCount(player, priority);
            end
            if smashud.visible.deathcount then
                smashud.drawHUDLives(player, priority);
            end

            if smashud.visible.coins then
                smashud.drawHUDCoins(player, priority);
            end
            if smashud.visible.stars then
                smashud.drawHUDStars(player, priority);
            end

            if smashud.visible.overworldPlayer then
                smashud.drawHUDPlayer(1, priority);
                if Player.count() >= 2 then
                    smashud.drawHUDPlayer(2, priority);
                end
            end

            if(smashud.visible.levelname and world.levelTitle ~= nil and world.levelTitle ~= "") then
                local offset = -#world.levelTitle*smashud.overworld.offsets.levelname.align*16;
                local yoffset = 0
                if Player.count() >= 2 then
                    offset = offset + smashud.overworld.offsets.levelname.p2Offset.x
                    yoffset = smashud.overworld.offsets.levelname.p2Offset.y
                end
                Text.printWP(world.levelTitle,2,400+smashud.overworld.offsets.levelname.x+offset,smashud.overworld.offsets.levelname.y+yoffset,priority);
            end
        end
    end
end

function smashud.drawHUDPlayer(plyridx, priority, color, shader, uniforms)
    local plyr = Player(plyridx)
    local offsets = smashud.overworld.offsets
    if plyridx == 1 then
        offsets = offsets.player
    elseif plyridx == 2 then
        offsets = offsets.player2
    else
        return
    end
    
    local x,y = 400+offsets.x-(plyr.width*0.5), offsets.y-plyr.height;
    plyr:render{x = x, y = y, ignorestate = true, sceneCoords = false, priority = priority, color = color, mountcolor = Color.white, shader = shader, uniforms = uniforms};
end

local function GetImageFromID(img, character)
    if(type(img) == "LuaImageResource" or (type(img) == "table" and img.img)) then --is an image type
        return img;
    elseif(pm) then --is a playermanager registered graphic id
        return pm.getGraphic(character, img);
    end
end

local function GetSprite(name, character)
    if(charHUDActions[character] == nil or charHUDActions[character].sprites == nil or charHUDActions[character].sprites[name] == nil) then
        return ConvertSprite(smashudsprites[name] or SpriteDefaults[name])
    else
        return ConvertSprite(GetImageFromID(charHUDActions[character].sprites[name], character) or smashudsprites[name] or SpriteDefaults[name])
    end
end

function smashud.drawKey(splitOffset, thisCam, thisPlayer, priority)
    if thisPlayer:mem(0x12,FIELD_WORD) ~= 0 then
        local key = GetSprite("keys", thisPlayer.character);
        local x = smashud.offsets.keys.x - key.width * smashud.offsets.keys.align;
        Graphics.drawImageWP(key, 0.5 * thisCam.width + x + splitOffset, smashud.offsets.keys.y, priority)
    end
end

local function drawCounter(splitOffset, thisCam, thisPlayer, obj, sprite, value, priority)
    local v = tostring(value)
    local left = math.min(0, obj.cross.x, obj.value.x - (#v * obj.value.align));
    local cross = GetSprite("cross", thisPlayer.character);
    local right = math.max(sprite.width, obj.cross.x + cross.width, obj.value.x + (#v * 18 * (smashud.ALIGN_RIGHT-obj.value.align)));
    local wid = right-left;
    local x = obj.x - wid*(obj.align);
    local y = obj.y
    
    if Player.count() >= 2 and obj.p2Offset then
        x = x + obj.p2Offset.x
        y = y + obj.p2Offset.y
    end
    Graphics.drawImageWP(sprite,     0.5 * thisCam.width +     x + splitOffset, y, priority)
    Graphics.drawImageWP(cross,     0.5 * thisCam.width +     x + obj.cross.x + splitOffset, y + obj.cross.y, priority)
                    
    if type(value) == "number" and value >= 0 and math.floor(value) == value then
        Text.printWP(v, 1, 0.5 * thisCam.width +x + obj.value.x + splitOffset - (#v * obj.value.align * 18), y + obj.value.y, priority)
    else
        drawCounterValue(v, 0.5 * thisCam.width +x + obj.value.x + splitOffset - (#v * obj.value.align * 18), y + obj.value.y, priority)
    end
end

function smashud.drawBombs(splitOffset, thisCam, thisPlayer, priority)
    local bombs = thisPlayer:mem(0x08, FIELD_WORD)
    if bombs > 0 then
        local sprite = GetSprite("bombs", thisPlayer.character);
        drawCounter(splitOffset, thisCam, thisPlayer, smashud.offsets.bombs, sprite, bombs, priority);
    end
end

function smashud.drawStars(splitOffset, thisCam, thisPlayer, priority)
    local stars = (SaveData.totalStarCount)
    if stars > 0 then
        local sprite = GetSprite("stars", thisPlayer.character);
        drawCounter(splitOffset, thisCam, thisPlayer, smashud.offsets.stars, sprite, stars, priority)
    end
end

function smashud.scoreCounterWithZeroes()
    if SaveData.totalScoreClassic >= 0 then
        string.format("00000000%1d",tostring(SaveData.totalScoreClassic))
    elseif SaveData.totalScoreClassic >= 99 then
        return string.format("0000000%2d",tostring(SaveData.totalScoreClassic))
    elseif SaveData.totalScoreClassic >= 999 then
        return string.format("000000%3d",tostring(SaveData.totalScoreClassic))
    elseif SaveData.totalScoreClassic >= 9999 then
        return string.format("00000%4d",tostring(SaveData.totalScoreClassic))
    elseif SaveData.totalScoreClassic >= 99999 then
        return string.format("0000%5d",tostring(SaveData.totalScoreClassic))
    elseif SaveData.totalScoreClassic >= 999999 then
        return string.format("000%6d",tostring(SaveData.totalScoreClassic))
    elseif SaveData.totalScoreClassic >= 9999999 then
        return string.format("00%7d",tostring(SaveData.totalScoreClassic))
    elseif SaveData.totalScoreClassic >= 99999999 then
        return string.format("0%8d",tostring(SaveData.totalScoreClassic))
    elseif SaveData.totalScoreClassic >= 999999999 then
        return SaveData.totalScoreClassic
    end
end

function smashud.lifeCrownCounter()
    if SaveData.totalLives < 1000 then
        return SaveData.totalLives
    elseif SaveData.totalLives >= 1000 and SaveData.totalLives <= 1009 then
        return string.format("!0%1d",tostring(SaveData.totalLives):sub(3, 4))
    elseif SaveData.totalLives >= 1010 and SaveData.totalLives < 1100 then
        return string.format("!%2d",tostring(SaveData.totalLives):sub(3, 4))
    elseif SaveData.totalLives >= 1100 and SaveData.totalLives < 1110 then
        return string.format("!!%1d",tostring(SaveData.totalLives):sub(4, 4))
    elseif SaveData.totalLives >= 1110 then
        return "!!!"
    end
end

function smashud.drawLives(splitOffset, thisCam, thisPlayer, priority)
    if not SaveData.disableX2char then
        if SaveData.totalLives <= 999 then
            drawCounter(splitOffset, thisCam, thisPlayer, smashud.offsets.lives, GetSprite("lives", thisPlayer.character), SaveData.totalLives, priority);
        elseif SaveData.totalLives >= 1000 then
            drawCounter(splitOffset, thisCam, thisPlayer, smashud.offsets.lives, GetSprite("lives", thisPlayer.character), SysManager.lifeCountWithCrownsAndZeroFailsafe(), priority);
        end
    elseif SaveData.disableX2char then
        if SaveData.totalLives <= 999 then
            drawCounter(splitOffset, thisCam, thisPlayer, smashud.offsets.lives, GetSprite("livesClassic", thisPlayer.character), SaveData.totalLives, priority);
        elseif SaveData.totalLives >= 1000 then
            drawCounter(splitOffset, thisCam, thisPlayer, smashud.offsets.lives, GetSprite("livesClassic", thisPlayer.character), SysManager.lifeCountWithCrownsAndZeroFailsafe(), priority);
        end
    end
end

function smashud.drawDeathCount(splitOffset, thisCam, thisPlayer, priority)
    if SaveData.deathCount >= 1000 then
        drawCounter(splitOffset, thisCam, thisPlayer, smashud.offsets.deathcount, GetSprite("deathcount", thisPlayer.character), "999+", priority);
    else
        drawCounter(splitOffset, thisCam, thisPlayer, smashud.offsets.deathcount, GetSprite("deathcount", thisPlayer.character), SaveData.deathCount, priority);
    end
end

function smashud.drawHUDLives(thisPlayer, priority)
    drawCounter(0, {width = 800}, thisPlayer, smashud.overworld.offsets.lives, GetSprite("lives", thisPlayer.character), SaveData.totalLives, priority);
end

function smashud.drawHUDCoins(thisPlayer, priority)
    drawCounter(0, {width = 800}, thisPlayer, smashud.overworld.offsets.coins, GetSprite("coins", thisPlayer.character), SaveData.totalCoinsClassic, priority);
end

function smashud.drawHUDStars(thisPlayer, priority)
    local stars = (SaveData.totalStarCount)
    if stars > 0 then
        local sprite = GetSprite("stars", thisPlayer.character);
        drawCounter(0, {width = 800}, thisPlayer, smashud.overworld.offsets.stars, sprite, stars, priority);
    end
end

do
    local huddraw = {
                        vertexCoords =
                        {
                            0,0,800,0,0,130,            0,130,800,0,800,130,                --Top side
                            0,130,66,130,0,534,            0,534,66,130,66,534,                --Left side
                            734,130,800,130,734,534,    734,534,800,130,800,534,            --Right side
                            0,534,800,534,0,600,        0,600,800,534,800,600                --Bottom side
                        },
                        textureCoords =
                        {
                            0,0,1,0,0,0.216667,                            0,0.216667,1,0,1,0.216667,
                            0,0.216667,0.0825,0.216667,0,0.89,            0,0.89,0.0825,0.216667,0.0825,0.89,
                            0.9175,0.216667,1,0.216667,0.9175,0.89,        0.9175,0.89,1,0.216667,1,0.89,
                            0,0.89,1,0.89,0,1,                            0,1,1,0.89,1,1
                        }
                    };
    function smashud.drawOverworldBox(priority)
        huddraw.texture = Graphics.sprites.hardcoded["33-4"].img;
        huddraw.priority = priority;
        Graphics.glDraw(huddraw);
    end
end

function smashud.countItemboxes(splitOffset, camIndex, isMultiplayer, isSplit, priority)
    thisCam = activeCameras[camIndex]
    if isMultiplayer and not isSplit then
        if Player.count() >= 2 then
            for i=1, 2 do
                thisPlayer = activePlayers[i]
                smashud.drawItembox(splitOffset[i], thisCam, camIndex, thisPlayer, isMultiplayer, priority)
            end
        end
    else
        thisPlayer = activePlayers[camIndex]
        smashud.drawItembox(splitOffset[1], thisCam, camIndex, thisPlayer, isMultiplayer, priority)
    end
end

function smashud.drawItembox(splitOffset, thisCam, playerIdx, thisPlayer, isMultiplayer, priority)
    local reserve2p = ConvertSprite(GetImageFromID(reserveBox2P[thisPlayer.character], thisPlayer.character))

    if Graphics.getHUDType(thisPlayer.character) == Graphics.HUD_ITEMBOX then
        local reserveBox = GetSprite("reserveBox", thisPlayer.character);
        local x1 = smashud.offsets.itembox.x - reserveBox.width * smashud.offsets.itembox.align;
        local x2 = smashud.offsets.itembox.x - reserve2p.width * smashud.offsets.itembox.align;

        if isMultiplayer then
            Graphics.drawImageWP(reserve2p, 0.5 * thisCam.width + x1 + splitOffset, smashud.offsets.itembox.y, priority)
        else
            Graphics.drawImageWP(reserveBox, 0.5 * thisCam.width + x2 + splitOffset, smashud.offsets.itembox.y, priority)
        end

    elseif(Graphics.getHUDType(thisPlayer.character) == Graphics.HUD_HEARTS) then
        local x = smashud.offsets.hearts.x - 96 * smashud.offsets.hearts.align;

        local hearts = thisPlayer:mem(0x16, FIELD_WORD)
        for i=1, 3 do
            local displayedImg = GetSprite("heartEmpty", thisPlayer.character);
            if hearts >= i then
                displayedImg = GetSprite("heartFull", thisPlayer.character);
            end
            Graphics.drawImageWP(displayedImg, 0.5 * thisCam.width  +     x + splitOffset + 32 * (i - 1),
                                                                        smashud.offsets.hearts.y, priority)
        end

    end
    if thisPlayer.reservePowerup > 0 and reserve2p then

        local reserve = Graphics.sprites.npc[thisPlayer.reservePowerup].img

        local w = NPC.config[thisPlayer.reservePowerup].gfxwidth
        if w == 0 then
            w = NPC.config[thisPlayer.reservePowerup].width
        end

        local h = NPC.config[thisPlayer.reservePowerup].gfxheight
        if h == 0 then
            h = NPC.config[thisPlayer.reservePowerup].height
        end

        local reserveBox = GetSprite("reserveBox", thisPlayer.character);
        local x1 = smashud.offsets.itembox.x - reserveBox.width * smashud.offsets.itembox.align;
        local x2 = smashud.offsets.itembox.x - reserve2p.width * smashud.offsets.itembox.align;
        local x;
        if isMultiplayer then
            x = x2;
        else
            x = x1;
        end

        local sourcex = 0;
        local sourcey = 0;

        --Special case for megashroom (TODO: Maybe make this a table for config?)
        if(thisPlayer.reservePowerup == 425) then
            sourcey = 5*h;
        end

        Graphics.draw{type = RTYPE_IMAGE, image = reserve, priority = priority, isSceneCoords = false,
                        x= 0.5 * thisCam.width +     x + smashud.offsets.itembox.item.x + splitOffset - smashud.offsets.itembox.item.align * w,
                        y=                             smashud.offsets.itembox.y + smashud.offsets.itembox.item.y - 0.5 * h,
                        sourceWidth = w,
                        sourceHeight = h,
                        sourceX = sourcex, sourceY = sourcey}
    end
end

function smashud.drawScore(splitOffset, thisCam, priority)
    if SaveData.disableX2char == true then
        local scoreDisplay13 = tostring(SysManager.scoreCount13())
        Text.printWP(scoreDisplay13, 1, 0.5 * thisCam.width + smashud.offsets.score.x + splitOffset - #scoreDisplay13 * 18 * smashud.offsets.score.align, smashud.offsets.score.y, priority)
    elseif SaveData.disableX2char == false then
        local scoreDisplay = SysManager.scoreCountWithZeroes()
        Text.printWP(scoreDisplay, 1, 0.5 * thisCam.width + smashud.offsets.score.x + splitOffset - #scoreDisplay * 18 * smashud.offsets.score.align, smashud.offsets.score.y, priority)
    end
end

function smashud.drawCoins(splitOffset, thisCam, thisPlayer, priority)
    local s = GetSprite("coins", thisPlayer.character);
    drawCounter(splitOffset, thisCam, thisPlayer, smashud.offsets.coins, s, tostring(SysManager.coinCountClassicWith99Limit()), priority);
end


local function validStarCoin(t, i)
    return t[i] and (not t.alive or t.alive[i])
end

function smashud.drawStarcoins(splitOffset, thisCam, thisPlayer, priority)
    local count = starcoin.count()
    if count > 0 then
    
        local data = starcoin.getLevelList()
        local collNum = starcoin.getLevelCollected()
        local offset = smashud.offsets.starcoins
        local grid = offset.grid
        local img_coll = GetSprite("starcoinCollected", thisPlayer.character)
        local img_uncoll = GetSprite("starcoinUncollected", thisPlayer.character)
        local halfCam = thisCam.width/2
        local offsety = 0

          --Correct the offset if it goes out of bounds
          if grid.offset < 0 then
            grid.offset = 0
          else
            local m = math.floor((count - grid.width*grid.height)/grid.width)
            if grid.width == 1 and grid.offset > m then
              grid.offset = math.max(0, m)
            elseif grid.offset > m + 1 then
              grid.offset = math.max(0, m + 1)
            end
          end
          
          
        --hacky workaround to make 2p mode work
        local origoff = {offset.x, offset.y}
        offset.x = offset.x + splitOffset
        
        if splitOffset ~= 0 then
            offset.y = offset.y + 40
        end
        
        splitOffset = 0
          
          
        -- Draw the counter
        drawCounter(splitOffset, thisCam, thisPlayer, offset, img_coll, collNum.."/"..count, priority)
        
        -- Draw the arrows
        if grid.offset > 0 then
            local img = GetSprite("arrowUp", thisPlayer.character)
            Graphics.drawImageWP(img, halfCam + offset.x - img.width*grid.align + grid.x + grid.width*(img_coll.width + 2)/2 - img.width/2, offset.y + grid.y - img.height - 4, priority)
        else
            offsety = -24
        end
        if count > grid.width*(grid.offset + grid.height) then
            local img = GetSprite("arrowDown", thisPlayer.character)
            Graphics.drawImageWP(img, halfCam + offset.x - img.width*grid.align + grid.x + grid.width*(img_coll.width + 2)/2 - img.width/2, offset.y + offsety + grid.y + grid.height*(img_coll.height + 2) + 2, priority)
        end
        
        -- Draw the icons
        local i = 1
        local idx = 1
        while idx <= starcoin.max() do
            if validStarCoin(data, idx + grid.offset) then
                local img
                if data[idx + grid.offset] == 0 then
                    img = img_uncoll
                else
                    img = img_coll
                end
                Graphics.drawImageWP(img, halfCam + offset.x - img.width*grid.align + grid.x + ((i - 1)%grid.width)*(img.width + 2), offset.y + offsety + grid.y + math.floor((i - 1)/grid.width)*(img.height + 2), priority)
                i = i+1
                if i > math.min(count - grid.offset*grid.width, grid.width*grid.height) then
                    break
                end
            end
            idx = idx+1
        end
        
        offset.x = origoff[1]
        offset.y = origoff[2]
    end
end

function smashud.drawTimer(splitOffset, thisCam, thisPlayer, priority)
    local s = GetSprite("timer", thisPlayer.character);
    
    local offset = smashud.offsets.timer
    
    --hacky workaround to make 2p mode work
    local origoff = {offset.x, offset.y}
    offset.x = offset.x + splitOffset
    
    if splitOffset ~= 0 then
        offset.y = offset.y + 40
    end
        
    splitOffset = 0
    
    drawCounter(splitOffset, thisCam, thisPlayer, offset, s, timer.getValue(), priority);
    
    offset.x = origoff[1]
    offset.y = origoff[2]
end

function smashud.onDraw()
    local s = mem(0x00B2C8E4, FIELD_DWORD)
    if (s > 0) then
        SaveData._basegame.hud.score = math.min(SaveData._basegame.hud.score + s, 9999990)
        mem(0x00B2C8E4, FIELD_DWORD, 0)
    end
    activeCameras = Camera.get()
    activePlayers = Player.get()
    
    local i = 1
    while i <= #textCacheList do
        local c = textCache[textCacheList[i]]
        c[2] = c[2]-1
        if c[2] <= 0 then
            textCache[textCacheList[i]] = nil
            table.remove(textCacheList, i)
        else
            i = i+1
        end
    end
end

function smashud.onTick()
    if SaveData.lifeCrownsComplete == nil then --To make the sound work, this has to be set as a string'd boolean...
        SaveData.lifeCrownsComplete = "false"
    end
    if SaveData.totalLives == 1110 then --When the lives hit 1110...
        if (SaveData.lifeCrownsComplete == "trulyfalse") == false then
            SaveData.lifeCrownsComplete = "true"
        end
    end
    if SaveData.lifeCrownsComplete == "true" then
        Sound.playSFX("all-crowns-achieved.ogg")
        SaveData.lifeCrownsComplete = "trulyfalse"
        SaveData.allLifeCrownsAchieved = true
    end
end

function smashud.onHUDDraw(camIdx)
    if isActive then
        if(isOverworld) then
            currentOWRenderFunc(smashud.priority);
        else
            --TODO: Replace with a better test for splitscreen
            local isSplit = (activeCameras[camIdx].width < 800) or (activeCameras[camIdx].height < 600)

            currentRenderFunc(camIdx, smashud.priority, isSplit)

            for _,v in ipairs(customHUDElements) do
                v(camIdx, smashud.priority, isSplit)
            end
        end
    end
end

return smashud
