AddCSLuaFile()

DEFINE_BASECLASS("base_anim")

ENT.PrintName = "Combine Fabricator"
ENT.Author = "Bloodmore"
ENT.Category = "Suppressed: Industrial Tech"

ENT.Spawnable = true
ENT.AdminOnly = true
ENT.AutomaticFrameAdvance = false
ENT.PhysgunPickupDisabled = false

-- Initialize the Fabricator
function ENT:Initialize()
    if SERVER then
        self:SetModel("models/synapse/props/fabricator.mdl")
        self:SetMoveType(MOVETYPE_VPHYSICS)
        self:PhysicsInit(SOLID_VPHYSICS)
        self:SetSolid(SOLID_VPHYSICS)
        self:SetUseType(SIMPLE_USE)
        self:SetTrigger(true)

        -- Rotate the model to face forward
        self:SetAngles(Angle(0, 180, 0)) -- Adjust Yaw (second number) as needed

        local phys = self:GetPhysicsObject()
        if IsValid(phys) then
            phys:EnableMotion(false)
        end
    end
end

-- Triggered when an entity touches the Fabricator
function ENT:StartTouch(ent)
    if not SERVER then return end
    if not IsValid(ent) then return end

    -- Only accept Combine Packages
    if ent:GetClass() ~= "ent_industrial_package" then return end

    -- Reward the player holding the package
    ent:RewardPlayers()

    -- Play a sound
    self:EmitSound("combine_tech/upgrade_station/combine_3d_printer_resin_tray_retract_01.wav", 65, math.random(95, 105))

    -- Remove the package
    SafeRemoveEntity(ent)
end

-- Draw the Fabricator
if CLIENT then
    function ENT:Draw()
        self:DrawModel()
    end
end