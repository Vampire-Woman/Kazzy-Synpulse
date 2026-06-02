--print("[CPVoiceDebug] CP Random Voiceline script loaded")

local voicelines = {
    "npc/overwatch/radiovoice/antifatigueration3mg.wav",
    "npc/overwatch/radiovoice/recievingconflictingdata.wav",
    "npc/overwatch/radiovoice/recalibratesocioscan.wav",
    "npc/overwatch/radiovoice/reminder100credits.wav",
    "npc/overwatch/radiovoice/remindermemoryreplacement.wav",
    "npc/overwatch/radiovoice/rewardnotice.wav",
    "npc/overwatch/radiovoice/switchtotac5reporttocp.wav",
    "npc/overwatch/radiovoice/teamsreportstatus.wav"
}

local function GetTimerName(ply)
    return "CPVoiceTimer_" .. ply:SteamID64()
end

local function playVoiceline(ply)

    if not IsValid(ply) then
        return
    end

    if ply:Team() ~= TEAM_CP then
        return
    end

    local sound = table.Random(voicelines)
    local volume = 0.2 -- range is 0 to 1
	
    ply:EmitSound(sound, 75, 100, volume)
end

local function StopVoiceLineTimer(ply)

    if not IsValid(ply) then return end

    local timerName = GetTimerName(ply)

    if timer.Exists(timerName) then
        timer.Remove(timerName)
    end

end

local function StartVoiceLineTimer(ply)

    if not IsValid(ply) then
        return
    end

    if ply:Team() ~= TEAM_CP then
        return
    end

    local timerName = GetTimerName(ply)

    if timer.Exists(timerName) then
        return
    end

    local delay = 5

    timer.Create(timerName, delay, 0, function()

        if not IsValid(ply) then
            timer.Remove(timerName)
            return
        end

        if ply:Team() ~= TEAM_CP then
            timer.Remove(timerName)
            return
        end

        playVoiceline(ply)

        local nextDelay = math.random(60,300)

        timer.Adjust(timerName, nextDelay, 0)

    end)

end

hook.Add("PlayerChangedTeam", "HandleTeamChange_RandomCPVoicelines", function(ply, oldTeam, newTeam)

    if newTeam == TEAM_CP then

        timer.Simple(0, function()
            if IsValid(ply) then
                StartVoiceLineTimer(ply)
            end
        end)

    else

        StopVoiceLineTimer(ply)

    end

end)

hook.Add("PlayerSpawn", "StartVoiceLineTimerOnSpawn_RandomCPVoicelines", function(ply)

    if ply:Team() == TEAM_CP then

        timer.Simple(0, function()
            if IsValid(ply) then
                StartVoiceLineTimer(ply)
            end
        end)

    end

end)

hook.Add("PlayerDisconnected", "CleanupVoiceLineTimers_RandomCPVoicelines", function(ply)

    StopVoiceLineTimer(ply)

end)