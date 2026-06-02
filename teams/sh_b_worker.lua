TEAM_WORKER = impulse.Teams.Define({
	name = "Combine Worker",
	color = Color(99, 120, 144),
	description = "",
	loadout = {"impulse_hands"},
	handModel = "models/weapons/c_arms_citizen.mdl",
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
            name = "Engineer Core",
            description = "",
			model = "models/odessa.mdl",
            xp = 0,
            noMenu = true,
            onBecome = function(ply)
                ply:SetRunSpeed(impulse.Config.JogSpeed)
                ply:GiveInventoryItem("wep_medkit", 1, true)
				ply:GiveInventoryItem("wep_id", 1, true)
			end			
        }
    }
})

CLASS_WORKER = 1