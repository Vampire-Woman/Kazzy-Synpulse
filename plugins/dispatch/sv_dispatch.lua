util.AddNetworkString("impulseHL2RPDispatchAnnounce")
util.AddNetworkString("impulseHL2RPDispatchCityCode")
util.AddNetworkString("impulseHL2RPCivilUnrestStart")
util.AddNetworkString("impulseHL2RPJWStart")
util.AddNetworkString("impulseHL2RPCivilStart")
util.AddNetworkString("impulseHL2RPMedicCall")
util.AddNetworkString("impulseHL2RPMedicCallRec")
util.AddNetworkString("impulseHL2RPObjectiveSet")
util.AddNetworkString("impulseHL2RPObjectiveSend")
util.AddNetworkString("impulseHL2RPObjectiveSendEvent")
util.AddNetworkString("impulseHL2RPCityCodeChange")
util.AddNetworkString("impulseHL2RPAmmoRaid")

-- =========================
-- DISPATCH ANNOUNCE
-- =========================
net.Receive("impulseHL2RPDispatchAnnounce", function(len, ply)
    print("[SERVER DEBUG] DispatchAnnounce received from:", ply:Nick())

    if not ply:IsUUHigherRank() then
        print("[SERVER DEBUG] FAILED: Not higher rank")
        ply:Notify("You don't have access to make announcements.")
        return
    end
    
    if (nextDispatchSay or 0) > CurTime() then
        print("[SERVER DEBUG] FAILED: Cooldown active")
        return ply:Notify("Wait before broadcasting another announcement.")
    end

    nextDispatchSay = CurTime() + 14

    local index = net.ReadUInt(8)
    print("[SERVER DEBUG] Announcement index:", index)

    if not impulse.Config.DispatchLines[index] then
        print("[SERVER DEBUG] FAILED: Invalid index")
        return
    end

    print("[SERVER DEBUG] Announcement valid. Sending.")
    impulse.Dispatch.Announce(index)
    ply:Notify("Dispatch announcement sent.")
    hook.Run("OnDispatchAnnounce", ply, index)
end)

-- =========================
-- CITY CODE CHANGE
-- =========================
local nextCityCodeChange = nextCityCodeChange or 0

net.Receive("impulseHL2RPDispatchCityCode", function(len, ply)

    print("--------------------------------------------------")
    print("[SERVER DEBUG] CityCode change requested by:", ply:Nick())

	if not ply:IsUUHigherRank() then
        print("[SERVER DEBUG] FAILED: Not high rank")
        ply:Notify("No access.")
        return
    end
	
	if not ply:IsCP() then
        print("[SERVER DEBUG] FAILED: Not CP")
        return
    end

    if nextCityCodeChange > CurTime() then
        print("[SERVER DEBUG] FAILED: Cooldown active")
        return ply:Notify("City code cooldown active.")
    end

    local code = net.ReadString()
    print("[SERVER DEBUG] Raw city code received:", code)

    if not impulse.ci.socioStatus.list[code] then
        print("[SERVER DEBUG] FAILED: Code not found in socioStatus list")
        PrintTable(impulse.ci.socioStatus.list)
        return
	end

    local codeData = impulse.ci.socioStatus.list[code]
    print("[SERVER DEBUG] Code exists. Name:", codeData.name)

    -- 🔥 EVENT TRIGGERS
    if code == "sociostatus_marginal" then
        print("[SERVER DEBUG] Triggering Civil Unrest net message")
        net.Start("impulseHL2RPCivilUnrestStart")
        net.Broadcast()
    end

    if code == "sociostatus_preserved" then
        print("[SERVER DEBUG] Triggering Civil Start net message")
        net.Start("impulseHL2RPCivilStart")
        net.Broadcast()
    end

    if code == "sociostatus_fractured" then
        print("[SERVER DEBUG] Triggering JW net message")
        net.Start("impulseHL2RPJWStart")
        net.Broadcast()
    end

    print("[SERVER DEBUG] Sending Combine status messages")

    for _, k in pairs(player.GetAll()) do
        if k:IsCombine() then
            print("[SERVER DEBUG] Sending status to:", k:Nick())
            k:SendCombineMessage("CITY CODE STATUS UPDATE: " .. codeData.name, codeData.color)
        end
    end

    nextCityCodeChange = CurTime() + 90
    print("[SERVER DEBUG] Cooldown set to 90 seconds")

    impulse.Dispatch.SetCityCode(ply, code)
    impulse.Dispatch.SetupCityCode(code)

    ply:Notify("Changed city code to: " .. codeData.name)

	local rf = RecipientFilter()
	rf:AddRecipientsByTeam(TEAM_CP)
	rf:AddRecipientsByTeam(TEAM_OTA)

	print("[SERVER DEBUG] Sending impulseHL2RPCityCodeChange to CP/OTA")

	net.Start("impulseHL2RPCityCodeChange")
    net.WriteString(code)
    net.Send(rf)

    hook.Run("OnCityCodeChanged", ply, codeData.name)
    print("[SERVER DEBUG] City code change complete")
    print("--------------------------------------------------")
end)

