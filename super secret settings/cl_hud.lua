surface.CreateFont("nigfont", {
    font = "Wasted Year",
    size = 999,
	weight = 1000
})

impulse.hudEnabled = impulse.hudEnabled or true

local hidden = {}
hidden["CHudHealth"] = true
hidden["CHudBattery"] = true
hidden["CHudAmmo"] = true
hidden["CHudSecondaryAmmo"] = true
hidden["CHudCrosshair"] = true
hidden["CHudHistoryResource"] = true
hidden["CHudDeathNotice"] = true
hidden["CHudDamageIndicator"] = true

function GM:HUDShouldDraw(element)
	if (hidden[element]) then
		return false
	end

	return true
end

local blur = Material("pp/blurscreen")
local cheapBlur = Color(0,0,0,205)
local function BlurRect(x, y, w, h)
	if not impulse.GetSetting("perf_blur") then
		draw.RoundedBox(0,x,y,w,h, cheapBlur)
		surface.SetDrawColor(0,0,0)
		surface.DrawOutlinedRect(x,y,w,h)
	else
		local X, Y = 0,0

		surface.SetDrawColor(color_white)
		surface.SetMaterial(blur)

		for i = 1, 2 do
			blur:SetFloat("$blur", (i / 10) * 20)
			blur:Recompute()

			render.UpdateScreenEffectTexture()

			render.SetScissorRect(x, y, x+w, y+h, true)
			surface.DrawTexturedRect(X * -1, Y * -1, ScrW(), ScrH())
			render.SetScissorRect(0, 0, 0, 0, false)
		end
	end
end

local vignette = Material("impulse/vignette.png")
local vig_alpha_normal = Color(10,10,10,190)
local lasthealth
local time = 0
local zoneLbl
local gradient = Material("vgui/gradient-l")
local watermark = Material("impulse/impulse-logo-white.png")
local watermarkCol = Color(255,255,255,30)
local fde = 0
local hudBlackGrad = Color(40,40,40,180)
local hudBlack = Color(20,20,20,140)
local darkCol = Color(30, 30, 30, 190)
local whiteCol = Color(255, 255, 255, 255)
local iconsWhiteCol = Color(255, 255, 255, 220)
local bleedFlashCol = Color(230, 0, 0, 220)
local painCol = Color(255,10,10,80)
local crosshairGap = 5
local crosshairLength = crosshairGap + 5
local healthIcon = Material("impulse/icons/heart-128.png")
local healthCol = Color(210, 0, 0, 255)
local armourIcon = Material("impulse/icons/shield-128.png")
local armourCol = Color(205, 190, 0, 255)
local hungerIcon = Material("impulse/icons/bread-128.png")
local hungerCol = Color(205, 133, 63, 255)
local moneyIcon = Material("impulse/icons/banknotes-128.png")
local moneyCol = Color(133, 227, 91, 255)
local timeIcon = Material("impulse/icons/clock-128.png")
local xpIcon = Material("impulse/icons/star-128.png")
local warningIcon = Material("impulse/icons/warning-128.png")
local infoIcon = Material("impulse/icons/info-128.png")
local announcementIcon = Material("impulse/icons/megaphone-128.png")
local exitIcon = Material("impulse/icons/exit-128.png")
local bleedingIcon = Material("impulse/icons/droplet-256.png")
local beta = Material( "logos/hls_betastage_banner.png", "smooth" )
local matIconRadio = Material("mrp/hud/radio_icon.png" , "noclamp smooth")

local lastModel = ""
local lastSkin = ""
local lastTeam = 99
local lastBodygroups = {}
local iconLoaded = false

local painFt
local painFde = 1

local bleedFlash = false
local hotPink = Color(148, 0, 211)

