impulse.DefineSetting("misc_cameranotifyduration", {name="Camera notify duration", category="Misc", type="slider", default=45, minValue=20, maxValue=140})
impulse.DefineSetting("misc_cameranotifymax", {name="Camera notify max", category="Misc", type="slider", default=3, minValue=1, maxValue=6})

net.Receive("impulseHL2RPCivilUnrestStart", function()
	timer.Simple(0.05, function()
        surface.PlaySound("npc/overwatch/cityvoice/f_unrestprocedure1_spkr.wav")
    end)
	
	--impulse.customChatFont = "Impulse-ChatRadio"
    --chat.AddText(Color(127, 255, 212), "[DISPATCH ANNOUNCEMENT]: ", "Attention community: unrest procedure code is now in effect. Inoculate, shield, pacify. Code: pressure, sword, sterilize.")
end)

net.Receive("impulseHL2RPCivilStart", function()
end)

net.Receive("impulseHL2RPJWStart", function()
	--impulse.customChatFont = "Impulse-ChatRadio"
    --chat.AddText(Color(127, 255, 212), "[DISPATCH ANNOUNCEMENT]: ", "Attention all Ground Protection teams: Judgement Waiver is now in effect. Capital prosecution is discretionary.")

    --surface.PlaySound("ambient/alarms/warningbell1.wav")
	
	timer.Simple(2, function()
        surface.PlaySound("npc/overwatch/cityvoice/f_protectionresponse_5_spkr.wav")
    end)	
	
	timer.Simple(5, function()
        surface.PlaySound("ambient/alarms/citadel_alert_loop2.wav")
    end)	

	timer.Simple(0.10, function()
        surface.PlaySound("ambient/levels/city/citadeloutsidefx04.wav")
    end)

	timer.Simple(0.10, function()
        surface.PlaySound("ambient/levels/citadel/citadel_5sirens3.wav")
    end)
	
	timer.Simple(33, function()
        surface.PlaySound("ambient/machines/thumper_startup1.wav")
    end)

	timer.Simple(10, function()
        surface.PlaySound("ambient/levels/launch/outsidesilodoorsopen.wav")
    end)
	
	timer.Simple(15, function()
        surface.PlaySound("overwatch/citywide/overwatch_chargedwithmultiplelevel5.mp3")
    end)	

    timer.Simple(35, function()
        surface.PlaySound("ambient/machines/wall_move2.wav")
    end)	
	
	timer.Simple(35, function()
        surface.PlaySound("ambient/alarms/citadel_alert_loop2.wav")
    end)		
	
    timer.Simple(41, function()
        surface.PlaySound("ambient/machines/wall_crash1.wav")
		util.ScreenShake(Vector(0, 0, 0), 50, 50, 1, 1000)
    end)	

    timer.Simple(43, function()
        surface.PlaySound("ambient/machines/wall_move1.wav")
    end)		
	
    timer.Simple(41, function()
        surface.PlaySound("ambient/atmosphere/terrain_rumble1.wav")
    end)			
end)

net.Receive("impulseHL2RPAmmoRaid", function()
	local box = net.ReadVector()

	surface.PlaySound("npc/overwatch/radiovoice/attention.wav")
	timer.Simple(1.8, function()
		surface.PlaySound("npc/overwatch/radiovoice/restrictedincursioninprogress.wav")
	end)

	LocalPlayer():SendCombineMessage("HIGH PRIORITY TRANMISSION INBOUND...", Color(139, 0, 0))
	timer.Simple(1, function()
		LocalPlayer():SendCombineMessage("RESTRICTED INCURSION DETECTED - ALL TEAMS RESPOND CODE 3", Color(139, 0, 0))
		impulse.AddCombineWaypoint("ILLEGAL INCURSION (RESPOND CODE 3)", box, impulse.Config.AmmoDrillTime, 6, 4, 4)
	end)
end)

