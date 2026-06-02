local PANEL = {}

function PANEL:Init()
    surface.PlaySound("impulse_citadel/music/a2_hideout_puzzle1.mp3")
	
    impulse.MainMenu = self
    impulse.hudEnabled = false
	
    -- rest of code underneath

    self:SetPos(0, 0)
    self:SetSize(ScrW(), ScrH())
    self:MakePopup()
    self:SetPopupStayAtBack(true)

    local panel = self

    -- Core background panel
    self.core = vgui.Create("DPanel", self)
    self.core:SetPos(0, 0)
    self.core:SetSize(ScrW(), ScrH())

    local bodyCol = Color(0, 255, 0, 255)
    function self.core:Paint(w, h)
        surface.SetDrawColor(bodyCol)
        impulse.render.glowgo(100, 50, 337, 91)
    end

    -- Materials
    local MAT_PLAY_BUTTON = Material("mrp/menu_stuff/button_play.png")
	local MAT_SKIP_BUTTON = Material( "mrp/ui/character_customization/skip_button.png")
    local MAT_LOGO = Material("logos/syn_bannerlogo.png", "noclamp smooth")
    local MAT_BACKGROUND = Material("overlays/hls_background_grunge.png", "noclamp smooth")
	local OTHER_LOGO = Material("impulse/impulse-logo-white.png", "noclamp smooth")

    local highlightCol = Color(impulse.Config.MainColour.r, impulse.Config.MainColour.g, impulse.Config.MainColour.b)

    -- Play Button
	local playButton = vgui.Create("DButton", self.core)
	playButton:SetSize(256, 128)

	local centerX = (ScrW() - 256) / 2
	local centerY = (ScrH() - -56) / 2
	playButton:SetPos(centerX, centerY)

	playButton:SetText("")

    function playButton:Paint(w, h)
        if MAT_PLAY_BUTTON:IsError() then return end
        surface.SetDrawColor(255, 255, 255, 255)
        surface.SetMaterial(MAT_PLAY_BUTTON)
        surface.DrawTexturedRect(0, 0, w, h)

		if self:IsHovered() then
			local texW, texH = 207, 32
			local texX = (self:GetWide() - texW) / 2
			local texY = (self:GetTall() - texH) / 2
			surface.SetDrawColor(56, 56, 56, 50)
			surface.DrawRect(texX, texY, texW, texH)  -- draw hover exactly over texture
		end
    end

    function playButton:OnCursorEntered()
        surface.PlaySound("ui/buttonrollover.wav")
    end

    function playButton:DoClick()
        surface.PlaySound("ui/buttonclickrelease.wav")
        Derma_Query(
            "You are not subscribed to the impulse framework content!\nIf you do not subscribe you will experience missing textures and errors.\nAfter subscribing, rejoin the server.",
            "impulse",
            "No thanks", function()
                surface.PlaySound("ui/buttonclickrelease.wav")
                timer.Simple(0.3, function()
                    if IsValid(LocalPlayer()) then
                        LocalPlayer():ConCommand("stopsound")
                    end
                end)

                if impulse_isNewPlayer == true then
                    vgui.Create("impulseCharacterCreator", panel)
                elseif not impulse.MainMenu.popup then
                    LocalPlayer():ScreenFade(SCREENFADE.IN, color_black, 10, 0)
                    impulse.MainMenu:AlphaTo(0, 0)
                    timer.Simple(0, function()
                        LocalPlayer():ScreenFade(SCREENFADE.IN, color_black, 0, 0)
                        panel:Remove()
                        impulse.hudEnabled = true
                        FORCE_FADESPAWN = true
                    end)
                else
                    panel:Remove()
                    impulse.hudEnabled = true
                end

                CRASHSCREEN_ALLOW = true
            end,
            "Subscribe", function()
                surface.PlaySound("ui/buttonclickrelease.wav")
            end
        )
    end

	local skipButton = vgui.Create("DButton", self.core)
	skipButton:SetSize(256, 128)

	-- Center horizontally, below play button
	local skipX = (ScrW() - 256) / 2
	local skipY = skipX + -60
	skipButton:SetPos(skipX, skipY)

	skipButton:SetText("")

	function skipButton:Paint(w, h)
		if MAT_SKIP_BUTTON:IsError() then return end
		surface.SetDrawColor(255, 255, 255, 0)
		surface.SetMaterial(MAT_SKIP_BUTTON)
		surface.DrawTexturedRect(0, 0, w, h)

		if self:IsHovered() then
			local texW, texH = 207, 32
			local texX = (self:GetWide() - texW) / 2
			local texY = (self:GetTall() - texH) / 2
			surface.SetDrawColor(255, 255, 255, 0)
			surface.DrawRect(texX, texY, texW, texH)  -- draw hover exactly over texture
		end
    end

	function skipButton:OnCursorEntered()
		surface.PlaySound("ui/buttonrollover.wav")
	end

    function skipButton:DoClick()
        surface.PlaySound("ui/buttonclickrelease.wav")
        vgui.Create("impulseSettings", panel)
    end

    -- Leave Button
    local leaveButton = vgui.Create("DButton", self.core)
    leaveButton:SetPos(900, ScrH() - 200)
    leaveButton:SetFont("BudgetLabel")
    leaveButton:SetText("")
    leaveButton:SizeToContents()

    local leaveHighlight = Color(240, 0, 0)
    function leaveButton:Paint()
        if self:IsHovered() then
            self:SetColor(leaveHighlight)
        else
            self:SetColor(color_white)
        end
    end

    function leaveButton:OnCursorEntered()
        surface.PlaySound("ui/buttonrollover.wav")
    end

    function leaveButton:DoClick()
        LocalPlayer():ConCommand("disconnect")
    end

    -- Logo Panel
    local logoPanel = vgui.Create("DPanel", self.core)
    logoPanel:SetSize(1024, 256)
    logoPanel:SetPos((ScrW() - 1024) / 2, 338)
    logoPanel.Paint = function(this, w, h)
        if MAT_LOGO:IsError() then return end
        surface.SetDrawColor(255, 255, 255, 255)
        surface.SetMaterial(MAT_LOGO)
        surface.DrawTexturedRect(0, 0, w, h)
    end
	
    -- Messages and first-load hooks
    local function testMessage()
        hook.Run("ShowMenuModalMessage", self)
    end

    timer.Simple(0, function()
        if impulse.MainMenu.popup then return end
        hook.Run("OnMenuFirstLoad", self)

        if REFUND_MSG then
            Derma_Message(REFUND_MSG, "impulse", "Claim Refund")
        end

        if steamworks.IsSubscribed("3010264401") then
            Derma_Query(
                "You are not subscribed to the impulse framework content!\nIf you do not subscribe you will experience missing textures and errors.\nAfter subscribing, rejoin the server.",
                "impulse",
                "Subscribe", function()
                    gui.OpenURL("https://steamcommunity.com/sharedfiles/filedetails/?id=3010264401")
                end,
                "Cancel"
            )
        end

        if impulse.GetSetting("perf_mcore") == false then
            Derma_Query(
                "Would you like to enable Multi-core rendering?\nThis will often greatly improve your FPS, however if your computer has a low core count and/or\na small amount of RAM, it can cause crashes and performance problems.",
                "impulse",
                "Enable Multi-core rendering", function()
                    impulse.SetSetting("perf_mcore", true)
                    testMessage()
                end,
                "No thanks"
            )
        else
            testMessage()
        end
    end)
end

-- Override Remove to hide instead of destroy
function PANEL:Remove()
    self:SetVisible(false)
end

-- Keep track of child panels
function PANEL:OnChildAdded(child)
    if self.AddingMsgs then return end
    if IsValid(self.openElement) then
        self.openElement:Remove()
    end
    self.openElement = child
end

-- Background paint
local MAT_BACKGROUND = Material("overlays/hls_background_grunge.png", "noclamp smooth")
function PANEL:Paint(w, h)
    if MAT_BACKGROUND:IsError() then
        surface.SetDrawColor(0, 0, 0, 255)
        surface.DrawRect(0, 0, w, h)
        return
    end

    surface.SetDrawColor(200, 200, 200, 255)
    surface.SetMaterial(MAT_BACKGROUND)
    surface.DrawTexturedRect(0, 0, w, h)
end

vgui.Register("impulseMainMenu", PANEL, "DPanel")