local function DrawOverheadInfo(target, alpha)
	local pos = target:EyePos()

	pos.z = pos.z + 5
	pos = pos:ToScreen()
	pos.y = pos.y - 50

	local myGroup = LocalPlayer():GetSyncVar(SYNC_GROUP_NAME, nil)
	local group = target:GetSyncVar(SYNC_GROUP_NAME, nil)
	local rank = target:GetSyncVar(SYNC_GROUP_RANK, nil)
	local col = ColorAlpha(team.GetColor(target:Team()), alpha)

	if myGroup and not LocalPlayer():IsCP() and not target:IsCP() and group and rank and group == myGroup then
		draw.DrawText(group.." - "..rank, "Impulse-Elements16-Shadow", pos.x, pos.y - 15, ColorAlpha(hotPink, alpha), 1)
	end

	draw.DrawText(target:KnownName(), "Impulse-Elements18-Shadow", pos.x, pos.y, col, 1)
	if target:GetSyncVar(SYNC_TYPING, false) then
		draw.DrawText("Typing...", "Impulse-Elements16-Shadow", pos.x, pos.y + 15, ColorAlpha(color_white, alpha), 1)
	elseif target:GetSyncVar(SYNC_ARRESTED, false) and LocalPlayer():CanArrest(target) then
		draw.DrawText("(F2 to unrestrain | E to drag)", "Impulse-Elements16-Shadow", pos.x, pos.y + 15, ColorAlpha(color_white, alpha), 1)
	end
end

local function DrawDoorInfo(target, alpha)
	local pos = target.LocalToWorld(target, target:OBBCenter()):ToScreen()
	local doorOwners = target:GetSyncVar(SYNC_DOOR_OWNERS, nil) 
	local doorName = target:GetSyncVar(SYNC_DOOR_NAME, nil) 
	local doorGroup =  target:GetSyncVar(SYNC_DOOR_GROUP, nil)
	local doorBuyable = target:GetSyncVar(SYNC_DOOR_BUYABLE, nil)
	local col = ColorAlpha(impulse.Config.MainColour, alpha)

	if doorName then
		draw.DrawText(doorName, "Impulse-Elements18-Shadow", pos.x, pos.y, col, 1)
	elseif doorGroup then
		draw.DrawText(impulse.Config.DoorGroups[doorGroup], "Impulse-Elements18-Shadow", pos.x, pos.y, col, 1)
	elseif doorOwners then
		local ownedBy
		if #doorOwners > 1 then
			ownedBy = "Owners:"
		else
			ownedBy = "Owner:"
		end

		for v,k in pairs(doorOwners) do
			local owner = Entity(k)

			if IsValid(owner) and owner:IsPlayer() then
				ownedBy = ownedBy.."\n"..owner:Name()
			end
		end
		draw.DrawText(ownedBy, "Impulse-Elements18-Shadow", pos.x, pos.y, col, 1)
	end

	if LocalPlayer():CanBuyDoor(doorOwners, doorBuyable) then
		draw.DrawText("", "Impulse-Elements18-Shadow", pos.x, pos.y, col, 1)
	end
end

local function DrawEntInfo(target, alpha)
	local pos = target.LocalToWorld(target, target:OBBCenter()):ToScreen()
	local scrW = ScrW()
	local scrH = ScrH()
	local hudName = target.HUDName
	local hudDesc = target.HUDDesc
	local hudCol = target.HUDColour or impulse.Config.InteractColour

	draw.DrawText(hudName, "Impulse-Elements19-Shadow", pos.x, pos.y, ColorAlpha(hudCol, alpha), 1)

	if hudDesc then
		draw.DrawText(hudDesc, "Impulse-Elements16-Shadow", pos.x, pos.y + 20, ColorAlpha(color_white, alpha), 1)
	end
end

local function DrawButtonInfo(target, alpha)	
	local pos = target.LocalToWorld(target, target:OBBCenter()):ToScreen()
	local scrW = ScrW()
	local scrH = ScrH()
	local buttonId = impulse_ActiveButtons[target:EntIndex()]
	local hudCol = impulse.Config.InteractColour
	local buttonData = impulse.Config.Buttons[buttonId]

	if not buttonData then
		return
	end

	if not buttonData.desc then
		return
	end

	draw.DrawText(buttonData.desc, HIGH_RES("Impulse-Elements18-Shadow", "Impulse-Elements20A-Shadow"), pos.x, pos.y + 20, ColorAlpha(hudCol, alpha), 1)
