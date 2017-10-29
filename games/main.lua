require("luafft")
local loader = require 'love-loader'
local log = require 'log'
local utl = require('utility')
abs = math.abs
new = complex.new --required for using the FFT function.
UpdateSpectrum = false

log.outfile = 'visuals.log'

Song = "redBird.mp3" --You have to put your songs somewhere along the main.lua file, so love2d can access it. Then, just point this string to the song you wish to use.
local finishedLoading = false
local sounds = {}

function devide(list, factor)
  for i,v in ipairs(list) do list[i] = list[i] * factor end
  -- This function multiplies every value in the list of frequencies for a given constant.Think of it as a sensibility setting.
end

once = true
local images = {}
function love.load()
  loader.newSoundData( sounds, 'music', 'redBird.mp3')
  loader.newImage(  images, 'rabbit', 'rabbit.PNG')
  loader.start(function() finishedLoading = true end)
  --[[
  SoundData = love.sound.newSoundData(Song) --You need to load the song both to obtain it's data AND play it.
  Size = 1024 --The amount of frequencies to obtain as result of the FFT process.
  Frequency = 144100 --The sampling rate of the song, in Hz
  length = Size / Frequency -- The size of each frequency range of the final generated FFT values.

  Music = love.audio.newSource(Song)
  Music:play()
  Window = love.window.setMode(1024, 768, {resizable=true, vsync=true})
  ]]
end

local Mysong = 0

local function play_song()
      Mysong = love.audio.newSource(sounds.music)
      Mysong:play()
end

utility_log = utl.exe_times(log.trace, 1)
first_song = utl.exe_times(play_song, 1)

function love.update(dt)
  if not finishedLoading then
     loader.update() -- You must do this on each iteration until all resources are loaded
  end

  if true == finishedLoading then
    utility_log('this is '..tostring(finishedLoading))
    --first_song()
  end
  --[[
    ScreenSizeW = love.graphics.getWidth() --gets screen dimensions.
    ScreenSizeH = love.graphics.getHeight() --gets screen dimensions.


    local MusicPos = Music:tell( "samples" ) --Returns the current sample being played by the engine.
    local MusicSize = SoundData:getSampleCount() --Obtain the size of the song in samples, so you can keep track of when it's gonna end.
    if MusicPos >= MusicSize - 1536 then love.audio.rewind(Music) end --Rewinds the song when the music is almost over.

    local List = {} --We'll fill this with sample information.

    for i= MusicPos, MusicPos + (Size-1) do
       CopyPos = i
       if i + 2048 > MusicSize then i = MusicSize/2 end --Make sure you stop trying to copy stuff when the song is *almost* over, or you'll wind up getting access errors!

       List[#List+1] = new(SoundData:getSample(i*2), 0) --Copies every sample to the list, which will be fed for the FFT calculation engine.
       -- In this case, we're fetching the Right channel samples, hence the "i*2". For the left channel, use "i*2+1". If it's a mono music, use "i*2" and you should be good.
       -- The "new" function used above is for generating complex numbers. The FFT function only works if given a table of complex values, and it returns a table of this kind.
    end

    spectrum = fft(List, false) --runs your list through the FFT analyzer. Returns a table of complex values, all properly processed for your usage.
    --An FFT converts audio from a time space to a frequency space, so you can analyze the volume level in each one of it's frequency bands.

    devide(spectrum, 10) --Multiply all obtained FFT freq infos by 10.
    UpdateSpectrum = true --Tells the draw function it already has data to draw
  ]]
end

function draw_graphics()
  if UpdateSpectrum then
    for i = 1, #spectrum/8 do --In case you want to show only a part of the list, you can use #spec/(amount of bars). Setting this to 1 will render all bars processed.
      love.graphics.rectangle("line", i*7, ScreenSizeH, 7, -1*(spectrum[i]:abs()*0.7)) --iterate over the list, and draws a rectangle for each band value.
      love.graphics.print("@ "..math.floor((i)/length).."Hz "..math.floor(spectrum[i]:abs()*0.7), ScreenSizeW-90,(12*i)) --prints the frequency and it's current value on the screen.
      love.graphics.print(CopyPos, 0, 0) --Current position being analyzed.
      love.graphics.print(SoundData:getSampleCount(), 0, 20) --Current size of song in samples.
    end
  end
end

function love.draw()
  if finishedLoading then
  -- media contains the images and sounds. You can use them here safely now.
  -- draw_graphics()
    love.graphics.draw(images.rabbit, 100, 200)
    love.graphics.circle('fill', 200, 200, 50, segments)
  else -- not finishedLoading
    local percent = 0
    if loader.resourceCount ~= 0 then percent = loader.loadedCount / loader.resourceCount end
    love.graphics.print(("Loading .. %d%%"):format(percent*100), 100, 100)
  end

end
