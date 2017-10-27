local socket = require "socket"
 
-- the address and port of the server
local address, port = "localhost", 12345

udp = socket:udp()
udp:settimeout(0)

udp:setpeername(address, port)
while true do
	for i=1, 10 do
		local dg = string.format("%s %s %d %d", 'bala', 'at', i, 240)
		udp:send(dg)
		socket.sleep(1)
	end
end
