--[[

smasExtraSounds.lua (Formely smasExtraSounds.lua) by Spencer Everly (v0.4.0)

To use this everywhere, you can simply put this under luna.lua:
_G.smasExtraSounds = require("smasExtraSounds")

And to have costume compability, require this library on any/all costumes you're using, then replace sound slot IDs 1,4,7,8,10,14,15,18,33,39,42,43,59 from (example):

Audio.sounds[14].sfx = Audio.SfxOpen("costumes/(character)/(costume)/coin.ogg")
to
smasExtraSounds.sounds[14].sfx = Audio.SfxOpen("costumes/(character)/(costume)/coin.ogg")

or this if that one doesn't work:
smasExtraSounds.sounds[14].sfx = Audio.SfxOpen(Misc.resolveSoundFile("costumes/(character)/(costume)/coin.ogg"))

Check the lua file for info on which things does what

]]

local smasExtraSounds = {}

--Are the extra sounds active? If not, they won't play. If false the library won't be used and will revert to the stock sound system. Useful for muting all sounds for a boot menu, cutscene, or something like that by using Audio.sounds[id].muted = true instead.
smasExtraSounds.active = true
--What is the volume limit smasExtraSounds should go? This can be set to any number, which playSoumd will automatically play in that specified volume.
smasExtraSounds.volume = 1

--**DELAY SETTINGS**
--Set this to any number to change how much the P-Switch Timer should delay to. Default is 50.
smasExtraSounds.pSwitchTimerDelay = 50
--Set this to any number to change how much the P-Switch Timer should delay to when the timer has almost run out. Default is 15.
smasExtraSounds.pSwitchTimerDelayFast = 15
--Set this to any number to change how much the P-Wing sound should delay to. Default is 7.
smasExtraSounds.pWingDelay = 7
--Set this to any number to change how much the player sliding should delay to. Default is 8.
smasExtraSounds.playerSlidingDelay = 8

--**FIRE/ICE/HAMMER SETTINGS**
--Whether to enable the Fire Flower sound.
smasExtraSounds.enableFireFlowerSFX = true
--Whether to enable the Ice Flower sound.
smasExtraSounds.enableIceFlowerSFX = true
--Whether to enable the Hammer Suit sound.
smasExtraSounds.enableHammerSuitSFX = true

--Whether to revert to the fire flower sound when using an ice flower instead of using the custom sound.
smasExtraSounds.useFireSoundForIce = false
--Whether to revert to the fire flower sound when using a hammer suit instead of using the custom sound.
smasExtraSounds.useFireSoundForHammerSuit = false

--**PROJECTILE SETTINGS**
--Whether to enable the boomerang SFX for Toad.
smasExtraSounds.enableToadBoomerangSFX = true
--Whether to enable the boomerang SFX for the Boomerang Bros.
smasExtraSounds.enableBoomerangBroBoomerangSFX = true

--**PLAYER SETTINGS**
--Whether to enable the jumping SFX used by players.
smasExtraSounds.enableJumpingSFX = true
--Whether to enable the spinjumping SFX used by players.
smasExtraSounds.enableSpinjumpingSFX = true
--Whether to enable the tail attack SFX used by players.
smasExtraSounds.enableTailAttackSFX = true
--Whether to enable the sliding SFX used by players.
smasExtraSounds.enableSlidingSFX = true
--Whether to enable the double jumping SFX used by players.
smasExtraSounds.enableDoubleJumpingSFX = true
--Whether to use the jump sound instead of the double jump sound.
smasExtraSounds.useOriginalJumpForDoubleJump = false
--Whether to enable the boot SFX used by players.
smasExtraSounds.enableBootSFX = true
--Whether to use the jump sound instead of the boot sound when unmounting a Yoshi.
smasExtraSounds.useJumpSoundInsteadWhenUnmountingYoshi = false
--Whether to enable the death sound used by players.
smasExtraSounds.enableDeathSFX = true
--Whether to enable the Link slashing used by Link characters.
smasExtraSounds.enableLinkSlashSFX = true
--Whether to enable the Link fireball slashing used by Link characters.
smasExtraSounds.enableLinkSlashFireballSFX = true
--Whether to enable the Link iceball slashing used by Link characters.
smasExtraSounds.enableLinkSlashIceballSFX = true
--Whether to enable the sound that plays when a fireball hits a hammer suit shell shield.
smasExtraSounds.enableFireballHammerShieldHitSFX = true

--**1UP SETTINGS**
--Whether to use the original 1UP sound instead of using the other custom sounds.
smasExtraSounds.use1UPSoundForAll1UPs = false

--**EXPLOSION SETTINGS**
--Whether to enable the SMB2 explosion SFX.
smasExtraSounds.enableSMB2ExplosionSFX = true
--Whether to enable the fireworks SFX.
smasExtraSounds.enableFireworksSFX = true
--Whether to use the original explosion sound instead of using the other custom sounds.
smasExtraSounds.useFireworksInsteadOfOtherExplosions = false

--**BLOCK SETTINGS**
--Whether to enable all normal brick smashing SFXs.
smasExtraSounds.enableBrickSmashing = true
--Whether to enable coin SFXs when hitting blocks.
smasExtraSounds.enableBlockCoinCollecting = true
--Whether to use the original sprout sound instead of using the other custom sounds.
smasExtraSounds.useOriginalBlockSproutInstead = false

--**NPC SETTINGS**
--Whether to use the original NPC fireball sound instead of using the other custom sounds.
smasExtraSounds.useOriginalBowserFireballInstead = false
--Whether to enable ice block freezing or not.
smasExtraSounds.enableIceBlockFreezing = true
--Whether to enable ice block breaking or not.
smasExtraSounds.enableIceBlockBreaking = true
--Whether to enable the enemy stomping SFX.
smasExtraSounds.enableEnemyStompingSFX = true
--Whether to enable the ice melting SFX used for throw blocks.
smasExtraSounds.enableIceMeltingSFX = true
--Whether to enable Venus Fire Trap fireballs.
smasExtraSounds.enableVenusFireball = true

--**COIN SETTINGS**
--Whether to enable the coin collecting SFX.
smasExtraSounds.enableCoinCollecting = true
--Whether to enable the cherry collecting SFX.
smasExtraSounds.enableCherryCollecting = true
--Whether to enable the rupee collecting SFX.
smasExtraSounds.enableRupeeCollecting = true
--Whether to use the original dragon coin sounds instead of the other custom sounds.
smasExtraSounds.useOriginalDragonCoinSounds = false

--**MISC SETTINGS**
--Whether to enable the NPC to Coin SFX.
smasExtraSounds.enableNPCtoCoin = true
--Whether to enable the HP get SFXs.
smasExtraSounds.enableHPCollecting = true
--Whether to use the original spinjumping SFX for big enemies instead.
smasExtraSounds.useOriginalSpinJumpForBigEnemies = false
--Whether to enable the SMB2 enemy kill sounds.
smasExtraSounds.enableSMB2EnemyKillSounds = true
--Whether to enable star collecting sounds.
smasExtraSounds.enableStarCollecting = true
--Whether to play the P-Switch/Stopwatch timer when a P-Switch/Stopwatch is active.
smasExtraSounds.playPSwitchTimerSFX = true
--Whether to enable fire flower block sound hitting.
smasExtraSounds.enableFireFlowerHitting = false --Let's only use this for characters that really need it
--Whether to enable the shell grabbing SFX.
smasExtraSounds.enableGrabShellSFX = true
--Whether to enable the P-Wing SFX.
smasExtraSounds.enablePWingSFX = true
--Whether to use the time out sound for the P-Switch/Stopwatch or not.
smasExtraSounds.enablePSwitchTimeOutSFX = true

local blockManager = require("blockManager") --Used to detect brick breaks when spinjumping
local inspect = require("ext/inspect")
local rng = require("base/rng")

local npcToCoinTimer = 0 --This is used for the NPC to Coin sound.
local holdingTimer = 0 --To count a timer on how long a player has held an item.
local comboMuteTally = 0 --To enable combo sounds

smasExtraSounds.harmableComboTypes = {
    HARM_TYPE_JUMP,
    HARM_TYPE_NPC,
    HARM_TYPE_PROJECTILE_USED,
    HARM_TYPE_TAIL,
    HARM_TYPE_HELD,
}

local ready = false --This library isn't ready until onInit is finished

smasExtraSounds.sounds = {}
smasExtraSounds.disableSoundMarker = false

