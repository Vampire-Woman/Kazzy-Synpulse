AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
 
include("shared.lua")

function ENT:SpawnFunction(ply, tr, cn)
	local ang = ply:GetAngles()
	local ent = ents.Create(cn)
	ent:SetPos(tr.HitPos + tr.HitNormal + Vector(0,0,40))
	ent:SetAngles(Angle(0, ang.y, 0) - Angle(0, 90, 0))
	ent:Spawn()

	return ent
end

function ENT:Initialize()
	self:SetModel("models/props_pipes/pipe03_90degree01.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)

	self:SetUseType(SIMPLE_USE)

	self:SetClothesNumber(0)
 
    local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
	end
end

function ENT:Use(act, cal)
	if ( ( cal.nextLaundryUse or 0 ) > CurTime() ) then return end
    cal.nextLaundryUse = CurTime() + 1
	
	if not ( cal:Team() == TEAM_CITIZEN and cal:GetTeamClass() == CLASS_CWU_INDUSTRIAL ) then return cal:Notify("You must be a CWU Industrial Worker to interact with this entity!") end

	if self:GetClothesNumber() >= impulse.Config.DirtyCartMaxCloth then return end

	local pos = self:LocalToWorld(self:OBBCenter())
	local ang = self:GetAngles()

	local cloth = ents.Create("impulse_hl2rp_cloth")
	if not cloth:IsValid() then return end
	cloth:SetPos(pos + (ang:Right() * 30))
	cloth:SetAngles(self:GetAngles())
	if math.random(1, 4) == 4 then
		cloth:SetClothType(2)
	else
		cloth:SetClothType(1)
	end
	cloth:SetClean(false)
	cloth:Spawn()
	self:EmitSound("ambient/machines/catapult_throw.wav")

	if ( IsValid(self) and IsValid(cloth) ) then
		cloth.OnRemove = function()
			self:SetClothesNumber(self:GetClothesNumber() - 1)
		end
	end

    cal:Notify("You have dispensed dirty laundry.")

	self:SetClothesNumber(self:GetClothesNumber() + 1)
	cal.nextUse = CurTime() + 5
end

function ENT:Think()
	return true
end

function ENT:OnRemove()
	if timer.Exists("AddClothTimer"..self:EntIndex()) then
		timer.Remove("AddClothTimer"..self:EntIndex())
	end
end