ENT.Type = "anim"
ENT.Base = "base_gmodentity"
 
ENT.PrintName = "Cloth"
ENT.Author = "eon"
ENT.Category = "impulse: Laundry"
ENT.Spawnable = true
ENT.AdminSpawnable = true

ENT.HUDName = "Laundry"
ENT.HUDDesc = "A piece of worn cloth."

function ENT:SetupDataTables()
	self:NetworkVar("Bool", 0, "Clean")
	self:NetworkVar("Float", 1, "ClothType") -- 1 = prisonnier, 2 = garde

	if SERVER then
		self:NetworkVarNotify("Clean", self.OnClothChangeState)
	end
end
