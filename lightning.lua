local smasExtraSounds = require("smasExtraSounds")

local lightning = {}

local lightningtimer = 0
local lightningcountdown = 0

lightning.mindelay = 32
lightning.maxdelay = 324
lightning.priority = -99.9
lightning.speed = 40
lightning.section = {0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20}

local c1,c2

function lightning.onInitAPI()
    registerEvent(lightning,"onTick")
    registerEvent(lightning,"onCameraDraw")
end

function lightning.onTick()
    if lightningtimer == RNG.randomInt(lightning.mindelay,lightning.maxdelay) or lightningtimer > lightning.maxdelay  then
        lightningtimer = 0
        lightningcountdown = lightning.speed
    else
        lightningtimer = lightningtimer + 1
        if lightningcountdown > 0 then
            lightningcountdown = lightningcountdown - 1
        else
            lightningcountdown = 0
        end
    end
    for _,p in ipairs(Player.get()) do
        if lightning.section[p.section+1] ~= nil and lightningtimer == 0 and lightningcountdown == lightning.speed then
            Sound.playSFX(43)
        end
    end
end

function lightning.onCameraDraw()
    c1 = Camera.get()[1]
    c2 = Camera.get()[2]
    if lightningcountdown > 0 then
        if lightning.section[player.section+1] ~= nil then
            Graphics.drawBox{x=c1.x,y=c1.y,width=c1.width,height=c1.height,sceneCoords=true,color=Color(1,1,1,lightningcountdown/(lightning.speed*1.125)),priority=lightning.priority}
        end
        if Player.count() >= 2 then
            if lightning.section[player2.section+1] ~= nil and c2:mem(0x20,FIELD_BOOL) then
                Graphics.drawBox{x=c2.x,y=c2.y,width=c2.width,height=c2.height,sceneCoords=true,color=Color(1,1,1,lightningcountdown/(lightning.speed*1.125)),priority=lightning.priority}
            end
        end
    end
end

return lightning