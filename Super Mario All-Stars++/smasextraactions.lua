local smasextraactions = {}

local maxPowerupID = 7 --Used for to make sure we're using powerup slots up to 7

smasextraactions.enableLongJump = false --Enable this to add a long jump ability for your character. Default is false.
smasextraactions.enableFasterClimbing = true --Enable this to add faster climbing. In order to climb faster, just hold run while you climb!
smasextraactions.enableSpinjumpBounce = true --Enable this to add spinjump bouncing, like when holding jump when stomping on an enemy, except you're spinjumping. This ability is similar to the one found in the Super Mario World Super Mario Maker 2 theme.

--**Long Jump (Settings)**
smasextraactions.isLongJumping = false --Enabled when the long jump was executed, disabled when the jump ends
smasextraactions.isLongJumpingFirstFrame = false --Only enabled on the first frame the long jump was executed.
smasextraactions.longJumpFullTimer = 0 --Used for the first frame calculation. Reset when on the ground.
smasextraactions.longJumpTimer = 0 --This is used for the long jump timer, when to execute, etc.
smasextraactions.longJumpWhenToStart = 120 --Used for when to start the long jump execution when ducking
smasextraactions.longJumpJumpAcceleration = -16 --How high the jump should be when long jumping.
smasextraactions.longJumpAnimationFrameActive = 1 --The frame that's active during the animation.
smasextraactions.longJumpAnimationSpeed = 1 --Used for the animation frame speed
smasextraactions.longJumpAnimationSpeedFrameChanger = 8 --Used for the animation frame speed, when changing frames
smasextraactions.longJumpAnimationFrames = {} --Table generation for animation frames for the long jump
smasextraactions.longJumpSmallDuckFrame = 8 --Used for small characters when ducking.
smasextraactions.longJumpAnimationTimer = 0
smasextraactions.longJumpAnimationArray = 0
smasextraactions.longJumpAnimationFrames[1] = {3} --This is a table which has the animation frames for the long jump. The first one is a frame of 3 (For small jumps), the rest uses a frame of 4. If multiple frames are specified, the frames will animate with the speed specified until the end frames, which will stay on that frame until the jump ends when landed.
for i = 2,maxPowerupID do
    smasextraactions.longJumpAnimationFrames[i] = {4}
end
smasextraactions.longJumpAnimationMaxFrames = 1 --Change this to set the maximum frames used.

--**Spin Bounce (Settings)**
smasextraactions.spinBounceHasStompedNPC = {} --Used for detecting the player that has stomped an NPC while spin jumping.

function smasextraactions.onInitAPI()
    registerEvent(smasextraactions,"onInputUpdate")
    registerEvent(smasextraactions,"onPostNPCHarm")
    registerEvent(smasextraactions,"onTick")
end

function smasextraactions.handleSpinBounce(p)
    if smasextraactions.spinBounceHasStompedNPC[p] and smasextraactions.enableSpinjumpBounce then
        p:mem(0x11C, FIELD_WORD, Defines.jumpheight_bounce)
        smasextraactions.spinBounceHasStompedNPC[p] = nil
    end
end

