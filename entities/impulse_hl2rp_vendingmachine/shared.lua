ENT.Type = "anim"
ENT.Base = "base_anim" 
ENT.PrintName = "Vending Machine"
ENT.Author = "Bloodmore"
ENT.Category = "Suppressed: Citizen Tech"
ENT.Spawnable = true
ENT.AdminOnly = true

function ENT:SetupDataTables()

	self:NetworkVar( "String", 0, "Stocks" )
	self:NetworkVar( "Float", 1, "Active" )
end

function ENT:getNearestButton(client)
	client = client or (CLIENT and LocalPlayer())

	if (self.buttons) then
		if (SERVER) then
			local position = self:GetPos()
			local f, r, u = self:GetForward(), self:GetRight(), self:GetUp()

			self.buttons[1] = position + f*18 + r*-24.7 + u*4
		end

		local data = {}
			data.start = client:GetShootPos()
			data.endpos = data.start + client:GetAimVector()*96
			data.filter = client
		local trace = util.TraceLine(data)
		local hitPos = trace.HitPos

		if (hitPos) then
			for k, v in pairs(self.buttons) do
				if (v:Distance(hitPos) <= 2) then
					return k
				end
			end
		end
	end
end