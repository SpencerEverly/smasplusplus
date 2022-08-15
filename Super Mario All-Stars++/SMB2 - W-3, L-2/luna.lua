local level_dependencies_normal= require("level_dependencies_normal")

function onStart()
local character = player.character;
  if (character == CHARACTER_YOSHI) then
    triggerEvent("YoshiSoftlockPrevention")
    end
end