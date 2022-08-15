local playersounds = {}

local ready = false

local climbsfxtimer = 1

local pipecounter = 1
local doorcounter = 1
local slidecounter = 1
local swallowcounter = 1
local pipecounter2 = 1
local doorcounter2 = 1
local slidecounter2 = 1
local swallowcounter2 = 1

playersounds.playersound0 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/nothing.ogg")) --General sound to mute anything, really

local path = "_OST/_Sound Effects/player"
playersounds.sounds = {}
for i=1, 2 do -- player indices
    playersounds.sounds[i] = {
        playerJump = Misc.resolveSoundFile(path .. i .. "/player-jump"),
        stomped = Misc.resolveSoundFile(path .. i .. "/stomped"),
        blockHit = Misc.resolveSoundFile(path .. i .. "/block-hit"),
        blockSmash = Misc.resolveSoundFile(path .. i .. "/block-smash"),
        playerShrink = Misc.resolveSoundFile(path .. i .. "/player-shrink"),
        playerGrow = Misc.resolveSoundFile(path .. i .. "/player-grow"),
        mushroom = Misc.resolveSoundFile(path .. i .. "/mushroom")
    }
end

--Player(1)
playersounds.playeronesound1 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/player-jump.ogg"))
playersounds.playeronesound2 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/stomped.ogg"))
playersounds.playeronesound3 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/block-hit.ogg"))
playersounds.playeronesound4 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/block-smash.ogg"))
playersounds.playeronesound5 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/player-shrink.ogg"))
playersounds.playeronesound6 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/player-grow.ogg"))
playersounds.playeronesound7 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/mushroom.ogg"))
playersounds.playeronesound8 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/player-died.ogg"))
playersounds.playeronesound9 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/shell-hit.ogg"))
playersounds.playeronesound10 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/player-slide.ogg"))
playersounds.playeronesound11 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/item-dropped.ogg"))
playersounds.playeronesound12 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/has-item.ogg"))
playersounds.playeronesound13 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/camera-change.ogg"))
playersounds.playeronesound14 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/coin.ogg"))
playersounds.playeronesound15 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/1up.ogg"))
playersounds.playeronesound16 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/lava.ogg"))
playersounds.playeronesound17 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/warp.ogg"))
playersounds.playeronesound18 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/fireball.ogg"))
playersounds.playeronesound19 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/level-win.ogg"))
playersounds.playeronesound20 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/boss-beat.ogg"))
playersounds.playeronesound21 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/dungeon-win.ogg"))
playersounds.playeronesound22 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/bullet-bill.ogg"))
playersounds.playeronesound23 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/grab.ogg"))
playersounds.playeronesound24 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/spring.ogg"))
playersounds.playeronesound25 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/hammer.ogg"))
playersounds.playeronesound26 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/slide.ogg"))
playersounds.playeronesound27 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/newpath.ogg"))
playersounds.playeronesound28 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/level-select.ogg"))
playersounds.playeronesound29 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/do.ogg"))
playersounds.playeronesound30 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/pause.ogg"))
playersounds.playeronesound31 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/key.ogg"))
playersounds.playeronesound32 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/pswitch.ogg"))
playersounds.playeronesound33 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/tail.ogg"))
playersounds.playeronesound34 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/racoon.ogg"))
playersounds.playeronesound35 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/boot.ogg"))
playersounds.playeronesound36 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/smash.ogg"))
playersounds.playeronesound37 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/thwomp.ogg"))
playersounds.playeronesound38 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/birdo-spit.ogg"))
playersounds.playeronesound39 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/birdo-hit.ogg"))
playersounds.playeronesound40 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/smb2-exit.ogg"))
playersounds.playeronesound41 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/birdo-beat.ogg"))
playersounds.playeronesound42 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/npc-fireball.ogg"))
playersounds.playeronesound43 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/fireworks.ogg"))
playersounds.playeronesound44 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/bowser-killed.ogg"))
playersounds.playeronesound45 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/game-beat.ogg"))
playersounds.playeronesound46 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/door.ogg"))
playersounds.playeronesound47 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/message.ogg"))
playersounds.playeronesound48 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/yoshi.ogg"))
playersounds.playeronesound49 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/yoshi-hurt.ogg"))
playersounds.playeronesound50 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/yoshi-tongue.ogg"))
playersounds.playeronesound51 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/yoshi-egg.ogg"))
playersounds.playeronesound52 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/got-star.ogg"))
playersounds.playeronesound53 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/zelda-kill.ogg"))
playersounds.playeronesound54 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/player-died2.ogg"))
playersounds.playeronesound55 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/yoshi-swallow.ogg"))
playersounds.playeronesound56 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/ring.ogg"))
playersounds.playeronesound57 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/dry-bones.ogg"))
playersounds.playeronesound58 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/smw-checkpoint.ogg"))
playersounds.playeronesound59 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/dragon-coin.ogg"))
playersounds.playeronesound60 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/smw-exit.ogg"))
playersounds.playeronesound61 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/smw-blaarg.ogg"))
playersounds.playeronesound62 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/wart-bubble.ogg"))
playersounds.playeronesound63 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/wart-die.ogg"))
playersounds.playeronesound64 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/sm-block-hit.ogg"))
playersounds.playeronesound65 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/sm-killed.ogg"))
playersounds.playeronesound66 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/sm-hurt.ogg"))
playersounds.playeronesound67 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/sm-glass.ogg"))
playersounds.playeronesound68 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/sm-boss-hit.ogg"))
playersounds.playeronesound69 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/sm-cry.ogg"))
playersounds.playeronesound70 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/sm-explosion.ogg"))
playersounds.playeronesound71 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/climbing.ogg"))
playersounds.playeronesound72 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/swim.ogg"))
playersounds.playeronesound73 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/grab2.ogg"))
playersounds.playeronesound74 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/smw-saw.ogg"))
playersounds.playeronesound75 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/smb2-throw.ogg"))
playersounds.playeronesound76 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/smb2-hit.ogg"))
playersounds.playeronesound77 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/zelda-stab.ogg"))
playersounds.playeronesound78 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/zelda-hurt.ogg"))
playersounds.playeronesound79 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/zelda-heart.ogg"))
playersounds.playeronesound80 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/zelda-died.ogg"))
playersounds.playeronesound81 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/zelda-rupee.ogg"))
playersounds.playeronesound82 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/zelda-fire.ogg"))
playersounds.playeronesound83 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/zelda-item.ogg"))
playersounds.playeronesound84 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/zelda-key.ogg"))
playersounds.playeronesound85 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/zelda-shield.ogg"))
playersounds.playeronesound86 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/zelda-dash.ogg"))
playersounds.playeronesound87 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/zelda-fairy.ogg"))
playersounds.playeronesound88 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/zelda-grass.ogg"))
playersounds.playeronesound89 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/zelda-hit.ogg"))
playersounds.playeronesound90 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/zelda-sword-beam.ogg"))
playersounds.playeronesound92 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/sprout-vine.ogg"))
playersounds.playeronesound93 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/iceball.ogg"))
playersounds.playeronesound94 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/yi_freeze.ogg"))
playersounds.playeronesound95 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/yi_icebreak.ogg"))
playersounds.playeronesound96 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/2up.ogg"))
playersounds.playeronesound97 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/3up.ogg"))
playersounds.playeronesound98 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/5up.ogg"))
playersounds.playeronesound99 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/dragon-coin-get2.ogg"))
playersounds.playeronesound100 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/dragon-coin-get3.ogg"))
playersounds.playeronesound101 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/dragon-coin-get4.ogg"))
playersounds.playeronesound102 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/dragon-coin-get5.ogg"))

