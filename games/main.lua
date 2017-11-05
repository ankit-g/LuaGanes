require("luafft")
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


  Size = 1024 --The amount of frequencies to obtain as result of the FFT process.
  Frequency = 4100 --The sampling rate of the song, in Hz
  length = Size / Frequency -- The size of each frequency range of the final generated FFT values.

  ScreenSizeW = love.graphics.getWidth() --gets screen dimensions.
  ScreenSizeH = love.graphics.getHeight() --gets screen dimensions.
  speaker_left = Speaker.new(ScreenSizeW/2-300, ScreenSizeH/2-100)
  speaker_right = Speaker.new(ScreenSizeW/2+300, ScreenSizeH/2-100)

  loader.newSoundData( sounds, 'music', 'irrigate.mp3')
  loader.newSoundData( sounds, 'next', 'hourGlass.mp3')
  loader.newImage(  images, 'rabbit', 'sign.PNG')
--  loader.newImage(  images, 'loading', 'loading.PNG')
  loader.start(function() finishedLoading = true end)
end

utility_log = utl.exe_times(log.trace, 1)
spectrum_log = utl.exe_times(log.trace, 100)

send_sound_data = utl.exe_times(function() channel.sound_data:supply(sounds.music) end ,1)

function love.update(dt)
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
    love.graphics.draw(images.rabbit, ScreenSizeW-100, ScreenSizeH-79)
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
