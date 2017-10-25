--local log = require('log')
--log.outfile = 'ball.c'

local Ball = {}

Ball.__index = Ball

Ball.new = function (x, y, radius, mode)
    local self = setmetatable({}, Ball)
    self.radius = radius
    self.mode = mode
    self.x = x
    self.y = y
    return self
end

Ball.fix_draw = function (self, color)
  assert(type(color) == 'table')
  --log.trace('color type '..type(color))
  love.graphics.setColor(unpack(color))
  love.graphics.circle(self.mode, self.x, self.y, self.radius, 100)
end

Ball.draw = function (self, x, y, color)
  assert(type(color) == 'table')
  --log.trace('color type '..type(color))
  love.graphics.setColor(unpack(color))
  love.graphics.circle(self.mode, x, y, self.radius, 100)
end

return Ball
