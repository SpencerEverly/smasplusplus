--host.lua for the SMAS++ Online Multiplayer Feature
--By Spencer Everly (Some code derived from hizhawk-co-op by TheOnlyOne/TestRunnerSRL)
--WILL ONLY WORK WITH THE SEE MOD!!!!!! DO NOT LOAD WITH THE ORIGINAL LUNALUA

local wifihoster = {}

function wifihoster.onInitAPI()
	registerEvent(wifihoster,"onStart")
	registerEvent(wifihoster,"onTick")
	registerEvent(wifihoster,"onDraw")
end

--local server = nil
--host.clients = {}
--host.users = {}
--host.playerlist = {}
--host.playerstatus = {}
--host.status = 'Idle'
--host.locked = false
--host.hostname = nil
--host.client_ping = {}

local host = "localhost"
local port = 31337
-- convert host name to ip address
local ip = socket.dns.toip(host)
-- create a new UDP object
local udp = socket.udp()
-- contact daytime host
udp:sendto("anything", ip, port)
--udp:receive()

-- retrieve the answer and print results
function wifihoster.onDraw()
	--Text.print(, 100, 100)
end

return wifihoster