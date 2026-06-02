local MIX = {}

MIX.Class = "refinedmetal"

MIX.Level = 2
MIX.Bench = "general"

MIX.Output = "util_refinedmetalplate"
MIX.Input = {
	["util_reclaimedmetalplate"] = {take = 3},
}

impulse.RegisterMixture(MIX)
