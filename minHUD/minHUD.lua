local minHUD = {}

-- require('minHUD')
-- You'll need the above code pasted in your luna.lua file.
-- Code made by Hatsune Blake! Please give credit!

local textplus = require("textplus")
local smasHud = require("smasHud")
local smasFunctions = require("smasFunctions")
local t = 0

-- Star Coin related stuff
local starcoin = require("npcs/ai/starcoin") 
starcoin.getLevelList()

function minHUD.onInitAPI()
    --registerEvent(twilightHUD, "onStart", "onStart")
    --registerEvent(twilightHUD, "onTick", "onTick")
end

-- Fonts
local minFont = textplus.loadFont("minFont.ini")

--------------
-- Settings --
--------------
-- You can tweek some of the HUD settings here, like extra graphics and so on.

-- Set this to 1 for solid black, 2 for transparent.
local hudBarSet = 2

-- Enter 2 to alter the uncollected Dragon Coin graphic to white. Only has an effect if you're using a solid black HUD bar. 
local dragonAltStyle = 1
-- Enter 2 for more space between Dragon Coin graphics. Useful if you only have 3 Dragon Coins per level as opposed to 5.
local dragonExtra = 1

-- If your episode has stars, enter 1. Otherwise enter 2.
local starCounterSet = 1

-- If you're using the built-in SMBX timer, enter 1. Otherwise enter 2.
local timeCounterSet = 1
-- Enter 2 for an alternative style for the timer graphic. Useful if you're using a solid black bar.
local timeAltStyle = 1

-- Set this to 2 to enable the death counter, a feature that tracks deaths insead of your lives.
local livesAltStyle = 1

---------------------
-- End of settings --
---------------------

-- Initialise the death counter to 0 if it hasn't been already
SaveData.SMASPlusPlus.hud.deathCount = SaveData.SMASPlusPlus.hud.deathCount or 0

-- Graphics
local hudBarB = Graphics.loadImage(Misc.resolveFile("minHUD/hudBarB.png"))
local hudBarT = Graphics.loadImage(Misc.resolveFile("minHUD/hudBarT.png"))
local coinCounter = Graphics.loadImage(Misc.resolveFile("minHUD/coinCounter.png"))
local lifeCounter = Graphics.loadImage(Misc.resolveFile("minHUD/lifeCounter.png"))
local starCounter = Graphics.loadImage(Misc.resolveFile("minHUD/starCounter.png"))
local deathCounter = Graphics.loadImage(Misc.resolveFile("minHUD/deathCounter.png"))
local timeCounter = Graphics.loadImage(Misc.resolveFile("minHUD/timeCounter.png"))
local timeCounterB = Graphics.loadImage(Misc.resolveFile("minHUD/timeCounterB.png"))
local dragonCoinEmpty = Graphics.loadImage(Misc.resolveFile("minHUD/dragonCoinEmpty.png"))
local dragonCoinEmptyB = Graphics.loadImage(Misc.resolveFile("minHUD/dragonCoinEmptyB.png"))
local dragonCoinEmptyW = Graphics.loadImage(Misc.resolveFile("minHUD/dragonCoinEmptyW.png"))
local dragonCoinCollect = Graphics.loadImage(Misc.resolveFile("minHUD/dragonCoinCollect.png"))
local reserveBox = Graphics.loadImage(Misc.resolveFile("minHUD/reserveBox.png"))

-- Item icon graphics
local reserveItem = {}

reserveItem[0] = Graphics.loadImageResolved("minHUD/item1.png")

reserveItem[9] = Graphics.loadImageResolved("minHUD/item2.png")
reserveItem[184] = reserveItem[9]
reserveItem[185] = reserveItem[9]
reserveItem[249] = reserveItem[9]

reserveItem[14] = Graphics.loadImageResolved("minHUD/item3.png")
reserveItem[182] = reserveItem[14]
reserveItem[183] = reserveItem[14]

reserveItem[264] = Graphics.loadImageResolved("minHUD/item7.png")
reserveItem[277] = reserveItem[264]

reserveItem[34] = Graphics.loadImageResolved("minHUD/item4.png")
reserveItem[169] = Graphics.loadImageResolved("minHUD/item5.png")
reserveItem[170] = Graphics.loadImageResolved("minHUD/item6.png")

-- No idea what this does lmao
function minHUD.onInitAPI()
    registerEvent(minHUD, "onDraw", "onDraw")
    registerEvent(minHUD, "onExitLevel", "onExitLevel")
end

