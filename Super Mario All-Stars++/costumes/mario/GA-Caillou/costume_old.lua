local pm = require("playerManager")
local animatx = require("animatx2_xmas2020")
local actorsys = require("a2xt_actor")
local ep3Playables = require("a2xt_ep3playables")

local costume = {
    baseCharID = CHARACTER_MARIO,
    name = "Caillou",
    index = "ga-caillou",
    path = "costumes/mario/GA-Caillou",

    namespace = ACTOR_KAYLOO,
    keepPowerupOnHit = true,
    scaledisabled = true,
    spintrailenabled = false
}

costume.playerData = {}
costume.playersList = {}

local players = {}

function costume.onInit(playerObj)
    registerEvent(costume,"onTick")
    Defines.jumpheight = 19
    Defines.player_walkspeed = 2.6
    Defines.player_runspeed = 6.3
    Defines.jumpheight_bounce = 29.5
    Defines.player_grav = 0.42
    players[playerObj] = ep3Playables.register(playerObj, costume, 
    inputEvent, animEvent, drawEndEvent);
    ready = true
end

function costume.onTick()
    extrasounds.sound.sfx[1] = Audio.SfxOpen("costumes/mario/GA-Caillou/player-jump.ogg")
    Audio.sounds[2].sfx  = Audio.SfxOpen("costumes/mario/GA-Caillou/stomped.ogg")
    Audio.sounds[5].sfx  = Audio.SfxOpen("costumes/mario/GA-Caillou/player-shrink.ogg")
    Audio.sounds[6].sfx  = Audio.SfxOpen("costumes/mario/GA-Caillou/player-grow.ogg")
    extrasounds.sound.sfx[8]  = Audio.SfxOpen("costumes/mario/GA-Caillou/player-died.ogg")
    Audio.sounds[10].sfx  = Audio.SfxOpen("costumes/mario/GA-Caillou/player-slide.ogg")
    Audio.sounds[14].sfx  = Audio.SfxOpen("costumes/mario/GA-Caillou/coin.ogg")
    Audio.sounds[18].sfx  = Audio.SfxOpen("costumes/mario/GA-Caillou/fireball.ogg")
    Audio.sounds[21].sfx  = Audio.SfxOpen("costumes/mario/GA-Caillou/dungeon-win.ogg")
    Audio.sounds[23].sfx = Audio.SfxOpen("costumes/mario/GA-Caillou/grab.ogg")
    extrasounds.sound.sfx[33] = Audio.SfxOpen("costumes/mario/GA-Caillou/tail.ogg")
    Audio.sounds[34].sfx = Audio.SfxOpen("costumes/mario/GA-Caillou/racoon.ogg")
    extrasounds.sound.sfx[43] = Audio.SfxOpen("costumes/mario/GA-Caillou/fireworks.ogg")
    Audio.sounds[46].sfx = Audio.SfxOpen("costumes/mario/GA-Caillou/door.ogg")
    Audio.sounds[52].sfx = Audio.SfxOpen("costumes/mario/GA-Caillou/got-star.ogg")
    Audio.sounds[54].sfx = Audio.SfxOpen("costumes/mario/GA-Caillou/player-died2.ogg")
    Audio.sounds[73].sfx = Audio.SfxOpen("costumes/mario/GA-Caillou/grab2.ogg")
    Audio.sounds[75].sfx = Audio.SfxOpen("costumes/mario/GA-Caillou/smb2-throw.ogg")
    for _,p in ipairs(costume.playersList) do
        local data = costume.playerData[playerObj]
    end    
end

function costume.onCleanup(playerObj)
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
    Audio.sounds[77].sfx = nil
    Audio.sounds[78].sfx = nil
    Audio.sounds[79].sfx = nil
    Audio.sounds[80].sfx = nil
    extrasounds.sound.sfx[81] = nil
    Audio.sounds[82].sfx = nil
    Audio.sounds[91].sfx = nil
    Defines.jumpheight = 20
    Defines.player_walkspeed = 3
    Defines.player_runspeed = 6
    Defines.jumpheight_bounce = 32
    Defines.player_grav = 0.4
    ep3Playables.cleanup(playerObj, costume, costumeTable, extraInputFunct, extraAnimFunct, extraDrawFunct)
    players[playerObj] = nil
end

return costume