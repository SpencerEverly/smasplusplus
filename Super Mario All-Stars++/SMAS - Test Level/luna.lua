local warpTransition = require("warpTransition")
local textplus = require("textplus")
local littleDialogue = require("littleDialogue")
local pausemenu = require("pausemenu2")

if SaveData.disableX2char then
    pausemenu13 = require("pausemenu13/pausemenu13")
end

local pauseplus = require("pauseplus")
local debugbox = require("debugbox")
local extrasounds = require("extrasounds")
local smasHudSystem = require("smasHudSystem")

littleDialogue.defaultStyleName = "smbx13"
smasBooleans.compatibilityMode13Mode = false

local warps
local effect

local debugtext = true
local fonttester = textplus.loadFont("littleDialogue/font/pacman-arrangement.ini")

function effectSpawn()
    Routine.wait(0, true)
    warps = Warp.get()
    effect = Effect.spawn(105,warps[11].exitX - 20,warps[11].exitY - 85)
end

function onStart()
    Routine.run(effectSpawn)
    
    if SMBX_VERSION == VER_SEE_MOD then
        
    end
end 

function onEvent(eventName)
    if eventName == "pauseenable" then
        pauseplus.canPause = true
    end
    if eventName == "pausedisable" then
        pauseplus.canPause = false
    end
end

function onTick()
    littleDialogue.defaultStyleName = "smbx13"
end

local snapshottaken = false
local timesnapped

function onKeyboardPressDirect(k)
    if k == VK_F12 then
        timesnapped = string.format("%.1d:%.2d:%.2d.%.3d", lunatime.tick()/(60 * 60 * 65), (lunatime.tick()/(60*65))%60, (lunatime.tick()/65)%60, ((lunatime.tick()%65)/65) * 1000)
        snapshottaken = true
    end
end

function onDraw()
    if snapshottaken then
        Text.printWP(timesnapped, 100, 100, 3)
    end
    if debugtext then
        textplus.print{x = 0, y = 0, text = "1234567890", font = fonttester, priority = -0.5, xscale = 2, yscale = 2}
        textplus.print{x = 0, y = 25, text = "abcdefghijklmnopqrstuvwxyz", font = fonttester, priority = -0.5, xscale = 2, yscale = 2}
        textplus.print{x = 0, y = 50, text = "ABCDEFGHIJKLMNOPQRSTUVWXYZ", font = fonttester, priority = -0.5, xscale = 2, yscale = 2}
    end
end