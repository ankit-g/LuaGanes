require 'love.graphics'
require 'socket'

local coordinate = require 'coordinates'
local log = require'log'
local clock = os.clock
log.outfile = 'thread_log.c'


function sleep(n)  -- seconds
	  local t0 = clock()
	    while clock() - t0 <= n do end
end

-- thread
channel 	= {};
channel.a	= love.thread.getChannel ( "a" );

coordinate.set_res(love.graphics.getWidth(), love.graphics.getHeight())

while true do
	sleep(0.1)
	if channel.a:getCount() == 0 then
		xy = {}
		coordinate.update()
		xy.x, xy.y = coordinate.getXY()
		channel.a:push(xy);
	end
end
