local pm = require("playerManager")
local extrasounds = require("extrasounds")
local smashud = require("smashud")

local costume = {}

function costume.onInit(p)
    registerEvent(costume,"onTick")
    registerEvent(costume,"onPostPlayerHarm")
    registerEvent(costume,"onPostNPCKill")
    extrasounds.sound.sfx[1] = Audio.SfxOpen("costumes/mario/GA-Caillou/player-jump.ogg")
    Audio.sounds[2].sfx  = Audio.SfxOpen("costumes/mario/GA-Caillou/stomped.ogg")
    Audio.sounds[5].sfx  = Audio.SfxOpen("costumes/mario/GA-Caillou/player-shrink.ogg")
    Audio.sounds[6].sfx  = Audio.SfxOpen("costumes/mario/GA-Caillou/player-grow.ogg")
    extrasounds.sound.sfx[8]  = Audio.SfxOpen("costumes/mario/GA-Caillou/player-died.ogg")
    Audio.sounds[10].sfx  = Audio.SfxOpen("costumes/mario/GA-Caillou/player-slide.ogg")
    extrasounds.sound.sfx[14]  = Audio.SfxOpen(Misc.resolveSoundFile("costumes/mario/GA-Caillou/coin.ogg"))
    extrasounds.sound.sfx[18]  = Audio.SfxOpen(Misc.resolveSoundFile("costumes/mario/GA-Caillou/fireball.ogg"))
    Audio.sounds[21].sfx  = Audio.SfxOpen("costumes/mario/GA-Caillou/dungeon-win.ogg")
    Audio.sounds[23].sfx = Audio.SfxOpen("costumes/mario/GA-Caillou/grab.ogg")
    extrasounds.sound.sfx[33] = Audio.SfxOpen("costumes/mario/GA-Caillou/tail.ogg")
    Audio.sounds[34].sfx = Audio.SfxOpen("costumes/mario/GA-Caillou/racoon.ogg")
    extrasounds.sound.sfx[43] = Audio.SfxOpen("costumes/mario/GA-Caillou/fireworks.ogg")
    Audio.sounds[52].sfx = Audio.SfxOpen("costumes/mario/GA-Caillou/got-star.ogg")
    Audio.sounds[54].sfx = Audio.SfxOpen("costumes/mario/GA-Caillou/player-died2.ogg")
    Audio.sounds[73].sfx = Audio.SfxOpen("costumes/mario/GA-Caillou/grab2.ogg")
    Audio.sounds[75].sfx = Audio.SfxOpen("costumes/mario/GA-Caillou/smb2-throw.ogg")
    Defines.jumpheight = 19
    Defines.player_walkspeed = 2.6
    Defines.player_runspeed = 6.3
    Defines.jumpheight_bounce = 29.5
    Defines.player_grav = 0.42
end

function costume.onPostNPCKill(npc, harmType)
    local items = table.map{9,184,185,249,14,182,183,277,264,996,994}
    local healitems = table.map{9,184,185,249,14,182,183,34,169,170,277,264}
    local specialitems = table.map{34,169,170}
    local rngkey
    if items[npc.id] and Colliders.collide(player, npc) then
        Sound.playSFX("mario/GA-Caillou/voices/kayloo-timetodieenemies.ogg", 1, 1, 80)
    end
    if specialitems[npc.id] and Colliders.collide(player, npc) then
        Sound.playSFX("mario/GA-Caillou/voices/kayloo-aspecialitem.ogg", 1, 1, 80)
    end
end

function costume.onPostPlayerHarm()
    --Sound.playSFX("mario/GA-Caillou/voices/kayloo-owthathurt.ogg")
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
    Defines.jumpheight = 20
    Defines.player_walkspeed = 3
    Defines.player_runspeed = 6
    Defines.jumpheight_bounce = 32
    Defines.player_grav = 0.4
end

return costume