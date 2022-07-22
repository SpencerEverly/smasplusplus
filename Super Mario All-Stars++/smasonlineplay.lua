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

local udp5 = assert(socket.udp())
udp5:settimeout(0)

local udp6 = assert(socket.udp())
udp6:settimeout(0)

if socket.dns.gethostname() == "SPENCERPC2022" then
    assert(udp:setsockname("*",12345))
    assert(udp:setpeername("25.3.160.51",12345))
    assert(udp2:setsockname("*",12344))
    assert(udp2:setpeername("25.3.160.51",12344))
    assert(udp3:setsockname("*",12343))
    assert(udp3:setpeername("25.3.160.51",12343))
    assert(udp4:setsockname("*",12342))
    assert(udp4:setpeername("25.3.160.51",12342))
    assert(udp5:setsockname("*",12341))
    assert(udp5:setpeername("25.3.160.51",12341))
    assert(udp6:setsockname("*",12340))
    assert(udp6:setpeername("25.3.160.51",12340))
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
    assert(udp5:setsockname("*",12341))
    assert(udp5:setpeername("25.3.161.35",12341))
    assert(udp6:setsockname("*",12340))
    assert(udp6:setpeername("25.3.161.35",12340))
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
local p2direction
local p2character

local p2coordinatefinalx
local p2coordinatefinaly
local p2finalpowerup
local p2finalframe
local p2finaldirection
local p2finalcharacter

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
                p2powerup = player2.powerup
                p2frame = player2.frame
                p2direction = player2.direction
                p2character = player2.character
                
                assert(udp:send(p2coordinatex))
                assert(udp2:send(p2coordinatey))
                assert(udp3:send(p2powerup))
                assert(udp4:send(p2frame))
                assert(udp5:send(p2direction))
                assert(udp6:send(p2character))
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
                p2finaldirection = assert(udp5:receive())
                p2finalcharacter = assert(udp6:receive())
                if p2coordinatesfinalx == nil or p2coordinatesfinaly == nil or p2finalpowerup == nil or p2finalframe == nil then
                    Text.print("Not connected.", 100, 80)
                else
                    Text.print(p2coordinatesfinalx, 100, 100)
                    Text.print(p2coordinatesfinaly, 100, 120)
                    Text.print(p2finalpowerup, 100, 140)
                    Text.print(p2finalframe, 100, 160)
                    Text.print(p2finaldirection, 100, 180)
                    Text.print(p2finalcharacter, 100, 200)
                    player2.x = tonumber(p2coordinatesfinalx)
                    player2.y = tonumber(p2coordinatesfinaly)
                    player2.powerup = tonumber(p2finalpowerup)
                    player2.frame = tonumber(p2finalframe)
                    player2.direction = tonumber(p2finaldirection)
                    player2.character = tonumber(p2finalcharacter)
                end
            end
        end
    end
end

return smasonlineplay