--Player(2)
playersounds.playertwosound1 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player2/player-jump2.ogg"))
playersounds.playertwosound2 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player2/stomped2.ogg"))
playersounds.playertwosound3 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player2/block-hit2.ogg"))
playersounds.playertwosound4 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player2/block-smash2.ogg"))
playersounds.playertwosound5 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player2/player-shrink2.ogg"))
playersounds.playertwosound6 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player2/player-grow2.ogg"))
playersounds.playertwosound7 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player2/mushroom2.ogg"))
playersounds.playertwosound8 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player2/player2-died.ogg"))
playersounds.playertwosound9 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player2/shell-hit2.ogg"))
playersounds.playertwosound10 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player2/player-slide2.ogg"))
playersounds.playertwosound11 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player2/item-dropped2.ogg"))
playersounds.playertwosound12 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player2/has-item2.ogg"))
playersounds.playertwosound13 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player2/camera-change2.ogg"))
playersounds.playertwosound14 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player2/coin2.ogg"))
playersounds.playertwosound15 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player2/1up2.ogg"))
playersounds.playertwosound16 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player2/lava2.ogg"))
playersounds.playertwosound17 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player2/warp2.ogg"))
playersounds.playertwosound18 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player2/fireball2.ogg"))
playersounds.playertwosound19 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player2/level-win2.ogg"))
playersounds.playertwosound20 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player2/boss-beat2.ogg"))
playersounds.playertwosound21 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player2/dungeon-win2.ogg"))
playersounds.playertwosound22 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player2/bullet-bill2.ogg"))
playersounds.playertwosound23 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player2/grab-p2.ogg"))
playersounds.playertwosound24 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player2/spring2.ogg"))
playersounds.playertwosound25 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player2/hammer2.ogg"))
playersounds.playertwosound26 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player2/slide2.ogg"))
playersounds.playertwosound27 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player2/newpath2.ogg"))
playersounds.playertwosound28 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player2/level-select2.ogg"))
playersounds.playertwosound29 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player2/do2.ogg"))
playersounds.playertwosound30 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player2/pause2.ogg"))
playersounds.playertwosound31 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player2/key2.ogg"))
playersounds.playertwosound32 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player2/pswitch2.ogg"))
playersounds.playertwosound33 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player2/tail2.ogg"))
playersounds.playertwosound34 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player2/racoon2.ogg"))
playersounds.playertwosound35 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player2/boot2.ogg"))
playersounds.playertwosound36 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player2/smash2.ogg"))
playersounds.playertwosound37 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player2/thwomp2.ogg"))
playersounds.playertwosound38 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player2/birdo-spit2.ogg"))
playersounds.playertwosound39 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player2/birdo-hit2.ogg"))
playersounds.playertwosound40 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player2/smb2-exit2.ogg"))
playersounds.playertwosound41 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player2/birdo-beat2.ogg"))
playersounds.playertwosound42 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player2/npc-fireball2.ogg"))
playersounds.playertwosound43 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player2/fireworks2.ogg"))
playersounds.playertwosound44 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player2/bowser-killed2.ogg"))
playersounds.playertwosound45 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player2/game-beat2.ogg"))
playersounds.playertwosound46 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player2/door2.ogg"))
playersounds.playertwosound47 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player2/message2.ogg"))
playersounds.playertwosound48 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player2/yoshi2.ogg"))
playersounds.playertwosound49 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player2/yoshi-hurt2.ogg"))
playersounds.playertwosound50 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player2/yoshi-tongue2.ogg"))
playersounds.playertwosound51 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player2/yoshi-egg2.ogg"))
playersounds.playertwosound52 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player2/got-star2.ogg"))
playersounds.playertwosound53 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player2/zelda-kill2.ogg"))
playersounds.playertwosound54 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player2/player2-died2.ogg"))
playersounds.playertwosound55 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player2/yoshi-swallow2.ogg"))
playersounds.playertwosound56 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player2/ring2.ogg"))
playersounds.playertwosound57 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player2/dry-bones2.ogg"))
playersounds.playertwosound58 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player2/smw-checkpoint2.ogg"))
playersounds.playertwosound59 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player2/dragon-coin2.ogg"))
playersounds.playertwosound60 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player2/smw-exit2.ogg"))
playersounds.playertwosound61 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player2/smw-blaarg2.ogg"))
playersounds.playertwosound62 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player2/wart-bubble2.ogg"))
playersounds.playertwosound63 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player2/wart-die2.ogg"))
playersounds.playertwosound64 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player2/sm-block-hit2.ogg"))
playersounds.playertwosound65 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player2/sm-killed2.ogg"))
playersounds.playertwosound66 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player2/sm-hurt2.ogg"))
playersounds.playertwosound67 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player2/sm-glass2.ogg"))
playersounds.playertwosound68 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player2/sm-boss-hit2.ogg"))
playersounds.playertwosound69 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player2/sm-cry2.ogg"))
playersounds.playertwosound70 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player2/sm-explosion2.ogg"))
playersounds.playertwosound71 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player2/climbing2.ogg"))
playersounds.playertwosound72 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player2/swim2.ogg"))
playersounds.playertwosound73 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player2/grab2-p2.ogg"))
playersounds.playertwosound74 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player2/smw-saw2.ogg"))
playersounds.playertwosound75 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player2/smb2-throw2.ogg"))
playersounds.playertwosound76 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player2/smb2-hit2.ogg"))
playersounds.playertwosound77 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player2/zelda-stab2.ogg"))
playersounds.playertwosound78 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player2/zelda-hurt2.ogg"))
playersounds.playertwosound79 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player2/zelda-heart2.ogg"))
playersounds.playertwosound80 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player2/zelda-died2.ogg"))
playersounds.playertwosound81 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player2/zelda-rupee2.ogg"))
playersounds.playertwosound82 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player2/zelda-fire2.ogg"))
playersounds.playertwosound83 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player2/zelda-item2.ogg"))
playersounds.playertwosound84 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player2/zelda-key2.ogg"))
playersounds.playertwosound85 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player2/zelda-shield2.ogg"))
playersounds.playertwosound86 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player2/zelda-dash2.ogg"))
playersounds.playertwosound87 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player2/zelda-fairy2.ogg"))
playersounds.playertwosound88 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player2/zelda-grass2.ogg"))
playersounds.playertwosound89 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player2/zelda-hit2.ogg"))
playersounds.playertwosound90 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player2/zelda-sword-beam2.ogg"))
playersounds.playertwosound92 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player2/sprout-vine2.ogg"))
playersounds.playertwosound93 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player2/iceball2.ogg"))
playersounds.playertwosound94 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player2/yi_freeze2.ogg"))
playersounds.playertwosound95 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player2/yi_icebreak2.ogg"))
playersounds.playertwosound96 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player2/2up2.ogg"))
playersounds.playertwosound97 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player2/3up2.ogg"))
playersounds.playertwosound98 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player2/5up2.ogg"))
playersounds.playertwosound99 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player2/dragon-coin2-get2.ogg"))
playersounds.playertwosound100 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player2/dragon-coin2-get3.ogg"))
playersounds.playertwosound101 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player2/dragon-coin2-get4.ogg"))
playersounds.playertwosound102 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player2/dragon-coin2-get5.ogg"))

