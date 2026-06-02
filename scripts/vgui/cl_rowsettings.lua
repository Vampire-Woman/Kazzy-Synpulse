-- alternative checkbox
DEFINE_BASECLASS("EditablePanel")
local PANEL = {}

AccessorFunc(PANEL, "enabledText", "EnabledText", FORCE_STRING)
AccessorFunc(PANEL, "disabledText", "DisabledText", FORCE_STRING)
AccessorFunc(PANEL, "font", "Font", FORCE_STRING)
AccessorFunc(PANEL, "bChecked", "Checked", FORCE_BOOL)
AccessorFunc(PANEL, "animationTime", "AnimationTime", FORCE_NUMBER)
AccessorFunc(PANEL, "labelPadding", "LabelPadding", FORCE_NUMBER)

PANEL.GetValue = PANEL.GetChecked

function PANEL:Init()
	self:SetMouseInputEnabled(true)
	self:SetCursor("hand")

	self.enabledText = "YES"
	self.disabledText = "NO"
	self.font = "Impulse-Elements32"
	self.animationTime = 0.5
	self.bChecked = false
	self.labelPadding = 8
	self.animationOffset = 0

	self:SizeToContents()
end

function PANEL:SizeToContents()
	BaseClass.SizeToContents(self)

	surface.SetFont(self.font)
	self:SetWide(math.max(surface.GetTextSize(self.enabledText), surface.GetTextSize(self.disabledText)) + self.labelPadding)
end

-- can be overidden to change audio params
function PANEL:GetAudioFeedback()
	return "weapons/ar2/ar2_empty.wav", 75, self.bChecked and 150 or 125, 0.25
end

function PANEL:EmitFeedback()
	LocalPlayer():EmitSound(self:GetAudioFeedback())
end

function PANEL:SetChecked(bChecked, bInstant)
	self.bChecked = tobool(bChecked)

	self.animationOffset = bChecked and 1 or 0

	if (!bInstant) then
		self:EmitFeedback()
	end
end

function PANEL:OnMousePressed(code)
	if (code == MOUSE_LEFT) then
		self:SetChecked(!self.bChecked)
		self:DoClick()
	end
end

function PANEL:DoClick()
end

function PANEL:Paint(width, height)
	surface.SetDrawColor(Color(0, 0, 0, 66))
	surface.DrawRect(0, 0, width, height)

	local offset = self.animationOffset
	surface.SetFont(self.font)

	local text = self.disabledText
	local textWidth, textHeight = surface.GetTextSize(text)
	local y = offset * -textHeight

	surface.SetTextColor(250, 60, 60, 255)
	surface.SetTextPos(width * 0.5 - textWidth * 0.5, y + height * 0.5 - textHeight * 0.5)
	surface.DrawText(text)

	text = self.enabledText
	y = y + textHeight
	textWidth, textHeight = surface.GetTextSize(text)

	surface.SetTextColor(30, 250, 30, 255)
	surface.SetTextPos(width * 0.5 - textWidth * 0.5, y + height * 0.5 - textHeight * 0.5)
	surface.DrawText(text)
end

vgui.Register("impulseCheckBox", PANEL, "EditablePanel")

-- settings row
PANEL = {}

AccessorFunc(PANEL, "backgroundIndex", "BackgroundIndex", FORCE_NUMBER)
AccessorFunc(PANEL, "bShowReset", "ShowReset", FORCE_BOOL)

function PANEL:Init()
	self:DockPadding(4, 4, 4, 4)

	self.text = self:Add("DLabel")
	self.text:Dock(LEFT)
	self.text:SetFont("Impulse-Elements32")
	self.text:SetExpensiveShadow(1, color_black)

	self.backgroundIndex = 0
end

function PANEL:OnResetClicked()
end

function PANEL:GetLabel()
	return self.text
end

function PANEL:SetText(text)
	self.text:SetText(text)
	self:SizeToContents()
end

function PANEL:GetText()
	return self.text:GetText()
end

-- implemented by row types
function PANEL:GetValue()
end

function PANEL:SetValue(value)
end

-- meant for array types to populate combo box values
function PANEL:Populate(key, info)
end

-- called when value is changed by user
function PANEL:OnValueChanged(newValue)
end

function PANEL:SizeToContents()
	local _, top, _, bottom = self:GetDockPadding()

	self.text:SizeToContents()
	self:SetTall(self.text:GetTall() + top + bottom)
	self.impulseRealHeight = self:GetTall()
	self.impulseHeight = self.impulseRealHeight
end

function PANEL:Paint(width, height)
	--derma.SkinFunc("PaintSettingsRowBackground", self, width, height)
end

vgui.Register("impulseSettingsRow", PANEL, "EditablePanel")

-- bool setting
PANEL = {}

function PANEL:Init()
	self.setting = self:Add("impulseCheckBox")
	self.setting:Dock(RIGHT)
	self.setting.DoClick = function(panel)
		self:OnValueChanged(self:GetValue())
	end
end

function PANEL:SetValue(bValue)
	bValue = tobool(bValue)

	self.setting:SetChecked(bValue, true)
end

function PANEL:GetValue()
	return self.setting:GetChecked()
end

vgui.Register("impulseSettingsRowBool", PANEL, "impulseSettingsRow")