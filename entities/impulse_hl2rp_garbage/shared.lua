ENT.Base = "base_gmodentity"
ENT.Type = "anim"
ENT.PrintName = "Dumpster"
ENT.Author = "Bloodmore"
ENT.Category = "Suppressed: Citizen Tech"
ENT.Spawnable = true
ENT.AdminOnly = true
ENT.bNoPersist = true

function ENT:SetupDataTables()
    self:NetworkVar("Bool", 0, "IsBeingDrilled")
    self:NetworkVar("Int", 0, "EndTime")
end

local material = Material("sprites/glow04_noz")
local buttonColor = Color(218, 165, 32) -- gold

function ENT:Draw()
    self:DrawModel()

    local position = self:GetPos()
    local f, r, u = self:GetForward(), self:GetRight(), self:GetUp()
    local pos1 = position + f * 0 - r * 0 + u * 0

    cam.Start3D()
    render.SetMaterial(material)

    if not self:GetIsBeingDrilled() and CurTime() >= self:GetEndTime() then
        render.DrawSprite(pos1, 32, 32, buttonColor)
    end

    cam.End3D()
end