local winstates = {
        [LEVEL_END_STATE_ROULETTE] = true,
        [LEVEL_END_STATE_SMB3ORB]  = true,
        [LEVEL_END_STATE_KEYHOLE]  = true,
        [LEVEL_END_STATE_SMB2ORB]  = true,
        [LEVEL_END_STATE_GAMEEND]  = true,
        [LEVEL_END_STATE_STAR]     = true,
        [LEVEL_END_STATE_TAPE]     = true,
    }

function playersounds.onInitAPI()
    registerEvent(playersounds, "onKeyboardPress")
    registerEvent(playersounds, "onDraw")
    registerEvent(playersounds, "onLevelExit")
    registerEvent(playersounds, "onTick")
    registerEvent(playersounds, "onTickEnd")
    registerEvent(playersounds, "onInputUpdate")
    registerEvent(playersounds, "onStart")
    registerEvent(playersounds, "onPostNPCKill")
    registerEvent(playersounds, "onPostNPCHarm")
    registerEvent(playersounds, "onPostPlayerHarm")
    registerEvent(playersounds, "onPostPlayerKill")
    registerEvent(playersounds, "onPostExplosion")
    registerEvent(playersounds, "onPostBlockHit")
    
    local Routine = require("routine")
    
    ready = true
end

function playersounds.onTickEnd()
    for idx, p in ipairs(Player.get()) do
        if (playersounds.sounds[p.idx]) then
            if not Misc.isPaused() then
                if Level.endState() == 1 then
                    Level.finish(1, true)
                end
                if Level.endState() == 2 then
                    Level.finish(2, true)
                end
                if Level.endState() == 3 then
                    Level.finish(3, true)
                    SFX.play(playersounds.playeronesound31)
                end
                if Level.endState() == 4 then
                    Level.finish(4, true)
                end
                if Level.endState() == 6 then
                    Level.finish(6, true)
                end
                if Level.endState() == 7 then
                    Level.finish(7, true)
                end
            end
        end
    end
