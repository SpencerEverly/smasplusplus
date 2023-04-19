local smasExtraActions = {}

local maxPowerupID = 7 --Used for to make sure we're using powerup slots up to 7

smasExtraActions.enableLongJump = false --Enable this to add a long jump ability for your character. Default is false.
smasExtraActions.enableFasterClimbing = true --Enable this to add faster climbing. In order to climb faster, just hold run while you climb!
smasExtraActions.enableSpinjumpBounce = true --Enable this to add spinjump bouncing, like when holding jump when stomping on an enemy, except you're spinjumping. This ability is similar to the one found in the Super Mario World Super Mario Maker 2 theme.

--**Long Jump (Settings)**
smasExtraActions.isLongJumping = false --Enabled when the long jump was executed, disabled when the jump ends
smasExtraActions.isLongJumpingFirstFrame = false --Only enabled on the first frame the long jump was executed.
smasExtraActions.longJumpFullTimer = 0 --Used for the first frame calculation. Reset when on the ground.
smasExtraActions.longJumpTimer = 0 --This is used for the long jump timer, when to execute, etc.
smasExtraActions.longJumpWhenToStart = 120 --Used for when to start the long jump execution when ducking
smasExtraActions.longJumpJumpAcceleration = -16 --How high the jump should be when long jumping.
smasExtraActions.longJumpAnimationFrameActive = 1 --The frame that's active during the animation.
smasExtraActions.longJumpAnimationSpeed = 1 --Used for the animation frame speed
smasExtraActions.longJumpAnimationSpeedFrameChanger = 8 --Used for the animation frame speed, when changing frames
smasExtraActions.longJumpAnimationFrames = {} --Table generation for animation frames for the long jump
smasExtraActions.longJumpSmallDuckFrame = 8 --Used for small characters when ducking.
smasExtraActions.longJumpAnimationTimer = 0
smasExtraActions.longJumpAnimationArray = 0
smasExtraActions.longJumpAnimationFrames[1] = {3} --This is a table which has the animation frames for the long jump. The first one is a frame of 3 (For small jumps), the rest uses a frame of 4. If multiple frames are specified, the frames will animate with the speed specified until the end frames, which will stay on that frame until the jump ends when landed.
for i = 2,maxPowerupID do
    smasExtraActions.longJumpAnimationFrames[i] = {4}
end
smasExtraActions.longJumpAnimationMaxFrames = 1 --Change this to set the maximum frames used.

--**Spin Bounce (Settings)**
smasExtraActions.spinBounceHasStompedNPC = {} --Used for detecting the player that has stomped an NPC while spin jumping.

function smasExtraActions.onInitAPI()
    registerEvent(smasExtraActions,"onInputUpdate")
    registerEvent(smasExtraActions,"onPostNPCHarm")
    registerEvent(smasExtraActions,"onTick")
end

function smasExtraActions.handleSpinBounce(p)
    if smasExtraActions.spinBounceHasStompedNPC[p] and smasExtraActions.enableSpinjumpBounce then
        p:mem(0x11C, FIELD_WORD, Defines.jumpheight_bounce)
        smasExtraActions.spinBounceHasStompedNPC[p] = nil
    end
end

