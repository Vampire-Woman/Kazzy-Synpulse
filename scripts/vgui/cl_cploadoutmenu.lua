surface.CreateFont("combfont", {
    font = "Combine_Alphabet1",
    weight = 0,
    size = 10,
    outline = true
})

surface.CreateFont("combfontbig", {
    font = "Combine_Alphabet1",
    weight = 0,
    size = 20,
    outline = true
})

surface.CreateFont("combfontmed", {
    font = "Combine_Alphabet1",
    weight = 0,
    size = 15,
    outline = true
})

surface.CreateFont("ocra", {
    font = "OCR A Extended",
    size = 17,
    weight = 800,
    outline = true
})

surface.CreateFont("ocrasmall", {
    font = "OCR A Extended",
    size = 14,
    weight = 800,
    outline = true
})

local PANEL = {}

local SCredits = 0
local totalSCredits = 0

local optionCosts = {
    option1 = 0,
    option2 = 0,
    option3 = 0,
    option4 = 0,
    option5 = 0,
    option6 = 0
}

-- WORKING ASCII (UNCHANGED)
local astring1 = "???????????????0??????????????????????????????????\n??????????????????000?????????????????????????????\n????????????????????00000?????????????????????????\n??????????????????????00000000????????????????????\n?????????????????????????0000000000???????????????\n???????????????????????????000000000000???????????\n?0????????????????????????????00000000000000??????\n??0???????????????????????????????00000000000000??\n???000????????????????????????????????000000000000\n????0000???????????????0000000000000????0000000000\n?????00000???????????00000000000000000????00000000\n???????000000???????0000000000000000000???00000000\n????????0000000?????00000000000000000000????000000\n?????????00000000???00000000000000000000????000000\n??????????0000000???0000000000000000000????0000000\n???????????0000000????0000000000000000?????0000000\n??__________?0_00000????0_0____0000????????0000000\n??__________?0__00000???__?____00?????????00000000\n??__________??___0____0__??____?______000000000000\n??__??????????___0____0__00____???00__000000000000\n??________????___00000___00____00____0000000000000\n??__________??___?0000___00____0_____0000000000000\n???????????????????0000000000000000000000000000000\n"

local astring2 = "??_______/     /_00000????0_0__0      0????????0000000\n??______/     /0__00000???__?___?      ???????00000000\n??_____/___/_?___0____0__??___?_______|00000000000\n??__??????????___0____0__00____???00__000000000000\n??________????___00000___00____00____0000000000000\n??__________??___?0000___00____0_____0000000000000\n???????????????????0000000000000000000000000000000\n"

-- ===============================
-- INIT
-- ===============================

function PANEL:Init()
    self:SetSize(600, 400)
    self:Center()
    self:SetTitle(" ")
    self:SetSkin("combinesSkin")
    self:MakePopup()

    if LocalPlayer():Team() == TEAM_CP then
        self:CreateInitialChoice()  -- Only for CP
    else
        self:CreatePasswordScreen() -- For all other teams
    end
end

-- ===============================
-- PASSWORD SCREEN
-- ===============================

function PANEL:CreatePasswordScreen()

    self.ascii = vgui.Create("RichText", self)
    self.ascii:SetPos(280, 80)
    self.ascii:SetSize(450, 450)

    self.ascii2 = vgui.Create("RichText", self)
    self.ascii2:SetPos(280, 288)
    self.ascii2:SetSize(450, 450)

    self.titleText = vgui.Create("DLabel", self)
    self.titleText:SetPos(23, 55)
    self.titleText:SetSize(250, 35)
    self.titleText:SetText("ENTER PASSWORD")
	self.titleText:SetFont("combfont")

    self.textBox = vgui.Create("DTextEntry", self)
    self.textBox:SetPos(20, 82)
    self.textBox:SetSize(250, 25)
    self.textBox:SetText("")

    self.textBox.LastKeySound = 0

    self.textBox.OnKeyCodeTyped = function()
        if CurTime() < self.textBox.LastKeySound then return end
        self.textBox.LastKeySound = CurTime() + 0.1

        LocalPlayer():EmitSound(
            "ambient/machines/keyboard" .. math.random(2, 4) .. "_clicks.wav",
            75,
            math.random(95, 100),
            0.2
        )
    end
	
    self.nextButton = vgui.Create("DButton", self)
    self.nextButton:SetPos(40, 125)
    self.nextButton:SetSize(200, 40)
    self.nextButton:SetText("LOGN")
	self.nextButton:SetFont("combfontbig")

	self.nextButton.DoClick = function()

		local entered = self.textBox:GetText()
		local nick = LocalPlayer():Nick()
		local ply = LocalPlayer()

		-- Prevent empty input
		if entered == "" or string.Trim(entered) == "" then
			surface.PlaySound("buttons/combine_button_locked.wav")
			LocalPlayer():Notify("Password cannot be empty.")
			return
		end
		
		if ply:GetXP() < 100 and not ply:IsAdmin() then
			surface.PlaySound("buttons/combine_button_locked.wav")
			LocalPlayer():Notify("Invalid password.")
			return
		end		

		-- Must match player's nick in uppercase
		if entered ~= string.upper(nick) then
			surface.PlaySound("buttons/combine_button_locked.wav")
			LocalPlayer():Notify("Invalid password.")
			return
		end

		surface.PlaySound("ambient/levels/citadel/pod_open1.wav")
		net.Start("impulseTeamChange")
        net.WriteUInt(TEAM_CP, 8)
        net.SendToServer()

		self.ascii:Remove()
		self.ascii2:Remove()
		self.titleText:Remove()
		self.textBox:Remove()
		self.nextButton:Remove()

		self:CreateInitialChoice()
	end
