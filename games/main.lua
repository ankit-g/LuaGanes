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

local socket = require "socket"
local utl  = require "utility"
local Ball = require "ball"

local fixed_balls = {}

local color_wild = {}

function load_wild_colors()
  for i = 1, 1000 do
    color_wild[i] = { math.random(0, 255),
                      math.random(0, 255),
                      math.random(0, 255),
                      255}
  end
end


math.random(os.time())
local log = require 'log'
log.outfile = 'game_log.c'
src = love.audio.newSource("redBird.mp3")

local move_ball = {}

math.randomseed(os.time())

love.window.setMode(1366, 786, {resizable=true, vsync=false, minwidth=400, minheight=300})
local SCREEN_HEIGHT = love.graphics.getHeight()
local SCREEN_WIDTH  = love.graphics.getWidth()

speed = 100
function love.update(dt)
  -- body...
    for ball_no = 1, #fixed_balls do
      fixed_balls[ball_no]:update_radius_on_touch(love.mouse.getX(), love.mouse.getY())
  end
  if love.keyboard.isDown('u') and speed < 400 then
    speed = speed + 20*dt
  elseif love.keyboard.isDown('d') and speed > 50 then
    speed = speed - 20*dt
  end

  if love.keyboard.isDown('left') and move_ball:get_x() > 10 then
    move_ball:setXY(-(speed*dt), 0)
  end
  if love.keyboard.isDown('right') and move_ball:get_x() < (SCREEN_WIDTH - 10) then
    move_ball:setXY((speed*dt), 0)
  end
  if love.keyboard.isDown('up') and move_ball:get_y() > 20 then
    move_ball:setXY(0, -(speed*dt))
  end
  if love.keyboard.isDown('down') and move_ball:get_y() < (SCREEN_HEIGHT - 10) then
    move_ball:setXY(0, (speed*dt))
  end
end

function love.load(arg)

  load_wild_colors()

  local ball_radius = 20
  local num_rows, num_columns, ball_cordinates =
      utl.get_ball_cordinates(SCREEN_WIDTH, SCREEN_HEIGHT, ball_radius)

  src:play()
  src:setLooping(true)
  local count = 1

  for row = 1, num_rows do
          for column = 1, num_columns do
                  fixed_balls[count] =
                    Ball.new(ball_cordinates[row][column].x,
                        ball_cordinates[row][column].y, ball_radius, 'fill',color_wild[math.random(1, #color_wild)])
                  count = count + 1
          end
  end
  move_ball = fixed_balls[math.random(1, #fixed_balls)]
end

function love.draw()
  for ball_no = 1, #fixed_balls do
      fixed_balls[ball_no]:fix_draw()
  end
end
