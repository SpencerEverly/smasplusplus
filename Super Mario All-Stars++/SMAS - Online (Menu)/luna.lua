local mleb = require("multilayeredearthboundbg")
local littleDialogue = require("littleDialogue")
local Routine = require("routine")
Graphics.activateHud(false)
local title = Graphics.loadImage("title-final-2x.png")
if SMBX_VERSION == VER_SEE_MOD then
    local wifiaccess = require("wifiaccess")
end
local extrasounds = require("extrasounds")

local exitwordswip = false

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
        animationPhase = 0.33,
        animationSpeed = 0.25,
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
        verticalWobble = 0.05,
        oscillationAmplitude = 0.1,
        oscillationFrequency = 0.4,
        move = vector(0, 0),
        iFrequency = 0.2,
        iAmplitude = 0.28,
        distortion = vector(0, 0),
    })

littleDialogue.defaultStyleName = "smbx13" --Change the text box to the SMBX 1.3 textbox format
extrasounds.active = false

local function ExitToBootMenu()
    exitscreen = true
    Audio.MusicChange(0, 0)
    Routine.wait(0.4)
    Misc.saveGame()
    Level.load("SMAS - Start.lvlx", nil, nil)
end

local function ExitToBootMenuWithSound()
    Sound.playSFX(14)
    exitscreen = true
    Audio.MusicChange(0, 0)
    Routine.wait(0.4)
    Misc.saveGame()
    Level.load("SMAS - Start.lvlx", nil, nil)
end

local function ExitMenu()
    exitwordswip = true
end

function NotFinished()
    littleDialogue.create({text = "<setPos 400 32 0.5 -1.7>Currently a work in progress. Please visit again some other time.<question QuitToMenuError>", pauses = false, updatesInPause = true})
end

function onlineBegin()
    if SMBX_VERSION == VER_SEE_MOD then
        littleDialogue.create({text = "<setPos 400 32 0.5 -1.7>Welcome to the world of online multiplayer.<page>This is the place to host and connect to other 2 player sessions, and experience the game like never before!<page>Please note that this place is under testing, and things won't be done as of yet.<page>When you see an loading icon, it is connecting to the Internet. Please don't close the game during that sequence.<page>With that being said, welcome to Online Multiplayer.<question StartConnecting>", pauses = false, updatesInPause = true})
    elseif SMBX_VERSION <= VER_BETA4_PATCH_4_1 then
        Audio.MusicChange(0, 0)
        littleDialogue.create({text = "<setPos 400 32 0.5 -1.0>Whoops! It looks like you're using the original LunaLua. Please use the SEE Mod to make online multiplayer work. You can get it here: https://github.com/SpencerEverly/smbx2-seemod<question QuitToMenuError2>", pauses = false, updatesInPause = true})
    end
end
    
function onStart()
    extrasounds.active = false
    Routine.run(onlineBegin)
    littleDialogue.defaultStyleName = "smbx13" --Change the text box to the SMBX 1.3 textbox format
end

function onTick()
    littleDialogue.defaultStyleName = "smbx13" --Change the text box to the SMBX 1.3 textbox format
    player:setFrame(50)
    player:mem(0x140, FIELD_BOOL, 150)
    if player:mem(0x140, FIELD_BOOL) == 0 then
        player:mem(0x140, FIELD_BOOL, 150)
    end
    Defines.cheat_donthurtme = true --These are to prevent the player from dying
    Audio.sounds[1].muted = true
    Audio.sounds[2].muted = true
    Audio.sounds[3].muted = true
    Audio.sounds[4].muted = true
    Audio.sounds[5].muted = true
    Audio.sounds[6].muted = true
    Audio.sounds[7].muted = true
    Audio.sounds[8].muted = true
    Audio.sounds[9].muted = true
    Audio.sounds[10].muted = true
    Audio.sounds[11].muted = true
    Audio.sounds[12].muted = true
    Audio.sounds[13].muted = true
    Audio.sounds[14].muted = true
    Audio.sounds[15].muted = true
    Audio.sounds[16].muted = true
    Audio.sounds[17].muted = true
    Audio.sounds[18].muted = true
    Audio.sounds[19].muted = true
    Audio.sounds[20].muted = true
    Audio.sounds[21].muted = true
    Audio.sounds[22].muted = true
    Audio.sounds[23].muted = true
    Audio.sounds[24].muted = true
    Audio.sounds[25].muted = true
    Audio.sounds[29].muted = true
    Audio.sounds[31].muted = true
    Audio.sounds[32].muted = true
    Audio.sounds[33].muted = true
    Audio.sounds[34].muted = true
    Audio.sounds[35].muted = true
    Audio.sounds[36].muted = true
    Audio.sounds[37].muted = true
    Audio.sounds[42].muted = true
    Audio.sounds[43].muted = true
    Audio.sounds[44].muted = true
    Audio.sounds[46].muted = true
    Audio.sounds[48].muted = true
    Audio.sounds[49].muted = true
    Audio.sounds[50].muted = true
    Audio.sounds[51].muted = true
    Audio.sounds[52].muted = true
    Audio.sounds[54].muted = true
    Audio.sounds[55].muted = true
    Audio.sounds[57].muted = true
    Audio.sounds[58].muted = true
    Audio.sounds[59].muted = true
    Audio.sounds[61].muted = true
    Audio.sounds[62].muted = true
    Audio.sounds[63].muted = true
    Audio.sounds[71].muted = true
    Audio.sounds[72].muted = true
    Audio.sounds[73].muted = true
    Audio.sounds[74].muted = true
    Audio.sounds[75].muted = true
    Audio.sounds[76].muted = true
    Audio.sounds[77].muted = true
    Audio.sounds[78].muted = true
    Audio.sounds[79].muted = true
    Audio.sounds[80].muted = true
    Audio.sounds[81].muted = true
    Audio.sounds[82].muted = true
    Audio.sounds[83].muted = true
    Audio.sounds[84].muted = true
    Audio.sounds[85].muted = true
    Audio.sounds[86].muted = true
    Audio.sounds[87].muted = true
    Audio.sounds[88].muted = true
    Audio.sounds[89].muted = true
    Audio.sounds[90].muted = true
    Audio.sounds[91].muted = true
end

function onDraw()
    if exitscreen then
        Graphics.drawScreen{color = Color.black, priority = 10}
    end
    if exitwordswip then
        Text.printWP("To exit, press PAGE DOWN.", 200, 200, -1)
    end
end

function onKeyboardPress(k)
    if k == VK_NEXT then
        Routine.run(ExitToBootMenuWithSound)
    end
end

function onExit()
    Defines.cheat_donthurtme = false
    Defines.cheat_shadowmario = false
end

littleDialogue.registerAnswer("QuitToMenuError",{text = "Exit",chosenFunction = function() Routine.run(ExitMenu) end})

littleDialogue.registerAnswer("QuitToMenuError2",{text = "Exit",chosenFunction = function() Routine.run(ExitToBootMenu) end})

littleDialogue.registerAnswer("StartConnecting",{text = "Let's get started!",chosenFunction = function() Routine.run(NotFinished) end})