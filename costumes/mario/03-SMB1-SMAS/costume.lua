local pm = require("playerManager")

local costume = {}

function costume.onInit(p)
    Graphics.sprites.hardcoded["48-0"].img = Graphics.loadImageResolved("graphics/customs/SNES/SMB1/ui/itembox.png")
    Graphics.sprites.hardcoded["48-1"].img = Graphics.loadImageResolved("graphics/customs/SNES/SMB1/ui/itembox.png")
    Graphics.sprites.hardcoded["33-0"].img = Graphics.loadImageResolved("graphics/customs/SNES/SMB1/ui/key.png")
    Graphics.sprites.hardcoded["33-1"].img = Graphics.loadImageResolved("graphics/customs/SNES/SMB1/ui/x.png")
    Graphics.sprites.hardcoded["33-2"].img = Graphics.loadImageResolved("graphics/customs/SNES/SMB1/ui/coin.png")
    Graphics.sprites.hardcoded["33-3"].img = Graphics.loadImageResolved("graphics/customs/SNES/SMB1/ui/1up.png")
    Graphics.sprites.hardcoded["33-5"].img = Graphics.loadImageResolved("graphics/customs/SNES/SMB1/ui/star.png")
    Graphics.sprites.hardcoded["33-6"].img = Graphics.loadImageResolved("graphics/customs/SNES/SMB1/ui/rupee.png")
    Graphics.sprites.hardcoded["33-7"].img = Graphics.loadImageResolved("graphics/customs/SNES/SMB1/ui/2up.png")
    Graphics.sprites.hardcoded["33-8"].img = Graphics.loadImageResolved("graphics/customs/SNES/SMB1/ui/bomb.png")
end

function costume.onCleanup(p)
    Graphics.sprites.hardcoded["48-0"].img = nil
    Graphics.sprites.hardcoded["48-1"].img = nil
    Graphics.sprites.hardcoded["33-0"].img = nil
    Graphics.sprites.hardcoded["33-1"].img = nil
    Graphics.sprites.hardcoded["33-2"].img = nil
    Graphics.sprites.hardcoded["33-3"].img = nil
    Graphics.sprites.hardcoded["33-5"].img = nil
    Graphics.sprites.hardcoded["33-6"].img = nil
    Graphics.sprites.hardcoded["33-7"].img = nil
    Graphics.sprites.hardcoded["33-8"].img = nil
end

Misc.storeLatestCostumeData(costume)

return costume