end

local crosshairMat = Material("mrp/hud/crossair/crosshair.png")

local function DrawCrosshair(x, y)
    surface.SetMaterial(crosshairMat)
    surface.SetDrawColor(255, 255, 255, 255)

    local size = 30.5 -- adjust to your image size

    surface.DrawTexturedRect(
        x - size / 2,
        y - size / 2,
        size,
        size
    )
end

local deathEndingFade
local deathEnding
function GM:HUDPaint()
	local health = LocalPlayer():Health()
	local lp = LocalPlayer()
	local lpTeam = lp:Team()
	local scrW, scrH = ScrW(), ScrH()
	local hudWidth, hudHeight = 300, 178
	local seeColIcons = impulse.GetSetting("hud_iconcolours")
	local aboveHUDUsed = false
	local deathSoundPlayed

	if SERVER_DOWN and CRASHSCREEN_ALLOW then
		if not IsValid(CRASH_SCREEN) then
			CRASH_SCREEN = vgui.Create("impulseCrashScreen")
		end
	elseif IsValid(CRASH_SCREEN) and not CRASH_SCREEN.fadin then
		CRASH_SCREEN.fadin = true
		CRASH_SCREEN:AlphaTo(0, 1.2, nil, function()
			if IsValid(CRASH_SCREEN) then
				CRASH_SCREEN:Remove()
			end
		end)
	end

	if not lp:Alive() and not SCENES_PLAYING then
		local ft = FrameTime()

		if not deathRegistered then
			local deathSound = hook.Run("GetDeathSound") or "ambient/intro/logosfx.wav"
			surface.PlaySound(deathSound)

			deathWait = CurTime() + impulse.Config.RespawnTime
			if lp:IsDonator() then
				deathWait = CurTime() + impulse.Config.RespawnTimeDonator
			end

			deathRegistered = true
			deathEnding = true
		end

		fde = math.Clamp(fde + ft * 2, 0, 1)
		painFde = 0

		surface.SetDrawColor(255, 0, 0, 255)
		surface.DrawRect(-1, -1, ScrW() +2, ScrH() +2)

		local shakeY = math.random(-32, 32)
		local shakeX = math.random(-8, 8)
		local flicker = math.random(254, 255)

		local textCol = Color(255, math.random(0,50), math.random(0,50), flicker)

		draw.SimpleText(
			" ",
			"nigfont",
			scrW / 2 + shakeX,
			scrH / 2.5 + shakeY,
			textCol,
			TEXT_ALIGN_CENTER
		)

		local wait = math.ceil(deathWait - CurTime())

		if IsValid(PlayerIcon) then
			PlayerIcon:Remove()
		end
		
		return
	else
		if FORCE_FADESPAWN or deathEnding then
			deathEnding = true
			FORCE_FADESPAWN = nil 

			local ft = FrameTime()
			deathEndingFade = math.Clamp((deathEndingFade or 0) + ft * .15, 0, 1)

			local val = 255 - math.ceil(deathEndingFade * 255)

			if deathEndingFade != 1 then
				surface.SetDrawColor(0, 0, 0, val)
				surface.DrawRect(0, 0, ScrW(), ScrH())
			else
				deathEnding = false
				deathEndingFade = 0
			end
		end

		fde = 0

		if deathRegistered then
			deathRegistered = false
		end

		LocalPlayer().Ragdoll = nil
	end

	if impulse.hudEnabled == false or (impulse.CinematicIntro and LocalPlayer():Alive()) or (IsValid(impulse.MainMenu) and impulse.MainMenu:IsVisible()) or hook.Run("ShouldDrawHUDBox") == false then
		if IsValid(PlayerIcon) then
			PlayerIcon:Remove()
		end
		return
	end

	local flPlayerHealth = LocalPlayer():Health()

	if flPlayerHealth < 81 then
		-- stronger non-linear intensity (THIS is the key fix)
		local flAlphaPercent = math.Clamp((81 - flPlayerHealth) / 81, 0.5, 1)
		flAlphaPercent = flAlphaPercent ^ 1.6 + 0.1

		local matBlood = Material("overlays/blood_vignette.png")

		surface.SetMaterial(matBlood)
		surface.SetDrawColor(255, 255, 255, math.Clamp(255 * flAlphaPercent, 0, 255))
		surface.DrawTexturedRect(0, 0, ScrW(), ScrH())
	end

	-- MOTION BLUR
	if flPlayerHealth <= 81 then
		local flBlur = math.Clamp(1 - (flPlayerHealth / 50), 0.5, 1)

		-- stronger curve so it ramps harder near low HP
		flBlur = flBlur ^ 1.4

		DrawMotionBlur(0.1, flBlur * 1.0, 0.01)
	end

	-- Draw any HUD stuff under this comment

	if lasthealth and health < lasthealth then
		painFde = 0
	end

	painFt = FrameTime() * 2
	painFde = math.Clamp(painFde + painFt, 0, 0.7)

	surface.SetDrawColor(ColorAlpha(painCol, 255 * (0.7 - painFde)))
	surface.DrawRect(0, 0, scrW, scrH)

	--Crosshair
	local x, y
	local curWep = lp:GetActiveWeapon()

	if not curWep or not curWep.ShouldDrawCrosshair or (curWep.ShouldDrawCrosshair and curWep.ShouldDrawCrosshair(curWep) != false) then
		if impulse.GetSetting("view_thirdperson") == true then
			local p = LocalPlayer():GetEyeTrace().HitPos:ToScreen()
			x, y = p.x, p.y
		else
			x, y = scrW/2, scrH/2
		end

		DrawCrosshair(x, y)
	end

	-- HUD

	local yAdd = 0

	surface.SetTextColor(color_white)
	surface.SetFont("Impulse-Elements19")

	surface.SetDrawColor(color_white)

	if lp:GetSyncVar(SYNC_ARRESTED, false) == true and impulse_JailTimeEnd and impulse_JailTimeEnd > CurTime() then
		local timeLeft = math.ceil(impulse_JailTimeEnd - CurTime())

		surface.SetMaterial(exitIcon)
		surface.DrawTexturedRect(10, y-30, 18, 18)
		draw.DrawText("Sentence remaining: "..string.FormattedTime(timeLeft, "%02i:%02i"), "Impulse-Elements19", 35, y-30, color_white, TEXT_ALIGN_LEFT)
		aboveHUDUsed = true
	end

	local iconsX = 315
	local bleedIconCol

	if lp:GetSyncVar(SYNC_BLEEDING, false) then
		if (nextBleedFlash or 0) < CurTime() then
			bleedFlash = !bleedFlash
			nextBleedFlash = CurTime() + 1
		end

		if bleedFlash then
			bleedIconCol = bleedFlashCol
		else
			bleedIconCol = iconsWhiteCol
		end

		surface.SetDrawColor(bleedIconCol)
		surface.SetMaterial(bleedingIcon)
		surface.DrawTexturedRect(iconsX, y + 10, 30, 30)
	end

	surface.SetDrawColor(color_white)

	if not aboveHUDUsed then
		if impulse.ShowZone then
			if IsValid(zoneLbl) then
				zoneLbl:Remove()	
			end

			zoneLbl = vgui.Create("impulseZoneLabel")
			zoneLbl:SetPos(0, 525)
			zoneLbl.Zone = lp:GetZoneName()

			impulse.ShowZone = false
		end
	elseif zoneLbl and IsValid(zoneLbl) then
		zoneLbl:Remove()
	end

	local isPreview = GetConVar("impulse_ispreview"):GetBool()
	local pings = LocalPlayer():Ping()

	if isPreview then
		local scrW, scrH = ScrW(), ScrH()

		-- BETA WATERMARK
		if beta then
			surface.SetDrawColor(watermarkCol or color_white)
			surface.SetMaterial(beta)
			surface.DrawTexturedRectRotated(scrW - 240, scrH - 50, 256, 128, 0)
		end

		-- RADIO ICON (Only for Cops and OTA)
		local ply = LocalPlayer()

		if (ply:Team() == TEAM_CP or ply:Team() == TEAM_OTA or ply:Team() == TEAM_HAZMAT or ply:Team() == TEAM_WORKER) and matIconRadio then
			surface.SetMaterial(matIconRadio)
			surface.SetDrawColor(255, 255, 255, 255)
			surface.DrawTexturedRect(scrW - 98, scrH - 104, 96, 96)
		end

		-- TEXT (optional, uncomment if needed)
		surface.SetTextPos(1400, 500)
		surface.SetTextColor(watermarkCol or color_white)
		surface.SetFont("Impulse-Elements18-Shadow")
		-- surface.DrawText("PREVIEW BUILD")
	end

	-- dev hud

	if impulse_DevHud and (lp:IsSuperAdmin() or lp:IsDeveloper()) then
		local trace = {}
		trace.start = lp:EyePos()
		trace.endpos = trace.start + lp:GetAimVector() * 3000
		trace.filter = lp

		local traceData = util.TraceLine(trace)
		local traceEnt = traceData.Entity

		if traceEnt and traceEnt != NULL then
			surface.SetTextPos((scrW / 2) + 30, (scrH / 2) - 100)
			surface.DrawText(tostring(traceEnt))

			surface.SetTextPos((scrW / 2) + 30, (scrH / 2) - 80)
			surface.DrawText(traceEnt:GetModel().."     "..traceData.HitTexture or "")

			local syncData = impulse.Sync.Data[traceEnt:EntIndex()]
			local netData
			local y = (scrH / 2) - 40

			if syncData then
				for v,k in pairs(syncData) do
					if type(k) == "table" then
						k = table.ToString(k)
					end

					surface.SetTextPos((scrW / 2) + 30, y)
					surface.DrawText("syncvalue: "..v.." ; "..tostring(k))
					y = y + 20
				end
			end

			if IsValid(traceEnt) and traceEnt.GetNetworkVars then
				netData = traceEnt:GetNetworkVars()
			end

			if netData then
				for v,k in pairs(netData) do
					surface.SetTextPos((scrW / 2) + 30, y)
					surface.DrawText("netvalue: "..v.." ; "..tostring(k))
					y = y + 20
				end
			end
		end

		surface.SetTextPos(400, scrH / 1.5)
		surface.DrawText(tostring(lp:GetPos()))
		surface.SetTextPos(400, (scrH / 1.5) + 20)
		surface.DrawText(tostring(lp:GetAngles()))
		surface.SetTextPos(400, (scrH / 1.5) + 40)
		surface.DrawText(lp:GetVelocity():Length2D())
	end

	lasthealth = health
