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

local p1coordinatessending
local p2coordinatessending

function smasonlineplay.onDraw()
    if player2Active() then
        if unexpected_condition then
            p1coordinates = "Not connected."
            p1coordinatefinal = "Not connected."
            p2coordinates = "Not connected."
            p2coordinatefinal = "Not connected."
        end
        if socket.dns.gethostname() == "SPENCERLAPTOP2020" then
            --Player 2 (Sending)
            p2coordinates = player2.x, player2.y
            p2coordinatessending = assert(udp:send(p2coordinates))
            if p2coordinatessending == nil then
                Text.print("Not connected.", 100, 100)
            else
                Text.print(p2coordinates, 100, 100)
            end
            --Player 1 (Recieving)
            p1coordinatesfinal = assert(udp2:receive())
            if p2coordinatesfinal == nil then
                Text.print("Not connected.", 100, 120)
            else
                Text.print(p2coordinatesfinal, 100, 120)
            end
        end
        if socket.dns.gethostname() == "SPENCERPC2022" then
            --Player 1 (Sending)
            p1coordinates = tostring(player.x, player.y)
            p1coordinatessending = assert(udp2:send(p1coordinates))
            if p1coordinatessending == nil then
                Text.print("Not connected.", 100, 100)
            else
                Text.print(p1coordinates, 100, 100)
            end
            --Player 2 (Recieving)
            p2coordinatesfinal = assert(udp:receive())
            if p2coordinatesfinal == nil then
                Text.print("Not connected.", 100, 120)
            else
                Text.print(p2coordinatesfinal, 100, 120)
            end
        end
    end
end

return smasonlineplay