local SKIN = {}

-- ===============================
-- FONTS
-- ===============================
SKIN.fontFrame = "BudgetLabel"
SKIN.fontTab = "BudgetLabel"
SKIN.fontButton = "BudgetLabel"
SKIN.fontCategoryHeader = "BudgetLabel"

-- ===============================
-- COLOURS
-- ===============================
SKIN.Colours = table.Copy(derma.SkinList.Default.Colours)

SKIN.Colours.Window.TitleActive = Color(255, 255, 255)
SKIN.Colours.Window.TitleInactive = Color(200, 200, 200)

SKIN.Colours.Button.Normal = Color(255, 255, 255)
SKIN.Colours.Button.Hover = Color(255, 255, 255)
SKIN.Colours.Button.Down = Color(251, 197, 49)
SKIN.Colours.Button.Disabled = Color(150, 150, 150)

SKIN.Colours.Label.Dark = SKIN.Colours.Label.Bright

-- ===============================
-- MATERIALS
-- ===============================
local frameMat = Material("overlays/cmb_bg_animated1")

-- Overlay tuning
local ALPHA = 255
local HORIZONTAL_STRETCH = 1
local VERTICAL_COMPRESS = 1

-- ===============================
-- FRAME
-- ===============================
function SKIN:PaintFrame(panel, w, h)
    -- Base
    surface.SetDrawColor(255, 255, 255, 255)
    surface.DrawRect(0, 0, w, h)

    -- Overlay
    surface.SetMaterial(frameMat)
    surface.SetDrawColor(255, 255, 255, ALPHA)
    surface.DrawTexturedRectUV(0, 0, w, h, 0, 0, HORIZONTAL_STRETCH, VERTICAL_COMPRESS)

    -- Border
    surface.SetDrawColor(0, 0, 0, 255)
    surface.DrawOutlinedRect(0, 0, w, h)

    panel.lblTitle:SetFont("BudgetLabel")
end

-- ===============================
-- GENERIC PANEL
-- ===============================
function SKIN:PaintPanel(panel, w, h)
    if not panel:GetPaintBackground() then return end

    surface.SetDrawColor(25, 25, 25, 255)
    surface.DrawRect(0, 0, w, h)

    surface.SetMaterial(frameMat)
    surface.SetDrawColor(255, 255, 255, ALPHA)
    surface.DrawTexturedRectUV(0, 0, w, h, 0, 0, HORIZONTAL_STRETCH, VERTICAL_COMPRESS)
end

-- ===============================
-- BUTTON
-- ===============================
function SKIN:PaintButton(panel, w, h)
    if not panel:GetPaintBackground() then return end

    local col = Color(39, 60, 117, 0)

    if panel:GetDisabled() then
        col = Color(60, 60, 60, 0)
    elseif panel.Depressed then
        col = Color(25, 42, 86, 0)
    elseif panel.Hovered then
        col = Color(54, 81, 150, 0)
    end

    surface.SetDrawColor(col)
    surface.DrawRect(0, 0, w, h)

    surface.SetDrawColor(0, 0, 0, 0)
    surface.DrawOutlinedRect(0, 0, w, h)
end

-- ===============================
-- LIST VIEW
-- ===============================
function SKIN:PaintListView(panel, w, h)
    surface.SetDrawColor(30, 30, 30, 255)
    surface.DrawRect(0, 0, w, h)

    surface.SetMaterial(frameMat)
    surface.SetDrawColor(255, 255, 255, ALPHA)
    surface.DrawTexturedRectUV(0, 0, w, h, 0, 0, HORIZONTAL_STRETCH, VERTICAL_COMPRESS)
end

function SKIN:PaintListViewLine(panel, w, h)
    if panel:IsSelected() then
        surface.SetDrawColor(39, 60, 117, 200)
        surface.DrawRect(0, 0, w, h)
    elseif panel.Hovered then
        surface.SetDrawColor(50, 50, 50, 255)
        surface.DrawRect(0, 0, w, h)
    elseif panel.m_bAlt then
        surface.SetDrawColor(40, 40, 40, 255)
        surface.DrawRect(0, 0, w, h)
    end
end

-- ===============================
-- WINDOW BUTTONS
-- ===============================
function SKIN:PaintWindowMinimizeButton() end
function SKIN:PaintWindowMaximizeButton() end

function SKIN:PaintWindowCloseButton(panel, w, h)
    surface.SetDrawColor(0, 0, 0, 0)
    surface.DrawRect(0, 0, w, h)

    draw.SimpleText(
        "✕",
        "BudgetLabel",
        w / 2,
        h / 2,
        Color(255,255,255),
        TEXT_ALIGN_CENTER,
        TEXT_ALIGN_CENTER
    )
end

-- ===============================
-- REGISTER SKIN
-- ===============================
derma.DefineSkin("combinesSkin", "Combine styled skin", SKIN)
derma.RefreshSkins()