-- =========================
-- MEDIC CALL
-- =========================
net.Receive("impulseHL2RPMedicCall", function(len, ply)

    print("[SERVER DEBUG] MedicCall received from:", ply:Nick())

	if not ply:IsCP() then
        print("[SERVER DEBUG] FAILED: Not CP")
		return
	end
	
	if (ply.nextCPMedicCall or 0) > CurTime() then 
        print("[SERVER DEBUG] FAILED: Medic cooldown")
        return 
    end

	ply.nextCPMedicCall = CurTime() + 90

	if ply:Health() > 90 then
        print("[SERVER DEBUG] FAILED: Health too high:", ply:Health())
		return
	end

	print("[SERVER DEBUG] Medic call valid. Building recipient filter.")

	local rf = RecipientFilter()
	rf:AddPlayer(ply)

	for _,k in pairs(player.GetAll()) do
		if k:Team() != TEAM_CP then continue end

		local class = k:GetTeamClass()
		if class and class == CLASS_HELIX then
            print("[SERVER DEBUG] Adding HELIX:", k:Nick())
			rf:AddPlayer(k)
		end
	end

	net.Start("impulseHL2RPMedicCallRec")
	net.WriteEntity(ply)
	net.Send(rf)

    print("[SERVER DEBUG] Medic call sent")
end)

-- =========================
-- OBJECTIVE SET
-- =========================
net.Receive("impulseHL2RPObjectiveSet", function(len, ply)

    print("[SERVER DEBUG] ObjectiveSet received from:", ply:Nick())

	if (ply.nextCPObjSet or 0) > CurTime() then 
        print("[SERVER DEBUG] FAILED: Objective cooldown")
        return 
    end

	ply.nextCPObjSet = CurTime() + 1

	if not ( ply:Team() == TEAM_CP or ply:Team() == TEAM_OTA ) then
        print("[SERVER DEBUG] FAILED: Not CP/OTA")
		return
	end

	if not ply:GetTeamClass() then
        print("[SERVER DEBUG] FAILED: No team class")
		return
	end

	if not ply:IsUUHigherRank() then
        print("[SERVER DEBUG] FAILED: Not high rank")
		return
	end

	if (HL2RP_NEXT_CPOBJECTIVE or 0) > CurTime() then
        print("[SERVER DEBUG] FAILED: Global objective cooldown")
		return ply:Notify("Wait before sending new objective.")
	end

	local order = string.Trim(string.sub(net.ReadString(), 1, 72), " ")
    print("[SERVER DEBUG] Objective text:", order)

	if order == "" then
        print("[SERVER DEBUG] FAILED: Empty objective")
		return
	end

	local rf = RecipientFilter()
	rf:AddRecipientsByTeam(TEAM_CP)
	rf:AddRecipientsByTeam(TEAM_OTA)

	net.Start("impulseHL2RPObjectiveSend")
	net.WriteEntity(ply)
	net.WriteString(order)
	net.Send(rf)

	HL2RP_NEXT_CPOBJECTIVE = CurTime() + 60

	ply:Notify("Objective sent.")
    print("[SERVER DEBUG] Objective broadcast complete")
end)

-- =========================
-- META FUNCTION
-- =========================
function meta:DispatchComm(message)
	print("[SERVER DEBUG] DispatchComm called by:", self:Nick(), "Message:", message)
	if self:IsCP() then
		self:SendChatClassMessage(17, message, self)
	end
end