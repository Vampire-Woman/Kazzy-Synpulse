impulse.Business.Define("Alcohol Brewer", {
    entity = "impulse_hl2rp_brewingbarrel",
    model = "models/props_c17/woodbarrel001.mdl",
    description = "A device to refine metal.",
    price = 90,
    refundAdd = 45,
    refund = true,
    removeOnTeamSwitch = true,
    teams = {TEAM_CITIZEN, TEAM_VORT},
    postSpawn = function(ent, ply)
    	ply.BarrelCount = (ply.BarrelCount or 0) + 1
    end,
    customCheck = function(ply)
    	local barrelCount = ply.BarrelCount or 0

    	if barrelCount >= impulse.Config.MaxBarrels then
    		ply:Notify("You have reached the max amount of alcohol brewers.")
    		return false
    	else
    		return true
    	end
    end
})