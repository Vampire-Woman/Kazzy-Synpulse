impulse.Dispatch.CityCodes = {
    [1] = {"CIVIL", Color(0, 255, 0)},
    [2] = {"CIVIL UNREST", Color(255, 165, 0)},
    [3] = {"JUDGMENT WAIVER", Color(255, 0, 0)},
}

function impulse.Dispatch.AnnounceBlockSearch(block)
    impulse.Dispatch.Announce(3)
    block:Notify("Your block is under civil inspection, Assume your inspection position.")

    for v,k in pairs(team.GetPlayers(TEAM_CP)) do
        timer.Simple(2, function()
            k:SendCombineMessage("ALL AVAILABLE PROTECTION TEAMS, PREPARE FOR RESIDENTIAL INSPECTION OF ".. string.upper(block.name), Color(216, 159, 45))
        end)
    end

    timer.Simple(30, function()
        impulse.Dispatch.Announce(4)
    end)
end

function impulse.Dispatch.Manhunt(ply)
    if !IsValid(ply) then return end
    ply.IsWanted = true
   -- ply:Notify("You are being hunted. Report yourself to civil authorities or attempt to hide.") don't think its appropriate to notify the player
    impulse.Dispatch.Announce(5)
    for v,k in pairs(team.GetPlayers(TEAM_CP)) do
        timer.Simple(2, function()
            k:SendCombineMessage("ALL PROTECTION TEAM MEMBERS, ".. string.upper(ply:GetName()) .." HAS BEEN MARKED 'POS', BOL FOR TARGET.")
        end)
    end
    timer.Simple(60, function()
        if IsValid(ply) && ply.IsWanted then
            impulse.Dispatch.Announce(6)
        end
    end)
end

CODE_CIVIL = 1
CODE_UNREST = 2
CODE_JW = 3
CODE_AJ = 4

local function findAndFire(pos)
    for v,k in pairs(ents.FindByClass("func_button")) do
        if pos:DistToSqr(k:GetPos()) < (9 ^ 2) then
            k:Fire("use")
        end
    end
end

local nextCityCodeSetup = 0
function impulse.Dispatch.SetupCityCode(code)
    local lastCityCode = LAST_CITYCODE or 1

    local idCode = impulse.ci.socioStatus.ToNumber(code)
    
    if idCode == lastCityCode then
        return
    end

    if nextCityCodeSetup > CurTime() then
        return
    end

    local doWait = false

    if lastCityCode == 3 then
        if impulse.Config.JWDirectOff then
            ents.FindByName(impulse.Config.JWDirectOff)[1]:Fire("use")
        elseif impulse.Config.JWButtonPos then
            findAndFire(impulse.Config.JWOffButtonPos or impulse.Config.JWButtonPos)
            doWait = true
        end
    elseif lastCityCode == 4 then
        if impulse.Config.AJDirectOn then
            ents.FindByName(impulse.Config.AJDirectOff)[1]:Fire("use")
        elseif impulse.Config.AJButtonPos then
            findAndFire(impulse.Config.AJOffButtonPos or impulse.Config.AJButtonPos)
            doWait = true
        end
    end

    timer.Simple((doWait and 31) or 2, function()
        if idCode == 3 then
            if impulse.Config.JWDirectOn then
                ents.FindByName(impulse.Config.JWDirectOn)[1]:Fire("use")
            elseif impulse.Config.JWButtonPos then
                findAndFire(impulse.Config.JWButtonPos)
            end
        end
        
        if idCode == 4 then
            if impulse.Config.AJDirectOn then
                ents.FindByName(impulse.Config.AJDirectOn)[1]:Fire("use")
            elseif impulse.Config.AJButtonPos then
                findAndFire(impulse.Config.AJButtonPos)
            end
        end
    end)

    LAST_CITYCODE = idCode
    nextCityCodeSetup = CurTime() + 68
end

function impulse.Dispatch.SetCityCode(ply, code)
    return impulse.ci.socioStatus.Set(ply, code)
end

function impulse.Dispatch.GetCityCode()
    return impulse.ci.socioStatus.ToNumber(impulse.ci.socioStatus.GetCurrent())
end

function impulse.Dispatch.GetCityCodeInfo()
    return impulse.ci.socioStatus.list[impulse.ci.socioStatus.GetCurrent()]
end

function meta:GetDigits()
	if not self:IsCP() then return end

	local digits = string.Right(self:Name(), 4)
	digits = tonumber(digits)

	if digits and isnumber(digits) then
		return digits
	end
end

local dispatchNumbers = {
	[0] = "npc/overwatch/radiovoice/zero.wav",
	[1] = "npc/overwatch/radiovoice/one.wav",
	[2] = "npc/overwatch/radiovoice/two.wav",
	[3] = "npc/overwatch/radiovoice/three.wav",
	[4] = "npc/overwatch/radiovoice/four.wav",
	[5] = "npc/overwatch/radiovoice/five.wav",
	[6] = "npc/overwatch/radiovoice/six.wav",
	[7] = "npc/overwatch/radiovoice/seven.wav",
	[8] = "npc/overwatch/radiovoice/eight.wav",
	[9] = "npc/overwatch/radiovoice/nine.wav"
}

function DispatchNumbersToVoice(number)
	number = tostring(number)
	local sounds = {}

	for v,k in pairs(string.ToTable(number)) do
		k = tonumber(k)
		if dispatchNumbers[k] then
			table.insert(sounds, dispatchNumbers[k])
		end
	end

	return sounds
end

function DispatchVoiceRead(lines, wait)
	local wait = wait or .6
	local queue = 0

	for v,k in pairs(lines) do
		timer.Simple(queue, function()
			surface.PlaySound(k)
		end)
		queue = queue + wait
	end

	return queue - wait
end

function meta:IsCPHigherRank()
	if self:Team() == TEAM_CP then

		if self:GetTeamClass() == nil then 
			return false 
		end
	
		if self:GetTeamClass() == CLASS_RL then
			return true
		else
			return false
		end
		
	else
		return false
	end
end

function meta:IsOTAHigherRank()
	if self:Team() == TEAM_OTA then

		if self:GetTeamClass() == nil then 
			return false 
		end
	
		if self:GetTeamClass() == CLASS_ELITE then
			return true
		else
			return false
		end

	else
		return false
	end
end

function IsJW()
    local currentSocioStatus = impulse.ci.socioStatus.GetCurrent()

    if currentSocioStatus == "jw" then
        return true
    else
        return false
    end
end

function meta:IsUUHigherRank()
	local class = self:GetTeamClass()
	if not class then return false end

	if self:Team() == TEAM_CP then
		if class == CLASS_RL then
			return true
		end
	elseif self:Team() == TEAM_OTA then
		if class == CLASS_ELITE then
			return true
		end
	end

	return false
end