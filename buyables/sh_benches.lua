impulse.Business.Define("General Workbench", {
	bench = "general",
	model = "models/mosi/fallout4/furniture/workstations/workshopbench.mdl",
    refund = true,
	price = 0,
    removeOnTeamSwitch = true,
    customCheck = function(ply)
    	return not ply:IsCP()
    end
})

impulse.Business.Define("Cooking Stove", {
	bench = "stove",
	model = "models/props_wasteland/kitchen_stove001a.mdl",
    refund = true,
	price = 0,
    removeOnTeamSwitch = true,
    customCheck = function(ply)
    	if ply:Team() == TEAM_CITIZEN and ply:GetTeamClass() == CLASS_CWU_COMMERCIAL then
    		return true
    	end

    	return not ply:IsCP()
    end
})


