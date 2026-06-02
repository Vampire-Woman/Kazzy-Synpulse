TEAM_CITIZEN = impulse.Teams.Define({
    name = "Citizen",
    color = Color(99, 120, 144),
    description = "",
    loadout = {"impulse_hands"},
    salary = 20,
    xp = 0,
    bodygroups = {{1, 1}, {2, 0}, {3, 0}, {4, 0}, {5, 0}},
    cp = false,

    onBecome = function(ply)
        ply:SetRunSpeed(impulse.Config.JogSpeed)
        ply:SetWalkSpeed(65)
        ply:SetJumpPower(160)
        ply:SetMaxHealth(100)
        ply:SetHealth(100)
        ply:AllowFlashlight(false)

        ply:GiveInventoryItem("wep_id", 1, true)

        timer.Simple(0, function()
            if IsValid(ply) then
                ply:AllowFlashlight(false)
            end
        end)
    end
})