if (SMBX_VERSION == VER_SEE_MOD) == false then return end

local smasonlineplay = {}

local udp = assert(socket.udp())
local data

udp:settimeout(1)
if socket.dns.gethostname() == "SPENCERPC2022" then
    assert(udp:setsockname("*",12345))
    assert(udp:setpeername("25.3.161.35",12345))
end
if socket.dns.gethostname() == "SPENCERLAPTOP2020" then
    assert(udp:setsockname("*",12345))
    assert(udp:setpeername("25.3.160.51",12345))
end

for i = 0, 2, 1 do
    assert(udp:send("Connected"))
    data = udp:receive()
    if data then
        break
    end
end

function smasonlineplay.onInitAPI()
    registerEvent(smasonlineplay,"onTick")
    registerEvent(smasonlineplay,"onDraw")
end

local p2coordinatex
local p2coordinatey

local data2

function smasonlineplay.onDraw()
    if player2Active() then
        if socket.dns.gethostname() == "SPENCERLAPTOP2020" then
            p2coordinatex = tostring(player2.x)
            p2coordinatey = tostring(player2.y)
            udp:send(p2coordinatex)
            udp:send(p2coordinatey)
        end
        if socket.dns.gethostname() == "SPENCERPC2022" then
            data2 = udp:receive()
            if data2 then
                Text.print(data2, 100, 160)
            end
        end
    end
    if data == nil then
        Text.print("Not Connected", 100, 100)
    else
        Text.print(data, 100, 100)
    end
    Text.print(p2coordinatex, 100, 120)
    Text.print(p2coordinatey, 100, 140)
end

return smasonlineplay