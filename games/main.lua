local yellow = {255, 255, 0, 255}
local one = {255, 0, 255, 255}
local two = {0, 255, 255, 255}
local red = {255, 0, 0, 255}
local green = {0, 255, 0, 255}
local blue  = {0, 0, 255, 255}
local white = {255, 255, 255, 255}
local dark =  {150, 100, 0, 255}
--not adding white (looks ugly)
local colors = {red, yellow, blue, green, one, two, dark}
local tbl_clr = {}

local Ball = require('ball')
local fixed_balls = {}

math.random(os.time())
local log = require 'log'
log.outfile = 'game_log.c'
src = love.audio.newSource("redBird.mp3")

function get_ball_cordinates(x_res, y_res, radius)
         local diameter = radius*2
         -- no of circles in x axis
         local num_columns = x_res / diameter
         local num_rows = y_res / diameter

         local total_circles = num_rows * num_columns
         local x, y = radius, radius

         local ball_cordinates = {}

          for row = 1, num_rows do
                  ball_cordinates[row] = {}
                  x = radius
                  for column = 1, num_columns do
                          ball_cordinates[row][column] = {}
                          ball_cordinates[row][column].x = x
                          ball_cordinates[row][column].y = y
                          x = x + diameter
                  end
                  y = y + diameter
          end
          return num_rows, num_columns, ball_cordinates
end

function love.load(arg)
  local ball_radius = 3
  local num_rows, num_columns, ball_cordinates =
      get_ball_cordinates(love.graphics.getWidth(),love.graphics.getHeight(), ball_radius)

  src:play()
  src:setLooping(true)
  local count = 1

  for row = 1, num_rows do
          for column = 1, num_columns do
                  fixed_balls[count] =
                    Ball.new(ball_cordinates[row][column].x,
                        ball_cordinates[row][column].y, ball_radius, 'fill')
                  count = count + 1
          end
  end
  log.trace(#fixed_balls)
  end

function love.draw()
  for ball_no = 1, #fixed_balls do
      --log.trace(ball_no)
      fixed_balls[ball_no]:fix_draw(colors[math.random(1, #colors)])
  end
  love.timer.sleep(1/4)
end
