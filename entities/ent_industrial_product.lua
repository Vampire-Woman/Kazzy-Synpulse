AddCSLuaFile()

DEFINE_BASECLASS("base_anim")

ENT.PrintName = "Combine Product"
ENT.Author = "Bloodmore"
ENT.Category = "Suppressed: Industrial Tech"

ENT.Spawnable = true
ENT.AdminOnly = true
ENT.AutomaticFrameAdvance = false
ENT.PhysgunPickupDisabled = false

local tProps = {
	"models/Items/battery.mdl"
}

function ENT:Initialize()
	if SERVER then
        self:SetModel(tProps[math.random(#tProps)])
		self:SetSkin(math.random(0, 4))
        self:SetMoveType(MOVETYPE_VPHYSICS)
        self:PhysicsInit(SOLID_VPHYSICS)
        self:SetSolid(SOLID_VPHYSICS)
		self:SetUseType(SIMPLE_USE)
		self:SetCollisionGroup(COLLISION_GROUP_PASSABLE_DOOR)

        local vPhys = self:GetPhysicsObject()
        if IsValid(vPhys) then
            vPhys:Wake()
        end

		self.HeldBy = nil
		self.iDeleteTime = CurTime() + 120
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

    if self.HeldBy and not IsValid(self.HeldBy) then
        self.HeldBy = nil
    end

    if self.iDeleteTime <= CurTime() then
        SafeRemoveEntity(self)
        return
    end

    self:NextThink(CurTime() + 1)
    return true
end

function ENT:Draw()
	self:DrawModel()
end