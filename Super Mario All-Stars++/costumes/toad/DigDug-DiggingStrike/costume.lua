local costume = {}

local extrasounds = require("extrasounds")

local plr
local musicTimer = 0
local harpoonXCoordinate = 0
local harpoonShowingCoordinate = 96
local harpoonXCoordinateMover = 96
local harpoonGraphic = Graphics.loadImageResolved("costumes/toad/DigDug-DiggingStrike/harpoon.png")
local harpoonBlockSpawned = false
local harpoonPlayerDirection = 0

costume.muteMusicWhenNotMoving = false
costume.enableHarpoon = true

local harpoonActive = false

function costume.onInit(p)
    plr = p
    registerEvent(costume,"onStart")
    registerEvent(costume,"onDrawEnd")
    registerEvent(costume,"onDraw")
    registerEvent(costume,"onTick")
    registerEvent(costume,"onInputUpdate")
    
    extrasounds.sound.sfx[1] = Audio.SfxOpen("costumes/toad/DigDug-DiggingStrike/player-jump.ogg")
    Audio.sounds[5].sfx = Audio.SfxOpen("costumes/toad/DigDug-DiggingStrike/player-shrink.ogg")
    Audio.sounds[6].sfx = Audio.SfxOpen("costumes/toad/DigDug-DiggingStrike/player-grow.ogg")
    extrasounds.sound.sfx[8] = Audio.SfxOpen(Misc.resolveSoundFile("costumes/toad/DigDug-DiggingStrike/player-died.ogg"))
    extrasounds.sound.sfx[14] = Audio.SfxOpen(Misc.resolveSoundFile("costumes/toad/DigDug-DiggingStrike/coin.ogg"))
    extrasounds.sound.sfx[15] = Audio.SfxOpen(Misc.resolveSoundFile("costumes/toad/DigDug-DiggingStrike/1up.ogg"))
    extrasounds.sound.sfx[96] = Audio.SfxOpen(Misc.resolveSoundFile("costumes/toad/DigDug-DiggingStrike/2up.ogg"))
    extrasounds.sound.sfx[97] = Audio.SfxOpen(Misc.resolveSoundFile("costumes/toad/DigDug-DiggingStrike/3up.ogg"))
    extrasounds.sound.sfx[98] = Audio.SfxOpen(Misc.resolveSoundFile("costumes/toad/DigDug-DiggingStrike/5up.ogg"))
end

function costume.onDrawEnd()
    if costume.muteMusicWhenNotMoving then
        if table.icontains(smastables._noLevelPlaces,Level.filename()) == false then
            if Level.endState() == 0 and plr.deathTimer == 0 and not Misc.isPaused() then
                if plr.speedX == 0 and plr.speedY == 0 then
                    Audio.MusicSetPos(musicTimer)
                    Audio.MusicPause()
                    if not plr.hasStarman and not plr.isMega and not smasbooleans.pSwitchActive then
                        smasbooleans.musicMuted = true
                    end
                else
                    musicTimer = Audio.MusicGetPos()
                    Audio.MusicResume()
                    if not plr.hasStarman and not plr.isMega and not smasbooleans.pSwitchActive then
                        smasbooleans.musicMuted = false
                    end
                end
            end
        end
    end
end

function costume.harpoonAttack()
    harpoonActive = true
    Sound.playSFX("toad/DigDug-DiggingStrike/harpoon-shoot.ogg")
    Routine.wait(0.6)
    harpoonActive = false
end

function costume.onDraw()
    if plr.powerup >= 3 then
        plr.powerup = 2
    end
end

function costume.onInputUpdate()
    if Level.endState() == 0 and plr.deathTimer == 0 and not Misc.isPaused() then
        if costume.enableHarpoon then
            if table.icontains(smastables._noLevelPlaces,Level.filename()) == false then
                if plr.keys.run == KEYS_PRESSED and not harpoonActive then
                    Routine.run(costume.harpoonAttack)
                end
            end
        end
    end
end

function costume.onTick()
    if Level.endState() == 0 and plr.deathTimer == 0 and not Misc.isPaused() then
        plr.speedX = 0
        plr:mem(0x12E, FIELD_BOOL, false)
        if plr.keys.left then
            plr.speedX = -2.5
        elseif plr.keys.right then
            plr.speedX = 2.5
        end
        if harpoonActive then
            plr:setFrame(30)
            harpoonShowingCoordinate = harpoonShowingCoordinate - 3
            harpoonXCoordinateMover = harpoonXCoordinateMover + 3
            if not harpoonBlockSpawned then
                Block.spawn(1000, plr.x + harpoonShowingCoordinate * plr.direction, plr.y)
                harpoonBlockSpawned = true
            end
            for k,block in ipairs(Block.get(1000)) do
                if plr.speedX == 0 and plr.speedY == 0 then --Standing
                    block.x = block.x + 3 * plr.direction
                elseif plr.speedX > 0 or plr.speedX < 0 then --Moving
                    block.x = block.x + 5.5 * plr.direction
                elseif plr.speedY > 0 or plr.speedY < 0 then --Jumping
                    block.x = block.x + 3 * plr.direction
                    block.y = block.y + plr.speedY * plr.direction
                elseif plr.speedY > 0 or plr.speedY < 0 and plr.speedX == 0 and plr.speedY == 0 then --Jumping but not moving
                    block.x = block.x + 3 * plr.direction
                    block.y = block.y + plr.speedY * plr.direction
                elseif plr.speedX > 0 or plr.speedX < 0 and plr.speedY > 0 or plr.speedY < 0 then --Jumping and moving
                    block.x = block.x + 5.5 * plr.direction
                    block.y = block.y + plr.speedY * plr.direction
                end
            end
            if plr.direction == 1 then
                Graphics.drawImageToSceneWP(harpoonGraphic, (plr.x + 12 * plr.direction), (plr.y + 12), (96 + harpoonShowingCoordinate), 0, (96 - harpoonShowingCoordinate), 12, -26)
            elseif plr.direction == -1 then
                Graphics.drawImageToSceneWP(harpoonGraphic, (plr.x + 100 + harpoonXCoordinateMover * plr.direction), (plr.y + 12), 0, 12, (harpoonShowingCoordinate * plr.direction), 12, -26)
            end
        elseif not harpoonActive then
            plr:setFrame(nil)
            harpoonXCoordinateMover = 96
            harpoonShowingCoordinate = 0
            harpoonBlockSpawned = false
            for k,block in ipairs(Block.get(1000)) do
                block:delete()
            end
        end
    end
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
    extrasounds.sound.sfx[92] = nil
    extrasounds.sound.sfx[93] = nil
    extrasounds.sound.sfx[94] = nil
    extrasounds.sound.sfx[95] = nil
    extrasounds.sound.sfx[96] = nil
    extrasounds.sound.sfx[97] = nil
    extrasounds.sound.sfx[98] = nil
    extrasounds.sound.sfx[99] = nil
    extrasounds.sound.sfx[100] = nil
    extrasounds.sound.sfx[101] = nil
    extrasounds.sound.sfx[102] = nil
    extrasounds.sound.sfx[103] = nil
    extrasounds.sound.sfx[104] = nil
    extrasounds.sound.sfx[105] = nil
    extrasounds.sound.sfx[106] = nil
    extrasounds.sound.sfx[107] = nil
    extrasounds.sound.sfx[108] = nil
    extrasounds.sound.sfx[109] = nil
    extrasounds.sound.sfx[110] = nil
    extrasounds.sound.sfx[111] = nil
    extrasounds.sound.sfx[112] = nil
end

return costume