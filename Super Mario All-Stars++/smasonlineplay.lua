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

local p2coordinatefinalx
local p2coordinatefinaly

function smasonlineplay.onDraw()
    if player2Active() then
        if socket.dns.gethostname() == "SPENCERLAPTOP2020" then
            p2coordinatex = tostring(player2.x)
            p2coordinatey = tostring(player2.y)
            assert(udp:send(p2coordinatex))
            assert(udp:send(p2coordinatey))
            Text.print(p2coordinatex, 100, 120)
            Text.print(p2coordinatey, 100, 140)
        end
        if socket.dns.gethostname() == "SPENCERPC2022" then
            p2coordinatefinalx = udp:receive(p2coordinatex)
            p2coordinatefinaly = udp:receive(p2coordinatey)
            Text.print(p2coordinatefinalx, 100, 120)
            Text.print(p2coordinatefinaly, 100, 140)
        end
    end
    if data == nil then
        Text.print("Not Connected", 100, 100)
    else
        Text.print(data, 100, 100)
    end
end

return smasonlineplay