local squadWaypointCol = Color(75, 155, 45, 100)
net.Receive("impulseSquadDoReinforce", function()
	local squad = net.ReadUInt(8)
	local pos = net.ReadVector()

	surface.PlaySound("npc/overwatch/radiovoice/reinforcementteamscode3.wav")

	local n = LocalPlayer():Team() == TEAM_CP and "PT" or "SQUAD"
	LocalPlayer():SendCombineMessage(n.." "..squad.." REQUESTING REINFORCEMENT", squadWaypointCol)
	impulse.AddCombineWaypoint(n.." "..squad.." REINFORCEMENT", pos, 60, 5, 2, 2)
end)

net.Receive("impulseSquadDoOrder", function()
	local text = net.ReadString()

	LocalPlayer():SendCombineMessage("NEW SQUAD OBJECTIVE:", squadWaypointCol)
	LocalPlayer():SendCombineMessage(text, squadWaypointCol)
end)

net.Receive("impulseSquadDoBlockInspection", function()
	local blockName = net.ReadString()
	local pos = net.ReadVector()

	surface.PlaySound("npc/overwatch/radiovoice/attention.wav")

	timer.Simple(0.7, function()
		surface.PlaySound("npc/overwatch/radiovoice/search.wav")

		timer.Simple(0.7, function()
			surface.PlaySound("npc/overwatch/radiovoice/residentialblock.wav")
		end)
	end)

	LocalPlayer():SendCombineMessage("SEARCH RESIDENTIAL BLOCK - "..string.upper(blockName), squadWaypointCol)
	impulse.AddCombineWaypoint("SEARCH BLOCK ("..string.upper(blockName)..")", pos, 120, 4, 2, 2)
end)

net.Receive("impulseHL2RPMedicCallRec", function()
	local caller = net.ReadEntity()

	if not IsValid(caller) then
		return
	end

	impulse.AddCombineMessage("MEDICAL ATTENTION REQUESTED FROM "..caller:Nick(), Color(168, 50, 76))
	impulse.AddCombineWaypoint("MEDICAL ATTENTION REQUESTED", caller:GetPos(), 65, 3, 5, 5, caller)
end)

net.Receive("impulseHL2RPObjectiveSend", function()
	local sender = net.ReadEntity()
	local order = net.ReadString():upper()
	
	if not IsValid(sender) then
		return
	end

	surface.PlaySound("npc/metropolice/vo/off1.wav")
	timer.Simple(0.8, function()
		surface.PlaySound("npc/overwatch/radiovoice/attention.wav")
	end)

	impulse.AddCombineMessage("INCOMING OBJECTIVE FROM "..sender:Nick(), Color(0, 107, 149))
	impulse.AddCombineMessage(order, Color(0, 107, 149))

	CP_OBJECTIVE = {
		message = order,
		endTime = CurTime() + 20,
		sender = sender:Nick()
	}
end)

net.Receive("impulseHL2RPObjectiveSendEvent", function()
	local order = net.ReadString():upper()
	local length = net.ReadUInt(8)
	
	surface.PlaySound("npc/metropolice/vo/off1.wav")
	timer.Simple(0.8, function()
		surface.PlaySound("npc/overwatch/radiovoice/attention.wav")
	end)

	impulse.AddCombineMessage("INCOMING OBJECTIVE FROM DISPATCH", Color(0, 107, 149))
	impulse.AddCombineMessage(order, Color(0, 107, 149))

	CP_OBJECTIVE = {
		message = order,
		endTime = CurTime() + length
	}
end)

net.Receive("impulseHL2RPCityCodeChange", function()
    local citycode = net.ReadString() -- Use string for city code

    if citycode == "jw" then
        CP_OBJECTIVE = nil

        timer.Simple(1.5, function()
            CP_OBJECTIVE = {
                citycode = citycode,
                endTime = CurTime() + 30
            }
        end)
    end
end)