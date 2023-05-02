local Evento = {}

local inspect = require("ext/inspect")

--New event stuff
local GM_NEWEVENT = mem(0x00B2D6E8, FIELD_DWORD)
local GM_NEWEVENTDELAY = mem(0x00B2D704, FIELD_DWORD)

--Event stuff
local GM_EVENT = mem(0x00B2C6CC, FIELD_DWORD)
local GM_EVENTNUM = 0x00B2D710

local EVENTS_STRUCT_SIZE = 0x588
local MAX_EVENTS = 255

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

function Evento.getSoundID(eventName)
    local idxNumber
    local name = {}
    for idx=0,MAX_EVENTS-1 do
        table.insert(name, mem(GM_EVENT+(idx*EVENTS_STRUCT_SIZE)+0x04,FIELD_STRING))
    end
    idxNumber = table.find(name, eventName) - 1
    if idxNumber == nil then
        return 0
    else
        return mem(GM_EVENT+(idxNumber*EVENTS_STRUCT_SIZE)+0x02,FIELD_WORD)
    end
end

function Evento.count()
    local name = {}
    local finalname = {}
    for idx=0,MAX_EVENTS-1 do
        table.insert(name, mem(GM_EVENT+(idx*EVENTS_STRUCT_SIZE)+0x04,FIELD_STRING))
    end
    for k,v in ipairs(name) do
        if v ~= "" then
            table.insert(finalname, v)
        end
    end
    return #finalname
end

local function setCheckpointPath(v)
	mem(0x00B250B0, FIELD_STRING, v);
end

function Evento.clearAllCheckpoints()
    for k,v in ipairs(GameData.__checkpoints) do
        setCheckpointPath("")
        GameData.__checkpoints[v].current = nil
    end
end

return Evento