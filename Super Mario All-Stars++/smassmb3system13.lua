local smassmb3system13 = {}

function smassmb3system13.onInitAPI()
    registerEvent(smassmb3system13,"onTick")
    registerEvent(smassmb3system13,"onDraw")
    registerEvent(smassmb3system13,"onPlayerHarm")
end

local animationTimer = 0
local walkAnimationFrame = 1

smassmb3system13.whiteSizableGoThroughTimer = {}
for i = 1,200 do
    smassmb3system13.whiteSizableGoThroughTimer[i] = 0
end
smassmb3system13.warpedIntoWhistleArea = false

function smassmb3system13.onTick()
    for k,v in ipairs(NPC.get(995)) do --Only one NPC of this is available anywhere in this level, soooo there's that
        for j,l in ipairs(Player.getIntersecting(v.x, v.y, v.x + v.width, v.y + v.height)) do
            if l:mem(0x12E, FIELD_BOOL) then
                smassmb3system13.whiteSizableGoThroughTimer[j] = smassmb3system13.whiteSizableGoThroughTimer[j] + 1
                if smassmb3system13.whiteSizableGoThroughTimer[j] == 200 and not smasbooleans.activateWarpWhistleRoomWarp[j] then
                    l.y = l.y + 8
                    smasbooleans.activateWarpWhistleRoomWarp[j] = true
                    smassmb3system13.whiteSizableGoThroughTimer[j] = 0
                elseif smassmb3system13.whiteSizableGoThroughTimer[j] == 200 and smasbooleans.activateWarpWhistleRoomWarp[j] then
                    l.y = l.y + 8
                    smassmb3system13.whiteSizableGoThroughTimer[j] = 0
                end
            elseif not l:mem(0x12E, FIELD_BOOL) then
                smassmb3system13.whiteSizableGoThroughTimer[j] = 0
            else
                smassmb3system13.whiteSizableGoThroughTimer[j] = 0
            end
        end
    end
end

function smassmb3system13.onDraw()
    for _,p in ipairs(Player.get()) do
        if smasbooleans.activateWarpWhistleRoomWarp[p.idx] and not smassmb3system13.warpedIntoWhistleArea then
            smasanimationsystem.renderPriority = -95
        elseif smasbooleans.activateWarpWhistleRoomWarp[p.idx] and smassmb3system13.warpedIntoWhistleArea then
            smasanimationsystem.renderPriority = -25
        end
    end
end

function smassmb3system13.onPlayerHarm(eventToken)
    for _,p in ipairs(Player.get()) do
        if smasbooleans.activateWarpWhistleRoomWarp[p.idx] and not warpedIntoWhistleArea then
            eventToken.cancelled = true
        end
    end
end

return smassmb3system13