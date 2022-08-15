local bootmenu = require("bootmenu")
bootmenu.active = true

local rng = require("base/rng")

function onStart()
    local rngnumber = rng.randomInt(1,30)
    Sound.changeMusic("intro_SMBX2b3/trials"..rngnumber..".ogg", 0)
end

function onPause(evt)
    evt.cancelled = true;
    isPauseMenuOpen = not isPauseMenuOpen
end