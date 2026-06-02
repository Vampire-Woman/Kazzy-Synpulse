local MIX = {}

MIX.Class = "reclaimedmetal"

MIX.Level = 1
MIX.Bench = "general"

MIX.Output = "util_reclaimedmetalplate"
MIX.Input = {
	["util_metalplate"] = {take = 3},
}

impulse.RegisterMixture(MIX)
