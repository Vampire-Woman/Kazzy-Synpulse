local function GetCombineSchedule()
    local hour = tonumber(os.date("%H"))
    local min = tonumber(os.date("%M"))
    local time = hour * 60 + min -- minutes since midnight

    if time >= 0 and time < 180 then
        return "Curfew Procedure", Color(255, 76, 53)

    elseif time < 245 then
        return "Inactive", Color(0, 214, 248)

    elseif time < 355 then
        return "Inactive", Color(0, 214, 248)

    elseif time < 360 then
        return "Inactive", Color(0, 214, 248)

    elseif time < 420 then
        return "Ration Cycle", Color(0, 214, 248)

    elseif time < 425 then
        return "Inactive", Color(0, 214, 248)

    elseif time < 715 then
        return "Workforce Intake", Color(48, 255, 228)

    elseif time < 785 then
        return "Inactive", Color(0, 214, 248)

    elseif time < 1075 then
        return "Inactive", Color(0, 214, 248)

    elseif time < 1080 then
        return "Inactive", Color(0, 214, 248)

    elseif time < 1140 then
        return "Ration Cycle", Color(255, 214, 48)

    elseif time < 1145 then
        return "Inactive", Color(0, 214, 248)

    elseif time < 1425 then
        return "Inactive", Color(0, 214, 248)

    else
        return "Inactive", Color(0, 214, 248)
    end
end

local surface = surface
local draw = draw
local CurTime = CurTime
local LocalPlayer = LocalPlayer
local math = math
local player = player
local pairs = pairs
local ScrW = ScrW
local ScrH = ScrH

local overlayCol = Color(255, 255, 255, 1)
local messagesCol = Color(0, 0, 0, 0)
local bootCol = Color(0, 0, 0, 130)
local red = Color(255, 0, 0)
local nextFlicker
local nextCheck

local CMB_OVERLAY_COLS = {
    Color(0, 0, 255), -- universal
    Color(75, 155, 45), -- squad
    Color(255, 150, 0), -- command
    Color(210, 55, 50), -- danger
    Color(150, 150, 150) -- respond
}

local CMB_OVERLAY_ICONS = {
    Material("impulse/hl2rp/overlay/move"), -- move
    Material("impulse/hl2rp/overlay/alert"), -- alert
    Material("impulse/hl2rp/overlay/flatline"), -- death
    Material("impulse/hl2rp/overlay/blockinspect"), -- block insp.
    Material("impulse/hl2rp/overlay/move_sq"), -- move squad
    Material("impulse/hl2rp/overlay/combine"), -- UU
    Material("impulse/hl2rp/overlay/cctv") -- camera
}

surface.CreateFont("impulseHL2RPOverlayBig", {
    font = "OCR A Extended",
    size = 17,
    weight = 800,
    outline = true
})

surface.CreateFont("bigfont", {
    font = "OCR A Extended",
    size = 17,
    weight = 800,
    outline = true
})

surface.CreateFont("amychoice", {
	font = "Consolas",
    size = 15,
    weight = 800,
    outline = true
})

surface.CreateFont("msgfont", {
    font = "Combine_Alphabet1",
    weight = 14,
    size = 14,
    outline = true,
	bold = false
})

surface.CreateFont("msgfont_numbers", {
    font = "Consolas",
    size = 16,
    outline = true
})

surface.CreateFont("compassfont", {
    font = "OCR A Extended",
    size = 20,
    weight = 600,
    outline = true
})

surface.CreateFont("compassnum", {
    font = "OCR A Extended",
    size = 24,
    weight = 800,
    outline = true
})

surface.CreateFont("notgayfont", {
    font = "Roboto",
    size = 16,
    weight = 0,
    outline = true,
    antialias = false,	
})

surface.CreateFont("impulseHL2RPScannerFont", {
    font = "Lucida Sans Typewriter",
    antialias = false,
    outline = true,
    weight = 800,
    size = 18
})

impulse.CombineMessages = impulse.CombineMessages or {}
impulse.CombineWaypoints = impulse.CombineWaypoints or {}
impulse.CombineMessageID = impulse.CombineMessageID or 0

local function DrawCombineWaypoints()
    for i = 1, #impulse.CombineWaypoints do
        local waypointData = impulse.CombineWaypoints[i]
        if not waypointData then continue end
        local pos = waypointData.pos:ToScreen()

        if not waypointData.nextUpdate or waypointData.nextUpdate < CurTime() then
            local plyPos = LocalPlayer():GetPos()

            waypointData.dist = (waypointData.pos:Distance(plyPos) / 39.3701) -- 39 inches in meter
            waypointData.nextUpdate = CurTime() + 0.5
        end

        surface.SetMaterial(waypointData.mat)
        surface.SetDrawColor(color_red)
        surface.DrawTexturedRect(pos.x - 16, pos.y, 32, 32)

        draw.SimpleText("<:: "..waypointData.text.." ::>", "notgayfont", pos.x, pos.y + 29, color_red or color_white, TEXT_ALIGN_CENTER)

        if waypointData.name then
            local prefix = waypointData.prefix or "UNIT"
            local text = waypointData.name

            draw.SimpleText("<:: "..prefix..": "..text.." ::>", "notgayfont", pos.x, pos.y + 42, color_white, TEXT_ALIGN_CENTER)
            draw.SimpleText("<:: DIST: "..math.Round(waypointData.dist).."m ::>", "notgayfont", pos.x, pos.y + 54, color_white, TEXT_ALIGN_CENTER)
        else
            draw.SimpleText("<:: DIST: "..math.Round(waypointData.dist).."m ::>", "notgayfont", pos.x, pos.y + 42, color_white, TEXT_ALIGN_CENTER)
        end

        if waypointData.endtime and waypointData.endtime < CurTime() then
            impulse.CombineWaypoints[i] = nil
            LocalPlayer():EmitSound("buttons/button17.wav", 35, 60)
        end 
    end
