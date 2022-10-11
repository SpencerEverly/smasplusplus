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
smascharacterchanger.selectionNumber = 1 --For scrolling left and right
smascharacterchanger.selectionNumberUpDown = 1 --For scrolling up and down
smascharacterchanger.maxCharacters = 20 --The max characters from left and right to choose from
smascharacterchanger.maxVariants = { --The max variants from up and down to choose from. This is chosen depending on what is chosen from left to right.
    1,
    1,
    1,
    1,
    1,
    1,
    1,
    1,
    1,
    1,
    1,
    1,
    1,
    1,
    1,
    1,
    1,
    1,
    1,
    1,
}

smascharacterchanger.namesSide = {
    "Mario",
    "Luigi",
    "Peach",
    "Toad",
    "Link",
    "Mega Man",
    "Wario",
    "Bowser",
    "Klonoa",
    "Yoshi",
    "Rosalina",
    "Snake",
    "Zelda",
    "Steve",
    "Uncle Broadsword",
    "Samus",
    "Frisk",
    "Tangent",
    "SpongeBob",
    "Eric Cartman",
}

smascharacterchanger.namesSideGame = {
    "Super Mario Bros. 3",
    "Super Mario Bros. 3",
    "Super Mario Bros. 2",
    "Super Mario Bros. 2",
    "Zelda II",
    "Mega Man X7",
    "SMBX2",
    "SMBX2",
    "Klonoa 2 (GBA)",
    "SMW2: Yoshi's Island",
    "SMBX2",
    "SMBX2",
    "SMBX2",
    "Minecraft",
    "A2XT",
    "Metroid (SMBX2)",
    "Undertale",
    "Spencer Everly (SEE)",
    "SpongeBob SquarePants",
    "South Park",
}
    


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
        if player.keys.up == KEYS_PRESSED then
            Sound.playSFX(26)
            smascharacterchanger.selectionNumberUpDown = smascharacterchanger.selectionNumberUpDown + 1
            if smascharacterchanger.selectionNumberUpDown > smascharacterchanger.maxVariants[smascharacterchanger.selectionNumber] then
                smascharacterchanger.selectionNumberUpDown = 1
            end
        elseif player.keys.down == KEYS_PRESSED then
            Sound.playSFX(26)
            smascharacterchanger.selectionNumberUpDown = smascharacterchanger.selectionNumberUpDown - 1
            if smascharacterchanger.selectionNumberUpDown < 1 then
                smascharacterchanger.selectionNumberUpDown = 1
            end
        end
        if player.keys.left == KEYS_PRESSED then
            Sound.playSFX(26)
            smascharacterchanger.selectionNumber = smascharacterchanger.selectionNumber - 1
            smascharacterchanger.selectionNumberUpDown = 1
        elseif player.keys.right == KEYS_PRESSED then
            Sound.playSFX(26)
            smascharacterchanger.selectionNumber = smascharacterchanger.selectionNumber + 1
            smascharacterchanger.selectionNumberUpDown = 1
        end
        if player.keys.jump == KEYS_PRESSED then
            Sound.playSFX("charcost_costume.ogg")
            Sound.playSFX("charcost-selected.ogg")
            if smascharacterchanger.selectionNumber >= 1 and smascharacterchanger.selectionNumber <= 5 and smascharacterchanger.selectionNumberUpDown == 1 then
                player:transform(smascharacterchanger.selectionNumber, false)
                player.setCostume(smascharacterchanger.selectionNumber, "!DEFAULT", false)
            elseif smascharacterchanger.selectionNumber >= 6 and smascharacterchanger.selectionNumber <= 16 and smascharacterchanger.selectionNumberUpDown == 1 then
                player:transform(smascharacterchanger.selectionNumber, false)
                player.setCostume(smascharacterchanger.selectionNumber, nil, false)
            end
            if smascharacterchanger.selectionNumber == 17 and smascharacterchanger.selectionNumberUpDown == 1 then
                player:transform(CHARACTER_LUIGI, false)
                player.setCostume(CHARACTER_LUIGI, "UNDERTALE-FRISK", false)
            elseif smascharacterchanger.selectionNumber == 18 and smascharacterchanger.selectionNumberUpDown == 1 then
                player:transform(CHARACTER_TOAD, false)
                player.setCostume(CHARACTER_TOAD, "SEE-TANGENT", false)
            elseif smascharacterchanger.selectionNumber == 19 and smascharacterchanger.selectionNumberUpDown == 1 then
                player:transform(CHARACTER_MARIO, false)
                player.setCostume(CHARACTER_MARIO, "SPONGEBOBSQUAREPANTS", false)
            elseif smascharacterchanger.selectionNumber == 20 and smascharacterchanger.selectionNumberUpDown == 1 then
                player:transform(CHARACTER_MARIO, false)
                player.setCostume(CHARACTER_MARIO, "SP-1-ERICCARTMAN", false)
            end
            if smascharacterchanger.selectionNumber then
                smascharacterchanger.menuActive = false
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
            Text.print(smascharacterchanger.selectionNumberUpDown, 100, 120)
            if smascharacterchanger.selectionNumber < 1 then
                smascharacterchanger.selectionNumber = smascharacterchanger.maxCharacters
            elseif smascharacterchanger.selectionNumber > smascharacterchanger.maxCharacters then
                smascharacterchanger.selectionNumber = 1
            end
            if smascharacterchanger.selectionNumber and smascharacterchanger.selectionNumberUpDown == 1 then
                textPrintCentered(smascharacterchanger.namesSide[smascharacterchanger.selectionNumber], 400, 200)
                textPrintCentered(smascharacterchanger.namesSideGame[smascharacterchanger.selectionNumber], 400, 250)
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