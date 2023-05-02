-- Enjl wrote about coyote time one fine sunday morning
local ct = {}
 
-- Customization Options:
ct.frames = 5
ct.onJump = function(p, isSpinJumping) end -- Override this in your own code if you have any special jump handling. Passes player and boolean.
 
-- Functionality
 
local timeSinceWasGrounded = {}
 
function ct.onInitAPI()
    registerEvent(ct, "onTick")
end
 
function ct.onTick()
    for k,p in ipairs(Player.get()) do
        if timeSinceWasGrounded[k] == nil then
            timeSinceWasGrounded[k] = 0
        end
        if not p:isGroundTouching() then
            if p.speedY > 0 then
                if timeSinceWasGrounded[k] < ct.frames then
                    if p.keys.jump == KEYS_PRESSED then
                        p.speedY = 0
                        p:mem(0x11E, FIELD_BOOL, true)
                        ct.onJump(p, false)
                    elseif p.keys.altJump == KEYS_PRESSED then
                        p.speedY = 0
                        p:mem(0x120, FIELD_BOOL, true)
                        ct.onJump(p, true)
                    end
                end
            end
            timeSinceWasGrounded[k] = timeSinceWasGrounded[k] + 1
        else
            timeSinceWasGrounded[k] = 0
        end
    end
end
 
return ct