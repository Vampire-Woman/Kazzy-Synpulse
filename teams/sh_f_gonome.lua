TEAM_GONOME = impulse.Teams.Define({
    name = "Gonome",
    color = Color(120, 80, 80),
    description = "Funky town guy, is that you?",
    loadout = {"impulse_hands", "weapon_zombie_classic"},
    salary = 0,
    xp = 0,
	handModel = "models/zombie/hla/hands/v_worker01_hands.mdl",
    bodygroups = {{1,1},{2,0},{3,0},{4,0},{5,0},{6,0},{7,0},{8,0},{9,0}},
    cp = false,
    onBecome = function(ply)
		gonomespawnpoints = {
			Vector( -1889, -1704, -127 ),
			Vector( -1941, -1704, -127 ),
			Vector( -1989, -1704, -127 ),
			Vector( -1899, -1757, -127 ),
			Vector( -1629, -614, -191 ),
			Vector( -1637, -858, -191 ),
			Vector( -1692, -861, -191 ),
			Vector( -1681, -615, -191 )
		}
		
		--ply:SetPos(table.Random(gonomespawnpoints))		
        ply:SetModel("models/Zombie/Classic.mdl")
        ply:SetRunSpeed(45)
		ply:SetJumpPower(0)
        ply:SetWalkSpeed(45)
        ply:SetHealth(100)
        ply:SetMaxHealth(100)
        ply:AllowFlashlight(false)
    end
})

hook.Add("StartCommand", "DisableGonomeJump", function(ply, cmd)
    if ply:Team() == TEAM_GONOME then
        cmd:RemoveKey(IN_JUMP)
    end
end)