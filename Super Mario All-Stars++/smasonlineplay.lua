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

local p2upkey
local p2downkey
local p2leftkey
local p2rightkey
local p2runkey
local p2jumpkey
local p2altrunkey
local p2altjumpkey
local p2reservekey
local p2pausekey

function smasonlineplay.onInputUpdate()
    if player2Active() then
        if socket.dns.gethostname() == "SPENCERLAPTOP2020" then
            p2coordinatex = tostring(player2.x)
            p2coordinatey = tostring(player2.y)
        end
    end
end

function smasonlineplay.onDraw()
    if player2Active() then
        if socket.dns.gethostname() == "SPENCERLAPTOP2020" then
            udp:send(p2coordinatex)
            udp:send(p2coordinatey)
        end
        if socket.dns.gethostname() == "SPENCERPC2022" then
            player2.x = tonumber(p2coordinatex)
            player2.y = tonumber(p2coordinatey)
        end
    end
    if data == nil then
        Text.print("Not Connected", 100, 100)
    else
        Text.print(data, 100, 100)
    end
end

return smasonlineplay