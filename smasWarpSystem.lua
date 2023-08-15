local smasWarpSystem = {}

smasWarpSystem.instantWarps = table.map{0,3}
smasWarpSystem.alternativeInstantWarpCooldown = 0

--[[smasWarpSystem.
for i = 1,200 do
    smasWarpSystem.
end]]

function smasWarpSystem.onInitAPI()
    registerEvent(smasWarpSystem,"onTick")
    registerEvent(smasWarpSystem,"onDraw")
    
    if SMBX_VERSION == VER_SEE_MOD then
        registerEvent(smasWarpSystem,"onWarp")
    end
end

function smasWarpSystem.canWarpPlayer(plr)
    return (
        plr:mem(0x15C, FIELD_WORD) == 0
    )
end

function smasWarpSystem.onDraw()
    --Door warp system, remade
    for _,p in ipairs(Player.get()) do
        for k,v in ipairs(Warp.getIntersectingEntrance(p.x, p.y + p.height, p.x + p.width, p.y + p.height)) do
            if smasWarpSystem.canWarpPlayer(p) and v.warpType == 2 then
                --Text.printWP("Can go in", 100, 100, 7)
            end
        end
    end
end

function smasWarpSystem.onTick()
    --Dumb fix pertaining to ground pounding with a Yoshi and insta-warps not working as intended
    for l,p in ipairs(Player.get()) do
        --If the warp cooldown is less than -1 and we're ground pounding with a Yoshi (With the smasWarpSystem.alternativeInstantWarpCooldown setting being 0)...
        if p:mem(0x15C,FIELD_WORD) <= -1 and p:mem(0x5C,FIELD_BOOL) and smasWarpSystem.alternativeInstantWarpCooldown == 0 then
            -- Instant/portal warps

            -- Sorta janky fix for ducking
            local playerSetting = PlayerSettings.get(playerManager.getBaseID(p.character),p.powerup)

            local x = (p.x+(p.speedX*1.5))
            local y = (p.y+(p.speedY*1.5))

            if p:mem(0x12E,FIELD_BOOL) and not p.keys.down then
                y = (y+p.height-playerSetting.hitboxHeight)
            end


            for _,warp in ipairs(Warp.getIntersectingEntrance(x,y,x+p.width,y+p.height)) do
                if smasWarpSystem.instantWarps[warp.warpType] and not warp.isHidden and not warp.fromOtherLevel
                and (not warp.locked or (p.holdingNPC ~= nil and p.holdingNPC.id == 31))
                and (warp.starsRequired <= SaveData.totalStarCount)
                then
                    -- Make sure whoever player is going in... goes in
                    p:teleport(warp.exitX, warp.exitY)
                    smasWarpSystem.alternativeInstantWarpCooldown = 50
                end
            end
        end
    end
    if smasWarpSystem.alternativeInstantWarpCooldown > 0 then
        smasWarpSystem.alternativeInstantWarpCooldown = smasWarpSystem.alternativeInstantWarpCooldown - 1
    end
end

return smasWarpSystem