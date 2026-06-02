surface.CreateFont("DIN_Pro_24", {
    font = "DIN Pro",        
    size = 24,
    weight = 500,            
    antialias = true,
    shadow = false
})

-- Notification panel
local PANEL = {}

local baseSizeW, baseSizeH = 1581, 20
local startX, startY = 33, 13
local activeNotifies = activeNotifies or {}

function PANEL:Init()
    self.message = markup.Parse("")
    self:SetSize(baseSizeW, baseSizeH)
    self.startTime = CurTime()
    self.endTime = CurTime() + 7.5

    table.insert(activeNotifies, self)

    -- Store original DPanel.SetPos (not our overridden one)
    self._OriginalSetPos = DPanel.SetPos
end

-- HARD OVERRIDE POSITIONING
function PANEL:SetPos()
    local yOffset = startY

    for _, pnl in ipairs(activeNotifies) do
        if pnl == self then break end
        if IsValid(pnl) then
            yOffset = yOffset + pnl:GetTall() + 5
        end
    end

    -- Call the original SetPos safely
    self._OriginalSetPos(self, startX, yOffset)
end

function PANEL:Think()
    -- Force position every frame
    self:SetPos()
end

function PANEL:OnRemove()
    for k, v in ipairs(activeNotifies) do
        if v == self then
            table.remove(activeNotifies, k)
            break
        end
    end
end

function PANEL:SetMessage(...)
    local msg = "<font=DIN_Pro_24>"

    for _, v in ipairs({...}) do
        if type(v) == "table" then
            msg = msg .. "<color=" .. v.r .. "," .. v.g .. "," .. v.b .. ">"
        elseif type(v) == "Player" then
            local col = team.GetColor(v:Team())
            msg = msg .. "<color=" .. col.r .. "," .. col.g .. "," .. col.b .. ">" ..
                  tostring(v:Name()):gsub("<", "&lt;"):gsub(">", "&gt;") ..
                  "</color>"
        else
            msg = msg .. tostring(v):gsub("<", "&lt;"):gsub(">", "&gt;")
        end
    end

    msg = msg .. "</font>"

    self.message = markup.Parse(msg, baseSizeW - 20)
    self:SetSize(baseSizeW, self.message:GetHeight() + baseSizeH)
	--surface.PlaySound("ui/hls_hint.wav")
end

function PANEL:Paint(w, h)
    -- No background
    if self.message then
        self.message:Draw(10, 10, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
    end
end

vgui.Register("impulseNotify", PANEL, "DPanel")