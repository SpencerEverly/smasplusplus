local fastFireballs = {}
--v1.0

local textplus = require("textplus")

function fastFireballs.onInitAPI()
    registerEvent(fastFireballs, "onTick")
    registerEvent(fastFireballs, "onNPCKill")
end
fastFireballs.showMeDebug = false
local cam = Camera.get()[1] --for debug


local playerBallCount = {0,0}
fastFireballs.limit = 2

function fastFireballs.onTick()
    for kp, p in ipairs(Player.get()) do
        if not p:mem(0x50, FIELD_BOOL) or p.powerup ~= 3 then

            --Assosiate Fireball to Player
            for kn, n in ipairs(NPC.getIntersecting(p.x-6, p.y-6, p.x+p.width+6, p.y+p.height+6)) do
                if n.id == 13 and n.ai3 == 0 then --This checks if ai3 is 0, which means it's ownerless.
                    n.ai3 = kp
                    playerBallCount[kp] = playerBallCount[kp] + 1
                end
            end

            if playerBallCount[kp] < fastFireballs.limit then
                p:mem(0x160,FIELD_WORD,0) -- Allow Shooting
            else
                p:mem(0x160,FIELD_WORD,1) -- Disable Shooting
            end

            --Reset Fireball counting to 0 when there are no fireballs (In case it bugs out)
            if #NPC.get(13) == 0 then
                playerBallCount[kp] = 0
            end


----------------------------------------DEBUG-------------------------------------------------------------------------------------------------------------------
            if fastFireballs.showMeDebug then
                function print(line, text, variable,color,x,y)
                    debugFont = textplus.loadFont("scripts/textplus/font/11.ini")
                    if x == nil or y == nil then
                        textplus.print{font=debugFont,xscale=1.5,yscale=1.5,x=20^kp*1.02,y=(6+line)*15,text=text..": "..tostring(variable),color=color}
                    else
                        textplus.print{font=debugFont,xscale=1.5,yscale=1.5,x=x,y=y,text=tostring(variable),color=color}
                    end
                end
                --print(2,    "Pressing Run Button",            (p.keys.run or p.keys.altRun)    )
                
                --print(3,    "0x160 (WORD)",                        p:mem(0x160,FIELD_WORD)            )
                --print(4,    "0x160 (BOOL)",                        p:mem(0x160,FIELD_BOOL)            )
                print(5,    "Fireball Count (P"..kp..")",    playerBallCount[kp]                    )
                print(6,    "Total Fireball Count",            #NPC.get(13)                    )
                for kn, n in ipairs(NPC.get(13)) do
                    print(nil,    nil,        "Owner: P"..(n.ai3)        ,nil                ,n.x-Camera.get()[kp].x-32,        n.y-Camera.get()[kp].y-12    )
                end
            end
----------------------------------------------------------------------------------------------------------------------------------------------------------------
        end
    end
end


function fastFireballs.onNPCKill(eventObj, npc, harmtype)
    for kp, p in ipairs(Player.get()) do
        if npc.ai3 == kp then
            playerBallCount[kp] = playerBallCount[kp] - 1
        end
    end
end

return fastFireballs