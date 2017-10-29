Coordinates = {}

local updated = false 

function Coordinates.update()
	Coordinates.x = math.random(10, 500)
	Coordinates.y = math.random()
	updated = true
end

function Coordinates.getXY()
	return Coordinates.x, Coordinates.y
end

return Coordinates
