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
            p2upkey = player2.keys.up
            p2downkey = player2.keys.down
            p2leftkey = player2.keys.left
            p2rightkey = player2.keys.right
            p2runkey = player2.keys.run
            p2jumpkey = player2.keys.jump
            p2altrunkey = player2.keys.altRun
            p2altjumpkey = player2.keys.altJump
            p2reservekey = player2.keys.dropItem
            p2pausekey = player2.keys.pause
        end
    end
end

function smasonlineplay.onDraw()
    if player2Active() then
        if socket.dns.gethostname() == "SPENCERLAPTOP2020" then
            udp:send(p2upkey)
            udp:send(p2downkey)
            udp:send(p2leftkey)
            udp:send(p2rightkey)
            udp:send(p2jumpkey)
            udp:send(p2runkey)
            udp:send(p2altjumpkey)
            udp:send(p2altrunkey)
            udp:send(p2reservekey)
            udp:send(p2pausekey)
        end
    end
    if data == nil then
        Text.print("Not Connected", 100, 100)
    else
        Text.print(data, 100, 100)
    end
end

return smasonlineplay