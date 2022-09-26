--[[

    Accurate SMW Mario & Luigi Costume
    by MrDoubleA & DarSonic55

    See _notes.txt for more

]]

local playerManager = require("playerManager")
local extrasounds = require("extrasounds")

local costume = {}

local players = {}

local doPSpeedAnimation = true


local useFallingFrame = false
local usePSpeedFrames = false

local timers = {}

local walkFrames = {}
walkFrames[PLAYER_SMALL] = table.map{1,2,5,6,16,17}
walkFrames[PLAYER_BIG  ] = table.map{1,2,3,8,9,10,16,17,18}

local leafFallingFrames = table.map{3,5,11,29}
local leafPowerups = table.map{4,5}

local neededPSpeed = { -- How long the player has to be running for the p-speed animation to start
    [CHARACTER_MARIO] = 35,
    [CHARACTER_LUIGI] = 40,
}

-- Copied from unclebroadsword.lua by Ohmato/Arabsalmon
local function canDuck(p)
    -- Ignore if not holding down or not small
    if not p.keys.down or (p.powerup ~= PLAYER_SMALL and p:mem(0x154, FIELD_WORD) == 0) then return false end
    
    -- Check if dead
    if p:mem(0x13e, FIELD_WORD) > 0 then return false end
    -- Check if submerged and standing on the ground
    if (p:mem(0x34, FIELD_WORD) ~= 0 or p:mem(0x36, FIELD_WORD) ~= 0)
    and not p:isGroundTouching() then return false end
    -- Check if on a slope and not underwater
    if p:mem(0x48, FIELD_WORD) ~= 0 and p:mem(0x36, FIELD_WORD) == 0 then return false end
    -- Check if sliding, climbing, holding an item, in statue form, or spinjumping
    if p:mem(0x3c, FIELD_WORD) ~= 0
    or p:mem(0x40, FIELD_WORD) ~= 0
    --or p:mem(0x154, FIELD_WORD) > 0
    or p:mem(0x4a, FIELD_WORD) == -1
    or p:mem(0x50, FIELD_WORD) ~= 0 then return false end
    -- Check if pulling an item from the ground
    if p:mem(0x26,FIELD_WORD) > 0 then return false end
    -- Check if on a mount or riding a rainbow shell
    if p.mount > 0 or p:mem(0x44,FIELD_BOOL) then return end
    -- Check if in a forced animation
    if p.forcedState == 1    -- Powering up
    or p.forcedState == 2    -- Powering down
    or p.forcedState == 3    -- Entering pipe
    or p.forcedState == 4    -- Getting fire flower
    or p.forcedState == 7    -- Entering door
    or p.forcedState == 41    -- Getting ice flower
    or p.forcedState == 500 then return false end
    
    return true
end

