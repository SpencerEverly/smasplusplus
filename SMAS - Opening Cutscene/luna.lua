Graphics.activateHud(false)
local smasDateAndTime = require("smasDateAndTime")

smasDateAndTime.enabled = false

smasHud.visible.keys = false
smasHud.visible.itemBox = false
smasHud.visible.bombs = false
smasHud.visible.coins = false
smasHud.visible.score = false
smasHud.visible.lives = false
smasHud.visible.deathCount = false
smasHud.visible.stars = false
smasHud.visible.starcoins = false
smasHud.visible.timer = false
smasHud.visible.customItemBox = false

smasCheats.checkCheatStatusAndDisable()

local bgone = true
local bgtwo = false
local timer = 0
local array = timer % 3
local frame = 1
local frameImages = {}

function onStart()
    for i = 1,2744 do
        table.insert(frameImages, Graphics.loadImageResolved("SMAS - Opening Cutscene/openingframes/"..string.format("%05d", i)..".png"))
    end
end

function onInputUpdate()
    for _,p in ipairs(Player.get()) do
        if p.keys.jump == KEYS_PRESSED then
            Routine.run(skipopening)
        end
    end
end

function skipopening()
    Sound.playSFX(1001)
    Routine.wait(0.3, true)
    if not SaveData.SMASPlusPlus.game.openingComplete then
        SaveData.SMASPlusPlus.game.openingComplete = true
    end
    Level.load("map.lvlx")
end

function onDraw()
    Text.printWP("Press jump to skip", Screen.calculateCameraDimensions(230, 1), Screen.calculateCameraDimensions(540, 2), 6)
    for _,p in ipairs(Player.get()) do
        p.forcedState = FORCEDSTATE_INVISIBLE
    end
    timer = timer + 2.70
    array = timer % 24
    if array >= 15 then
        frame = frame + 1
    end
    if frame >= 2743 then
        frame = 2743
    end
    Graphics.drawImageWP(frameImages[frame], Screen.calculateCameraDimensions(0, 1), Screen.calculateCameraDimensions(0, 2), 5)
    if timer >= 19700 then
        if not SaveData.SMASPlusPlus.game.openingComplete then
            SaveData.SMASPlusPlus.game.openingComplete = true
        end
        Level.load("map.lvlx")
    end
end
