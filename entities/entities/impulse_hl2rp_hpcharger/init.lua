AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

local CHARGER_SOUND_LOOP = "items/suitcharge1.wav"
local CHARGER_SOUND_USE = "items/medshot4.wav"
local CHARGER_SOUND_FAIL = "items/medshotno1.wav"
local VALID_TEAMS = {
    [TEAM_OTA] = true,
    [TEAM_CP] = true
}

function ENT:Initialize()
    self:SetModel("models/props_combine/health_charger001.mdl")
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    self:SetUseType(CONTINUOUS_USE)

    local physObj = self:GetPhysicsObject()

    if IsValid(physObj) then
        physObj:EnableMotion(false)
        physObj:Wake()
    end
    
    self.nextUseTime = CurTime()
    self.isInUse = false
    self.loopSound = nil
end

function ENT:OnTakeDamage()
    return false
end

function ENT:Use(ply)
    if self.nextUseTime > CurTime() then
        ply:EmitSound(Sound(CHARGER_SOUND_FAIL), 75, 100)
        return
    end
    
    if not VALID_TEAMS[ply:Team()] then
        ply:EmitSound(Sound(CHARGER_SOUND_FAIL), 75, 100)
        return
    end

    if self.isInUse then
        return
    end

    self.isInUse = true
    self:SetSequence(self:LookupSequence("active"))

    if not self.loopSound then
        self.loopSound = CreateSound(self, CHARGER_SOUND_LOOP)
        self.loopSound:Play()
    end

    timer.Create("HealthChargerTimer_" .. self:EntIndex(), 0.1, 0, function()
        if not IsValid(self) or not IsValid(ply) or not ply:KeyDown(IN_USE) then
            self:StopUsing(ply)
            return
        end

        if ply:Health() >= ply:GetMaxHealth() then
            ply:Notify("You are already at full health.")
            ply:EmitSound(Sound(CHARGER_SOUND_FAIL), 75, 100)
            self:StopUsing(ply)
            return
        end

        if ply:HasBrokenLegs() then
            ply:FixLegs()
            ply:Notify("Your broken legs have been healed by the bio-gel.")
        end

        local healthIncrease = 1
        local newHealth = math.min(ply:Health() + healthIncrease, ply:GetMaxHealth())
        ply:SetHealth(newHealth)
        ply:EmitSound(Sound(CHARGER_SOUND_USE), 25, 100)
    end)
end

function ENT:StopUsing(ply)
    if timer.Exists("HealthChargerTimer_" .. self:EntIndex()) then
        timer.Remove("HealthChargerTimer_" .. self:EntIndex())
    end
    self.isInUse = false
    self.nextUseTime = CurTime() + 2
    
    if self.loopSound then
        self.loopSound:Stop()
        self.loopSound = nil
    end
end

function ENT:OnRemove()
    if self.loopSound then
        self.loopSound:Stop()
    end
end