smasExtraSounds.soundNamesInOrder = {
    "player-jump", --1
    "stomped", --2
    "block-hit", --3
    "block-smash", --4
    "player-shrink", --5
    "player-grow", --6
    "mushroom", --7
    "player-died", --8
    "shell-hit", --9
    "player-slide", --10
    "item-dropped", --11
    "has-item", --12
    "camera-change", --13
    "coin", --14
    "1up", --15
    "lava", --16
    "warp", --17
    "fireball", --18
    "level-win", --19
    "boss-beat", --20
    "dungeon-win", --21
    "bullet-bill", --22
    "grab", --23
    "spring", --24
    "hammer", --25
    "slide", --26
    "newpath", --27
    "level-select", --28
    "do", --29
    "pause", --30
    "key", --31
    "pswitch", --32
    "tail", --33
    "racoon", --34
    "boot", --35
    "smash", --36
    "thwomp", --37
    "birdo-spit", --38
    "birdo-hit", --39
    "smb2-exit", --40
    "birdo-beat", --41
    "npc-fireball", --42
    "fireworks", --43
    "bowser-killed", --44
    "game-beat", --45
    "door", --46
    "message", --47
    "yoshi", --48
    "yoshi-hurt", --49
    "yoshi-tongue", --50
    "yoshi-egg", --51
    "got-star", --52
    "zelda-kill", --53
    "player-died2", --54
    "yoshi-swallow", --55
    "ring", --56
    "dry-bones", --57
    "smw-checkpoint", --58
    "dragon-coin", --59
    "smw-exit", --60
    "smw-blaarg", --61
    "wart-bubble", --62
    "wart-die", --63
    "sm-block-hit", --64
    "sm-killed", --65
    "sm-glass", --66
    "sm-hurt", --67
    "sm-boss-hit", --68
    "sm-cry", --69
    "sm-explosion", --70
    "climbing", --71
    "swim", --72
    "grab2", --73
    "smw-saw", --74
    "smb2-throw", --75
    "smb2-hit", --76
    "zelda-stab", --77
    "zelda-hurt", --78
    "zelda-heart", --79
    "zelda-died", --80
    "zelda-rupee", --81
    "zelda-fire", --82
    "zelda-item", --83
    "zelda-key", --84
    "zelda-shield", --85
    "zelda-dash", --86
    "zelda-fairy", --87
    "zelda-grass", --88
    "zelda-hit", --89
    "zelda-sword-beam", --90
    "bubble", --91
    "sprout-vine", --92
    "iceball", --93
    "yi-freeze", --94
    "yi-icebreak", --95
    "2up", --96
    "3up", --97
    "5up", --98
    "dragon-coin-get2", --99
    "dragon-coin-get3", --100
    "dragon-coin-get4", --101
    "dragon-coin-get5", --102
    "cherry", --103
    "explode", --104
    "hammerthrow", --105
    "combo1", --106
    "combo2", --107
    "combo3", --108
    "combo4", --109
    "combo5", --110
    "combo6", --111
    "combo7", --112
    "score-tally", --113
    "score-tally-end", --114
    "bowser-fire", --115
    "boomerang", --116
    "smb2-charge", --117
    "stopwatch", --118
    "whale-spout", --119
    "door-reveal", --120
    "p-wing", --121
    "wand-moving", --122
    "wand-whoosh", --123
    "hop", --124
    "smash-big", --125
    "smb2-hitenemy", --126
    "boss-fall", --127
    "boss-lava", --128
    "boss-shrink", --129
    "boss-shrink-done", --130
    "hp-get", --131
    "hp-max", --132
    "cape-feather", --133
    "cape-fly", --134
    "flag-slide", --135
    "smb1-exit", --136
    "smb2-clear", --137
    "smb1-world-clear", --138
    "smb1-underground-overworld", --139
    "smb1-underground-desert", --140
    "smb1-underground-sky", --141
    "goaltape-countdown-start", --142
    "goaltape-countdown-loop", --143
    "goaltape-countdown-end", --144
    "goaltape-irisout", --145
    "smw-exit-orb", --146
    "ace-coins-5", --147
    "door-close", --148
    "sprout-megashroom", --149
    "0up", --150
    "correct", --151
    "wrong", --152
    "castle-destroy", --153
    "twirl", --154
    "fireball-hit", --155
    "shell-grab", --156
    "ice-melt", --157
    "player-jump2", --158
    "ground-pound", --159
    "ground-pound-hit", --160
    "zelda-fireball", --161
    "zelda-iceball", --162
    "pballoon", --163
    "peach-cry", --164
    "timeout", --165
    "flyinghammer-throw", --166
    "fireball2", --167
    "fireball3", --168
    "fireball-hit-hammershield", --169
}

smasExtraSounds.stockSoundNumbersInOrder = table.map{2,3,5,6,9,11,12,13,16,17,19,20,21,22,23,24,25,26,27,28,29,30,31,32,34,35,37,38,40,41,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,78,79,80,82,83,84,85,86,87,88,89,90,91}

for k,v in ipairs(smasExtraSounds.soundNamesInOrder) do
    if not smasExtraSounds.stockSoundNumbersInOrder[k] then --Will decrease sound RAM since we're only using what's replaceable via smasExtraSounds
        smasExtraSounds.sounds[k] = {}
        smasExtraSounds.sounds[k].sfx = Audio.SfxOpen(Misc.resolveSoundFile(v)) --Sound effect file
        smasExtraSounds.sounds[k].muted = false --SFX muting, will replace the variables that mute SFX
    end
end

