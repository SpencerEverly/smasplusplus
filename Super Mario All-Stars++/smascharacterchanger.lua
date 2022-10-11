local smascharacterchanger = {}

local playerManager = require("playerManager")
local textplus = require("textplus")
local smbx13font = textplus.loadFont("littleDialogue/font/hardcoded-45-2-textplus-1x.ini")

function smascharacterchanger.onInitAPI()
    registerEvent(smascharacterchanger,"onDraw")
    registerEvent(smascharacterchanger,"onInputUpdate")
    registerEvent(smascharacterchanger,"onKeyboardPressDirect")
end

smascharacterchanger.tvImage = Img.load("graphics/characterchangermenu/tv.png") --The image for the TV.
smascharacterchanger.scrollSFX = "_OST/_Sound Effects/characterchangermenu/scrolling-tv.ogg"
smascharacterchanger.stopSFX = "_OST/_Sound Effects/characterchangermenu/scrolled-tv.ogg"
smascharacterchanger.turnOnSFX = "_OST/_Sound Effects/characterchangermenu/turn-on-tv.ogg"
smascharacterchanger.menuActive = false --True if the menu is active.
smascharacterchanger.animationActive = false --True if the animation is active.
smascharacterchanger.animationTimer = 0 --Timer for the animation, both for the start and end sequences.
smascharacterchanger.tvScrollNumber = -600 --This is used for the TV animation sequence.
smascharacterchanger.menuBGM = "_OST/All Stars Menu/Character Changer Menu.ogg"
smascharacterchanger.selectionNumber = 0 --For scrolling left and right
smascharacterchanger.maxCharacters = 5 --The max characters from left and right to choose from



local soundObject1
local menuBGMObject

local started = false
local ending = false

local function textPrintCentered(t, x, y, color)
    textplus.print{text=t, x=x, y=y, plaintext=true, pivot=vector.v2(0.5,0.5), xscale=2, yscale=2, color=color, priority = -0.7, font = smbx13font}
end

function smascharacterchanger.startupChanger()
    Misc.pause()
    Sound.muteMusic(-1)
    soundObject1 = SFX.play(smascharacterchanger.scrollSFX)
    Routine.waitFrames(10, true)
    Misc.pause()
    Routine.waitFrames(54, true)
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
        if player.keys.left == KEYS_PRESSED then
            Sound.playSFX(26)
            smascharacterchanger.selectionNumber = smascharacterchanger.selectionNumber - 1
        end
        if player.keys.right == KEYS_PRESSED then
            Sound.playSFX(26)
            smascharacterchanger.selectionNumber = smascharacterchanger.selectionNumber + 1
        end
        if player.keys.jump == KEYS_PRESSED then
            Sound.playSFX(1001)
            if smascharacterchanger.selectionNumber == 0 then
                player:transform(CHARACTER_MARIO, false)
                playerManager.setCostume(CHARACTER_MARIO, "!Default")
            end
            if smascharacterchanger.selectionNumber == 1 then
                player:transform(CHARACTER_LUIGI, false)
                playerManager.setCostume(CHARACTER_LUIGI, "!Default")
            end
            if smascharacterchanger.selectionNumber == 2 then
                player:transform(CHARACTER_TOAD, false)
                playerManager.setCostume(CHARACTER_TOAD, "!Default")
            end
            if smascharacterchanger.selectionNumber == 3 then
                player:transform(CHARACTER_PEACH, false)
                playerManager.setCostume(CHARACTER_PEACH, "!Default")
            end
            if smascharacterchanger.selectionNumber == 4 then
                player:transform(CHARACTER_LINK, false)
                playerManager.setCostume(CHARACTER_LINK, "!Default")
            end
            if smascharacterchanger.selectionNumber == 5 then
                player:transform(CHARACTER_MEGAMAN, false)
                playerManager.setCostume(CHARACTER_MEGAMAN, nil)
            end
            if smascharacterchanger.selectionNumber then
                GameData.savedXCoordinate = player.x
                GameData.savedYCoordinate = player.y
                GameData.respringActive = true
                Misc.unpause()
                Level.load(Level.filename())
            end
        end
    end
end

function smascharacterchanger.onDraw()
    if smascharacterchanger.menuActive then
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
        if started then
            textPrintCentered("Select your character!", 400, 100)
            Text.print(smascharacterchanger.selectionNumber, 100, 100)
            if smascharacterchanger.selectionNumber < 0 then
                smascharacterchanger.selectionNumber = smascharacterchanger.maxCharacters
            elseif smascharacterchanger.selectionNumber > smascharacterchanger.maxCharacters then
                smascharacterchanger.selectionNumber = 0
            end
            if smascharacterchanger.selectionNumber == 0 then
                textPrintCentered("Mario", 400, 200)
                textPrintCentered("Super Mario Bros. 3", 400, 250)
            elseif smascharacterchanger.selectionNumber == 1 then
                textPrintCentered("Luigi", 400, 200)
                textPrintCentered("Super Mario Bros. 3", 400, 250)
            elseif smascharacterchanger.selectionNumber == 2 then
                textPrintCentered("Toad", 400, 200)
                textPrintCentered("Super Mario Bros. 2", 400, 250)
            elseif smascharacterchanger.selectionNumber == 3 then
                textPrintCentered("Peach", 400, 200)
                textPrintCentered("Super Mario Bros. 2", 400, 250)
            elseif smascharacterchanger.selectionNumber == 4 then
                textPrintCentered("Link", 400, 200)
                textPrintCentered("Zelda II: The Adventure", 400, 250)
                textPrintCentered("of Link", 400, 270)
            elseif smascharacterchanger.selectionNumber == 5 then
                textPrintCentered("Mega Man", 400, 200)
                textPrintCentered("Mega Man X7", 400, 250)
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