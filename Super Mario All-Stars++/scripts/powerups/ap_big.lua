local apt = {}

-- Variable "name" is reserved
-- variable "registerItems" is reserved

apt.spritesheets = {
    Graphics.sprites.mario[2].img, --Mario
    Graphics.sprites.luigi[2].img, --Luigi
    Graphics.sprites.peach[2].img, --Peach
    Graphics.sprites.toad[2].img, --Toad
    Graphics.sprites.link[2].img, --Link
}
apt.items = {9,184,185,249,264,277} -- Items that can be collected

--------------------

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