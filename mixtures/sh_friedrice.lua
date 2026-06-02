local MIX = {}

MIX.Class = "friedrice"

MIX.Level = 3
MIX.Bench = "stove"

MIX.Output = "food_friedrice"
MIX.Input = {
	["util_spices"] = {take = 1},
	["util_rice"] = {take = 1},
	["food_water"] = {take = 1}
}

impulse.RegisterMixture(MIX)