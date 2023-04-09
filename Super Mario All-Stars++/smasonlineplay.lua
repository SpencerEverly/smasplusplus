if (SMBX_VERSION == VER_SEE_MOD) == false then return end

local smasOnlinePlay = {}

local inspect = require("ext/inspect")

local udp = socket.udp()
udp:settimeout(0)

if socket.dns.gethostname() == "SPENCERPC2022" then
    udp:setsockname("*",12345)
    udp:setpeername("25.3.160.51",12345)
end
if socket.dns.gethostname() == "SPENCERLAPTOP2020" then
    udp:setsockname("*",12345)
    udp:setpeername("25.3.161.35",12345)
end

function smasOnlinePlay.onInitAPI()
    registerEvent(smasOnlinePlay,"onStart")
    registerEvent(smasOnlinePlay,"onTick")
    registerEvent(smasOnlinePlay,"onDraw")
end

local p2specifics
local p2specificsstring
local p2finalspecifics
local p2finalspecificstable = {}

smasOnlinePlay.onlineactivated = false

function smasOnlinePlay.onStart()
    smasOnlinePlay.onlineactivated = false
end

function smasOnlinePlay.onDraw()
    if smasOnlinePlay.onlineactivated then
        if Player.count() >= 2 then
            if socket.dns.gethostname() == "SPENCERLAPTOP2020" then
                p2specifics = {
                    [1] = player2.x,
                    [2] = player2.y,
                    [3] = player2.powerup,
                    [4] = player2.frame,
                    [5] = player2.direction,
                    [6] = player2.character
                }
                p2specificsstring = tostring(inspect(p2specifics))
                udp:send(p2specificsstring)
                Text.print(inspect(p2specifics), 100, 100)
            end
            if socket.dns.gethostname() == "SPENCERPC2022" then
                p2finalspecifics = udp:receive()
                if p2finalspecifics == nil then
                    Text.print("Not connected.", 100, 100)
                else
                    Text.print(p2finalspecifics, 100, 100)
                    for item in string.gmatch(player2.x, "%S+") do 
                        if string.find(p2finalspecifics, string.lower(item)) then
                            table.insert(p2finalspecificstable, player2.x)
                        end
                    end
                    for item in string.gmatch(player2.y, "%S+") do 
                        if string.find(p2finalspecifics, string.lower(item)) then
                            table.insert(p2finalspecificstable, player2.y)
                        end
                    end
                    for item in string.gmatch(player2.powerup, "%S+") do 
                        if string.find(p2finalspecifics, string.lower(item)) then
                            table.insert(p2finalspecificstable, player2.powerup)
                        end
                    end
                    for item in string.gmatch(player2.frame, "%S+") do 
                        if string.find(p2finalspecifics, string.lower(item)) then
                            table.insert(p2finalspecificstable, player2.frame)
                        end
                    end
                    for item in string.gmatch(player2.direction, "%S+") do 
                        if string.find(p2finalspecifics, string.lower(item)) then
                            table.insert(p2finalspecificstable, player2.direction)
                        end
                    end
                    for item in string.gmatch(player2.character, "%S+") do 
                        if string.find(p2finalspecifics, string.lower(item)) then
                            table.insert(p2finalspecificstable, player2.character)
                        end
                    end
                    player2.x = p2finalspecificstable[1]
                    player2.y = p2finalspecificstable[2]
                    player2.powerup = p2finalspecificstable[3]
                    player2.frame = p2finalspecificstable[4]
                    player2.direction = p2finalspecificstable[5]
                    player2.character = p2finalspecificstable[6]
                end
            end
        end
    end
end

return smasOnlinePlay