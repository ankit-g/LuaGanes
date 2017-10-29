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


local log = require 'log'
log.outfile = 'game_log.c'

math.randomseed(os.time())

love.window.setMode(1366, 768, {resizable=true, vsync=false, minwidth=400, minheight=300})
local SCREEN_HEIGHT = love.graphics.getHeight()
local SCREEN_WIDTH  = love.graphics.getWidth()

function love.update(dt)
  if thread:isRunning() == false then
    log.trace(thread:isRunning(), thread:getError())
  end
end

function love.load(arg)

thread = love.thread.newThread('thread.lua')
thread:start ();
channel		= {};
channel.a	= love.thread.getChannel ( "a" );

end

xy = {}
xy.x = 100
xy.y = 100

function love.draw()
    if channel.a:getCount() > 0 then
      xy = channel.a:pop()
    end
    love.graphics.circle('line', xy.x, xy.y, 30, 100)
end
