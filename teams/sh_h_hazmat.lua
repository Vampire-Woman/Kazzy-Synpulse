TEAM_HAZMAT = impulse.Teams.Define({
	name = "Infestation Control",
	color = Color(155, 155, 44),
	description = "",
	loadout = {"impulse_hands"},
	handModel = "models/weapons/c_hlvr_hazmat_worker_arms.mdl",
	salary = 20,
	xp = 0,
	bodygroups = {{1, 0}, {2, 0}, {3, 0}, {4, 0}, {5, 0}},
	cp = true,
	onBecome = function(ply)
		 ply:SetRunSpeed(impulse.Config.JogSpeed)
		 ply:SetWalkSpeed(68)
		 ply:SetJumpPower(160)
		 ply:SetMaxHealth(100)
		 ply:SetHealth(100)
		 ply:GiveInventoryItem("wep_id", 1, true)
		 
		-- Set RP name as per original code logic
		local sSteamID = ply:SteamID64()
		local sLastDigits = string.Right(sSteamID, 3)
		local sTagLine = "Tap " .. sLastDigits
		ply:SetRPName(sTagLine, false)
		 
		 timer.Simple(0,function()   
			 ply:SetTeamClass(1)
			 ply:AllowFlashlight(true)
		 end)
	end,
	
    classes = {
        {
            name = "Combine Hazmat Worker",
            description = "",
			model = "models/hlvr/characters/hazmat_worker/npc/hazmat_worker_citizen.mdl",
            xp = 0,
            noMenu = true,
            onBecome = function(ply)
                ply:SetRunSpeed(impulse.Config.JogSpeed)
                ply:GiveInventoryItem("wep_foam", 1, true)
				ply:GiveInventoryItem("wep_id", 1, true)
			end			
        }
    }
})

CLASS_HAZMAT = 1