local lastStars = 0

local STARS_FOR_EVENT = 10 --change this according to how many stars are needed to trigger the event
local EVENT_NAME = "Test1" --change this according to the name of the event

function onStart()
    lastStars = mem(0x00B251E0, FIELD_WORD)
end

function onPostNPCKill(killedNPC, harmType)
    if(killedNPC.id == 196 or killedNPC.id == 97) then
        if(mem(0x00B251E0, FIELD_WORD) > lastStars and mem(0x00B251E0, FIELD_WORD) == STARS_FOR_EVENT) then
            triggerEvent(EVENT_NAME)
        end
        lastStars = mem(0x00B251E0, FIELD_WORD)
    end
end