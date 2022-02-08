local lastXSpeed = {}
local ppp = {}

ppp.speedXDecelerationModifier = 0.08
ppp.groundTouchingDecelerationMultiplier = 1
ppp.groundNotTouchingDecelerationMultiplier = 2

ppp.accelerationMaxSpeedThereshold = 2
ppp.accelerationMinSpeedThereshold = 0.1
ppp.accelerationSpeedDifferenceThereshold = 0.2
ppp.accelerationMultiplier = 1.5

ppp.aerialIdleDeceleration = 0.98

ppp.enabled = true

function ppp.onInitAPI()
    registerEvent(ppp, "onTick")
end

function ppp.onTick()-- (deceleration tightness)
    if ppp.enabled then
        for k,p in ipairs(Player.get()) do
            lastXSpeed[k] = lastXSpeed[k] or 0
            if not player:mem(0x3C, FIELD_BOOL) then
                if (not (p:isGroundTouching() and p:mem(0x12E, FIELD_BOOL))) then
                    local mod = ppp.groundTouchingDecelerationMultiplier
                    if (not p:isGroundTouching()) then
                        mod = ppp.groundNotTouchingDecelerationMultiplier
                    end
                    if p.rightKeyPressing then
                        if p.speedX < 0 then
                            p.speedX = p.speedX + ppp.speedXDecelerationModifier * mod;
                        end
                    elseif p.leftKeyPressing then
                        if  p.speedX > 0 then
                            p.speedX = p.speedX - ppp.speedXDecelerationModifier * mod;
                        end
                    else
                        p.speedX = p.speedX * ppp.aerialIdleDeceleration;	
                    end
                end
            
            -- (acceleration tightness)
                local xspeeddiff = p.speedX - lastXSpeed[k]

                if math.abs(p.speedX) < ppp.accelerationMaxSpeedThereshold and math.abs(p.speedX) > ppp.accelerationMinSpeedThereshold and math.sign(p.speedX * xspeeddiff) == 1 and math.abs(xspeeddiff) <= ppp.accelerationSpeedDifferenceThereshold then
                    p.speedX = p.speedX - xspeeddiff
                    p.speedX = p.speedX + xspeeddiff * ppp.accelerationMultiplier
                end

            end
            lastXSpeed[k] = p.speedX
        end
    end
end

return ppp