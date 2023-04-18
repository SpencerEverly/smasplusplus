local pm = require("playerManager")
local smasExtraSounds = require("smasExtraSounds")
local textplus = require("textplus")
local smasHud = require("smasHud")
local smasFunctions = require("smasFunctions")

local costume = {}

costume.loaded = false

local smbddxfont = textplus.loadFont("littleDialogue/font/verdana.ini")
local coinCounter = Graphics.loadImageResolved("costumes/mario/SMBDDX-Mario/coincounter.png")
local starCounter = Graphics.loadImageResolved("costumes/mario/SMBDDX-Mario/starcounter.png")
local marioHead = Graphics.loadImageResolved("costumes/mario/SMBDDX-Mario/mariohead.png")

local plr

function costume.onInit(p)
    plr = p
    registerEvent(costume,"onTick")
    registerEvent(costume,"onDraw")
    if not costume.loaded then
        Sound.loadCostumeSounds()
        costume.loaded = true
    end
    
    Graphics.overrideHUD(costume.drawHUD)
    costume.abilitesenabled = true
end

function costume.drawHUD(camIdx,priority,isSplit)
    --Lives
    Graphics.drawImageWP(marioHead, 107, 30, -4.3)
    textplus.print{text = "x", font = minFont, priority = -4.3, x = 137, y = 26, xscale = 2, yscale = 2, color = Color.fromHexRGBA(0xFFFFFFFF)}
    textplus.print{text = tostring(SaveData.totalLives), font = minFont, priority = -4.3, x = 152, y = 26, xscale = 2, yscale = 2, color = Color.fromHexRGBA(0xFFFFFFFF)}
    
    --Coins
    Graphics.drawImageWP(coinCounter, 202, 22, -4.3)
    textplus.print{text = "x", font = minFont, priority = -4.3, x = 225, y = 26, xscale = 2, yscale = 2, color = Color.fromHexRGBA(0xFFFFFFFF)}
    textplus.print{text = tostring(SaveData.totalCoinsClassic), font = minFont, priority = -4.3, x = 240, y = 26, xscale = 2, yscale = 2, color = Color.fromHexRGBA(0xFFFFFFFF)}

    --Stars
    Graphics.drawImageWP(starCounter, 305, 26, -4.3)
    textplus.print{text = "x", font = minFont, priority = -4.3, x = 335, y = 26, xscale = 2, yscale = 2, color = Color.fromHexRGBA(0xFFFFFFFF)}
    textplus.print{text = tostring(SaveData.totalStarCount), font = minFont, priority = -4.3, x = 350, y = 26, xscale = 2, yscale = 2, color = Color.fromHexRGBA(0xFFFFFFFF)}

    --Score
    textplus.print{text = tostring(SaveData.totalScoreClassic), font = minFont, priority = -4.3, x = 432, y = 26, xscale = 2, yscale = 2, color = Color.fromHexRGBA(0xFFFFFFFF)}

    --Time
    textplus.print{text = "Time "..tostring(Timer.getValue()), font = minFont, priority = -4.3, x = 590, y = 26, xscale = 2, yscale = 2, color = Color.fromHexRGBA(0xFFFFFFFF)} 
end

local leafPowerups = table.map{PLAYER_LEAF,PLAYER_TANOOKI}

local function isSlowFalling()
    return (leafPowerups[player.powerup] and player.speedY > 0 and (player.keys.jump or player.keys.altJump))
end

local function canDuck()
    return (
        player.forcedState == FORCEDSTATE_NONE
        and player.deathTimer == 0 and not player:mem(0x13C,FIELD_BOOL) -- not dead
        and player.mount == MOUNT_NONE
        and not player.climbing
        and not player:mem(0x0C,FIELD_BOOL) -- fairy
        and not player:mem(0x3C,FIELD_BOOL) -- sliding
        and not player:mem(0x44,FIELD_BOOL) -- surfing on a rainbow shell
        and not player:mem(0x4A,FIELD_BOOL) -- statue
        and not player:mem(0x50,FIELD_BOOL) -- spin jumping
        and player:mem(0x26,FIELD_WORD) == 0 -- picking up something from the top
        and (player:mem(0x34,FIELD_WORD) == 0 or isOnGround()) -- underwater or on ground

        and (
            player:mem(0x48,FIELD_WORD) == 0 -- not on a slope (ducking on a slope is weird due to sliding)
            or (player.holdingNPC ~= nil and player.powerup == PLAYER_SMALL) -- small and holding an NPC
            or player:mem(0x34,FIELD_WORD) > 0 -- underwater
        )
    )
end

local function isOnGround()
    return (
        player.speedY == 0 -- "on a block"
        or player:mem(0x176,FIELD_WORD) ~= 0 -- on an NPC
        or player:mem(0x48,FIELD_WORD) ~= 0 -- on a slope
    )
end

function costume.onTick()
    if SaveData.toggleCostumeAbilities then
        if plr.holdingNPC == nil then
            if isSlowFalling() and not isOnGround() and not player:mem(0x12E, FIELD_BOOL) then
                plr:playAnim({5,37,11,37}, 4, false, -25)
            end
        end
    end
end

function costume.onDraw()
    
end

function costume.onCleanup(p)
    Sound.cleanupCostumeSounds()
    
    Graphics.overrideHUD(Graphics.drawVanillaHUD)
    costume.abilitesenabled = false
end

Misc.storeLatestCostumeData(costume)

return costume