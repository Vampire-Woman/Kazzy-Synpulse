plogs.Register('Terminal', false)

plogs.AddHook("OnDispatchAnnounce", function(ply, announcement)
	plogs.PlayerLog(ply, 'Terminal', ply:NameID().." activated announcement "..announcement, {
		['Name'] 	= ply:Name(),
		['SteamID']	= ply:SteamID()
	})
end)

plogs.AddHook("ChangeCityCode", function(ply, code)
	if isstring(ply) then
		plogs.PlayerLog(ply, 'Terminal', "City code changed to " .. code .. " by the event manager.", {
			['Name'] 	= "Event Mangager",
			['SteamID']	= "Server"
		})
	else
		plogs.PlayerLog(ply, 'Terminal', ply:NameID().." changed the city code to "..code, {
			['Name'] 	= ply:Name(),
			['SteamID']	= ply:SteamID()
		})
	end
end)

plogs.AddHook("DispatchLines", function(ply, dispatch)
	plogs.PlayerLog(ply, 'Terminal', ply:NameID().." Has just played the annoucement "..dispatch.name, {
		['Name'] 	= ply:Name(),
		['SteamID']	= ply:SteamID()
	})
end)
plogs.AddHook("SetBol", function(ply, bool, msg, placer )


	if not placer then
		return
	end
	
	local logmsg = "empty"
	if bool == true then
		logmsg = ply:NameID().." BOL state changed to " ..tostring(bool) .. " placed by: " .. placer:NameID() or "DISPATCH"
	else
		logmsg = ply:NameID().." BOL state changed to " ..tostring(bool) .. " removed by: " .. placer:NameID() or "DISPATCH"
	end
	plogs.PlayerLog(ply, 'Terminal', logmsg, {
		['Name'] 	= ply:Name(),
		['SteamID']	= ply:SteamID(),
		['Placer Name'] = placer:Name() or "DISPATCH",
		['Placer SteamID'] = placer:SteamID() or "DISPATCH",
	})
end)