local yellow = {255, 255, 0, 255}
local one = {255, 0, 255, 255}
local two = {0, 255, 255, 255}
local red = {255, 0, 0, 255}
local green = {0, 255, 0, 255}
local blue  = {0, 0, 255, 255}
local white = {255, 255, 255, 255}
local dark = {100, 40, 50, 255}
--not adding white (looks ugly)
local colors = {red, yellow, blue, green, one, two, dark}
local tbl_clr = {}

local Ball = require('ball')
local ball_one = Ball.new(20, 'fill')
math.random(os.time())
--local log = require 'log'
--log.outfile = 'game_log.c'

function love.load(arg)
end

local function draw_circle_line(x, y, line_number)
    for i = 1, 20 do
        ball_one:draw(x, y, colors[math.random(1, #colors)])
        x = x + 40
    end
end

function love.draw()
  --log.trace('red type '..type(red))
    x, y = 20, 20
    for line = 1, 15 do
        draw_circle_line(x, y, line)
        y = y + 40
    end
    love.timer.sleep(1/4)
end
