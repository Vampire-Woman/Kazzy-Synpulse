local PANEL = {}

function PANEL:Think()
	local rand = math.random(1,1000)
	if(rand == 1) then LocalPlayer():EmitSound("ambient/levels/prison/radio_random"..math.random(1,9)..".wav", 100, 100, 0.2) end
end

function PANEL:Init()
    local ply = LocalPlayer()

    local panel = self
    
	self.setting = {}

    self:SetSize(1000, 600)
	self:Center()
	self:SetSkin("combineSkin")
	self:MakePopup() -- Make the panel a popup
	self:SetTitle("Combine Interface")

    LocalPlayer():EmitSound("ambient/levels/prison/radio_random"..math.random(1,9)..".wav", 100, 100, 0.33)

    self.sheet = panel:Add("DColumnSheet")
    self.sheet:Dock(FILL)
    self.sheet.Navigation:SetWidth(self:GetWide() / 6)
    self.sheet.Navigation:DockMargin(ScreenScale(8), ScreenScale(8), ScreenScale(8), ScreenScale(8))
    self.sheet.Navigation.Paint = function(this, width, height)
    end

    if ( ply:IsUUHigherRank() ) then 
        local bollist = panel:Add("EditablePanel")
        bollist:Dock(FILL)

        bollist.sheet = bollist:Add("DColumnSheet")
        bollist.sheet:Dock(FILL)
        bollist.sheet.Navigation:SetWidth(self:GetWide() / 8)
        bollist.sheet.Navigation:DockMargin(ScreenScale(8), ScreenScale(8), ScreenScale(8), ScreenScale(8))
        bollist.sheet.Navigation.Paint = function(this, width, height)
        end

        bollist.sheet.bolPlayer = vgui.Create("DComboBox", bollist.sheet)
        bollist.sheet.bolPlayer:SetPos(5, 5)
        bollist.sheet.bolPlayer:SetSize(1446, 20)
        bollist.sheet.bolPlayer:SetValue("Select Citizen...")
        bollist.sheet.bolPlayer:SetSkin("Default")

        for v,k in pairs(player.GetAll()) do
            if not k:IsCP() and not k:IsDispatchBOL() then
                bollist.sheet.bolPlayer:AddChoice(k:Name(), k)
            end
        end

        bollist.sheet.bolCrime = vgui.Create("DComboBox", bollist.sheet)
        bollist.sheet.bolCrime:SetPos(5, 25)
        bollist.sheet.bolCrime:SetSize(1446, 20)
        bollist.sheet.bolCrime:SetValue("Select Conviction...")
        bollist.sheet.bolCrime:SetSkin("Default")

        for v,k in pairs(impulse.Config.ArrestCharges) do
            bollist.sheet.bolCrime:AddChoice(k.name, v)
        end

        bollist.sheet.bolAdd = vgui.Create("DButton", bollist.sheet)
        bollist.sheet.bolAdd:SetText("Add BOL")
        bollist.sheet.bolAdd:SetPos(5, 47)
        bollist.sheet.bolAdd:SetSize(1446, 20)

        function bollist.sheet.bolAdd:Think()
            if bollist.sheet.bolCrime:GetValue() == "Select Conviction..." or bollist.sheet.bolPlayer:GetValue() == "Select Citizen..." then
                self:SetDisabled(true)
            else
                self:SetDisabled(false)
            end
        end

        local xx = self

        function bollist.sheet.bolAdd:DoClick()
            local name, ply = bollist.sheet.bolPlayer:GetSelected()
            local charge, crime = bollist.sheet.bolCrime:GetSelected()

            if not IsValid(ply) and not ply:IsDispatchBOL() then
                return
            end

            local panel = Derma_Query("Please confirm that you wish to set the BOL status of "..name..".",
            "BOL ADD CONFIRMATION",
            "ADD BOL",
            function()
                net.Start("impulseHL2RPAddBOL")
                net.WriteEntity(ply)
                net.WriteUInt(crime, 8)
                net.SendToServer()

                xx:Remove()
            end,"CANCEL")
        end
            
        bollist.sheet.scrollPanel = vgui.Create("DScrollPanel", bollist.sheet)
        bollist.sheet.scrollPanel:SetPos(5, 67)
        bollist.sheet.scrollPanel:SetSize(1446, 800)
        
        for v,k in pairs(player.GetAll()) do
            if ( k:IsCP() ) then continue end
            
            local bol, crime = k:IsDispatchBOL()		
            if bol then
                local entry = bollist.sheet.scrollPanel:Add("impulseTerminalPlayer")
                entry:SetBOLPlayer(k, crime)
                entry:SetHeight(60)
                entry:Dock(TOP)
                
                entry.master = self
            end
        end
        
        local button = self.sheet:AddSheet("BOL List", bollist)
        button.Button:DockMargin(0, 0, 0, ScreenScale(4))
        button.Button:SizeToContents()
    end

    if ( ply:IsUUHigherRank() ) then 
        local socioStatuses = panel:Add("EditablePanel")
        socioStatuses:Dock(FILL)
    
        socioStatuses.sheet = socioStatuses:Add("DColumnSheet")
        socioStatuses.sheet:Dock(FILL)
        socioStatuses.sheet.Navigation:SetWidth(self:GetWide() / 8)
        socioStatuses.sheet.Navigation:DockMargin(ScreenScale(8), ScreenScale(8), ScreenScale(8), ScreenScale(8))
        socioStatuses.sheet.Navigation.Paint = function(this, width, height)
        end
    
        local socioStatusList = impulse.ci.socioStatus.list
        table.sort(socioStatusList, function(a, b)
            return a.sort > b.sort
        end)
    
        for k, v in SortedPairs(socioStatusList) do
            local button = socioStatuses.sheet:AddSheet(v.name, socioStatuses)
            button.Button:DockMargin(0, 0, 0, ScreenScale(4))
            button.Button:SizeToContents()
            button.Button:SetTextColor(v.color)
            button.Button.DoClick = function(this)
                net.Start("impulseHL2RPDispatchCityCode")
                    net.WriteString(k)
                net.SendToServer()
            end
        end
        local button = self.sheet:AddSheet("City Codes", socioStatuses)
        button.Button:DockMargin(0, 0, 0, ScreenScale(4))
        button.Button:SizeToContents()
    end
    
    if ( ply:IsUUHigherRank() ) then 
        local dispatchAnnouncements = panel:Add("EditablePanel")
        dispatchAnnouncements:Dock(FILL)

        dispatchAnnouncements.scrollPanel = vgui.Create("DScrollPanel", dispatchAnnouncements)
        dispatchAnnouncements.scrollPanel:Dock(FILL)
        dispatchAnnouncements.scrollPanel:DockMargin(ScreenScale(8), ScreenScale(8), ScreenScale(8), ScreenScale(8))

        for k, v in pairs(impulse.Config.DispatchLines) do
            local button = dispatchAnnouncements.scrollPanel:Add("DButton")
            button:Dock(TOP)
            button:DockMargin(0, 0, 0, ScreenScale(4))
            button:SizeToContents()
            button:SetText(v.name)
            button.DoClick = function(s)
                net.Start("impulseHL2RPDispatchAnnounce") -- Use the correct net message name
                    net.WriteUInt(k, 8)
                net.SendToServer()
            end
        end

        local button = self.sheet:AddSheet("Announcements", dispatchAnnouncements)
        button.Button:DockMargin(0, 0, 0, ScreenScale(4))
        button.Button:SizeToContents()
    end

    impulse.dvlTerminal = self
end

vgui.Register("dvlTerminal", PANEL, "DFrame")
