Graphics.activateHud(false)
local datetime = require("datetime")

datetime.bottomright = false

smashud.visible.keys = false
smashud.visible.itembox = false
smashud.visible.bombs = false
smashud.visible.coins = false
smashud.visible.score = false
smashud.visible.lives = false
smashud.visible.deathcount = false
smashud.visible.stars = false
smashud.visible.starcoins = false
smashud.visible.timer = false
smashud.visible.customitembox = false

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
    if not SaveData.openingComplete then
        SaveData.openingComplete = true
    end
    Level.load("map.lvlx")
end

function onDraw()
    Text.printWP("Press jump to skip", 230, 540, 0)
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
    Graphics.drawImageWP(frameImages[frame], 0, 0, -5)
    if timer >= 19700 then
        if not SaveData.openingComplete then
            SaveData.openingComplete = true
        end
        Level.load("map.lvlx")
    end
end
