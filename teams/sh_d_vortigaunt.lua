TEAM_VORT = impulse.Teams.Define({
    name = "Enslaved Alien",
    color = Color(172, 156, 11, 255),
    description = [[A mysterious alien race, enslaved by the Universal Union.
They are a wise and mainly peaceful race, forced into servitude by other
races for centuries. Most are treated poorly by the Combine, forced to 
clean the streets and Nexus. However, once freed they are able to harness
a mysterious energy, known as the Vortessence, that connects them with
each other.]],
    loadout = {"impulse_hands", "ls_broom"},
    salary = 0,
    skin = 1,
    bodygroups = {{1,0},{2,0},{3,0},{4,0},{5,0},{6,0},{7,0},{8,0},{9,0}},
    model = "models/vortigaunt_slave.mdl",
    handModel = "models/weapons/vortigaunt_junior_arms.mdl",
    donatorOnly = true,
    xp = 1000,
    onBecome = function(ply)
        ply:SetRunSpeed(65)
        ply:SetWalkSpeed(65)
        ply:SetJumpPower(0)
        ply:SetHealth(100)
        ply:SetMaxHealth(100)
        ply:AllowFlashlight(false)
        ply:GiveInventoryItem("wep_id", 1, true)

        -- Set RP name as per original code logic
        local sSteamID = ply:SteamID64()
        local sLastDigits = string.Right(sSteamID, 3)
        local sTagLine = "B39-09" .. sLastDigits
        ply:SetRPName(sTagLine, false)
    end
})

hook.Add("StartCommand", "DisableVortJump", function(ply, cmd)
    if ply:Team() == TEAM_VORT then
        cmd:RemoveKey(IN_JUMP)
    end
end)

hook.Add("StartCommand", "DisableVortWalk", function(ply, cmd)
    if ply:Team() == TEAM_VORT then
        cmd:RemoveKey(IN_WALK)
    end
end)