end

local scannerColorModify = {
    ["$pp_colour_addr"] = 0,
    ["$pp_colour_addg"] = 0,
    ["$pp_colour_addb"] = 0,
    ["$pp_colour_brightness"] = 0,
    ["$pp_colour_contrast"] = 1,
    ["$pp_colour_colour"] = 0,
    ["$pp_colour_mulr"] = 0,
    ["$pp_colour_mulg"] = 0,
    ["$pp_colour_mulb"] = 0
}

local lineYPos = 75
local lastTargetTime = 0
local lastTarget
local scanPercentage = 0
local lineWide = 5
local lineCol =  Color(190, 190, 190, 180)
local faceShadeCol =  Color(40, 40, 40, 60)
local redColor = 0
local loopDirection = true

local function DrawScannerPlayerBox(target, scanner, percentage)
    local head = target:LookupBone("ValveBiped.Bip01_Head1")

    if not head then
        return
    end

    local ang = LocalPlayer():GetAngles()
    local bottomPos = target:GetBonePosition(head) - (ang:Up() * 4)
    local xGap = ang:Right() * 7.5
    local topPos = bottomPos + (ang:Up() * 15)
    local bottomL = bottomPos - xGap
    local bottomR = bottomPos + xGap
    local topL = topPos - xGap
    local topR = topPos + xGap

    local tl = topL:ToScreen()
    local br = bottomR:ToScreen()
    
    local w = br.x - tl.x
    local h = br.y - tl.y
    
    surface.SetDrawColor(faceShadeCol)
    surface.DrawRect(tl.x, tl.y, w, h)

    surface.SetDrawColor(lineCol)
    surface.DrawOutlinedRect(tl.x, tl.y, w, h)

    surface.SetTextColor(Color(255, 255, 255, 255))
    surface.SetFont("bigfont")
    surface.SetTextPos(tl.x + 2, tl.y + 2)
    if scanner:GetIsScanning() and target == scanner:GetScanTarget() then
        surface.DrawText(percentage .. "%")
    else
        surface.DrawText("IDLE...")
    end
end

local function DrawScannerHUD() 
    local scanner = LocalPlayer():GetScannerFromPlayer()
    local target = scanner:GetCurrentTarget()

    DrawColorModify(scannerColorModify)

    -- nutscript style scanner hud
    local boxWide, boxHeight = 580, 420
    local boxWide2, boxHeight2 = boxWide * 0.5, boxHeight * 0.5
    local scrW, scrH = ScrW() * 0.5, ScrH() * 0.5
    local x, y = scrW - boxWide2, scrH - boxHeight2
    local pos = scanner:GetPos()
    local ang = LocalPlayer():GetAimVector():Angle()

    draw.SimpleText("POS ("..math.floor(pos[1])..", "..math.floor(pos[2])..", "..math.floor(pos[3])..")", "impulseHL2RPScannerFont", x + 8, y + 8, color_white)
    draw.SimpleText("ANG ("..math.floor(ang[1])..", "..math.floor(ang[2])..", "..math.floor(ang[3])..")", "impulseHL2RPScannerFont", x + 8, y + 24, color_white)
    draw.SimpleText("IAS ("..math.Round(scanner:GetVelocity():Length2D())..")", "impulseHL2RPScannerFont", x + 8, y + 40, color_white)
    draw.SimpleText("ID  ("..LocalPlayer():Name()..")", "impulseHL2RPScannerFont", x + 8, y + 56, color_white)
    draw.SimpleText("ZM  ("..math.Round(SCANNER_ZOOM)..")", "impulseHL2RPScannerFont", x + 8, y + 72, color_white)

    surface.SetDrawColor(235, 235, 235, 230)

    surface.DrawLine(x, y, x + 128, y)
    surface.DrawLine(x, y, x, y + 128)

    x = scrW + boxWide2

    surface.DrawLine(x, y, x - 128, y)
    surface.DrawLine(x, y, x, y + 128)

    x = scrW - boxWide2
    y = scrH + boxHeight2

    surface.DrawLine(x, y, x + 128, y)
    surface.DrawLine(x, y, x, y - 128)

    x = scrW + boxWide2

    surface.DrawLine(x, y, x - 128, y)
    surface.DrawLine(x, y, x, y - 128)
end

local squadCol = Color(75, 155, 45, 255)
local grey = Color(60, 60, 60, 255)

local function DrawCombineSquad()
    local scrH = ScrH()
    local w, h = 330, 178
    local yadd = 0
    local lp = LocalPlayer()

    surface.SetTextColor(squadCol)
    surface.SetFont("bigfont")

    surface.SetTextPos(w, scrH - 196)

    local squadId = lp:GetSyncVar(SYNC_SQUAD_ID, 0)
    local squadComp = {}
    local i = 2

    for v,k in pairs(team.GetPlayers(lp:Team())) do
        if k:GetSyncVar(SYNC_SQUAD_ID, -1) == squadId then
            if k:GetSyncVar(SYNC_SQUAD_LEADER, false) then
                squadComp[1] = k
            else
                squadComp[i] = k
                i = i + 1
            end
        end
    end

    local squadName = "SQUAD"
    if lp:Team() == TEAM_CP then
        squadName = "PT"
    end
    surface.DrawText(squadName.." "..squadId..":")

    for i=1,#squadComp do
        local k = squadComp[i]

        if not IsValid(k) then
            if i == 1 then
                surface.SetTextPos(w, scrH - h + yadd)
                surface.DrawText("⏺ NO LEADER (F6)")
                yadd = yadd + 18
            end
            continue
        end

        surface.SetTextPos(w, scrH - h + yadd)

        local hp = k:Health()
        if not k:Alive() then
            surface.SetTextColor(grey)
            hp = 0
        elseif hp < 26 then
            surface.SetTextColor(CMB_OVERLAY_COLS[4])
        else
            surface.SetTextColor(squadCol)
        end

        surface.DrawText("⏺ "..k:Nick().." ["..hp.."]")
        yadd = yadd + 18
    end

    return squadComp
