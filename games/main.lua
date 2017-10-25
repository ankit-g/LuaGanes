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

local Ball = require('ball')
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

function love.conf(t)
    t.identity = nil                    -- The name of the save directory (string)
    t.version = "0.10.2"                -- The LÖVE version this game was made for (string)
    t.console = false                   -- Attach a console (boolean, Windows only)
    t.accelerometerjoystick = true      -- Enable the accelerometer on iOS and Android by exposing it as a Joystick (boolean)
    t.externalstorage = false           -- True to save files (and read from the save directory) in external storage on Android (boolean)
    t.gammacorrect = false              -- Enable gamma-correct rendering, when supported by the system (boolean)

    t.window.title = "ChillApp"         -- The window title (string)
    t.window.icon = nil                 -- Filepath to an image to use as the window's icon (string)
    t.window.width = 1024                -- The window width (number)
    t.window.height =  786              -- The window height (number)
    t.window.borderless = false         -- Remove all border visuals from the window (boolean)
    t.window.resizable = false          -- Let the window be user-resizable (boolean)
    t.window.minwidth = 1               -- Minimum window width if the window is resizable (number)
    t.window.minheight = 1              -- Minimum window height if the window is resizable (number)
    t.window.fullscreen = false         -- Enable fullscreen (boolean)
    t.window.fullscreentype = "exclusive" -- Choose between "desktop" fullscreen or "exclusive" fullscreen mode (string)
    t.window.vsync = true               -- Enable vertical sync (boolean)
    t.window.msaa = 0                   -- The number of samples to use with multi-sampled antialiasing (number)
    t.window.display = 1                -- Index of the monitor to show the window in (number)
    t.window.highdpi = false            -- Enable high-dpi mode for the window on a Retina display (boolean)
    t.window.x = nil                    -- The x-coordinate of the window's position in the specified display (number)
    t.window.y = nil                    -- The y-coordinate of the window's position in the specified display (number)

    t.modules.audio = true              -- Enable the audio module (boolean)
    t.modules.event = true              -- Enable the event module (boolean)
    t.modules.graphics = true           -- Enable the graphics module (boolean)
    t.modules.image = true              -- Enable the image module (boolean)
    t.modules.joystick = true           -- Enable the joystick module (boolean)
    t.modules.keyboard = true           -- Enable the keyboard module (boolean)
    t.modules.math = true               -- Enable the math module (boolean)
    t.modules.mouse = true              -- Enable the mouse module (boolean)
    t.modules.physics = true            -- Enable the physics module (boolean)
    t.modules.sound = true              -- Enable the sound module (boolean)
    t.modules.system = true             -- Enable the system module (boolean)
    t.modules.timer = true              -- Enable the timer module (boolean), Disabling it will result 0 delta time in love.update
    t.modules.touch = true              -- Enable the touch module (boolean)
    t.modules.video = true              -- Enable the video module (boolean)
    t.modules.window = true             -- Enable the window module (boolean)
    t.modules.thread = true             -- Enable the thread module (boolean)
end

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

function love.update(dt)
  -- body...

    for ball_no = 1, #fixed_balls do
      fixed_balls[ball_no]:update_radius_on_touch(love.mouse.getX(), love.mouse.getY())
  end

end

function love.load(arg)

  load_wild_colors()

  love.window.setMode(1366, 786, {resizable=true, vsync=false, minwidth=400, minheight=300})
  local ball_radius = 4
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
end

local past_time = os.clock()

function love.draw()
  local color = color_wild[math.random(1, #color_wild)]
  for ball_no = 1, #fixed_balls do
      --log.trace(ball_no)
      if math.abs(os.clock()-past_time) >= 2 then
        color = color_wild[math.random(1, #color_wild)]
        pas_time = os.clock()
      end
      fixed_balls[ball_no]:fix_draw(color)
  end
end
