local smasExtraSounds = require("smasExtraSounds")
local littleDialogue = require("littleDialogue")
local blackscreen = false

Graphics.activateHud(false)

function onStart()
    if SaveData.GameOverCount == nil then
        SaveData.GameOverCount = SaveData.GameOverCount or 0
    end
    SaveData.GameOverCount = SaveData.GameOverCount + 1
    if SaveData.disableX2char then
        mem(0x00B2C5AC,FIELD_FLOAT, 3)
    end
    Sound.playSFX("gameover-sound.ogg")
end

function onTick()
    Audio.sounds[1].muted  = true
    Audio.sounds[2].muted  = true
    Audio.sounds[3].muted  = true
    Audio.sounds[18].muted  = true
    Audio.sounds[28].muted  = true
end

function onInputUpdate()
    player.leftKeyPressing = false
    player.rightKeyPressing = false
    player.altJumpKeyPressing = false
    player.runKeyPressing = false
    player.altRunKeyPressing = false
    player.dropItemKeyPressing = false
    player.pauseKeyPressing = false
end

function onEvent(eventName)
    if eventName == "Game Over Timing Execution 2" then
        Sound.playSFX("gameover-announcer.ogg")
    end
    if eventName == "Game Over Timing Execution 3" then
        littleDialogue.create({text = "<setPos 400 32 0.5 -4.5><boxStyle gameoverdialog><question gameoverselect>", pauses = true, updatesInPause = true})
    end
    if eventName == "Continued1" then
        Sound.playSFX(27)
    end
    if eventName == "Continued2" then
        Level.load(SaveData.lastLevelPlayed, nil, 0)
    end
    if eventName == "Restart1" then
        Sound.playSFX(27)
    end
    if eventName == "Restart2" then
        Level.load("SMAS - Start.lvlx", nil, nil)
    end
    if eventName == "EndGame1" then
        Sound.playSFX(14)
        blackscreen = true
        Misc.saveGame()
    end
    if eventName == "EndGame2" then
        Misc.exitEngine()
    end
end

function onDraw()
    if blackscreen then
        Graphics.drawScreen{color = Color.black, priority = 10}
    end
end

littleDialogue.registerAnswer("gameoverselect",{text = "Continue",chosenFunction = function() triggerEvent("Continued1") end})
littleDialogue.registerAnswer("gameoverselect",{text = "Restart",chosenFunction = function() triggerEvent("Restart1") end})
littleDialogue.registerAnswer("gameoverselect",{text = "End Game",chosenFunction = function() triggerEvent("EndGame1") end})