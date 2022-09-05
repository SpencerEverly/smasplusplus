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
    Img.loadCharacter("mario-cape.png"),
    Img.loadCharacter("luigi-cape.png"),
    Img.loadCharacter("peach-cape.png"),
    Img.loadCharacter("toad-cape.png"),
    Img.loadCharacter("link-cape.png"),
}

apt.capeSpritesheets = {
    Img.loadCharacter("mario-cape-cape.png"),
    Img.loadCharacter("luigi-cape-cape.png"),
    Img.loadCharacter("peach-cape-cape.png"),
    Img.loadCharacter("toad-cape-cape.png"),
    Img.loadCharacter("link-cape-cape.png"),
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