local Routine = require("routine")
local littleDialogue = require("littleDialogue")

SaveData.resolution = "fullscreen"
SaveData.letterbox = true
SaveData.borderEnabled = true
SaveData.SMASPlusPlus.game.onePointThreeModeActivated = false

local blacklayer = true
local whitelayer = false

local mleb = require("multilayeredearthboundbg")

local bg_example = Graphics.loadImage("bg_example.png")
local bg_example_palA = Graphics.loadImage("bg_example_palette_1.png")
local bg_example_palB = Graphics.loadImage("bg_example_palette_2.png")

local cutscenerunning1 = false
local cutscenerunning2 = false

littleDialogue.registerStyle("endingtextone",{
    openSpeed = 1,
    pageScrollSpeed = 1, -- How fast it scrolls when switching pages.
    answerPageScrollSpeed = 1, -- How fast it scrolls when switching answer pages.

    windowingOpeningEffectEnabled = true,

    typewriterEnabled = false,
    showTextWhileOpening = false,

    closeSoundEnabled = false,
    continueArrowEnabled = false,
    scrollArrowEnabled   = false,
    selectorImageEnabled = false,
})

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
        tint=Color.purple,
        distortion = vector(0.1, 0),
        palette = bg_example_palB,
        paletteHeight = 2,
})

mleb.addShaderSection(0, {
        texture = bg_example,
        interlace = 4,
        interlaceIntensity = 2,
        animationPhase = 0.33,
        animationSpeed = 0.25,
        verticalWobble = 0.4,
        tint=Color.darkred,
        oscillationAmplitude = 0.1,
        oscillationFrequency = 0.2,
        move = vector(0, 0),
        iFrequency = -0.2,
        iAmplitude = 0.158,
        distortion = vector(0, 0),
        palette = loadImage("bg_example_palA"),
        paletteHeight = 2,
})

local invisible = false

Graphics.activateHud(false)

local function box1()
    littleDialogue.create({text = "<boxStyle endingtextone><setPos 400 32 0.5 -8.0>File load failed."})
end

function onDraw()
    if blacklayer then
        local blackbglayer = Graphics.drawScreen{color = Color.black, priority = -99.5}
    end
    if whitelayer then
        local blackbglayer = Graphics.drawScreen{color = Color.white, priority = -90}
    end
end

function onStart()
    blackbglayer = true
    cutscenerunning1 = false
    cutscenerunning2 = false
    Misc.saveGame()
    player.setCostume(1, nil)
    player:transform(1, false)
    player.powerup = 2
end

function onInputUpdate()
    if cutscenerunning1 == true then
        player.keys.left = false
        player.keys.right = false
        player.keys.dropItem = false
        player.keys.altJump = false
        player.keys.altRun = false
        player.keys.run = false
        player.keys.down = false
        player.keys.up = false
    end
    if cutscenerunning1 == false then
        
    end
    if cutscenerunning2 == true then
        player.keys.left = false
        player.keys.right = false
        player.keys.dropItem = false
        player.keys.altJump = false
        player.keys.altRun = false
        player.keys.run = false
        player.keys.down = false
        player.keys.up = false
    end
    if cutscenerunning2 == false then
        
    end
end

function onTick()
    if invisible == true then
        player:setFrame(50)
    end
end

function onEvent(eventName)
    if eventName == "2" then
        invisible = true
        cutscenerunning1 = true
        Audio.sounds[1].sfx = Audio.SfxOpen("_OST/_Sound Effects/nothing.ogg")
    end
    if eventName == "4" then
        player:teleport(-197216, -200120)
        Routine.run(box1)
        Audio.sounds[3].sfx = Audio.SfxOpen("_OST/_Sound Effects/nothing.ogg")
    end
    if eventName == "5" then
        cutscenerunning1 = false
        cutscenerunning2 = true
        Audio.MusicChange(0, 0)
    end
    if eventName == "6" then
        Defines.earthquake = 10
        Sound.playSFX("mus_sfx_gigapunch.ogg")
    end
    if eventName == "7" then
        Defines.earthquake = 15
        Sound.playSFX("mus_sfx_gigapunch_2.ogg")
    end
    if eventName == "8" then
        Defines.earthquake = 25
        Sound.playSFX("mus_sfx_gigapunch_3.ogg")
    end
    if eventName == "9" then
        Defines.earthquake = 35
        blacklayer = false
        Sound.playSFX("mus_explosion.ogg")
    end
    if eventName == "13" then
        Audio.MusicChange(0, "_OST/All Stars Secrets/Raca Has Had It.ogg")
    end
    if eventName == "14" then
        Audio.MusicChange(0, 0)
        Sound.playSFX("raca-chant.ogg")
    end
    if eventName == "16" then
        whitelayer = true
        Defines.earthquake = 35
        Sound.playSFX("mus_explosion.ogg")
        Sound.playSFX("mario-screaming1.ogg")
    end
    if eventName == "18" then
        whitelayer = false
        blacklayer = true
    end
    if eventName == "BattleStart" then
        Level.load("SMAS - Raca's World (Part 1).lvlx", nil, nil)
    end
end