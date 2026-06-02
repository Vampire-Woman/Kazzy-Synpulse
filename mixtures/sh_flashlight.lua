local MIX = {}

MIX.Class = "flashlight"

MIX.Level = 3
MIX.Bench = "general"

MIX.Output = "item_flashlight"
MIX.Input = {
	["util_metalplate"] = {take = 1},
	["util_battery"] = {take = 1}
}

impulse.RegisterMixture(MIX)
