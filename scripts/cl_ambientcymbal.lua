local soundFiles = {
    "ambient/cymbals/amb_cymbal_high_01.mp3",
    "ambient/cymbals/amb_cymbal_high_02.mp3",
    "ambient/cymbals/amb_cymbal_high_03.mp3",
    "ambient/cymbals/amb_cymbal_high_04.mp3",
    "ambient/cymbals/amb_cymbal_high_05.mp3",	
    "ambient/cymbals/amb_cymbal_high_06.mp3",	
    "ambient/cymbals/amb_cymbal_high_07.mp3",	
    "ambient/cymbals/amb_cymbal_high_08.mp3"

}

local lastIndex = nil
local interval = 240 -- seconds
local nextPlayTime = os.time() + interval

-- Function to play a random sound
local function PlayNextSound()
    local randomIndex
    repeat
        randomIndex = math.random(1, #soundFiles)
    until randomIndex ~= lastIndex

    surface.PlaySound(soundFiles[randomIndex])
    lastIndex = randomIndex

    nextPlayTime = os.time() + interval -- schedule next play
end

-- Timer that plays sounds every interval
timer.Create("AmbientCymbalSounds", interval, 0, PlayNextSound)

-- Countdown timer that prints time remaining every second
timer.Create("AmbientCymbalSoundsCountdown", 1, 0, function()
    local now = os.time()
    local remaining = nextPlayTime - now
    if remaining < 0 then remaining = 0 end
end)