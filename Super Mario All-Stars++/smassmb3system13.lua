local smasSMB3System13 = {}

function smasSMB3System13.onInitAPI()
    registerEvent(smasSMB3System13,"onTick")
    registerEvent(smasSMB3System13,"onDraw")
    registerEvent(smasSMB3System13,"onPlayerHarm")
end

local animationTimer = 0
local walkAnimationFrame = 1

smasSMB3System13.whiteSizableGoThroughTimer = {}
for i = 1,200 do
    smasSMB3System13.whiteSizableGoThroughTimer[i] = 0
end
smasSMB3System13.warpedIntoWhistleArea = false

function smasSMB3System13.onTick()
    for k,v in ipairs(NPC.get(995)) do --Only one NPC of this is available anywhere in this level, soooo there's that
        for j,l in ipairs(Player.getIntersecting(v.x, v.y, v.x + v.width, v.y + v.height)) do
            if l:mem(0x12E, FIELD_BOOL) then
                smasSMB3System13.whiteSizableGoThroughTimer[j] = smasSMB3System13.whiteSizableGoThroughTimer[j] + 1
                if smasSMB3System13.whiteSizableGoThroughTimer[j] == 200 and not smasBooleans.activateWarpWhistleRoomWarp[j] then
                    l.y = l.y + 8
                    smasBooleans.activateWarpWhistleRoomWarp[j] = true
                    smasSMB3System13.whiteSizableGoThroughTimer[j] = 0
                elseif smasSMB3System13.whiteSizableGoThroughTimer[j] == 200 and smasBooleans.activateWarpWhistleRoomWarp[j] then
                    l.y = l.y + 8
                    smasSMB3System13.whiteSizableGoThroughTimer[j] = 0
                end
            elseif not l:mem(0x12E, FIELD_BOOL) then
                smasSMB3System13.whiteSizableGoThroughTimer[j] = 0
            else
                smasSMB3System13.whiteSizableGoThroughTimer[j] = 0
            end
        end
    end
end

function smasSMB3System13.onDraw()
    for _,p in ipairs(Player.get()) do
        if smasBooleans.activateWarpWhistleRoomWarp[p.idx] and not smasSMB3System13.warpedIntoWhistleArea then
            smasAnimationSystem.renderPriority = -95
        elseif smasBooleans.activateWarpWhistleRoomWarp[p.idx] and smasSMB3System13.warpedIntoWhistleArea then
            smasAnimationSystem.renderPriority = -25
        end
    end
end

function smasSMB3System13.onPlayerHarm(eventToken)
    for _,p in ipairs(Player.get()) do
        if smasBooleans.activateWarpWhistleRoomWarp[p.idx] and not warpedIntoWhistleArea then
            eventToken.cancelled = true
        end
    end
end

return smasSMB3System13