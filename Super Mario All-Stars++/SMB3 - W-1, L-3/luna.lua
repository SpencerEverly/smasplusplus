local level_dependencies_normal= require("level_dependencies_normal")
local steve = require("steve")

function onLoadSection1()
    autoscrolla.scrollRight(1)
end

local animationTimer = 0
local walkAnimationFrame = 1

local whiteSizableGoThroughTimer = {}
for i = 1,200 do
    whiteSizableGoThroughTimer[i] = 0
end
local warpedIntoWhistleArea = false

function onTick()
    for k,v in ipairs(NPC.get(995)) do --Only one NPC of this is available anywhere in this level, soooo there's that
        for j,l in ipairs(Player.getIntersecting(v.x, v.y, v.x + v.width, v.y + v.height)) do
            if l:mem(0x12E, FIELD_BOOL) then
                whiteSizableGoThroughTimer[j] = whiteSizableGoThroughTimer[j] + 1
                if whiteSizableGoThroughTimer[j] == 200 then
                    l.y = l.y + 8
                    smasbooleans.activateWarpWhistleRoomWarp[j] = true
                    whiteSizableGoThroughTimer[j] = 0
                end
            elseif not l:mem(0x12E, FIELD_BOOL) then
                whiteSizableGoThroughTimer[j] = 0
            else
                whiteSizableGoThroughTimer[j] = 0
            end
        end
    end
end

function onDraw()
    for _,p in ipairs(Player.get()) do
        if smasbooleans.activateWarpWhistleRoomWarp[p.idx] and not warpedIntoWhistleArea then
            --p:setFrame(-50*player.direction)
            
            --[[local currentAnimation = Playur.findAnimation(p)
            local priority = -70
            
            if currentAnimation == "stance" then
                p:render{frame = 1, priority = priority, mountpriority = priority}
            elseif currentAnimation == "duck" then
                if p.powerup > 2 then
                    p:render{frame = 6, priority = priority, mountpriority = priority}
                elseif p.powerup == 1 then
                    p:render{frame = 1, priority = priority, mountpriority = priority}
                end
            elseif currentAnimation == "walk" or currentAnimation == "run" then
                local animationSpeed = 6
                animationTimer = animationTimer + 1
                if animationTimer == animationTimer % animationSpeed then
                    walkAnimationFrame = walkAnimationFrame + 1
                end
                if animationTimer >= 18 then
                    walkAnimationFrame = 1
                    animationTimer = 0
                end
                p:render{frame = walkAnimationFrame, priority = priority, mountpriority = priority}
            elseif currentAnimation == "jump" then
                if p.powerup > 2 then
                    p:render{frame = 4, priority = priority, mountpriority = priority}
                elseif p.powerup == 1 then
                    p:render{frame = 3, priority = priority, mountpriority = priority}
                end
            end]]
        end
    end
end

function onPlayerHarm(eventToken)
    for _,p in ipairs(Player.get()) do
        if smasbooleans.activateWarpWhistleRoomWarp[p.idx] and not warpedIntoWhistleArea then
            eventToken.cancelled = true
        end
    end
end