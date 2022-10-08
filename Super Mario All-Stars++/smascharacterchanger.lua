local smascharacterchanger = {}

function smascharacterchanger.onInitAPI()
    registerEvent(smascharacterchanger,"onDraw")
    registerEvent(smascharacterchanger,"onInputUpdate")
    registerEvent(smascharacterchanger,"onKeyboardPressDirect")
end

smascharacterchanger.tvImage = Img.load("graphics/characterchangermenu/tv.png")
smascharacterchanger.scrollSFX = SFX.open("_OST/_Sound Effects/characterchangermenu/scrolling-tv.ogg")
smascharacterchanger.stopSFX = SFX.open("_OST/_Sound Effects/characterchangermenu/scrolled-tv.ogg")
smascharacterchanger.turnOnSFX = SFX.open("_OST/_Sound Effects/characterchangermenu/turn-on-tv.ogg")
smascharacterchanger.menuActive = false
smascharacterchanger.animationActive = false
smascharacterchanger.animationTimer = 0
smascharacterchanger.tvScrollNumber = -600
smascharacterchanger.menuBGM = SFX.open("_OST/All Stars Menu/Character Changer Menu.ogg")

local soundObject1
local menuBGMObject

local started = false
local ending = false

function smascharacterchanger.startupChanger()
    Sound.muteMusic(-1)
    soundObject1 = SFX.play(smascharacterchanger.scrollSFX)
    Routine.waitFrames(64, true)
    if soundObject1 ~= nil then
        soundObject1:FadeOut(10)
    end
    SFX.play(smascharacterchanger.stopSFX)
    Routine.waitFrames(14, true)
    SFX.play(smascharacterchanger.turnOnSFX)
    Routine.waitFrames(14, true)
    smascharacterchanger.animationActive = false
    menuBGMObject = SFX.play(smascharacterchanger.menuBGM, Audio.MusicVolume() / 100, 0)
    started = true
end

function smascharacterchanger.shutdownChanger()
    started = false
    ending = true
    smascharacterchanger.animationActive = true
    Sound.playSFX(1001)
    Routine.waitFrames(35, true)
    Misc.unpause()
    Sound.restoreMusic(-1)
    smascharacterchanger.animationActive = false
    smascharacterchanger.tvScrollNumber = -600
    smascharacterchanger.animationTimer = 0
    ending = false
end

function smascharacterchanger.onInputUpdate()
    if smascharacterchanger.menuActive and started then
        if player.keys.run == KEYS_PRESSED then
            smascharacterchanger.menuActive = false
        end
    end
end

function smascharacterchanger.onDraw()
    if smascharacterchanger.menuActive then
        Misc.pause()
        if smascharacterchanger.animationActive then
            smascharacterchanger.animationTimer = smascharacterchanger.animationTimer + 1
            if smascharacterchanger.animationTimer == 1 then
                Routine.run(smascharacterchanger.startupChanger)
            end
            if smascharacterchanger.animationTimer >= 1 and smascharacterchanger.animationTimer <= 64 then
                smascharacterchanger.tvScrollNumber = smascharacterchanger.tvScrollNumber + 9.2
                Graphics.drawImageWP(smascharacterchanger.tvImage, 0, smascharacterchanger.tvScrollNumber, -0.5)
            end
            if smascharacterchanger.animationTimer >= 65 then
                smascharacterchanger.tvScrollNumber = 0
                Graphics.drawImageWP(smascharacterchanger.tvImage, 0, 0, -0.5)
            end
        end
        if not smascharacterchanger.animationActive and started then
            Graphics.drawImageWP(smascharacterchanger.tvImage, 0, 0, -0.5)
        end
    elseif not smascharacterchanger.menuActive and started then
        if menuBGMObject ~= nil then
            menuBGMObject:FadeOut(2000)
        end
        Routine.run(smascharacterchanger.shutdownChanger)
    elseif not smascharacterchanger.menuActive and ending then
        if smascharacterchanger.animationActive then
            smascharacterchanger.animationTimer = smascharacterchanger.animationTimer + 1
            if smascharacterchanger.animationTimer >= 1 and smascharacterchanger.animationTimer <= 34 then
                smascharacterchanger.tvScrollNumber = smascharacterchanger.tvScrollNumber - 20
                Graphics.drawImageWP(smascharacterchanger.tvImage, 0, smascharacterchanger.tvScrollNumber, -0.5)
            end
        end
    end
end

return smascharacterchanger