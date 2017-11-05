local utl = require 'utility'
local log = require'log'
local clock = os.clock
require "love.filesystem"
require "love.image"
require "love.audio"
require "love.sound"
require "luafft"
require "socket"
complex = require "complex"
log.outfile = 'thread_log.c'

local Size = 1024 --The amount of frequencies to obtain as result of the FFT process.
local Frequency = 4100 --The sampling rate of the song, in Hz
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
--    SoundData = love.sound.newSoundData('redBird.mp3')
    SoundData = SoundData
    Music = love.audio.newSource(SoundData)
    Music:play()
    return Music
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

function get_mid_and_bass(channel_freq_table)
    local mid_table = {}
    local bass_table = {}

    spectrum = fft(channel_freq_table, false) 
    multiply(spectrum, 10)
    
    for i = 1, #spectrum/8 do
	      local freq = math.floor((i)/length)
	      if freq > 230 and freq < 270 then
	      	mid_table[freq] = -1*math.floor((complex.abs(spectrum[i])*0.7)) 
	      end

	      if freq > 5 and freq < 50 then
	      	bass_table[freq] = -1*math.floor((complex.abs(spectrum[i])*0.7)) 
	      end
    end

    return get_sound_avg(mid_table), get_sound_avg(bass_table)
end
--An FFT converts audio from a time
--space to a frequency space,
--so you can analyze the volume level in 
--each one of it's frequency bands.
--Multiply all obtained FFT freq infos by 10.
function get_spectrum(Music)
    local MusicPos = Music:tell( "samples" ) 
    local MusicSize = SoundData:getSampleCount() 
    local ListLeft = {}
    local ListRight = {}
    local spec = {}

    if Music:isStopped() == true then
    	spec.mid_left, spec.bass_left = 'next', -1
    	spec.mid_right, spec.bass_right = -1, -1 
	start_analysis = false
	return spec	    
    end

--    if MusicPos >= MusicSize - 1536 then love.audio.rewind(Music) end 

    for i = MusicPos, MusicPos + (Size-1) do
       if i + 2048 > MusicSize then i = MusicSize/2 end 
       ListLeft[#ListLeft+1] = complex.new(SoundData:getSample(i*2+1), 0) 
       ListRight[#ListRight+1] = complex.new(SoundData:getSample(i*2), 0) 
    end

    spec.mid_left, spec.bass_left = get_mid_and_bass(ListLeft) 
    spec.mid_right, spec.bass_right = get_mid_and_bass(ListRight) 

    return spec
end

count = 0
while true do
	if channel.sound_data:getCount() == 1 then
		count = count + 1
		--if count == 2 then assert(1 == 0) end
		start_analysis = false
		SoundData = channel.sound_data:pop()
		music = play_song(SoundData)
    		start_analysis = true
	end
	if true == start_analysis and
		channel.sound_data:getCount() == 0 then
		spec = get_spectrum(music)
		channel.spectrum:supply(spec)
	end
end
