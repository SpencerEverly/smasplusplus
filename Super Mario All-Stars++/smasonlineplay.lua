if (SMBX_VERSION == VER_SEE_MOD) == false then return end

local smasonlineplay = {}

local inspect = require("ext/inspect")

local udp = assert(socket.udp())
udp:settimeout(0)

local udp2 = assert(socket.udp())
udp2:settimeout(0)

if socket.dns.gethostname() == "SPENCERPC2022" then
    assert(udp:setsockname("*",12345))
    assert(udp:setpeername("25.3.160.51",12345))
    assert(udp2:setsockname("*",12344))
    assert(udp2:setpeername("25.3.160.51",12344))
end
if socket.dns.gethostname() == "SPENCERLAPTOP2020" then
    assert(udp:setsockname("*",12345))
    assert(udp:setpeername("25.3.161.35",12345))
    assert(udp2:setsockname("*",12344))
    assert(udp2:setpeername("25.3.161.35",12344))
end

function smasonlineplay.onInitAPI()
    registerEvent(smasonlineplay,"onStart")
    registerEvent(smasonlineplay,"onTick")
    registerEvent(smasonlineplay,"onDraw")
end

local p2coordinatex
local p2coordinatey

local p2coordinatefinalx
local p2coordinatefinaly

smasonlineplay.onlineactivated = false

function smasonlineplay.onStart()
    smasonlineplay.onlineactivated = true
end

function smasonlineplay.onDraw()
    if smasonlineplay.onlineactivated then
        if player2Active() then
            if socket.dns.gethostname() == "SPENCERLAPTOP2020" then
                p2coordinatex = player2.x
                p2coordinatey = player2.y
                assert(udp:send(p2coordinatex))
                assert(udp2:send(p2coordinatey))
                Text.print(inspect(p2coordinates), 100, 120)
            end
            if socket.dns.gethostname() == "SPENCERPC2022" then
                p2coordinatesfinalx = assert(udp:receive())
                p2coordinatesfinaly = assert(udp2:receive())
                if p2coordinatesfinalx == nil or p2coordinatesfinaly == nil then
                    Text.print("Not connected.", 100, 120)
                else
                    Text.print(p2coordinatesfinalx, 100, 100)
                    Text.print(p2coordinatesfinaly, 100, 120)
                    player2.x = tonumber(p2coordinatesfinalx)
                    player2.y = tonumber(p2coordinatesfinaly)
                end
            end
        end
    end
end

return smasonlineplay