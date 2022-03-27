local bootmenu = require("bootmenu")
local littleDialogue = require("littleDialogue")

function onPause(evt)
    evt.cancelled = true;
    isPauseMenuOpen = not isPauseMenuOpen
end