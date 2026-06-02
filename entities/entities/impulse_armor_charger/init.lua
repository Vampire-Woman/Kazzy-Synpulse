AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.
include('shared.lua')

function ENT:Initialize()
    self:SetModel("models/props_combine/suit_charger001.mdl")

    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(SOLID_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    self:SetUseType(SIMPLE_USE)
    local physObj = self:GetPhysicsObject()

    self.delay = CurTime()

    if (IsValid(physObj)) then
        physObj:EnableMotion(false)
    end
end

function ENT:Use(activator, caller)
    if (not IsValid(caller) or not caller:IsPlayer()) then return end

    self.delay = self.delay or 0
    if (self.delay > CurTime()) then return end

    -- Must be OTA
    if (caller:Team() ~= TEAM_OTA) then
        caller:Notify("You must be an OTA unit to use this.")
        self.delay = CurTime() + 1
        return
    end

    -- Armour values by class
    local armour = 100 -- default fallback

    if (caller:GetTeamClass() == CLASS_ECHO) then
        armour = 100
    elseif (caller:GetTeamClass() == CLASS_MACE) then
        armour = 130
    elseif (caller:GetTeamClass() == CLASS_ELITE) then
        armour = 200
    end

    -- Already full armour
    if (caller:Armor() >= armour) then
        self:EmitBudgetSound("items/suitchargeno1.wav")
        self.delay = CurTime() + 1
        return
    end

    -- Recharge
    self:EmitBudgetSound("items/suitchargeok1.wav")
    caller:SetArmor(armour)

    self.delay = CurTime() + 3
end