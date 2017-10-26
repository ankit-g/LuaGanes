--local log = require('log')
--log.outfile = 'ball.c'

local Ball = {}

Ball.__index = Ball

local utl = require "utility"

function getDistance(x1, y1, x2, y2)
        return math.ceil(math.sqrt((x1-x2)^2 + (y1-y2)^2))
end

Ball.new = function (x, y, radius, mode, color)
    local self = setmetatable({}, Ball)
    self.radius = radius
    self.orignal_radius = radius
    self.mode = mode
    self.x = x
    self.y = y
    self.color = color
    self.orignal_color = color
    return self
end

Ball.fix_draw = function (self)
  assert(type(self.color) == 'table')
  --log.trace('color type '..type(color))
  love.graphics.setColor(unpack(self.color))
  love.graphics.circle(self.mode, self.x, self.y, self.radius, 100)
end

Ball.update_radius_on_touch = function(self, mouse_x, mouse_y)
    distance = utl.getDistance(self.x, self.y, mouse_x, mouse_y)
    if distance <= self.orignal_radius then
      self.radius = self.orignal_radius + math.random(0, 5)
      self.color  = {255, 0, 0, 255}
    elseif distance == math.random(100, 200) then
      self.color = {math.random(0, 255), math.random(0, 255),math.random(0, 255), 255}
      self.radius = self.orignal_radius - math.random(5, 10)
      --self.color  = {0, 255, 0, 255}
    elseif distance == math.random(201, 300) then
      self.radius = self.orignal_radius - 5
    elseif distance == math.random(400, 500) then
      self.radius = self.orignal_radius + math.random(1, 10)
    elseif distance == self.orignal_radius*2 then
      self.radius = self.orignal_radius
      --self.color = self.orignal_color
    end
end

Ball.draw = function (self, x, y, color)
  assert(type(color) == 'table')
  --log.trace('color type '..type(color))
  love.graphics.setColor(unpack(color))
  love.graphics.circle(self.mode, x, y, self.radius, 100)
end

return Ball
