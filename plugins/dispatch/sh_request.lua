if SERVER then
	util.AddNetworkString("impulseHL2RPRequest")
else
	net.Receive("impulseHL2RPRequest", function()
		local sender = net.ReadUInt(8)
		local message = net.ReadString()
		sender = Entity(sender)

		if sender and IsValid(sender) and sender:IsPlayer() then
			LocalPlayer():SendCombineMessage("NEW REQUEST FROM: "..sender:Name(), Color(0, 0, 255))
			LocalPlayer():SendCombineMessage("MESSAGE: "..message, Color(0, 0, 255))

			LocalPlayer():SendTrackedCombineWaypoint(message, sender:GetPos(), 90, 2, 5, nil, nil, nil, nil, sender)

			surface.PlaySound("npc/overwatch/radiovoice/attention.wav")
		end
	end)
end

if SERVER then
	util.AddNetworkString("impulseHL2RPDistress")
else
	net.Receive("impulseHL2RPDistress", function()
		local sender = net.ReadUInt(8)
		local message = net.ReadString()
		sender = Entity(sender)

		if sender and IsValid(sender) and sender:IsPlayer() then
			LocalPlayer():SendTrackedCombineWaypoint(
				"RESPOND",
				sender:GetPos(),
				90,
				2,
				5,
				nil,
				nil,
				nil,
				nil,
				sender
			)

			surface.PlaySound("npc/overwatch/radiovoice/attention.wav")

			timer.Simple(0.7, function()
				surface.PlaySound("overwatch/radio_vo_protectionteam.wav")
			end)

			timer.Simple(1.7, function()
				surface.PlaySound("npc/overwatch/radiovoice/respond.wav")
			end)
		end
	end)
end

local requestCommand = {
	description = "Sends a request to Metropolice teams for assistance.",
	requiresArg = true,
	requiesAlive = true,
	onRun = function(ply, arg, rawText)
		if ply:Alive() and (ply:Team() == TEAM_CITIZEN or ply:Team() == TEAM_VORT) then
			if (ply.nextRequest or 0) > CurTime() then 
				return ply:Notify("Please wait a while before sending another request.") 
			end

			if ply:GetSyncVar(SYNC_ARRESTED, false) then
				return ply:Notify("You can not send a request when arrested.")
			end
			
			if ply:IsValid() then
				return ply:Notify("You do not have a request device.")
			end

			if ply:IsArmored() then
				return ply:Notify("You can not send a request as a rebel.")
			end

			local recipFilter = RecipientFilter()

			for v,k in pairs(player.GetAll()) do
				if k:Team() == TEAM_CP or k:Team() == TEAM_OTA then
					recipFilter:AddPlayer(k)
				end
			end

			net.Start("impulseHL2RPRequest")
			net.WriteUInt(ply:EntIndex(), 8)
			net.WriteString(rawText)
			net.Send(recipFilter)

			ply:Notify("You have sent a request to Metropolice teams.")
			ply:EmitBudgetSound("ambient/levels/prison/radio_random2.wav")
			ply.nextRequest = CurTime() + 30
		else
			ply:Notify("You must be a citizen to make a request.")
		end
	end
}

impulse.RegisterChatCommand("/request", requestCommand)

local respondCommand = {
	description = "Overwatch sends a Civil Protection Team to respond.",
	requiresArg = false,
	adminOnly = true,
	onRun = function(ply, arg, rawText)
		if ply:Alive() and (ply:Team() == TEAM_CP) then
			if (ply.nextRequest or 0) > CurTime() then 
				return
			end

			local recipFilter = RecipientFilter()

			for v,k in pairs(player.GetAll()) do
				if k:Team() == TEAM_CP or k:Team() == TEAM_OTA then
					recipFilter:AddPlayer(k)
				end
			end

			net.Start("impulseHL2RPDistress")
			net.WriteUInt(ply:EntIndex(), 8)
			net.Send(recipFilter)

			ply.nextRequest = CurTime() + 5
		else
		end
	end
}

impulse.RegisterChatCommand("/respond", respondCommand)