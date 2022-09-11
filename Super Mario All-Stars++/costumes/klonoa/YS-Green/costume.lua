local costume = {}
local klonoa = API.load("klonoaa");
local colliders = require("colliders")
local playerManager = require("playerManager");
local extrasounds = require("extrasounds")

function costume.onInit()
    registerEvent(costume, "onDraw");
    registerEvent(costume, "onTick");
    klonoa.flapAnimSpeed=3;
    ringbox = colliders.Box(0, 0, 32, 32);
    extrasounds.sound.sfx[1] = Audio.SfxOpen("costumes/klonoa/YS-Green/player-jump.ogg")
    extrasounds.sound.sfx[8]  = Audio.SfxOpen(Misc.resolveSoundFile("costumes/klonoa/YS-Green/player-died.ogg"))
    Audio.sounds[52].sfx = Audio.SfxOpen("costumes/klonoa/YS-Green/got-star.ogg")
    Audio.sounds[54].sfx = Audio.SfxOpen("costumes/klonoa/YS-Green/player-died2.ogg")
end

function costume.onTick()
    ringbox.y = player.y + 0;
end

function costume.onDraw()
    for _,v in ipairs(Animation.get(152)) do
        v.height = 64;
    end
    
    if(player.holdingNPC) then
        player.holdingNPC.x = player.x-65536;
        player.holdingNPC.y = player.y-65536;
    end
end

function costume.onCleanup(playerObject)
    extrasounds.sound.sfx[1] = nil    
    Audio.sounds[2].sfx  = nil
    Audio.sounds[3].sfx  = nil
    Audio.sounds[4].sfx  = nil
    Audio.sounds[5].sfx  = nil
    Audio.sounds[6].sfx  = nil
    Audio.sounds[7].sfx  = nil
    extrasounds.sound.sfx[8] = nil
    Audio.sounds[9].sfx  = nil
    extrasounds.sound.sfx[10] = nil
    Audio.sounds[11].sfx = nil
    Audio.sounds[12].sfx = nil
    Audio.sounds[13].sfx = nil
    Audio.sounds[14].sfx = nil
    Audio.sounds[15].sfx = nil
    Audio.sounds[16].sfx = nil
    Audio.sounds[17].sfx = nil
    Audio.sounds[18].sfx = nil
    Audio.sounds[19].sfx = nil
    Audio.sounds[20].sfx = nil
    Audio.sounds[21].sfx = nil
    Audio.sounds[22].sfx = nil
    Audio.sounds[23].sfx = nil
    Audio.sounds[24].sfx = nil
    Audio.sounds[25].sfx = nil
    Audio.sounds[29].sfx = nil
    Audio.sounds[31].sfx = nil
    Audio.sounds[32].sfx = nil
    extrasounds.sound.sfx[33] = nil
    Audio.sounds[34].sfx = nil
    Audio.sounds[35].sfx = nil
    extrasounds.sound.sfx[36] = nil
    Audio.sounds[37].sfx = nil
    Audio.sounds[38].sfx = nil
    extrasounds.sound.sfx[39] = nil
    Audio.sounds[41].sfx = nil
    extrasounds.sound.sfx[42] = nil
    extrasounds.sound.sfx[43] = nil
    Audio.sounds[44].sfx = nil
    Audio.sounds[46].sfx = nil
    Audio.sounds[47].sfx = nil
    Audio.sounds[48].sfx = nil
    Audio.sounds[49].sfx = nil
    Audio.sounds[50].sfx = nil
    Audio.sounds[51].sfx = nil
    Audio.sounds[52].sfx = nil
    Audio.sounds[54].sfx = nil
    Audio.sounds[55].sfx = nil
    Audio.sounds[56].sfx = nil
    Audio.sounds[57].sfx = nil
    Audio.sounds[58].sfx = nil
    Audio.sounds[59].sfx = nil
    Audio.sounds[61].sfx = nil
    Audio.sounds[62].sfx = nil
    Audio.sounds[63].sfx = nil
    Audio.sounds[71].sfx = nil
    Audio.sounds[72].sfx = nil
    Audio.sounds[73].sfx = nil
    Audio.sounds[75].sfx = nil
    Audio.sounds[76].sfx = nil
    extrasounds.sound.sfx[77] = nil
    Audio.sounds[78].sfx = nil
    Audio.sounds[79].sfx = nil
    Audio.sounds[80].sfx = nil
    extrasounds.sound.sfx[81] = nil
    Audio.sounds[82].sfx = nil
    Audio.sounds[91].sfx = nil
    klonoa.flapAnimSpeed = 6;
    ringbox = colliders.Box(0, 0, 32, 32);
    ringbox.y = player.y + 16
end

return costume;