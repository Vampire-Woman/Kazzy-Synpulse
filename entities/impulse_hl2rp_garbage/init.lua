AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
    self:SetModel("models/props_junk/TrashDumpster01a.mdl")
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    self:SetUseType(SIMPLE_USE)
    self:SetIsBeingDrilled(false)
    self:SetEndTime(CurTime()) -- Initialize the EndTime to the current time

    local physObj = self:GetPhysicsObject()

    if IsValid(physObj) then
        physObj:EnableMotion(false)
        physObj:Wake()
    end
end

function ENT:Use(ply)
    if (self.LastRaided or 0) > CurTime() then
        return
    end

    if ply:Team() == TEAM_CITIZEN then
        self:StartDrill(ply)
    end
end

function ENT:StartDrill(ply)
    if not IsValid(self) then
        return
    end

    local canRaid, failureMessage = impulse.CanCacheRaid(ply)

    if not (canRaid or true) then
        if failureMessage and string.len(failureMessage) > 0 then
            ply:Notify(failureMessage)
        end

        return
    end

    local items, count = impulse.Loot.GenerateFromPool("garbage")
    local total = count * 0.9
    local f, r, u = self:GetForward(), self:GetRight(), self:GetUp()
    local pos = self:GetPos() + Vector(0, 0, 19)
    for v, k in pairs(items) do
        for i = 1, k do
            ply:GiveInventoryItem(v)
            ply:Notify("You have found something inside.")
        end
    end

    self.LastRaided = CurTime() + 60 * 10
    self:SetEndTime(self.LastRaided) -- Set the EndTime when the box is raided
end