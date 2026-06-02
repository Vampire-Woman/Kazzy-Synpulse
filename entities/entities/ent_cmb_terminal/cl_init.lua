include("shared.lua")

local BG = Material("ui/terminal/ccs_bg.png")

local localX, localY = 640, 360

local tDestinations = {
    { Title = "RESIDENCE ASSIGNMENT  ::  6859203 . . 575 . 5 . 1 . .", Name = "Assign Residence", Func = function(eEnt)
        surface.PlaySound("misc/nosound.wav")
    end, CitizenOnly = true },

    { Title = "ALERT PROTECTION TEAMS  ::  911054 . . 174 . 8 . 3 . .", Name = "Alert Civil Protection", Func = function(eEnt)
        surface.PlaySound("misc/nosound.wav")
    end, CitizenOnly = true },

    { Title = "DISTRIBUTION ASSIGNMENT  ::  737052 . . 936 . 3 . 2 . .", Name = "Acquire Distribution Permit", Func = function(eEnt)
        surface.PlaySound("misc/nosound.wav")
    end, CitizenOnly = true },

    { Title = "STERILIZED CREDIT BALANCE  ::  493041 . . 23 . 5 . 7 . .", Name = "Access Credit Balance", Func = function(eEnt)
        surface.PlaySound("misc/nosound.wav")
    end },

    { Name = "Exit Navigation", Func = function(eEnt)
        eEnt.LoggedIn = false
        surface.PlaySound("misc/nosound.wav")
    end }
}

-- =========================
-- INIT
-- =========================
function ENT:Initialize()
    self.LoggedIn = false

    sound.PlayFile("sound/combine_tech/civic_station/station_hum_loop1.wav", "3d noplay noblock", function(station, errCode, errStr)
        if IsValid(station) then
            station:Set3DFadeDistance(100, 2048)
            station:SetVolume(0.1)
            station:SetPos(self:GetPos())
            station:EnableLooping(true)
            station:Play()

            self.Station = station
        end
    end)

    self.Page = 0
end

-- =========================
-- DRAW MODEL
-- =========================
function ENT:Draw()
    self:DrawModel()

    local lp = LocalPlayer()
    if not IsValid(lp) then return end

    if self:GetPos():DistToSqr(lp:GetPos()) > 128000 then return end

    local alarmEnd = self.GetAlarmTimeEnd and self:GetAlarmTimeEnd() or 0

    if alarmEnd > CurTime() then
        self:DrawAlarmEffects()
    end
end

-- =========================
-- PAGE SYSTEM
-- =========================
function ENT:GetPage()
    return tDestinations[self.Page]
end

function ENT:GetPageNumber()
    return self.Page or 0
end

function ENT:SetPage(iPage)
    self.Page = iPage
end

-- =========================
-- SAFE USAGE CHECK
-- =========================
function ENT:CanUse(ply)
    if not IsValid(ply) then return false end
    if not ply:IsPlayer() then return false end

    return true
end

-- =========================
-- REMOVE SOUND
-- =========================
function ENT:OnRemove()
    if IsValid(self.Station) then
        self.Station:Stop()
    end
end

-- =========================
-- 3D2D UI (FULL REPLACEMENT)
-- =========================
hook.Add("PostDrawTranslucentRenderables", "Terminal_UI_Draw", function()
    local lp = LocalPlayer()
    if not IsValid(lp) then return end

    for _, ent in ipairs(ents.FindByClass("ent_cmb_terminal")) do
        if not IsValid(ent) then continue end
        if not ent:CanUse(lp) then continue end

        local pos = ent:LocalToWorld(Vector(-26, 1.5, -1))

        local ang = ent:GetAngles()
        ang:RotateAroundAxis(ang:Up(), -100)
        ang:RotateAroundAxis(ang:Forward(), 90)

        cam.Start3D2D(pos, ang, 0.04)

            -- BACKGROUND
            surface.SetMaterial(BG)
            surface.SetDrawColor(255, 255, 255)
            surface.DrawTexturedRectRotated(0, 0, 640, 360, 0)

            -- HEADER
            draw.SimpleText(
                " ",
                "DermaLarge",
                0,
                -150,
                Color(120, 180, 255),
                TEXT_ALIGN_CENTER,
                TEXT_ALIGN_CENTER
            )

            -- ALARM OVERRIDE
            local alarmEnd = ent.GetAlarmTimeEnd and ent:GetAlarmTimeEnd() or 0
            if alarmEnd > CurTime() then
                draw.SimpleText(
                    "ALERT ACTIVE",
                    "DermaLarge",
                    0,
                    0,
                    Color(255, 80, 80),
                    TEXT_ALIGN_CENTER,
                    TEXT_ALIGN_CENTER
                )
                cam.End3D2D()
                continue
            end

            -- LOGIN SCREEN
            if ent.LoggedIn then
                draw.SimpleText(
                    "ACCESS REQUIRED",
                    "DermaLarge",
                    0,
                    0,
                    color_white,
                    TEXT_ALIGN_CENTER,
                    TEXT_ALIGN_CENTER
                )
                cam.End3D2D()
                continue
            end

            -- MENU
            local iCount = 1

            for _, tDest in SortedPairs(tDestinations) do
                local x = -320
                local y = -180 + (iCount * 50)
                local w, h = 640 * 0.5, 40

                local lpTeam = lp:Team()

                if tDest.CitizenOnly then
                    draw.RoundedBox(0, -160, y, w, h, Color(0, 0, 0, 150))

                    draw.SimpleText(
                        tDest.Name,
                        "DermaDefaultBold",
                        x + w / 1,
                        y + h / 2,
                        Color(150, 200, 255),
                        TEXT_ALIGN_CENTER,
                        TEXT_ALIGN_CENTER
                    )

                    iCount = iCount + 1
                    continue
                end

                draw.RoundedBox(0, -160, y, w, h, Color(0, 0, 0, 150))

                draw.SimpleText(
                    tDest.Name,
                    "DermaDefaultBold",
                    x + w / 1,
                    y + h / 2,
                    Color(150, 200, 255),
                    TEXT_ALIGN_CENTER,
                    TEXT_ALIGN_CENTER
                )

                -- SIMPLE CLICK DETECTION (basic usable version)
                if input.IsMouseDown(MOUSE_LEFT) then
                    local mx, my = gui.MousePos()

                    if mx and my then
                        -- NOTE: real 3D2D click detection requires projection (not included)
                    end
                end

                iCount = iCount + 1
            end

        cam.End3D2D()
    end
end)

-- =========================
-- ALARM EFFECTS
-- =========================
local mGlow = Material("sprites/glow04_noz")

function ENT:DrawAlarmEffects()
    local pos =
        self:GetPos()
        + self:GetUp() * 2.2
        + self:GetRight() * -20.5
        + self:GetForward() * -24

    local alpha = math.abs(math.cos(RealTime() * 3) * 255)

    render.SetMaterial(mGlow)
    render.DrawSprite(pos, 3, 3, Color(255, 60, 60, alpha))
end