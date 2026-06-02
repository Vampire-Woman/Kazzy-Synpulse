ENT.Type = "anim"
ENT.Base = "base_gmodentity"
 
ENT.PrintName = "Clean Laundry Cart"
ENT.Author = "eon"
ENT.Category = "impulse: Laundry"
ENT.Spawnable = true
ENT.AdminOnly = true

ENT.HUDName = "Laundry Basket"
ENT.HUDDesc = "Basket full of clean laundry."

function ENT:SetupDataTables()
	self:NetworkVar("Float", 0, "ClothesNumber")
end