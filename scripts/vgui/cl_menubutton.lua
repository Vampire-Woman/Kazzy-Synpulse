
local buttonPadding = ScreenScale(14) * 0.5
local animationTime = 0.5

-- base menu button
DEFINE_BASECLASS("DButton")

local PANEL = {}

AccessorFunc(PANEL, "insetColor", "InsetColor")
AccessorFunc(PANEL, "backgroundColor", "BackgroundColor")
AccessorFunc(PANEL, "backgroundAlpha", "BackgroundAlpha")
AccessorFunc(PANEL, "move", "Move")

local textInset = buttonPadding

function PANEL:Init()
    self:SetContentAlignment(4)
    self:SetTextColor(Color(255, 255, 255))
    self:SetFont("Impulse-LightUI40")
    self:SetTextInset(textInset, 0)
    self.insetColor = impulse.Config.MainColour
    self.padding = {0, 0, 0, 0} -- left, top, right, bottom
	self.backgroundColor = Color(0, 0, 0)
	self.backgroundAlpha = 200
	self.currentBackgroundAlpha = 0
	self.move = false

	textInset = self:GetTextInset()
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

function PANEL:SetContentAlignment(alignment)
    BaseClass.SetContentAlignment(self, alignment)

    self.contentAlignment = alignment or 4
end

function PANEL:SizeToContents()
    BaseClass.SizeToContents(self)
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

	currentBackgroundAlpha = self.backgroundAlpha

    LocalPlayer():EmitSound("ui/buttonrollover.wav")
end

function PANEL:OnCursorExited()
    if ( self:GetDisabled() ) then
        return
    end

    local textColor = self.textColor
    self:SetTextColorInternal(textColor)

	currentBackgroundAlpha = 0
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

    LocalPlayer():EmitSound("ui/buttonclick.wav")
end

function PANEL:Think()
    if ( self:GetDisabled() or self.contentAlignment != 4 or !self.move ) then
        return
    end

    if ( self.contentAlignment != 4 ) then
        return
    end
    
    local ft = FrameTime()

    if ( self:IsHovered() ) then
        self.textInsetLerp = Lerp(ft * 10, self.textInsetLerp or textInset, textInset * 2)
    else
        self.textInsetLerp = Lerp(ft * 10, self.textInsetLerp or textInset, textInset)
    end

    self:SetTextInset(self.textInsetLerp, 0)
end

function PANEL:PaintBackground(width, height)
	surface.SetDrawColor(ColorAlpha(self.backgroundColor, self.currentBackgroundAlpha))
	surface.DrawRect(0, 0, width, height)
end

local defaultWidthBar = textInset * 1.5
function PANEL:Paint(width, height)
	self:PaintBackground(width, height)

    if ( self:GetDisabled() or self.contentAlignment != 4 or !self.move ) then
        return
    end

    local ft = FrameTime()

    if ( self:IsHovered() ) then
        self.widthBar = Lerp(ft * 10, self.widthBar or 0, defaultWidthBar)
    else
        self.widthBar = Lerp(ft * 10, self.widthBar or 0, 0)
    end

	surface.SetDrawColor(ColorAlpha(self.insetColor, self.currentBackgroundAlpha))
	surface.DrawRect(0, 0, self.widthBar, height)
end

vgui.Register("impulseSpecialMenuButton", PANEL, "DButton")

DEFINE_BASECLASS("DButton")
PANEL = {}

AccessorFunc(PANEL, "backgroundColor", "BackgroundColor")
AccessorFunc(PANEL, "backgroundAlpha", "BackgroundAlpha")

function PANEL:Init()
	self:SetFont("Impulse-LightUI40")
    self:SetTextColor(Color(255, 255, 255))
	self:SetPaintBackground(false)
	self:SetContentAlignment(4)
	self:SetTextInset(buttonPadding, 0)

	self.padding = {8, 4, 8, 4} -- left, top, right, bottom
	self.backgroundColor = Color(0, 0, 0)
	self.backgroundAlpha = 200
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
	self:SetSize(width, height)
end

function PANEL:PaintBackground(width, height)
	surface.SetDrawColor(ColorAlpha(self.backgroundColor, self.currentBackgroundAlpha))
	surface.DrawRect(0, 0, width, height)
end

function PANEL:Paint(width, height)
	if ( self:GetFont() == "Impulse-LightUI" ) then
		draw.DrawText(self:GetText(), self:GetFont().."-Blurred", 22, height / 2 - 20, ColorAlpha(self:GetTextColor(), 100))
	end
	
	self:PaintBackground(width, height)
	BaseClass.Paint(self, width, height)
end

function PANEL:SetTextColorInternal(color)
	BaseClass.SetTextColor(self, color)
	self:SetFGColor(color)
end

function PANEL:SetTextColor(color)
	self:SetTextColorInternal(color)
	self.color = color
end

function PANEL:SetDisabled(bValue)
	local color = self.color

	if (bValue) then
		self:SetTextColorInternal(Color(math.max(color.r - 60, 0), math.max(color.g - 60, 0), math.max(color.b - 60, 0)))
	else
		self:SetTextColorInternal(color)
	end

	BaseClass.SetDisabled(self, bValue)
end

function PANEL:OnCursorEntered()
	if (self:GetDisabled()) then
		return
	end

	local color = self:GetTextColor()
	self:SetTextColorInternal(Color(math.max(color.r + 100, 0), math.max(color.g + 100, 0), math.max(color.b + 100, 0)))

	currentBackgroundAlpha = self.backgroundAlpha

	LocalPlayer():EmitSound("ui/buttonrollover.wav")
end

function PANEL:OnCursorExited()
	if (self:GetDisabled()) then
		return
	end

	if (self.color) then
		self:SetTextColor(self.color)
	else
		self:SetTextColor(color_white)
	end

	currentBackgroundAlpha = 0
end

function PANEL:OnMousePressed(code)
	if (self:GetDisabled()) then
		return
	end

	if (self.color) then
		self:SetTextColor(self.color)
	else
		self:SetTextColor(impulse.Config.MainColour)
	end

	LocalPlayer():EmitSound("ui/buttonclick.wav")

	if (code == MOUSE_LEFT and self.DoClick) then
		self:DoClick(self)
	elseif (code == MOUSE_RIGHT and self.DoRightClick) then
		self:DoRightClick(self)
	end
end

function PANEL:OnMouseReleased(key)
	if (self:GetDisabled()) then
		return
	end

	if (self.color) then
		self:SetTextColor(self.color)
	else
		self:SetTextColor(color_white)
	end
end

vgui.Register("impulseMenuButton", PANEL, "DButton")