local MIX = {}

MIX.Class = "cos_armoredpants"

MIX.Level = 3
MIX.Bench = "general"

MIX.Output = "cos_armoredpants"
MIX.Input = {
	["cos_paddedpants"] = {take = 1},
	["util_refinedmetalplate"] = {take = 2}
}

impulse.RegisterMixture(MIX)