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

    local arrestProcedure = panel:Add("EditablePanel")
    arrestProcedure:Dock(FILL)
    arrestProcedure.Paint = function(this, width, height)

    end

    arrestProcedure.sentencebutton = arrestProcedure:Add("DButton")
    arrestProcedure.sentencebutton:SetText("ARREST (CHARGES: 0 | CYCLES: 0)")
    arrestProcedure.sentencebutton:SizeToContents()
    arrestProcedure.sentencebutton:Dock(BOTTOM)
    arrestProcedure.sentencebutton:DockMargin(ScreenScale(8), ScreenScale(8), ScreenScale(8), ScreenScale(8))

    arrestProcedure.sentencebutton.DoClick = function()
        local chargecount = 0
        local charges = {}
        local chargestimeoriginal = 0
        local chargestime = 0

        for k, v in pairs(self.setting) do
            table.insert(charges, k)
            chargestimeoriginal = chargestimeoriginal + impulse.Config.ArrestCharges[k].severity
            chargestime = 60 * impulse.Config.ArrestCharges[k].severity
            chargecount = chargecount + 1
        end

        if chargecount > 0 and chargecount < 5 then
            net.Start("impulseCitadelCombineTerminalCharge")
            net.WriteTable(charges)
            net.WriteUInt(chargestimeoriginal, 4)
            net.WriteUInt(chargestime, 12)
            net.SendToServer()
        else
            if chargecount > 4 then
                LocalPlayer():Notify("You cannot select too many charges!")
            elseif chargecount == 0 then
                LocalPlayer():Notify("You must at least select one reasonable charge!")
            end
        end

        surface.PlaySound("buttons/combine_button1.wav")
    end

    arrestProcedure.layout = arrestProcedure:Add("DScrollPanel")
    arrestProcedure.layout:Dock(FILL)
    arrestProcedure.layout:DockMargin(ScreenScale(8), ScreenScale(8), ScreenScale(8), ScreenScale(8))

    function arrestProcedure:AddCharge(chargeid, data)
        local chargesetting = arrestProcedure.layout:Add("DCheckBoxLabel")
        chargesetting:SetText(data.name)
        chargesetting:SizeToContents()
        chargesetting:Dock(TOP)
        chargesetting:DockMargin(4, 4, 1, 1)
        chargesetting.chargeID = chargeid

        chargesetting.OnChange = function(self, value)
            if value then
                panel.setting[self.chargeID] = value
            else
                panel.setting[self.chargeID] = nil
            end

            local chargecount = 0
            local timecount = 0

            for k, v in pairs(panel.setting) do
                timecount = timecount + impulse.Config.ArrestCharges[k].severity
                chargecount = chargecount + 1
            end

            arrestProcedure.sentencebutton:SetText("ARREST (CHARGES: " .. chargecount .. " | CYCLES: " .. math.Clamp(timecount, 0, 999) .. ")")
        end
    end

    for k, v in SortedPairs(impulse.Config.ArrestCharges) do
        arrestProcedure:AddCharge(k, v)
    end

    local button = self.sheet:AddSheet("Arrest Procedure", arrestProcedure)
    button.Button:DockMargin(0, 0, 0, ScreenScale(4))
    button.Button:SizeToContents()

    impulse.CombineTerminal = self
end

vgui.Register("impulseCombineTerminal", PANEL, "DFrame")