end

local nextOverheadCheck = 0
local lastEnt
local trace = {}
local approach = math.Approach
local letterboxFde = 0
local textFde = 0
local holdTime
overheadEntCache = {}
-- overhead info is HEAVILY based off nutscript. I'm not taking credit for it. but it saves clients like 70 fps so its worth it
function GM:HUDPaintBackground()

	if impulse.GetSetting("hud_vignette") == true then
		surface.SetMaterial(vignette)
		surface.SetDrawColor(vig_alpha_normal)
		surface.DrawTexturedRect(0, 0, ScrW(), ScrH())
	end

	if impulse.hudEnabled == false then
		return
	end

	local lp = LocalPlayer()
	local realTime = RealTime()
	local frameTime = FrameTime()

	if nextOverheadCheck < realTime then
		nextOverheadCheck = realTime + 0.5
		
		trace.start = lp.GetShootPos(lp)
		trace.endpos = trace.start + lp.GetAimVector(lp) * 300
		trace.filter = lp
		trace.mins = Vector(-4, -4, -4)
		trace.maxs = Vector(4, 4, 4)
		trace.mask = MASK_SHOT_HULL

		lastEnt = util.TraceHull(trace).Entity

		if IsValid(lastEnt) then
			overheadEntCache[lastEnt] = true
		end
	end

	for entTarg, shouldDraw in pairs(overheadEntCache) do
		if IsValid(entTarg) then
			local goal = shouldDraw and 255 or 0
			local alpha = approach(entTarg.overheadAlpha or 0, goal, frameTime * 1000)

			if lastEnt != entTarg then
				overheadEntCache[entTarg] = false
			end

			if alpha > 0 then
				if not entTarg:GetNoDraw() then
					if entTarg:IsPlayer() then
						DrawOverheadInfo(entTarg, alpha)
					elseif entTarg.HUDName then
						DrawEntInfo(entTarg, alpha)
					elseif entTarg:IsDoor() then
						DrawDoorInfo(entTarg, alpha)
					elseif impulse_ActiveButtons[entTarg.EntIndex(entTarg)] then
						DrawButtonInfo(entTarg, alpha)
					end
				end
			end

			entTarg.overheadAlpha = alpha

			if alpha == 0 and goal == 0 then
				overheadEntCache[entTarg] = nil
			end
		else
			overheadEntCache[entTarg] = nil
		end
	end
	
	if impulse.CinematicIntro and lp:Alive() then
		local ft = FrameTime()
		local maxTall =  ScrH() * .12

		if holdTime and holdTime + 6 < CurTime() then
			letterboxFde = math.Clamp(letterboxFde - ft * .5, 0, 1)
			textFde = math.Clamp(textFde - ft * .3, 0, 1)

			if letterboxFde == 0 then
				impulse.CinematicIntro = false
			end
		elseif holdTime and holdTime + 4 < CurTime() then
			textFde = math.Clamp(textFde - ft * .3, 0, 1)
		else
			letterboxFde = math.Clamp(letterboxFde + ft * .5, 0, 1)

			if letterboxFde == 1 then
				textFde = math.Clamp(textFde + ft * .1, 0, 1)
				holdTime = holdTime or CurTime()
			end
		end

		surface.SetDrawColor(color_black)
		surface.DrawRect(0, 0, ScrW(), (maxTall * letterboxFde))
		surface.DrawRect(0, (ScrH() - (maxTall * letterboxFde)) + 1, ScrW(), maxTall)

		draw.DrawText(impulse.CinematicTitle, "Impulse-Elements36", ScrW() - 150, ScrH() * .905, ColorAlpha(color_white, (255 * textFde)), TEXT_ALIGN_RIGHT)
	else
		letterboxFde = 0
		textFde = 0
		holdTime = nil
	end
