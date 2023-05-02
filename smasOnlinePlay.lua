if (SMBX_VERSION ~= VER_SEE_MOD) then return end

local smasOnlinePlay = {}

local inspect = require("ext/inspect")

function smasOnlinePlay.onInitAPI()
    registerEvent(smasOnlinePlay,"onStart")
    registerEvent(smasOnlinePlay,"onTick")
    registerEvent(smasOnlinePlay,"onDraw")
end

local p2specifics
local p2specificsstring
local p2finalspecifics
local p2finalspecificstable = {}

local udp

smasOnlinePlay.onlineActivated = false --Is online activated?
smasOnlinePlay.onlineConnected = false --Are we connected online ready to play?

smasOnlinePlay.canBeginConnecting = false --Whether we can connect with the IP Address set.
smasOnlinePlay.IPHostAddressEntered = "" --The host's IP Address.
smasOnlinePlay.IPClientAddressEntered = "" --The client's IP Address.
smasOnlinePlay.IPHostAddressRecieved = ""
smasOnlinePlay.IPClientAddressRecieved = ""

smasOnlinePlay.IPAddressName = socket.dns.gethostname()

smasOnlinePlay.hasEnteredHostIP = false
smasOnlinePlay.hasEnteredClientIP = false

smasOnlinePlay.tempBoolean = false

smasOnlinePlay.playerSpecifics = {}

function smasOnlinePlay.startConnecting()
    udp = socket.udp()
    udp:settimeout(2)

    udp:setsockname("*",12345)
    udp:setpeername(smasOnlinePlay.IPHostAddressEntered,12345)
    
    udp:send(smasOnlinePlay.IPHostAddressEntered)
    smasOnlinePlay.IPHostAddressRecieved = udp:receive()
    
    if smasOnlinePlay.IPHostAddressRecieved ~= smasOnlinePlay.IPHostAddressEntered then
        udp:close()
        error("Wrong IP!")
    else
        Misc.dialog("Connection values correct!")
        udp:send(smasOnlinePlay.IPClientAddressEntered)
        smasOnlinePlay.IPClientAddressRecieved = udp:receive()
    end
    
    if smasOnlinePlay.IPClientAddressRecieved ~= smasOnlinePlay.IPClientAddressEntered then
        udp:close()
        error("Wrong IP!")
    else
        Misc.dialog("Connection success!")
    end
    
    smasOnlinePlay.onlineConnected = true
end

function smasOnlinePlay.onStart()
    
end

function smasOnlinePlay.onDraw()
    if smasOnlinePlay.onlineActivated then
        
        if smasOnlinePlay.onlineConnected then
            if Player.count() >= 2 then
                if socket.dns.gethostname() == smasOnlinePlay.IPAddressName then
                    p2specifics = {
                        [1] = player2.x,
                        [2] = player2.y,
                        [3] = player2.powerup,
                        [4] = player2.frame,
                        [5] = player2.direction,
                        [6] = player2.character,
                        [7] = player2.speedX,
                        [8] = player2.speedY,
                    }
                    p2specificsstring = tostring(inspect(p2specifics))
                    udp:send(p2specificsstring)
                    Text.print(inspect(p2specifics), 100, 100)
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
                        for item in string.gmatch(player2.speedX, "%S+") do 
                            if string.find(p2finalspecifics, string.lower(item)) then
                                table.insert(p2finalspecificstable, player2.speedX)
                            end
                        end
                        for item in string.gmatch(player2.speedY, "%S+") do 
                            if string.find(p2finalspecifics, string.lower(item)) then
                                table.insert(p2finalspecificstable, player2.speedY)
                            end
                        end
                        player2.x = p2finalspecificstable[1]
                        player2.y = p2finalspecificstable[2]
                        player2.powerup = p2finalspecificstable[3]
                        player2.frame = p2finalspecificstable[4]
                        player2.direction = p2finalspecificstable[5]
                        player2.character = p2finalspecificstable[6]
                        player2.speedX = p2finalspecificstable[7]
                        player2.speedY = p2finalspecificstable[8]
                    end
                end
            end
        end
    end
end

return smasOnlinePlay