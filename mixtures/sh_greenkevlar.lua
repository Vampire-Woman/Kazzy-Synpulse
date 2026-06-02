local MIX = {}

MIX.Class = "cos_greenkevlar"

MIX.Level = 3
MIX.Bench = "general"

MIX.Output = "cos_green_rebelvest"
MIX.Input = {
	["cos_green_shirt"] = {take = 1},
	["util_refinedmetalplate"] = {take = 1},
	["util_cpvest"] = {take = 1}
}

impulse.RegisterMixture(MIX)