end

function playersounds.onTick(playerOrNil)
    if not Misc.isPaused() then
        if Player(1) then
            if player.forcedState == FORCEDSTATE_POWERUP_BIG or player.forcedState == FORCEDSTATE_POWERUP_FIRE or player.forcedState == FORCEDSTATE_POWERUP_HAMMER or player.forcedState == FORCEDSTATE_POWERUP_ICE then
                if player.forcedTimer == 0 then
                    SFX.play(playersounds.playeronesound6)
                end
            end
            if player.forcedState == FORCEDSTATE_POWERUP_LEAF or player.forcedState == FORCEDSTATE_POWERUP_TANOOKI then
                if player.forcedTimer == 0 then
                    SFX.play(playersounds.playeronesound34)
                end
            end
            if player.forcedState == FORCEDSTATE_POWERDOWN_SMALL and not player.hasStarman then
                if player.forcedTimer == 0 then
                    SFX.play(playersounds.playeronesound5)
                end
            end
            if player.forcedState == FORCEDSTATE_PIPE then
                if player.forcedTimer == 0 and not Misc.isPaused() then
                    pipecounter = pipecounter - 1
                    SFX.play(playersounds.playeronesound17, 1, 1, 70)
                end
                if player.forcedTimer == 2 and not Misc.isPaused() then
                    pipecounter = pipecounter - 1
                    SFX.play(playersounds.playeronesound17, 1, 1, 70)
                end
                if pipecounter <= 0 then
                    if playersounds.playeronesound17.playing then
                        playersounds.playeronesound17:stop()
                    end
                end
            end
            if player.forcedState == FORCEDSTATE_DOOR then
                if player.forcedTimer == 0 and not Misc.isPaused() then
                    doorcounter = doorcounter - 1
                    SFX.play(playersounds.playeronesound46, 1, 1, 70)
                end
                if player.forcedTimer == 2 and not Misc.isPaused() then
                    doorcounter = doorcounter - 1
                    SFX.play(playersounds.playeronesound46, 1, 1, 70)
                end
                if doorcounter <= 0 then
                    if playersounds.playeronesound46.playing then
                        playersounds.playeronesound46:stop()
                    end
                end
            end
            if player:mem(0x3C, FIELD_BOOL) == true then
                slidecounter = slidecounter - 1
                SFX.play(playersounds.playeronesound10)
            end
            if slidecounter <= 0 then
                slidecounter = 1
                if playersounds.playeronesound10.playing then
                    playersounds.playeronesound10:stop()
                end
            end
            if player:mem(0x74, FIELD_WORD) == 1 then
                SFX.play(playersounds.playeronesound55)
                if player:mem(0x74, FIELD_WORD) >= 2 then
                    if playersounds.playeronesound55.playing then
                        playersounds.playeronesound55:stop()
                    end
                end
            end
        end
        if Player.count() >= 2 then
            if not Misc.isPaused() then
                if Player(2).forcedState == FORCEDSTATE_POWERUP_BIG or Player(2).forcedState == FORCEDSTATE_POWERUP_FIRE or Player(2).forcedState == FFORCEDSTATE_POWERUP_HAMMER or Player(2).forcedState == FORCEDSTATE_POWERUP_ICE then
                    if Player(2).forcedTimer == 0 then
                        SFX.play(playersounds.playertwosound6)
                    end
                end
                if Player(2).forcedState == FORCEDSTATE_POWERUP_LEAF or Player(2).forcedState == FORCEDSTATE_POWERUP_TANOOKI then
                    if Player(2).forcedTimer == 0 then
                        SFX.play(playersounds.playertwosound34)
                    end
                end
                if Player(2).forcedState == FORCEDSTATE_POWERDOWN_SMALL and not Player(2).hasStarman then
                    if Player(2).forcedTimer == 0 then
                        SFX.play(playersounds.playertwosound5)
                    end
                end
                if Player(2).forcedState == FORCEDSTATE_PIPE then
                    if Player(2).forcedTimer == 0 and not Misc.isPaused() then
                        pipecounter2 = pipecounter2 - 1
                        SFX.play(playersounds.playertwosound17, 1, 1, 190)
                    end
                    if Player(2).forcedTimer == 2 and not Misc.isPaused() then
                        pipecounter2 = pipecounter2 - 1
                        SFX.play(playersounds.playertwosound17, 1, 1, 190)
                    end
                    if pipecounter2 <= 0 then
                        if playersounds.playeronesound17.playing then
                            playersounds.playertwosound17:stop()
                        end
                    end
                end
                if Player(2).forcedState == FORCEDSTATE_DOOR then
                    if Player(2).forcedTimer == 0 then
                        doorcounter2 = doorcounter2 - 1
                        SFX.play(playersounds.playertwosound46, 1, 1, 70)
                    end
                    if Player(2).forcedTimer == 2 then
                        doorcounter2 = doorcounter2 - 1
                        SFX.play(playersounds.playertwosound46, 1, 1, 70)
                    end
                    if doorcounter2 <= 0 then
                        if playersounds.playertwosound46.playing then
                            playersounds.playertwosound46:stop()
                        end
                    end
                end
                if Player(2):mem(0x3C, FIELD_BOOL) == true then
                    slidecounter2 = slidecounter2 - 1
                    SFX.play(playersounds.playertwosound10)
                end
                if slidecounter2 <= 0 then
                    slidecounter2 = 1
                    if playersounds.playertwosound10.playing then
                        playersounds.playertwosound10:stop()
                    end
                end
                if Player(2):mem(0x74, FIELD_WORD) == 1 then
                    swallowcounter2 = swallowcounter2 - 1
                    SFX.play(playersounds.playertwosound55)
                end
                if swallowcounter2 <= 0 then
                    swallowcounter2 = 1
                    if playersounds.playertwosound55.playing then
                        playersounds.playertwosound55:stop()
                    end
                end
            end
        end
    end