end

-- Compass configuration
local COMPASS_X = 0.5
local COMPASS_Y = 0
local COMPASS_WIDTH = 0.5
local COMPASS_HEIGHT = 0.03
local LINE_SPACE = 1.8
local COMPASS_COLOR = Color(35, 214, 248)

-- Default compass directions
local direction = {
    [ 0 ] = "N",
    [ 45 ] = "NE",
    [ 90 ] = "E",
    [ 135 ] = "SE",
    [ 180 ] = "S",
    [ 225 ] = "SW",
    [ 270 ] = "W",
    [ 315 ] = "NW",
    [ 360 ] = "N"
}

-- Ensure compass heading strings table exists
local COMPASS_HEADING_STRINGS = COMPASS_HEADING_STRINGS or {}
for k,v in pairs(direction or {}) do
    COMPASS_HEADING_STRINGS[k] = v
end

-- Store lerped angle outside function
local playerAngles = Angle(0,0,0)

-- Draw a line with stencil masks for fade effect
local function Compass_DrawLine(mask1, mask2, line, color)
    render.ClearStencil()
    render.SetStencilEnable(true)
        render.SetStencilFailOperation(STENCILOPERATION_KEEP)
        render.SetStencilZFailOperation(STENCILOPERATION_KEEP)
        render.SetStencilPassOperation(STENCILOPERATION_REPLACE)
        render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_ALWAYS)

        render.SetStencilWriteMask(1)
        render.SetStencilReferenceValue(1)

        surface.SetDrawColor(0, 0, 0, 1)
        surface.DrawRect(mask1[1], mask1[2], mask1[3], mask1[4])
        surface.DrawRect(mask2[1], mask2[2], mask2[3], mask2[4])

        render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_EQUAL)
        render.SetStencilTestMask(1)

        surface.SetDrawColor(color)
        surface.DrawLine(line[1], line[2], line[3], line[4])
    render.SetStencilEnable(false)
end

-- Draw the Combine-style compass
local function DrawCombineCompass()
    local player = LocalPlayer()
    if not IsValid(player) then return end

    local frameAng = player:EyeAngles()
    playerAngles = LerpAngle(5 * RealFrameTime(), playerAngles, frameAng)
    local aAng = playerAngles

    local nWidth = ScrW() * COMPASS_WIDTH
    local nHeight = ScrH() * COMPASS_HEIGHT
    local nCompassX = ScrW() * COMPASS_X + -2
    local nCompassY = ScrH() * COMPASS_Y + 110
    local nSpacing = (nWidth * LINE_SPACE) / 360
    local nNumOfLines = nWidth / nSpacing
    local nFadeDist = 0.5

    for i = math.floor(-aAng.y) % 360, (math.floor(-aAng.y) % 360) + nNumOfLines do
        local compassBearingW, compassBearingH = 0, 0
        local x = (nCompassX - (nWidth / 2)) + (((i + aAng.y) % 360) * nSpacing)
        local value = math.abs(x - nCompassX)
        local calc = 1 - ((value + (value - nFadeDist)) / (nWidth / 2))
        local calculation = 255 * math.Clamp(calc, 0.001, 1)
        local i_offset = (math.floor(i - (nNumOfLines / 2))) % 360

        -- Big headings
        if i_offset % 15 == 0 then
            local text = (COMPASS_HEADING_STRINGS and COMPASS_HEADING_STRINGS[i_offset]) or tostring(i_offset)
            local font = (COMPASS_HEADING_STRINGS and COMPASS_HEADING_STRINGS[i_offset]) and "compassnum" or "compassfont"

            surface.SetFont(font)
            local w, h = surface.GetTextSize(text)
            compassBearingW, compassBearingH = w or 0, h or 0

            local cColor = Color(COMPASS_COLOR.r, COMPASS_COLOR.g, COMPASS_COLOR.b, calculation)
            surface.SetDrawColor(cColor)
            surface.SetTextColor(cColor)

            local mask1 = {nCompassX - nWidth/2 - nFadeDist, nCompassY, nWidth/2 + nFadeDist - compassBearingW, nHeight * 2}
            local mask2 = {nCompassX + compassBearingW, nCompassY, nWidth/2 + nFadeDist - compassBearingW, nHeight * 2}
            local line = {x, nCompassY, x, nCompassY + nHeight * 0.5}

            Compass_DrawLine(mask1, mask2, line, cColor)

            surface.SetTextPos(x - w / 2, nCompassY + nHeight * 0.55)
            surface.DrawText(text)
        end

        -- Small tick marks
        if i_offset % 5 == 0 and i_offset % 15 ~= 0 then
            local mask1 = {nCompassX - nWidth/2 - nFadeDist, nCompassY, nWidth/2 + nFadeDist, nHeight * 0.25}
            local mask2 = {nCompassX, nCompassY, nWidth/2 + nFadeDist, nHeight * 0.25}
            local cColor = Color(COMPASS_COLOR.r, COMPASS_COLOR.g, COMPASS_COLOR.b, calculation)
            local line = {x, nCompassY, x, nCompassY + nHeight * 0.25}
            Compass_DrawLine(mask1, mask2, line, cColor)
        end
    end
