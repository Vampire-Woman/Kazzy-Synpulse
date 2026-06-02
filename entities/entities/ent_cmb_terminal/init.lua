AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

-- =========================
-- INIT
-- =========================
function ENT:Initialize()

    self:SetModel("models/hls/alyxports/monitor_medium.mdl")

    -- physics setup
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    self:SetUseType(SIMPLE_USE)

    local phys = self:GetPhysicsObject()
    if IsValid(phys) then
        phys:Wake()
        phys:EnableMotion(false)
        phys:Sleep()
        phys:SetMass(1000)
    end

    timer.Simple(0, function()
        if not IsValid(self) then return end

        local lp = Entity(1)
        if not IsValid(lp) then return end

		local backDistance = 30

		local forward = self:GetForward()
		forward.z = 0
		forward:Normalize()

		self:SetPos(self:GetPos() - forward * backDistance)
        local ang = (lp:GetPos() - self:GetPos()):Angle()

        ang.p = 0
        ang.r = 0
        ang:RotateAroundAxis(ang:Up(), 180)

        self:SetAngles(ang)
    end)

    self.LoggedIn = false
    self.Page = 0
    self.Online = true

    if self.SetAlarmTimeEnd then
        self:SetAlarmTimeEnd(self:GetAlarmTimeEnd() or 0)
    end
end

-- =========================
-- ONLINE FLAG
-- =========================
function ENT:GetOnline()
    return self.Online
end

-- =========================
-- USE
-- =========================
function ENT:Use(activator, caller)
	if activator:IsPlayer() and activator:Alive() then
		net.Start("impulseATMOpen")
		net.Send(activator)

		activator.currentATM = self
	end
end

-- =========================
-- CLEANUP
-- =========================
function ENT:OnRemove()
end