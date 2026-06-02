local soundFiles = {
    "ambient/amb_c17_strider_distant_01.mp3",
    "ambient/amb_c17_strider_distant_02.mp3",
    "ambient/amb_c17_strider_distant_03.mp3",
    "ambient/amb_c17_strider_distant_04.mp3",
    "ambient/amb_c17_strider_distant_05.mp3",
    "ambient/amb_c17_strider_distant_06.mp3",
    "ambient/amb_c17_strider_distant_07.mp3",
    "ambient/amb_c17_strider_distant_08.mp3",
    "ambient/amb_c17_strider_distant_09.mp3",
    "ambient/amb_c17_strider_distant_10.mp3",
    "ambient/amb_c17_strider_distant_11.mp3",
    "ambient/amb_c17_strider_distant_12.mp3",
    "ambient/amb_c17_strider_distant_13.mp3",
    "ambient/amb_c17_strider_distant_14.mp3",
    "ambient/amb_c17_strider_distant_15.mp3",
    "ambient/amb_c17_strider_distant_16.mp3"
}

local lastIndex = nil
local interval = 180 -- seconds
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
timer.Create("AmbientStriderSounds", interval, 0, PlayNextSound)

-- Countdown timer that prints time remaining every second
timer.Create("AmbientStriderSoundsCountdown", 1, 0, function()
    local now = os.time()
    local remaining = nextPlayTime - now
    if remaining < 0 then remaining = 0 end
end)