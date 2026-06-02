local VENDOR = {}

VENDOR.UniqueID = "metal"
VENDOR.Name = "Civil Refinery Dispenser"
VENDOR.Desc = "Purchase and sell metal supplies."
VENDOR.DownloadTrades = true
VENDOR.Model = "models/props_combine/combine_dispenser.mdl"

--VENDOR.Gender = "male" -- male, female, cp

VENDOR.Talk = false

VENDOR.Buy = {
     ["util_fuel"] = {
        Cost = 40
    },
    ["util_refinedmetalplate"] = {
        Cost = 3
    },
    ["util_reclaimedmetalplate"] = {
        Cost = 2
    }
}

VENDOR.Sell = {
    ["util_metalplate"] = {
        Cost = 1
    },
}

function VENDOR:CanUse(ply)
	return ply:Team() == TEAM_CITIZEN and ply:GetTeamClass() == CLASS_CWU_INDUSTRIAL
end

function VENDOR:Think()
	self:NextThink(CurTime() + 2)
end

impulse.RegisterVendor(VENDOR)