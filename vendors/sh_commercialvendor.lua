local VENDOR = {}

VENDOR.UniqueID = "commercial"
VENDOR.Name = "Commercial Substance Dispenser"
VENDOR.Desc = "Purchase bulk supplies for food production"

VENDOR.Model = "models/props_combine/combine_dispenser.mdl"

--VENDOR.Gender = "cp" -- male, female, cp
VENDOR.Talk = false

VENDOR.Sell = {
	["item_buildingkit"] = {
        Cost = 15
    },
    ["item_canopener"] = {
        Cost = 10
    },
	["food_jugwater"] = {
        Cost = 5
    },
    ["util_yeast"] = {
        Cost = 5
    },
    ["util_flour"] = {
        Cost = 5
    },
    ["util_rice"] = {
        Cost = 5
    },
    ["util_spices"] = {
        Cost = 5
    },
	["food_milk"] = {
        Cost = 5
    },
	["food_water"] = {
        Cost = 2
    }
}

VENDOR.Buy = {
    ["food_vodka"] = {
        Cost = 100
    },
    ["food_whiskey"] = {
        Cost = 100
    }
}

function VENDOR:CanUse(ply)
	if( ply:Team() == TEAM_CITIZEN and ply:GetTeamClass() and ply:GetTeamClass() == CLASS_CWU_COMMERCIAL ) then
		return true
	else
		return false
	end
end

function VENDOR:OnItemPurchased(class, ply)
	
end

impulse.RegisterVendor(VENDOR)