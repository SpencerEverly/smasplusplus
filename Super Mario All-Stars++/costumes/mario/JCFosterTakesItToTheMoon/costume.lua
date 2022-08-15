local pm = require("playerManager")
local extrasounds = require("extrasounds")

local costume = {}

function costume.onInit(p)
    extrasounds.sound.sfx[1] = Audio.SfxOpen("costumes/mario/JCFosterTakesItToTheMoon/player-jump.ogg")
    Audio.sounds[5].sfx  = Audio.SfxOpen("costumes/mario/JCFosterTakesItToTheMoon/player-shrink.ogg")
    Audio.sounds[6].sfx  = Audio.SfxOpen("costumes/mario/JCFosterTakesItToTheMoon/player-grow.ogg")
    extrasounds.sound.sfx[8]  = Audio.SfxOpen("costumes/mario/JCFosterTakesItToTheMoon/player-died.ogg")
    Audio.sounds[52].sfx = Audio.SfxOpen("costumes/mario/JCFosterTakesItToTheMoon/got-star.ogg")
    Audio.sounds[54].sfx = Audio.SfxOpen("costumes/mario/JCFosterTakesItToTheMoon/player-died2.ogg")
end

function costume.onCleanup(p)
    extrasounds.sound.sfx[1] = nil
    Audio.sounds[5].sfx  = nil
    Audio.sounds[6].sfx  = nil
    extrasounds.sound.sfx[8] = nil
    Audio.sounds[52].sfx = nil
    Audio.sounds[54].sfx = nil
end

return costume;