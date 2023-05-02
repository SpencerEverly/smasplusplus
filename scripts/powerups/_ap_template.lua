local apt = {}

-- Variable "name" is reserved
-- variable "registerItems" is reserved

apt.spritesheets = {
    --Mario
    --Luigi
    --Peach
    --Toad
    --Link
}

-- sounds for new collection and repeat collection
apt.apSounds = {
    upgrade = 6,
    reserve = 12
}

apt.items = {} -- Items that can be collected

-- Runs when player switches to this powerup. Use for setting stuff like global Defines.
function apt.onEnable()

end

-- Runs when player switches to this powerup. Use for resetting stuff from onEnable.
function apt.onDisable()

end

-- If you wish to have global onTick etc... functions, you can register them with an alias like so:
-- registerEvent(apt, "onTick", "onPersistentTick")

-- No need to register. Runs only when powerup is active.
function apt.onTick()

end

-- No need to register. Runs only when powerup is active.
function apt.onTickEnd()

end

-- No need to register. Runs only when powerup is active.
function apt.onDraw()

end

return apt