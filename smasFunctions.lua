--smasFunctions.lua
--v1.0
--For more information on this library, use "smasFunctions.help()",
--or read the txt file "smasfunctions_help.txt" in the episode folder.

local smasFunctions = {}

if SMBX_VERSION == VER_SEE_MOD then
    console:println("SEE MOD DETECTED! Loading LunaDLL.dll...")
    _G.LunaDLL = ffi.load("LunaDll.dll")
end

console:println("Loading SMASFunctions...")

_G.smasSaveDataSystem = require("smasSaveDataSystem") --Load smasSaveDataSystem as early as smasFunctions because we're wanting this to be a low-level library, when costumes are officially loaded

--Now for the base functions!
_G.Misk = require("scripts/functions/misc")
_G.File = require("scripts/functions/file")
_G.Img = require("scripts/functions/img")
_G.Sound = require("scripts/functions/sound")
_G.Tabled = require("scripts/functions/table")
_G.SysManager = require("scripts/functions/sysmanager")
_G.Time = require("scripts/functions/time")
_G.Playur = require("scripts/functions/player")
_G.Npc = require("scripts/functions/npc")
_G.Screen = require("scripts/functions/camera")
_G.Evento = require("scripts/functions/events")
_G.Effectx = require("scripts/functions/effect")
_G.Collisionz = require("scripts/functions/collision")
_G.Liquidz = require("scripts/functions/liquid")

--This is used for spitting out help documentation for these scripts.
function smasFunctions.help()
    Misc.richDialog("SMASFunctions Help Dialog Box", File.readFile("smasFunctions_help.txt"), true)
end

_G.smasCharacterGlobals = require("smasCharacterGlobals")
_G.smasCharacterCostumes = require("smasCharacterCostumes")
_G.smasCharacterHealthSystem = require("smasCharacterHealthSystem")

return smasFunctions