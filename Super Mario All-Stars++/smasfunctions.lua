--smasfunctions.lua
--v1.0
--For more information on this library, use "smasfunctions.help()",
--or read the txt file "smasfunctions_help.txt" in the episode folder.

local smasfunctions = {}

_G.File = require("scripts/functions/file")
_G.Img = require("scripts/functions/img")
_G.Sound = require("scripts/functions/sound")
_G.SysManager = require("scripts/functions/sysmanager")
_G.Time = require("scripts/functions/time")
_G.Playur = require("scripts/functions/player")
_G.Npc = require("scripts/functions/npc")
_G.Misk = require("scripts/functions/misc")
_G.Screen = require("scripts/functions/camera")
_G.Evento = require("scripts/functions/events")

function smasfunctions.help()
    Misc.richDialog("SMASFunctions Help Dialog Box", File.readFile("smasfunctions_help.txt"), true)
end

return smasfunctions