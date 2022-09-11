local pm = require("playerManager")
local extrasounds = require("extrasounds")

local costume = {}

function costume.onInit(p)
    plr = p
    registerEvent(costume,"onInputUpdate")
    extrasounds.sound.sfx[1] = Audio.SfxOpen("costumes/link/Takeshi-SNES/player-jump.ogg")
    Audio.sounds[2].sfx  = Audio.SfxOpen("costumes/link/Takeshi-SNES/stomped.ogg")
    Audio.sounds[6].sfx  = Audio.SfxOpen("costumes/link/Takeshi-SNES/player-grow.ogg")
    extrasounds.sound.sfx[8]  = Audio.SfxOpen("costumes/link/Takeshi-SNES/player-died.ogg")
    Audio.sounds[12].sfx = Audio.SfxOpen("costumes/link/Takeshi-SNES/has-item.ogg")
    extrasounds.sound.sfx[14] = Audio.SfxOpen("costumes/link/Takeshi-SNES/coin.ogg")
    Audio.sounds[29].sfx = Audio.SfxOpen("costumes/link/Takeshi-SNES/do.ogg")
    extrasounds.sound.sfx[43] = Audio.SfxOpen("costumes/link/Takeshi-SNES/fireworks.ogg")
    Audio.sounds[52].sfx = Audio.SfxOpen("costumes/link/Takeshi-SNES/got-star.ogg")
    Audio.sounds[54].sfx = Audio.SfxOpen("costumes/link/Takeshi-SNES/player-died2.ogg")
    extrasounds.sound.sfx[59]  = Audio.SfxOpen("costumes/link/Takeshi-SNES/dragon-coin.ogg")
    extrasounds.sound.sfx[77] = Audio.SfxOpen("costumes/link/Takeshi-SNES/zelda-stab.ogg")
    Audio.sounds[78].sfx = Audio.SfxOpen("costumes/link/Takeshi-SNES/zelda-hurt.ogg")
    Audio.sounds[79].sfx = Audio.SfxOpen("costumes/link/Takeshi-SNES/zelda-heart.ogg")
    Audio.sounds[80].sfx = Audio.SfxOpen("costumes/link/Takeshi-SNES/zelda-died.ogg")
    extrasounds.sound.sfx[81] = Audio.SfxOpen("costumes/link/Takeshi-SNES/zelda-rupee.ogg")
    Audio.sounds[83].sfx = Audio.SfxOpen("costumes/link/Takeshi-SNES/zelda-item.ogg")
    Audio.sounds[86].sfx = Audio.SfxOpen("costumes/link/Takeshi-SNES/zelda-dash.ogg")
    Audio.sounds[87].sfx = Audio.SfxOpen("costumes/link/Takeshi-SNES/zelda-fairy.ogg")
    Audio.sounds[89].sfx = Audio.SfxOpen("costumes/link/Takeshi-SNES/zelda-hit.ogg")
    
    Defines.player_walkspeed = 3
    Defines.player_runspeed = 3
    Defines.jumpheight = 17
    Defines.jumpheight_bounce = 27
    Defines.projectilespeedx = 7.0
    Defines.player_grav = 0.3
    
    costume.abilitesenabled = true
end

function costume.onInputUpdate()
    if SaveData.toggleCostumeAbilities == true then
        if player.keys.run == KEYS_DOWN then
            plr:mem(0x168, FIELD_FLOAT, 10)
        else
            plr:mem(0x168, FIELD_FLOAT, 0)
        end
    end
end

function costume.onCleanup(p)
    extrasounds.sound.sfx[1] = nil    
    Audio.sounds[2].sfx  = nil
    Audio.sounds[3].sfx  = nil
    extrasounds.sound.sfx[4] = nil
    Audio.sounds[5].sfx  = nil
    Audio.sounds[6].sfx  = nil
    extrasounds.sound.sfx[7] = nil
    extrasounds.sound.sfx[8] = nil
    Audio.sounds[9].sfx  = nil
    extrasounds.sound.sfx[10] = nil
    Audio.sounds[11].sfx = nil
    Audio.sounds[12].sfx = nil
    Audio.sounds[13].sfx = nil
    extrasounds.sound.sfx[14] = nil
    extrasounds.sound.sfx[15] = nil
    Audio.sounds[16].sfx = nil
    Audio.sounds[17].sfx = nil
    extrasounds.sound.sfx[18] = nil
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
    extrasounds.sound.sfx[59] = nil
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
    Audio.sounds[83].sfx = nil
    Audio.sounds[84].sfx = nil
    Audio.sounds[85].sfx = nil
    Audio.sounds[86].sfx = nil
    Audio.sounds[87].sfx = nil
    Audio.sounds[88].sfx = nil
    Audio.sounds[89].sfx = nil
    Audio.sounds[90].sfx = nil
    Audio.sounds[91].sfx = nil
    extrasounds.sound.sfx[92] = nil
    extrasounds.sound.sfx[93] = nil
    extrasounds.sound.sfx[94] = nil
    extrasounds.sound.sfx[95] = nil
    extrasounds.sound.sfx[96] = nil
    extrasounds.sound.sfx[97] = nil
    extrasounds.sound.sfx[98] = nil
    extrasounds.sound.sfx[99] = nil
    extrasounds.sound.sfx[100] = nil
    extrasounds.sound.sfx[101] = nil
    extrasounds.sound.sfx[102] = nil
    extrasounds.sound.sfx[103] = nil
    extrasounds.sound.sfx[104] = nil
    extrasounds.sound.sfx[105] = nil
    extrasounds.sound.sfx[106] = nil
    extrasounds.sound.sfx[107] = nil
    extrasounds.sound.sfx[108] = nil
    extrasounds.sound.sfx[109] = nil
    extrasounds.sound.sfx[110] = nil
    extrasounds.sound.sfx[111] = nil
    extrasounds.sound.sfx[112] = nil
    
    Defines.jumpheight = 20
    Defines.player_walkspeed = 3
    Defines.player_runspeed = 6
    Defines.jumpheight_bounce = 32
    Defines.projectilespeedx = 7.1
    Defines.player_grav = 0.4
end

return costume