util.AddNetworkString("impulseHalloweenStrike")
util.PrecacheModel("models/lightning/lightning1.mdl")
util.PrecacheModel("models/lightning/lightning2.mdl")
util.PrecacheModel("models/lightning/lightning3.mdl")

local strikePoses = {
	["rp_suppressed_v1_halloween"] = {
		Vector(-571.45050048828, -3597.5417480469, 76.03125),
		Vector(-211.90751647949, 639.15393066406, 76.03125),
		Vector(-2787.8725585938, -2054.0300292969, 80.03125),
		Vector(3590.251953125, 9415.9873046875, -13542.087890625),
		Vector(698.2509765625, 8324.8701171875, -13542.96875),
		Vector(-9365.443359375, -2078.3386230469, -9389.0703125),

	}
}

function doLightningStrike(rf)
	net.Start("impulseHalloweenStrike")
	net.WriteVector(strikePoses[game.GetMap()][math.random(1, #strikePoses[game.GetMap()])])
	if rf then
		net.Send(rf)
	else
		net.Broadcast()
	end
end

local nextStrike
function PLUGIN:Think()
	if nextStrike and nextStrike > CurTime() then
		return
	end

	if not strikePoses[game.GetMap()] then
		return print("[impulse] Halloween lightning strike positions NOT SETUP!!!! PANIC (goto sv_storm.lua and set them up please)")
	end

	if math.random(1, 10) > 7 then
		nextStrike = CurTime() + math.random(1.1, 4)
	else
		nextStrike = CurTime() + math.random(35, 57)
	end

	doLightningStrike()
end