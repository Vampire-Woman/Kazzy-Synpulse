plogs.Register('Names', false)

plogs.AddHook("PlayerChangeRPName", function(ply, output)
	plogs.PlayerLog(ply, 'Names', ply:NameID().." has changed RP name to "..output, {
		['Name'] 	= ply:Name(),
		['SteamID']	= ply:SteamID()
	})
end)