end

function playersounds.onPostPlayerKill()
    if Player(1) then
        SFX.play(playersounds.playeronesound8)
    end
    if Player(2) then
        SFX.play(playersounds.playertwosound8)
    end
end


function playersounds.onPostBlockHit(block, fromUpper, playerOrNil)
    local bricks = table.map{4,60,188,226}
    if not Misc.isPaused() then
        if Player(1) then
            SFX.play(playersounds.playeronesound3)
            if block.contentID == nil then --Question Blocks, Special Blocks, etc.
                SFX.play(playersounds.playersound0)
            end
            if block.contentID == 1225 then
                SFX.play(playersounds.playeronesound92)
            elseif block.contentID == 1226 then
                SFX.play(playersounds.playeronesound92)
            elseif block.contentID == 1227 then
                SFX.play(playersounds.playeronesound92)
            elseif block.contentID == 0 then
                SFX.play(playersounds.playersound0)
            elseif block.contentID == 1000 then
                SFX.play(playersounds.playersound0)
            elseif block.contentID >= 1001 then
                SFX.play(playersounds.playeronesound7)
            elseif block.contentID <= 99 then
                SFX.play(playersounds.playeronesound14)
            end
            if block:mem(0x10, FIELD_STRING) then --Bricks
                if bricks[block.id] == (block.contentID >= 1) then
                    SFX.play(playersounds.playersound0)
                elseif bricks[block.id] then
                    SFX.play(playersounds.playeronesound4)
                end
            end
        end
        if Player.count() >= 2 then
            if not Misc.isPaused() then
                SFX.play(playersounds.playertwosound3)
                if block.contentID == nil then --Question Blocks, Special Blocks, etc.
                    SFX.play(playersounds.playersound0)
                end
                if block.contentID == 1225 then
                    SFX.play(playersounds.playertwosound92)
                elseif block.contentID == 1226 then
                    SFX.play(playersounds.playertwosound92)
                elseif block.contentID == 1227 then
                    SFX.play(playersounds.playertwosound92)
                elseif block.contentID == 0 then
                    SFX.play(playersounds.playersound0)
                elseif block.contentID == 1000 then
                    SFX.play(playersounds.playersound0)
                elseif block.contentID >= 1001 then
                    SFX.play(playersounds.playertwosound7)
                elseif block.contentID <= 99 then
                    SFX.play(playersounds.playertwosound14)
                end
                if block:mem(0x10, FIELD_STRING) then --Bricks
                    if bricks[block.id] == (block.contentID >= 1) then
                        SFX.play(playersounds.playersound0)
                    elseif bricks[block.id] then
                        SFX.play(playersounds.playertwosound4)
                    end
                end
            end
        end
    end
