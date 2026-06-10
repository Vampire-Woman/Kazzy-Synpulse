AddCSLuaFile()

DEFINE_BASECLASS("base_anim")

ENT.PrintName = "Combine Shipment"
ENT.Author = "Bloodmore"
ENT.Category = "Suppressed: Industrial Tech"

ENT.Spawnable = true
ENT.AdminOnly = true
ENT.AutomaticFrameAdvance = false
ENT.PhysgunPickupDisabled = false

function ENT:Initialize()
    if SERVER then
        self:SetModel("models/props_junk/wood_crate002a.mdl")
        self:SetMoveType(MOVETYPE_VPHYSICS)
        self:PhysicsInit(SOLID_VPHYSICS)
        self:SetSolid(SOLID_VPHYSICS)
		self:SetCollisionGroup( COLLISION_GROUP_PASSABLE_DOOR )

        local phys = self:GetPhysicsObject()
        if IsValid(phys) then
            phys:Wake()
        end

        self:SetHealth(50)
        self.iDeleteTime = CurTime() + 1200
        self.HeldBy = nil
    end
end

function ENT:Use(activator, caller)
    if not SERVER then return end
    if not IsValid(activator) or not activator:IsPlayer() then return end

    if self.HeldBy == activator then
        -- Drop object
        activator:DropObject()
        self.HeldBy = nil
    else
        -- Pick up object
        activator:PickupObject(self)
        self.HeldBy = activator
    end
end

function ENT:OnTakeDamage(dmg)
    if SERVER then
        local damage = dmg:GetDamage()
        self:SetHealth(self:Health() - damage)

        if self:Health() <= 0 then
            self:EmitSound("physics/wood/wood_box_break1.wav", 70)
            SafeRemoveEntity(self)
        end
    end
end

function ENT:Think()
    if not SERVER then return end

    -- Auto delete
    if self.iDeleteTime <= CurTime() then
        SafeRemoveEntity(self)
        return
    end

    -- Reset holder if invalid
    if self.HeldBy and not IsValid(self.HeldBy) then
        self.HeldBy = nil
    end

    self:NextThink(CurTime() + 1)
    return true
end

function ENT:Draw()
    self:DrawModel()
end