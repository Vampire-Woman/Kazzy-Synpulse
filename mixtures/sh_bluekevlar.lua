local MIX = {}

MIX.Class = "cos_bluekevlar"

MIX.Level = 3
MIX.Bench = "general"

MIX.Output = "cos_blue_rebelvest"
MIX.Input = {
	["cos_blue_shirt"] = {take = 1},
	["util_refinedmetalplate"] = {take = 1},
	["util_cpvest"] = {take = 1}
}

impulse.RegisterMixture(MIX)