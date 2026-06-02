CUSTOM_MUSICKITS = CUSTOM_MUSICKITS or {}

file.CreateDir("impulse")
file.CreateDir("impulse/musickits")

CreateClientConVar("impulse_music_debug", "1", false, false)

-- ========================
-- MUSIC KIT LOADING
-- ========================

local function ReadMusicKit(name)
	local path = "impulse/musickits/" .. name
	local txt = file.Read(path)

	if not txt then return end

	local json = util.JSONToTable(txt)
	if not json then return end

	CUSTOM_MUSICKITS[json.Name or name] = json
end

local function LoadMusicKits()
	local kits = file.Find("impulse/musickits/*.json", "DATA")

	for _, k in ipairs(kits) do
		ReadMusicKit(k)
	end
end

LoadMusicKits()

-- ========================
-- COMBAT CHECK
-- ========================

local function InCombat()
	if not impulse or not impulse.ci or not impulse.ci.socioStatus then
		return false
	end

	local ok, result = pcall(function()
		local status = impulse.ci.socioStatus.GetCurrent()
		return impulse.ci.socioStatus.ToNumber(status) == 3
	end)

	return ok and result or false
end

-- ========================
-- SONG PICKER
-- ========================

local function GetRandomSong(style)
	local list = (style == "combat") and impulse.Config.CombatMusic or impulse.Config.PassiveMusic

	if not list or #list == 0 then
		return nil
	end

	local pick = list[math.random(#list)]
	return pick[1], pick[2] or 5
end

-- ========================
-- SOUND MANAGER
-- ========================

local Music = {
	current = nil,
	mode = nil,
	nextSwitch = 0,
	endTime = 0,
}

function Music:Debug(msg)
	if GetConVar("impulse_music_debug"):GetBool() then
		print("[Music] " .. msg)
	end
end

function Music:Stop()
	if self.current then
		self.current:Stop()
		self.current = nil
		self.endTime = 0
		--self:Debug("Stopped music")
	end
end

function PLUGIN:DefineSettings()
	impulse.DefineSetting("music_enabled", {
		name = "Music enabled",
		category = "Music",
		type = "tickbox",
		default = true
	})

	impulse.DefineSetting("music_ambientvol", {
		name = "Ambient music volume",
		category = "Music",
		type = "slider",
		default = 20, -- raised so it's not silent
		minValue = 0,
		maxValue = 100
	})

	impulse.DefineSetting("music_combatvol", {
		name = "Combat music volume",
		category = "Music",
		type = "slider",
		default = 25,
		minValue = 0,
		maxValue = 100
	})
end

function Music:IsValid()
	return self.current and self.current:IsPlaying()
end

function Music:GetVolume()
	if self.mode == "combat" then
		return (impulse.GetSetting("music_combatvol", 25) or 25) / 100
	else
		return (impulse.GetSetting("music_ambientvol", 20) or 20) / 100
	end
end

function Music:Play(ply, path, duration)
	self:Stop()

	local snd = CreateSound(ply, path)
	if not snd then
		--self:Debug("Failed to create sound: " .. path)
		return
	end

	local volume = self:GetVolume()

	snd:Play()
	snd:ChangeVolume(volume, 0)

	self.current = snd
	self.endTime = CurTime() + duration

	--self:Debug("Now playing: " .. path .. " (" .. duration .. "s, vol=" .. volume .. ")")
end

function Music:Ensure(ply, mode)
	-- Recover from stopsound
	if self.current and not self.current:IsPlaying() then
		--self:Debug("Sound stopped externally, recovering...")
		self.current = nil
		self.endTime = 0
	end

	-- Mode change
	if self.mode ~= mode then
		--self:Debug("Mode changed to: " .. mode)
		self.mode = mode
		self.current = nil
		self.endTime = 0
	end

	-- Play new track if needed
	if not self.current or CurTime() >= self.endTime then
		local path, duration = GetRandomSong(mode)
		if not path then
			--self:Debug("No music found for mode: " .. mode)
			return
		end

		self:Play(ply, path, duration)
	end
end

-- ========================
-- THINK LOOP
-- ========================

local nextThink = 0

function PLUGIN:Think()
	local lp = LocalPlayer()
	if not IsValid(lp) then return end

	-- Respect setting: music enabled
	if not impulse.GetSetting("music_enabled", true) then
		Music:Stop()
		return
	end

	if not lp:Alive() then
		Music:Stop()
		return
	end

	local ct = CurTime()
	if ct < nextThink then return end
	nextThink = ct + 1

	local mode = InCombat() and "combat" or "passive"

	Music:Ensure(lp, mode)
end