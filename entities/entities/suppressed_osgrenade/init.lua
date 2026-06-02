AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

function ENT:Initialize()
    self:SetModel("models/Items/grenadeammo.mdl")

    if SERVER then
        self:PhysicsInit(SOLID_VPHYSICS)
        self:SetMoveType(MOVETYPE_VPHYSICS)
        self:SetSolid(SOLID_VPHYSICS)
        self:SetUseType(SIMPLE_USE)
        self:Activate()

        local phys = self:GetPhysicsObject()
        if IsValid(phys) then
            phys:Wake()
        end


        self.ExplodeTime = CurTime() + 5

        self:EmitSound("weapons/grenade/tick1.wav", 75, 100)

        timer.Simple(1, function()
            self:EmitSound("weapons/grenade/tick1.wav", 75, 100)
        end)

        timer.Simple(2, function()
            self:EmitSound("weapons/grenade/tick1.wav", 75, 100)
        end)

        timer.Simple(2.8, function()
            self:EmitSound("weapons/grenade/tick1.wav", 75, 100)
        end)

        timer.Simple(3.5, function()
            self:EmitSound("weapons/grenade/tick1.wav", 75, 100)
        end)

        timer.Simple(4, function()
            self:EmitSound("weapons/grenade/tick1.wav", 75, 100)
        end)

        timer.Simple(4.5, function()
            self:EmitSound("weapons/grenade/tick1.wav", 75, 100)
        end)

        timer.Simple(4.8, function()
            self:EmitSound("weapons/grenade/tick1.wav", 75, 100)
        end)

        util.SpriteTrail(self, 0, Color(255, 0, 0), false, 15, 1, 1, 0.1, "trails/laser.vmt")
    end

    self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
end

function ENT:Explode()
    if SERVER then
        local explosionPos = self:GetPos()

        util.BlastDamage(self, self:GetOwner(), explosionPos, 400, 100)
        util.ScreenShake(explosionPos, 1, 1, 2, 500)

        local effectdata = EffectData()
        effectdata:SetOrigin(explosionPos)
        util.Effect("Explosion", effectdata)

        self:EmitSound("ambient/explosions/explode_" .. math.random(1, 4) .. ".wav", 100, 100)

        self:Remove()
    end
end

function ENT:Think()
    if SERVER and CurTime() >= self.ExplodeTime then
        self:Explode()
    end
    self:NextThink(CurTime())
    return true
end