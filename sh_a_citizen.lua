TEAM_CITIZEN = impulse.Teams.Define({
    name = "Citizen",
    color = Color(99, 120, 144),
    description = "",
    loadout = {"impulse_hands"},
    salary = 20,
    xp = 0,
    bodygroups = {
        {1, 1},
        {2, 0},
        {3, 0},
        {4, 0},
        {5, 0}
    },
    cp = false,

	onBecome = function(ply)
		ply:SetRunSpeed(impulse.Config.JogSpeed)
		ply:SetWalkSpeed(65)
		ply:SetJumpPower(160)
		ply:SetMaxHealth(100)
		ply:SetHealth(100)
		ply:AllowFlashlight(false)

		timer.Simple(1, function()
			if not IsValid(ply) then return end
			ply:GiveInventoryItem("wep_id", 1, true)
		end)
	end
})

hook.Add("PlayerInitialSpawn", "Impulse_GiveWepIDOnce", function(ply)
    timer.Simple(2, function()
        if not IsValid(ply) then return end

        local sid = ply:SteamID64()
        local key = "impulse_wep_id_given_" .. sid

        -- already given forever
        if ply:GetPData(key, "0") == "1" then return end

        -- give item
        ply:GiveInventoryItem("wep_id", 1, true)

        -- mark as given
        ply:SetPData(key, "1")
    end)
end)