function smasextraactions.onTick()
    if not SaveData.disableX2char then
        for _,p in ipairs(Player.get()) do
            
            
            
            --**LONG JUMP**
            if smasextraactions.enableLongJump then
                --[[Text.print(smasextraactions.longJumpAnimationTimer, 100, 100)
                Text.print(smasextraactions.longJumpAnimationSpeed, 100, 120)
                Text.print(smasextraactions.longJumpAnimationArray, 100, 140)]]
                if p.keys.down == KEYS_DOWN then
                    if Playur.ducking(p) then
                        if p.powerup == 1 then
                            p:setFrame(smasextraactions.longJumpSmallDuckFrame * player.direction)
                        end
                        smasextraactions.longJumpTimer = smasextraactions.longJumpTimer + 1
                        if smasextraactions.longJumpTimer == smasextraactions.longJumpWhenToStart then
                            if not table.icontains(smastables._noLevelPlaces,Level.filename()) then
                                Sound.playSFX(117)
                            end
                        end
                        if Playur.isJumping(p) and smasextraactions.longJumpTimer >= smasextraactions.longJumpWhenToStart then
                            for i = 1,maxPowerupID do
                                if p.powerup == i then
                                    p:setFrame(smasextraactions.longJumpAnimationFrames[i][smasextraactions.longJumpAnimationFrameActive] * player.direction)
                                end
                            end
                            p.speedY = smasextraactions.longJumpJumpAcceleration
                            smasextraactions.isLongJumping = true
                            smasextraactions.isLongJumpingFirstFrame = true
                            smasextraactions.longJumpTimer = 0
                        end
                    end
                end
                if not Playur.ducking(p) then
                    smasextraactions.longJumpTimer = 0
                end
                if smasextraactions.isLongJumping then
                    p.keys.down = false
                    
                    smasextraactions.longJumpFullTimer = smasextraactions.longJumpFullTimer + 1
                    
                    if smasextraactions.longJumpFullTimer >= 2 then
                        smasextraactions.isLongJumpingFirstFrame = false
                    end
                    
                    smasextraactions.longJumpAnimationTimer = smasextraactions.longJumpAnimationTimer + smasextraactions.longJumpAnimationSpeed
                    smasextraactions.longJumpAnimationArray = smasextraactions.longJumpAnimationTimer % smasextraactions.longJumpAnimationSpeedFrameChanger
                    
                    if smasextraactions.longJumpAnimationFrameActive < smasextraactions.longJumpAnimationMaxFrames then
                        if smasextraactions.longJumpAnimationArray >= smasextraactions.longJumpAnimationSpeedFrameChanger - 1 then
                            smasextraactions.longJumpAnimationFrameActive = smasextraactions.longJumpAnimationFrameActive + 1
                        end
                    end
                    
                    if p.speedY < 0 or not p.climbing then
                        for i = 1,maxPowerupID do
                            if p.powerup == i then
                                p:setFrame(smasextraactions.longJumpAnimationFrames[i][smasextraactions.longJumpAnimationFrameActive] * player.direction)
                            end
                        end
                    end
                    if p.speedY > 0 or p.climbing then
                        smasextraactions.isLongJumping = false
                    end
                end
                if (Playur.isOnGround(p) and smasextraactions.isLongJumping) or Playur.isOnGround(p) then
                    smasextraactions.isLongJumping = false
                    smasextraactions.longJumpAnimationFrameActive = 1
                    smasextraactions.longJumpAnimationTimer = 0
                    smasextraactions.longJumpAnimationArray = 0
                    smasextraactions.longJumpFullTimer = 0
                end
            end
            
            
            
            
            
            --**SPIN BOUNCE**
            if smasextraactions.enableSpinjumpBounce then
                smasextraactions.handleSpinBounce(p)
            end
            
            
            
            
            
        end
    end
end

function smasextraactions.onInputUpdate()
    if not SaveData.disableX2char then
        if smasextraactions.enableFasterClimbing then
            for _,p in ipairs(Player.get()) do
                --Faster climbing when holding run
                if p.climbing and p.forcedState == 0 and p.deathTimer == 0 then
                    if p.keys.run then
                        if p.keys.left then
                            p.x = p.x - 1.5
                        elseif p.keys.right then
                            p.x = p.x + 1.5
                        elseif p.keys.up then
                            p.y = p.y - 1.5
                        elseif p.keys.down then
                            p.y = p.y + 1.5
                        end
                    end
                end
            end
        end
    end
end

function smasextraactions.onPostNPCHarm(npc, harmType, culprit)
    if not SaveData.disableX2char then
        if smasextraactions.enableSpinjumpBounce then
            if harmType == HARM_TYPE_SPINJUMP then
                if type(culprit) == "Player" then
                    if (culprit.keys.jump or culprit.keys.altJump) then
                        smasextraactions.spinBounceHasStompedNPC[culprit] = true
                    end
                end
            end
        end
    end
end

return smasextraactions