function meta:IsLoadoutSMG()
	local loadoutsmg = self:GetSyncVar(SYNC_LOADOUTSMG, nil)

	if loadoutsmg then
		return true, loadoutsmg
	end

	return false
end

function meta:IsLoadoutPistol()
    local loadoutpistol = self:GetSyncVar(SYNC_LOADOUTPISTOL, nil)

	if loadoutpistol then
		return true, loadoutpistol
	end

	return false
end

function meta:IsLoadoutHealthVial()
    local loadouthealthvial = self:GetSyncVar(SYNC_LOADOUTHEALTHVIAL, nil)

	if loadouthealthvial then
		return true, loadouthealthvial
	end

	return false
end

function meta:IsLoadoutHealthKit()
    local loadouthealthkit = self:GetSyncVar(SYNC_LOADOUTHEALTHKIT, nil)

	if loadouthealthkit then
		return true, loadouthealthkit
	end

	return false
end

function meta:IsLoadoutExtraAmmo()
    local loadoutextraammo = self:GetSyncVar(SYNC_LOADOUTEXTRAAMMO, nil)

	if loadoutextraammo then
		return true, loadoutextraammo
	end

	return false
end

function meta:IsLoadoutExtraCuffs()
    local loadoutextracuffs = self:GetSyncVar(SYNC_LOADOUTEXTRACUFFS, nil)

	if loadoutextracuffs then
		return true, loadoutextracuffs
	end

	return false
end

function meta:Promote(amount, customMessage)
    if self:IsPlayer() and (self:Team() == TEAM_CP or self:Team() == TEAM_OTA) then
        local currentRankPoints = self:GetRankPoints()
        if currentRankPoints < 100 then
            local newRankPoints = math.min(currentRankPoints + amount, 100)
            self:SetRankPoints(newRankPoints)
            local message = customMessage or ((newRankPoints - currentRankPoints) .. " Rank Points have been rewarded to your profile by Overwatch.")
            self:Notify(message, 1)
            for _, player in pairs(player.GetAll()) do
                if player:IsCombine() then
                    --player:SendCombineMessage("UNIT " .. self:Name() .. " HAS BEEN REWARDED " .. (newRankPoints - currentRankPoints) .. " RANK POINTS.", Color(0, 0, 0))
                end
            end
        end
    end
end

function meta:Demote(amount, customMessage)
    if self:IsPlayer() and (self:Team() == TEAM_CP or self:Team() == TEAM_OTA) then
        local currentRankPoints = self:GetRankPoints()
        if currentRankPoints > 0 then
            local newRankPoints = math.max(currentRankPoints - amount, 0)
            self:SetRankPoints(newRankPoints)
            local message = customMessage or ((currentRankPoints - newRankPoints) .. " Rank Points have been deducted from your profile by Overwatch.")
            self:Notify(message, 2)
            for _, player in pairs(player.GetAll()) do
                if player:IsCombine() then
                    --player:SendCombineMessage("UNIT " .. self:Name() .. " HAS BEEN PENALIZED " .. (currentRankPoints - newRankPoints) .. " RANK POINTS.", Color(0, 0, 0))
                end
            end
        end
    end
end
