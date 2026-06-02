local PANEL = {}

function PANEL:Init()
    local ply = LocalPlayer()

    self:SetSize(1600, 1000)
    self:Center()
    self:SetTitle("Dropship Deployment Terminal")
    self:MakePopup()
    self:SetSkin("combineSkin")
    self:ShowCloseButton(false)
	self:SetDraggable(false)
    self.zone = nil

	LocalPlayer():EmitSound("ambient/levels/prison/radio_random"..math.random(1,9)..".wav", 100, 100, 0.33)

    self.leftpanel = self:Add("DScrollPanel")
    self.leftpanel:SetWide(scrW / 3)
    self.leftpanel:Dock(LEFT)

    local label = self:Add("Panel")
    label:Dock(TOP)
    label:DockMargin(16, 16, 16, 16)
    label:SetTall(ScreenScale(50))
    label.Paint = function(panel, w, h)
        draw.SimpleText("Waiting for more units...", "Impulse-Elements32", w / 2, h / 2, impulse.Config.MainColour, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    local label = self:Add("Panel")
    label:Dock(TOP)
    label:DockMargin(16, 16, 16, 16)
    label:SetTall(ScreenScale(30))
    label.Paint = function(panel, w, h)
        draw.SimpleText(#impulse.dp.queue.plaza.." / 4", "Impulse-Elements32", w / 2, h / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    self.modela = self.leftpanel:Add("DModelPanel")
    self.modela:SetPos(0, 0)
    self.modela:SetSize(scrW / 3, scrH)
    self.modela:SetModel("models/combine_dropship_container.mdl")
    self.modela:SetCamPos(self.modela:GetCamPos() + Vector(50, 150, 130))
    self.modela:SetFOV(75)

    local button = self:Add("DButton")
    button:SetText("Cancel")
    button:SetFont("Impulse-Elements32")
    button:Dock(BOTTOM)
    button:SetContentAlignment(5)
    button:SizeToContents()
    button.DoClick = function()
        net.Start("CancelPlazaWait")
        net.SendToServer()

        self:Remove()
    end
end

function PANEL:Think()
    local rand = math.random(1,1000)
	if(rand == 1) then LocalPlayer():EmitSound("ambient/levels/prison/radio_random"..math.random(1,9)..".wav", 100, 100, 0.2) end
    
    if ( #impulse.dp.queue.plaza >= 4 ) then
        self:Remove()
    end
end

vgui.Register("dropshipwait", PANEL, "DFrame")