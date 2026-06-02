local VENDOR = {}

VENDOR.UniqueID = "cloth"
VENDOR.Name = "Clothing Dispenser"
VENDOR.Desc = "Purchase fashionable pieces of clothing."
VENDOR.DownloadTrades = true
VENDOR.Model = "models/props_combine/combine_dispenser.mdl"

--VENDOR.Gender = "male" -- male, female, cp

VENDOR.Talk = false

VENDOR.Buy = {}

VENDOR.Sell = {
    ["cos_blue_shirt"] = {
        Cost = 10
    },
    ["cos_white_shirt"] = {
        Cost = 10
    },
    ["cos_tan_shirt"] = {
        Cost = 10
    },
    ["cos_medical_shirt"] = {
        Cost = 15
    },
    ["cos_green_shirt"] = {
        Cost = 10
    },
    ["cos_loyaljacket_a"] = {
        Cost = 15
    },
    ["cos_loyaljacket_b"] = {
        Cost = 15
    },
    ["cos_loyaljacket_c"] = {
        Cost = 15
    },
    ["cos_brownpants"] = {
        Cost = 10
    },
    ["cos_paddedpants"] = {
        Cost = 10
    },
    ["cos_glove_fingered"] = {
        Cost = 5
    },
    ["cos_glove_fingerless"] = {
        Cost = 5
    },
    ["cos_beanie_grey"] = {
        Cost = 5
    },
    ["cos_beanie_green"] = {
        Cost = 5
    }
}

function VENDOR:CanUse(ply)
	return not ply:IsCP()
end

function VENDOR:Think()
	self:NextThink(CurTime() + 2)
end

impulse.RegisterVendor(VENDOR)