function smasExtraActions.onTick()
    if not SaveData.SMASPlusPlus.game.onePointThreeModeActivated then
        for _,p in ipairs(Player.get()) do
            
            
            
            --**LONG JUMP**
            if smasExtraActions.enableLongJump then
                --[[Text.print(smasExtraActions.longJumpAnimationTimer, 100, 100)
                Text.print(smasExtraActions.longJumpAnimationSpeed, 100, 120)
                Text.print(smasExtraActions.longJumpAnimationArray, 100, 140)]]
                if p.keys.down == KEYS_DOWN then
                    if Playur.ducking(p) then
                        if p.powerup == 1 then
                            p:setFrame(smasExtraActions.longJumpSmallDuckFrame * player.direction)
                        end
                        smasExtraActions.longJumpTimer = smasExtraActions.longJumpTimer + 1
                        if smasExtraActions.longJumpTimer == smasExtraActions.longJumpWhenToStart then
                            if not table.icontains(smasTables._noLevelPlaces,Level.filename()) then
                                console:println("Long jump can now be started using jump.")
                                Sound.playSFX(117)
                            end
                        end
                        if Playur.isJumping(p) and smasExtraActions.longJumpTimer >= smasExtraActions.longJumpWhenToStart then
                            for i = 1,maxPowerupID do
                                if p.powerup == i then
                                    p:setFrame(smasExtraActions.longJumpAnimationFrames[i][smasExtraActions.longJumpAnimationFrameActive] * player.direction)
                                end
                            end
                            p.speedY = smasExtraActions.longJumpJumpAcceleration
                            smasExtraActions.isLongJumping = true
                            smasExtraActions.isLongJumpingFirstFrame = true
                            smasExtraActions.longJumpTimer = 0
                        end
                    end
                end
                if not Playur.ducking(p) then
                    smasExtraActions.longJumpTimer = 0
                end
                if smasExtraActions.isLongJumping then
                    p.keys.down = false
                    
                    smasExtraActions.longJumpFullTimer = smasExtraActions.longJumpFullTimer + 1
                    
                    if smasExtraActions.longJumpFullTimer >= 2 then
                        smasExtraActions.isLongJumpingFirstFrame = false
                    end
                    
                    smasExtraActions.longJumpAnimationTimer = smasExtraActions.longJumpAnimationTimer + smasExtraActions.longJumpAnimationSpeed
                    smasExtraActions.longJumpAnimationArray = smasExtraActions.longJumpAnimationTimer % smasExtraActions.longJumpAnimationSpeedFrameChanger
                    
                    if smasExtraActions.longJumpAnimationFrameActive < smasExtraActions.longJumpAnimationMaxFrames then
                        if smasExtraActions.longJumpAnimationArray >= smasExtraActions.longJumpAnimationSpeedFrameChanger - 1 then
                            smasExtraActions.longJumpAnimationFrameActive = smasExtraActions.longJumpAnimationFrameActive + 1
                        end
                    end
                    
                    if p.speedY < 0 or not p.climbing then
                        for i = 1,maxPowerupID do
                            if p.powerup == i then
                                p:setFrame(smasExtraActions.longJumpAnimationFrames[i][smasExtraActions.longJumpAnimationFrameActive] * player.direction)
                            end
                        end
                    end
                    if p.speedY > 0 or p.climbing then
                        smasExtraActions.isLongJumping = false
                    end
                end
                if (Playur.isOnGround(p) and smasExtraActions.isLongJumping) or Playur.isOnGround(p) then
                    smasExtraActions.isLongJumping = false
                    smasExtraActions.longJumpAnimationFrameActive = 1
                    smasExtraActions.longJumpAnimationTimer = 0
                    smasExtraActions.longJumpAnimationArray = 0
                    smasExtraActions.longJumpFullTimer = 0
                end
            end
            
            
            
            
            
            --**SPIN BOUNCE**
            if smasExtraActions.enableSpinjumpBounce then
                smasExtraActions.handleSpinBounce(p)
            end
            
            
            
            
            
        end
    end
end

function smasExtraActions.onInputUpdate()
    if not SaveData.SMASPlusPlus.game.onePointThreeModeActivated then
        if smasExtraActions.enableFasterClimbing then
            for _,p in ipairs(Player.get()) do
                --Faster climbing when holding run
                if not Misc.isPaused() then
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
end

function smasExtraActions.onPostNPCHarm(npc, harmType, culprit)
    if not SaveData.SMASPlusPlus.game.onePointThreeModeActivated then
        if smasExtraActions.enableSpinjumpBounce then
            if harmType == HARM_TYPE_SPINJUMP then
                if type(culprit) == "Player" then
                    if (culprit.keys.jump or culprit.keys.altJump) then
                        smasExtraActions.spinBounceHasStompedNPC[culprit] = true
                        console:println("Spin jump bounce can be executed.")
                    end
                end
            end
        end
    end
end

return smasExtraActions