end

-- Define the color modification table
local tColorModify = {
    [ "$pp_colour_brightness" ] = 0,
    [ "$pp_colour_contrast" ] = 1,
    [ "$pp_colour_colour" ] = 1,
    [ "$pp_colour_addr" ] = 0,
    [ "$pp_colour_addg" ] = 0,
    [ "$pp_colour_addb" ] = 0,
    [ "$pp_colour_mulr" ] = 0,
    [ "$pp_colour_mulg" ] = 0,
    [ "$pp_colour_mulb" ] = 0
}

-- Apply custom values
tColorModify[ "$pp_colour_colour" ] = 0.50  -- Adjust the color saturation
tColorModify[ "$pp_colour_contrast" ] = 1  -- Red multiplier set to 0
tColorModify[ "$pp_colour_mulg" ] = 0.0  -- Green multiplier set to 0

-- Hook into the PostDrawTranslucentRenderables to apply the effect
hook.Add( "RenderScreenspaceEffects", "ApplyCustomColorModify", function()
    -- Apply the color modification
    DrawColorModify(tColorModify)
end )

concommand.Add("impulse_cameratoggle", function()
	impulse.hudEnabled = (!impulse.hudEnabled)

	if not IsValid(impulse.chatBox.frame) then
		return
	end

	if impulse.hudEnabled then
		impulse.chatBox.frame:Show()
	else
		impulse.chatBox.frame:Hide()
	end
end)