function costume.onInit(playerObj)
    extrasounds.sound.sfx[1] = Audio.SfxOpen("costumes/mario/Modern2/player-jump.ogg")
    Audio.sounds[2].sfx  = Audio.SfxOpen("costumes/mario/Modern2/stomped.ogg")
    Audio.sounds[3].sfx  = Audio.SfxOpen("costumes/mario/Modern2/block-hit.ogg")
    extrasounds.sound.sfx[4]  = Audio.SfxOpen(Misc.resolveSoundFile("costumes/mario/Modern2/block-smash.ogg"))
    Audio.sounds[5].sfx  = Audio.SfxOpen("costumes/mario/Modern2/player-shrink.ogg")
    Audio.sounds[6].sfx  = Audio.SfxOpen("costumes/mario/Modern2/player-grow.ogg")
    extrasounds.sound.sfx[7]  = Audio.SfxOpen(Misc.resolveSoundFile("costumes/mario/Modern2/mushroom.ogg"))
    extrasounds.sound.sfx[8]  = Audio.SfxOpen(Misc.resolveSoundFile("costumes/mario/Modern2/player-died.ogg"))
    Audio.sounds[9].sfx  = Audio.SfxOpen("costumes/mario/Modern2/shell-hit.ogg")
    extrasounds.sound.sfx[10] = Audio.SfxOpen("costumes/mario/Modern2/player-slide.ogg")
    Audio.sounds[11].sfx = Audio.SfxOpen("costumes/mario/Modern2/item-dropped.ogg")
    Audio.sounds[12].sfx = Audio.SfxOpen("costumes/mario/Modern2/has-item.ogg")
    Audio.sounds[13].sfx = Audio.SfxOpen("costumes/mario/Modern2/camera-change.ogg")
    extrasounds.sound.sfx[14] = Audio.SfxOpen(Misc.resolveSoundFile("costumes/mario/Modern2/coin.ogg"))
    extrasounds.sound.sfx[15] = Audio.SfxOpen(Misc.resolveSoundFile("costumes/mario/Modern2/1up.ogg"))
    Audio.sounds[16].sfx = Audio.SfxOpen("costumes/mario/Modern2/lava.ogg")
    Audio.sounds[17].sfx = Audio.SfxOpen("costumes/mario/Modern2/warp.ogg")
    extrasounds.sound.sfx[18] = Audio.SfxOpen(Misc.resolveSoundFile("costumes/mario/Modern2/fireball.ogg"))
    Audio.sounds[19].sfx = Audio.SfxOpen("costumes/mario/Modern2/level-win.ogg")
    Audio.sounds[20].sfx = Audio.SfxOpen("costumes/mario/Modern2/boss-beat.ogg")
    Audio.sounds[21].sfx = Audio.SfxOpen("costumes/mario/Modern2/dungeon-win.ogg")
    Audio.sounds[22].sfx = Audio.SfxOpen("costumes/mario/Modern2/bullet-bill.ogg")
    Audio.sounds[23].sfx = Audio.SfxOpen("costumes/mario/Modern2/grab.ogg")
    Audio.sounds[24].sfx = Audio.SfxOpen("costumes/mario/Modern2/spring.ogg")
    Audio.sounds[25].sfx = Audio.SfxOpen("costumes/mario/Modern2/hammer.ogg")
    Audio.sounds[29].sfx = Audio.SfxOpen("costumes/mario/Modern2/do.ogg")
    Audio.sounds[31].sfx = Audio.SfxOpen("costumes/mario/Modern2/key.ogg")
    Audio.sounds[32].sfx = Audio.SfxOpen("costumes/mario/Modern2/pswitch.ogg")
    extrasounds.sound.sfx[33] = Audio.SfxOpen("costumes/mario/Modern2/tail.ogg")
    Audio.sounds[34].sfx = Audio.SfxOpen("costumes/mario/Modern2/racoon.ogg")
    Audio.sounds[35].sfx = Audio.SfxOpen("costumes/mario/Modern2/boot.ogg")
    extrasounds.sound.sfx[36] = Audio.SfxOpen(Misc.resolveSoundFile("costumes/mario/Modern2/smash.ogg"))
    Audio.sounds[37].sfx = Audio.SfxOpen("costumes/mario/Modern2/thwomp.ogg")
    Audio.sounds[38].sfx = Audio.SfxOpen("costumes/mario/Modern2/birdo-spit.ogg")
    --extrasounds.sound.sfx[39] = Audio.SfxOpen(Misc.resolveSoundFile("costumes/mario/Modern2/birdo-hit.ogg"))
    Audio.sounds[41].sfx = Audio.SfxOpen("costumes/mario/Modern2/birdo-beat.ogg")
    extrasounds.sound.sfx[42] = Audio.SfxOpen(Misc.resolveSoundFile("costumes/mario/Modern2/npc-fireball.ogg"))
    extrasounds.sound.sfx[43] = Audio.SfxOpen(Misc.resolveSoundFile("costumes/mario/Modern2/fireworks.ogg"))
    Audio.sounds[44].sfx = Audio.SfxOpen("costumes/mario/Modern2/bowser-killed.ogg")
    Audio.sounds[46].sfx = Audio.SfxOpen("costumes/mario/Modern2/door.ogg")
    Audio.sounds[47].sfx = Audio.SfxOpen("costumes/mario/Modern2/message.ogg")
    Audio.sounds[48].sfx = Audio.SfxOpen("costumes/mario/Modern2/yoshi.ogg")
    Audio.sounds[49].sfx = Audio.SfxOpen("costumes/mario/Modern2/yoshi-hurt.ogg")
    Audio.sounds[50].sfx = Audio.SfxOpen("costumes/mario/Modern2/yoshi-tongue.ogg")
    Audio.sounds[51].sfx = Audio.SfxOpen("costumes/mario/Modern2/yoshi-egg.ogg")
    Audio.sounds[52].sfx = Audio.SfxOpen("costumes/mario/Modern2/got-star.ogg")
    Audio.sounds[54].sfx = Audio.SfxOpen("costumes/mario/Modern2/player-died2.ogg")
    Audio.sounds[55].sfx = Audio.SfxOpen("costumes/mario/Modern2/yoshi-swallow.ogg")
    Audio.sounds[57].sfx = Audio.SfxOpen("costumes/mario/Modern2/dry-bones.ogg")
    Audio.sounds[58].sfx = Audio.SfxOpen("costumes/mario/Modern2/smw-checkpoint.ogg")
    extrasounds.sound.sfx[59] = Audio.SfxOpen(Misc.resolveSoundFile("costumes/mario/Modern2/dragon-coin.ogg"))
    Audio.sounds[61].sfx = Audio.SfxOpen("costumes/mario/Modern2/smw-blaarg.ogg")
    Audio.sounds[62].sfx = Audio.SfxOpen("costumes/mario/Modern2/wart-bubble.ogg")
    Audio.sounds[63].sfx = Audio.SfxOpen("costumes/mario/Modern2/wart-die.ogg")
    Audio.sounds[71].sfx = Audio.SfxOpen("costumes/mario/Modern2/climbing.ogg")
    Audio.sounds[72].sfx = Audio.SfxOpen("costumes/mario/Modern2/swim.ogg")
    Audio.sounds[73].sfx = Audio.SfxOpen("costumes/mario/Modern2/grab2.ogg")
    --Audio.sounds[74].sfx = Audio.SfxOpen("costumes/mario/Modern2/saw.ogg")
    Audio.sounds[75].sfx = Audio.SfxOpen("costumes/mario/Modern2/smb2-throw.ogg")
    Audio.sounds[76].sfx = Audio.SfxOpen("costumes/mario/Modern2/smb2-hit.ogg")
    Audio.sounds[91].sfx = Audio.SfxOpen("costumes/mario/Modern2/bubble.ogg")
    extrasounds.sound.sfx[92] = Audio.SfxOpen(Misc.resolveSoundFile("costumes/mario/Modern2/sprout-vine.ogg")) --Vine sprout
    extrasounds.sound.sfx[93] = Audio.SfxOpen(Misc.resolveSoundFile("costumes/mario/Modern2/iceball.ogg")) --Iceball
    extrasounds.sound.sfx[96] = Audio.SfxOpen(Misc.resolveSoundFile("costumes/mario/Modern2/2up.ogg")) --2UP
    extrasounds.sound.sfx[97] = Audio.SfxOpen(Misc.resolveSoundFile("costumes/mario/Modern2/3up.ogg")) --3UP
    extrasounds.sound.sfx[98] = Audio.SfxOpen(Misc.resolveSoundFile("costumes/mario/Modern2/5up.ogg")) --5UP
    extrasounds.sound.sfx[99] = Audio.SfxOpen(Misc.resolveSoundFile("costumes/mario/Modern2/dragon-coin-get2.ogg")) --Dragon Coin #2
    extrasounds.sound.sfx[100] = Audio.SfxOpen(Misc.resolveSoundFile("costumes/mario/Modern2/dragon-coin-get3.ogg")) --Dragon Coin #3
    extrasounds.sound.sfx[101] = Audio.SfxOpen(Misc.resolveSoundFile("costumes/mario/Modern2/dragon-coin-get4.ogg")) --Dragon Coin #4
    extrasounds.sound.sfx[102] = Audio.SfxOpen(Misc.resolveSoundFile("costumes/mario/Modern2/dragon-coin-get5.ogg")) --Dragon Coin #5
    extrasounds.sound.sfx[103] = Audio.SfxOpen(Misc.resolveSoundFile("costumes/mario/Modern2/cherry.ogg")) --Cherry
    extrasounds.sound.sfx[104] = Audio.SfxOpen(Misc.resolveSoundFile("costumes/mario/Modern2/explode.ogg")) --SMB2 Explosion
    extrasounds.sound.sfx[105] = Audio.SfxOpen(Misc.resolveSoundFile("costumes/mario/Modern2/hammerthrow.ogg")) --Player hammer throw
    extrasounds.sound.sfx[106] = Audio.SfxOpen(Misc.resolveSoundFile("costumes/mario/Modern2/combo1.ogg")) --Combo 1
    extrasounds.sound.sfx[107] = Audio.SfxOpen(Misc.resolveSoundFile("costumes/mario/Modern2/combo2.ogg")) --Combo 2
    extrasounds.sound.sfx[108] = Audio.SfxOpen(Misc.resolveSoundFile("costumes/mario/Modern2/combo3.ogg")) --Combo 3
    extrasounds.sound.sfx[109] = Audio.SfxOpen(Misc.resolveSoundFile("costumes/mario/Modern2/combo4.ogg")) --Combo 4
    extrasounds.sound.sfx[110] = Audio.SfxOpen(Misc.resolveSoundFile("costumes/mario/Modern2/combo5.ogg")) --Combo 5
    extrasounds.sound.sfx[111] = Audio.SfxOpen(Misc.resolveSoundFile("costumes/mario/Modern2/combo6.ogg")) --Combo 6
    extrasounds.sound.sfx[112] = Audio.SfxOpen(Misc.resolveSoundFile("costumes/mario/Modern2/combo7.ogg")) --Combo 7
    extrasounds.sound.sfx[113] = Audio.SfxOpen(Misc.resolveSoundFile("costumes/mario/Modern2/score-tally.ogg")) --Score tally
    extrasounds.sound.sfx[114] = Audio.SfxOpen(Misc.resolveSoundFile("costumes/mario/Modern2/score-tally-end.ogg")) --Score tally end
    extrasounds.sound.sfx[115] = Audio.SfxOpen(Misc.resolveSoundFile("costumes/mario/Modern2/bowser-fire.ogg")) --Bowser fire
    extrasounds.sound.sfx[116] = Audio.SfxOpen(Misc.resolveSoundFile("costumes/mario/Modern2/boomerang.ogg")) --Boomerang
    extrasounds.sound.sfx[117] = Audio.SfxOpen(Misc.resolveSoundFile("costumes/mario/Modern2/smb2-charge.ogg")) --SMB2 Charge
    extrasounds.sound.sfx[118] = Audio.SfxOpen(Misc.resolveSoundFile("costumes/mario/Modern2/stopwatch.ogg")) --Stopwatch
    extrasounds.sound.sfx[119] = Audio.SfxOpen(Misc.resolveSoundFile("costumes/mario/Modern2/whale-spout.ogg"))
    extrasounds.sound.sfx[120] = Audio.SfxOpen(Misc.resolveSoundFile("costumes/mario/Modern2/door-reveal.ogg"))
    extrasounds.sound.sfx[121] = Audio.SfxOpen(Misc.resolveSoundFile("costumes/mario/Modern2/p-wing.ogg"))
    extrasounds.sound.sfx[122] = Audio.SfxOpen(Misc.resolveSoundFile("wand-moving.ogg"))
    extrasounds.sound.sfx[123] = Audio.SfxOpen(Misc.resolveSoundFile("wand-whoosh.ogg"))
    extrasounds.sound.sfx[124] = Audio.SfxOpen(Misc.resolveSoundFile("costumes/mario/Modern2/hop.ogg"))
    extrasounds.sound.sfx[125] = Audio.SfxOpen(Misc.resolveSoundFile("costumes/mario/Modern2/smash-big.ogg"))
    extrasounds.sound.sfx[126] = Audio.SfxOpen(Misc.resolveSoundFile("smb2-hitenemy.ogg")) --SMB2 Hit Enemy
    extrasounds.sound.sfx[127] = Audio.SfxOpen(Misc.resolveSoundFile("costumes/mario/Modern2/boss-fall.ogg"))
    extrasounds.sound.sfx[128] = Audio.SfxOpen(Misc.resolveSoundFile("costumes/mario/Modern2/boss-lava.ogg"))
    extrasounds.sound.sfx[129] = Audio.SfxOpen(Misc.resolveSoundFile("costumes/mario/Modern2/boss-shrink.ogg"))
    extrasounds.sound.sfx[130] = Audio.SfxOpen(Misc.resolveSoundFile("costumes/mario/Modern2/boss-shrink-done.ogg"))
    extrasounds.sound.sfx[131] = Audio.SfxOpen(Misc.resolveSoundFile("costumes/mario/Modern2/hp-get.ogg"))
    extrasounds.sound.sfx[132] = Audio.SfxOpen(Misc.resolveSoundFile("costumes/mario/Modern2/hp-max.ogg"))
    extrasounds.sound.sfx[133] = Audio.SfxOpen(Misc.resolveSoundFile("costumes/mario/Modern2/cape-feather.ogg"))
    extrasounds.sound.sfx[134] = Audio.SfxOpen(Misc.resolveSoundFile("costumes/mario/Modern2/cape-fly.ogg"))
    extrasounds.sound.sfx[135] = Audio.SfxOpen(Misc.resolveSoundFile("costumes/mario/Modern2/flag-slide.ogg"))
    extrasounds.sound.sfx[136] = Audio.SfxOpen(Misc.resolveSoundFile("costumes/mario/Modern2/smb1-exit.ogg")) --SMB1 Exit
    extrasounds.sound.sfx[137] = Audio.SfxOpen(Misc.resolveSoundFile("costumes/mario/Modern2/smb2-clear.ogg"))
    extrasounds.sound.sfx[138] = Audio.SfxOpen(Misc.resolveSoundFile("costumes/mario/Modern2/smb1-world-clear.ogg"))
    extrasounds.sound.sfx[139] = Audio.SfxOpen(Misc.resolveSoundFile("smb1-underground-overworld.ogg"))
    extrasounds.sound.sfx[140] = Audio.SfxOpen(Misc.resolveSoundFile("smb1-underground-desert.ogg"))
    extrasounds.sound.sfx[141] = Audio.SfxOpen(Misc.resolveSoundFile("smb1-underground-sky.ogg"))
    extrasounds.sound.sfx[142] = Audio.SfxOpen(Misc.resolveSoundFile("costumes/mario/Modern2/goaltape-countdown-start.ogg"))
    extrasounds.sound.sfx[143] = Audio.SfxOpen(Misc.resolveSoundFile("costumes/mario/Modern2/goaltape-countdown-loop.ogg"))
    extrasounds.sound.sfx[144] = Audio.SfxOpen(Misc.resolveSoundFile("costumes/mario/Modern2/goaltape-countdown-end.ogg"))
    extrasounds.sound.sfx[145] = Audio.SfxOpen(Misc.resolveSoundFile("costumes/mario/Modern2/goaltape-irisout.ogg"))
    extrasounds.sound.sfx[146] = Audio.SfxOpen(Misc.resolveSoundFile("smw-exit-orb.ogg"))
    extrasounds.sound.sfx[147] = Audio.SfxOpen(Misc.resolveSoundFile("ace-coins-5.ogg"))
    extrasounds.sound.sfx[148] = Audio.SfxOpen(Misc.resolveSoundFile("costumes/mario/Modern2/door-close.ogg"))
    extrasounds.sound.sfx[149] = Audio.SfxOpen(Misc.resolveSoundFile("costumes/mario/Modern2/sprout-megashroom.ogg"))
    extrasounds.sound.sfx[150] = Audio.SfxOpen(Misc.resolveSoundFile("costumes/mario/Modern2/0up.ogg"))
    extrasounds.sound.sfx[151] = Audio.SfxOpen(Misc.resolveSoundFile("costumes/mario/Modern2/correct.ogg"))
    extrasounds.sound.sfx[152] = Audio.SfxOpen(Misc.resolveSoundFile("costumes/mario/Modern2/wrong.ogg"))
    extrasounds.sound.sfx[153] = Audio.SfxOpen(Misc.resolveSoundFile("costumes/mario/Modern2/castle-destroy.ogg"))
    extrasounds.sound.sfx[154] = Audio.SfxOpen(Misc.resolveSoundFile("costumes/mario/Modern2/twirl.ogg"))
    extrasounds.sound.sfx[155] = Audio.SfxOpen(Misc.resolveSoundFile("fireball-hit.ogg")) --Fireball hit
    extrasounds.sound.sfx[156] = Audio.SfxOpen(Misc.resolveSoundFile("costumes/mario/Modern2/shell-grab.ogg")) --Shell grab
    extrasounds.sound.sfx[157] = Audio.SfxOpen(Misc.resolveSoundFile("ice-melt.ogg"))
    extrasounds.sound.sfx[158] = Audio.SfxOpen(Misc.resolveSoundFile("costumes/mario/Modern2/player-jump2.ogg"))
    extrasounds.sound.sfx[159] = Audio.SfxOpen(Misc.resolveSoundFile("costumes/mario/Modern2/ground-pound.ogg"))
    extrasounds.sound.sfx[160] = Audio.SfxOpen(Misc.resolveSoundFile("costumes/mario/Modern2/ground-pound-hit.ogg"))
    extrasounds.sound.sfx[161] = Audio.SfxOpen(Misc.resolveSoundFile("zelda-fireball.ogg"))
    extrasounds.sound.sfx[162] = Audio.SfxOpen(Misc.resolveSoundFile("zelda-iceball.ogg"))
    extrasounds.sound.sfx[163] = Audio.SfxOpen(Misc.resolveSoundFile("costumes/mario/Modern2/pballoon.ogg"))
    extrasounds.sound.sfx[164] = Audio.SfxOpen(Misc.resolveSoundFile("costumes/mario/Modern2/peach-cry.ogg"))
    extrasounds.sound.sfx[165] = Audio.SfxOpen(Misc.resolveSoundFile("timeout.ogg"))
    extrasounds.sound.sfx[166] = Audio.SfxOpen(Misc.resolveSoundFile("flyinghammer-throw.ogg"))
    
    Graphics.sprites.npc[9].img = Graphics.loadImageResolved("costumes/mario/Modern2/npc-9.png")
    Graphics.sprites.npc[14].img = Graphics.loadImageResolved("costumes/mario/Modern2/npc-14.png")
    Graphics.sprites.npc[34].img = Graphics.loadImageResolved("costumes/mario/Modern2/npc-34.png")
    Graphics.sprites.npc[169].img = Graphics.loadImageResolved("costumes/mario/Modern2/npc-169.png")
    Graphics.sprites.npc[170].img = Graphics.loadImageResolved("costumes/mario/Modern2/npc-170.png")
    Graphics.sprites.npc[183].img = Graphics.loadImageResolved("costumes/mario/Modern2/npc-183.png")
    Graphics.sprites.npc[263].img = Graphics.loadImageResolved("costumes/mario/Modern2/npc-263.png")
    Graphics.sprites.npc[264].img = Graphics.loadImageResolved("costumes/mario/Modern2/npc-264.png")
    Graphics.sprites.npc[265].img = Graphics.loadImageResolved("costumes/mario/Modern2/npc-265.png")
    Graphics.sprites.npc[277].img = Graphics.loadImageResolved("costumes/mario/Modern2/npc-277.png")
    
    extrasounds.enableFireFlowerHitting = true
    
    registerEvent(costume, "onDraw")
    registerEvent(costume, "onTick")
    registerEvent(costume, "onTickEnd")
    
    if not table.ifind(players,playerObj) then
        table.insert(players,playerObj)
    end
    
    timers[playerObj] = {    
                            pSpeedTimer = 0, 
                            walkTimer = 0, 
                            kickTimer = 0, 
                            tailTimer = 0 -- For falling slowly with leaf/tanookie suit
                        }