end


function playersounds.onPostPlayerHarm()
    if Player(1) then
        if not Misc.isPaused() then
            if not player.hasStarman or (player.mount == MOUNT_YOSHI) == false or (player.mount == MOUNT_BOOT) == false or (player.mount == MOUNT_CLOWNCAR) == false then
                SFX.play(playersounds.playeronesound5)
            end
            if (player.mount == MOUNT_YOSHI) == true then
                SFX.play(playersounds.playeronesound49)
            end
        end
    end
    if Player.count() >= 2 then
        if not Misc.isPaused() then
            if not Player(2).hasStarman or (Player(2).mount == MOUNT_YOSHI) == false or (Player(2).mount == MOUNT_BOOT) == false or (Player(2).mount == MOUNT_CLOWNCAR) == false then
                SFX.play(playersounds.playertwosound5)
            end
            if (Player(2).mount == MOUNT_YOSHI) == true then
                SFX.play(playersounds.playertwosound49)
            end
        end
    end
end

function playersounds.onInputUpdate()
    if Player(1) then
        if not Misc.isPaused() then
            if player.rawKeys.jump == KEYS_PRESSED and player:isGroundTouching() then
                SFX.play(playersounds.playeronesound1)
            end
            if player.climbing and player.rawKeys.jump == KEYS_PRESSED then
                SFX.play(playersounds.playeronesound1)
            end
            if player.rawKeys.run == KEYS_PRESSED and player:mem(0x160, FIELD_WORD) <= 0 and (player.mount == MOUNT_YOSHI) == false and player.climbing == false then
                if player.powerup == 3 then
                    SFX.play(playersounds.playeronesound18)
                end
                if player.powerup == 7 then
                    SFX.play(playersounds.playeronesound93)
                end
            end
            if player.rawKeys.run == KEYS_PRESSED and player:mem(0x160, FIELD_WORD) <= 0 and (player.mount == MOUNT_YOSHI) == true then
                if player.mount == MOUNT_YOSHI and player:mem(0x10C, FIELD_WORD) then --If the tongue is out
                    SFX.play(playersounds.playeronesound50)
                elseif player:mem(0x160, FIELD_WORD) >= 1 then
                    SFX.play(playersounds.playersound0)
                end
            end
            if player.rawKeys.altJump == KEYS_PRESSED and player:mem(0x52, FIELD_WORD) >= 0 and player:isGroundTouching() then
                SFX.play(playersounds.playeronesound33)
            end
        end
    end
    if Player.count() >= 2 then
        if not Misc.isPaused() then
            if Player(2).rawKeys.jump == KEYS_PRESSED and Player(2):isGroundTouching() then
                SFX.play(playersounds.playertwosound1)
            end
            if Player(2).climbing and Player(2).rawKeys.jump == KEYS_PRESSED then
                SFX.play(playersounds.playertwosound1)
            end
            if Player(2).rawKeys.run == KEYS_PRESSED and Player(2):mem(0x160, FIELD_WORD) <= 0 and (Player(2).mount == MOUNT_YOSHI) == false and Player(2).climbing == false  then
                if Player(2).powerup == 3 then
                    SFX.play(playersounds.playertwosound18)
                end
                if player.powerup == 7 then
                    SFX.play(playersounds.playertwosound93)
                end
            end
            if Player(2).rawKeys.run == KEYS_PRESSED and Player(2):mem(0x160, FIELD_WORD) <= 0 and (Player(2).mount == MOUNT_YOSHI) == true then
                if Player(2).mount == MOUNT_YOSHI and Player(2):mem(0x10C, FIELD_WORD) then --If the tongue is out
                    SFX.play(playersounds.playertwosound50)
                elseif Player(2):mem(0x160, FIELD_WORD) >= 1 then
                    SFX.play(playersounds.playersound0)
                end
            end
            if Player(2).rawKeys.altJump == KEYS_PRESSED and player:mem(0x52, FIELD_WORD) >= 0 and Player(2):isGroundTouching() then
                SFX.play(playersounds.playertwosound33)
            end
        end
    end
