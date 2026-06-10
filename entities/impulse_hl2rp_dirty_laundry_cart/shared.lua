ENT.Type = "anim"
ENT.Base = "base_gmodentity"
 
ENT.PrintName = "Dirty Laundry Cart"
ENT.Author = "eon"
ENT.Category = "impulse: Laundry"
ENT.Contact = "none"
ENT.Spawnable = true
ENT.AdminSpawnable = true

ENT.HUDName = "Laundry Chute"
ENT.HUDDesc = "Dispenses laundry."

function ENT:SetupDataTables()
	self:NetworkVar("Float", 0, "ClothesNumber")
end