--host.lua for the SMAS++ Online Multiplayer Feature
--By Spencer Everly (Some code derived from hizhawk-co-op by TheOnlyOne/TestRunnerSRL)
--WILL ONLY WORK WITH THE SEE MOD!!!!!! DO NOT LOAD WITH THE ORIGINAL LUNALUA

local wifihoster = {}

function wifihoster.onInitAPI()
	registerEvent(wifihoster,"onStart")
	registerEvent(wifihoster,"onTick")
	registerEvent(wifihoster,"onDraw")
end

local HOME_ADDR = '192.168.0.1'
local SUBNET_PATTERN = '%d+%.%d+%.%d+%.'

local function get_own_address()
  local s = assert(socket.udp())
  assert(s:setpeername(HOME_ADDR, 80))
  local host = s:getsockname()
  s:close()
  return host
end

function broadcast(message, address, port)
  local broadcaster = assert(socket:udp())
  assert(broadcaster:setoption('broadcast', true))
  assert(broadcaster:setoption('dontroute', true))   -- do we need this?

  print(('Broadcasting %q to %s:%i'):format(message, address, port))
  assert(broadcaster:sendto(message, address, port))
  broadcaster:close()
end

function antiphony(message, timeout, call_port, response_port, response_mask)
  local message, timeout, mask = tostring(message), tonumber(timeout) or 1.5, response_mask or '*a'
  local send_port, recv_port = call_port or 10500, response_port or 10501
  local broadcast_address = get_own_address():match(SUBNET_PATTERN) .. '255'
  local listener = assert(socket.bind('*', recv_port, 64))
  local clients, responses, starttime = {}, {}

  listener:settimeout(0)
  broadcast(message, broadcast_address, send_port)
  starttime = socket.gettime()
  repeat clients[listener:accept() or false] = true
  until socket.gettime() - starttime > timeout

  for client in pairs(clients) do 
    if client then
      responses[client:getpeername()] = tostring(client:receive(mask))
      client:close()
    end
  end
  listener:close()

  return responses
end

function listen(response_callback, timeout, listen_port, reply_port)
  local recv_port, send_port = tonumber(listen_port) or 10500, tonumber(reply_port) or 10501
  local callback = response_callback or function()end
  local address = get_own_address():match(SUBNET_PATTERN) .. '255'
  local sleeper = socket.udp()

  sleeper:settimeout(timeout)
  sleeper:setsockname(address, recv_port)
  repeat
    local data, ip, port = sleeper:receivefrom(1024)
    if data then callback(ip, send_port, data) end
  until not data
end

function respond(message, data_handler) 
  return function(ip_addr, port, data)
    assert(ip_addr and port, ('Invalid address: %s:%s'):format(tostring(ip_addr), tostring(port)))
    local msg = tostring(type(data_handler) == 'function' and (data_handler(data, message) or messsage) or message)
    local sender = assert(socket.connect(ip_addr, port))
    assert(sender:send(msg))
    sender:close()
  end
end

--[[

-- Listener / Responder:
listen(respond('polo', print), 600) -- 10 minute timeout

-- Broadcaster / Receiever:
for address, response in pairs(antiphony('marco')) do 
  print(address, response) 
end

]]

-- retrieve the answer and print results
function wifihoster.onDraw()
	--Text.print(, 100, 100)
end

return wifihoster