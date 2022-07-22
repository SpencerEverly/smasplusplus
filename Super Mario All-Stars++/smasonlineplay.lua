if (SMBX_VERSION == VER_SEE_MOD) == false then return end

local smasonlineplay = {}

local inspect = require("ext/inspect")

local udp = assert(socket.udp())
local udp2 = assert(socket.udp())
local data

assert(udp:settimeout(0))
assert(udp2:settimeout(0))

if socket.dns.gethostname() == "SPENCERPC2022" then
    assert(udp:setsockname("*",12345))
    assert(udp:setpeername("25.3.160.51",12345))
    assert(udp2:setsockname("*",12344))
    assert(udp2:setpeername("25.3.160.51",12344))
end
if socket.dns.gethostname() == "SPENCERLAPTOP2020" then
    assert(udp:setsockname("*",12343))
    assert(udp:setpeername("25.3.161.35",12343))
    assert(udp2:setsockname("*",12342))
    assert(udp2:setpeername("25.3.161.35",12342))
end

function smasonlineplay.onInitAPI()
    registerEvent(smasonlineplay,"onStart")
    registerEvent(smasonlineplay,"onTick")
    registerEvent(smasonlineplay,"onDraw")
end

local p1coordinates
local p1coordinatefinal

local p2coordinates
local p2coordinatefinal

local p1coordinatessending
local p2coordinatessending

local data, msg_or_ip, port_or_nil

smasonlineplay.onlineactivated = false

function smasonlineplay.onStart()
    smasonlineplay.onlineactivated = true
end

function smasonlineplay.onDraw()
    while smasonlineplay.onlineactivated do
        if player2Active() then
            if socket.dns.gethostname() == "SPENCERLAPTOP2020" then
                data, msg_or_ip, port_or_nil = udp2:receive()
                --Player 1 (Recieving)
                if data then
                    if data == nil then
                        Text.print("Not connected.", 100, 120)
                    else
                        Text.print(p2coordinatesfinal, 100, 120)
                    end
                end
                --Player 2 (Sending)
                p2coordinates = {player2.x, player2.y}
                p2coordinatessending = assert(udp:send(inspect(p2coordinates)))
                if p2coordinatessending == nil then
                    Text.print("Not connected.", 100, 100)
                else
                    Text.print(p2coordinates, 100, 100)
                end
            end
            if socket.dns.gethostname() == "SPENCERPC2022" then
                --Player 1 (Sending)
                p1coordinates = {player.x, player.y}
                p1coordinatessending = assert(udp2:send(inspect(p1coordinates)))
                if p1coordinatessending == nil then
                    Text.print("Not connected.", 100, 100)
                else
                    Text.print(p1coordinates, 100, 100)
                end
                --Player 2 (Recieving)
                data, msg_or_ip, port_or_nil = assert(udp:receive())
                if data then
                    if data == nil then
                        Text.print("Not connected.", 100, 120)
                    else
                        Text.print(p2coordinatesfinal, 100, 120)
                    end
                end
            end
            if msg_or_ip == 'timeout' then
                error("Unknown network error: "..tostring(msg))
            end
            socket.sleep(0.01)
        end
    end
end

return smasonlineplay