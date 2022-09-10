local pm = require("playerManager")
local extrasounds = require("extrasounds")

local costume = {}

local eventsRegistered = false

function costume.onInit(p)
    registerEvent(costume,"onDraw")
    extrasounds.sound.sfx[1] = Audio.SfxOpen("costumes/peach/A2XT-Kood/player-jump.ogg")
    Audio.sounds[2].sfx  = Audio.SfxOpen("costumes/peach/A2XT-Kood/stomped.ogg")
    Audio.sounds[3].sfx  = Audio.SfxOpen("costumes/peach/A2XT-Kood/block-hit.ogg")
    extrasounds.sound.sfx[4]  = Audio.SfxOpen("costumes/peach/A2XT-Kood/block-smash.ogg")
    Audio.sounds[5].sfx  = Audio.SfxOpen("costumes/peach/A2XT-Kood/player-shrink.ogg")
    Audio.sounds[6].sfx  = Audio.SfxOpen("costumes/peach/A2XT-Kood/player-grow.ogg")
    extrasounds.sound.sfx[7]  = Audio.SfxOpen("costumes/peach/A2XT-Kood/mushroom.ogg")
    extrasounds.sound.sfx[8]  = Audio.SfxOpen("costumes/peach/A2XT-Kood/player-died.ogg")
    Audio.sounds[9].sfx  = Audio.SfxOpen("costumes/peach/A2XT-Kood/shell-hit.ogg")
    extrasounds.sound.sfx[10] = Audio.SfxOpen("costumes/peach/A2XT-Kood/player-slide.ogg")
    Audio.sounds[11].sfx = Audio.SfxOpen("costumes/peach/A2XT-Kood/item-dropped.ogg")
    Audio.sounds[12].sfx = Audio.SfxOpen("costumes/peach/A2XT-Kood/has-item.ogg")
    Audio.sounds[13].sfx = Audio.SfxOpen("costumes/peach/A2XT-Kood/camera-change.ogg")
    extrasounds.sound.sfx[14] = Audio.SfxOpen("costumes/peach/A2XT-Kood/coin.ogg")
    extrasounds.sound.sfx[15] = Audio.SfxOpen("costumes/peach/A2XT-Kood/1up.ogg")
    Audio.sounds[16].sfx = Audio.SfxOpen("costumes/peach/A2XT-Kood/lava.ogg")
    Audio.sounds[17].sfx = Audio.SfxOpen("costumes/peach/A2XT-Kood/warp.ogg")
    extrasounds.sound.sfx[18] = Audio.SfxOpen("costumes/peach/A2XT-Kood/fireball.ogg")
    Audio.sounds[19].sfx = Audio.SfxOpen("costumes/peach/A2XT-Kood/level-win.ogg")
    Audio.sounds[20].sfx = Audio.SfxOpen("costumes/peach/A2XT-Kood/boss-beat.ogg")
    Audio.sounds[21].sfx = Audio.SfxOpen("costumes/peach/A2XT-Kood/dungeon-win.ogg")
    Audio.sounds[22].sfx = Audio.SfxOpen("costumes/peach/A2XT-Kood/bullet-bill.ogg")
    Audio.sounds[23].sfx = Audio.SfxOpen("costumes/peach/A2XT-Kood/grab.ogg")
    Audio.sounds[24].sfx = Audio.SfxOpen("costumes/peach/A2XT-Kood/spring.ogg")
    Audio.sounds[25].sfx = Audio.SfxOpen("costumes/peach/A2XT-Kood/hammer.ogg")
    Audio.sounds[29].sfx = Audio.SfxOpen("costumes/peach/A2XT-Kood/do.ogg")
    Audio.sounds[31].sfx = Audio.SfxOpen("costumes/peach/A2XT-Kood/key.ogg")
    Audio.sounds[32].sfx = Audio.SfxOpen("costumes/peach/A2XT-Kood/pswitch.ogg")
    extrasounds.sound.sfx[33] = Audio.SfxOpen("costumes/peach/A2XT-Kood/tail.ogg")
    Audio.sounds[34].sfx = Audio.SfxOpen("costumes/peach/A2XT-Kood/racoon.ogg")
    Audio.sounds[35].sfx = Audio.SfxOpen("costumes/peach/A2XT-Kood/boot.ogg")
    extrasounds.sound.sfx[36] = Audio.SfxOpen(Misc.resolveSoundFile("costumes/peach/A2XT-Kood/smash.ogg"))
    Audio.sounds[37].sfx = Audio.SfxOpen("costumes/peach/A2XT-Kood/thwomp.ogg")
    extrasounds.sound.sfx[42] = Audio.SfxOpen(Misc.resolveSoundFile("costumes/peach/A2XT-Kood/npc-fireball.ogg"))
    extrasounds.sound.sfx[43] = Audio.SfxOpen("costumes/peach/A2XT-Kood/fireworks.ogg")
    Audio.sounds[44].sfx = Audio.SfxOpen("costumes/peach/A2XT-Kood/bowser-killed.ogg")
    Audio.sounds[46].sfx = Audio.SfxOpen("costumes/peach/A2XT-Kood/door.ogg")
    Audio.sounds[48].sfx = Audio.SfxOpen("costumes/peach/A2XT-Kood/yoshi.ogg")
    Audio.sounds[49].sfx = Audio.SfxOpen("costumes/peach/A2XT-Kood/yoshi-hurt.ogg")
    Audio.sounds[50].sfx = Audio.SfxOpen("costumes/peach/A2XT-Kood/yoshi-tongue.ogg")
    Audio.sounds[51].sfx = Audio.SfxOpen("costumes/peach/A2XT-Kood/yoshi-egg.ogg")
    Audio.sounds[52].sfx = Audio.SfxOpen("costumes/peach/A2XT-Kood/got-star.ogg")
    Audio.sounds[54].sfx = Audio.SfxOpen("costumes/peach/A2XT-Kood/player-died2.ogg")
    Audio.sounds[55].sfx = Audio.SfxOpen("costumes/peach/A2XT-Kood/yoshi-swallow.ogg")
    Audio.sounds[57].sfx = Audio.SfxOpen("costumes/peach/A2XT-Kood/dry-bones.ogg")
    Audio.sounds[58].sfx = Audio.SfxOpen("costumes/peach/A2XT-Kood/smw-checkpoint.ogg")
    extrasounds.sound.sfx[59] = Audio.SfxOpen("costumes/peach/A2XT-Kood/dragon-coin.ogg")
    Audio.sounds[61].sfx = Audio.SfxOpen("costumes/peach/A2XT-Kood/smw-blaarg.ogg")
    Audio.sounds[62].sfx = Audio.SfxOpen("costumes/peach/A2XT-Kood/wart-bubble.ogg")
    Audio.sounds[63].sfx = Audio.SfxOpen("costumes/peach/A2XT-Kood/wart-die.ogg")
    Audio.sounds[71].sfx = Audio.SfxOpen("costumes/peach/A2XT-Kood/climbing.ogg")
    Audio.sounds[72].sfx = Audio.SfxOpen("costumes/peach/A2XT-Kood/swim.ogg")
    Audio.sounds[73].sfx = Audio.SfxOpen("costumes/peach/A2XT-Kood/grab2.ogg")
    --Audio.sounds[74].sfx = Audio.SfxOpen("costumes/peach/A2XT-Kood/saw.ogg")
    Audio.sounds[75].sfx = Audio.SfxOpen("costumes/peach/A2XT-Kood/smb2-throw.ogg")
    Audio.sounds[76].sfx = Audio.SfxOpen("costumes/peach/A2XT-Kood/smb2-hit.ogg")
    Audio.sounds[91].sfx = Audio.SfxOpen("costumes/peach/A2XT-Kood/bubble.ogg")
    
    eventsRegistered = true
end

function costume.onDraw()
    for _,v in ipairs(Animation.get(129)) do
        v.width = 26;
        v.height = 44;
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
    extrasounds.sound.sfx[81] = nil
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
end

return costume