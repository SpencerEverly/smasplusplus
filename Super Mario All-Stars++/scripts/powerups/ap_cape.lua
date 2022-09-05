--[[

    Cape for anotherpowerup.lua
    by MrDoubleA

    Credit to JDaster64 for making a SMW physics guide and ripping SMA4 Mario/Luigi sprites
    Custom Toad and Link sprites by Legend-Tony980 (https://www.deviantart.com/legend-tony980/art/SMBX-Toad-s-sprites-Fourth-Update-724628909, https://www.deviantart.com/legend-tony980/art/SMBX-Link-s-sprites-Sixth-Update-672269804)
    Custom Peach sprites by Lx Xzit and Pakesho
    SMW Mario and Luigi graphics from AwesomeZack

    Credit to FyreNova for generally being cool (oh and maybe working on a SMBX38A version of this, too)

]]

local ai = require("scripts/powerups/ap_cape_ai")
local extrasounds = require("extrasounds")
local smasfunctions = require("smasfunctions")

local apt = {}

apt.spritesheets = {
    Img.loadCharacter("mario-8.png"),
    Img.loadCharacter("luigi-8.png"),
    Img.loadCharacter("peach-8.png"),
    Img.loadCharacter("toad-8.png"),
    Img.loadCharacter("link-8.png"),
}

apt.capeSpritesheets = {
    Img.loadCharacter("mario-8-cape.png"),
    Img.loadCharacter("luigi-8-cape.png"),
    Img.loadCharacter("peach-8-cape.png"),
    Img.loadCharacter("toad-8-cape.png"),
    Img.loadCharacter("link-8-cape.png"),
}

apt.apSounds = {
    upgrade = extrasounds.sound.sfx[133],
    reserve = 12
}

apt.items = {984}


apt.cheats = {"needacape","needafeather"}

ai.register(apt)


function apt.onEnable()
    ai.onEnable(apt)
end
function apt.onDisable()
    ai.onDisable(apt)
end

function apt.onTick()
    ai.onTick(apt)
end
function apt.onTickEnd()
    ai.onTickEnd(apt)
end
function apt.onDraw()
    ai.onDraw(apt)
end


return apt