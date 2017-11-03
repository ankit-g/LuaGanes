require("luafft")
local loader = require 'love-loader'
local log = require 'log'
local utl = require('utility')
abs = math.abs
require "complex"
--complex.new --required for using the FFT function.
UpdateSpectrum = false

log.outfile = 'visuals.log'

Song = "redBird.mp3" 
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
  loader.newSoundData( sounds, 'music', 'redBird.mp3')
  loader.newImage(  images, 'rabbit', 'rabbit.PNG')
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
    --send sound data here so that the thread can start playing it.
    	if channel.spectrum:getCount() >= 1 and UpdateSpectrum  == false then
    		spectrum = channel.spectrum:pop()

	    	--Tells the draw function it already has data to draw
    		UpdateSpectrum = true
    	end
    end
end

function get_sound_avg(sound_table)
      value = 0
      len = 0
      for _, v in pairs(sound_table) do
	value = value + v
	len = len + 1 
      end
      return (value / len)
end

freq_log = utl.exe_times(log.trace, 1000)
function draw_graphics()
  if UpdateSpectrum then
  --[[In case you want to show only a part of the list,
      you can use #spec/(amount of bars). Setting 
      this to 1 will render all bars processed.]]
    local mid_table = {}
    local bass_table = {}
    for i = 1, #spectrum/8 do
	    	local freq = math.floor((i)/length)
	       --love.graphics.rectangle("line", i*7, ScreenSizeH, 7, -1*math.floor((complex.abs(spectrum[i])*0.7)))
	      if freq > 230 and freq < 270 then
	--      love.graphics.rectangle("line", i*7, ScreenSizeH, 7, -1*math.floor((complex.abs(spectrum[i])*0.7)))
	--	love.graphics.print("@ "..math.floor((i)/length).."Hz "..math.floor(complex.abs(spectrum[i])*0.7), ScreenSizeW-90,(12*i)) 
	      	mid_table[freq] = -1*math.floor((complex.abs(spectrum[i])*0.7)) 
	      end

	      if freq > 5 and freq < 55 then
	--	love.graphics.rectangle("line", i*7, ScreenSizeH, 7, -1*math.floor((complex.abs(spectrum[i])*0.7)))
	--	love.graphics.print("@ "..math.floor((i)/length).."Hz "..math.floor(complex.abs(spectrum[i])*0.7), ScreenSizeW-90,(12*i)) 
	      	bass_table[freq] = -1*math.floor((complex.abs(spectrum[i])*0.7)) 
	      end


    end

      love.graphics.rectangle("fill", 100, ScreenSizeH, 7, get_sound_avg(mid_table)*5) 
      love.graphics.rectangle("fill", 150, ScreenSizeH, 7, get_sound_avg(bass_table)) 
--      freq_log(tostring('dude '..value))]]
      UpdateSpectrum = false
  end
end

function love.draw()
  if finishedLoading  then
  -- media contains the images and sounds. You can use them here safely now.
    draw_graphics()
    love.graphics.draw(images.rabbit, 172, 172)
    love.graphics.circle('line', 200, 200, 50, 100)
  else -- not finishedLoading
    love.graphics.circle('fill', 200, 200, 50, 100)
    local percent = 0
    if loader.resourceCount ~= 0 then 
	    percent = loader.loadedCount / loader.resourceCount 
    end
    love.graphics.print(("Loading .. %d%%"):format(percent*100), 100, 100)
  end
end
