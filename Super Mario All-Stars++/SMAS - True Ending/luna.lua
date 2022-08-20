local level_dependencies_normal= require("level_dependencies_normal")
local Routine = require("routine")
local furyinventory = require("furyinventory")

local stars = SaveData.totalStarCount

local whiteflash = false
local blackscreen = false
local invisible = false

local timer1 = 0
local speed = 0
local numberup = 0
local time = 0

local opacity = timer1/speed
local middle = math.floor(timer1*numberup)

local function Crash()
    Misc.saveGame()
    Routine.wait(0.1, true)
    --mem(0x00B257F0, FIELD_FLOAT, 245353464654)
    Misc.exitEngine()
end

local function WhiteFadeInSlow()
    whiteflashpre1 = true
end

function onLoad()
    if SaveData.disableX2char == true then
        SaveData.disableX2char = false
    end
end

function onStart()
    Audio.MusicVolume(65)
end

function onTick()
    Audio.sounds[52].sfx  = Audio.SfxOpen("_OST/_Sound Effects/nothing.ogg")
    Audio.sounds[45].sfx  = Audio.SfxOpen("_OST/_Sound Effects/nothing.ogg")
    if invisible == true then
        player:setFrame(50)
    end
end

function onEvent(eventName)
    if eventName == "GenosideEnding" then
        Sound.changeMusic("_OST/Undertale/mus_smallshock_genoside.ogg", 0)
        Sound.changeMusic("_OST/Undertale/mus_smallshock_genoside.ogg", 1)
        Sound.changeMusic("_OST/Undertale/mus_smallshock_genoside.ogg", 2)
        Sound.changeMusic("_OST/Undertale/mus_smallshock_genoside.ogg", 3)
        Sound.changeMusic("_OST/Undertale/mus_inmyway.ogg", 4)
        Sound.changeMusic("_OST/Undertale/mus_smallshock_genoside.ogg", 5)
        Sound.changeMusic("_OST/Undertale/mus_inmyway.ogg", 6)
        Sound.changeMusic("_OST/Undertale/mus_inmyway.ogg", 7)
    end
    if eventName == "NormalCutsceneBegin" then
        pauseplus.canPause = false
        furyinventory.activated = false
        player:teleport(-78784, -80128)
        triggerEvent("NormalCutsceneBegin2")
        player.keys.left = false
        player.keys.right = false
        player.keys.pause = false
        player.keys.dropItem = false
        player.keys.altRun = false
        player.keys.up = false
        player.keys.down = false
        player.keys.altJump = false
        Sound.muteMusic(-1)
        Graphics.activateHud(false)
        smasbooleans.toggleoffinventory = true
        Sound.playSFX("mus_explosion.ogg")
        if SMBX_VERSION == VER_SEE_MOD then
            Misc.shakeWindow(35, false, false)
        end
        whiteflash = true
        player.setCostume(1, nil)
        player:transform(1, false)
        Audio.sounds[1].sfx  = Audio.SfxOpen("_OST/_Sound Effects/nothing.ogg")
        Audio.sounds[2].sfx  = Audio.SfxOpen("_OST/_Sound Effects/nothing.ogg")
        Audio.sounds[3].sfx  = Audio.SfxOpen("_OST/_Sound Effects/nothing.ogg")
    end
    if eventName == "NormalCutscene1" then
        whiteflash = false
        invisible = true
        SFX.play(5)
    end
    if eventName == "NormalCutscene2" then
        Sound.changeMusic("_OST/Deltarune/GALLERY.ogg", 6)
    end
    if eventName == "NormalCutscene3" then
        Sound.playSFX("raca-chant.ogg")
    end
    if eventName == "NormalCutscene4" then
        
    end
    if eventName == "NormalCutscene5" then
        Sound.muteMusic(-1)
    end
    if eventName == "NormalCutscene6" then
        if SaveData.racaActivated == nil then
            SaveData.racaActivated = 0
        end
        SaveData.racaActivated = 1
        SaveData.introselect = 1
        SaveData.resolution = "fullscreen"
        SaveData.letterbox = true
        SaveData.borderEnabled = false
        SaveData.clockTheme = "normal"
        Misc.saveGame()
        Routine.run(WhiteFadeInSlow)
        Sound.playSFX("raca-chant.ogg")
        SFX.play("_OST/Undertale/mus_cymbal.ogg")
        Misc.saveGame()
    end
    if eventName == "CrashExecute" then
        Misc.saveGame()
        Routine.run(Crash)
    end
end

function onDraw()
    if whiteflash then
        Graphics.drawScreen{color = Color.white, priority = 10}
    end
    if blackscreen then
        Graphics.drawScreen{color = Color.black, priority = 10}
    end
    if whiteflashpre1 then
        time = time + 1
        Graphics.drawScreen{color = Color.white..math.max(0,time/293),priority = 10}
    end
end

function onEnd()
    if Level.finish(LEVEL_END_STATE_GAMEEND) then
        Level.load("SMAS - Credits.lvlx", nil, nil)
    end
end