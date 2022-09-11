local pm = require("playerManager")
local extrasounds = require("extrasounds")

local costume = {}

function costume.onInit(p)
    extrasounds.sound.sfx[1] = Audio.SfxOpen("costumes/mario/06-SMB3-Retro/player-jump.ogg")
    Audio.sounds[2].sfx  = Audio.SfxOpen("costumes/mario/06-SMB3-Retro/stomped.ogg")
    Audio.sounds[3].sfx  = Audio.SfxOpen("costumes/mario/06-SMB3-Retro/block-hit.ogg")
    extrasounds.sound.sfx[4]  = Audio.SfxOpen("costumes/mario/06-SMB3-Retro/block-smash.ogg")
    Audio.sounds[5].sfx  = Audio.SfxOpen("costumes/mario/06-SMB3-Retro/player-shrink.ogg")
    Audio.sounds[6].sfx  = Audio.SfxOpen("costumes/mario/06-SMB3-Retro/player-grow.ogg")
    extrasounds.sound.sfx[7]  = Audio.SfxOpen("costumes/mario/06-SMB3-Retro/mushroom.ogg")
    extrasounds.sound.sfx[8]  = Audio.SfxOpen("costumes/mario/06-SMB3-Retro/player-died.ogg")
    Audio.sounds[9].sfx  = Audio.SfxOpen("costumes/mario/06-SMB3-Retro/shell-hit.ogg")
    extrasounds.sound.sfx[10] = Audio.SfxOpen("costumes/mario/06-SMB3-Retro/player-slide.ogg")
    Audio.sounds[11].sfx = Audio.SfxOpen("costumes/mario/06-SMB3-Retro/item-dropped.ogg")
    Audio.sounds[12].sfx = Audio.SfxOpen("costumes/mario/06-SMB3-Retro/has-item.ogg")
    Audio.sounds[13].sfx = Audio.SfxOpen("costumes/mario/06-SMB3-Retro/camera-change.ogg")
    extrasounds.sound.sfx[14] = Audio.SfxOpen("costumes/mario/06-SMB3-Retro/coin.ogg")
    extrasounds.sound.sfx[15] = Audio.SfxOpen("costumes/mario/06-SMB3-Retro/1up.ogg")
    Audio.sounds[16].sfx = Audio.SfxOpen("costumes/mario/06-SMB3-Retro/lava.ogg")
    Audio.sounds[17].sfx = Audio.SfxOpen("costumes/mario/06-SMB3-Retro/warp.ogg")
    extrasounds.sound.sfx[18] = Audio.SfxOpen("costumes/mario/06-SMB3-Retro/fireball.ogg")
    Audio.sounds[19].sfx = Audio.SfxOpen("costumes/mario/06-SMB3-Retro/level-win.ogg")
    Audio.sounds[20].sfx = Audio.SfxOpen("costumes/mario/06-SMB3-Retro/boss-beat.ogg")
    Audio.sounds[21].sfx = Audio.SfxOpen("costumes/mario/06-SMB3-Retro/dungeon-win.ogg")
    Audio.sounds[22].sfx = Audio.SfxOpen("costumes/mario/06-SMB3-Retro/bullet-bill.ogg")
    Audio.sounds[23].sfx = Audio.SfxOpen("costumes/mario/06-SMB3-Retro/grab.ogg")
    Audio.sounds[24].sfx = Audio.SfxOpen("costumes/mario/06-SMB3-Retro/spring.ogg")
    Audio.sounds[25].sfx = Audio.SfxOpen("costumes/mario/06-SMB3-Retro/hammer.ogg")
    Audio.sounds[29].sfx = Audio.SfxOpen("costumes/mario/06-SMB3-Retro/do.ogg")
    Audio.sounds[31].sfx = Audio.SfxOpen("costumes/mario/06-SMB3-Retro/key.ogg")
    Audio.sounds[32].sfx = Audio.SfxOpen("costumes/mario/06-SMB3-Retro/pswitch.ogg")
    extrasounds.sound.sfx[33] = Audio.SfxOpen("costumes/mario/06-SMB3-Retro/tail.ogg")
    Audio.sounds[34].sfx = Audio.SfxOpen("costumes/mario/06-SMB3-Retro/racoon.ogg")
    Audio.sounds[35].sfx = Audio.SfxOpen("costumes/mario/06-SMB3-Retro/boot.ogg")
    extrasounds.sound.sfx[36] = Audio.SfxOpen(Misc.resolveSoundFile("costumes/mario/06-SMB3-Retro/smash.ogg"))
    Audio.sounds[37].sfx = Audio.SfxOpen("costumes/mario/06-SMB3-Retro/thwomp.ogg")
    Audio.sounds[38].sfx = Audio.SfxOpen("costumes/mario/06-SMB3-Retro/birdo-spit.ogg")
    extrasounds.sound.sfx[39] = Audio.SfxOpen(Misc.resolveSoundFile("costumes/mario/06-SMB3-Retro/birdo-hit.ogg"))
    Audio.sounds[41].sfx = Audio.SfxOpen("costumes/mario/06-SMB3-Retro/birdo-beat.ogg")
    extrasounds.sound.sfx[42] = Audio.SfxOpen(Misc.resolveSoundFile("costumes/mario/06-SMB3-Retro/npc-fireball.ogg"))
    extrasounds.sound.sfx[43] = Audio.SfxOpen("costumes/mario/06-SMB3-Retro/fireworks.ogg")
    Audio.sounds[44].sfx = Audio.SfxOpen("costumes/mario/06-SMB3-Retro/bowser-killed.ogg")
    Audio.sounds[46].sfx = Audio.SfxOpen("costumes/mario/06-SMB3-Retro/door.ogg")
    Audio.sounds[47].sfx = Audio.SfxOpen("costumes/mario/06-SMB3-Retro/message.ogg")
    Audio.sounds[48].sfx = Audio.SfxOpen("costumes/mario/06-SMB3-Retro/yoshi.ogg")
    Audio.sounds[49].sfx = Audio.SfxOpen("costumes/mario/06-SMB3-Retro/yoshi-hurt.ogg")
    Audio.sounds[50].sfx = Audio.SfxOpen("costumes/mario/06-SMB3-Retro/yoshi-tongue.ogg")
    Audio.sounds[51].sfx = Audio.SfxOpen("costumes/mario/06-SMB3-Retro/yoshi-egg.ogg")
    Audio.sounds[52].sfx = Audio.SfxOpen("costumes/mario/06-SMB3-Retro/got-star.ogg")
    Audio.sounds[54].sfx = Audio.SfxOpen("costumes/mario/06-SMB3-Retro/player-died2.ogg")
    Audio.sounds[55].sfx = Audio.SfxOpen("costumes/mario/06-SMB3-Retro/yoshi-swallow.ogg")
    Audio.sounds[57].sfx = Audio.SfxOpen("costumes/mario/06-SMB3-Retro/dry-bones.ogg")
    Audio.sounds[58].sfx = Audio.SfxOpen("costumes/mario/06-SMB3-Retro/smw-checkpoint.ogg")
    extrasounds.sound.sfx[59] = Audio.SfxOpen("costumes/mario/06-SMB3-Retro/dragon-coin.ogg")
    Audio.sounds[61].sfx = Audio.SfxOpen("costumes/mario/06-SMB3-Retro/smw-blaarg.ogg")
    Audio.sounds[62].sfx = Audio.SfxOpen("costumes/mario/06-SMB3-Retro/wart-bubble.ogg")
    Audio.sounds[63].sfx = Audio.SfxOpen("costumes/mario/06-SMB3-Retro/wart-die.ogg")
    Audio.sounds[71].sfx = Audio.SfxOpen("costumes/mario/06-SMB3-Retro/climbing.ogg")
    Audio.sounds[72].sfx = Audio.SfxOpen("costumes/mario/06-SMB3-Retro/swim.ogg")
    Audio.sounds[73].sfx = Audio.SfxOpen("costumes/mario/06-SMB3-Retro/grab2.ogg")
    --Audio.sounds[74].sfx = Audio.SfxOpen("costumes/mario/06-SMB3-Retro/saw.ogg")
    Audio.sounds[75].sfx = Audio.SfxOpen("costumes/mario/06-SMB3-Retro/smb2-throw.ogg")
    Audio.sounds[76].sfx = Audio.SfxOpen("costumes/mario/06-SMB3-Retro/smb2-hit.ogg")
    Audio.sounds[91].sfx = Audio.SfxOpen("costumes/mario/06-SMB3-Retro/bubble.ogg")
end

function costume.onCleanup(p)
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
end

return costume