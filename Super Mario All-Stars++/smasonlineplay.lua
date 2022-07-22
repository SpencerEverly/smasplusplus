if (SMBX_VERSION == VER_SEE_MOD) == false then return end

local smasonlineplay = {}

local inspect = require("ext/inspect")

local udp = assert(socket.udp())
udp:settimeout(0)

local udp2 = assert(socket.udp())
udp2:settimeout(0)

local udp3 = assert(socket.udp())
udp3:settimeout(0)

local udp4 = assert(socket.udp())
udp4:settimeout(0)

if socket.dns.gethostname() == "SPENCERPC2022" then
    assert(udp:setsockname("*",12345))
    assert(udp:setpeername("25.3.160.51",12345))
    assert(udp2:setsockname("*",12344))
    assert(udp2:setpeername("25.3.160.51",12344))
    assert(udp3:setsockname("*",12343))
    assert(udp3:setpeername("25.3.160.51",12343))
    assert(udp4:setsockname("*",12342))
    assert(udp4:setpeername("25.3.160.51",12342))
end
if socket.dns.gethostname() == "SPENCERLAPTOP2020" then
    assert(udp:setsockname("*",12345))
    assert(udp:setpeername("25.3.161.35",12345))
    assert(udp2:setsockname("*",12344))
    assert(udp2:setpeername("25.3.161.35",12344))
    assert(udp3:setsockname("*",12343))
    assert(udp3:setpeername("25.3.161.35",12343))
    assert(udp4:setsockname("*",12342))
    assert(udp4:setpeername("25.3.161.35",12342))
end

function smasonlineplay.onInitAPI()
    registerEvent(smasonlineplay,"onStart")
    registerEvent(smasonlineplay,"onTick")
    registerEvent(smasonlineplay,"onDraw")
end

local p2coordinatex
local p2coordinatey
local p2powerup
local p2frame

local p2coordinatefinalx
local p2coordinatefinaly
local p2finalpowerup
local p2finalframe

smasonlineplay.onlineactivated = false

function smasonlineplay.onStart()
    smasonlineplay.onlineactivated = true
end

function smasonlineplay.onDraw()
    if smasonlineplay.onlineactivated then
        if player2Active() then
            if not "timeout" then
                if socket.dns.gethostname() == "SPENCERLAPTOP2020" then
                    p2coordinatex = player2.x
                    p2coordinatey = player2.y
                    p2powerup = player2.powerup
                    p2frame = player2.frame
                    
                    assert(udp:send(p2coordinatex))
                    assert(udp2:send(p2coordinatey))
                    assert(udp3:send(p2powerup))
                    assert(udp4:send(p2frame))
                    Text.print(p2coordinatesx, 100, 100)
                    Text.print(p2coordinatesy, 100, 120)
                    Text.print(p2powerup, 100, 140)
                    Text.print(p2frame, 100, 160)
                end
                if socket.dns.gethostname() == "SPENCERPC2022" then
                    p2coordinatesfinalx = assert(udp:receive())
                    p2coordinatesfinaly = assert(udp2:receive())
                    p2finalpowerup = assert(udp3:receive())
                    p2finalframe = assert(udp4:receive())
                    if p2coordinatesfinalx == nil or p2coordinatesfinaly == nil or p2finalpowerup == nil or p2finalframe == nil then
                        Text.print("Not connected.", 100, 80)
                    else
                        Text.print(p2coordinatesfinalx, 100, 100)
                        Text.print(p2coordinatesfinaly, 100, 120)
                        Text.print(p2finalpowerup, 100, 140)
                        Text.print(p2finalframe, 100, 160)
                        player2.x = tonumber(p2coordinatesfinalx)
                        player2.y = tonumber(p2coordinatesfinaly)
                        player2.powerup = tonumber(p2finalpowerup)
                        player2.frame = tonumber(p2finalframe)
                    end
                end
            else
                Text.print("Not connected.", 100, 100)
            end
        end
    end
end

return smasonlineplay