end

-- ===============================
-- ASCII ANIMATION (EXACT WORKING LOGIC)
-- ===============================

function PANEL:Think()

    if not IsValid(self.ascii) or not IsValid(self.ascii2) then return end

	local results = math.random(1, 256)
    if results == 255 then
        LocalPlayer():EmitSound("ambient/levels/prison/radio_random" .. math.random(1, 9) .. ".wav", 100, 100, 0.2)
    end

    local ustring1 = string.SetChar(astring1, math.random(1, string.len(astring1)), "   ")
    local ustring2 = string.SetChar(astring2, math.random(1, string.len(astring2)), "   ")

    self.ascii:SetText(ustring1)
    self.ascii2:SetText(ustring2)

end

-- ===============================
-- LOGIN / LOGOUT
-- ===============================

function PANEL:CreateInitialChoice()

    self.signUpButton = vgui.Create("DButton", self)
    self.signUpButton:SetSize(200, 50)
    self.signUpButton:SetPos(self:GetWide() / 2 - 100, 140)
    self.signUpButton:SetText("HOME")
	self.signUpButton:SetFont("combfontbig")

    self.signUpButton.DoClick = function()

		surface.PlaySound("buttons/combine_button1.wav")

        self.signUpButton:Remove()
        self.signOutButton:Remove()

		self:CreateHomePage()
    end

    self.signOutButton = vgui.Create("DButton", self)
    self.signOutButton:SetSize(200, 50)
    self.signOutButton:SetPos(self:GetWide() / 2 - 100, 200)
    self.signOutButton:SetText("LOGOUT")
	self.signOutButton:SetFont("combfontbig")

    self.signOutButton.DoClick = function()
		surface.PlaySound("ambient/levels/citadel/pod_close1.wav")
        net.Start("impulseTeamChange")
        net.WriteUInt(TEAM_CITIZEN, 8)
        net.SendToServer()

        self:Remove()
    end
end

-- ===============================
-- NEW HOME PAGE
-- ===============================

function PANEL:CreateHomePage()
	local name = LocalPlayer():Nick()

    self.homeTitle = vgui.Create("DLabel", self)
    self.homeTitle:SetPos(-103, 365)
    self.homeTitle:SetSize(self:GetWide(), 40)
    self.homeTitle:SetText("Reminder, 100 sterilized credits qualifies\nfor Non-Mechanical Reproduction Simulation.")
    self.homeTitle:SetFont("ocrasmall")
    self.homeTitle:SetContentAlignment(5)
	
    self.backTitle = vgui.Create("DLabel", self)
    self.backTitle:SetPos(0, 100)
    self.backTitle:SetSize(self:GetWide(), 40)
    self.backTitle:SetText("Welcome back, " .. name .. " ")
    self.backTitle:SetFont("ocrasmall")
    self.backTitle:SetContentAlignment(5)	

    self.loadoutButton = vgui.Create("DButton", self)
    self.loadoutButton:SetSize(440, 50)
    self.loadoutButton:SetPos(self:GetWide() / 2 - 220, 140)
    self.loadoutButton:SetText("CHECK QUALIFY")
    self.loadoutButton:SetFont("combfontbig")

	self.loadoutButton.DoClick = function()

		surface.PlaySound("buttons/combine_button1.wav")
		surface.PlaySound("ambient/levels/citadel/pod_close1.wav")

		-- Become citizen first
		net.Start("impulseTeamChange")
		net.WriteUInt(TEAM_CITIZEN, 8)
		net.SendToServer()

		-- Wait before changing to CP
		timer.Simple(1, function()

			if not IsValid(LocalPlayer()) then return end

			surface.PlaySound("ambient/levels/citadel/pod_open1.wav")

			net.Start("impulseTeamChange")
			net.WriteUInt(TEAM_CP, 8)
			net.SendToServer()

		end)

		self.backTitle:Remove()
		self.homeTitle:Remove()
		self.loadoutButton:Remove()
	end
end

vgui.Register("cpLoadoutMenu", PANEL, "DFrame")
