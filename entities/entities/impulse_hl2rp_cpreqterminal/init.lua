AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
    self:SetModel("models/props_combine/breenconsole.mdl")
    self:PhysicsInit(SOLID_VPHYSICS) 
    self:SetSolid(SOLID_VPHYSICS)
    self:SetUseType(SIMPLE_USE)

    local physObj = self:GetPhysicsObject()

    if ( IsValid(physObj) ) then
        physObj:EnableMotion(false)
        physObj:Wake()
    end
end

function ENT:Use(act, ply)
    local teamClass = ply:GetTeamClass() or 0
    
    if ply:Team() == TEAM_CP or ply:Team() == TEAM_CITIZEN then
        self:EmitSound("buttons/combine_button5.wav")
        ply:ForceSequence("Buttonfront")
        ply:OpenVGUI("cpLoadoutMenu")
    else
        self:EmitSound("buttons/combine_button_locked.wav")
    end
end