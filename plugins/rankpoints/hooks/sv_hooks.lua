function meta:AddLoadoutSMG()
    self:SetSyncVar(SYNC_LOADOUTSMG, true, true)
end

function meta:RemoveLoadoutSMG()
    if not self:GetSyncVar(SYNC_LOADOUTSMG, false) then
        return
    end

    self:SetSyncVar(SYNC_LOADOUTSMG, false, true)
end

function meta:AddLoadoutPistol()
    self:SetSyncVar(SYNC_LOADOUTPISTOL, true, true)
end

function meta:RemoveLoadoutPistol()
    if not self:GetSyncVar(SYNC_LOADOUTPISTOL, false) then
        return
    end

    self:SetSyncVar(SYNC_LOADOUTPISTOL, false, true)
end

function meta:AddLoadoutHealthVial()
    self:SetSyncVar(SYNC_LOADOUTHEALTHVIAL, true, true)
end

function meta:RemoveLoadoutHealthVial()
    if not self:GetSyncVar(SYNC_LOADOUTHEALTHVIAL, false) then
        return
    end

    self:SetSyncVar(SYNC_LOADOUTHEALTHVIAL, false, true)
end

function meta:AddLoadoutHealthKit()
    self:SetSyncVar(SYNC_LOADOUTHEALTHKIT, true, true)
end

function meta:RemoveLoadoutHealthKit()
    if not self:GetSyncVar(SYNC_LOADOUTHEALTHKIT, false) then
        return
    end

    self:SetSyncVar(SYNC_LOADOUTHEALTHKIT, false, true)
end

function meta:AddLoadoutExtraAmmo()
    self:SetSyncVar(SYNC_LOADOUTEXTRAAMMO, true, true)
end

function meta:RemoveLoadoutExtraAmmo()
    if not self:GetSyncVar(SYNC_LOADOUTEXTRAAMMO, false) then
        return
    end

    self:SetSyncVar(SYNC_LOADOUTEXTRAAMMO, false, true)
end

function meta:AddLoadoutExtraCuffs()
    self:SetSyncVar(SYNC_LOADOUTEXTRACUFFS, true, true)
end

function meta:RemoveLoadoutExtraCuffs()
    if not self:GetSyncVar(SYNC_LOADOUTEXTRACUFFS, false) then
        return
    end

    self:SetSyncVar(SYNC_LOADOUTEXTRACUFFS, false, true)
end

hook.Add("PlayerDeath", "impulseCitadelLoadoutRemover", function(target, ent, attacker)
	if ( target:IsLoadoutSMG() ) then
		target:RemoveLoadoutSMG()
    elseif ( target:IsLoadoutPistol() ) then
		target:RemoveLoadoutPistol()
    elseif ( target:IsLoadoutHealthVial() ) then
		target:RemoveLoadoutHealthVial()
    elseif ( target:IsLoadoutHealthKit() ) then
		target:RemoveLoadoutHealthKit()
    elseif ( target:IsLoadoutExtraAmmo() ) then
		target:RemoveLoadoutExtraAmmo()
    elseif ( target:IsLoadoutExtraCuffs() ) then
		target:RemoveLoadoutExtraCuffs()
	end
end)

function PLUGIN:PostSetupPlayer(ply)
	timer.Simple(15, function()
		ply:SetLocalSyncVar(SYNC_RANKPOINTS, ply:GetData().rp, true)
	end)			
end

local cooldowns = {}

function PLUGIN:PlayerHurt(victim, attacker, healthRemaining, damageTaken)
    if IsValid(attacker) and IsValid(victim) and attacker:IsPlayer() and victim:IsPlayer() then
        if attacker:Team() == TEAM_CP and (victim:Team() == TEAM_CP or victim:Team() == TEAM_OTA) and not victim:IsDispatchDefunct() then
            if attacker:Team() == TEAM_CP then
                local currentRankPoints = attacker:GetRankPoints()
                if not cooldowns[attacker] or CurTime() - cooldowns[attacker] >= 2 then
                    if currentRankPoints > 0 then
                        attacker:Demote(1, "1 Rank Point has been deducted from your profile by Overwatch for 99 reckless operation.")
                        cooldowns[attacker] = CurTime()
                    end
                end
            end
        end
    end
end

function PLUGIN:PlayerDeath(victim, inflictor, attacker)
    if IsValid(victim) and victim:IsPlayer() then
        -- CP death penalty
        if victim:Team() == TEAM_CP then
            local rankPointsLoss = math.random(1, 10)
            local currentRankPoints = victim:GetRankPoints()

            if currentRankPoints > 0 then
                victim:Demote(
                    rankPointsLoss,
                    "Attention, Premature Mission Termination is not permitted. "
                    .. rankPointsLoss ..
                    " Rank Point(s) have been removed from your profile by Overwatch."
                )
            end
        end

        if IsValid(attacker) and attacker:IsPlayer() then
            -- Friendly fire punishment
            if attacker:Team() == TEAM_CP and
                (victim:Team() == TEAM_CP or victim:Team() == TEAM_OTA) and
                not victim:IsDispatchDefunct() then

                local currentRankPoints = attacker:GetRankPoints()

                if currentRankPoints > 0 then
                    attacker:Demote(
                        50,
                        "50 Rank Points have been deducted from your profile by Overwatch for amputating another Protection Unit."
                    )
                end
            end

            -- Armed citizen/rebel/vort reward
            if attacker:Team() == TEAM_CP and
                (victim:Team() == TEAM_CITIZEN or victim:Team() == TEAM_REBEL or victim:Team() == TEAM_VORT) then

                if victim:IsArmed() or victim:IsArmored() then
                    local currentRankPoints = attacker:GetRankPoints()

                    if currentRankPoints > 100 then
                        attacker:Promote(
                            25,
                            "25 Rank Points have been rewarded for the amputation of an Anti-Citizen."
                        )
                    end
                end
            end

            -- Unarmed rebel reward
            if attacker:Team() == TEAM_CP and victim:Team() == TEAM_REBEL then
                if not (victim:IsArmed() or victim:IsArmored()) then
                    local currentRankPoints = attacker:GetRankPoints()

                    if currentRankPoints > 100 then
                        attacker:Promote(
                            25,
                            "25 Rank Points have been rewarded for the amputation of an Anti-Citizen."
                        )
                    end
                end
            end
        end
    end
end

function PLUGIN:OnNPCKilled(npc, attacker, inflictor)
    if not IsValid(npc) or not IsValid(attacker) then return end
    if not attacker:IsPlayer() then return end
    if attacker:Team() ~= TEAM_CP then return end

    local class = npc:GetClass()
    local currentRankPoints = attacker:GetRankPoints()

    -- Prevent rewards above 100 RP
    if currentRankPoints >= 100 then return end

    -- Citizen rewards
    if class == "npc_citizen" then
        local reward = math.random(1, 2)

        attacker:Promote(
            reward,
            reward .. " Rank Point(s) have been rewarded for the amputation of an Anti-Citizen."
        )
    end

    -- Gonome rewards
    if class == "npc_zombie" then
        local chance = math.random(1, 3)

        if chance == 2 then
            local reward = math.random(1, 3)

            attacker:Promote(
                reward,
                reward .. " Rank Point(s) have been rewarded for the amputation of a Necrotic."
            )
        end
    end

    -- Fast Gonome rewards
    if class == "npc_fastzombie" then
        local chance = math.random(1, 3)

        if chance == 2 then
            local reward = math.random(1, 3)

            attacker:Promote(
                reward,
                reward .. " Rank Point(s) have been rewarded for the amputation of a Necrotic."
            )
        end
    end
end