function meta:IsDispatchDefunct()
	local defunct = self:GetSyncVar(SYNC_DISPATCH_DEFUNCT, nil)

	if defunct then
		return true, defunct
	end

	return false
end

if SERVER then
	util.AddNetworkString("impulseHL2RPDefunct")
else
	net.Receive("impulseHL2RPDefunct", function()
		local sender = net.ReadUInt(8)
		local message = net.ReadString()
		sender = Entity(sender)

		if sender and IsValid(sender) and sender:IsPlayer() then
			surface.PlaySound("npc/overwatch/radiovoice/disengaged647e.wav")
			LocalPlayer():SendCombineMessage("LOCAL UNIT HAS BEEN MARKED AUTONOMOUS AMPUTATE " .. sender:Name(), Color(204, 165, 8))
			LocalPlayer():SendTrackedCombineWaypoint("MARKED AS AUTONOMOUS", sender:GetPos(), 90, 2, 5, nil, nil, nil, nil, sender)
		end
	end)
end