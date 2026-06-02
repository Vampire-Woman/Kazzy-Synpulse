AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

-- Define sounds once (outside functions)
local StartupSounds = {
    "ambient/levels/canals/headcrab_canister_ambient1.wav",
    "ambient/levels/canals/headcrab_canister_ambient2.wav",
    "ambient/levels/canals/headcrab_canister_ambient5.wav",
	"ambient/levels/canals/headcrab_canister_ambient6.wav",
    "ambient/levels/citadel/weapon_disintegrate1.wav",
    "ambient/machines/combine_terminal_idle1.wav",
	"ambient/machines/combine_terminal_idle2.wav"
}

local IdleLoopSound = "ambient/machines/combine_terminal_loop1.wav"

-- Precache sounds when the entity file loads
if SERVER then
    for _, snd in ipairs(StartupSounds) do
        util.PrecacheSound(snd)
    end

    util.PrecacheSound(IdleLoopSound)
end

function ENT:Initialize()
    self:SetModel("models/props_combine/combine_interface001.mdl")
    self:PhysicsInit(SOLID_VPHYSICS) 
    self:SetSolid(SOLID_VPHYSICS)
    self:SetUseType(SIMPLE_USE)

    -- Lower the spawn position slightly
    local pos = self:GetPos()
    self:SetPos(pos - Vector(0, 0, 10))

    local physObj = self:GetPhysicsObject()
    if IsValid(physObj) then
        physObj:EnableMotion(false)
        physObj:Wake()
    end

    -- Create looping idle sound (quiet)
    if SERVER then
        self.IdleSound = CreateSound(self, IdleLoopSound)
        if self.IdleSound then
            self.IdleSound:PlayEx(0.2, 100) -- quiet volume
        end
    end
end

function ENT:Use(_, ply)
    if not SERVER then return end
    if not IsValid(ply) or not ply:IsPlayer() then return end

    if ply:Team() == TEAM_CP or ply:Team() == TEAM_OTA then
        local snd = table.Random(StartupSounds)
        self:EmitSound(snd)
        
        ply:ForceSequence("Buttonfront")
		ply:ForceSequence("console_type")
        ply:OpenVGUI("CombineScreen")
    else
        self:EmitSound("buttons/combine_button_locked.wav")
    end
end

function ENT:OnRemove()
    if SERVER and self.IdleSound then
        self.IdleSound:Stop() -- instant stop, no fade
    end
end