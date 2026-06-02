local entityMeta = FindMetaTable("Entity")

function impulse.CanCacheRaid(ply)
	if ( player.GetCount() >= 5 and #team.GetPlayers(TEAM_CP) >= 1 ) then
		return false, "There is not enough players to raid caches."
	end
end

function meta:IsInGame()
    if ( IsValid(impulse.splash) or IsValid(impulse.MainMenu) ) then
        return false
    end

    return true
end

function meta:CanUseTerminalConvicts()
	if not self:Team() == TEAM_CP then
		return false
	end

	if self:IsUUHigherRank() then
		return true
	end

	local class = self:GetTeamClass()

	if class and class == CLASS_RL then
		return true
	end
	
	return false
end

function meta:ResetBoneAngles()
    for i = 0, self:GetBoneCount() - 1 do
        self:ManipulateBoneAngles(i, Angle(0, 0, 0))
    end
end

function meta:ResetBonePositions()
    for i = 0, self:GetBoneCount() - 1 do
        self:ManipulateBonePosition(i, Vector(0, 0, 0))
    end
end

function meta:ResetBoneScale()
    for i = 0, self:GetBoneCount() - 1 do
        self:ManipulateBoneScale(i, Vector(1, 1, 1))
    end
end

function meta:ResetBones()
    self:ResetBoneAngles()
    self:ResetBonePositions()
    self:ResetBoneScale()
end

function impulse.CanNexusRaid()
	local cps = #team.GetPlayers(TEAM_CP)
	local otas = #team.GetPlayers(TEAM_OTA)
	local players = player.GetCount()
	local baddies = cps + otas
	local modCount = 0

	for k, ply in ipairs(player.GetHumans()) do
		if ply:IsAdmin() then
			modCount = modCount + 1
		end
	end

	if modCount == 0 then
		print("no mods?")
		return false
	end

	if (impulse.BoxRaidBypass or false) then
		return true
	end

	if baddies < 3 then
		return false
	end

	if otas < 1 then
		return false
	end

	if players < 10 then
		return false
	end

	return true
end

local entityMeta = FindMetaTable("Entity")

function impulse.CanCacheRaid(ply)
	if ( player.GetCount() >= 5 and #team.GetPlayers(TEAM_CP) >= 1 ) then
		return false, "There is not enough players to raid caches."
	end
end

function meta:IsInGame()
    if ( IsValid(impulse.splash) or IsValid(impulse.MainMenu) ) then
        return false
    end

    return true
end

function meta:CombineSoldierBall()
    if CLIENT then return end
	
	local sounds = {
        "weapons/irifle/irifle_fire2.wav",
        "weapons/irifle/irifle_fire2.wav"
    }
    self:EmitSound(sounds[math.random(#sounds)])
    self.BallCooldown = CurTime() + 15

    local ball = ents.Create("prop_combine_ball")
    if IsValid(ball) then
        ball:SetPos(self:EyePos())
        ball:SetSaveValue("m_flRadius", 10)
        ball:Activate()
        ball:Spawn()
        ball:GetPhysicsObject():SetVelocity(self:GetAimVector() * 1000)
        ball:SetSaveValue("m_nState", 3)
        ball:Fire("Explode", nil, 5)
    end
end

function meta:CanUseTerminalConvicts()
	if not self:Team() == TEAM_CP then
		return false
	end

	if self:IsUUHigherRank() then
		return true
	end

	local class = self:GetTeamClass()

	if class and class == CLASS_RL then
		return true
	end
	
	return false
end

function impulse.CanNexusRaid()
	local cps = #team.GetPlayers(TEAM_CP)
	local otas = #team.GetPlayers(TEAM_OTA)
	local players = player.GetCount()
	local baddies = cps + otas
	local modCount = 0

	for k, ply in ipairs(player.GetHumans()) do
		if ply:IsAdmin() then
			modCount = modCount + 1
		end
	end

	if modCount == 0 then
		print("no mods?")
		return false
	end

	if (impulse.BoxRaidBypass or false) then
		return true
	end

	if baddies < 3 then
		return false
	end

	if otas < 1 then
		return false
	end

	if players < 10 then
		return false
	end

	return true
end