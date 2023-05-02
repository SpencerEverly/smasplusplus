local pm = require("playermanager")

local intro = {}
durationtoend = lunatime.toTicks(0.7);

local timepause = {};

p = p or player


local openend = durationtoend

function intro.onInitAPI()
        musicChunk = Audio.SfxOpen(mega2.sfxFile)
        
        registerEvent(mega2, "onInputUpdate")
        registerEvent(mega2, "onTick")
        registerEvent(mega2, "onDraw")
        registerEvent(mega2, "onDrawEnd")
        
        registerCustomEvent(intro, "StartTimer");
end

function intro.StartTimer(pobj, useShrink, p)
pobj = pobj or player;
if not timepause[pobj] then
    return
end

intro.onExitMega(pobj, useShrink);
timepause[pobj] = false

if(useShrink) then


if timepause[p] then