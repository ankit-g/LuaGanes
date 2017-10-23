--local log = require('log')
--log.outfile = 'ball.c'

local Ball = {}

Ball.__index = Ball

Ball.new = function (radius, mode)
    local self = setmetatable({}, Ball)
    self.radius = radius
    self.mode = mode
    return self
end

Ball.draw = function (self, x, y, color)
  assert(type(color) == 'table')
  --log.trace('color type '..type(color))
  love.graphics.setColor(unpack(color))
  love.graphics.circle(self.mode, x, y, self.radius, 100)
end

return Ball
