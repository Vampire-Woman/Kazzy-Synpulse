include("shared.lua")


local PANEL = {}

function PANEL:Init()
    self:SetPos(0, 0)
    self:SetSize(scrW, scrH)
    self:MakePopup()
    self.systime = SysTime()
    
    local ply = LocalPlayer()
    
    self.close = self:Add("impulseMenuButton")
    self.close:SetFont("Impulse-LightUI96")
    self.close:SetText("Close")
    self.close:Dock(BOTTOM)
    self.close:SetContentAlignment(5)
    self.close:SetTall(50)
    self.close:SizeToContents()
    self.close.DoClick = function()
        self:Remove()
    end
    
    self.refill = self:Add("impulseMenuButton")
    self.refill:SetText("Refill")
    self.refill:Dock(BOTTOM)
    self.refill:SetContentAlignment(5)
    self.refill:SetTall(50)
    self.refill:SetFont("Impulse-LightUI96")
    self.refill:SizeToContents()
    self.refill.DoClick = function()        
        net.Start("impulseCitadelHealthChargerRefill")
        net.SendToServer()
    end
    
    self.lol = self:Add("Panel")
    self.lol:Dock(FILL)
    
    self.model = self.lol:Add("impulseModelPanel")
    self.model.LayoutEntity = function(s, ent)
        ent:SetAngles(Angle(0, 45, 0)) 
    end
    
    self.model:SetFOV(104)
    self.model:Dock(FILL)
    self.model:SetModel(ply:GetModel(), ply:GetSkin())
end

function PANEL:Paint(w, h)
    Derma_DrawBackgroundBlur(self, self.systime)
    
    surface.SetDrawColor(Color(0, 255, 0, 50))
    for i = 0, h, 5 do
        surface.DrawRect(0, i, w, 2)
    end
    
    surface.SetDrawColor(Color(30, 30, 30, 255))
    surface.DrawRect(ScrW() - 700, ScrH() / 2 + 400 - math.Clamp(LocalPlayer():Health() * 8, 0, 840), 15, math.Clamp(LocalPlayer():Health() * 8, 0, 840))
end

vgui.Register("impulseCitadelHealthCharger", PANEL, "DPanel")

PANEL = {}

function PANEL:Init()
    self:SetSize(1500, 800)
    self:Center()
    
    self:MakePopup()
    
    self:SetTitle("")
    
    self.rightpanel = self:Add("Panel")
    self.rightpanel:SetWide(450)
    self.rightpanel:Dock(RIGHT)
    
    self.label = self:Add("DLabel")
    self.label:SetText("Objective Menu")
    self.label:SetFont("impulseCitadelOverlayHuge")
    self.label:Dock(TOP)
    self.label:SetContentAlignment(5)
    self.label:SizeToContents()
    
    self.label2 = self.rightpanel:Add("DLabel")
    self.label2:SetText("Objectives")
    self.label2:SetFont("impulseCitadelOverlayHuge")
    self.label2:Dock(TOP)
    self.label2:SetContentAlignment(5)
    self.label2:SizeToContents()
    
    self.scrollpanel = self.rightpanel:Add("DScrollPanel")
    self.scrollpanel:Dock(FILL)
    
    for k, v in pairs(impulse.ci.directives) do
        local obj = self.scrollpanel:Add("DLabel")
        obj:SetText(v[1])
        obj:SetFont("impulseCitadelOverlayMedium")
        obj:DockMargin(10, 0, 0, 0)
        obj:SizeToContents()
        obj:Dock(TOP)
        
        obj:SetWrap(true)
        obj:SetTall(obj:GetTall() * 3)
    end
end

vgui.Register("impulseCitadelObjectivesMenu", PANEL, "DFrame")