end

local function DrawLowAmmo(offset)
    draw.SimpleText("ERROR: NO AMMO DETECTED", "bigfont", ScrW() * 0.52, ScrH() * 0.45 + offset, CMB_OVERLAY_COLS[4])
end

local modeNames = {
    [0] = "Grounded",
    [1] = "Grounded",
    [2] = "Pacify",
    [3] = "Active"
}

local function DrawBatonStatus(baton, offset)
    local mode = baton:GetMode() or 1
    --draw.SimpleText("BATON STATUS:\n"..modeNames[mode], "bigfont", ScrW() * 0.52, ScrH() * 0.45 + offset, CMB_OVERLAY_COLS[1])
end

local bootCmds = {
    "./sh/boot/epstein64.iso",
    "./sh/boot/esptein32.iso",
    "./sh/boot/epstein16.iso",
    "./sh/boot/island-gate.txt",
    "...1",
    "...2",
    "...3",
    "...4",
    "...5",
    "...6",
    "done",
    "syntax error! /flight/log.ep: (line 470): 'epstein' was not capitalized!",
    "loading vin's CP folder...",
	"6 TB (Terabytes) detected...",
	"Password required.",
	"login: the_vingard",
    "done!",
    "establishing connection to little st james interface...",
    "trying VPN 1",
    "trying VPN 2",
    "trying VPN 3",
    "trying VPN 4",
    "trying VPN 5",
    "trying VPN 6",
	"trying VPN 7",
    "connection established (island latency): Code 54 — epstein authorisation request",
    "GIRL-001-CONNECTED",
    "GIRL-002-CONNECTED",
    "GIRL-003-CONNECTED",
    "ISLE-001-CONNECTED",
    "ISLE-002-CONNECTED",
    "ISLE-003-CONNECTED",
    "ISLE-004-FAILED (victim silenced)",
    "connecting to hidden hardware...",
    "voice modulator - CONNECTED (whispers 'you're so mature')",
    "encrypted sat-phone - CONNECTED (burner to recruiters)",
    "arousal monitor - CONNECTED (spikes at 13-15)",
    "visual receptor - CONNECTED (zoomed on uniforms)",
    "internal biolink - CONNECTED (dopamine at 'young')",
    "firearm RFID interface - CONNECTED (intimidation loaded)",
    "./sh/os32.z",
    "./sh/js-compact-lies.js",
    "...",
    "....",
    ".....",
    "......",
    "completed epstein island boot sequence! (last serviceID: EPSTEIN-872194)"
}

local command = 0
local nextCommand
local bootDone = 0
local startTime

local function DrawBootSequence()
    if bootDone and bootDone < CurTime() then
        startTime = nil
        return true
    end

    local blue = (LocalPlayer():Team() == TEAM_OTA and team.GetColor(TEAM_OTA)) or CMB_OVERLAY_COLS[1]
    local x, y = ScrW() * .4, ScrH() * .25
    startTime = startTime or CurTime()

    surface.SetDrawColor(blue)
    surface.SetMaterial(CMB_OVERLAY_ICONS[6])
    surface.DrawTexturedRect(x, y, 128, 128)

    if startTime + 0.2 < CurTime() then
        draw.SimpleText("<:: CENTRAL DISPATCH INTERFACE", "impulseHL2RPOverlayBig", x + 140, y + 20, blue)
    end
    
    if startTime + 0.5 < CurTime() then
        draw.SimpleText("Booting...                          "..bit.tohex(bit.tobit(math.random(-10000000,10000000))), "bigfont", x + 140, y + 40, blue)
    end

    if startTime + 1.5 < CurTime() then
        if not bootDone and (not nextCommand or nextCommand < CurTime()) then
            command = command + 1

            chat.PlaySound()

            if not bootCmds[command] then
                bootDone = CurTime() + 1.1
                surface.PlaySound("impulse_citadel/combine_terminals/combine_machines_select.wav")
                surface.PlaySound("impulse_citadel/combine_terminals/login.wav")
            end

            local wait = 0.05

            if command == 13 then
                wait = wait + 5
            end
			
            if command == 14 then
                wait = wait + 4
            end

            if command == 15 then
                wait = wait + 1
            end		

            if command == 16 then
                wait = wait + 0.5
            end						

            nextCommand = CurTime() + wait
        end

        for i = 1, command do
            local cmd = bootCmds[i]

            if cmd then
                draw.SimpleText(cmd, "bigfont", x + 140, (y + 55) + (15 * i))     
            end
        end
    end
end

------------------------------------------------------------

-- THE 

-- BEAST

-- BELOW 

------------------------------------------------------------

local medCol = Color(255, 228, 0)
local armCol = Color(255, 0, 0)
local nextArmFlash = 0

local message = "Vin's Pedophile Island"
local loadingStates = {}

-- Type the message from empty to full
for i = 0, #message do
    table.insert(loadingStates, message:sub(1, i))
end

local holdTime = 30
local frameRate = 0.2
local holdFrames = holdTime / frameRate

for i = 1, holdFrames do
    table.insert(loadingStates, message)
end

for i = 1, #message do
    table.insert(loadingStates, message:sub(i + 1))
end

for _, state in ipairs(loadingStates) do
    --print("[" .. state .. "]")
    -- simulate frame delay
    -- os.execute("sleep " .. frameRate)  -- uncomment if running in an environment that supports os.execute
end

local loadingIndex = 1
local nextLoadingUpdate = 0

