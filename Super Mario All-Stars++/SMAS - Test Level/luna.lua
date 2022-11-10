local warpTransition = require("warpTransition")
local textplus = require("textplus")
local littleDialogue = require("littleDialogue")
local pausemenu = require("pausemenu2")
local pauseplus = require("pauseplus")
local debugbox = require("debugbox")
local extrasounds = require("extrasounds")
local smashudsystem = require("smashudsystem")

littleDialogue.defaultStyleName = "smbx13"
smasbooleans.compatibilityMode13Mode = false

local warps
local effect

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
end