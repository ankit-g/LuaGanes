local utl = require 'utility'
require 'socket'

local log = require'log'
local clock = os.clock

log.outfile = 'thread_log.c'

local Size = 1024 --The amount of frequencies to obtain as result of the FFT process.
local Frequency = 14100 --The sampling rate of the song, in Hz
local length = Size / Frequency -- The size of each frequency range of the final generated FFT values.

-- This function multiplies every value in the
-- list of frequencies for a given constant.
-- Think of it as a sensibility setting.
local function multiply(list, factor)
  for i,v in ipairs(list) do list[i] = list[i] * factor end
end

-- thread
channel 		= {};
channel.sound_data	= love.thread.getChannel ( "sound_data" );
channel.spectrum  	= love.thread.getChannel ( "spectrum" );

start_analysis = false
local function play_song(SoundData)
    utility_log('this is '..tostring(finishedLoading))

    local Music = love.audio.newSource(SoundData)
    Music:play()

    start_analysis = true
    return Music
end

--An FFT converts audio from a time
--space to a frequency space,
--so you can analyze the volume level in 
--each one of it's frequency bands.
--Multiply all obtained FFT freq infos by 10.
function get_spectrum(Music)
    local MusicPos = Music:tell( "samples" ) 
    local MusicSize = SoundData:getSampleCount() 
    if MusicPos >= MusicSize - 1536 then love.audio.rewind(Music) end 
    local List = {}

    for i = MusicPos, MusicPos + (Size-1) do
       CopyPos = i
       if i + 2048 > MusicSize then i = MusicSize/2 end 
       List[#List+1] = complex.new(SoundData:getSample(i*2), 0) 
    end

    spectrum = fft(List, false) 
    multiply(spectrum, 100)

    return spectrum
end

while true do
		assert(1==0)
	if channel.sound_data:getCount() == 1 then
		start_analysis = false
		music = play_song(channel.sound_data:pop())	
	end

	if true == start_analysis and
		channel.sound_data:getCount() == 0 then
		channel.spectrum:push(get_spectrum(music))
	end
end