local function DrawAuxData(offset)
    local lp = LocalPlayer()
    local scrW = ScrW()
    local pos = lp:GetPos()
    local zone = loadingStates[math.floor(CurTime() * 5) % #loadingStates + 1]
    local grid = math.Round(pos.x / 100).." "..math.Round(pos.y / 100).." "..math.Round(pos.z / 100)
    
    -- Retrieve the city code
    local cityCode = impulse.Dispatch.GetCityCode()
    
    -- Debug: Check the raw value of cityCode
    --print("[SERVER DEBUG] cityCode retrieved:", cityCode)

    -- Map city codes to corresponding keys in socioStatus.list
    local cityCodeMapping = {
        [1] = "cc",   -- City code 1 maps to "cc"
        [2] = "cu",   -- City code 2 maps to "cu"
        [3] = "jw",   -- City code 3 maps to "jw"
    }

    -- Get the corresponding key for the city code
    local cityCodeKey = cityCodeMapping[cityCode]

    -- Debug: Print the city code key we're using
    --print("[SERVER DEBUG] Mapped cityCode to key:", cityCodeKey)

    -- Fetch codeData from the list using the mapped city code key
    local codeData = impulse.ci.socioStatus.list[cityCodeKey]

    -- If no data is found, use a fallback
    if not codeData then
        --print("[SERVER DEBUG] No codeData found for cityCode:", cityCodeKey)
        codeData = { name = "Sociostable", color = Color(48, 255, 228) }  -- Fallback values
    end

    -- Debug: Check if codeData is correctly fetched
    --print("[SERVER DEBUG] codeData name:", codeData.name)

    -- Retrieve socioCode from socioStatus (no need to call Get() twice)
    local socioCode = impulse.ci.socioStatus.Get()
    local socioCodeData = socioCode and socioCode.name or "N/A"  -- Fallback to "N/A" if no socioCode is found
    
    -- Get player stats
    local hp = lp:Health()
    local armour = lp:Armor()
    local nick = lp:Nick()
    
    -- Get the combine schedule (if available)
    local scheduleText, scheduleColor = GetCombineSchedule()
    
    local blue = Color(35, 214, 248)
	local cyan = Color(48, 255, 228)

    local add = 0
    local sps = false
	local zone = lp:GetZoneName()
	local zones = bit.tohex(bit.tobit(math.random(-999999999999999, 999)))
	local thing = bit.tohex(bit.tobit(math.random(-999999999999999, 999)))
	local nigga = zone
	local pad = string.sub(thing, 6) -- Remove the '0x' prefix

	-- Apply fallback if zone is missing/empty
	if not nigga or tostring(nigga):match("^%s*$") then
		nigga = tostring(zones) .. tostring(pad)
	end
	
	if not cpt then  -- Check if cpt is already set
		cpt = math.random(1, 9)  -- Generate the random number once
	end
	
	local teamn = "Technician"

	if lp:Team() == TEAM_OTA then
		teamn = "Stabilization"
	elseif lp:Team() == TEAM_CP then
		teamn = "Protection"
	elseif lp:Team() == TEAM_HAZMAT then
		teamn = "Decontamination"		
	end
	
    local rightEdge = ScrW() - 48
	local faggotEdge = ScrW() - 1092 -- CHANGE THIS FOR LOW RESOLUTIONS ONLY
    local faggot = ScrW() - 720
	local fucksake = ScrW() - 1582
	local hazmats = ScrW() - 1570
	local wolf = ScrW() - 1652
	local fuckyou = ScrW() - 1096

    local baseY = 118 + offset
    local line = 21

    -- Update the override display using codeData.name
    if codeData then
        -- Display the city code override
        draw.SimpleText(codeData.name .. " :: OVERRIDE", "bigfont", rightEdge, baseY + (line * 2), codeData.color, TEXT_ALIGN_RIGHT)
    end
	
	local time = os.date("%I:%M %p"):gsub("^0", "")

	-- Draw the rest of the information
	draw.SimpleText(scheduleText .. " (" .. time .. ") " .. ":: SCHEDULE", "bigfont", rightEdge, baseY, scheduleColor, TEXT_ALIGN_RIGHT)
    draw.SimpleText(nigga .. " :: LOCATION", "bigfont", rightEdge, baseY + line, blue, TEXT_ALIGN_RIGHT)

	--draw.SimpleText("BIOSIGNAL GRID: "..grid.." ::>", "bigfont", rightEdge, baseY + (line * 3), blue, TEXT_ALIGN_RIGHT)
	--draw.SimpleText("LOCAL UNIT HEALTH: "..hp.."% ::>", "bigfont", rightEdge, baseY + (line * 4), blue, TEXT_ALIGN_RIGHT)
	if lp:Team() == TEAM_OTA then
		draw.SimpleText("TEAM :: ".. teamn .." Team " .. cpt .. " 																																					", "bigfont", fucksake, 127 + (line * 5), cyan, TEXT_ALIGN_RIGHT)
	elseif lp:Team() == TEAM_HAZMAT then
		draw.SimpleText("TEAM :: ".. teamn .." Team " .. cpt .. "", "bigfont", hazmats, 127 + (line * 5), cyan, TEXT_ALIGN_RIGHT)	
	else
		draw.SimpleText("TEAM :: ".. teamn .." Team " .. cpt .. " 																																					", "bigfont", faggotEdge, 127 + (line * 5), cyan, TEXT_ALIGN_RIGHT)
	end
	
	if lp:Team() == TEAM_CP then
		draw.SimpleText("UNIT :: " .. nick .. " (L) 			 																																	", "bigfont", fuckyou, 127 + 123, cyan, TEXT_ALIGN_RIGHT)
	elseif lp:Team() == TEAM_OTA then	
		draw.SimpleText("UNIT :: " .. nick .. " (L)  ", "bigfont", wolf, 127 + 123, cyan, TEXT_ALIGN_RIGHT)
	else
		draw.SimpleText("UNIT :: " .. nick .. " (L) 																																					      ", "bigfont", faggotEdge, 127 + 123, cyan, TEXT_ALIGN_RIGHT)
	end
	
	--draw.SimpleText("UNIT DESIGNATION: "..lastFour.." ::>", "bigfont", rightEdge, baseY + (line * 6), blue, TEXT_ALIGN_RIGHT)
	--draw.SimpleText("ACTIVE WEAPON: "..weaponName.." ::>", "bigfont", rightEdge, baseY + (line * 7), blue, TEXT_ALIGN_RIGHT)

    if lp:Team() == TEAM_OTA then
        sps = true
        --draw.SimpleText("BODYPACK INTEGRITY: "..armour.."% ::>", "bigfont", rightEdge, 122 + offset, blue, TEXT_ALIGN_RIGHT)
        add = add + 14
    end

    add = add + 5
    if hp <= 70 then
	if lp:Team() == TEAM_WORKER then return end
        add = add + 14
        draw.SimpleText("WARNING: LOCAL UNIT REQUIRES MEDICAL ATTENTION!", "bigfont", faggot, 94 + add + offset, medCol, TEXT_ALIGN_RIGHT)
    end

    if sps and armour <= 40 then
        if armour <= 5 and CurTime() > nextArmFlash + 1 then
            nextArmFlash = CurTime() + 1
        end
        add = add + 14

        if CurTime() > nextArmFlash then
            draw.SimpleText("WARNING: LOCAL UNIT REQUIRES BODYPACK RECHARGE!", "bigfont", faggot, 95 + add + offset, armCol, TEXT_ALIGN_RIGHT)
        end
    end
end

local function DrawCombineMessages(offset)
    local x, y

    for i = 1, #impulse.CombineMessages do
        local msgData = impulse.CombineMessages[i]
        local message = msgData.message or ""

        x, y = 35 + offset, (i - 1.2) * 21 + 120

        -------------------------------------------------
        -- Calculate width using mixed fonts
        -------------------------------------------------
		
        local totalWidth = 0
        local maxHeight = 0

        for c = 1, #message do
            local char = message:sub(c, c)
            local fontToUse = char:match("%d") and "msgfont_numbers" or "msgfont"

            surface.SetFont(fontToUse)
            local w, h = surface.GetTextSize(char)

            totalWidth = totalWidth + w
            maxHeight = math.max(maxHeight, h)
        end

        -------------------------------------------------
        -- Background
        -------------------------------------------------
		
        surface.SetDrawColor(messagesCol)
        surface.DrawRect(x, y + 6, totalWidth + 12, maxHeight)

        -------------------------------------------------
        -- Colour Logic
        -------------------------------------------------
		
        local textCol = color_white
        local upperMsg = string.upper(message)

		local trimmedMsg = string.TrimLeft(upperMsg) -- remove leading spaces

		if string.StartWith(trimmedMsg, "DOWN") then
			textCol = Color(255, 76, 53, 255)
		elseif string.StartWith(trimmedMsg, "AU") then
			textCol = Color(0, 255, 0) -- Green if it starts with Automatic
		elseif string.StartWith(trimmedMsg, "") then
			textCol = Color(35, 214, 248) -- Blue for anything else that had spaces
		else
			textCol = Color(0, 255, 0) -- Default green
		end
		
        -------------------------------------------------
        -- Draw text seamlessly (with vertical fix)
        -------------------------------------------------
		
        local drawX = x + 6
        local baseY = y + 6

        for c = 1, #message do
            local char = message:sub(c, c)
            local isNumber = char:match("%d")
            local fontToUse = isNumber and "msgfont_numbers" or "msgfont"

            surface.SetFont(fontToUse)
            local w, h = surface.GetTextSize(char)

            -- Raise numbers slightly so they align properly
            local yOffset = isNumber and 0 or 0  -- adjust -2 if needed

            draw.SimpleText(char, fontToUse, drawX, baseY + yOffset, textCol, 0, 0)
            drawX = drawX + w
        end
    end

    return y
end

local function DrawCombineCameraOverlay()
    if not IsValid(WATCHING_CAM) then
        return
    end

    local x = ScrW() * 0.3
    local y = ScrH() * 0.3
    local ang = WATCHING_CAM:GetAttachment(1).Ang

    DrawColorModify(scannerColorModify)

    draw.SimpleText("CAM-"..WATCHING_CAM:GetSyncVar(SYNC_CAM_CAMID, 0), "bigfont", x, y, color_white)
    draw.SimpleText("ANG: "..math.floor(ang[1]).." "..math.floor(ang[2]).." "..math.floor(ang[3]), "bigfont", x, y + 10, color_white)
    draw.SimpleText("STATUS: ONLINE", "bigfont", x, y + 20, color_white)
    draw.SimpleText("HEALTH: "..WATCHING_CAM:Health(), "bigfont", x, y + 30, color_white)
end

local otaWallsRange =  820 ^ 2
local function DrawCombineHUD()
    local lp = LocalPlayer()
    local offset = 0

    if not lp:IsCP() or lp:Team() == TEAM_CA then
        return
    end

    if lp:GetTeamClass() == 0 then
        return
    end

    if (not WATCHING_CAM and impulse.hudEnabled == false) or (IsValid(impulse.MainMenu) and impulse.MainMenu:IsVisible()) then
        return
    end

	-- Create overlay material once
	if not CMB_OVERLAY then
		CMB_OVERLAY = Material("effects/cmb_overlay")
		CMB_OVERLAY:SetFloat("$salpha", 0.01)
		CMB_OVERLAY:Recompute()
		CMB_OVERLAY:SetFloat("$refractamount", 0.01)
		CMB_OVERLAY:SetFloat("$envmaptint", 1)
		CMB_OVERLAY:SetFloat("$envmap", 0)
		CMB_OVERLAY:SetFloat("$alpha", 1)
		CMB_OVERLAY:SetInt("$ignorez", 1)
	end
	
	if not CMB_BINOVERLAY then
		CMB_BINOVERLAY = Material("effects/combine_binocoverlay")
		CMB_BINOVERLAY:SetFloat("$salpha", 0.2)
		CMB_BINOVERLAY:Recompute()
		CMB_BINOVERLAY:SetFloat("$refractamount", 0.01)
		CMB_BINOVERLAY:SetFloat("$envmaptint", 1)
		CMB_BINOVERLAY:SetFloat("$envmap", 0)
		CMB_BINOVERLAY:SetFloat("$alpha", 1)
		CMB_BINOVERLAY:SetInt("$ignorez", 1)
	end	

	--if not WATCHING_CAM then
	--	surface.SetDrawColor(overlayCol)
	--	surface.SetMaterial(CMB_OVERLAY)
	--	surface.DrawTexturedRect(0, 0, ScrW(), ScrH())
	--end

    --if not DrawBootSequence() then
    --    return
    --end
    
    DrawCombineWaypoints()

    if WATCHING_CAM then
        DrawCombineCameraOverlay()
    end

    local sqData
    if lp:GetSyncVar(SYNC_SQUAD_ID, nil) then
        sqData = DrawCombineSquad()
    end

    if lp:Team() == TEAM_OTA or lp:Team() == TEAM_CP or lp:Team() == TEAM_WORKER or lp:Team() == TEAM_HAZMAT then
        local pos = lp:GetPos()

        DrawCombineCompass(sqData)

        local wep = lp:GetActiveWeapon()
        if wep and IsValid(wep) then
            local clip = wep:Clip1()
            local maxClip = wep:GetMaxClip1()

            if maxClip > 0 and clip < maxClip * 0.01 then
                DrawLowAmmo(offset)
            end
        end
    elseif lp:Team() == TEAM_CP then
        local wep = lp:GetActiveWeapon()

        if wep and IsValid(wep) and wep:GetClass() == "ls_stunstick" and lp:IsWeaponRaised() then
            DrawBatonStatus(wep, offset)
        end
    end

    local h = DrawCombineMessages(offset)
    DrawAuxData(offset)
end

hook.Add("HUDPaint", "impulseHL2RPCombineOverlay", DrawCombineHUD)

local function CameraView(ply, pos, ang, fov)
    if not WATCHING_CAM then
        return
    end

    if not IsValid(WATCHING_CAM) then
        impulse.hudEnabled = true
        WATCHING_CAM = nil
        return
    end

    if not WATCHING_CAM:IsCameraEnabled() then
        impulse.hudEnabled = true
        WATCHING_CAM = nil
        return LocalPlayer():Notify("Camera signal lost.")
    end

    if not LocalPlayer():Alive() then
        impulse.hudEnabled = true
        WATCHING_CAM = nil
        return
    end

    if not LocalPlayer():IsCP() then
        impulse.hudEnabled = true
        WATCHING_CAM = nil
        return
    end

    if WATCHING_CAM_POS:DistToSqr(LocalPlayer():GetPos()) > (70 ^ 2) then
        impulse.hudEnabled = true
        WATCHING_CAM = nil
        return ply:Notify("You moved too far from the terminal.")
    end

    local eyes = WATCHING_CAM:LookupAttachment("eyes")

    if not eyes then
        impulse.hudEnabled = true
        WATCHING_CAM = nil
        return
    end

    local data = WATCHING_CAM:GetAttachment(eyes)
    data.Pos = data.Pos + data.Ang:Forward() * 2.8

    local view = {}
    view.origin = data.Pos
    view.angles = data.Ang
    view.fov = 110

    return view
end

hook.Add("CalcView", "impulseHL2RPCombineCamView", CameraView)

function impulse.AddCombineMessage(text, col, noSound)
    impulse.CombineMessageID = impulse.CombineMessageID + 1
    text = ""..text

    if col then
        col.a = 175
    end

    local msgData = {
        message = "",
        bgCol = col
    }

    table.insert(impulse.CombineMessages, msgData)

    if (#impulse.CombineMessages == 4) then
        table.remove(impulse.CombineMessages, 1)
    end

	local i = 0
	local id = "impulse_CombineOverlay"..impulse.CombineMessageID

	timer.Create(id, 0.06, #text, function()
		i = i + 1
		msgData.message = string.sub(text, 1, i)

        if msgData.message == #text then
            timer.Remove(id)
        end
    end)

    if not noSound then
    end
end

function impulse.AddCombineWaypoint(message, pos, duration, icon, colour, textcolour, unit, sender, citizen)
    local waypoint = {
        text = message,
        pos = pos,
        endtime = duration and (CurTime() + duration) or nil,
        mat = CMB_OVERLAY_ICONS[icon or 1],
        colour = CMB_OVERLAY_COLS[colour or 1],
		font = "msgfont",
        textcolour = CMB_OVERLAY_COLS[textcolour or 1] or color_white
    }

    if unit and IsValid(unit) then
        waypoint.name = unit:Nick()
        waypoint.prefix = "UNIT"
    elseif sender and IsValid(sender) then
        waypoint.name = sender:Nick()
        waypoint.prefix = "SENDER"
    elseif citizen then
        waypoint.name = citizen:Nick()
        waypoint.prefix = "TARGET"
    end

    local id = table.insert(impulse.CombineWaypoints, waypoint)

    LocalPlayer():EmitSound("buttons/button17.wav", 45, 135)

    return id
end

net.Receive("impulseHL2RPCombineMessage", function()
    local message = net.ReadString()
    local col = net.ReadColor()

    if col == Color(0, 0, 0) then
        impulse.AddCombineMessage(message)
    else
        impulse.AddCombineMessage(message, col)
    end
end)

net.Receive("impulseHL2RPCombineWaypoint",function()
    local message = net.ReadString()
    local pos = net.ReadVector()
    local duration = net.ReadUInt(10)
    local icon = net.ReadUInt(8)
    local colour = net.ReadUInt(8)
    local unit = net.ReadUInt(8)

    if unit != 0 then
        unit = Entity(unit)

        if not IsValid(unit) then
            unit = nil
        end
    end

    impulse.AddCombineWaypoint(message, pos, duration, icon, colour, nil, unit or nil)
end)

net.Receive("impulseHL2RPCombineOverlayBoot", function()
    bootDone = nil
    command = 0
    nextCommand = nil
end)

local nextMessage
local lastMessage
local idleMessages = {
    " hrtfew     Refreshing          civic  politi-stabilization  index",
	" thbdhr     Transmitting  physical  transition  vector",
    " ytrbwd         Modulating          temperature  levels",
    " qkejkm             Fuck  you  for  using  a  font  replacer",
    " lrkwmn     Re-establishing  connection  to  network",
	" pekfse     Parsing  view        ports  arrays",
	" gkrtst          Updating  biosignal  co-ordinates",
	" bmfnlo         Downloading  recent  dictionaries",
    " rgrrjt     Regaining  equalization  modules",
	" rtkgdb     Updating  mainframe  connection",
	" fmrnnc             Synchronizing        data",
    " mbmezs     Filtering  incoming  messages",
	" kwmfsd     Translating  radio  messages",
	" tngnfe     Emptying  outgoing                  pipes",
    " krmfjg         Recalibrating  socioscan",
	" ktnmgf     Sensoring  proximity",
	" rjwdgf       Pinging                 loopback",
	" pejwfg     Idle  connection"
}

hook.Add("Think", "impulseAmbientMessages", function()
    local lp = LocalPlayer()

    if (lp:Team() == TEAM_CP or lp:Team() == TEAM_OTA or lp:Team() == TEAM_WORKER or lp:Team() == TEAM_HAZMAT) and (nextMessage or 0) < CurTime() then
        local message = idleMessages[math.random(1, #idleMessages)]

        if message != (lastMessage or "") then
            impulse.AddCombineMessage(message, nil, true)
            lastMessage = message
        end

        nextMessage = CurTime() + math.random(3, 6)
    end
end)

local visorColorModify = {
    ["$pp_colour_addr"] = 0,
    ["$pp_colour_addg"] = 0,
    ["$pp_colour_addb"] = 0,
    ["$pp_colour_brightness"] = 0,
    ["$pp_colour_contrast"] = 1.4,
    ["$pp_colour_colour"] = 1,
    ["$pp_colour_mulr"] = 0,
    ["$pp_colour_mulg"] = 0,
    ["$pp_colour_mulb"] = 0
}

local transhumanColorModify = {
    ["$pp_colour_addr"] = 0,
    ["$pp_colour_addg"] = 0,
    ["$pp_colour_addb"] = 0,
    ["$pp_colour_brightness"] = 0.05,
    ["$pp_colour_contrast"] = 1.1,
    ["$pp_colour_colour"] = 1,
    ["$pp_colour_mulr"] = 0,
    ["$pp_colour_mulg"] = 0,
    ["$pp_colour_mulb"] = 0
}

hook.Add("RenderScreenspaceEffects", "impulseHL2RPCombineOverlayEffect", function()
    local lp = LocalPlayer()

    if not IsValid(lp) then return end
    if not lp:IsCP() then return end
    if lp:Team() == TEAM_CA then return end
	if lp:Team() == TEAM_OTA then return end
    if WATCHING_CAM then return end
    if IsValid(impulse.MainMenu) and impulse.MainMenu:IsVisible() then return end

    if not CMB_OVERLAY then return end

    render.UpdateScreenEffectTexture()
	DrawColorModify(visorColorModify)

    surface.SetMaterial(CMB_OVERLAY)
    surface.SetDrawColor(255, 255, 255, 1)
    surface.DrawTexturedRect(0, 0, ScrW(), ScrH())
end)

hook.Add("RenderScreenspaceEffects", "TranshumanOverlayEffect", function()
    local lp = LocalPlayer()

    if not IsValid(lp) then return end
    if not lp:IsCP() then return end
    if lp:Team() == TEAM_CA then return end
	if lp:Team() == TEAM_CP then return end
	if lp:Team() == TEAM_WORKER then return end
	if lp:Team() == TEAM_HAZMAT then return end
    if WATCHING_CAM then return end
    if IsValid(impulse.MainMenu) and impulse.MainMenu:IsVisible() then return end

    if not CMB_BINOVERLAY then return end

    render.UpdateScreenEffectTexture()
	DrawColorModify(transhumanColorModify)

    surface.SetMaterial(CMB_BINOVERLAY)
    surface.SetDrawColor(0, 0, 0, 255)
    surface.DrawTexturedRect(0, 0, ScrW(), ScrH())
end)