end

function costume.onTick()
    for _,p in ipairs(players) do
        if canDuck(p) and p:isGroundTouching() then
            if p.keys.left == KEYS_PRESSED then
                p.direction = DIR_LEFT
            elseif p.keys.right == KEYS_PRESSED then
                p.direction = DIR_RIGHT
            end

            p:mem(0x12C,FIELD_BOOL,true)
            p:mem(0x12E,FIELD_BOOL,true)

            p.keys.left = KEYS_UP
            p.keys.right = KEYS_UP
        end
    end
end

function costume.onTickEnd()
    for _,p in ipairs(players) do
        if timers[p] then
            local settings = PlayerSettings.get(playerManager.getBaseID(p.character),p.powerup)

            if p.forcedState == 0 and p.deathTimer == 0 and not p:mem(0x13C,FIELD_BOOL) then
                if p:isGroundTouching() or p:mem(0x40,FIELD_WORD) > 0 then
                    useFallingFrame = false
                end

                -- P-Speed logic
                if not leafPowerups[p.powerup] and p:mem(0x34,FIELD_WORD) == 0 then
                    if p:isGroundTouching() and math.abs(p.speedX) >= Defines.player_runspeed then
                        timers[p].pSpeedTimer = math.min((neededPSpeed[p.character] or math.huge),timers[p].pSpeedTimer + 1)
                    elseif p:isGroundTouching() then
                        timers[p].pSpeedTimer = math.max(0,timers[p].pSpeedTimer - 0.3)
                    end
                end

                if doPSpeedAnimation and doPSpeedAnimation and timers[p].pSpeedTimer >= (neededPSpeed[p.character] or math.huge) then
                    if p.powerup == PLAYER_SMALL                                 and (p.frame == 3 or p.frame == 7)
                    or p.powerup ~= PLAYER_SMALL and not leafPowerups[p.powerup] and (p.frame == 4 or p.frame == 5)
                    then
                        p.frame = 19
                    end
                end


                if canDuck(p) then
                    if p:mem(0x154, FIELD_WORD) > 0 then
                        p.frame = 36

                        if p.direction == DIR_RIGHT then
                            p.holdingNPC.x = (p.x+settings.grabOffsetX)
                        else
                            p.holdingNPC.x = (p.x+p.width-settings.grabOffsetX-p.holdingNPC.width)
                        end
                        p.holdingNPC.y = (p.y+p.height-p.holdingNPC.height)
                    else
                        p.frame = 35
                    end

                    p:mem(0x12C,FIELD_BOOL,true)
                    p:mem(0x12E,FIELD_BOOL,true)
                elseif p:isGroundTouching() then
                    if p.speedX == 0 then
                        if p.keys.up and not p:mem(0x44,FIELD_BOOL) and p.mount == 0 then
                            if p.frame == 1 then
                                p.frame = 32
                            elseif (p.frame == 5 and p.powerup == 1) or (p.frame == 8 and p.powerup ~= 1) then
                                p.frame = 33
                            end
                        end
                    end
                elseif leafPowerups[p.powerup] and leafFallingFrames[p.frame] and (p.keys.jump or p.keys.altJump) then -- gotta love redigit
                    timers[p].tailTimer = (timers[p].tailTimer+1)%15

                    if timers[p].tailTimer < 5 then
                        p.frame = 11
                    elseif timers[p].tailTimer < 10 then
                        p.frame = 29
                    else
                        p.frame = 5
                    end
                else
                    if p.speedY > 0 or p.mount > 0 then
                        useFallingFrame = true
                    end

                    if useFallingFrame and (p.powerup == PLAYER_SMALL and p.frame == 3) then
                        p.frame = 7
                    elseif useFallingFrame and (p.powerup ~= PLAYER_SMALL and p.frame == 4) then
                        p.frame = 5
                    end
                end

                if p:mem(0x154,FIELD_WORD) > 0 then
                    timers[p].kickTimer = -1
                elseif timers[p].kickTimer < 0 then
                    if not p:mem(0x12E,FIELD_BOOL) then
                        local e = Effect.spawn(75,0,0)

                        e.x = (p.x+(p.width/2)+((p.width/2)*p.direction)-(e.width/2))
                        e.y = (p.y+(p.height/2)-(e.height/2))
                    end

                    timers[p].kickTimer = 16 -- Start kick animation if the player isn't holding an item, but was on the last frame
                elseif timers[p].kickTimer > 0 then
                    timers[p].kickTimer = timers[p].kickTimer - 1
                end
                if timers[p].kickTimer > 0 and not p:mem(0x12E,FIELD_BOOL) then
                    p.frame = 34
                end
            else
                timers[p].pSpeedTimer = 0
                timers[p].kickTimer = 0
            end

            if p.deathTimer == 0 and not p:mem(0x13C,FIELD_BOOL) then
                -- Change walk animation to be more like SMW
                local nearbyWarp = Warp(p:mem(0x15E,FIELD_WORD)-1)

                if  p.mount == 0
                and (p.forcedState == 0 and p.speedX ~= 0 and not p:mem(0x50,FIELD_BOOL) and (walkFrames[p.powerup] or walkFrames[PLAYER_BIG])[p.frame] and (p:mem(0x154,FIELD_WORD) == 0 or p:isGroundTouching())
                or   p.forcedState == 3 and (nearbyWarp and nearbyWarp.isValid and (nearbyWarp:mem(0x80,FIELD_WORD) == 2 or nearbyWarp:mem(0x80,FIELD_WORD) == 4))
                ) then
                    local frames = 3
                    local frameTime = 15

                    if p.powerup == PLAYER_SMALL then
                        frames = 2
                    end

                    if p.forcedState == 3 then
                        timers[p].walkTimer = (timers[p].walkTimer+1)%(frames*frameTime)
                    else
                        timers[p].walkTimer = (timers[p].walkTimer+math.max(1,math.abs(p.speedX)))%(frames*frameTime)
                    end

                    local frameOffset = 1
                    if p:mem(0x154,FIELD_WORD) > 0 then
                        if p.powerup == PLAYER_SMALL then
                            frameOffset = 5
                        else
                            frameOffset = 8
                        end
                    elseif p:mem(0x16C,FIELD_BOOL) or (doPSpeedAnimation and timers[p].pSpeedTimer >= (neededPSpeed[p.character] or math.huge)) then
                        frameOffset = 16
                    end

                    p.frame = (((frames*frameTime)-math.floor(timers[p].walkTimer)-1)/frameTime)+frameOffset
                else
                    timers[p].walkTimer = 0
                end
            end
        end
    end
end

function costume.onDraw()
    for _,v in ipairs(Animation.get(3)) do
        v.width = 32;
        v.height = 48;
    end
end

function costume.onCleanup(playerObj)
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
    Audio.sounds[91].sfx = nil
    for i = 92,165 do
        extrasounds.sound.sfx[i] = nil
    end
    
    Graphics.sprites.npc[9].img = nil
    Graphics.sprites.npc[14].img = nil
    Graphics.sprites.npc[34].img = nil
    Graphics.sprites.npc[169].img = nil
    Graphics.sprites.npc[170].img = nil
    Graphics.sprites.npc[183].img = nil
    Graphics.sprites.npc[263].img = nil
    Graphics.sprites.npc[264].img = nil
    Graphics.sprites.npc[265].img = nil
    Graphics.sprites.npc[277].img = nil
    
    extrasounds.enableFireFlowerHitting = false
    
    local spot = table.ifind(players,playerObj)

    timers[playerObj] = nil
    
    if spot then
        table.remove(players,spot)
    end
end

return costume;