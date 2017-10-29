local Coordinates = {}
local log = require'log'
log.outfile = 'other'

local updated = false


function Coordinates.set_res(width, height)
	Coordinates.width = width
	Coordinates.height = height
end

function Coordinates.update()
	Coordinates.x = math.random(10, Coordinates.width)
	Coordinates.y = math.random(10, Coordinates.height)
	updated = true
end

function Coordinates.getXY()
	if (updated == true) then
		updated = false
		return Coordinates.x, Coordinates.y
	elseif (updated == false) then
		return -1, -1
	end
end

function is_updated() return updated end

return Coordinates
