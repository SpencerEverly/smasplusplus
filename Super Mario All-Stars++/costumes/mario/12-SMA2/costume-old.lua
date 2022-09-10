local pm = require("playerManager")

local costume = {}

costume.playersList = {}
costume.playerData = {}

local eventsRegistered = false

function costume.onInit(p)
    -- If events have not been registered yet, do so
    if not eventsRegistered then
        registerEvent(costume,"onStart")
        registerEvent(costume,"onTick")
        registerEvent(costume,"onTickEnd")
        registerEvent(costume,"onCleanup")
        registerEvent(costume,"onInputUpdate")

        eventsRegistered = true
        
        -- Add this player to the list
    if costume.playerData[p] == nil then
        costume.playerData[p] = {
            currentAnimation = "",
        }
        
        table.insert(costume.playersList,p)
        end
    end
end

function costume.onStart()
  Audio.playSFX("costumes/mario/12-SMA2/mario-letsago.ogg")
  if player:mem(0x13e, FIELD_WORD) > 0 then return false end
  if player:mem(0x122, FIELD_WORD) > 0 then return false end
--if player:mem(0x108, FIELD_WORD) > 0 then return false end

end

function costume.onTickEnd()
    for _,p in ipairs(costume.playersList) do
        local data = costume.playerData[p]
    end
end
    
