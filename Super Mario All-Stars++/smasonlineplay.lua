if (SMBX_VERSION == VER_SEE_MOD) == false then return end

local smasonlineplay = {}

local udp = assert(socket.udp())
local data

udp:settimeout(1)
assert(udp:setsockname("*",12345))
assert(udp:setpeername("25.3.161.35",12345))

for i = 0, 2, 1 do
    assert(udp:send("ping"))
    data = udp:receive()
    if data then
        break
    end
end

function smasonlineplay.onInitAPI()
    registerEvent(smasonlineplay,"onTick")
    registerEvent(smasonlineplay,"onDraw")
end

function smasonlineplay.onTick()
    
end

function smasonlineplay.onDraw()
    if data == nil then
        Text.print("Timeout", 100, 100)
    else
        Text.print(data, 100, 100)
    end
end

return smasonlineplay