include('shared.lua')

	local draw_SimpleText = draw.SimpleText
	local glowMaterial = Material("sprites/glow04_noz")

	local color_green = Color(0, 255, 0, 255)
	local color_red = Color(255, 0, 0, 255)
	local color_orange = Color(255, 125, 0, 255)

	function ENT:Initialize()
		self.buttons = {}

		local position = self:GetPos()
		local f, r, u = self:GetForward(), self:GetRight(), self:GetUp()

		self.buttons[1] = position + f*18 + r*-24.7 + u*4
	end

	function ENT:OnRemove()
		if ( self.sound ) then
			self.sound:Stop()
		end
	end

	function ENT:Draw()
		self:DrawModel()

		if not ( self.sound ) then
			self.sound = CreateSound(self, "ambient/waterrun.wav")
		elseif not ( self.sound:IsPlaying() ) then
			self.sound:PlayEx(5, 30)
		end

		if not ( LocalPlayer():IsLineOfSightClear(self:GetPos()) ) then
			return
		end
	
		local position = self:GetPos()
		local angles = self:GetAngles()

		angles:RotateAroundAxis(angles:Up(), 90)
		angles:RotateAroundAxis(angles:Forward(), 90)
	
		local f, r, u = self:GetForward(), self:GetRight(), self:GetUp()

        local dlight = DynamicLight(self:EntIndex())
        if ( dlight ) then
            dlight.pos = position + f * 32 + u * 8
            dlight.r = 0
            dlight.g = 102
            dlight.b = 255
            dlight.brightness = 1
            dlight.Decay = 1
            dlight.Size = 512
            dlight.DieTime = CurTime() + 2
        end

		local position = self:GetPos()
		local angles = self:GetAngles()
		angles:RotateAroundAxis(angles:Up(), 90)
		angles:RotateAroundAxis(angles:Forward(), 90)

		local f, r, u = self:GetForward(), self:GetRight(), self:GetUp()

		cam.Start3D2D(position + f*17.5 + r*-19.5 + u*6, angles, 0.06)
			draw_SimpleText("Water", "synChatFont", 5, 0, color_white, 0, 0)
			--draw_SimpleText("Canned Water", "synChatFont", -3, 48, color_white, 0, 0)
			--draw_SimpleText("Water Jug", "synChatFont", 0, 84, color_white, 0, 0)
		cam.End3D2D()

		render.SetMaterial(glowMaterial)

		if (self.buttons) then
			self.buttons[1] = position + f*17.5 + r*-24.35 + u*5.25

			local closest = self:getNearestButton()
			local stocks = util.JSONToTable(self:GetStocks());

			for k, v in pairs(self.buttons) do
				local color = color_green

				if (self:GetActive()) then
					if (stocks and stocks[k] and stocks[k] < 1) then
						color = color_red
						color.a = 200
					end

					if (closest != k) then
						color.a = color == color_red and 100 or 75
					else
						color.a = 230 + (math.sin(RealTime() * 7.5) * 25)
					end

					if (LocalPlayer():KeyDown(IN_USE) and closest == k) then
						color = table.Copy(color)
						color.r = math.min(color.r + 100, 255)
						color.g = math.min(color.g + 100, 255)
						color.b = math.min(color.b + 100, 255)
					end
				else
					color = color_orange
				end

				render.DrawSprite(v, 5, 5, color)
			end
		end
	end