function costume.onTick()
    extrasounds.sound.sfx[1] = Audio.SfxOpen("costumes/mario/12-SMA2/player-jump.ogg")
    Audio.sounds[2].sfx  = Audio.SfxOpen("costumes/mario/12-SMA2/stomped.ogg")
    Audio.sounds[3].sfx  = Audio.SfxOpen("costumes/mario/12-SMA2/block-hit.ogg")
    extrasounds.sound.sfx[4]  = Audio.SfxOpen("costumes/mario/12-SMA2/block-smash.ogg")
    Audio.sounds[5].sfx  = Audio.SfxOpen("costumes/mario/12-SMA2/player-shrink.ogg")
    Audio.sounds[6].sfx  = Audio.SfxOpen("costumes/mario/12-SMA2/player-grow.ogg")
    extrasounds.sound.sfx[7]  = Audio.SfxOpen("costumes/mario/12-SMA2/mushroom.ogg")
    extrasounds.sound.sfx[8]  = Audio.SfxOpen("costumes/mario/12-SMA2/player-died.ogg")
    Audio.sounds[9].sfx  = Audio.SfxOpen("costumes/mario/12-SMA2/shell-hit.ogg")
    extrasounds.sound.sfx[10] = Audio.SfxOpen("costumes/mario/12-SMA2/player-slide.ogg")
    Audio.sounds[11].sfx = Audio.SfxOpen("costumes/mario/12-SMA2/item-dropped.ogg")
    Audio.sounds[12].sfx = Audio.SfxOpen("costumes/mario/12-SMA2/has-item.ogg")
    Audio.sounds[13].sfx = Audio.SfxOpen("costumes/mario/12-SMA2/camera-change.ogg")
    extrasounds.sound.sfx[14]  = Audio.SfxOpen("costumes/mario/12-SMA2/coin.ogg")
    extrasounds.sound.sfx[15]  = Audio.SfxOpen("costumes/mario/12-SMA2/1up.ogg")
    Audio.sounds[16].sfx = Audio.SfxOpen("costumes/mario/12-SMA2/lava.ogg")
    Audio.sounds[17].sfx = Audio.SfxOpen("costumes/mario/12-SMA2/warp.ogg")
    extrasounds.sound.sfx[18]  = Audio.SfxOpen("costumes/mario/12-SMA2/fireball.ogg")
    Audio.sounds[19].sfx = Audio.SfxOpen("costumes/mario/12-SMA2/level-win.ogg")
    Audio.sounds[20].sfx = Audio.SfxOpen("costumes/mario/12-SMA2/boss-beat.ogg")
    Audio.sounds[21].sfx = Audio.SfxOpen("costumes/mario/12-SMA2/dungeon-win.ogg")
    Audio.sounds[22].sfx = Audio.SfxOpen("costumes/mario/12-SMA2/bullet-bill.ogg")
    Audio.sounds[23].sfx = Audio.SfxOpen("costumes/mario/12-SMA2/grab.ogg")
    Audio.sounds[24].sfx = Audio.SfxOpen("costumes/mario/12-SMA2/spring.ogg")
    Audio.sounds[25].sfx = Audio.SfxOpen("costumes/mario/12-SMA2/hammer.ogg")
    Audio.sounds[29].sfx = Audio.SfxOpen("costumes/mario/12-SMA2/do.ogg")
    Audio.sounds[31].sfx = Audio.SfxOpen("costumes/mario/12-SMA2/key.ogg")
    Audio.sounds[32].sfx = Audio.SfxOpen("costumes/mario/12-SMA2/pswitch.ogg")
    extrasounds.sound.sfx[33] = Audio.SfxOpen("costumes/mario/12-SMA2/tail.ogg")
    Audio.sounds[34].sfx = Audio.SfxOpen("costumes/mario/12-SMA2/racoon.ogg")
    Audio.sounds[35].sfx = Audio.SfxOpen("costumes/mario/12-SMA2/boot.ogg")
    extrasounds.sound.sfx[36] = Audio.SfxOpen(Misc.resolveSoundFile("costumes/mario/12-SMA2/smash.ogg"))
    Audio.sounds[37].sfx = Audio.SfxOpen("costumes/mario/12-SMA2/thwomp.ogg")
    extrasounds.sound.sfx[42] = Audio.SfxOpen(Misc.resolveSoundFile("costumes/mario/12-SMA2/npc-fireball.ogg"))
    extrasounds.sound.sfx[43] = Audio.SfxOpen("costumes/mario/12-SMA2/fireworks.ogg")
    Audio.sounds[44].sfx = Audio.SfxOpen("costumes/mario/12-SMA2/bowser-killed.ogg")
    Audio.sounds[46].sfx = Audio.SfxOpen("costumes/mario/12-SMA2/door.ogg")
    Audio.sounds[48].sfx = Audio.SfxOpen("costumes/mario/12-SMA2/yoshi.ogg")
    Audio.sounds[49].sfx = Audio.SfxOpen("costumes/mario/12-SMA2/yoshi-hurt.ogg")
    Audio.sounds[50].sfx = Audio.SfxOpen("costumes/mario/12-SMA2/yoshi-tongue.ogg")
    Audio.sounds[51].sfx = Audio.SfxOpen("costumes/mario/12-SMA2/yoshi-egg.ogg")
    Audio.sounds[54].sfx = Audio.SfxOpen("costumes/mario/12-SMA2/player-died2.ogg")
    Audio.sounds[55].sfx = Audio.SfxOpen("costumes/mario/12-SMA2/yoshi-swallow.ogg")
    Audio.sounds[57].sfx = Audio.SfxOpen("costumes/mario/12-SMA2/dry-bones.ogg")
    Audio.sounds[58].sfx = Audio.SfxOpen("costumes/mario/12-SMA2/smw-checkpoint.ogg")
    extrasounds.sound.sfx[59]  = Audio.SfxOpen("costumes/mario/12-SMA2/dragon-coin.ogg")
    Audio.sounds[61].sfx = Audio.SfxOpen("costumes/mario/12-SMA2/smw-blaarg.ogg")
    Audio.sounds[62].sfx = Audio.SfxOpen("costumes/mario/12-SMA2/wart-bubble.ogg")
    Audio.sounds[63].sfx = Audio.SfxOpen("costumes/mario/12-SMA2/wart-die.ogg")
    Audio.sounds[71].sfx = Audio.SfxOpen("costumes/mario/12-SMA2/climbing.ogg")
    Audio.sounds[72].sfx = Audio.SfxOpen("costumes/mario/12-SMA2/swim.ogg")
    Audio.sounds[73].sfx = Audio.SfxOpen("costumes/mario/12-SMA2/grab2.ogg")
    --Audio.sounds[74].sfx = Audio.SfxOpen("costumes/mario/12-SMA2/saw.ogg")
    Audio.sounds[75].sfx = Audio.SfxOpen("costumes/mario/12-SMA2/smb2-throw.ogg")
    Audio.sounds[76].sfx = Audio.SfxOpen("costumes/mario/12-SMA2/smb2-hit.ogg")
    Audio.sounds[77].sfx = Audio.SfxOpen("costumes/mario/12-SMA2/mario-hurt.ogg")
    Audio.sounds[78].sfx = Audio.SfxOpen("costumes/mario/12-SMA2/mario-justwhatineeded.ogg")
    Audio.sounds[79].sfx = Audio.SfxOpen("costumes/mario/12-SMA2/mario-gotcha.ogg")
    Audio.sounds[80].sfx = Audio.SfxOpen("costumes/mario/12-SMA2/mario-wahah.ogg")
    extrasounds.sound.sfx[81] = Audio.SfxOpen("costumes/mario/12-SMA2/mario-lucky.ogg")
    Audio.sounds[82].sfx = Audio.SfxOpen("costumes/mario/12-SMA2/mario-hereigo.ogg")
    Audio.sounds[91].sfx = Audio.SfxOpen("costumes/mario/12-SMA2/bubble.ogg")

    timer = 1

    if(not killed and player:mem(0x13E,FIELD_BOOL)) then
        killed = true;
        Audio.playSFX("costumes/mario/12-SMA2/mario-mama-mia.ogg");
    end
    
    if(player:mem(0x122,FIELD_WORD) == 2) then    --Powering down? Then update HP.
        if(not powerdown and hp == 1) then --This happens if player is hurt when on 1HP, so should die.
            killed = true;
            Sound.playSFX("mario/12-SMA2/mario-mama-mia.ogg");
            player:kill();

            powerdown = true;
