require("luafft")
local loader = require 'love-loader'
local log = require 'log'
local utl = require('utility')
abs = math.abs
--complex.new --required for using the FFT function.
UpdateSpectrum = false

log.outfile = 'visuals.log'

Song = "redBird.mp3" 
local finishedLoading = false

-- thread
thread = love.thread.newThread('music_thread.lua')
thread:start ();

channel 		= {};
channel.sound_data	= love.thread.getChannel ( "sound_data" );
channel.spectrum  	= love.thread.getChannel ( "spectrum" );

local images = {}
local sounds = {}

function love.load()
  loader.newSoundData( sounds, 'music', 'redBird.mp3')
  loader.newImage(  images, 'rabbit', 'rabbit.PNG')
  loader.start(function() finishedLoading = true end)
end

utility_log = utl.exe_times(log.trace, 1)

send_sound_data = utl.exe_times(function() channel.sound_data:push(sounds.music) end ,1)

function love.update(dt)
  if not finishedLoading then
     loader.update() -- You must do this on each iteration until all resources are loaded
  end

   if true == finishedLoading then
	  send_sound_data()
    --send sound data here so that the thread can start playing it.
    	if channel.spectrum:getCount() == 1 then
    		spectrum = channel.spectrum:pop()
	    	--Tells the draw function it already has data to draw
    		UpdateSpectrum = true
    	end
    end
end

function draw_graphics()
  if UpdateSpectrum then
  --[[In case you want to show only a part of the list,
      you can use #spec/(amount of bars). Setting 
      this to 1 will render all bars processed.]]
      UpdateSpectrum = false
    for i = 1, #spectrum/8 do
      --iterate over the list, and draws a rectangle for each band value.
      love.graphics.rectangle("line", i*7, ScreenSizeH, 7, -1*(spectrum[i]:abs()*0.7))       
      --prints the frequency and it's current value on the screen.
      love.graphics.print("@ "..math.floor((i)/length).."Hz "..math.floor(spectrum[i]:abs()*0.7), ScreenSizeW-90,(12*i)) 
      --Current position being analyzed.
      love.graphics.print(CopyPos, 0, 0)
      --Current size of song in samples.
      love.graphics.print(SoundData:getSampleCount(), 0, 20) 
      end
  end
end

function love.draw()
  if finishedLoading then
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
