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

local name = require "socket"
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

function love.update(dt)
  -- body...
    for ball_no = 1, #fixed_balls do
      fixed_balls[ball_no]:update_radius_on_touch(love.mouse.getX(), love.mouse.getY())
  end
end

function love.load(arg)

  load_wild_colors()

  love.window.setMode(1366, 786, {resizable=true, vsync=false, minwidth=400, minheight=300})
  local ball_radius = 20
  local num_rows, num_columns, ball_cordinates =
      utl.get_ball_cordinates(love.graphics.getWidth(),love.graphics.getHeight(), ball_radius)

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
end

function love.draw()
  for ball_no = 1, #fixed_balls do
      fixed_balls[ball_no]:fix_draw()
  end
end
