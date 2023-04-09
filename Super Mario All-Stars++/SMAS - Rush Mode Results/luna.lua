local littleDialogue = require("littleDialogue")
local rng = require("base/rng")
local smasHud = require("smasHud")
local level_dependencies_rushmode = require("level_dependencies_rushmode")
local mleb = require("multilayeredearthboundbg")
local title = Graphics.loadImage("title-final-2x.png")

GameData.rushModeResultsActive = true
GameData.rushModeWon = false

smasHud.visible.keys = false
smasHud.visible.itembox = false
smasHud.visible.bombs = false
smasHud.visible.coins = false
smasHud.visible.score = false
smasHud.visible.lives = false
smasHud.visible.stars = false
smasHud.visible.starcoins = false
smasHud.visible.timer = false
smasHud.visible.levelname = false
smasHud.visible.overworldPlayer = false
smasHud.visible.deathcount = false
if not Misc.inMarioChallenge() then
    smasHud.visible.customitembox = false
end

local exitscreen = false

mleb.addShaderSection(0, {
        texture = bg_example,
        interlace = 4,
        interlaceIntensity = 2,
        animationPhase = -0.533,
        animationSpeed = 0.5,
        verticalWobble = 0.1,
        oscillationAmplitude = 0.1,
        oscillationFrequency = 0.2,
        move = vector(0, 0),
        iFrequency = 0.1,
        iAmplitude = 0.158,
        tint=Color.blue,
        distortion = vector(0.1, 0),
       -- palette = bg_example_palB,
        paletteHeight = 2,
})

mleb.addShaderSection(0, {
        texture = bg_example,
        interlace = 4,
        interlaceIntensity = 2,
        animationPhase = 0.13,
        animationSpeed = 0.45,
        verticalWobble = 0.4,
        tint=Color.red,
        oscillationAmplitude = 0.1,
        oscillationFrequency = 0.2,
        move = vector(0, 0),
        iFrequency = -0.2,
        iAmplitude = 0.158,
        distortion = vector(0, 0),
        --palette = loadImage("bg_example_palA"),
        paletteHeight = 2,
})

mleb.addShaderSection(0, {
        texture = title,
        interlace = 2,
        interlaceIntensity = 2,
        animationPhase = 2,
        animationSpeed = 0.78,
        verticalWobble = 0.15,
        oscillationAmplitude = 0.1,
        oscillationFrequency = 0.4,
        move = vector(0, 0),
        iFrequency = 0.2,
        iAmplitude = 0.28,
        distortion = vector(0, 0),
    })

function startNextLevel()
    exitscreen = true
    Sound.playSFX(14)
    Sound.muteMusic(-1)
    Routine.wait(0.4)
    Misc.saveGame()
    Level.load(smasTables.__allMandatoryLevels[rng.randomInt(1,#smasTables.__allMandatoryLevels)], nil, nil)
end

function restartLastLevel()
    exitscreen = true
    Sound.playSFX(14)
    Sound.muteMusic(-1)
    Routine.wait(0.4)
    Misc.saveGame()
    Level.load(SaveData.lastLevelPlayed)
end

function exitRushMode()
    exitscreen = true
    Sound.playSFX(14)
    Sound.muteMusic(-1)
    GameData.rushModeActive = false
    Routine.wait(0.4)
    Misc.saveGame()
    Level.load("SMAS - Start.lvlx")
end

function onStart()
    littleDialogue.create({text = "<boxStyle gameoverdialog><setPos 400 32 0.5 -2.0><question MenuBoxOne>", pauses = false, updatesInPause = true})
end

function onExit()
    GameData.rushModeResultsActive = false
end

function onDraw()
    Playur.execute(-1, function(plr) plr:setFrame(50) end) --Prevent any player from showing up on the boot menu
    if exitscreen then
        Graphics.drawScreen{color = Color.black, priority = 10}
    end
end

littleDialogue.registerAnswer("MenuBoxOne",{text = "Start Next Level",chosenFunction = function() Routine.run(startNextLevel) end})
littleDialogue.registerAnswer("MenuBoxOne",{text = "Restart Previous Level",chosenFunction = function() Routine.run(restartLastLevel) end})
littleDialogue.registerAnswer("MenuBoxOne",{text = "Exit Rush Mode",chosenFunction = function() Routine.run(exitRushMode) end})