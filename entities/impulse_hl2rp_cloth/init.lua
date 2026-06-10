AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
 
include("shared.lua")

function ENT:SpawnFunction(ply, tr, cn)
	local ent = ents.Create(cn)
	ent:SetPos(tr.HitPos + tr.HitNormal)
	if math.random(1, 4) == 4 then
		ent:SetClothType(2)
	else 
		ent:SetClothType(1)
	end
	ent:SetClean(false)
	ent:Spawn()

	return ent
end

function ENT:Initialize()
	self:SetModel("models/props_junk/garbage_bag001a.mdl")

	if not self:GetClean() then
		self:SetMaterial("models/props_pipes/GutterMetal01a")
	else
		self:SetModel("models/props_junk/garbage_newspaper001a.mdl")
		self:SetMaterial("models/props_c17/FurnitureFabric003a")
	end

	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
 
    local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
	end
end