--            Audio.SfxPlayCh(18, mariohurt, 0);
            else
                powerdown = false;
            end
        end

--    if((player:mem(0x122,FIELD_WORD) == 1 or player:mem(0x122,FIELD_WORD) == 4 or player:mem(0x122,FIELD_WORD) == 12 or player:mem(0x122,FIELD_WORD) == 41)) then
--        Audio.SfxPlayCh(18, mariopowerup, 0)
--    end

--    if ((player:mem(0x122,FIELD_WORD) == 5 or player:mem(0x122,FIELD_WORD) == 11)) then
--        Audio.SfxPlayCh(18, marioreserve, 0)
--    end

    if(not offyoshi and player:mem(0x108,FIELD_WORD,0)) then
        offyoshi = true;
        Audio.SfxPlayCh(18, mariodismount, 0)
    end
end

function costume.onCleanup(p)
    -- Remove the player from the list
    if costume.playerData[p] ~= nil then
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
        extrasounds.sound.sfx[42] = nil
        extrasounds.sound.sfx[43] = nil
        Audio.sounds[44].sfx = nil
        Audio.sounds[46].sfx = nil
        Audio.sounds[48].sfx = nil
        Audio.sounds[49].sfx = nil
        Audio.sounds[50].sfx = nil
        Audio.sounds[51].sfx = nil
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
        --Audio.sounds[74].sfx = nil
        Audio.sounds[75].sfx = nil
        Audio.sounds[76].sfx = nil
        Audio.sounds[77].sfx = nil
        Audio.sounds[78].sfx = nil
        Audio.sounds[79].sfx = nil
        Audio.sounds[80].sfx = nil
        extrasounds.sound.sfx[81] = nil
        Audio.sounds[82].sfx = nil
        Audio.sounds[91].sfx = nil
        costume.playerData[p] = nil
    end
end

return costume;