local Evento = {}

local GM_NEWEVENT = mem(0x00B2D6E8, FIELD_DWORD)
local GM_NEWEVENTDELAY = mem(0x00B2D704, FIELD_DWORD)
local GM_EVENTS_PTR = mem(0x00B2C6CC, FIELD_DWORD)
local GM_NEWEVENTNUM = 0x00B2D710

function Evento.getPendingEvents()
    local eventNum = mem(GM_NEWEVENTNUM, FIELD_WORD)
    local out = {}
    for i = 0,eventNum-1 do
        out[#out+1] = {
            soundid  = mem(GM_NEWEVENT+i*0x02, FIELD_BYTE),
            name     = mem(GM_NEWEVENT+i*0x04, FIELD_STRING),
            message  = mem(GM_NEWEVENT+i*0x06, FIELD_STRING),
            delay    = mem(GM_NEWEVENTDELAY+i*0x02, FIELD_WORD),
        }
    end
    return out
end

--[[function Evento.getSoundID(eventName)
    if eventName == nil then
        error("You must have an event name.")
        return
    else
        local eventNum = mem(0x00B2D710, FIELD_WORD)
        local out = {}
        for i = 0,eventNum-1 do
            out[#out+1] = {
                soundid  = mem(GM_EVENTS_PTR+i*2, FIELD_WORD),
                name     = mem(GM_EVENTS_PTR+i*4, FIELD_STRING),
            }
        end
        return out
    end
end]]

return Evento