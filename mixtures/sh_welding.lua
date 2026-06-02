local MIX = {}

MIX.Class = "cos_welding"

MIX.Level = 4
MIX.Bench = "general"

MIX.Output = "cos_weldingmask"
MIX.Input = {
	["cos_beanie_grey"] = {take = 1},
	["util_refinedmetalplate"] = {take = 2}
}

impulse.RegisterMixture(MIX)
