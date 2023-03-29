--smasanimationsystem.lua (v1.0)
--By Spencer Everly

local smasanimationsystem = {}

--**PLAYER ANIMATION VARIABLES**
for i = 1,200 do
    smasanimationsystem.playerAnimation = {}
    
    --*RENDER PRIORITIES*
    
    --Which priority to render the player at.
    smasanimationsystem.playerAnimation.renderPriority = {}
    smasanimationsystem.playerAnimation.renderPriority[i] = -25
    --Which priority to render the player at on pipes.
    smasanimationsystem.playerAnimation.renderPriorityPipe = {}
    smasanimationsystem.playerAnimation.renderPriorityPipe[i] = -70
    
    --*PLAYER RENDER SETTINGS*
    
    --Whenever to not draw the player.
    smasanimationsystem.playerAnimation.dontDrawPlayer = {}
    smasanimationsystem.playerAnimation.dontDrawPlayer[i] = false
    
    --*PLAYER ANIMATION FRAMES*
    
    --The frames used for walking.
    smasanimationsystem.playerAnimation.walkingFrames = {}
    smasanimationsystem.playerAnimation.walkingFrames[i] = {1,2,3,2}
end

function smasanimationsystem.onInitAPI()
    
end

return smasanimationsystem