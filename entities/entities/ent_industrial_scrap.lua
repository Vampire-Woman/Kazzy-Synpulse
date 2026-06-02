AddCSLuaFile()

DEFINE_BASECLASS("base_anim")

ENT.PrintName = "Industrial Scrap"
ENT.Author = "Bloodmore"
ENT.Category = "Suppressed: Industrial Tech"

ENT.Spawnable = true
ENT.AdminOnly = true
ENT.AutomaticFrameAdvance = false
ENT.PhysgunPickupDisabled = false

function ENT:Initialize()
	if SERVER then

        local models = {
            "models/gibs/metal_gib1.mdl",
            "models/gibs/metal_gib5.mdl",
            "models/props_junk/wood_crate001a_chunk05.mdl",
            "models/props_junk/wood_crate001a_chunk06.mdl"
        }

        local randomModel = models[ math.random( #models ) ]

        self:SetModel(randomModel)
        self:SetMoveType(MOVETYPE_VPHYSICS)
        self:PhysicsInit(SOLID_VPHYSICS)
        self:SetSolid(SOLID_VPHYSICS)
        self:SetCollisionGroup( COLLISION_GROUP_PASSABLE_DOOR )

        local vPhys = self:GetPhysicsObject()
        if IsValid(vPhys) then
            vPhys:Wake()
        end

        self.HeldBy = nil
        self.iDeleteTime = CurTime() + 300
	end
end

function ENT:Use(activator, caller)
    if not SERVER then return end
    if not IsValid(activator) or not activator:IsPlayer() then return end

    if self.HeldBy == activator then
        activator:DropObject()
        self.HeldBy = nil
    else
        activator:PickupObject(self)
        self.HeldBy = activator
    end
end

function ENT:Think()
    if not SERVER then return end

    if self.iDeleteTime <= CurTime() then
        SafeRemoveEntity(self)
        return
    end

    if self.HeldBy and not IsValid(self.HeldBy) then
        self.HeldBy = nil
    end

    self:NextThink(CurTime() + 1)
    return true
end

function ENT:Draw()
	self:DrawModel()
end