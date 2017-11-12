require("luafft")
require("gooi")
local loader = require 'love-loader'
local log = require 'log'
local utl = require('utility')
abs = math.abs
require "complex"

local Speaker = {}
Speaker.__index = Speaker

Speaker.new = function(base_x, base_y)
	self = setmetatable({}, Speaker)
	self.base_x, self.base_y = base_x, base_y
	return self
end

Speaker.draw = function(self)
	speaker_x, speaker_y = self.base_x, self.base_y
        love.graphics.setColor(255, 255, 255, 255)
	love.graphics.rectangle("line", speaker_x-138, speaker_y-200, 300, 600 )
end

Speaker.play = function(self, mid, bass)
	speaker_x, speaker_y = self.base_x, self.base_y
	love.graphics.setColor(0, 0, 255, 255)
	love.graphics.circle('line', speaker_x, speaker_y - 50, (((-1*bass)/1)/1), 100)
	love.graphics.setColor(255, 0, 255, 255)
	love.graphics.circle('fill', speaker_x, speaker_y - 50, (((-1*bass)/5)/1), 100)
	love.graphics.setColor(255, 0, 0, 255)

	love.graphics.circle('line', speaker_x, speaker_y + 250, (((-1*mid)*5)/1), 100)
	love.graphics.setColor(0, 0, 255, 255)
	love.graphics.circle('fill', speaker_x, speaker_y + 250, (((-1*mid))/1), 100)
end

--complex.new --required for using the FFT function.
UpdateSpectrum = false

log.outfile = 'visuals.log'

local finishedLoading = false

-- thread
local thread = love.thread.newThread('music_thread.lua')
thread:start ();

channel 		= {};
channel.sound_data	= love.thread.getChannel ( "sound_data" );
channel.spectrum  	= love.thread.getChannel ( "spectrum" );

local images = {}
local sounds = {}

function love.load()
	panelGrid = gooi.newPanel({x = 350, y = 10, w = 420, h = 270, layout = "game"})

	gooi.newLabel({
	    text = "      HollaSolutions GameChanging Technology",
	    x = 470,
	    icon = "imgs/h.png"
	})

	gooi.newCheck({
	    text = "checkbox",
	    x = 10,
	    y = 250,
	    w = 100,
	    h = 25,
	    checked = true -- default = false
	})

	gooi.newText({
	    x = 10,
	    y = 350,
	    w = 100,
	    h = 25,
	}):setText("A text field")

	gooi.newBar({
	    value = 0.75,
	    x = 10,
	    y = 400,
	    w = 100,
	    h = 25,
	})

	gooi.newJoy({
	    x = 10,
	    y = 480,
	    size = 100, -- width and height
	    deadZone = 0.2 -- deadzone = 20%
	})

	gooi.newKnob({
	    value = 0.2, -- default = 0.5
	    x = 10,
	    y = 590,
	    size = 100,-- width and height
	})

	gooi.newSpinner({
	    min = -20,
	    max = 20,
	    value = 0,
	    x = 10,
	    y = 450,
	    w = 100,
	    h = 25,
	})

	gooi.newRadio({
	    text = "radio",
	    radioGroup = "civil-status", -- similar to radio name attribute in HTML
	    x = 10,
	    y = 300,
	    w = 100,
	    h = 25,
	    selected = true -- default = false
	})

	btn = gooi.newButton({
		text = "    Exit",
		x = 10,
		y = 10,
		w = 50,
		h = 35,
		icon = "imgs/exit.png"
		}):onRelease(function()
		gooi.confirm({
		    text = "Are you sure?",
		    ok = function()
			love.event.quit()
		    end
	})
	end)
	:warning()

	slider = gooi.newSlider({x = 10, y = 50, w = 22, h = 90, value = 0}):vertical()

  Size = 1024 --The amount of frequencies to obtain as result of the FFT process.
  Frequency = 4100 --The sampling rate of the song, in Hz
  length = Size / Frequency -- The size of each frequency range of the final generated FFT values.

  ScreenSizeW = love.graphics.getWidth() --gets screen dimensions.
  ScreenSizeH = love.graphics.getHeight() --gets screen dimensions.
  speaker_left = Speaker.new(ScreenSizeW/2-300, ScreenSizeH/2-100)
  speaker_right = Speaker.new(ScreenSizeW/2+300, ScreenSizeH/2-100)

  loader.newSoundData( sounds, 'music', 'redBird.mp3')
  loader.newSoundData( sounds, 'next', 'redBird.mp3')
  --loader.newImage(  images, 'rabbit', 'sign.PNG')
--  loader.newImage(  images, 'loading', 'loading.PNG')
  loader.start(function() finishedLoading = true end)
end

utility_log = utl.exe_times(log.trace, 1)
spectrum_log = utl.exe_times(log.trace, 100)

send_sound_data = utl.exe_times(function() channel.sound_data:supply(sounds.music) end ,1)

function love.update(dt)
    gooi.update(dt)
	 if thread:isRunning() == false then
	  log.trace(thread:isRunning(), thread:getError())
	  assert(1==0)
	end

  if not finishedLoading then
     loader.update() -- You must do this on each iteration until all resources are loaded
  end

   if true == finishedLoading then
	  send_sound_data()
    end
end

freq_log = utl.exe_times(log.trace, 1000)
function draw_graphics()
      if channel.spectrum:getCount() >=  1 then
      	spec = channel.spectrum:pop()
      end
      if spec then
	if spec.mid_left == 'next' then
		channel.sound_data:push(sounds.next)
		spec.mid_left, spec.bass_left = -1 , -1
		spec.mid_right, spec.bass_right = -1, -1
	return 
	end
        love.graphics.setColor(255, 255, 255, 255)
      	love.graphics.rectangle("fill", 100, ScreenSizeH, 7,spec.mid_left*5)
      	love.graphics.rectangle("fill", 150, ScreenSizeH, 7,spec.bass_left*1)
        speaker_left:draw()
        speaker_right:draw()
        speaker_left:play (spec.mid_left, spec.bass_left)
        speaker_right:play(spec.mid_right, spec.bass_right)
      end
end

function love.draw()
  gooi.draw()
  love.graphics.print(("volume %d%%"):format(slider:getValue()*100), 100, 100)

  if finishedLoading  then
    --Drawing stuff reset colors
    love.graphics.setColor(255,255,255)
    -- love.graphics.draw(images.loading, 0, 0)
    -- media contains the images and sounds. You can use them here safely now.
    -- love.graphics.circle('line', 200, 200, 50, 100)
    draw_graphics()
    love.graphics.setColor(255, 0, 0, 255)
    --Drawing stuff reset colors
    love.graphics.setColor(255,255,255)
    --love.graphics.draw(images.rabbit, ScreenSizeW-100, ScreenSizeH-79)
  else
    -- not finishedLoading
    -- love.graphics.circle('fill', 200, 200, 50, 100)
    local percent = 0
    if loader.resourceCount ~= 0 then
	    percent = loader.loadedCount / loader.resourceCount
    end
    love.graphics.print(("Loading .. %d%%"):format(percent*100), 100, 100)
  end
end

function love.mousereleased(x, y, button) gooi.released() end
function love.mousepressed(x, y, button)  gooi.pressed() end

function love.textinput(text)
    gooi.textinput(text)
end
function love.keypressed(key, scancode, isrepeat)
    gooi.keypressed(key, scancode, isrepeat)
    if key == "escape" then
        quit()
    end
end
function love.keyreleased(key, scancode)
    gooi.keyreleased(key, scancode)
end

function quit()
    love.event.quit()
end
