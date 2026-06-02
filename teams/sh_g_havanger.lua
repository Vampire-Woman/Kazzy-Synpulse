TEAM_HAVANGER = impulse.Teams.Define({
    name = "Havanger",
    color = Color(80, 80, 80),
    description = "Opposite of SSBBW",
    loadout = {"impulse_hands", "weapon_zombie_fast"},
    salary = 0,
    xp = 0,
    handModel = "models/zombie/hla/hands/v_shirtless_hands.mdl",
    bodygroups = {{1,1},{2,0},{3,0},{4,0},{5,0},{6,0},{7,0},{8,0},{9,0}},
    cp = false,
    onBecome = function(ply)
		havangerspawnpoints = {
			Vector( -1889, -1704, -127 ),
			Vector( -1989, -1704, -127 ),
			Vector( -1899, -1757, -127 ),
			Vector( -1629, -614, -191 ),
			Vector( -1692, -861, -191 ),
			Vector( -1681, -615, -191 )
		}
		
		--ply:SetPos(table.Random(havangerspawnpoints))	
        ply:SetModel("models/Zombie/Fast.mdl")
        ply:SetRunSpeed(225)
        ply:SetJumpPower(300)
        ply:SetWalkSpeed(60)
        ply:SetHealth(100)
        ply:SetMaxHealth(100)
        ply:AllowFlashlight(false)
    end
})

hook.Add("EntityTakeDamage", "Havanger_NoFallDamage", function(ent, dmginfo)
    if not ent:IsPlayer() then return end
    if ent:Team() ~= TEAM_HAVANGER then return end

    if dmginfo:IsDamageType(DMG_FALL) then
        return true
    end
	
    if dmginfo:IsDamageType(DMG_ACID) then
        return true
    end	
end)

hook.Add("GetFallDamage", "Havanger_NoFallDamages", function(ply, speed)
    if ply:Team() == TEAM_HAVANGER then
        return 0
    end
end)