local Actor = {}

Actor.__index = Actor

local action = function ()
	print ('salva mea')
	end

Actor.new = function ()
	local self = setmetatable({}, Actor)
	self.name = 'default'
	return self
	end

function Actor.set_name(self, name)
--	Actor.name = name this is a class variable visible by 
--	all instances of the class.
	self.name = name
	end

function Actor.get_name(self)
--	return Actor.name
	action()
	return self.name
	end

return Actor
