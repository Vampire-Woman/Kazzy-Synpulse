local colors = {
    ["white"] = Color(200, 200, 200),
    ["blue"] = Color(100, 160, 250),
    ["cyan"] = Color(0, 200, 200),
    ["yellow"] = Color(200, 200, 0),
    ["red"] = Color(250, 50, 50),
    ["orange"] = Color(250, 100, 0),
    ["green"] = Color(100, 250, 100),
}

local PANEL = {}

AccessorFunc(PANEL, "message", "Message")

function PANEL:Init()
    local ply = LocalPlayer()

    self:SetSize(ScrW() / 2, scrH / 3)
    self:MakePopup()
    self:Center()
    self.message = "Unknown Text"

    self.button = self:Add("impulseCombineButton")
    self.button:SetText("Continue")
    self.button:SizeToContents()
    self.button:Dock(BOTTOM)
    self.button:DockMargin(-ScreenScale(2), ScreenScale(4), ScreenScale(128), ScreenScale(2))
    self.button:SetContentAlignment(4)
    self.button.Paint = function(this, width, height)
    end
    self.button.DoClick = function(this)
        self:Remove()
    end

    self.label = self:Add("DLabel")
    self.label:SetText(self.message or "Unknown Text")
    self.label:SetTextColor(colors["white"])
    self.label:SetFont("DebugFixed")
    self.label:Dock(TOP)
    self.label:DockMargin(ScreenScale(6), ScreenScale(4), ScreenScale(128), ScreenScale(4))
    self.label:SetWrap(true)
    self.label:SetAutoStretchVertical(true)

    impulse.CombineMessage = self
end

function PANEL:SetMessage(message)
    self.message = message
    self.label:SetText(message)
end

function PANEL:Paint(width, height)
    impulse.ci.DrawCombineBox(0, 0, width, height, true)
end

vgui.Register("impulseCombineMessage", PANEL, "EditablePanel")

PANEL = {}

function PANEL:Init()
	self.Name = ""
	self.CID = ""
	self.IsBOL = false
	--self:SetCursor("hand")
	--self:SetTooltip("Left click to interact.")
end

function PANEL:SetPlayer(player, cell)
	self.Colour = team.GetColor(player:Team()) -- Store colour and name micro optomization, other things can be calculated on the go.
	self.Name = player:Nick()
	self.Player = player
	self.PlayerEntIndex = player:EntIndex()
	self.Cell = cell or nil

	local panel = self
	local xpnl = panel

	self.chargesBtn = vgui.Create("DButton", self)
	self.chargesBtn:SetPos(320, 5)
	self.chargesBtn:SetSize(115, 24)
	self.chargesBtn:SetText("VIEW CHARGES")
	self.chargesBtn:SetFont("DebugFixed")

	function self.chargesBtn:DoClick()
		net.Start("impulseHL2RPChargesRequest")
		net.WriteUInt(panel.PlayerEntIndex, 8)
		net.SendToServer()
	end

	self.editBtn = vgui.Create("DButton", self)
	self.editBtn:SetPos(320, 29)
	self.editBtn:SetSize(115, 24)
	self.editBtn:SetText("EDIT SENTENCE")
	self.editBtn:SetFont("DebugFixed")

	function self.editBtn:DoClick()
		local panel = Derma_StringRequest("EDIT CYCLES",
			"Enter the new sentence length in cycles below:\n*The new length will take affect from the original arrest time.",
			nil,
			function(time)
				time = tonumber(time)

				if not isnumber(time) then
					return LocalPlayer():Notify("Sentence must be a number.")
				end

				time = math.floor(time)

				if time < 1 then
					return LocalPlayer():Notify("Sentence too small.")
				end

				if time > (impulse.Config.MaxJailTime / 60) then
					return LocalPlayer():Notify("Sentence too large.")
				end

				local target = panel.Player

				if not IsValid(target) then
					return LocalPlayer():Notify("Target left the game.")
				end

				net.Start("impulseHL2RPChargesEdit")
				net.WriteUInt(time, 8)
				net.WriteUInt(target:EntIndex(), 8)
				net.SendToServer()

				xpnl.master:Remove()
			end,
			nil,
			"EDIT",
			"CLOSE")
		panel:SetSkin("combineSkin")
	end

 	self.modelIcon = vgui.Create("impulseSpawnIcon", self)
	self.modelIcon:SetPos(10,4)
	self.modelIcon:SetSize(52,52)
	self.modelIcon:SetModel(player:GetModel(), player:GetSkin())
	self.modelIcon:SetTooltip(false)
	self.modelIcon:SetDisabled(true)

	timer.Simple(0, function()
		if not IsValid(self) then
			return
		end

		local ent = self.modelIcon.Entity

		if IsValid(ent) and IsValid(self.Player) then
			for v,k in pairs(self.Player:GetBodyGroups()) do
				ent:SetBodygroup(k.id, self.Player:GetBodygroup(k.id))
			end
		end
	end)

	local staticOverlay = Material("effects/tvscreen_noise002a")
	staticOverlay:SetFloat("$salpha", "0.2")
	staticOverlay:Recompute()

	local greyCol = Color(100, 100, 100, 50)
	local outlineCol = Color(0, 0, 0, 180)

	function self.modelIcon:PaintOver(w, h) -- remove that mouse hover effect
		surface.SetDrawColor(greyCol)
		surface.DrawRect(0, 0, w, h)

		surface.SetDrawColor(outlineCol)
		surface.DrawOutlinedRect(0, 0, w, h)
	end

	local oldPaint = self.modelIcon.Paint 
	local background =  Material("impulse/hl2rp/background-photo.png")
	function self.modelIcon:Paint(w, h)
		surface.SetDrawColor(color_white)
		surface.SetMaterial(background)
		surface.DrawTexturedRect(0, 0, w, h)

		oldPaint(self, w, h)

		surface.SetMaterial(staticOverlay)
		surface.DrawTexturedRect(0, 0, w, h)
	end
