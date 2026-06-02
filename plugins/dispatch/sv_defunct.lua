impulse.Dispatch = impulse.Dispatch or {}
impulse.Dispatch.Defunct = impulse.Dispatch.Defunct or {}

function meta:AddDispatchDefunct()
	self:SetSyncVar(SYNC_DISPATCH_DEFUNCT, 6, true)

	local rf = RecipientFilter()
	rf:AddRecipientsByTeam(TEAM_CP)

	impulse.Dispatch.Defunct[self:SteamID()] = true -- Add player to defunct list
end

function meta:RemoveDispatchDefunct()
	if not self:GetSyncVar(SYNC_DISPATCH_DEFUNCT, nil) then
		return
	end

	impulse.Dispatch.Defunct[self:SteamID()] = nil -- Remove player from defunct list

	self:SetSyncVar(SYNC_DISPATCH_DEFUNCT, nil, true)
end

hook.Add("PlayerDeath", "impulseCitadelDefunctRemover", function(ply, ent, attacker)
	if ply:IsDispatchDefunct() then
		ply:RemoveDispatchDefunct()
	end
end)