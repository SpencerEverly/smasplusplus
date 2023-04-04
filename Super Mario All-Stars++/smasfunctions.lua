--smasfunctions.lua
--v1.0
--For more information on this library, use "smasfunctions.help()",
--or read the txt file "smasfunctions_help.txt" in the episode folder.

local smasfunctions = {}

--If loading it with a costume, load these libraries here to prevent errors
if SFX == nil then
    require("base/audiomaster")
end
if Cheats == nil then
    require("base/game/newcheats")
end

--Now for the base functions!
_G.Misk = require("scripts/functions/misc")
_G.File = require("scripts/functions/file")
_G.Img = require("scripts/functions/img")
_G.Sound = require("scripts/functions/sound")
_G.SysManager = require("scripts/functions/sysmanager")
_G.Time = require("scripts/functions/time")
_G.Playur = require("scripts/functions/player")
_G.Npc = require("scripts/functions/npc")
_G.Screen = require("scripts/functions/camera")
_G.Evento = require("scripts/functions/events")
_G.Effectx = require("scripts/functions/effect")

--This is used for spitting out help documentation for these scripts.
function smasfunctions.help()
    Misc.richDialog("SMASFunctions Help Dialog Box", File.readFile("smasfunctions_help.txt"), true)
end

if Misc.inSuperMarioAllStarsPlusPlus() then --Easy-to-require SMAS++-specific globals, to load early on boot
    _G.smascharacterglobals = require("smascharacterglobals")
end

return smasfunctions