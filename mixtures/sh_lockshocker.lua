local MIX = {}

MIX.Class = "lockshocker"

MIX.Level = 3
MIX.Bench = "general"

MIX.Output = "item_lockshocker"
MIX.Input = {
	["util_refinedmetalplate"] = {take = 1},
	["util_electronics"] = {take = 1},
}

impulse.RegisterMixture(MIX)
