AddCSLuaFile()

DEFINE_BASECLASS("base_anim")

ENT.PrintName = "Oil Cannister"
ENT.Author = "Bloodmore"
ENT.Category = "Suppressed: Industrial Tech"

ENT.Spawnable = true
ENT.AdminOnly = true
ENT.AutomaticFrameAdvance = false
ENT.PhysgunPickupDisabled = false

function ENT:Initialize()
    if SERVER then
        self:SetModel("models/props_junk/gascan001a.mdl")
        self:SetMoveType(MOVETYPE_VPHYSICS)
        self:PhysicsInit(SOLID_VPHYSICS)
        self:SetSolid(SOLID_VPHYSICS)
        self:SetCollisionGroup(COLLISION_GROUP_PASSABLE_DOOR)

        local vPhys = self:GetPhysicsObject()
        if vPhys:IsValid() then
            vPhys:Wake()
        end

        self:SetHealth(25)
        self.iDeleteTime = CurTime() + 480
    end
end

function ENT:OnTakeDamage(dmg)
    if SERVER then
        local damage = dmg:GetDamage()
        self:SetHealth(self:Health() - damage)

        if self:Health() <= 0 then
            self.bCreateExplosion = true
            SafeRemoveEntity( self )
        end
    end
end

function ENT:OnRemove()
    if SERVER then
        if self.bCreateExplosion then
            self:CreateExplosion()
        end
    end
end

function ENT:CreateExplosion()
    local explosion = ents.Create("env_explosion")
    explosion:SetPos(self:GetPos())
    explosion:Spawn()
    explosion:SetKeyValue("iMagnitude", "3")
    explosion:SetKeyValue("spawnflags", 32)
    explosion:Fire("Explode", 0, 0)
    
    self:EmitSound("ambient/fire/gascan_ignite1.wav", 100, 100)
end

function ENT:Think()
    if not SERVER then return end
    if self.iDeleteTime > CurTime() then return end

    SafeRemoveEntity( self )
    self:NextThink( CurTime() + 1 )
end

if not CLIENT then return end

function ENT:Draw()
	self:DrawModel()
end