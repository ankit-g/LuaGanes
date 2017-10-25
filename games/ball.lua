--local log = require('log')
--log.outfile = 'ball.c'

local Ball = {}

Ball.__index = Ball

local utl = require "utility"

function getDistance(x1, y1, x2, y2)
        return math.ceil(math.sqrt((x1-x2)^2 + (y1-y2)^2))
end

Ball.new = function (x, y, radius, mode)
    local self = setmetatable({}, Ball)
    self.radius = radius
    self.orignal_radius = radius
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

Ball.update_radius_on_touch = function(self, mouse_x, mouse_y)
    distance = getDistance(self.x, self.y, mouse_x, mouse_y)
    if distance <= self.orignal_radius then
      self.radius = self.orignal_radius + 20
    else
      self.radius = self.orignal_radius
    end
end

Ball.draw = function (self, x, y, color)
  assert(type(color) == 'table')
  --log.trace('color type '..type(color))
  love.graphics.setColor(unpack(color))
  love.graphics.circle(self.mode, x, y, self.radius, 100)
end

return Ball
