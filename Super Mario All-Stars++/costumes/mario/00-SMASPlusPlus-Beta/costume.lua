local pm = require("playerManager")
local extrasounds = require("extrasounds")
local smasfunctions = require("smasfunctions")

local costume = {}

costume.loadedSounds = false
costume.loadedGraphics = false

function costume.onInit(p)
    if not costume.loadedGraphics then
        Graphics.sprites.bgo[48].img = Graphics.loadImageResolved("costumes/mario/00-SMASPlusPlus-Beta/smb1flagbeta.png")
        Graphics.sprites.bgo[57].img = Graphics.loadImageResolved("costumes/mario/00-SMASPlusPlus-Beta/smb1flaglinebeta.png")
        Graphics.sprites.block[207].img = Graphics.loadImageResolved("costumes/mario/00-SMASPlusPlus-Beta/smb2underbeta.png")
        Graphics.sprites.block[201].img = Graphics.loadImageResolved("costumes/mario/00-SMASPlusPlus-Beta/smb2underbeta.png")
        Graphics.sprites.block[208].img = Graphics.loadImageResolved("costumes/mario/00-SMASPlusPlus-Beta/smb2underbeta.png")
        Graphics.sprites.block[203].img = Graphics.loadImageResolved("costumes/mario/00-SMASPlusPlus-Beta/smb2underbeta.png")
        Graphics.sprites.block[205].img = Graphics.loadImageResolved("costumes/mario/00-SMASPlusPlus-Beta/smb2underbeta.png")
        Graphics.sprites.block[204].img = Graphics.loadImageResolved("costumes/mario/00-SMASPlusPlus-Beta/smb2underbeta.png")
        Graphics.sprites.block[214].img = Graphics.loadImageResolved("costumes/mario/00-SMASPlusPlus-Beta/smb2underbeta.png")
        Graphics.sprites.block[213].img = Graphics.loadImageResolved("costumes/mario/00-SMASPlusPlus-Beta/smb2underbeta.png")
        Graphics.sprites.block[215].img = Graphics.loadImageResolved("costumes/mario/00-SMASPlusPlus-Beta/smb2underbeta.png")
        Graphics.sprites.block[1223].img = Graphics.loadImageResolved("costumes/mario/00-SMASPlusPlus-Beta/smb2underbeta-2x1.png")
        Graphics.sprites.block[1222].img = Graphics.loadImageResolved("costumes/mario/00-SMASPlusPlus-Beta/smb2underbeta-2x1.png")
        Graphics.sprites.block[211].img = Graphics.loadImageResolved("costumes/mario/00-SMASPlusPlus-Beta/smb2underbeta-1x2.png")
        Graphics.sprites.block[212].img = Graphics.loadImageResolved("costumes/mario/00-SMASPlusPlus-Beta/smb2underbeta-1x2.png")
        Graphics.sprites.block[206].img = Graphics.loadImageResolved("costumes/mario/00-SMASPlusPlus-Beta/smb2underbeta-2x2.png")
        Graphics.sprites.block[216].img = Graphics.loadImageResolved("costumes/mario/00-SMASPlusPlus-Beta/smb2underbeta.png")
        Graphics.sprites.block[1220].img = Graphics.loadImageResolved("costumes/mario/00-SMASPlusPlus-Beta/smb2underbeta.png")
        Graphics.sprites.block[1221].img = Graphics.loadImageResolved("costumes/mario/00-SMASPlusPlus-Beta/smb2underbeta.png")
        Graphics.sprites.npc[14].img = Graphics.loadImageResolved("costumes/mario/00-SMASPlusPlus-Beta/fireflowerbeta.png")
        costume.loadedGraphics = true
    end
    if not costume.loadedSounds then
        Sound.loadCostumeSounds()
        costume.loadedSounds = true
    end
end

function costume.onCleanup(p)
    for i = 1,91 do
        Audio.sounds[i].sfx = nil
    end
    for i = 1,165 do
        extrasounds.sound.sfx[i] = nil
    end
    Graphics.sprites.bgo[48].img = nil
    Graphics.sprites.bgo[57].img = nil
    Graphics.sprites.block[207].img = nil
    Graphics.sprites.block[201].img = nil
    Graphics.sprites.block[208].img = nil
    Graphics.sprites.block[203].img = nil
    Graphics.sprites.block[205].img = nil
    Graphics.sprites.block[204].img = nil
    Graphics.sprites.block[214].img = nil
    Graphics.sprites.block[213].img = nil
    Graphics.sprites.block[215].img = nil
    Graphics.sprites.block[1223].img = nil
    Graphics.sprites.block[1222].img = nil
    Graphics.sprites.block[211].img = nil
    Graphics.sprites.block[212].img = nil
    Graphics.sprites.block[206].img = nil
    Graphics.sprites.block[216].img = nil
    Graphics.sprites.block[1220].img = nil
    Graphics.sprites.block[1221].img = nil
    Graphics.sprites.npc[14].img = nil
end

return costume;