end

function playersounds.onPostNPCKill(npc, harmtype)
    local starmans = table.map{994,996}
    local coins = table.map{10,33,88,103,258,528}
    local oneups = table.map{90,186,187}
    local threeups = table.map{188}
    if Player(1) then
        if not Misc.isPaused() then
            if harmtype == HARM_TYPE_JUMP then
                SFX.play(playersounds.playeronesound2)
            end
            if harmtype == HARM_TYPE_FROMBELOW then
                SFX.play(playersounds.playeronesound9)
            end
            if harmtype == HARM_TYPE_NPC then
                SFX.play(playersounds.playeronesound9)
            end
            if harmtype == HARM_TYPE_HELD then
                SFX.play(playersounds.playeronesound9)
            end
            if harmtype == HARM_TYPE_LAVA then
                SFX.play(playersounds.playeronesound16)
            end
            if harmtype == HARM_TYPE_TAIL then
                SFX.play(playersounds.playeronesound9)
            end
            if harmtype == HARM_TYPE_SPINJUMP then
                SFX.play(playersounds.playeronesound36)
            end
            if harmtype == HARM_TYPE_SWORD then
                SFX.play(playersounds.playeronesound53)
            end
            if harmtype == HARM_TYPE_EXT_FIRE then
                SFX.play(playersounds.playeronesound9)
            end
            if harmtype == HARM_TYPE_EXT_ICE then
                SFX.play(playersounds.playeronesound9)
            end
            if harmtype == HARM_TYPE_EXT_HAMMER then
                SFX.play(playersounds.playeronesound9)
            end
            if harmtype == HARM_TYPE_PROJECTILE_USED then
                if not npc.id == 13 or not npc.id == 265 then
                    SFX.play(playersounds.playeronesound9)
                end
                if npc.id == 13 or npc.id == 265 then
                    SFX.play(playersounds.playeronesound3)
                end
            end
            if starmans[npc.id] then
                SFX.play(playersounds.playertwosound6)
            end
            if coins[npc.id] then
                SFX.play(playersounds.playeronesound14)
            end
            if oneups[npc.id] then
                SFX.play(playersounds.playeronesound15)
            end
            if npc.id == 188 then
                SFX.play(playersounds.playeronesound97)
            end
            if npc.id == 11 then
                SFX.play(playersounds.playeronesound19)
            end
            if npc.id == 16 then
                SFX.play(playersounds.playeronesound21)
            end
            if npc.id == 41 then
                SFX.play(playersounds.playeronesound40)
            end
            if npc.id == 97 then
                SFX.play(playersounds.playeronesound52)
            end
            if npc.id == 197 then
                SFX.play(playersounds.playeronesound60)
            end
            if npc.id == 274 then
                if NPC.config[npc.id].score == 6 then
                    SFX.play(playersounds.playeronesound59)
                elseif NPC.config[npc.id].score == 7 then
                    SFX.play(playersounds.playeronesound59)
                elseif NPC.config[npc.id].score == 8 then
                    SFX.play(playersounds.playeronesound99)
                elseif NPC.config[npc.id].score == 9 then
                    SFX.play(playersounds.playeronesound100)
                elseif NPC.config[npc.id].score == 10 then
                    SFX.play(playersounds.playeronesound101)
                elseif NPC.config[npc.id].score >= 11 then
                    --Play 1UP sound as well
                    SFX.play(playersounds.playeronesound102)
                    SFX.play(playersounds.playeronesound15)
                end
            end
        end
    end
    if Player.count() >= 2 then
        if not Misc.isPaused() then
            if harmtype == HARM_TYPE_JUMP then
                SFX.play(playersounds.playertwosound2)
            end
            if harmtype == HARM_TYPE_FROMBELOW then
                SFX.play(playersounds.playertwosound9)
            end
            if harmtype == HARM_TYPE_NPC then
                SFX.play(playersounds.playertwosound9)
            end
            if harmtype == HARM_TYPE_EXT_FIRE then
                SFX.play(playersounds.playertwosound9)
            end
            if harmtype == HARM_TYPE_EXT_ICE then
                SFX.play(playersounds.playertwosound9)
            end
            if harmtype == HARM_TYPE_EXT_HAMMER then
                SFX.play(playersounds.playertwosound9)
            end
            if harmtype == HARM_TYPE_PROJECTILE_USED then
                SFX.play(playersounds.playertwosound9)
            end
            if starmans[npc.id] then
                SFX.play(playersounds.playertwosound6)
            end
            if coins[npc.id] then
                SFX.play(playersounds.playertwosound14)
            end
            if oneups[npc.id] then
                SFX.play(playersounds.playertwosound15)
            end
            if npc.id == 11 then
                SFX.play(playersounds.playertwosound19)
            end
            if npc.id == 16 then
                SFX.play(playersounds.playertwosound21)
            end
            if npc.id == 41 then
                SFX.play(playersounds.playertwosound40)
            end
            if npc.id == 97 then
                SFX.play(playersounds.playertwosound52)
            end
            if npc.id == 197 then
                SFX.play(playersounds.playertwosound60)
            end
            if npc.id == 274 then
                if NPC.config[npc.id].score == 6 then
                    SFX.play(playersounds.playertwosound59)
                elseif NPC.config[npc.id].score == 7 then
                    SFX.play(playersounds.playertwosound99)
                elseif NPC.config[npc.id].score == 8 then
                    SFX.play(playersounds.playertwosound100)
                elseif NPC.config[npc.id].score == 9 then
                    SFX.play(playersounds.playertwosound101)
                elseif NPC.config[npc.id].score == 10 then
                    SFX.play(playersounds.playertwosound102)
                elseif NPC.config[npc.id].score >= 11 then
                    --Play 1UP sound as well
                    SFX.play(playersounds.playertwosound15)
                end
            end
        end
    end
end

return playersounds