--Non-Changable Sounds (Specific to SMAS++, which doesn't necessarily use any character utilizing to use these sounds)
smasExtraSounds.sounds[1000] = {}
smasExtraSounds.sounds[1000].sfx = Audio.SfxOpen(Misc.resolveSoundFile("menu/dialog.ogg")) --Dialog Menu Picker
smasExtraSounds.sounds[1000].muted = false
smasExtraSounds.sounds[1001] = {}
smasExtraSounds.sounds[1001].sfx = Audio.SfxOpen(Misc.resolveSoundFile("menu/dialog-confirm.ogg")) --Dialog Menu Choosing Confirmed
smasExtraSounds.sounds[1001].muted = false

local normalCharacters = {
    [CHARACTER_MARIO] = true,
    [CHARACTER_LUIGI] = true,
    [CHARACTER_PEACH] = true,
    [CHARACTER_TOAD] = true,
    [CHARACTER_MEGAMAN] = true,
    [CHARACTER_WARIO] = true,
    [CHARACTER_BOWSER] = true,
    [CHARACTER_KLONOA] = true,
    [CHARACTER_NINJABOMBERMAN] = true,
    [CHARACTER_ROSALINA] = true,
    [CHARACTER_ZELDA] = true,
    [CHARACTER_ULTIMATERINKA] = true,
    [CHARACTER_UNCLEBROADSWORD] = true,
    [CHARACTER_SAMUS] = true
}

local normalCharactersToad = {
    [CHARACTER_PEACH] = true,
    [CHARACTER_TOAD] = true,
    [CHARACTER_MEGAMAN] = true,
    [CHARACTER_KLONOA] = true,
    [CHARACTER_NINJABOMBERMAN] = true,
    [CHARACTER_ROSALINA] = true,
    [CHARACTER_ULTIMATERINKA] = true,
}

local normalCharactersWithoutMegaman = {
    [CHARACTER_MARIO] = true,
    [CHARACTER_LUIGI] = true,
    [CHARACTER_PEACH] = true,
    [CHARACTER_TOAD] = true,
    [CHARACTER_WARIO] = true,
    [CHARACTER_BOWSER] = true,
    [CHARACTER_KLONOA] = true,
    [CHARACTER_NINJABOMBERMAN] = true,
    [CHARACTER_ROSALINA] = true,
    [CHARACTER_ZELDA] = true,
    [CHARACTER_ULTIMATERINKA] = true,
    [CHARACTER_UNCLEBROADSWORD] = true,
    [CHARACTER_SAMUS] = true
}

local linkCharacters = {
    [CHARACTER_LINK] = true,
    [CHARACTER_SNAKE] = true,
}

smasExtraSounds.allVanillaSoundNumbersInOrder = table.map{1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91}

function smasExtraSounds.playSFX(name, volume, loops, delay) --If you want to play any sound, you can use smasExtraSounds.playSFX(id), or you can use a string (You can also optionally play the sound with a volume, loop, and/or delay). This is similar to SFX.play, but with smasExtraSounds support!
    console:println("Playing sound '"..name.."'...")
    
    if unexpected_condition then error("That sound doesn't exist. Play something else.") end
    
    if name == nil then
        error("That sound doesn't exist. Play something else.")
        return
    end
    
    if volume == nil then
        volume = smasExtraSounds.volume
    end
    if smasExtraSounds.volume == nil then
        volume = 1
    end
    if loops == nil then
        loops = 1
    end
    if delay == nil then
        delay = 4
    end
    
    local eventObj = {cancelled = false}
    EventManager.callEvent("onPlaySFX", eventObj, name, volume, loops, delay)
    
    if not eventObj.cancelled then
        if Sound.isExtraSoundsActive() then
            if smasExtraSounds.sounds[name] and not smasTables.stockSoundNumbersInOrder[name] then
                if not smasExtraSounds.sounds[name].muted then
                    SFX.play(smasExtraSounds.sounds[name].sfx, volume, loops, delay)
                end
            elseif smasTables.stockSoundNumbersInOrder[name] then
                SFX.play(name, volume, loops, delay)
            elseif name then
                local file = Misc.resolveSoundFile(name) or Misc.resolveSoundFile("_OST/"..name) or Misc.resolveSoundFile("_OST/_Sound Effects/"..name) or Misc.resolveSoundFile("costumes/"..name) or Misc.resolveSoundFile("___MainUserDirectory/"..name) --Common sound directories, see above for the entire list
                SFX.play(file, volume, loops, delay) --Then play it afterward
            end
        elseif not Sound.isExtraSoundsActive() then
            if smasTables.allVanillaSoundNumbersInOrder[name] then
                SFX.play(name, volume, loops, delay)
            elseif name then
                local file = Misc.resolveSoundFile(name) or Misc.resolveSoundFile("_OST/"..name) or Misc.resolveSoundFile("_OST/_Sound Effects/"..name) or Misc.resolveSoundFile("costumes/"..name) or Misc.resolveSoundFile("___MainUserDirectory/"..name) --Common sound directories, see above for the entire list
                SFX.play(file, volume, loops, delay) --Then play it afterward
            end
        end
        
        EventManager.callEvent("onPostPlaySFX", name, volume, loops, delay)
    end
end

local extrasoundsBlock90 = {}
local extrasoundsBlock668 = {}

function smasExtraSounds.onInitAPI() --This'll require a bunch of events to start
    registerEvent(smasExtraSounds, "onKeyboardPress")
    registerEvent(smasExtraSounds, "onDraw")
    registerEvent(smasExtraSounds, "onDrawEnd")
    registerEvent(smasExtraSounds, "onLevelExit")
    registerEvent(smasExtraSounds, "onTick")
    registerEvent(smasExtraSounds, "onTickEnd")
    registerEvent(smasExtraSounds, "onInputUpdate")
    registerEvent(smasExtraSounds, "onStart")
    registerEvent(smasExtraSounds, "onPostNPCKill")
    registerEvent(smasExtraSounds, "onNPCKill")
    registerEvent(smasExtraSounds, "onPostNPCHarm")
    registerEvent(smasExtraSounds, "onNPCHarm")
    registerEvent(smasExtraSounds, "onPostPlayerHarm")
    registerEvent(smasExtraSounds, "onPostPlayerKill")
    registerEvent(smasExtraSounds, "onPostExplosion")
    registerEvent(smasExtraSounds, "onExplosion")
    registerEvent(smasExtraSounds, "onPostBlockHit")
    registerEvent(smasExtraSounds, "onPlayerKill")
    registerEvent(smasExtraSounds, "onEvent")
    
    blockManager.registerEvent(90, extrasoundsBlock90, "onCollideBlock")
    blockManager.registerEvent(668, extrasoundsBlock668, "onCollideBlock")
    
    local Routine = require("routine")
    
    ready = true --We're ready, so we can begin
end

local function harmNPC(npc,...) -- npc:harm but it returns if it actually did anything
    local oldKilled     = npc:mem(0x122,FIELD_WORD)
    local oldProjectile = npc:mem(0x136,FIELD_BOOL)
    local oldHitCount   = npc:mem(0x148,FIELD_FLOAT)
    local oldImmune     = npc:mem(0x156,FIELD_WORD)
    local oldID         = npc.id
    local oldSpeedX     = npc.speedX
    local oldSpeedY     = npc.speedY

    npc:harm(...)

    return (
           oldKilled     ~= npc:mem(0x122,FIELD_WORD)
        or oldProjectile ~= npc:mem(0x136,FIELD_BOOL)
        or oldHitCount   ~= npc:mem(0x148,FIELD_FLOAT)
        or oldImmune     ~= npc:mem(0x156,FIELD_WORD)
        or oldID         ~= npc.id
        or oldSpeedX     ~= npc.speedX
        or oldSpeedY     ~= npc.speedY
    )
end

local function isShooting(p)
    return (p:mem(0x160, FIELD_WORD) == 0
        and Level.endState() == 0
        and (
            not GameData.winStateActive
            or GameData.winStateActive == nil
        )
        and p.deathTimer == 0
        and p.forcedState == 0
        and p.holdingNPC == nil
        and not p.climbing
        and not p.keys.down
        and (
            p.mount == MOUNT_NONE
            or p.mount == MOUNT_BOOT
        )
        and not p:mem(0x50, FIELD_BOOL)
        and p.keys.run == KEYS_PRESSED or p.keys.altRun == KEYS_PRESSED
        and p:mem(0x172, FIELD_BOOL)
    )
end

local function isShootingLink(p)
    return (p:mem(0x160, FIELD_WORD) == 0
        and p:mem(0x162, FIELD_WORD) == 0
        and Level.endState() == 0
        and (
            not GameData.winStateActive
            or GameData.winStateActive == nil
        )
        and p.deathTimer == 0
        and p.forcedState == 0
        and p.holdingNPC == nil
        and not p.climbing
        and (
            p.mount == MOUNT_NONE
            or p.mount == MOUNT_BOOT
        )
        and p.keys.run == KEYS_PRESSED or p.keys.altRun == KEYS_PRESSED
        and p:mem(0x172, FIELD_BOOL)
    )
end

local function isTailSwiping(p)
    return (p.keys.run == KEYS_PRESSED
        and p:mem(0x172, FIELD_BOOL)
        and Level.endState() == 0
        and (
            not GameData.winStateActive
            or GameData.winStateActive == nil
        )
        and p.forcedState == FORCEDSTATE_NONE
        and not p.climbing
        and p.mount == 0
        and not p.keys.down
        and not p:mem(0x50, FIELD_BOOL)
        and p:mem(0x172, FIELD_BOOL)
        and p.deathTimer == 0
    )
end

local function isPlayerUnderwater(p) --Returns true if the specified player is underwater.
    return (
        p:mem(0x34,FIELD_WORD) > 0
        and p:mem(0x06,FIELD_WORD) == 0
    )
end

local function isInQuicksand(p) --Returns true if the specified player is in quicksand.
    return (
        p:mem(0x34, FIELD_WORD) == 2
        and p:mem(0x06, FIELD_WORD) > 0
    )
end

local function hasJumped(p, ahippinandahoppinactive)
    if ahippinandahoppinactive == nil then
        ahippinandahoppinactive = false
    end
    if not ahippinandahoppinactive then
        return (p.deathTimer == 0
            and Level.endState() == 0
            and (
                not GameData.winStateActive
                or GameData.winStateActive == nil
            )
            and p.forcedState == 0
            and not isPlayerUnderwater(p)
            and (
                p:isOnGround()
                or p:isClimbing()
                or isInQuicksand(p)
            )
            and (
                p:mem(0x11E, FIELD_BOOL)
                and p.keys.jump == KEYS_PRESSED
            )
        )
    elseif ahippinandahoppinactive then
        return (p.deathTimer == 0
            and Level.endState() == 0
            and (
                not GameData.winStateActive
                or GameData.winStateActive == nil
            )
            and p.forcedState == 0
            and not isPlayerUnderwater(p)
            and (
                p:mem(0x11E, FIELD_BOOL)
                and p.keys.jump == KEYS_PRESSED
            )
        )
    end
end

local function isOnScreen(npc)
    -- Get camera boundaries
    local left = camera.x;
    local right = left + camera.width;
    local top = camera.y;
    local bottom = top + camera.height;
    -- Check if offscreen
    if npc.x + npc.width < left or npc.x > right then
        return false
    elseif npc.y + npc.height < top or npc.y > bottom then
        return false
    else
        return true
    end
end

local leafPowerups = table.map{PLAYER_LEAF,PLAYER_TANOOKI}
local shootingPowerups = table.map{PLAYER_FIREFLOWER,PLAYER_ICE,PLAYER_HAMMER}

local starmans = table.map{293,559,994,996}
local coins = table.map{10,33,88,103,138,258,411,528}
local oneups = table.map{90,186,187}
local threeups = table.map{188}
local items = table.map{9,184,185,249,14,182,183,34,169,170,277,264,996,994}
local healitems = table.map{9,184,185,249,14,182,183,34,169,170,277,264}
local allenemies = table.map{1,2,3,4,5,6,7,8,12,15,17,18,19,20,23,24,25,27,28,29,36,37,38,39,42,43,44,47,48,51,52,53,54,55,59,61,63,65,71,72,73,74,76,77,89,93,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,135,137,161,162,163,164,165,166,167,168,172,173,174,175,176,177,180,189,199,200,201,203,204,205,206,207,209,210,229,230,231,232,233,234,235,236,242,243,244,245,247,261,262,267,268,270,271,272,275,280,281,284,285,286,294,295,296,298,299,301,302,303,304,305,307,309,311,312,313,314,315,316,317,318,321,323,324,333,345,346,347,350,351,352,357,360,365,368,369,371,372,373,374,375,377,379,380,382,383,386,388,389,392,393,395,401,406,407,408,409,413,415,431,437,446,447,448,449,459,460,461,463,464,466,467,469,470,471,472,485,486,487,490,491,492,493,509,510,512,513,514,515,516,517,418,519,520,521,522,523,524,529,530,539,562,563,564,572,578,579,580,586,587,588,589,590,610,611,612,613,614,616,618,619,624,666} --Every single X2 enemy.
local allsmallenemies = table.map{1,2,3,4,5,6,7,8,12,15,17,18,19,20,23,24,25,27,28,29,36,37,38,39,42,43,44,47,48,51,52,53,54,55,59,61,63,65,73,74,76,77,89,93,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,135,137,161,162,163,164,165,166,167,168,172,173,174,175,176,177,180,189,199,200,201,203,204,205,206,207,209,210,229,230,231,232,233,234,235,236,242,243,244,245,247,261,262,267,268,270,271,272,275,280,281,284,285,286,294,295,296,298,299,301,302,303,304,305,307,309,311,312,313,314,315,316,317,318,321,323,324,333,345,346,347,350,351,352,357,360,365,368,369,371,372,373,374,375,377,379,380,382,383,386,388,389,392,393,395,401,406,407,408,409,413,415,431,437,446,447,448,449,459,460,461,463,464,469,470,471,472,485,486,487,490,491,492,493,509,510,512,513,514,515,516,517,418,519,520,521,522,523,524,529,530,539,562,563,564,572,578,579,580,586,587,588,589,590,610,611,612,613,614,616,619,624,666} --Every single small X2 enemy.
local allbigenemies = table.map{71,72,466,467,618} --Every single big X2 enemy.
local enemyfireballs = table.map{85,87,246,276} --All enemy fireballs.

function smasExtraSounds.onDraw()
    for k,v in ipairs(smasExtraSounds.soundNamesInOrder) do
        if not smasExtraSounds.stockSoundNumbersInOrder[k] then
            if smasExtraSounds.sounds[k].sfx == nil then --If nil, roll back to the original sound...
                smasExtraSounds.sounds[k].sfx = Audio.SfxOpen(Misc.resolveSoundFile(v))
            end
        end
    end
end

function smasExtraSounds.onDrawEnd()
    if comboMuteTally > 0 then
        comboMuteTally = comboMuteTally - 1
        if comboMuteTally == 0 then
            Audio.sounds[9].muted = false
        end
    end
end

function smasExtraSounds.onTick() --This is a list of sounds that'll need to be replaced within each costume. They're muted here for obivious reasons.
    if smasExtraSounds.active then --Only mute when active
        smasExtraSounds.disableSoundMarker = false --Make sure, when disabled, it only unmutes once when disabled
        Audio.sounds[1].muted = true --player-jump.ogg
        Audio.sounds[4].muted = true --block-smash.ogg
        Audio.sounds[7].muted = true --mushroom.ogg
        Audio.sounds[8].muted = true --player-dead.ogg
        Audio.sounds[10].muted = true --player-slide.ogg
        Audio.sounds[14].muted = true --coin.ogg
        Audio.sounds[15].muted = true --1up.ogg
        --Audio.sounds[17].muted = true --warp.ogg
        Audio.sounds[18].muted = true --fireball.ogg
        Audio.sounds[33].muted = true --tail.ogg
        Audio.sounds[36].muted = true --smash.ogg
        Audio.sounds[39].muted = true --birdo-hit.ogg
        Audio.sounds[42].muted = true --npc-fireball.ogg
        Audio.sounds[43].muted = true --fireworks.ogg
        Audio.sounds[59].muted = true --dragon-coin.ogg
        Audio.sounds[77].muted = true --zelda-stab.ogg
        Audio.sounds[81].muted = true --zelda-rupee.ogg
        
        
        
        for _,p in ipairs(Player.get()) do
            
            
            
            
            
            --**JUMPING**
            if hasJumped(p, false) and not Cheats.get("ahippinandahoppin").active then
                if smasExtraSounds.enableJumpingSFX then
                    smasExtraSounds.playSFX(1)
                end
            elseif hasJumped(p, true) and Cheats.get("ahippinandahoppin").active then
                if smasExtraSounds.enableJumpingSFX then
                    smasExtraSounds.playSFX(1)
                end
            end
            
            
            
            
            
            --**YOSHI UNMOUNT**
            if p.mount == 3 then
                if (p:mem(0x11E, FIELD_BOOL) and p.keys.altJump == KEYS_PRESSED) then
                    if not smasExtraSounds.useJumpSoundInsteadWhenUnmountingYoshi then
                        if smasExtraSounds.enableBootSFX then
                            smasExtraSounds.playSFX(35)
                        end
                    elseif smasExtraSounds.useJumpSoundInsteadWhenUnmountingYoshi then
                        if smasExtraSounds.enableJumpingSFX then
                            smasExtraSounds.playSFX(1)
                        end
                    end
                end
            end
            
            
            
            
            
            
            --**DOUBLE JUMPING**
            if (p:mem(0x00, FIELD_BOOL) and p:mem(0x174, FIELD_BOOL) and p.keys.jump == KEYS_PRESSED) then
                if smasExtraSounds.enableDoubleJumpingSFX then
                    if smasExtraSounds.useOriginalJumpForDoubleJump then
                        smasExtraSounds.playSFX(1)
                    elseif not smasExtraSounds.useOriginalJumpForDoubleJump then
                        smasExtraSounds.playSFX(158)
                    end
                end
            end
            
            
            
            
            
            --**SLIDING**
            if p:isOnGround() then
                if (p.speedX < 0 and p.rightKeyPressing) or (p.speedX > 0 and p.leftKeyPressing) then --Is the player sliding?
                    if smasExtraSounds.enableSlidingSFX then
                        smasExtraSounds.playSFX(10, smasExtraSounds.volume, 1, smasExtraSounds.playerSlidingDelay) --Sliding SFX
                    end
                end
            end
            
            
            
            
            --**TAIL ATTACK**
            if p.powerup == 4 or p.powerup == 5 then
                if isTailSwiping(p) then --Is the key pressed, and active, and the forced state is none, while not climbing and not on a mount and not ducking (And not dead)?
                    if smasExtraSounds.enableTailAttackSFX then
                        smasExtraSounds.playSFX(33)
                    end
                end
            end
            
            
            
            
            
            --**SPINJUMPING**
            if normalCharacters[p.character] then
                if (p:isOnGround() and not p.keys.down and p.mount == 0 and (not GameData.winStateActive or GameData.winStateActive == nil) and Level.endState() == 0) then --If on the ground, not holding down, and not on a mount...
                    if (p:mem(0x120, FIELD_BOOL) and p.keys.altJump == KEYS_PRESSED) then --If alt jump is pressed and jump has been activated...
                        if p:mem(0x50, FIELD_BOOL) == false then
                            if smasExtraSounds.enableSpinjumpingSFX then
                                smasExtraSounds.playSFX(33)
                            end
                        end
                    end
                end
            elseif linkCharacters[p.character] then
                if (p:isOnGround() and Level.endState() == 0) then --If on the ground...
                    if (p:mem(0x120, FIELD_BOOL) and p.keys.altJump == KEYS_PRESSED) then --If alt jump is pressed and jump has been activated...
                        if p:mem(0x50, FIELD_BOOL) == false then
                            if smasExtraSounds.enableJumpingSFX then
                                smasExtraSounds.playSFX(1)
                            end
                        end
                    end
                end
            end
            
            
            
            
            --**SPINJUMP FIRE/ICEBALLS**
            if p:mem(0x50, FIELD_BOOL) and p.holdingNPC == nil then --Is the player spinjumping while not holding an item?
                if p:mem(0x160, FIELD_WORD) == 0 then --Is the cooldown on this number?
                    if p.powerup == 3 then --Fireball sound
                        if smasExtraSounds.enableFireFlowerSFX then
                            smasExtraSounds.playSFX(18)
                        end
                    end
                    if p.powerup == 7 then --Iceball sound
                        if smasExtraSounds.enableIceFlowerSFX then
                            if not smasExtraSounds.useFireSoundForIce then
                                smasExtraSounds.playSFX(93)
                            elseif smasExtraSounds.useFireSoundForIce then
                                smasExtraSounds.playSFX(18)
                            end
                        end
                    end
                end
            end
            if not p:mem(0x50, FIELD_BOOL) then --Is the player not spinjumping?
                
            end
        
        
            
            
            --**GRABBING SHELLS**
            if Player.count() == 1 then
                if p.holdingNPC ~= nil then
                    holdingTimer = holdingTimer + 1
                else
                    holdingTimer = 0
                end
                for k,v in ipairs(NPC.get({5,7,24,73,113,114,115,116,172,174,194})) do
                    if p.holdingNPC == v and p.keys.run then
                        if not normalCharactersToad[p.character] then
                            if holdingTimer == 1 then
                                if smasExtraSounds.enableGrabShellSFX then
                                    smasExtraSounds.playSFX(156)
                                end
                            end
                        end
                    end
                end
            end
            
            
            
            
            --**FIREBALL HAMMER SUIT SHIELD HIT (Block Hit Muting Detection)**
            if ((p.powerup == 6 and p:mem(0x12E,FIELD_BOOL) and p.mount == 0 and not linkCharacters[p.character]) or (p.mount == 1 and p.mountColor == 2)) then
                for k,v in ipairs(NPC.getIntersecting(p.x - 15, p.y - 15, p.x + p.width + 30, p.y + p.height + 30)) do
                    if enemyfireballs[v.id] then
                        if smasExtraSounds.enableFireballHammerShieldHitSFX then
                            Audio.sounds[3].muted = true
                            Routine.run(smasExtraSounds.tempMuteBlockHit)
                        end
                    end
                end
            end
            
            
            
        
            --**PSWITCH/STOPWATCH TIMER**
            if mem(0x00B2C62C, FIELD_WORD) >= 150 and mem(0x00B2C62C, FIELD_WORD) < mem(0x00B2C87C, FIELD_WORD) - 27 or mem(0x00B2C62E, FIELD_WORD) >= 150 and mem(0x00B2C62E, FIELD_WORD) < mem(0x00B2C87C, FIELD_WORD) - 27 then --Are the P-Switch/Stopwatch timers activate and on these number values?
                if Level.endState() <= 0 then --Make sure to not activate when the endState is greater than 1
                    if not GameData.winStateActive or GameData.winStateActive == nil then --SMAS++ episode specific, you don't need this for anything outside of SMAS++
                        if smasExtraSounds.playPSwitchTimerSFX then
                            smasExtraSounds.playSFX(118, smasExtraSounds.volume, 1, smasExtraSounds.pSwitchTimerDelay)
                        end
                    end
                end
            elseif mem(0x00B2C62C, FIELD_WORD) <= 150 and mem(0x00B2C62C, FIELD_WORD) >= 1 or mem(0x00B2C62E, FIELD_WORD) <= 150 and mem(0x00B2C62E, FIELD_WORD) >= 1 then --Are the P-Switch/Stopwatch timers activate and on these number values?
                if Level.endState() <= 0 then --Make sure to not activate when the endState is greater than 1
                    if not GameData.winStateActive or GameData.winStateActive == nil then --SMAS++ episode specific, you don't need this for anything outside of SMAS++
                        if smasExtraSounds.playPSwitchTimerSFX then
                            smasExtraSounds.playSFX(118, smasExtraSounds.volume, 1, smasExtraSounds.pSwitchTimerDelayFast)
                        end
                    end
                end
            end
            
            
            
            --**PSWITCH/STOPWATCH TIMEOUT**
            if mem(0x00B2C62C, FIELD_WORD) == 150 or mem(0x00B2C62E, FIELD_WORD) == 150 then --Time out sound effect
                if Level.endState() <= 0 then --Make sure to not activate when the endState is greater than 1
                    if not GameData.winStateActive or GameData.winStateActive == nil then --SMAS++ episode specific, you don't need this for anything outside of SMAS++
                        if smasExtraSounds.enablePSwitchTimeOutSFX then
                            smasExtraSounds.playSFX(165, smasExtraSounds.volume, 1)
                        end
                    end
                end
            end
            
            
            
            --**P-WING**
            for k,p in ipairs(Player.get()) do
                if p:mem(0x66, FIELD_BOOL) == false and p.deathTimer <= 0 and p.forcedState == FORCEDSTATE_NONE and Level.endState() <= 0 then
                    if p:mem(0x16C, FIELD_BOOL) == true then
                        if smasExtraSounds.enablePWingSFX then
                            smasExtraSounds.playSFX(121, smasExtraSounds.volume, 1, smasExtraSounds.pWingDelay)
                        end
                    end
                    if p:mem(0x170, FIELD_WORD) >= 1 then
                        if smasExtraSounds.enablePWingSFX then
                            smasExtraSounds.playSFX(121, smasExtraSounds.volume, 1, smasExtraSounds.pWingDelay)
                        end
                    end
                end
            end
            
            
            
            
            --**NPCS**
            
            --ITEMS/PROJECTILES**
            for k,v in ipairs(NPC.get(45)) do --Throw blocks/ice blocks, used for when they melt
                if v.ai2 == 449 then
                    if smasExtraSounds.enableIceMeltingSFX then
                        smasExtraSounds.playSFX(157)
                    end
                end
            end
            
            --*ENEMIES*
            --
            --*Venus Fire Trap*
            for k,v in ipairs(NPC.get(245)) do
                if (v.ai2 == 2 and v.ai1 == 50) and isOnScreen(v) then
                    if smasExtraSounds.enableVenusFireball then
                        smasExtraSounds.playSFX(167)
                    end
                end
            end
            
            --*BOSSES*
            --
            --*SMB3 Bowser*
            for k,v in ipairs(NPC.get(86)) do --Make sure the seperate Bowser fire sound plays when SMB3 Bowser actually fires up a fireball
                if v.ai4 == 4 then
                    if v.ai3 == 25 then
                        if not smasExtraSounds.useOriginalBowserFireballInstead then
                            smasExtraSounds.playSFX(115)
                        elseif smasExtraSounds.useOriginalBowserFireballInstead then
                            smasExtraSounds.playSFX(42)
                        end
                    end
                end
            end
            --*SMB1 Bowser*
            for k,v in ipairs(NPC.get(200)) do --Make sure the seperate Bowser fire sound plays when SMB1 Bowser actually fires up a fireball
                if v.ai3 == 40 then
                    if not smasExtraSounds.useOriginalBowserFireballInstead then
                        smasExtraSounds.playSFX(115)
                    elseif smasExtraSounds.useOriginalBowserFireballInstead then
                        smasExtraSounds.playSFX(42)
                    end
                end
            end
            --*SMW Ludwig Koopa*
            for k,v in ipairs(NPC.get(280)) do --Make sure the actual fire sound plays when Ludwig Koopa actually fires up a fireball
                if v.ai1 == 2 then
                    smasExtraSounds.playSFX(42, smasExtraSounds.volume, 1, 35)
                end
            end
            --*SMB3 Boom Boom*
            for k,v in ipairs(NPC.get(15)) do --Adding a hurt sound for Boom Boom cause why not lol
                if v.ai1 == 4 and v.ai2 == 1 then
                    smasExtraSounds.playSFX(39, smasExtraSounds.volume)
                end
            end
            
            
            
            
            
            --**PROJECTILES**
            --*Toad's Boomerang*
            for k,v in ipairs(NPC.get(292)) do --Boomerang sounds! (Toad's Boomerang)
                if smasExtraSounds.enableToadBoomerangSFX then
                    if isOnScreen(v) then
                        smasExtraSounds.playSFX(116, smasExtraSounds.volume, 1, 12)
                    end
                end
            end
            --*Boomerang Bro. Projectile*
            for k,v in ipairs(NPC.get(615)) do --Boomerang sounds! (Boomerang Bros.)
                if smasExtraSounds.enableBoomerangBroBoomerangSFX then
                    if isOnScreen(v) then
                        smasExtraSounds.playSFX(116, smasExtraSounds.volume, 1, 12)
                    end
                end
            end
            
            
            
            --**1UPS**
            if not isOverworld then
                for index,scoreboard in ipairs(Animation.get(79)) do --Score values!
                    if scoreboard.animationFrame == 9 and scoreboard.speedY == -1.94 then --1UP
                        if SaveData.enableLives then
                            smasExtraSounds.playSFX(15)
                        else
                            smasExtraSounds.playSFX(150)
                        end
                    end
                    if scoreboard.animationFrame == 10 and scoreboard.speedY == -1.94 then --2UP
                        if not smasExtraSounds.use1UPSoundForAll1UPs then
                            if SaveData.enableLives then
                                smasExtraSounds.playSFX(96)
                            else
                                smasExtraSounds.playSFX(150)
                            end
                        elseif smasExtraSounds.use1UPSoundForAll1UPs then
                            if SaveData.enableLives then
                                smasExtraSounds.playSFX(15)
                            else
                                smasExtraSounds.playSFX(150)
                            end
                        end
                    end
                    if scoreboard.animationFrame == 11 and scoreboard.speedY == -1.94 then --3UP
                        if not smasExtraSounds.use1UPSoundForAll1UPs then
                            if SaveData.enableLives then
                                smasExtraSounds.playSFX(97)
                            else
                                smasExtraSounds.playSFX(150)
                            end
                        elseif smasExtraSounds.use1UPSoundForAll1UPs then
                            if SaveData.enableLives then
                                smasExtraSounds.playSFX(15)
                            else
                                smasExtraSounds.playSFX(150)
                            end
                        end
                    end
                    if scoreboard.animationFrame == 12 and scoreboard.speedY == -1.94 then --5UP
                        if not smasExtraSounds.use1UPSoundForAll1UPs then
                            if SaveData.enableLives then
                                smasExtraSounds.playSFX(98)
                            else
                                smasExtraSounds.playSFX(150)
                            end
                        elseif smasExtraSounds.use1UPSoundForAll1UPs then
                            if SaveData.enableLives then
                                smasExtraSounds.playSFX(15)
                            else
                                smasExtraSounds.playSFX(150)
                            end
                        end
                    end
                end
                
                
                
                
            --**EXPLOSIONS**
                for index,explosion in ipairs(Effect.get(69)) do --Explosions!
                    if explosion.timer == 59 then
                        if not smasExtraSounds.useFireworksInsteadOfOtherExplosions then
                            if smasExtraSounds.enableSMB2ExplosionSFX then
                                smasExtraSounds.playSFX(104, smasExtraSounds.volume)
                            end
                        elseif smasExtraSounds.useFireworksInsteadOfOtherExplosions then
                            if smasExtraSounds.enableFireworksSFX then
                                smasExtraSounds.playSFX(43, smasExtraSounds.volume)
                            end
                        end
                    end
                end
                for index2,explosion2 in ipairs(Effect.get(71)) do
                    if explosion2.timer == 59 then
                        if smasExtraSounds.enableFireworksSFX then
                            smasExtraSounds.playSFX(43, smasExtraSounds.volume, 1)
                        end
                    end
                end
            end
            
            
            
            
            
            
            
            --**NPCTOCOIN**
            if mem(0x00A3C87F, FIELD_BYTE) == 14 and Level.endState() == 2 or Level.endState() == 4 then --This plays a coin sound when NpcToCoin happens
                npcToCoinTimer = npcToCoinTimer + 1
                if smasExtraSounds.enableNPCtoCoin then
                    if npcToCoinTimer == 1 then
                        smasExtraSounds.playSFX(14)
                    end
                end
            end
            
            
            
            
            
            
        end
    end
    if not smasExtraSounds.active then --Unmute when not active
        if not smasExtraSounds.disableSoundMarker then
            Audio.sounds[1].muted = false --player-jump.ogg
            Audio.sounds[4].muted = false --block-smash.ogg
            Audio.sounds[7].muted = false --mushroom.ogg
            Audio.sounds[8].muted = false --player-dead.ogg
            Audio.sounds[10].muted = false --player-slide.ogg
            Audio.sounds[14].muted = false --coin.ogg
            Audio.sounds[15].muted = false --1up.ogg
            --Audio.sounds[17].muted = false --warp.ogg
            Audio.sounds[18].muted = false --fireball.ogg
            Audio.sounds[33].muted = false --tail.ogg
            Audio.sounds[36].muted = false --smash.ogg
            Audio.sounds[39].muted = false --birdo-hit.ogg
            Audio.sounds[42].muted = false --npc-fireball.ogg
            Audio.sounds[43].muted = false --fireworks.ogg
            Audio.sounds[59].muted = false --dragon-coin.ogg
            Audio.sounds[77].muted = false --zelda-stab.ogg
            Audio.sounds[81].muted = false --zelda-rupee.ogg
            smasExtraSounds.disableSoundMarker = true
        end
    end
end

local blockSmashTable = {
    [4] = 4,
    [60] = 4,
    [90] = 4,
    [186] = 43,
    [188] = 4,
    [226] = 4,
    [293] = 4,
    [668] = 4,
}

function bricksmashsound(block, fromUpper, playerornil) --This will smash bricks, as said from the source code.
    Routine.waitFrames(2, true)
    if block.isHidden and block.layerName == "Destroyed Blocks" then
        if smasExtraSounds.enableBrickSmashing then
            smasExtraSounds.playSFX(blockSmashTable[block.id])
        end
    end
end

function brickkillsound(block, hitter) --Alternative way to play the sound. Used with the SMW block, the Brinstar Block, and the Unstable Turn Block.
    Routine.waitFrames(2, true)
    if block.isHidden and block.layerName == "Destroyed Blocks" then
        if smasExtraSounds.enableBrickSmashing then
            smasExtraSounds.playSFX(blockSmashTable[block.id])
        end
    end
end

local otherCoinSoundsMap = {
    [251] = 81,
    [252] = 81,
    [253] = 81,
}

function brickcointopdetection(block, fromUpper, playerornil)
    if smasExtraSounds.enableBlockCoinCollecting and not fromUpper then
        for k,v in NPC.iterateIntersecting(block.x, block.y - 32, block.x + 32, block.y) do
            if NPC.config[v.id].iscoin and not v.isHidden and not v.isGenerator then
                smasExtraSounds.playSFX(otherCoinSoundsMap[v.id] or 14)
            end
        end
    end
end

function extrasoundsBlock90.onCollideBlock(block, hitter) --SMW BLock
    if type(hitter) == "Player" then
        if (hitter.y+hitter.height) <= (block.y+4) then
            if (hitter:mem(0x50, FIELD_BOOL)) then --Is the player spinjumping?
                Routine.run(brickkillsound,block,hitter)
            end
        end
    end
end

function extrasoundsBlock668.onCollideBlock(block, hitter) --Unstable Turn Block
    if type(hitter) == "Player" then
        Routine.run(brickkillsound,block,hitter)
    end
end

function smasExtraSounds.onPostBlockHit(block, fromUpper, playerornil) --Let's start off with block hitting.
    local bricks = table.map{4,60,90,188,226,293,526} --These are a list of breakable bricks
    local bricksnormal = table.map{4,60,90,188,226,293} --These are a list of breakable bricks, without the Super Metroid breakable.
    local questionblocks = table.map{5,88,193,224}
    if smasExtraSounds.active then --If it's true, play them
        if not Misc.isPaused() then --Making sure the sound only plays when not paused...
            for _,p in ipairs(Player.get()) do --This will get actions regarding all players
            
                
                
                
                
                --**CONTENT ID DETECTION**
                if block.contentID == nil then --For blocks that are already used
                    
                end
                if block.contentID == 1225 or block.contentID == 1226 or block.contentID == 1227 then --Add 1000 to get an actual content ID number. The first three are vine blocks.
                    if not smasExtraSounds.useOriginalBlockSproutInstead then
                        smasExtraSounds.playSFX(92)
                    elseif smasExtraSounds.useOriginalBlockSproutInstead then
                        smasExtraSounds.playSFX(7)
                    end
                elseif block.contentID == 1997 or block.contentID == 1425 then --Megashroom block, also compatible with SMAS++
                    if not smasExtraSounds.useOriginalBlockSproutInstead then
                        smasExtraSounds.playSFX(149)
                    elseif smasExtraSounds.useOriginalBlockSproutInstead then
                        smasExtraSounds.playSFX(7)
                    end
                elseif block.contentID == 0 then --This is to prevent a coin sound from playing when hitting an nonexistant block
                    
                elseif block.contentID == 1000 then --Same as last
                    
                elseif block.contentID >= 1001 then --Greater than blocks, exceptional to vine blocks, will play a mushroom spawn sound
                    smasExtraSounds.playSFX(7)
                elseif block.contentID <= 99 then --Elseif, we'll play a coin sound with things less than 99, the coin block limit
                    if playerornil then
                        if normalCharacters[playerornil.character] then
                            if smasExtraSounds.enableBlockCoinCollecting then
                                smasExtraSounds.playSFX(14)
                            end
                        elseif linkCharacters[playerornil.character] then
                            if smasExtraSounds.enableBlockCoinCollecting then
                                smasExtraSounds.playSFX(81)
                            end
                        end
                    else
                        smasExtraSounds.playSFX(14)
                    end
                end
                
                
                
                
                --**BOWSER BRICKS**
                if block.id == 186 then --SMB3 Bowser Brick detection, thanks to looking at the source code
                    smasExtraSounds.playSFX(43)
                end
                
                
                
                
                --**BRICK SMASHING**
                if bricksnormal[block.id] or block.id == 186 then
                    Routine.run(bricksmashsound, block, fromUpper, playerornil)
                end
                
                
                
                
                --**COIN TOP DETECTION**
                if bricksnormal[block.id] or questionblocks[block.id] then
                    Routine.run(brickcointopdetection, block, fromUpper, playerornil)
                end
                
                
                
                
                
            end
        end
    end
end

function smasExtraSounds.onPostPlayerKill()
    if smasExtraSounds.active then
        for _,p in ipairs(Player.get()) do --This will get actions regards to the player itself
    
    
    
    
            --**PLAYER DYING**
            if smasExtraSounds.enableDeathSFX then
                if p.character ~= CHARACTER_LINK and p.character ~= CHARACTER_SNAKE then
                    smasExtraSounds.playSFX(8)
                end
            end
        
        
        
        end
    end
end

function smasExtraSounds.onInputUpdate() --Button pressing for such commands
    if not Misc.isPaused() then
        if smasExtraSounds.active then
            for _,p in ipairs(Player.get()) do --Get all players
            
            
            
                
                
                
                --**FIREBALLS/HAMMERS/ICEBALLS**
                if isShooting(p) then
                    if normalCharactersWithoutMegaman[p.character] then
                        if p.powerup == 3 then --Fireball sound
                            if smasExtraSounds.enableFireFlowerSFX then
                                smasExtraSounds.playSFX(18, smasExtraSounds.volume)
                            end
                        end
                        if p.powerup == 6 then --Hammer throw sound
                            if smasExtraSounds.enableHammerSuitSFX then
                                if not smasExtraSounds.useFireSoundForHammerSuit then
                                    smasExtraSounds.playSFX(105, smasExtraSounds.volume)
                                elseif smasExtraSounds.useFireSoundForHammerSuit then
                                    smasExtraSounds.playSFX(18, smasExtraSounds.volume)
                                end
                            end
                        end
                        if p.powerup == 7 then --Iceball sound
                            if smasExtraSounds.enableIceFlowerSFX then
                                if not smasExtraSounds.useFireSoundForIce then
                                    smasExtraSounds.playSFX(93, smasExtraSounds.volume)
                                elseif smasExtraSounds.useFireSoundForIce then
                                    smasExtraSounds.playSFX(18, smasExtraSounds.volume)
                                end
                            end
                        end
                    end
                end
                
                
                
                
                --**LINK SLASHING**
                if isShootingLink(p) then
                    if linkCharacters[p.character] then
                        if p.powerup == 3 then --Fireball sound
                            if smasExtraSounds.enableLinkSlashFireballSFX then
                                smasExtraSounds.playSFX(161, smasExtraSounds.volume)
                            end
                        elseif p.powerup == 7 then --Iceball sound
                            if smasExtraSounds.enableLinkSlashIceballSFX then
                                smasExtraSounds.playSFX(162, smasExtraSounds.volume)
                            end
                        else
                            if smasExtraSounds.enableLinkSlashSFX then
                                smasExtraSounds.playSFX(77, smasExtraSounds.volume)
                            end
                        end
                    end
                end
                
                
                
                --*YOSHI FIRE SPITTING*
                if p:mem(0x68, FIELD_BOOL) == true then --If it's detected that Yoshi has the fire ability...
                    if p.keys.run == KEYS_PRESSED or p.keys.altRun == KEYS_PRESSED then --Then if it's spit out...
                        smasExtraSounds.playSFX(42) --Play the sound
                    end
                end
                
                
                

                
                
                
            end
        end
    end
end


function smasExtraSounds.comboSoundRoutine()
    Routine.waitFrames(1, true)
    for index,scoreboard in ipairs(Animation.get(79)) do --Score values!
        if scoreboard.animationFrame == 0 and scoreboard.speedY == -1.94 then --10 Points
            smasExtraSounds.playSFX(9)
        end
        if scoreboard.animationFrame == 1 and scoreboard.speedY == -1.94 then --100 Points
            smasExtraSounds.playSFX(9)
        end
        if scoreboard.animationFrame == 2 and scoreboard.speedY == -1.94 then --200 Points
            smasExtraSounds.playSFX(106)
        end
        if scoreboard.animationFrame == 3 and scoreboard.speedY == -1.94 then --400 Points
            smasExtraSounds.playSFX(107)
        end
        if scoreboard.animationFrame == 4 and scoreboard.speedY == -1.94 then --800 Points
            smasExtraSounds.playSFX(108)
        end
        if scoreboard.animationFrame == 5 and scoreboard.speedY == -1.94 then --1000 Points
            smasExtraSounds.playSFX(109)
        end
        if scoreboard.animationFrame == 6 and scoreboard.speedY == -1.94 then --2000 Points
            smasExtraSounds.playSFX(110)
        end
        if scoreboard.animationFrame == 7 and scoreboard.speedY == -1.94 then --4000 Points
            smasExtraSounds.playSFX(111)
        end
        if scoreboard.animationFrame == 8 and scoreboard.speedY == -1.94 then --8000 Points
            smasExtraSounds.playSFX(112)
        end
        if scoreboard.animationFrame >= 9 and scoreboard.speedY == -1.94 then --1UP -> 5UP
            smasExtraSounds.playSFX(112)
        end
    end
end


function smasExtraSounds.onPostNPCHarm(npc, harmtype, player)
    if not Misc.isPaused() then
        if smasExtraSounds.active then
            for _,p in ipairs(Player.get()) do --This will get actions regards to the player itself
                
                
                
                --*BOSSES*
                --
                --*SMB1 Bowser*
                if harmtype ~= HARM_TYPE_VANISH then
                    if npc.id == 200 then --Play the hurt sound when hurting SMB1 Bowser
                        smasExtraSounds.playSFX(39)
                    end
                    --*SMB3 Bowser*
                    if npc.id == 86 then --Play the hurt sound when hurting SMB3 Bowser
                        smasExtraSounds.playSFX(39)
                    end
                    --*SMB3 Boom Boom*
                    if npc.id == 15 then --Play the hurt sound when hurting SMB3 Boom Boom
                        smasExtraSounds.playSFX(39)
                    end
                    --*SMB3 Larry Koopa*
                    if npc.id == 267 or npc.id == 268 then --Play the hurt sound when hurting SMB3 Larry Koopa
                        smasExtraSounds.playSFX(39)
                    end
                    --*SMB2 Birdo*
                    if npc.id == 39 then --Play the hurt sound when hurting SMB2 Birdo
                        smasExtraSounds.playSFX(39)
                    end
                    --*SMB2 Mouser*
                    if npc.id == 262 then --Play the hurt sound when hurting SMB2 Mouser
                        smasExtraSounds.playSFX(39)
                    end
                    --*SMB2 Wart*
                    if npc.id == 201 then --Play the hurt sound when hurting SMB2 Wart
                        smasExtraSounds.playSFX(39)
                    end
                end
                
                
                
                
                --**COMBO SOUNDS**
                if not isOverworld then
                    if smasExtraSounds.harmableComboTypes[harmtype] then
                        Audio.sounds[9].muted = true
                        comboMuteTally = 2
                        Routine.run(smasExtraSounds.comboSoundRoutine)
                    end
                end
                
                
                
            end
        end
    end
end

function smasExtraSounds.tempMuteBlockHit()
    Routine.waitFrames(3)
    Audio.sounds[3].muted = false
end

function smasExtraSounds.onNPCKill(eventToken, npc, harmtype)
    if not Misc.isPaused() then
        if smasExtraSounds.active then
            for _,p in ipairs(Player.get()) do --This will get actions regards to the player itself
                
                --Code goes here
                
            end
        end
    end
end

function smasExtraSounds.playDragonCoinSFX(npc)
    if not smasExtraSounds.useOriginalDragonCoinSounds then
        if NPC.config[npc.id].score == 7 then
            smasExtraSounds.playSFX(59)
        elseif NPC.config[npc.id].score == 8 then
            smasExtraSounds.playSFX(99)
        elseif NPC.config[npc.id].score == 9 then
            smasExtraSounds.playSFX(100)
        elseif NPC.config[npc.id].score == 10 then
            smasExtraSounds.playSFX(101)
        elseif NPC.config[npc.id].score == 11 then
            smasExtraSounds.playSFX(102)
        end
    elseif smasExtraSounds.useOriginalDragonCoinSounds then
        if NPC.config[npc.id].score == 7 then
            smasExtraSounds.playSFX(59)
        elseif NPC.config[npc.id].score == 8 then
            smasExtraSounds.playSFX(59)
        elseif NPC.config[npc.id].score == 9 then
            smasExtraSounds.playSFX(59)
        elseif NPC.config[npc.id].score == 10 then
            smasExtraSounds.playSFX(59)
        elseif NPC.config[npc.id].score == 11 then
            smasExtraSounds.playSFX(59)
        end
    end
end

function smasExtraSounds.onPostNPCKill(npc, harmtype) --NPC Kill stuff, for custom coin sounds and etc.
    if not Misc.isPaused() then
        if smasExtraSounds.active then
            for _,p in ipairs(Player.get()) do --This will get actions regards to the player itself
                
                
                
                
                --**STOMPING**
                if harmtype == HARM_TYPE_JUMP then
                    if smasExtraSounds.enableEnemyStompingSFX then
                        --smasExtraSounds.playSFX(2)
                    end
                end
                
                
                
                
                
                --**FIREBALL HIT**
                if npc.id == 13 and harmtype ~= HARM_TYPE_VANISH then
                    if smasExtraSounds.enableFireFlowerHitting then
                        smasExtraSounds.playSFX(155)
                    end
                end
                
                
                
                
                --**FIREBALL HAMMER SUIT SHIELD HIT (SFX)**
                for k,v in ipairs(NPC.getIntersecting(p.x - 15, p.y - 15, p.x + p.width + 30, p.y + p.height + 30)) do
                    if ((p.powerup == 6 and p:mem(0x12E,FIELD_BOOL) and p.mount == 0 and not linkCharacters[p.character]) or (p.mount == 1 and p.mountColor == 2) and enemyfireballs[v.id] and harmtype == HARM_TYPE_VANISH) then
                        if smasExtraSounds.enableFireballHammerShieldHitSFX then
                            smasExtraSounds.playSFX(169)
                        end
                    end
                end
                
                
                
                
                --**ICE BREAKING**
                if npc.id == 263 and harmtype ~= HARM_TYPE_VANISH then
                    if smasExtraSounds.enableIceBlockBreaking then
                        smasExtraSounds.playSFX(95)
                    end
                end
                
                
                
                
                
                --**HP COLLECTING**
                if healitems[npc.id] and Colliders.collide(p, npc) then
                    if p.character == CHARACTER_PEACH or p.character == CHARACTER_TOAD or p.character == CHARACTER_LINK or p.character == CHARACTER_KLONOA or p.character == CHARACTER_ROSALINA or p.character == CHARACTER_ULTIMATERINKA or p.character == CHARACTER_STEVE then
                        if p:mem(0x16, FIELD_WORD) <= 2 then
                            if smasExtraSounds.enableHPCollecting then
                                smasExtraSounds.playSFX(131)
                            end
                        elseif p:mem(0x16, FIELD_WORD) == 3 then
                            if smasExtraSounds.enableHPCollecting then
                                smasExtraSounds.playSFX(132)
                            end
                        end
                    end
                end
                
                
                
                --**PLAYER SMASHING**
                if allsmallenemies[npc.id] and harmtype == HARM_TYPE_SPINJUMP then
                    smasExtraSounds.playSFX(36)
                end
                if npc.id >= 751 and harmtype == HARM_TYPE_SPINJUMP then
                    smasExtraSounds.playSFX(36)
                end
                if allbigenemies[npc.id] and harmtype == HARM_TYPE_SPINJUMP then
                    if not smasExtraSounds.useOriginalSpinJumpForBigEnemies then
                        smasExtraSounds.playSFX(125)
                    elseif smasExtraSounds.useOriginalSpinJumpForBigEnemies then
                        smasExtraSounds.playSFX(36)
                    end
                end
                
                
                
                
                --**COIN COLLECTING**
                if coins[npc.id] and Colliders.collide(p, npc) then --Any coin ID that was marked above will play this sound when collected
                    if smasExtraSounds.enableCoinCollecting then
                        smasExtraSounds.playSFX(14)
                    end
                end
                if otherCoinSoundsMap[npc.id] and Colliders.collide(p, npc) then --Any coin ID that was marked above will play this sound when collected
                    if smasExtraSounds.enableRupeeCollecting then
                        smasExtraSounds.playSFX(81)
                    end
                end
                
                
                
                
                --**CHERRY COLLECTING**
                if npc.id == 558 and Colliders.collide(p, npc) then --Cherry sound effect
                    if smasExtraSounds.enableCherryCollecting then
                        smasExtraSounds.playSFX(103)
                    end
                end
                
                
                
                
                --**ICE BLOCKS (THROW BLOCKS)**
                if npc.id == 45 and npc.ai2 < 449 then
                    if smasExtraSounds.enableBrickSmashing then
                        smasExtraSounds.playSFX(4)
                    end
                end
                
                
                
                --**SMW POWER STARS**
                if npc.id == 196 then
                    if smasExtraSounds.enableStarCollecting then
                        smasExtraSounds.playSFX(59)
                    end
                end
                
                
                
                
                --**DRAGON COINS**
                if npc.id == 274 and Colliders.collide(p, npc) then --Dragon coin counter sounds
                    smasExtraSounds.playDragonCoinSFX(npc)
                end
                
                
                
                --**SMB2 ENEMY KILLS**
                for k,v in ipairs(NPC.get({19,20,25,130,131,132,470,471,129,345,346,347,371,372,373,272,350,530,374,247,206})) do --SMB2 Enemies
                    if (v.killFlag ~= 0) and not (v.killFlag == HARM_TYPE_VANISH) then
                        if smasExtraSounds.enableSMB2EnemyKillSounds then
                            smasExtraSounds.playSFX(126)
                        end
                    end
                end
                
                
                
                --**SLIDING COMBO KILLS**
                if p:mem(0x3C, FIELD_BOOL) and smasExtraSounds.harmableComboTypes[harmtype] then
                    Audio.sounds[9].muted = true
                    comboMuteTally = 2
                    Routine.run(smasExtraSounds.comboSoundRoutine)
                end
                
                
            end
        end
    end
end

--New event stuff
local GM_NEWEVENT = mem(0x00B2D6E8, FIELD_DWORD)
local GM_NEWEVENTDELAY = mem(0x00B2D704, FIELD_DWORD)

--Event stuff
local GM_EVENT = mem(0x00B2C6CC, FIELD_DWORD)
local GM_EVENTNUM = 0x00B2D710

local EVENTS_STRUCT_SIZE = 0x588
local MAX_EVENTS = 255

function smasExtraSounds.getSoundID(eventName)
    local idxNumber
    local name = {}
    for idx=0,MAX_EVENTS-1 do
        table.insert(name, mem(GM_EVENT+(idx*EVENTS_STRUCT_SIZE)+0x04,FIELD_STRING))
    end
    idxNumber = table.ifind(name, eventName) - 1
    if idxNumber == nil then
        return 0
    elseif idxNumber ~= nil then
        return mem(GM_EVENT+(idxNumber*EVENTS_STRUCT_SIZE)+0x02,FIELD_WORD)
    end
end

function smasExtraSounds.onEvent(eventName)
    --if eventName then --Fixes vanilla events from not playing smasExtraSounds sounds
        --if smasExtraSounds.getSoundID(eventName) >= 1 and not smasExtraSounds.stockSoundNumbersInOrder[smasExtraSounds.getSoundID(eventName)] then
            --smasExtraSounds.playSFX(smasExtraSounds.getSoundID(eventName))
        --end
    --end
end

return smasExtraSounds --This ends the library