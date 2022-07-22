if (SMBX_VERSION == VER_SEE_MOD) == false then return end

local smasonlineplay = {}

local inspect = require("ext/inspect")

local udp = assert(socket.udp())
local data

assert(udp:settimeout(0))

if socket.dns.gethostname() == "SPENCERPC2022" then
    assert(udp:setsockname("*",12345))
    assert(udp:setpeername("25.3.160.51",12345))
end
if socket.dns.gethostname() == "SPENCERLAPTOP2020" then
    assert(udp:setsockname("*",12345))
    assert(udp:setpeername("25.3.161.35",12345))
end

function smasonlineplay.onInitAPI()
    registerEvent(smasonlineplay,"onStart")
    registerEvent(smasonlineplay,"onTick")
    registerEvent(smasonlineplay,"onDraw")
end

local p2coordinates
local p2coordinatefinal

smasonlineplay.onlineactivated = false

function smasonlineplay.onStart()
    smasonlineplay.onlineactivated = true
end

function smasonlineplay.onDraw()
    if smasonlineplay.onlineactivated then
        if player2Active() then
            if socket.dns.gethostname() == "SPENCERLAPTOP2020" then
                p2coordinates = {player2.x, player2.y}
                assert(udp:send(inspect(p2coordinates)))
                Text.print(inspect(p2coordinates), 100, 120)
            end
            if socket.dns.gethostname() == "SPENCERPC2022" then
                p2coordinatesfinal = assert(udp:receive())
                if p2coordinatesfinal == nil then
                    Text.print("Not connected.", 100, 120)
                else
                    Text.print(p2coordinatesfinal, 100, 120)
                end
            end
            socket.sleep(0.01)
        end
    end
end

return smasonlineplay