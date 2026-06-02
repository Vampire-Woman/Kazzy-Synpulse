local colors = {
    ["white"] = Color(200, 200, 200),
    ["blue"] = Color(100, 160, 250),
    ["cyan"] = Color(0, 200, 200),
    ["yellow"] = Color(200, 200, 0),
    ["red"] = Color(250, 50, 50),
    ["orange"] = Color(250, 100, 0),
    ["green"] = Color(100, 250, 100),
}

DEFINE_BASECLASS("DButton")

local PANEL = {}

function PANEL:Init()
	self:SetContentAlignment(5)
	self:SetTextColor(colors["cyan"])
    self:SetFont("Impulse-Elements18-Shadow")
    self:SetTextInset(ScreenScale(8), 0)

	self.padding = {8, 8, 8, 8} -- left, top, right, bottom
	self.backgroundColor = Color(0, 0, 0)
	self.backgroundAlpha = 50
	self.currentBackgroundAlpha = 0
end

function PANEL:GetPadding()
	return self.padding
end

function PANEL:SetPadding(left, top, right, bottom)
	self.padding = {
		left or self.padding[1],
		top or self.padding[2],
		right or self.padding[3],
		bottom or self.padding[4]
	}
end

function PANEL:SetText(text)
	BaseClass.SetText(self, text)
end

function PANEL:SizeToContents()
	BaseClass.SizeToContents(self)

	local width, height = self:GetSize()
	self:SetSize(width + self.padding[1] + self.padding[3], height + self.padding[2] + self.padding[4])
end

function PANEL:SetTextColorInternal(color)
	BaseClass.SetTextColor(self, color)
end

function PANEL:SetTextColor(color)
    BaseClass.SetTextColor(self, color)
    self.textColor = color
end

function PANEL:OnCursorEntered()
    if ( self:GetDisabled() ) then
        return
    end

    local textColor = self:GetTextColor()
    self:SetTextColorInternal(Color(textColor.r + 100, textColor.g + 100, textColor.b + 100))

    LocalPlayer():EmitSound("ui/buttonrollover.wav", nil, 130, 0.4)
end

function PANEL:OnCursorExited()
    if ( self:GetDisabled() ) then
        return
    end

    local textColor = self.textColor
    self:SetTextColorInternal(textColor)

    LocalPlayer():EmitSound("ui/buttonrollover.wav", nil, 70, 0.4)
end

function PANEL:OnMousePressed(key)
    BaseClass.OnMousePressed(self, key)

	if ( self:GetDisabled() ) then
		return
	end

    self.bPressed = true
    timer.Simple(0.1, function()
        if ( IsValid(self) ) then
            self.bPressed = nil
        end
    end)

    LocalPlayer():EmitSound("buttons/combine_button7.wav", nil, nil, 1)
end

function PANEL:Paint(width, height)
    impulse.ci.DrawCombineBox(0, 0, width, height, false)
end

vgui.Register("impulseCombineButton", PANEL, "DButton")