function minHUD.drawHUD(camIdx,priority,isSplit)
    -- All HUD rendering goes here

    -- Base HUD Bar
    if hudBarSet == 1 then
        Graphics.drawBox{
            color = Color.black,
            x = 0,
            y = 0,
            width = camera.width,
            height = 24,
            priority = 4.998,
        }
    else
        Graphics.drawBox{
            color = Color(0,0,0,0.5),
            x = 0,
            y = 0,
            width = camera.width,
            height = 24,
            priority = 4.998,
        }
    end

    -- Reserve Box
    Graphics.drawImageWP(reserveBox, Screen.calculateCameraDimensions(400 - reserveBox.width*0.5, 1), 4, 4.9999)

    local itemImage = reserveItem[player.reservePowerup] or reserveItem[0]

    if player.reservePowerup > 0 and itemImage ~= nil then
        Graphics.drawImageWP(itemImage, Screen.calculateCameraDimensions(392, 1), 4, 4.9999)
    end

    -- Coins
    Graphics.drawImageWP(coinCounter, Screen.calculateCameraDimensions(20, 1), 4, 4.9999)
    textplus.print{text = tostring(SaveData.SMASPlusPlus.hud.coinsClassic), font = minFont, priority = 4.9999, x = Screen.calculateCameraDimensions(54, 1), y = 4, xscale = 2, yscale = 2, color = Color.fromHexRGBA(0xFFFFFFFF)}

    -- Lives or Death Counter
    if livesAltStyle == 2 then
        Graphics.drawImageWP(deathCounter, Screen.calculateCameraDimensions(130, 1), 4, 4.9999)
        textplus.print{text = tostring(SaveData.SMASPlusPlus.hud.deathCount), font = minFont, priority = 4.9999, x = Screen.calculateCameraDimensions(164, 1), y = 4, xscale = 2, yscale = 2} 
    else
        Graphics.drawImageWP(lifeCounter, Screen.calculateCameraDimensions(114, 1), 4, 4.9999)
        textplus.print{text = tostring(SaveData.SMASPlusPlus.hud.lives), font = minFont, priority = 4.9999, x = Screen.calculateCameraDimensions(164, 1), y = 4, xscale = 2, yscale = 2, color = Color.fromHexRGBA(0xFFFFFFFF)}
    end

    -- Stars
    if starCounterSet == 1 then
        Graphics.drawImageWP(starCounter, Screen.calculateCameraDimensions(450, 1), 4, 4.9999)
        textplus.print{text = tostring(SaveData.totalStarCount), font = minFont, priority = 4.9999, x = Screen.calculateCameraDimensions(484, 1), y = 4, xscale = 2, yscale = 2, color = Color.fromHexRGBA(0xFFFFFFFF)}
    end

    -- Score
    textplus.print{text = tostring(SysManager.scoreCount13()), font = minFont, priority = 4.9999, x = Screen.calculateCameraDimensions(544, 1), y = 4, xscale = 2, yscale = 2, color = Color.fromHexRGBA(0xFFFFFFFF)}

    -- Time [SMBX Built In]
    if timeCounterSet == 1 then
        if timeAltStyle == 2 then
            Graphics.drawImageWP(timeCounterB, Screen.calculateCameraDimensions(670, 1), 4, 4.9999)
        else
            Graphics.drawImageWP(timeCounter, Screen.calculateCameraDimensions(670, 1), 4, 4.9999)
        end
        textplus.print{text = tostring(Timer.getValue()), font = minFont, priority = 4.9999, x = Screen.calculateCameraDimensions(702, 1), y = 4, xscale = 2, yscale = 2, color = Color.fromHexRGBA(0xFFFFFFFF)}
    end    

    -- Reserve power-up rendering
    -- if player.reservePowerup > 0 then
    --     local image = Graphics.sprites.npc[player.reservePowerup].img
    --     local config = NPC.config[player.reservePowerup]
    
    --     local gfxwidth = config.gfxwidth
    --     local gfxheight = config.gfxheight
    
    --     if gfxwidth == 0 then
    --         gfxwidth = config.width
    --     end
    --     if gfxheight == 0 then
    --         gfxheight = config.height
    --     end
    
    --     Graphics.drawImageWP(image, 400 - gfxwidth*0.5, 16 + deeperReserveBox.height*0.5 - gfxheight*0.5, 0,0, gfxwidth,gfxheight, priority)
    -- end

    -- Dragon Coins tracking
    for index,value in ipairs(starcoin.getLevelList()) do
        if value == 0 then
            if hudBarSet == 1 then
                if dragonAltStyle == 2 then
                    if dragonExtra == 2 then
                        Graphics.drawImageWP(dragonCoinEmptyW, Screen.calculateCameraDimensions(204 + (index * 36), 1), 4, 4.9999)
                    else
                        Graphics.drawImageWP(dragonCoinEmptyW, Screen.calculateCameraDimensions(204 + (index * 18), 1), 4, 4.9999)
                    end
                else
                    if dragonExtra == 2 then
                    Graphics.drawImageWP(dragonCoinEmptyB, Screen.calculateCameraDimensions(204 + (index * 36), 1), 4, 4.9999)
                    else
                    Graphics.drawImageWP(dragonCoinEmptyB, Screen.calculateCameraDimensions(204 + (index * 18), 1), 4, 4.9999)
                    end
                end
            else
                if dragonExtra == 2 then
                    Graphics.drawImageWP(dragonCoinEmpty, Screen.calculateCameraDimensions(204 + (index * 36), 1), 4, 4.9999)
                else
                    Graphics.drawImageWP(dragonCoinEmpty, Screen.calculateCameraDimensions(204 + (index * 18), 1), 4, 4.9999)
                end
            end
        else
            if dragonExtra == 2 then
                Graphics.drawImageWP(dragonCoinCollect, Screen.calculateCameraDimensions(204 + (index * 36), 1), 4, 4.9999)
            else
                Graphics.drawImageWP(dragonCoinCollect, Screen.calculateCameraDimensions(204 + (index * 18), 1), 4, 4.9999)
            end
        end
    end
end

return minHUD