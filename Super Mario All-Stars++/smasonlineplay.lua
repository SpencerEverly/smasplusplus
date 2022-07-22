if (SMBX_VERSION == VER_SEE_MOD) == false then return end

local smasonlineplay = {}

local inspect = require("ext/inspect")

local udp = assert(socket.udp())
local udp2 = assert(socket.udp())
local data

udp:settimeout(0)
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
    registerEvent(smasonlineplay,"onTick")
    registerEvent(smasonlineplay,"onDraw")
end

local p1coordinates
local p1coordinatefinal

local p2coordinates
local p2coordinatefinal

function smasonlineplay.onDraw()
    if player2Active() then
        if socket.dns.gethostname() == "SPENCERLAPTOP2020" then
            --Player 2 (Sending)
            p2coordinates = player2.x, player2.y
            if timeout then
                p2coordinates = "Not connected."
            else
                assert(udp:send(p2coordinates))
            end
            Text.print(p2coordinates, 100, 100)
            --Player 1 (Recieving)
            if timeout then
                p1coordinatesfinal = "Not connected."
            else
                p1coordinatesfinal = assert(udp2:receive())
            end
            if p2coordinatesfinal == nil then
                Text.print("Not connected.", 100, 120)
            else
                Text.print(p2coordinatesfinal, 100, 120)
            end
        end
        if socket.dns.gethostname() == "SPENCERPC2022" then
            --Player 1 (Sending)
            p1coordinates = tostring(player.x, player.y)
            if timeout then
                p1coordinates = "Not connected."
            else
                assert(udp2:send(p1coordinates))
            end
            Text.print(p1coordinates, 100, 100)
            --Player 2 (Recieving)
            if timeout then
                p2coordinatesfinal = "Not connected."
            else
                p2coordinatesfinal = assert(udp:receive())
            end
            if p2coordinatesfinal == nil then
                Text.print("Not connected.", 100, 120)
            else
                Text.print(p2coordinatesfinal, 100, 120)
            end
        end
    end
end

return smasonlineplay