local extrasounds = require("extrasounds")
local smasfunctions = require("smasfunctions")

local costume = {}

costume.loadedSounds = false

local plr
local musicTimer = 0
local harpoonXCoordinate = 0
local harpoonShowingCoordinate = 96
local harpoonXCoordinateMover = 96
local harpoonGraphic = Graphics.loadImageResolved("costumes/toad/DigDug-DiggingStrike/harpoon.png")
local harpoonBlockSpawned = false
local harpoonPlayerDirection = 0

local harpoonActive = false

function costume.onInit(p)
    plr = p
    registerEvent(costume,"onStart")
    registerEvent(costume,"onDrawEnd")
    registerEvent(costume,"onDraw")
    registerEvent(costume,"onTick")
    registerEvent(costume,"onInputUpdate")
    
    if not costume.loadedSounds then
        Sound.loadCostumeSounds()
        costume.loadedSounds = true
    end
end

function costume.onDrawEnd()
    if smascharacterglobals.abilitySettings.taizoMuteMusicWhenNotMoving then
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
    Sound.playSFX(smascharacterglobals.soundSettings.taizoHarpoonShootSFX)
    Routine.wait(0.6)
    harpoonActive = false
end

function costume.onDraw()
    if plr.powerup >= 4 then
        plr.powerup = 3
    end
end

function costume.onInputUpdate()
    if Level.endState() == 0 and plr.deathTimer == 0 and not Misc.isPaused() then
        if smascharacterglobals.abilitySettings.taizoCanUseHarpoon then
            if table.icontains(smastables._noLevelPlaces,Level.filename()) == false then
                if plr.keys.run == KEYS_PRESSED and not harpoonActive and plr.powerup <= 2 then
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
    Sound.cleanupCostumeSounds()
end

return costume