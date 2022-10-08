local pm = require("playerManager")
local extrasounds = require("extrasounds")
local smasfunctions
pcall(function() smasfunctions = require("smasfunctions") end)

local costume = {}

costume.loadedSounds = false

function costume.onInit(p)
    plr = p
    registerEvent(costume,"onInputUpdate")
    registerEvent(costume,"onTick")
    if not costume.loadedSounds then
        Sound.loadCostumeSounds()
        costume.loadedSounds = true
    end
    
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
    Defines.projectilespeedx = 7.1
    Defines.player_grav = 0.4
end

return costume