local pm = require("playerManager")
local extrasounds = require("extrasounds")
local smashud = require("smashud")
_G.smasfunctions = require("smasfunctions")

local costume = {}

costume.loadedSounds = false

function costume.onInit(p)
    registerEvent(costume,"onTick")
    registerEvent(costume,"onPostPlayerHarm")
    registerEvent(costume,"onPostNPCKill")
    if not costume.loadedSounds then
        Sound.loadCostumeSounds()
        costume.loadedSounds = true
    end
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
    for i = 1,91 do
        Audio.sounds[i].sfx = nil
    end
    for i = 1,165 do
        extrasounds.sound.sfx[i] = nil
    end
    
    Defines.jumpheight = 20
    Defines.player_walkspeed = 3
    Defines.player_runspeed = 6
    Defines.jumpheight_bounce = 32
    Defines.player_grav = 0.4
end

return costume