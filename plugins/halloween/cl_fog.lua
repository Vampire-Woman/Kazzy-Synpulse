local fog = {				
	["fog_start"] = 600,
	["fog_end"] = 3000,
	["fog_max_density"] = 0.13,
	["fog_color"] = Vector(147, 126, 187) * 0.9
}

local fogFade = 0
local transSpeed = 0.3
local transWait = 2
local wait = 0
local function SetupFog()
	render.FogMode(MATERIAL_FOG_LINEAR)
	render.FogStart(fog.fog_start)
	render.FogEnd(fog.fog_end)
	render.FogColor(fog.fog_color.r, fog.fog_color.g, fog.fog_color.b)

	if impulse.GetSetting("hal_fog") then
		render.FogMaxDensity(math.Clamp(fog.fog_max_density, 0.19, 1))
	else
		render.FogMaxDensity(0.01)
	end
				
	return true
end

-- hook it
PLUGIN.SetupWorldFog = SetupFog
PLUGIN.SetupSkyboxFog = SetupFog