end

function PANEL:SetBOLPlayer(player, crime)
	self.IsBOL = true

	self.Colour = team.GetColor(player:Team()) -- Store colour and name micro optomization, other things can be calculated on the go.
	self.Name = player:Nick()
	self.Player = player
	self.PlayerEntIndex = player:EntIndex()
	self.BOLCrime = crime

	local panel = self
	local xpnl = panel

	if LocalPlayer():IsUUHigherRank() then
		self.editBtn = vgui.Create("impulseCombineButton", self)
		self.editBtn:SetPos(1200, 0)
		self.editBtn:SetSize(245, 60)
		self.editBtn:SetText("REMOVE BOL")

		function self.editBtn:DoClick()
			local panel = Derma_Query("Please confirm that you wish to remove the BOL status of "..panel.Name..".",
				"BOL REMOVAL CONFIRMATION",
				"REMOVE BOL",
				function()
					net.Start("impulseHL2RPRemoveBOL")
					net.WriteEntity(player)
					net.SendToServer()

					xpnl.master:Remove()
				end,"CANCEL")
			panel:SetSkin("combineSkin")
		end
	end

 	self.modelIcon = vgui.Create("impulseSpawnIcon", self)
	self.modelIcon:SetPos(10,4)
	self.modelIcon:SetSize(52,52)
	self.modelIcon:SetModel(player:GetModel(), player:GetSkin())
	self.modelIcon:SetTooltip(false)
	self.modelIcon:SetDisabled(true)

	timer.Simple(0, function()
		if not IsValid(self) then
			return
		end

		local ent = self.modelIcon.Entity

		if IsValid(ent) and IsValid(self.Player) then
			for v,k in pairs(self.Player:GetBodyGroups()) do
				ent:SetBodygroup(k.id, self.Player:GetBodygroup(k.id))
			end
		end
	end)

	local staticOverlay = Material("effects/tvscreen_noise002a")
	staticOverlay:SetFloat("$salpha", "0.2")
	staticOverlay:Recompute()

	local greyCol = Color(100, 100, 100, 50)
	local outlineCol = Color(0, 0, 0, 180)

	function self.modelIcon:PaintOver(w, h) -- remove that mouse hover effect
		surface.SetDrawColor(greyCol)
		surface.DrawRect(0, 0, w, h)

		surface.SetDrawColor(outlineCol)
		surface.DrawOutlinedRect(0, 0, w, h)
	end

	local oldPaint = self.modelIcon.Paint 
	local background =  Material("impulse/hl2rp/background-photo.png")
	function self.modelIcon:Paint(w, h)
		surface.SetDrawColor(color_white)
		surface.SetMaterial(background)
		surface.DrawTexturedRect(0, 0, w, h)

		oldPaint(self, w, h)

		surface.SetMaterial(staticOverlay)
		surface.DrawTexturedRect(0, 0, w, h)
	end
end

local darkCol = Color(39, 60, 117, 130)
local outlineCol = Color(0, 0, 0, 180)

function PANEL:Paint(w,h)
	-- Frame
	impulse.Draw.Blur(self)
    
    surface.SetDrawColor(outlineCol)
    surface.DrawRect(0, 0, w, h)

 	surface.SetTextColor(color_white)
 	surface.SetFont("DebugFixed")

 	surface.SetTextPos(70, 0)
 	surface.DrawText("NAME: "..self.Name)


 	if self.IsBOL and self.BOLCrime then
 		surface.SetTextPos(70, 35)
 		surface.DrawText("CONVICTION: "..impulse.Config.ArrestCharges[self.BOLCrime].name)
 		return
 	end

 	surface.SetTextPos(70, 17)
 	surface.DrawText("CYCLES ISSUED: "..self.convictData.cycles)

 	local timeLeft = self.convictData.endTime - CurTime()

 	if timeLeft <= 0 then
 		self:Remove()
 	else
	 	surface.SetTextPos(70, 27)
	 	surface.DrawText("SENTENCE REMAINING: "..string.FormattedTime(timeLeft, "%02i:%02i"))
	 end

 	if self.Cell then
  		surface.SetTextPos(70, 37)
 		surface.DrawText("CELL: "..self.convictData.cell)
 	end
end

vgui.Register("impulseTerminalPlayer", PANEL, "DPanel")