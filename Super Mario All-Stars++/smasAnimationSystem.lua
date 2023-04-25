--smasAnimationSystem.lua (v1.0)
--By Spencer Everly

local smasAnimationSystem = {}

--**PLAYER ANIMATION VARIABLES**
for i = 1,200 do
    smasAnimationSystem.playerAnimation = {}
    
    --*RENDER PRIORITIES*
    
    --Which priority to render the player at.
    smasAnimationSystem.playerAnimation.renderPriority = {}
    smasAnimationSystem.playerAnimation.renderPriority[i] = -25
    --Which priority to render the player at on pipes.
    smasAnimationSystem.playerAnimation.renderPriorityPipe = {}
    smasAnimationSystem.playerAnimation.renderPriorityPipe[i] = -70
    
    --*PLAYER RENDER SETTINGS*
    
    --Whenever to not draw the player.
    smasAnimationSystem.playerAnimation.dontDrawPlayer = {}
    smasAnimationSystem.playerAnimation.dontDrawPlayer[i] = false
    
    --*PLAYER ANIMATION FRAMES*
    
    --The frames used for walking.
    smasAnimationSystem.playerAnimation.walkingFrames = {}
    smasAnimationSystem.playerAnimation.walkingFrames[i] = {1,2,3,2}
end

function smasAnimationSystem.onInitAPI()
    
end

return smasAnimationSystem