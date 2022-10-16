local Evento = {}

local inspect = require("ext/inspect")

function Evento.onInitAPI()
    registerEvent(Evento,"onDraw")
end

--New event stuff
local GM_NEWEVENT = mem(0x00B2D6E8, FIELD_DWORD)
local GM_NEWEVENTDELAY = mem(0x00B2D704, FIELD_DWORD)

--Event stuff
local GM_EVENT = mem(0x00B2C6CC, FIELD_DWORD)
local GM_EVENTNUM = 0x00B2D710

function Evento.getPendingEvents()
    local eventNum = mem(GM_EVENTNUM, FIELD_WORD)
    local out = {}
    for i = 0,eventNum-1 do
        out[#out+1] = {
            soundid  = mem(GM_NEWEVENT+i*0x02, FIELD_WORD),
            name     = mem(GM_NEWEVENT+i*0x04, FIELD_STRING),
            message  = mem(GM_NEWEVENT+i*0x08, FIELD_STRING),
            delay    = mem(GM_NEWEVENTDELAY+i*0x02, FIELD_WORD),
        }
    end
    return out
end

return Evento