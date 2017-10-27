local socket = require "socket"
local udp = socket.udp()


udp:settimeout(0)
udp:setsockname('*', 12345)

while true do
	data, msg_or_ip, port_or_nil = udp:receivefrom()
	if data then
		print(data)
		print(msg_or_ip)
		print(port_or_nil)
	elseif msg_or_ip ~= 'timeout' then
		error("Unknown network error: "..tostring(msg))
	end
	socket.sleep(0.01)
end
