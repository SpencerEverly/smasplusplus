local pm = require("playerManager")
local extrasounds = require("extrasounds")

local costume = {}

function costume.onInit(p)
    plr = p
    registerEvent(costume,"onInputUpdate")
    registerEvent(costume,"onTick")
    extrasounds.sound.sfx[1] = Audio.SfxOpen("costumes/link/Ness/player-jump.ogg")
    Audio.sounds[2].sfx  = Audio.SfxOpen("costumes/link/Ness/stomped.ogg")
    Audio.sounds[3].sfx  = Audio.SfxOpen("costumes/link/Ness/block-hit.ogg")
    --extrasounds.sound.sfx[4]  = Audio.SfxOpen("costumes/link/Ness/block-smash.ogg")
    Audio.sounds[5].sfx  = Audio.SfxOpen("costumes/link/Ness/player-shrink.ogg")
    Audio.sounds[6].sfx  = Audio.SfxOpen("costumes/link/Ness/player-grow.ogg")
    --extrasounds.sound.sfx[7]  = Audio.SfxOpen("costumes/link/Ness/mushroom.ogg")
    extrasounds.sound.sfx[8]  = Audio.SfxOpen("costumes/link/Ness/player-died.ogg")
    extrasounds.sound.sfx[14] = Audio.SfxOpen("costumes/link/Ness/coin.ogg")
    extrasounds.sound.sfx[15] = Audio.SfxOpen("costumes/link/Ness/1up.ogg")
    extrasounds.sound.sfx[18] = Audio.SfxOpen("costumes/link/Ness/fireball.ogg")
    Audio.sounds[46].sfx = Audio.SfxOpen("costumes/link/Ness/door.ogg")
    Audio.sounds[52].sfx = Audio.SfxOpen("costumes/link/Ness/got-star.ogg")
    Audio.sounds[54].sfx = Audio.SfxOpen("costumes/link/Ness/player-died2.ogg")
    Audio.sounds[77].sfx = Audio.SfxOpen("costumes/link/Ness/zelda-stab.ogg")
    Audio.sounds[78].sfx = Audio.SfxOpen("costumes/link/Ness/zelda-hurt.ogg")
    Audio.sounds[79].sfx = Audio.SfxOpen("costumes/link/Ness/zelda-heart.ogg")
    Audio.sounds[80].sfx = Audio.SfxOpen("costumes/link/Ness/zelda-died.ogg")
    Audio.sounds[81].sfx = Audio.SfxOpen("costumes/link/Ness/zelda-rupee.ogg")
    Audio.sounds[82].sfx = Audio.SfxOpen("costumes/link/Ness/zelda-fire.ogg")
    Audio.sounds[83].sfx = Audio.SfxOpen("costumes/link/Ness/zelda-item.ogg")
    Audio.sounds[84].sfx = Audio.SfxOpen("costumes/link/Ness/zelda-key.ogg")
    Audio.sounds[85].sfx = Audio.SfxOpen("costumes/link/Ness/zelda-shield.ogg")
    Audio.sounds[86].sfx = Audio.SfxOpen("costumes/link/Ness/zelda-dash.ogg")
    Audio.sounds[87].sfx = Audio.SfxOpen("costumes/link/Ness/zelda-fairy.ogg")
    Audio.sounds[88].sfx = Audio.SfxOpen("costumes/link/Ness/zelda-grass.ogg")
    Audio.sounds[89].sfx = Audio.SfxOpen("costumes/link/Ness/zelda-hit.ogg")
    Audio.sounds[90].sfx = Audio.SfxOpen("costumes/link/Ness/zelda-sword-beam.ogg")
    
    Defines.player_walkspeed = 4
    Defines.player_runspeed = 4
    Defines.jumpheight = 21
    Defines.jumpheight_bounce = 20
    Defines.projectilespeedx = 7.0
    Defines.player_grav = 0.41
    
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
    extrasounds.sound.sfx[4]  = Audio.SfxOpen(Misc.resolveSoundFile("block-smash"))
    Audio.sounds[5].sfx  = nil
    Audio.sounds[6].sfx  = nil
    extrasounds.sound.sfx[7]  = Audio.SfxOpen(Misc.resolveSoundFile("mushroom"))
    extrasounds.sound.sfx[8] = nil
    Audio.sounds[9].sfx  = nil
    extrasounds.sound.sfx[10] = nil
    Audio.sounds[11].sfx = nil
    Audio.sounds[12].sfx = nil
    Audio.sounds[13].sfx = nil
    extrasounds.sound.sfx[14] = Audio.SfxOpen(Misc.resolveSoundFile("coin"))
    extrasounds.sound.sfx[15] = Audio.SfxOpen(Misc.resolveSoundFile("1up"))
    Audio.sounds[16].sfx = nil
    Audio.sounds[17].sfx = nil
    extrasounds.sound.sfx[18] = Audio.SfxOpen(Misc.resolveSoundFile("fireball"))
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
    extrasounds.sound.sfx[43] = Audio.SfxOpen(Misc.resolveSoundFile("fireworks"))
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
    extrasounds.sound.sfx[59] = Audio.SfxOpen(Misc.resolveSoundFile("dragon-coin"))
    Audio.sounds[61].sfx = nil
    Audio.sounds[62].sfx = nil
    Audio.sounds[63].sfx = nil
    Audio.sounds[71].sfx = nil
    Audio.sounds[72].sfx = nil
    Audio.sounds[73].sfx = nil
    Audio.sounds[75].sfx = nil
    Audio.sounds[76].sfx = nil
    Audio.sounds[77].sfx = nil
    Audio.sounds[78].sfx = nil
    Audio.sounds[79].sfx = nil
    Audio.sounds[80].sfx = nil
    Audio.sounds[81].sfx = nil
    Audio.sounds[82].sfx = nil
    Audio.sounds[91].sfx = nil
    extrasounds.sound.sfx92 = Audio.SfxOpen(Misc.resolveSoundFile("sound/sprout-vine.ogg"))
    extrasounds.sound.sfx93 = Audio.SfxOpen(Misc.resolveSoundFile("sound/iceball.ogg"))
    extrasounds.sound.sfx94 = Audio.SfxOpen(Misc.resolveSoundFile("sound/yi-freeze.ogg"))
    extrasounds.sound.sfx95 = Audio.SfxOpen(Misc.resolveSoundFile("sound/yi-icebreak.ogg"))
    extrasounds.sound.sfx96 = Audio.SfxOpen(Misc.resolveSoundFile("sound/2up.ogg"))
    extrasounds.sound.sfx97 = Audio.SfxOpen(Misc.resolveSoundFile("sound/3up.ogg"))
    extrasounds.sound.sfx98 = Audio.SfxOpen(Misc.resolveSoundFile("sound/5up.ogg"))
    extrasounds.sound.sfx99 = Audio.SfxOpen(Misc.resolveSoundFile("sound/dragon-coin-get2.ogg"))
    extrasounds.sound.sfx100 = Audio.SfxOpen(Misc.resolveSoundFile("sound/dragon-coin-get3.ogg"))
    extrasounds.sound.sfx101 = Audio.SfxOpen(Misc.resolveSoundFile("sound/dragon-coin-get4.ogg"))
    extrasounds.sound.sfx102 = Audio.SfxOpen(Misc.resolveSoundFile("sound/dragon-coin-get5.ogg"))
    extrasounds.sound.sfx103 = Audio.SfxOpen(Misc.resolveSoundFile("sound/cherry.ogg"))
    extrasounds.sound.sfx104 = Audio.SfxOpen(Misc.resolveSoundFile("sound/explode.ogg")) --SMB2 Explosion
    extrasounds.sound.sfx105 = Audio.SfxOpen(Misc.resolveSoundFile("sound/hammerthrow.ogg")) --Player hammer throw
    extrasounds.sound.sfx106 = Audio.SfxOpen(Misc.resolveSoundFile("sound/combo1.ogg")) --Shell hit 2
    extrasounds.sound.sfx107 = Audio.SfxOpen(Misc.resolveSoundFile("sound/combo2.ogg")) --Shell hit 3
    extrasounds.sound.sfx108 = Audio.SfxOpen(Misc.resolveSoundFile("sound/combo3.ogg")) --Shell hit 4
    extrasounds.sound.sfx109 = Audio.SfxOpen(Misc.resolveSoundFile("sound/combo4.ogg")) --Shell hit 5
    extrasounds.sound.sfx110 = Audio.SfxOpen(Misc.resolveSoundFile("sound/combo5.ogg")) --Shell hit 6
    extrasounds.sound.sfx111 = Audio.SfxOpen(Misc.resolveSoundFile("sound/combo6.ogg")) --Shell hit 7
    extrasounds.sound.sfx112 = Audio.SfxOpen(Misc.resolveSoundFile("sound/combo7.ogg")) --Shell hit 8
    
    
    Defines.jumpheight = 20
    Defines.player_walkspeed = 3
    Defines.player_runspeed = 6
    Defines.jumpheight_bounce = 32
    Defines.projectilespeedx = 7.1
    Defines.player_grav = 0.4
end

return costume