local VENDOR = {}

VENDOR.UniqueID = "medical"
VENDOR.Name = "Medical Supply Dispenser"
VENDOR.Desc = "Purchase medical supplies."

VENDOR.Model = "models/props_combine/combine_dispenser.mdl"

VENDOR.Talk = false

VENDOR.Sell = {
	["item_healthvial"] = {
		Cost = 20,
		BuyMax = 4,
		TempCooldown = 600
	}
}

function VENDOR:CanUse(ply)
	return ply:Team() == TEAM_CITIZEN and ply:GetTeamClass() == CLASS_CWU_MEDICAL
end

impulse.RegisterVendor(VENDOR)