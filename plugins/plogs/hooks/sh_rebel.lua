plogs.Register('Rebel', false)

plogs.AddHook("VolatilityLockerUse", function(ply, RebelState)
	state = tostring(RebelState)
	plogs.PlayerLog(ply, 'Rebel', ply:NameID().." changed rebel state to " .. state, {
		['Name'] 	= ply:Name(),
		['SteamID']	= ply:SteamID()
	})
end)
